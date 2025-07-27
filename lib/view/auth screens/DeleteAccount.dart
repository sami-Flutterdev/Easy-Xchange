import 'package:easy_xchange/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_xchange/view_model/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/auth%20screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String error = '';

  Future<void> _deleteUserData(String uid) async {
    try {
      // Delete posts
      QuerySnapshot postsSnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: uid)
          .get();
      for (DocumentSnapshot doc in postsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete other collections associated with the user here...

      // Finally, delete the user document
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception('Error deleting user data: $e');
    }
  }

  Future<void> _reauthenticateWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }

  Future<void> _deleteAccount(String password) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Reauthenticate based on the sign-in method
        if (userViewModel.isGoogleSignup) {
          await _reauthenticateWithGoogle();
        } else {
          await user.reauthenticateWithCredential(EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          ));
        }

        // Delete user account from Firebase Auth
        await user.delete();

        // Delete user data from Firestore
        await _deleteUserData(uid);

        // Sign out after deleting the account
        await _auth.signOut().then((value) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove("uid").then((value) {
            const WelcomeScreen().launch(context, isNewTask: true);
          });
        });
      } else {
        setState(() {
          error = 'No user is currently signed in.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error deleting account: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 360,
        width: double.infinity,
        child: isLoading
            ? Center(child: CustomLoadingIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userViewModel.isGoogleSignup == true
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.redColor,
                                  size: 60,
                                ),
                              )
                            : const SizedBox(),
                        text("Delete Account",
                            fontSize: 20.0, fontWeight: FontWeight.w500),
                        const SizedBox(
                          height: 4,
                        ).paddingTop(3),
                        text(
                          "Do you want to delete your account?",
                          color: AppColors.greyColor,
                          maxLine: 5,
                          isCentered: true,
                        ).paddingBottom(20),
                        const SizedBox(
                          height: 4,
                        ),
                        userViewModel.isGoogleSignup == true
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: "Confirm Password",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (error.isNotEmpty)
                          Text(
                            error,
                            style: const TextStyle(color: AppColors.redColor),
                          ).paddingSymmetric(horizontal: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: elevatedButton(
                            context,
                            onPress: () {
                              Navigator.pop(context);
                            },
                            height: 45.0,
                            borderRadius: 25.0,
                            backgroundColor: AppColors.whiteColor,
                            bodersideColor: AppColors.blackColor,
                            child: text("Cancel", fontSize: 14.0),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: elevatedButton(
                            context,
                            onPress: () async {
                              String password = _passwordController.text.trim();

                              if (userViewModel.isGoogleSignup != true) {
                                if (password.isEmpty) {
                                  setState(() {
                                    error = 'Please enter your password.';
                                  });
                                } else {
                                  await _deleteAccount(password);
                                }
                              } else {
                                await _deleteAccount(password);
                              }
                            },
                            height: 45.0,
                            borderRadius: 25.0,
                            backgroundColor: AppColors.redColor,
                            bodersideColor: AppColors.redColor,
                            child: text("Delete",
                                color: AppColors.whiteColor, fontSize: 14.0),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 10),
                  ),
                ],
              ),
      ),
    );
  }
}

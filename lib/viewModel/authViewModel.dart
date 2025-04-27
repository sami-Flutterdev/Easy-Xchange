import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/admin/dashbaord/main_screen_admin.dart';
import 'package:easy_xchange/view/auth%20screens/verifySignUp.dart';
import 'package:easy_xchange/view/auth%20screens/welcome_screen.dart';
import 'package:easy_xchange/view/user_app/dashbaord/dashboard.dart';
import 'package:easy_xchange/viewModel/userViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthViewModel with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  bool _passwordObsecure = true;
  final bool _isEmailVerified = false;
  bool _isLoading = false;

  bool get passwordObsecure => _passwordObsecure;
  bool get isEmailVerified => _isEmailVerified;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _passwordObsecure = !_passwordObsecure;
    notifyListeners();
  }

  Future<firebase_auth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      firebase_auth.UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      firebase_auth.User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await users.doc(user.uid).get();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("uid", user.uid);
        await prefs.setBool("isVerified", user.emailVerified);
        await prefs.setBool("isGoogle", true);

        if (!userDoc.exists) {
          await users.doc(user.uid).set({
            'id': user.uid,
            'username': user.displayName,
            'email': user.email,
            'gender': 'Male',
            'userImage': user.photoURL,
            'role': "user",
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  /// 🔹 SignUp with Email and Save Data to Firestore
  Future<void> signUpWithEmail(
      {required String name,
      required String email,
      required String password,
      required String cnicNo,
      File? imageFile,
      context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (_auth.currentUser!.uid.isNotEmpty) {
        print("User Created: ${_auth.currentUser!.uid}");
        // 🗂 Save Data to Firestore
        await users.doc(_auth.currentUser!.uid).set({
          'id': _auth.currentUser!.uid,
          'username': name.trim(),
          'email': email.trim(),
          'cnic': cnicNo.trim(),
          'userImage': '', // Default empty if no image
          'role': "user",
          'createdAt': FieldValue.serverTimestamp(),
        }).then(
          (value) {
            const VerifySignUp().launch(context);
          },
        );

        print("User Data Saved in Firestore");
      }
    } catch (e) {
      print("Signup Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Input validation (keep your existing checks)
      if (email.isEmpty) {
        throw "Please enter the email";
      } else if (!email.contains("@") || !email.contains(".")) {
        throw "Invalid Email";
      } else if (password.isEmpty) {
        throw "Password is not to be empty";
      }

      // 1. First check if user exists and is active in Firestore
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw "No user found with that email address.";
      }

      final userData = userQuery.docs.first.data();
      if (userData['isActive'] == false) {
        throw "Your account has been disabled. Please contact support.";
      }

      // 2. Proceed with Firebase authentication
      final userCredential = await firebase_auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var isVerified = userCredential.user!.emailVerified;
      prefs.setString("uid", userCredential.user!.uid);
      prefs.setBool("isVerified", isVerified);
      prefs.setBool("isgoogle", false);

      if (!isVerified) {
        _isLoading = false;
        notifyListeners();
        Fluttertoast.showToast(
            msg: "Please verify your email. Go to your Gmail.");
        await sendEmailVerification(userCredential.user!);
        return;
      }

      // 3. Get updated user data after successful auth
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userSnapshot.exists) {
        // Double-check isActive status (in case it changed during login)
        if ((userSnapshot.data() as Map<String, dynamic>)['isActive'] ==
            false) {
          await firebase_auth.FirebaseAuth.instance.signOut(); // Force logout
          throw "Your account has been disabled during login. Please contact support.";
        }

        _isLoading = false;
        notifyListeners();

        // Fetch user role from Firestore
        String userRole = userSnapshot['role'];

        // Save user role in SharedPreferences
        prefs.setString("userRole", userRole);

        // Navigate based on role
        if (userRole == 'user') {
          Dashboard().launch(context);
          Fluttertoast.showToast(
              msg: 'Congratulations! You have successfully logged in.');
        } else if (userRole == 'admin') {
          MainScreenAdmin().launch(context);
          Fluttertoast.showToast(
              msg: 'Congratulations! You have successfully logged in.');
        } else {
          throw "Unknown user role.";
        }
      } else {
        throw "User does not exist.";
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      if (e.code == 'user-not-found' || e.code.contains("no user record")) {
        throw "No user found with that email address.";
      } else if (e.code == 'wrong-password') {
        throw "Wrong password provided.";
      } else {
        throw e.message ?? "An error occurred. Please try again.";
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e.toString();
    }
  }

  Future<void> sendEmailVerification(firebase_auth.User user) async {
    await user.sendEmailVerification();
  }

  // Update a product
  Future<void> updateProfile({
    required String id,
    String? name,
    required BuildContext context,
  }) async {
    try {
      // Show Custom Loading Indicator
      showDialog(
        context: context,
        barrierDismissible:
            false, // User cannot close dialog by tapping outside
        builder: (context) {
          return Container(
            color: AppColors.blackColor.withOpacity(.2),
            child: CustomLoadingIndicator(),
          );
        },
      );

      // If a new image is provided, upload it to Supabase Storage
      String? imageUrl;
      var userViewModel = Provider.of<UserViewModel>(context, listen: false);
      if (userViewModel.selectedImage != null) {
        final file = userViewModel.selectedImage;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.Supabase.instance.client.storage
            .from('profile-pictures')
            .upload(fileName, file!);

        // Get the new image URL
        imageUrl = supabase.Supabase.instance.client.storage
            .from('profile-pictures')
            .getPublicUrl(fileName);
      }

      // Prepare the update data
      Map<String, dynamic> updateData = {};
      if (name != null) updateData['username'] = name;
      if (imageUrl != null) updateData['userImage'] = imageUrl;
      // Update the product in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update(updateData);

      Navigator.pop(context); // Close the loading dialog
      utils().toastMethod('profile updated successfully!');
      userViewModel.userRole == "user"
          ? Dashboard().launch(context, isNewTask: true)
          : MainScreenAdmin()
              .launch(context, isNewTask: true); // put dashbaord Admin here
      // getAllProducts(); // Refresh the product list
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      print('Error updating Profile: $e');
      utils().toastMethod('Error updating profile: ${e.toString()}');
    }
  }

  clearData(context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.userId = null;
    userViewModel.userRole = null;
  }

  Future<void> signOutGoogle(context) async {
    await signOut(context);
    await _auth.signOut();
    notifyListeners();
  }

  // Sign out
  Future signOut(context) async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomLoadingIndicator(),
    );
    try {
      await _auth.signOut().then((value) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        userViewModel.isVerified = false;
        prefs.remove("uid").then((value) {
          prefs.clear();
          clearData(context);
          WelcomeScreen().launch(context, isNewTask: true);
        });
      });
    } catch (e) {
      finish(context);
      debugPrint(e.toString());
    }
  }
}

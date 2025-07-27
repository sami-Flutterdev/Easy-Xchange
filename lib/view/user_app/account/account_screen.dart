import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/view/auth%20screens/DeleteAccount.dart';
import 'package:easy_xchange/view/auth%20screens/welcome_screen.dart'
    show WelcomeScreen;
import 'package:easy_xchange/view_model/userViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/view/auth%20screens/updateProfile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String username = '';
    var size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(FirebaseAuth.instance.currentUser?.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomLoadingIndicator();
            }

            if (!snapshot.hasData ||
                !snapshot.data!.exists ||
                snapshot.data!.data() == null) {
              // logout user
              FirebaseAuth.instance.signOut();

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Your account has been deleted. Logging out..."),
                    backgroundColor: Colors.red,
                  ),
                );
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.remove("uid").then((value) {
                  const WelcomeScreen().launch(context, isNewTask: true);
                });
              });

              return const Center(child: Text("Your account has been deleted"));
            }

            // Otherwise show account data
            final userData = snapshot.data!;
            username = userData['username'].toString();

            return Column(
              children: [
                Consumer<UserViewModel>(
                  builder: (context, value, child) => Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: size.width * .14,
                            backgroundColor: AppColors.primaryColor,
                            child: value.selectedImage == null
                                ? userData['userImage'] == null ||
                                        userData['userImage']!.isEmpty
                                    ? ClipOval(
                                        child: Image.asset(
                                          image_profile,
                                          height: size.width * .24,
                                          width: size.width * .24,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          userData['userImage'].toString(),
                                          height: size.width * .24,
                                          width: size.width * .24,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                : ClipOval(
                                    child: Image.file(
                                      value.selectedImage!,
                                      height: size.width * .24,
                                      width: size.width * .24,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          alignment: Alignment.center,
                          onPressed: () {
                            UpdateProfileScreen(
                              username: username,
                              id: FirebaseAuth.instance.currentUser!.uid,
                            ).launch(context);
                          },
                          icon: const Icon(Icons.edit_outlined),
                          color: whiteColor,
                          iconSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
                text(userData['username'].toString(),
                        fontSize: 18.0, fontWeight: FontWeight.w600)
                    .paddingTop(10),
                text(userData['email'].toString(),
                    fontSize: 11.0, color: AppColors.greyColor),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text("Personal Details",
                                fontSize: textSizeLargeMedium,
                                fontWeight: FontWeight.w600)
                            .paddingTop(spacing_thirty),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 24,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                color: const Color(0xff333333).withOpacity(.10),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              ProfileDetailContainer(
                                isContainer: false,
                                leadingIcon: Icons.email_outlined,
                                title: "Email",
                                subtitle: userData['email'].toString(),
                              ),
                              ProfileDetailContainer(
                                isContainer: false,
                                leadingIcon:
                                    Icons.admin_panel_settings_outlined,
                                title: "Role",
                                subtitle: userData['role'].toString(),
                              ),
                              ProfileDetailContainer(
                                isContainer: false,
                                leadingIcon: Icons.people_outline,
                                title: "CNIC",
                                subtitle: userData['cnic'] == ""
                                    ? "Add CNIC No via Edit Profile."
                                    : userData['cnic'],
                              ),
                              ProfileDetailContainer(
                                isContainer: false,
                                leadingIcon: Icons.how_to_reg_outlined,
                                title: "Created Date",
                                subtitle: formatDateTime(userData['createdAt']),
                              ),
                            ],
                          )
                              .paddingSymmetric(
                                  horizontal: spacing_standard_new)
                              .paddingOnly(bottom: spacing_standard_new),
                        ).paddingTop(spacing_middle),
                        ProfileDetailContainer(
                          ontap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const DeleteAccount();
                              },
                            );
                          },
                          iconColor: AppColors.redColor,
                          backgroundColor: AppColors.redColor,
                          leadingIcon: Icons.delete_outline_outlined,
                          title: "Delete Account",
                        ).paddingTop(spacing_standard_new),
                        const SizedBox(
                          height: spacing_thirty,
                        ),
                      ],
                    ).paddingAll(spacing_twinty),
                  ),
                ),
              ],
            );
          },
        ).paddingTop(40),
      ),
    );
  }
}

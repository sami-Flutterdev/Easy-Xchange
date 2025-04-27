import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/view/user_app/drawer/complaint_submission.dart';
import 'package:easy_xchange/view/user_app/helpFAQs/help_support.dart';
import 'package:easy_xchange/view/user_app/privacy_policy/privacy_policy_screen.dart';
import 'package:easy_xchange/view/user_app/termsCondition/termsConditionScreen.dart';
import 'package:easy_xchange/view/user_app/drawer/about_us.dart';
import 'package:easy_xchange/viewModel/userViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/view/auth%20screens/logOut.dart';
import 'package:easy_xchange/view/auth%20screens/updateProfile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String? address;

  Future<void> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        address =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    String username = '';
    var size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Drawer(
      width: size.width * .6,
      child: SafeArea(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomLoadingIndicator();
                } else if (snapshot.hasData) {
                  username = snapshot.data!['username'].toString();
                  return Column(
                    children: [
                      snapshot.data!['userImage'] == null ||
                              snapshot.data!['userImage']!.isEmpty
                          ? CircleAvatar(
                              radius: size.width * .14,
                              backgroundColor: AppColors.primaryColor,
                              child: ClipOval(
                                  child: Image.asset(
                                imageProfile,
                                height: size.width * .24,
                                width: size.width * .24,
                                fit: BoxFit.cover,
                              )),
                            )
                          : CircleAvatar(
                              radius: size.width * .14,
                              backgroundColor: AppColors.primaryColor,
                              child: ClipOval(
                                  child: Image.network(
                                snapshot.data!['userImage'].toString(),
                                height: size.width * .24,
                                width: size.width * .24,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    placeholderProfile,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )),
                            ),
                      text(snapshot.data!['username'].toString(),
                              fontSize: 18.0, fontWeight: FontWeight.w600)
                          .paddingTop(10),
                      text(snapshot.data!['email'].toString(),
                          fontSize: 11.0, color: Colors.grey),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Center(child: CustomLoadingIndicator()),
                    ],
                  );
                }
              },
            ).paddingTop(40),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    drawerRow(
                      icon: Icons.person_outline,
                      title: "Update Profile",
                      ontap: () {
                        UpdateProfileScreen(
                          username: username,
                          id: FirebaseAuth.instance.currentUser!.uid,
                        ).launch(context);
                      },
                    ),
                    drawerRow(
                      icon: Icons.group_outlined,
                      title: "About Us",
                      ontap: () {
                        AboutUsScreen().launch(context);
                      },
                    ),
                    drawerRow(
                      icon: Icons.security_outlined,
                      title: "Terms & Conditions",
                      ontap: () {
                        TermsConditionScreen().launch(context);
                      },
                    ),
                    drawerRow(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy & Policy",
                      ontap: () {
                        PrivacyPolicyScreen().launch(context);
                      },
                    ),
                    drawerRow(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      ontap: () {
                        const HelpSupportScreen().launch(context);
                      },
                    ),
                    userViewModel.userRole == 'user'
                        ? drawerRow(
                            icon: Icons.report_outlined,
                            title: "Complaint",
                            ontap: () {
                              ComplaintSubmissionScreen().launch(context);
                            },
                          )
                        : SizedBox(),
                    drawerRow(
                      icon: Icons.logout,
                      title: "Logout",
                      ontap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            // Delete Page (Dialog Box) is Called.............>>>
                            return const LogoutDialog();
                          },
                        );
                      },
                    ),
                  ],
                ).paddingAll(spacing_twinty),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class drawerRow extends StatelessWidget {
  IconData? icon;
  var title;
  VoidCallback? ontap;
  drawerRow({
    this.icon,
    this.title,
    this.ontap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: ontap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon).paddingRight(spacing_middle),
              text(title,
                  fontWeight: FontWeight.w400, fontSize: spacing_standard_new)
            ],
          ).paddingBottom(30),
        ),
      ],
    );
  }
}

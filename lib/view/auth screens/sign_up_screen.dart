import 'dart:io';

import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/viewModel/authViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/auth%20screens/login_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  var active1 = true;

  String imageUrl = '';
  File? logoImage;
  XFile? imageFile;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var conformPasswordController = TextEditingController();
  var cnicPasswordController = TextEditingController();

  final obSecurePassword = ValueNotifier(true);
  final obSecureConfromPassword = ValueNotifier(true);

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(
              logo,
              fit: BoxFit.contain,
              height: 120,
              width: 120,
            )).paddingTop(spacing_twinty),
            Center(
                    child: text("Create an Account",
                        isCentered: true,
                        color: black,
                        fontSize: textSizeNormal,
                        fontWeight: FontWeight.w700))
                .paddingTop(spacing_thirty),
            Center(
                child: text(
                        "Signup to continue your seamless money\n exchange experience",
                        maxLine: 5,
                        isCentered: true,
                        color: AppColors.textGreyColor)
                    .paddingTop(spacing_control)),
            text(
              fontSize: textSizeSMedium,
              "Name",
            ).paddingTop(spacing_twinty),
            CustomTextFormField(
              context,
              controller: nameController,
              hintText: "Please enter your full name",
            ).paddingTop(spacing_middle),
            text(
              fontSize: textSizeSMedium,
              "Email",
            ).paddingTop(spacing_middle),
            CustomTextFormField(
              context,
              controller: emailController,
              hintText: "Please enter the email",
              keyboardType: TextInputType.emailAddress,
            ).paddingTop(spacing_middle),
            text(
              fontSize: textSizeSMedium,
              "CNIC",
            ).paddingTop(spacing_middle),
            CustomTextFormField(
              context,
              controller: cnicPasswordController,
              hintText: "Please enter 13 digits of CNIC",
              keyboardType: TextInputType.number,
              maxLength: 13,
            ).paddingTop(spacing_middle),
            text(
              "Password",
              fontSize: textSizeSMedium,
            ),
            ValueListenableBuilder(
              valueListenable: obSecurePassword,
              builder: (context, value, child) => CustomTextFormField(
                context,
                controller: passwordController,
                obscureText: obSecurePassword.value,
                hintText: "Please Enter the password",
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: GestureDetector(
                        onTap: () {
                          obSecurePassword.value = !obSecurePassword.value;
                        },
                        child: Icon(obSecurePassword.value
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded))
                    .paddingRight(spacing_middle),
              ).paddingTop(spacing_middle),
            ),
            // text(
            //   fontSize: textSizeSMedium,
            //   "Conform Password",
            // ).paddingTop(spacing_middle),
            // ValueListenableBuilder(
            //   valueListenable: obSecureConfromPassword,
            //   builder: (context, value, child) => CustomTextFormField(
            //     context,
            //     controller: conformpasswordController,
            //     obscureText: obSecureConfromPassword.value,
            //     hintText: "Please confrom the password",
            //     keyboardType: TextInputType.visiblePassword,
            //     suffixIcon: GestureDetector(
            //             onTap: () {
            //               obSecureConfromPassword.value =
            //                   !obSecureConfromPassword.value;
            //             },
            //             child: Icon(obSecurePassword.value
            //                 ? Icons.visibility_off_rounded
            //                 : Icons.visibility_rounded))
            //         .paddingRight(spacing_middle),
            //   ).paddingTop(spacing_middle),
            // ),
            // const SizedBox(
            //   height: spacing_twinty,
            // ),
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                return elevatedButton(
                  loading: authViewModel.isLoading,
                  context,
                  width: double.infinity,
                  child: text("Sign Up", color: whiteColor),
                  onPress: () {
                    if (nameController.text.isEmpty) {
                      toast("Please enter your name", bgColor: redColor);
                    } else if (emailController.text.isEmpty ||
                        !emailController.text.contains("@")) {
                      toast("Invalid Email", bgColor: redColor);
                    } else if (passwordController.text.length < 6) {
                      toast("Password must be greater than 6 characters",
                          bgColor: redColor);
                    } else if (cnicPasswordController.text.isEmpty) {
                      toast("Please enter your CNIC Number", bgColor: redColor);
                    } else {
                      authViewModel.signUpWithEmail(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        cnicNo: cnicPasswordController.text,
                        context: context,
                      );
                    }
                  },
                ).paddingTop(40);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text(
                  "Already have an account?",
                  color: AppColors.greyColor,
                  fontSize: spacing_middle,
                ),
                TextButton(
                  child: text("login"),
                  onPressed: () {
                    const LoginScreen().launch(context);
                  },
                )
              ],
            )
          ],
        ).paddingAll(spacing_twinty),
      ),
    );
  }
}

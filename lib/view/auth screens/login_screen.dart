import 'dart:async';

import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/view/user_app/dashbaord/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/auth%20screens/forgotPassword.dart';
import 'package:easy_xchange/view/auth%20screens/sign_up_screen.dart';
import 'package:easy_xchange/view_model/authViewModel.dart';
import 'package:easy_xchange/view_model/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoading = false;
  //var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final obSecurePassword = ValueNotifier(true);

// New changes
  var active1 = true;
  Timer? timer;

  sendEmailVerification(currentUser) async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    Provider.of<UserViewModel>(context, listen: false).isVerified = currentUser;
    if (provider.isVerified == false) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future checkEmailVerified() async {
    var provider = Provider.of<UserViewModel>(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.currentUser!.reload();
    var isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    prefs.setBool("isVerified", isVerified);
    setState(() {});
    if (provider.isVerified) {
      timer?.cancel();
      Fluttertoast.showToast(msg: "email verified succefssfully login again");
    }
  } //////////////////////////

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    var authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.asset(
                      logo,
                      fit: BoxFit.contain,
                      height: 120,
                      width: 120,
                    )),
                    Center(
                            child: text("Log In To Your Account",
                                isCentered: true,
                                color: black,
                                fontSize: textSizeNormal,
                                fontWeight: FontWeight.w700))
                        .paddingTop(spacing_thirty),
                    Center(
                        child: text(
                                "Sign in to continue your seamless money\n exchange experience",
                                maxLine: 5,
                                isCentered: true,
                                color: AppColors.textGreyColor)
                            .paddingTop(spacing_middle)),
                    text(
                      "Email",
                      fontSize: textSizeSMedium,
                    ).paddingTop(spacing_thirty),
                    CustomTextFormField(
                      context,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      hintText: "Please enter your email",
                    ).paddingTop(spacing_middle),
                    text(
                      "Password",
                      fontSize: textSizeSMedium,
                    ).paddingTop(spacing_thirty),
                    ValueListenableBuilder(
                      valueListenable: obSecurePassword,
                      builder: (context, value, child) => CustomTextFormField(
                        context,
                        controller: passwordController,
                        obscureText: obSecurePassword.value,
                        suffixIcon: GestureDetector(
                                onTap: () {
                                  obSecurePassword.value =
                                      !obSecurePassword.value;
                                },
                                child: Icon(obSecurePassword.value
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded))
                            .paddingRight(spacing_middle),
                        hintText: "Please enter your Password",
                      ).paddingTop(spacing_middle),
                    ),
                    InkWell(
                      onTap: () {
                        ForgotPassword().launch(context);
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: text(
                            "ForgotPassword",
                            fontSize: textSizeSMedium,
                          )),
                    ).paddingTop(spacing_twinty),
                    const SizedBox(height: 20),
                    Consumer<AuthViewModel>(
                      builder: (context, authViewModel, child) {
                        return // Login Button
                            elevatedButton(
                          context,
                          loading: authViewModel.isLoading,
                          onPress: () async {
                            if (emailController.text.isEmpty) {
                              utils().toastMethod("Please enter the email",
                                  backgroundColor: AppColors.redColor);
                            } else if (!emailController.text.contains("@") ||
                                !emailController.text.contains(".")) {
                              utils().toastMethod("Invalid Email",
                                  backgroundColor: AppColors.redColor);
                            } else if (passwordController.text.isEmpty) {
                              utils().toastMethod("Password is not to be empty",
                                  backgroundColor: AppColors.redColor);
                            } else {
                              try {
                                await authViewModel.loginWithEmailPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  context: context,
                                );
                              } catch (e) {
                                utils().toastMethod(e.toString(),
                                    backgroundColor: AppColors.redColor);
                              }
                            }
                          },
                          width: double.infinity,
                          child: text(
                            'Login',
                            color: AppColors.whiteColor,
                          ),
                        ).paddingTop(spacing_twinty);
                      },
                    ),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                          thickness: 1,
                        )),
                        text("OR", fontWeight: FontWeight.w500)
                            .paddingSymmetric(horizontal: spacing_standard)
                            .center(),
                        const Expanded(
                            child: Divider(
                          thickness: 1,
                        )),
                      ],
                    ).paddingTop(spacing_xxLarge),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await authViewModel
                              .signInWithGoogle()
                              .then((value) async {
                            await Dashboard().launch(context, isNewTask: true);
                          }).onError((error, stackTrace) {
                            utils().toastMethod(error.toString());
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              svgGoogleLogo,
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                            text("Continue With Google",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)
                                .paddingLeft(10),
                          ],
                        ),
                      ),
                    ).paddingTop(spacing_twinty),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(
                          "Didn't have an account?",
                          color: AppColors.greyColor,
                          fontSize: spacing_middle,
                        ),
                        TextButton(
                          child: text("Sign Up"),
                          onPressed: () {
                            const SignUpScreen().launch(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

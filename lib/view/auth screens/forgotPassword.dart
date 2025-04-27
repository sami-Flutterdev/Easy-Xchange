import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/Constant.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/string.dart';
import 'package:easy_xchange/view/auth%20screens/login_screen.dart';

import 'package:nb_utils/nb_utils.dart';
import '../../utils/Widget.dart';

class ForgotPassword extends StatefulWidget {
  static String tag = '/GroceryForgotPassword';

  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool islooding = false;
  @override
  Widget build(BuildContext context) {
    final ForgotemailController = TextEditingController();
    final auth = FirebaseAuth.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    text(
                      ForgotPassword_text,
                      fontSize: textSizeLarge,
                    ).paddingOnly(
                        top: spacing_standard_new, right: spacing_standard_new),
                    text(
                      ForgotPassword_subtitle,
                      maxLine: 5,
                      color: AppColors.greyColor,
                      fontSize: textSizeMedium,
                    ).paddingTop(spacing_twinty),
                    const SizedBox(height: spacing_standard_new),
                    CustomTextFormField(
                      context,
                      // keyboardType: TextInputType.emailAddress,
                      controller: ForgotemailController,
                      obscureText: false,
                      hintText: "email",
                      prefixIcon: const Icon(Icons.email_outlined),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is Required';
                        } else if (!value.contains('@')) {
                          return "Enter a Valid Email,'@ 'is Required";
                        }
                        return null;
                      },
                    ).paddingTop(spacing_standard_new),
                    elevatedButton(
                      context,
                      loading: islooding,
                      onPress: () {
                        if (ForgotemailController.text.isEmpty) {
                          utils().toastMethod("Please enter email",
                              backgroundColor: AppColors.redColor);
                        } else {
                          setState(() {
                            islooding = true;
                          });
                          auth
                              .sendPasswordResetEmail(
                                  email: ForgotemailController.text
                                      .toString()
                                      .trim())
                              .then((value) {
                            setState(() {
                              islooding = false;
                            });
                            const LoginScreen().launch(context);
                            utils().toastMethod(
                                'We Have Sent Email Verification Code to your Email please check and Change your Password');
                          }).onError((error, stackTrace) {
                            setState(() {
                              islooding = false;
                            });
                            utils().toastMethod(error.toString(),
                                backgroundColor: AppColors.redColor);
                          });
                        }
                      },
                      width: double.infinity,
                      child: text(
                        ForgotPassword_SendCode,
                        color: AppColors.whiteColor,
                      ),
                    ).paddingTop(spacing_xlarge),
                  ],
                ).paddingSymmetric(horizontal: spacing_twinty),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
            },
            child: RichText(
                text: const TextSpan(
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: textSizeMedium,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                    text: ForgotPassword_Rememberpass,
                    children: [
                  TextSpan(
                      text: ForgotPassword_Login,
                      style: TextStyle(
                          color: AppColors.primaryColor, fontFamily: 'Poppins'))
                ])).center().paddingBottom(spacing_twinty),
          )
        ],
      ),
    );
  }
}

import 'package:easy_xchange/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/components/build_button.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/view/auth%20screens/login_screen.dart';
import 'package:easy_xchange/view/auth%20screens/sign_up_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_xchange/utils/widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  imageWelcome,
                  height: orientation == Orientation.portrait
                      ? MediaQuery.sizeOf(context).height * .3
                      : MediaQuery.sizeOf(context).height * .4,
                  width: orientation == Orientation.portrait
                      ? MediaQuery.sizeOf(context).width * 1
                      : MediaQuery.sizeOf(context).width * .8,
                ).paddingSymmetric(vertical: spacing_xxLarge),
                text("Welcome",
                        fontWeight: FontWeight.w500, fontSize: spacing_twinty)
                    .paddingBottom(spacing_middle),
                text("Have a better sharing experience",
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyColor,
                        fontSize: spacing_middle)
                    .paddingBottom(spacing_twinty),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  BuildButton(
                          onPressed: () {
                            const SignUpScreen().launch(context);
                          },
                          text: "Create an Account")
                      .paddingBottom(spacing_twinty),
                  GestureDetector(
                    onTap: () {
                      const LoginScreen().launch(context);
                    },
                    child: Container(
                      height: spacing_xxLarge,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(spacing_middle),
                          color: AppColors.whiteColor),
                      child: Center(
                          child: text("Log In",
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                              fontSize: spacing_middle)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ).paddingAll(spacing_twinty),
      ),
    );
  }
}

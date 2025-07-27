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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(imageWelcome,
                        height: MediaQuery.sizeOf(context).height * .36)
                    .paddingSymmetric(vertical: spacing_xxLarge),
                text("Welcome to EasyXchange",
                    fontWeight: FontWeight.w700, fontSize: 22.0),
                text("Easily exchange cash & e-money with trusted users — secure, hassle-free.",
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyColor,
                        isCentered: true,
                        fontSize: 12.0)
                    .paddingBottom(spacing_twinty),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  elevatedButton(
                    context,
                    onPress: () async {
                      const SignUpScreen().launch(context);
                    },
                    width: double.infinity,
                    child: text(
                      'Create an Account',
                      color: AppColors.whiteColor,
                    ),
                  ).paddingBottom(spacing_twinty),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        const LoginScreen().launch(context);
                      },
                      child: text(
                        "Log In",
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
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

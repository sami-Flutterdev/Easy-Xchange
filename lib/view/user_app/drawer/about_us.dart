import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("About Us",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mission Section
            text("Our Mission",
                    fontSize: textSizeLargeMedium,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor)
                .paddingOnly(
              top: spacing_standard,
              bottom: spacing_middle,
            ),

            text("Welcome to EasyXchange – a secure and user-friendly platform built to connect people for mutual exchange of e-money and cash.",
                    fontSize: spacing_standard_new,
                    color: AppColors.textprimaryColor,
                    maxLine: 10)
                .paddingBottom(spacing_middle),

            // Problem Statement
            text("The Challenge",
                    fontWeight: FontWeight.bold, color: AppColors.primaryColor)
                .paddingBottom(spacing_middle),

            text("In a time where digital wallets like EasyPaisa and JazzCash have transformed financial transactions, many users — especially in rural or underdeveloped areas — still face challenges when it comes to withdrawing physical cash. High service charges and the absence of official outlets make the process frustrating and expensive.",
                    fontSize: spacing_standard_new,
                    color: AppColors.textprimaryColor,
                    maxLine: 10)
                .paddingBottom(spacing_standard_new),

            // Solution
            text("Our Solution",
                    fontWeight: FontWeight.bold, color: AppColors.primaryColor)
                .paddingBottom(spacing_middle),

            text("EasyXchange offers a simple, commission-free solution: peer-to-peer exchange. Users who need cash can connect with others nearby who have it and want e-money — all within a 1-kilometer radius.",
                    fontSize: spacing_standard_new,
                    color: AppColors.textprimaryColor,
                    maxLine: 10)
                .paddingBottom(spacing_standard_new),

            // How It Works
            text("How It Works",
                    fontWeight: FontWeight.bold, color: AppColors.primaryColor)
                .paddingBottom(spacing_middle),

            Column(
              children: [
                buildBulletPoint("1. Find users nearby (within 1km radius)"),
                buildBulletPoint("2. Negotiate exchange terms directly"),
                buildBulletPoint("3. Meet securely to complete transactions"),
                buildBulletPoint("4. No platform fees or hidden charges"),
              ],
            ).paddingBottom(spacing_standard_new),

            // Disclaimer
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor2.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(spacing_middle),
              child: text(
                "Note: EasyXchange doesn't process payments or host listings. We enable secure communication between users to coordinate exchanges on their own terms.",
                fontSize: spacing_standard_new,
                maxLine: 10,
                color: AppColors.textprimaryColor,
              ),
            ).paddingBottom(spacing_standard_new),

            // Closing Statement
            text("At EasyXchange, we're committed to empowering communities through smarter, faster, and more reliable connections.",
                    fontSize: spacing_standard_new,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    maxLine: 10)
                .paddingBottom(spacing_thirty),
          ],
        ).paddingSymmetric(horizontal: spacing_standard_new),
      ),
    );
  }
}

Widget buildBulletPoint(String texttitle) {
  return Padding(
    padding: EdgeInsets.only(bottom: spacing_middle),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text("•", color: AppColors.primaryColor),
        SizedBox(width: spacing_middle),
        Expanded(
            child:
                text(texttitle, fontSize: spacing_standard_new, maxLine: 10)),
      ],
    ),
  );
}

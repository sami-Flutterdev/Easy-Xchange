import 'package:easy_xchange/view/user_app/drawer/about_us.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Privacy Policy',
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(
              'Your privacy matters to us. Here\'s how we protect it:',
              fontSize: textSizeLargeMedium,
              color: AppColors.textprimaryColor,
            ).paddingOnly(
              top: spacing_standard_new,
              bottom: spacing_twinty,
            ),
            buildBulletPoint(
                'We collect only the data necessary for your account and transactions'),
            buildBulletPoint(
                'We do not share your personal information with third parties without consent'),
            buildBulletPoint(
                'All communications and data are protected using secure encryption methods'),
            buildBulletPoint(
                'Users can update or delete their information anytime from their profile'),
            SizedBox(height: spacing_twinty),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2))),
              child: Column(
                children: [
                  text('Data We Collect',
                      fontSize: spacing_standard_new,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor),
                  SizedBox(height: spacing_middle),
                  text(
                    '• Contact Information (email, phone)\n'
                    '• Device Information (for security)\n'
                    '• Transaction History (for dispute resolution)\n'
                    '• Location Data (only during active sessions)',
                    fontSize: spacing_standard_new,
                    color: AppColors.textprimaryColor,
                  ),
                ],
              ),
            ).paddingBottom(spacing_twinty),
            text(
                'We respect your trust and are committed to protecting your digital privacy.',
                fontSize: spacing_standard_new,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                maxLine: 10),
            SizedBox(height: spacing_thirty),
            Padding(
              padding: EdgeInsets.all(spacing_standard_new),
              child: text(
                'Last Updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                fontSize: spacing_standard_new,
                color: AppColors.greyColor,
              ),
            ),
          ],
        ).paddingAll(spacing_standard_new),
      ),
    );
  }
}

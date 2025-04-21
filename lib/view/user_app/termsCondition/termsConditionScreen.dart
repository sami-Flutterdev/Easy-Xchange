import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Terms & Conditions',
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ExpansionSection(
              title: '1. Account Registration',
              content:
                  'By creating an account with EasyXchange, you agree to provide accurate and complete information. '
                  'You are responsible for maintaining the confidentiality of your account credentials.',
            ),
            ExpansionSection(
              title: '2. Transaction Responsibility',
              content:
                  'All peer-to-peer transactions are conducted directly between users. '
                  'EasyXchange acts only as a platform to facilitate connections and is not responsible for transaction disputes.',
            ),
            ExpansionSection(
              title: '3. Prohibited Activities',
              content:
                  'You agree not to use EasyXchange for any illegal activities including but not limited to money laundering, fraud, or terrorist financing. '
                  'Any suspicious activity will be reported to authorities.',
            ),
            ExpansionSection(
              title: '4. Location-Based Services',
              content:
                  'By using our location features, you consent to sharing your approximate location to facilitate nearby exchanges. '
                  'Location data is not stored after the session ends.',
            ),
            ExpansionSection(
              title: '5. Dispute Resolution',
              content:
                  'In case of transaction disputes, users should attempt to resolve issues amicably. '
                  'EasyXchange may provide mediation but has no obligation to resolve disputes.',
            ),
            ExpansionSection(
              title: '6. Limitation of Liability',
              content:
                  'EasyXchange shall not be liable for any direct, indirect, incidental, or consequential damages resulting from the use of our platform. '
                  'Users engage in transactions at their own risk.',
            ),
            ExpansionSection(
              title: '7. Privacy Policy',
              content:
                  'Your use of EasyXchange is subject to our Privacy Policy which governs our collection and use of your information. '
                  'We implement security measures but cannot guarantee absolute security.',
            ),
            ExpansionSection(
              title: '8. Platform Modifications',
              content:
                  'EasyXchange reserves the right to modify or discontinue any service feature without notice. '
                  'Continued use after changes constitutes acceptance of the modified terms.',
            ),
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

Widget ExpansionSection({required String title, required String content}) {
  return Card(
    margin: EdgeInsets.only(bottom: spacing_middle),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: spacing_standard_new),
      title: text(title,
          fontSize: spacing_standard_new,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor),
      children: [
        Padding(
          padding: EdgeInsets.all(spacing_standard_new),
          child: text(content,
              maxLine: 10,
              fontSize: spacing_standard_new,
              color: AppColors.textprimaryColor),
        ),
      ],
    ),
  );
}

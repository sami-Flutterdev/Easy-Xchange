import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/view/user_app/drawer/about_us.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  void openWhatsApp(phoneNumber) async {
    final Uri _url = Uri.parse('whatsapp://send?phone=$phoneNumber');
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  void makePhoneCall(phoneNumber) async {
    final Uri phoneUrl = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(phoneUrl)) throw 'Could not launch $phoneUrl ';
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'osama.codes01@gmail.com',
      query: _encodeQueryParameters({
        'subject': 'EasyXchange Support Request',
        'body': 'Hello EasyXchange team,\n\n',
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(
          emailLaunchUri,
          mode: LaunchMode.externalApplication, // YAHI jaruri hai
        );
      } else {
        utils().toastMethod(
          "Koi email app configured nahi hai",
          backgroundColor: AppColors.redColor,
        );
      }
    } catch (e) {
      utils().toastMethod(
        "Email launch nahi ho saka: ${e.toString()}",
        backgroundColor: AppColors.redColor,
      );
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Help & Support',
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            text('Need help? We\'re here for you!',
                    fontSize: spacing_standard_new,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor)
                .paddingOnly(
              top: spacing_standard_new,
              bottom: spacing_twinty,
            ),

            // Bullet Points
            buildBulletPoint(
                'For app issues, bugs, or feedback, contact our support team directly'),
            buildBulletPoint(
                'You can find frequently asked questions (FAQs) and solutions inside the support section'),
            buildBulletPoint('Our team responds within 24–48 hours'),

            SizedBox(height: spacing_twinty),

            _buildSupportCard(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'osama.codes01@gmail.com',
              onTap: _launchEmail,
            ),
            _buildSupportCard(
              icon: Icons.phone,
              title: 'Call Support',
              subtitle: '+92 334 0910486',
              onTap: () => makePhoneCall('+92 334 0910486'),
            ),

            _buildSupportCard(
              icon: Icons.chat,
              title: 'Live Chat',
              subtitle: 'Available 9AM-5PM',
              onTap: () => openWhatsApp("+92 334 0910486"),
            ),

            // FAQ Section
            text('FAQs',
                    fontSize: spacing_standard_new, fontWeight: FontWeight.w600)
                .paddingOnly(
              top: spacing_thirty,
              bottom: spacing_middle,
            ),

            // _buildFAQItem(
            //   question: 'How do I reset my password?',
            //   answer: 'Go to Profile > Settings > Change Password',
            // ),

            _buildFAQItem(
              question: 'What if I encounter a failed transaction?',
              answer: 'Contact support immediately with transaction details',
            ),

            _buildFAQItem(
              question: 'How to report a suspicious user?',
              answer:
                  'Tap the complaint tab in a Side bar and submit the report or contact us on email',
            ),

            // Closing Message
            text('Let us know how we can improve your experience.',
                    fontSize: spacing_standard_new,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500)
                .paddingOnly(
              top: spacing_thirty,
              bottom: spacing_thirty,
            ),
          ],
        ).paddingAll(spacing_standard_new),
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: spacing_middle),
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.greyColor.withOpacity(0.2))),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: text(title,
            fontSize: spacing_standard_new, fontWeight: FontWeight.w500),
        subtitle: text(subtitle,
            fontSize: spacing_standard_new, color: AppColors.greyColor),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: text(question,
          fontSize: spacing_standard_new, fontWeight: FontWeight.w500),
      children: [
        Padding(
          padding: EdgeInsets.all(spacing_standard_new),
          child: text(answer,
              fontSize: spacing_standard_new,
              color: AppColors.textcolorSecondary),
        ),
      ],
    );
  }
}

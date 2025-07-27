import 'package:easy_xchange/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/google_map/google_map_screen.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperDetails extends StatefulWidget {
  var userDetails;
  var postDetails;
  HelperDetails(
      {required this.userDetails, required this.postDetails, super.key});
//
  @override
  State<HelperDetails> createState() => _HelperDetailsState();
}

class _HelperDetailsState extends State<HelperDetails> {
  @override
  Widget build(BuildContext context) {
    void openWhatsApp(phoneNumber) async {
      final Uri url = Uri.parse('whatsapp://send?phone=$phoneNumber');
      if (!await launchUrl(url)) throw 'Could not launch $url';
    }

    void makePhoneCall(phoneNumber) async {
      final Uri phoneUrl = Uri.parse('tel:$phoneNumber');
      if (!await launchUrl(phoneUrl)) throw 'Could not launch $phoneUrl ';
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: [
            Center(
              child: Column(
                children: [
                  widget.userDetails['userImage'] == null ||
                          widget.userDetails['userImage']!.isEmpty
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
                            widget.userDetails['userImage'].toString(),
                            height: size.width * .24,
                            width: size.width * .24,
                            fit: BoxFit.cover,
                          )),
                        ),
                  text(widget.userDetails['username'].toString(),
                      fontWeight: FontWeight.bold, fontSize: spacing_twinty),
                  text(widget.userDetails['email'].toString()),
                ],
              ),
            ),
            Expanded(
                child: GoogleMapScreen(coordinates: [
              widget.postDetails['latitude'],
              widget.postDetails['longitude']
            ], isBottomNav: true, currentLocation: "Marchant Location")
                    .paddingTop(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                elevatedButton(context,
                        width: MediaQuery.sizeOf(context).width * .4,
                        onPress: () {
                  makePhoneCall("+92${widget.postDetails['whatsAppNo']}");
                }, child: text("Call", color: AppColors.whiteColor))
                    .paddingRight(spacing_middle),
                elevatedButton(context,
                        width: MediaQuery.sizeOf(context).width * .4,
                        onPress: () {
                  openWhatsApp("+92${widget.postDetails['whatsAppNo']}");
                }, child: text("WhatsApp", color: AppColors.whiteColor))
                    .paddingRight(spacing_middle),
              ],
            ).paddingSymmetric(vertical: spacing_twinty),
          ],
        ).paddingSymmetric(horizontal: 20));
  }
}

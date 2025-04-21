import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/constant.dart'
    show
        spacing_control,
        spacing_middle,
        spacing_thirty,
        spacing_twinty,
        textSizeLargeMedium;
import 'package:easy_xchange/view/user_app/dashbaord/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/components/textfield.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/viewModel/userViewModel.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../helper_details.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  var paymentType;
  var paymentSource;
  var isLoading = false;
  var addressController = TextEditingController();
  var descriptionController = TextEditingController();
  var whatsappNoController = TextEditingController();
  var amountController = TextEditingController();
  final locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: text("Post Your Post",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Type Dropdown
            text("Payment type", fontSize: 14.0),
            CustomDropdownButton(
              hint: "Choose one",
              value: paymentType,
              items: ['Cash to E-Money', 'E-Money to Cash'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: text(value,
                      color: AppColors.blackColor, fontWeight: FontWeight.w400),
                );
              }).toList(),
              onChanged: (value) {
                if (kDebugMode) {
                  print('Selected: $value');
                }
                setState(() {
                  paymentType = value;
                });
              },
            ).paddingOnly(top: spacing_middle, bottom: spacing_twinty),

            // Payment Source Dropdown
            text("Payment Source", fontSize: 14.0),
            CustomDropdownButton(
              hint: "Choose one",
              value: paymentSource,
              items: ['Jazz Cash', 'Easypaisa', "Upaisa", "Sada Pay"]
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: text(value,
                      color: AppColors.blackColor, fontWeight: FontWeight.w400),
                );
              }).toList(),
              onChanged: (value) {
                if (kDebugMode) {
                  print('Selected: $value');
                }
                setState(() {
                  paymentSource = value;
                });
              },
            ).paddingOnly(top: spacing_middle, bottom: spacing_twinty),
            text("Amount", fontSize: 14.0),

            CustomTextFormField(
              context,
              controller: amountController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              hintText: "Please enter your Amount",
            ).paddingTop(spacing_middle),
            text("Whatsapp No", fontSize: 14.0).paddingTop(spacing_twinty),
            CustomTextFormField(
              context,
              hintText: "3303333333",
              controller: whatsappNoController,
              filledColor: AppColors.filledColor,
              keyboardType: TextInputType.number,
              maxLength: 10,
            ).paddingTop(5),
            text("Description", fontSize: 14.0),
            CustomTextFormField(
              context,
              hintText: "Description",
              controller: descriptionController,
              filledColor: AppColors.filledColor,
              maxLines: 5,
              maxLength: 120,
            ).paddingTop(5),
            Consumer<UserViewModel>(
              builder: (context, value, child) =>
                  elevatedButton(context, onPress: () async {
                if (paymentType == null) {
                  utils().toastMethod("Please select the payment type",
                      backgroundColor: AppColors.redColor);
                } else if (paymentSource == null) {
                  utils().toastMethod("Please select the payment Source",
                      backgroundColor: AppColors.redColor);
                } else if (amountController.text.isEmpty) {
                  utils().toastMethod("Please enter amount",
                      backgroundColor: AppColors.redColor);
                } else if (whatsappNoController.text.isEmpty) {
                  utils().toastMethod(
                      "Please Enter 10 digits number without 0 ",
                      backgroundColor: AppColors.redColor);
                } else if (descriptionController.text.isEmpty) {
                  utils().toastMethod(
                      "Please Write Something About your Payments",
                      backgroundColor: AppColors.redColor);
                } else {
                  // Directly use the location from the userViewModel
                  if (value.currentLocation == null) {
                    utils().toastMethod(
                        "Error getting your location. Please try again.",
                        backgroundColor: AppColors.redColor);
                  }

                  value.createPost(
                      value.currentLocation!.latitude ?? 0.0,
                      value.currentLocation!.longitude ?? 0.0,
                      paymentType,
                      paymentSource,
                      amountController.text.toString().trim(),
                      descriptionController.text.toString().trim(),
                      whatsappNoController.text.trim().toInt(),
                      value.userId.toString(),
                      context);
                }
              }, child: text("Submit", color: AppColors.whiteColor))
                      .paddingTop(spacing_thirty),
            ),
          ],
        ).paddingAll(spacing_twinty),
      ),
    );
  }
}

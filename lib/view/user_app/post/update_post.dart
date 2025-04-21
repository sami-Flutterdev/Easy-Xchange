import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/components/textfield.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class UpdatePostScreen extends StatefulWidget {
  var postdata;
  UpdatePostScreen({required this.postdata, super.key});

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  var lat, lng;
  var paymentType;
  var paymentSource;
  var descriptionController = TextEditingController();
  var whatsappNoController = TextEditingController();
  var amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    paymentType = widget.postdata["paymentType"].toString();
    paymentSource = widget.postdata["paymentSource"].toString();
    descriptionController.text = widget.postdata["description"].toString();
    whatsappNoController.text = widget.postdata["whatsAppNo"].toString();
    descriptionController.text = widget.postdata["description"];
    amountController.text = widget.postdata["amount"].toString();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: text("Update Your Post",
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
              builder: (context, value, child) => elevatedButton(
                context,
                onPress: () async {
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
                        "Please Enter 10 digits number without 0",
                        backgroundColor: AppColors.redColor);
                  } else if (descriptionController.text.isEmpty) {
                    utils().toastMethod(
                        "Please Write Something About your Payments",
                        backgroundColor: AppColors.redColor);
                  } else {
                    value.updatePost(
                        context,
                        userViewModel.currentLocation!.latitude ?? 0.0,
                        userViewModel.currentLocation!.longitude ?? 0.0,
                        paymentType,
                        paymentSource,
                        amountController.text.toString().trim(),
                        descriptionController.text.toString().trim(),
                        whatsappNoController.text.trim().toInt(),
                        userViewModel.userId.toString(),
                        widget.postdata["_id"].toString());
                  }
                },
                child: text("Submit", color: AppColors.whiteColor),
              ).paddingTop(spacing_thirty),
            ),
          ],
        ).paddingAll(spacing_twinty),
      ),
    );
  }
}

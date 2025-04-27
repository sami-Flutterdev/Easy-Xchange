import 'dart:async';
import 'dart:io';

import 'package:easy_xchange/utils/Constant.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/viewModel/userViewModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLocationAndNavigate();
  }

  Future<void> checkLocationAndNavigate() async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);

    // Step 1: Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showLocationDialog();
      return;
    }

    // Step 2: Request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        showLocationDialog();
        return;
      }
    }

    // Step 3: Try getting location
    try {
      await userViewModel.getCurrentLocation();
      if (userViewModel.currentLocation != null) {
        // Location obtained, go ahead
        userViewModel.getUserTokens();
        userViewModel.isCheckLogin(context);
      } else {
        // Location is null, wait and retry
        Future.delayed(const Duration(seconds: 2), () {
          checkLocationAndNavigate(); // Retry
        });
      }
    } catch (e) {
      showLocationDialog();
    }
  }

  Future<void> showLocationDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: text(
          "Location Required",
          fontSize: textSizeLargeMedium,
          fontWeight: FontWeight.w600,
        ).center(),
        content: text(
          "To ensure the best experience, this app requires access to your location. "
          "Please enable location services to continue.",
          maxLine: 5,
          isCentered: true,
          fontSize: textSizeSMedium,
          fontWeight: FontWeight.w400,
          color: AppColors.textGreyColor,
        ),
        actions: [
          TextButton(
            onPressed: () => exit(0),
            child: text("Exit", color: AppColors.redColor),
          ),
          TextButton(
            onPressed: () async {
              bool isEnabledNow = await Geolocator.isLocationServiceEnabled();
              if (!isEnabledNow) {
                utils()
                    .toastMethod('Please enable location services to continue');
              } else {
                Navigator.of(ctx).pop();
                await checkLocationAndNavigate(); // Retry
              }
            },
            child: text("Try Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          logo,
          height: MediaQuery.sizeOf(context).height * .45,
          width: MediaQuery.sizeOf(context).width * .45,
        ),
      ),
    );
  }
}

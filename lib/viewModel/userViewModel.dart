import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:easy_xchange/view/auth%20screens/login_screen.dart';
import 'package:easy_xchange/view/user_app/dashbaord/dashboard.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:provider/provider.dart';

class UserViewModel with ChangeNotifier {
  CollectionReference postCollection =
      FirebaseFirestore.instance.collection("posts");

  UserViewModel() {
    _init();
  }

  Future _init() async {
    await getCurrentLocation();
    await getUserTokens();
  }

  //Current coordinates//..........................................
  LocationData? currentLocation;

  // Get User Token...........................................................>>>
  String? userId;
  bool isGoogleSignup = false;
  var isVerified = false;
  String? userRole;

  getUserTokens() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString("uid");
    isGoogleSignup = sp.getBool("isgoogle") ?? false;
    isVerified = sp.getBool("isVerified") ?? false;
    userRole = sp.getString("userRole");

    notifyListeners();
  }

  isCheckLogin(context) async {
    var p = Provider.of<UserViewModel>(context, listen: false);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString("uid");
    isVerified = sp.getBool("isVerified") ?? false;
    userRole = sp.getString("userRole");

    if (kDebugMode) {
      print("userId: $userId");
      print("isVerified: ${p.isVerified}");
    }
    userId == null || userId!.isEmpty || isVerified != true
        ? const LoginScreen().launch(context)
        : const Dashboard().launch(context);
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
      notifyListeners();
    });
  }

// Location getLocationAndShowDialog
  Future<void> getLocationAndShowDialog(context) async {
    Position position = await Geolocator.getCurrentPosition(
        // desiredAccuracy: LocationAccuracy.high,
        );
    notifyListeners();
  }

// Location premission
  Future getCurrentLocationPermission() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error("Location Service are disable");
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        notifyListeners();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print("Location Permission is Denied");
          }
          return Future.error("Location Permission is Denied");
        }
      }
    }
  }

  // Create post
  void createPost(
      double lat,
      double lng,
      String paymentType,
      String paymentSource,
      String amount,
      String description,
      int whatsAppNo,
      String userId,
      context) async {
    try {
      // Show Custom Loading Indicator
      showDialog(
        context: context,
        barrierDismissible:
            false, // User cannot close dialog by tapping outside
        builder: (context) {
          return Container(
            color: AppColors.blackColor.withOpacity(.2),
            child: CustomLoadingIndicator(),
          );
        },
      );
      // Store location data in GeoPoint format for better querying
      GeoPoint geoPoint = GeoPoint(lat, lng);

      // Add the post and get the document reference
      DocumentReference docRef = await postCollection.add({
        'paymentType': paymentType,
        'paymentSource': paymentSource,
        'latitude': lat,
        'longitude': lng,
        'location': geoPoint, // Add GeoPoint for easier querying
        'amount': amount,
        'description': description,
        'userId': userId,
        'whatsAppNo': whatsAppNo,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Retrieve the document ID
      var id = docRef.id;

      // Update the document with the ID in the _id field
      await docRef.update({'_id': id});
      Navigator.pop(context); // Close the loading dialog
      // Navigate to Dashboard and update the state
      const Dashboard().launch(context);
      debugPrint("Post ID: $id");
      utils().toastMethod("Your post has been successfully listed.");
    } catch (error) {
      // Handle errors
      Navigator.pop(context); // Close the loading dialog

      utils()
          .toastMethod(error.toString(), backgroundColor: AppColors.redColor);
    }
  }

// Update Post
  void updatePost(
      context,
      double lat,
      double lng,
      String paymentType,
      String paymentSource,
      String amount,
      String description,
      int whatsAppNo,
      String userId,
      String postId) async {
    // Creating a custom map to store latitude and longitude
    // Show Custom Loading Indicator
    showDialog(
      context: context,
      barrierDismissible: false, // User cannot close dialog by tapping outside
      builder: (context) {
        return Container(
          color: AppColors.blackColor.withOpacity(.2),
          child: CustomLoadingIndicator(),
        );
      },
    );
    GeoPoint geoPoint = GeoPoint(lat, lng);

    await postCollection.doc().update({
      'paymentType': paymentType,
      'paymentSource': paymentSource,
      'latitude': lat,
      'longitude': lng,
      'location': geoPoint, // Add GeoPoint for easier querying
      'amount': amount,
      'description': description,
      'userId': userId,
      'whatsAppNo': whatsAppNo,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      finish(context);
      utils().toastMethod("Your post has been successfully updated.");
    }).onError((error, stackTrace) {
      utils()
          .toastMethod(error.toString(), backgroundColor: AppColors.redColor);
      finish(context);
    });
  }

  // Image Picker ................................................
  File? selectedImage;
  Future getProductImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      utils().toastMethod("image picked");
      notifyListeners();
    } else {
      utils().toastMethod("image not picked");
    }
  }
}

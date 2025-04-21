import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:math';

import 'nearby_posts_calculation.dart';

class Cash_to_E_Money extends StatefulWidget {
  bool isAppbar = true;
  Cash_to_E_Money({required this.isAppbar, super.key});

  @override
  _Cash_to_E_MoneyState createState() => _Cash_to_E_MoneyState();
}

class _Cash_to_E_MoneyState extends State<Cash_to_E_Money> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Location _location = Location();
  bool _isLoading = true;
  List<Map<String, dynamic>> _posts = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          setState(() {
            _isLoading = false;
            _error = 'Location services are disabled.';
          });
          return;
        }
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          setState(() {
            _isLoading = false;
            _error = 'Location permission denied.';
          });
          return;
        }
      }

      _locationData = await _location.getLocation();
      _queryPosts(_locationData.latitude!, _locationData.longitude!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error getting location: $e';
      });
    }
  }

  void _queryPosts(double lat, double lng) async {
    var collectionReference = _firestore.collection('posts');
    var snapshot = await collectionReference.get();
    List<Map<String, dynamic>> postsWithUserDetails = [];

    double radius = 1.0; // Radius in kilometers

    for (var document in snapshot.docs) {
      var postData = document.data();
      double postLat = postData['position']['latitude'];
      double postLng = postData['position']['longitude'];

      // Calculate the distance between the user's location and the post's location
      double distance = _calculateDistance(lat, lng, postLat, postLng);

      if (distance <= radius && postData['paymentType'] == "E-Money to Cash") {
        var userId = postData['userId'];

        // Fetch user details
        var userDoc = await _firestore.collection('users').doc(userId).get();
        var userData = userDoc.data();

        if (userData != null) {
          postsWithUserDetails.add({
            'post': postData,
            'user': userData,
          });
        }
      }
    }

    setState(() {
      _posts = postsWithUserDetails;
      _isLoading = false;
      if (_posts.isEmpty) {
        _error = 'No nearby posts found.';
      }
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0; // Earth radius in kilometers
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NearbyPostsScreen(
      isAppbar: widget.isAppbar,
      paymentTypeFilter: 'Cash to E-Money',
    ));
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/user_app/helper_details.dart';
import 'package:easy_xchange/view/user_app/post/post_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';

class NearbyPostsScreen extends StatefulWidget {
  final bool isAppbar;
  final String paymentTypeFilter; // Filter to show only specific payment types

  const NearbyPostsScreen(
      {required this.isAppbar,
      this.paymentTypeFilter = '', // Empty string means no filter
      Key? key})
      : super(key: key);

  @override
  _NearbyPostsScreenState createState() => _NearbyPostsScreenState();
}

class _NearbyPostsScreenState extends State<NearbyPostsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();
  bool _isLoading = true;
  List<Map<String, dynamic>> _posts = [];
  String _error = '';
  LocationData? _userLocation;

  // Default radius in kilometers
  double _radius = 1.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Check if location service is enabled
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

      // Check location permission
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

      // Get current location
      _userLocation = await _location.getLocation();

      // Query nearby posts once we have location
      _fetchNearbyPosts();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error getting location: $e';
      });
    }
  }

  void _fetchNearbyPosts() async {
    if (_userLocation == null ||
        _userLocation!.latitude == null ||
        _userLocation!.longitude == null) {
      setState(() {
        _isLoading = false;
        _error = 'Could not get your location.';
      });
      return;
    }

    try {
      // Query all posts from Firestore
      final QuerySnapshot postsSnapshot =
          await _firestore.collection('posts').get();
      List<Map<String, dynamic>> nearbyPosts = [];

      // Process each post
      for (var doc in postsSnapshot.docs) {
        Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;

        // Skip if payment type filter is set and doesn't match
        if (widget.paymentTypeFilter.isNotEmpty &&
            postData['paymentType'] != widget.paymentTypeFilter) {
          continue;
        }

        // Get post location coordinates
        double? postLat;
        double? postLng;

        if (postData.containsKey('position') &&
            postData['position'] is Map &&
            postData['position'].containsKey('latitude') &&
            postData['position'].containsKey('longitude')) {
          postLat = postData['position']['latitude'];
          postLng = postData['position']['longitude'];
        } else if (postData.containsKey('latitude') &&
            postData.containsKey('longitude')) {
          postLat = postData['latitude'];
          postLng = postData['longitude'];
        }

        // Skip posts without proper location data
        if (postLat == null || postLng == null) {
          continue;
        }

        // Calculate distance between user and post
        double distance = _calculateDistance(_userLocation!.latitude!,
            _userLocation!.longitude!, postLat, postLng);

        // Add post to list if within radius
        if (distance <= _radius) {
          // Get user data for this post
          try {
            String userId = postData['userId'];
            DocumentSnapshot userDoc =
                await _firestore.collection('users').doc(userId).get();

            if (userDoc.exists) {
              Map<String, dynamic> userData =
                  userDoc.data() as Map<String, dynamic>;

              // Add post with user data and distance
              nearbyPosts.add({
                'post': postData,
                'user': userData,
                'distance': distance.toStringAsFixed(2),
              });
            }
          } catch (e) {
            debugPrint('Error fetching user data: $e');
          }
        }
      }

      // Sort posts by distance (closest first)
      nearbyPosts.sort((a, b) {
        double distA = double.parse(a['distance']);
        double distB = double.parse(b['distance']);
        return distA.compareTo(distB);
      });

      setState(() {
        _posts = nearbyPosts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error fetching posts: $e';
      });
    }
  }

  // Calculate distance between two coordinates using Haversine formula
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
      appBar: widget.isAppbar
          ? AppBar(
              title: text(widget.paymentTypeFilter.isEmpty
                  ? 'Nearby Posts'
                  : widget.paymentTypeFilter),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _getCurrentLocation,
                ),
              ],
            )
          : null,
      body: _isLoading
          ? Center(child: CustomLoadingIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error),
                      ElevatedButton(
                        onPressed: _getCurrentLocation,
                        child: text('Try Again'),
                      ),
                    ],
                  ),
                )
              : _posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text('No nearby posts found within ${_radius}km.',
                              fontWeight: FontWeight.w600),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              text('Extend Radius')
                                  .paddingRight(spacing_standard_new),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InkWell(
                                        onTap: _radius > 1.1
                                            ? () {
                                                setState(() {
                                                  _radius = _radius -
                                                      1.0; // Increase search radius
                                                });
                                                _fetchNearbyPosts();
                                              }
                                            : null,
                                        child: Icon(
                                          Icons.remove,
                                          color: AppColors.whiteColor,
                                        )),
                                  ),
                                  text('${_radius - 1} km'),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InkWell(
                                        onTap: _radius <= 5.0
                                            ? () {
                                                setState(() {
                                                  _radius = _radius +
                                                      1.0; // Increase search radius
                                                });
                                                _fetchNearbyPosts();
                                              }
                                            : null,
                                        child: Icon(Icons.add,
                                            color: AppColors.whiteColor)),
                                  ),
                                ],
                              ),
                            ],
                          ).paddingTop(spacing_twinty),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: text(
                              'Found ${_posts.length} posts within ${_radius}km:',
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: spacing_middle,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _posts.length,
                            padding:
                                const EdgeInsets.only(bottom: spacing_middle),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var postData = _posts[index]['post'];
                              var userData = _posts[index]['user'];
                              var distance = _posts[index]['distance'];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HelperDetails(
                                        userDetails: userData,
                                        postDetails: postData,
                                      ),
                                    ),
                                  );
                                },
                                child: PostCard(
                                  title: '${userData['username'] ?? 'Unknown'}',
                                  createdAt: DateFormat('dd MMM yyyy, hh:mm a')
                                      .format(postData['timestamp'].toDate()),
                                  desc:
                                      '${postData['description'] ?? 'No description'}',
                                  type:
                                      'Payment Source: ${postData['paymentSource'] ?? 'Unknown'}',
                                  amount:
                                      'Amount: ${postData['amount'] ?? 'N/A'}',
                                  distance: '$distance km away',
                                ).paddingBottom(spacing_middle),
                              );
                            },
                          ),
                        )
                      ],
                    ).paddingAll(spacing_standard_new),
    );
  }
}

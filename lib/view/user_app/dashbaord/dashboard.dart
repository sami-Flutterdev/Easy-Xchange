import 'dart:io';

import 'package:easy_xchange/utils/Images.dart';
import 'package:easy_xchange/view/user_app/account/account_screen.dart';
import 'package:easy_xchange/view/user_app/dashbaord/home_screen.dart';
import 'package:easy_xchange/view/user_app/post/my_posts.dart';
import 'package:easy_xchange/view/user_app/post/your_post.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/view_model/userViewModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:easy_xchange/utils/widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getLocationAndShowDialog(context);
    userViewModel.getCurrentLocationPermission();
    userViewModel.getUserTokens();
    debugPrint("userid:${userViewModel.userId}");
    debugPrint("current location:${userViewModel.currentLocation}");
    debugPrint("isGoogleSignup:${userViewModel.isGoogleSignup}");
  }

  int currentIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const MyPosts(),
    YourPosts(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: SvgPicture.asset(svgHome,
                colorFilter:
                    ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                height: 25,
                width: 25,
                fit: BoxFit.cover),
            title: text("Home", color: AppColors.blackColor),
            selectedColor: AppColors.primaryColor,
          ),

          /// Exchange
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              svgPost,
              colorFilter:
                  ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
              height: 26,
              width: 26,
              fit: BoxFit.cover,
            ),
            title: text("Exchange", color: AppColors.blackColor),
            selectedColor: AppColors.primaryColor,
          ),

          /// chat
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              svgMyPost,
              colorFilter:
                  ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
              height: 25,
              width: 25,
              fit: BoxFit.cover,
            ),
            title: text("My Posts", color: AppColors.blackColor),
            selectedColor: AppColors.primaryColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              svgProfile,
              colorFilter:
                  ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
              height: 25,
              width: 25,
              fit: BoxFit.cover,
            ),
            title: text("profile", color: AppColors.blackColor),
            selectedColor: AppColors.primaryColor,
          ),
        ],
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          if (currentIndex != 0) {
            currentIndex = 0;
            setState(() {});
          } else {
            // Show exit confirmation dialog
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Exit the app?'),
                  content: const Text('Are you sure you want to exit the app?'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: text("NO")),
                    TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: text("Yes")),
                  ],
                );
              },
            );
          }
          return false;
        },
        child: PageView(
          children: [screens[currentIndex]],
        ),
      ),
    );
  }
}

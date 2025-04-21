import 'package:easy_xchange/utils/Images.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/view/user_app/drawer/drawer.dart';
import 'package:easy_xchange/view/user_app/near_posts/cash_to_E_Money.dart';
import 'package:easy_xchange/view/user_app/near_posts/e_Money_to_Cash.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/GoogleMap/googleMapScreen.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/viewModel/userViewModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:provider/provider.dart';

import '../post/post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // final tabbarlist = ["E-Money to Cash", "Cash to E-Money"];
  int selectedIndex = 0;
  Color defaultBorderColor = white;
  Color selectedBorderColor = AppColors.primaryColor;
  @override
  Widget build(BuildContext context) {
    // TabController control = TabController(length: 2, vsync: this);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const PostScreen().launch(context);
        },
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ).paddingBottom(MediaQuery.sizeOf(context).height * .1),
      drawer: const DrawerScreen(),
      appBar: AppBar(
        elevation: 0,
        title: text("Current Location",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                svgNotification,
                height: 20,
                width: 20,
              ).paddingRight(spacing_middle))
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer<UserViewModel>(
            builder: (context, userView, child) {
              return GoogleMapScreen(coordinates: [
                userView.currentLocation!.latitude,
                userView.currentLocation!.longitude
              ], isBottomNav: true, currentLocation: "Current Location");
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: MediaQuery.sizeOf(context).height * .09,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(spacing_middle),
                  border: Border.all(width: 2, color: AppColors.primaryColor)),
              child: Center(
                child: SizedBox(
                  height: spacing_xxLarge,
                  // width: spacing_middle0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: homeModel.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index; // Update selected index
                          });
                          homeModel[index].txt == "E-Money to Cash"
                              ? E_Money_to_Cash(
                                  isAppbar: true,
                                ).launch(context)
                              : Cash_to_E_Money(
                                  isAppbar: true,
                                ).launch(context);
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * .38,
                          // width: MediaQuery.sizeOf(context).width * .3,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: index == selectedIndex
                                    ? selectedBorderColor
                                    : defaultBorderColor,
                              ),
                              color: index == selectedIndex
                                  ? selectedBorderColor
                                  : defaultBorderColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Center(
                            child: text(homeModel[index].txt,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: textSizeMedium,
                                    color: index == selectedIndex
                                        ? defaultBorderColor
                                        : selectedBorderColor,
                                    fontWeight: FontWeight.w500)
                                .paddingAll(spacing_control),
                          ),
                        ).paddingLeft(spacing_middle),
                      );
                    },
                  ),
                ).paddingAll(spacing_middle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//model
class HomeModel {
  String? txt;
  HomeModel({this.txt});
}

final homeModel = [
  HomeModel(txt: "E-Money to Cash"),
  HomeModel(txt: "Cash to E-Money"),
];

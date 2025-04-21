import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/user_app/near_posts/cash_to_E_Money.dart';
import 'package:easy_xchange/view/user_app/near_posts/e_Money_to_Cash.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class GetAllPostScreen extends StatefulWidget {
  const GetAllPostScreen({super.key});

  @override
  State<GetAllPostScreen> createState() => _GetAllPostScreenState();
}

class _GetAllPostScreenState extends State<GetAllPostScreen>
    with TickerProviderStateMixin {
  final tabbarlist = ["E-Money to Cash", "Cash to E-Money"];
  @override
  Widget build(BuildContext context) {
    TabController control = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: text("All Posts",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
      ),
      body: Column(
        children: [
          DefaultTabController(
              length: tabbarlist.length,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(spacing_middle),
                        color: AppColors.primaryColor.withOpacity(.5)),
                    height: spacing_xxLarge,
                    child: TabBar(
                        onTap: (value) {
                          setState(() {});
                        },
                        dividerColor: Colors.transparent,
                        controller: control,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: const EdgeInsets.only(right: 6),
                        labelColor: AppColors.whiteColor,
                        unselectedLabelColor: AppColors.whiteColor,
                        indicatorColor: AppColors.primaryColor,
                        indicator: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tabs: [
                          text("E-Money to Cash", color: AppColors.whiteColor),
                          text("Cash to E-Money", color: AppColors.whiteColor),
                        ]),
                  )
                ],
              )).paddingSymmetric(vertical: 10, horizontal: 15),
          Expanded(
              child: TabBarView(controller: control, children: [
            E_Money_to_Cash(
              isAppbar: false,
            ),
            Cash_to_E_Money(
              isAppbar: false,
            ),
          ]))
        ],
      ),
    );
  }
}

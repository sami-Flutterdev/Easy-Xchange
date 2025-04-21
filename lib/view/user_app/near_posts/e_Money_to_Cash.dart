import 'package:flutter/material.dart';

import 'nearby_posts_calculation.dart';

class E_Money_to_Cash extends StatefulWidget {
  bool isAppbar = true;
  E_Money_to_Cash({required this.isAppbar, super.key});

  @override
  _E_Money_to_CashState createState() => _E_Money_to_CashState();
}

class _E_Money_to_CashState extends State<E_Money_to_Cash> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold( body: 
       NearbyPostsScreen(
      isAppbar:  widget.isAppbar,
      paymentTypeFilter: 'E-Money to Cash',
    ));
  }
}


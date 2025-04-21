// ignore_for_file: must_be_immutable

import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/colors.dart';

class BuildButton extends StatefulWidget {
  bool loading;
  var height, width;
  String? text;
  VoidCallback? onPressed;
  Color backgrounDColor;
  Color color;
  BuildButton({
    super.key,
    this.loading = false,
    this.height = spacing_xxLarge,
    this.width = double.infinity,
    this.color = Colors.white,
    this.backgrounDColor = AppColors.primaryColor,
    required this.onPressed,
    required this.text,
  });

  @override
  State<BuildButton> createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Set your desired radius here
            ),
            backgroundColor: widget.backgrounDColor,
          ),
          child: widget.loading
              ? Center(
                  child: CustomLoadingIndicator(),
                )
              : Text(
                  widget.text.toString(),
                  style: TextStyle(
                      color: widget.color,
                      fontSize: spacing_middle,
                      fontWeight: FontWeight.w500),
                )),
    );
  }
}

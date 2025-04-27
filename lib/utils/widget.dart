import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easy_xchange/utils/colors.dart';

import 'package:nb_utils/nb_utils.dart';

import 'Constant.dart';

// Elevated button .....................................>>>
// ignore: must_be_immutable
class elevatedButton extends StatelessWidget {
  VoidCallback? onPress;
  var isStroked = false;
  double? elevation;
  Widget? child;
  ValueChanged? onFocusChanged;
  Color backgroundColor;
  Color bodersideColor;
  var height;
  var width;
  var borderRadius;
  var loading;

  elevatedButton(
    BuildContext context, {
    super.key,
    this.loading = false,
    var this.isStroked = false,
    this.onFocusChanged,
    required var this.onPress,
    this.elevation,
    var this.child,
    var this.backgroundColor = AppColors.primaryColor,
    var this.bodersideColor = AppColors.primaryColor,
    var this.borderRadius = 30.0,
    var this.height = 55.0,
    var this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onFocusChange: onFocusChanged,
          onPressed: onPress,
          style: isStroked
              ? ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder())
              : ElevatedButton.styleFrom(
                  elevation: elevation,
                  side: BorderSide(color: bodersideColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius)),
                  backgroundColor: backgroundColor,
                ),
          child: loading
              ? CustomLoadingIndicator(
                  color: AppColors.whiteColor,
                )
              : child),
    );
  }
}

// Elevated button .....................................>>>Finished

class CustomDropdownButton extends StatelessWidget {
  final String hint;
  final List<DropdownMenuItem<String>>? items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  // final TextStyle textStyle;
  // final EdgeInsets padding;
  final String? value;

  const CustomDropdownButton({
    super.key,
    required this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    // required this.textStyle,
    // required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
                color: const Color(0xff000000).withOpacity(.1))
          ]),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          border: InputBorder.none,
        ),
        hint: text(hint,
            color: AppColors.textGreyColor, fontSize: textSizeSMedium),
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

//formatNumber ammout formatter
String ammoutFormatter(int number) {
  final formatter = NumberFormat('#,##0');
  return formatter.format(number);
}

// Function to format DateTime
String formatDateTime(dynamic timestamp) {
  if (timestamp == null) return 'Unknown date';

  try {
    if (timestamp is Timestamp) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());
    } else if (timestamp is String) {
      return timestamp; // Display as-is if it's already formatted
    }
    return 'Invalid date';
  } catch (e) {
    return 'Date format error';
  }
}

// Helper function to capitalize the first letter
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

// Text widget .....................................>>>Start
Widget text(String? text,
    {var fontSize = textSizeMedium,
    Color? color,
    bool isgoogleFonts = true,
    TextStyle? googleFonts,
    var fontFamily = 'Poppins',
    var isCentered = false,
    var maxLine = 10,
    TextOverflow? overflow,
    var latterSpacing = 0.5,
    bool textAllCaps = false,
    var isLongText = false,
    bool lineThrough = false,
    var fontWeight = FontWeight.w400}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : capitalizeFirstLetter(text!),
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: overflow,
    style: isgoogleFonts
        ? GoogleFonts.nunitoSans(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color ?? AppColors.blackColor,
            height: 1.5,
            letterSpacing: latterSpacing,
            decoration:
                lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
          )
        : TextStyle(
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: color ?? AppColors.textprimaryColor,
            height: 1.5,
            letterSpacing: latterSpacing,
            decoration:
                lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
          ),
  );
}

class utils {
  // toastMethod .....................
  void toastMethod(message,
      {backgroundColor = AppColors.primaryColor, color = Colors.white}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: backgroundColor,
        textColor: color,
        fontSize: 16.0);
  }

  // FormFocusChange.....................
  void formFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

// Text TextFromFeild...........................................>>>
class CustomTextFormField extends StatelessWidget {
  final VoidCallback? onPressed;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final ValueChanged<String>? onFieldSubmitted;

  final double height;
  final String? hintText;
  final Color filledColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final BorderSide? borderSide;
  final bool isPassword;
  final bool isSecure;
  final double fontSize;
  final Color color;
  final String? fontFamily;
  final String? text;
  final double suffixWidth;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  const CustomTextFormField(
    BuildContext context, {
    super.key,
    this.focusNode,
    this.onFieldSubmitted,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.minLines,
    this.onChanged,
    this.height = 80.0,
    this.onPressed,
    this.suffixWidth = 50.0,
    this.hintText,
    this.filledColor = Colors.white,
    this.prefixIcon,
    this.suffixIcon,
    this.borderSide,
    this.fontFamily,
    this.fontSize = 14.0,
    this.isPassword = false,
    this.isSecure = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.text,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          // height: height,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
                color: const Color(0xff000000).withOpacity(.1),
              ),
            ],
          ),
          child: TextFormField(
            maxLines: maxLines,
            maxLength: maxLength,
            focusNode: focusNode,
            minLines: minLines,
            keyboardType: keyboardType,
            onFieldSubmitted: onFieldSubmitted,
            controller: controller,
            obscureText: obscureText,
            onTap: onPressed,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0), // Text ke andar ka space kam karein
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              suffixIconConstraints: BoxConstraints(
                maxHeight: 30,
                maxWidth: suffixWidth,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                  fontSize: textSizeSMedium, color: AppColors.textGreyColor),
            ),
          ),
        ),
      ],
    );
  }
}

// Text TextFromFeild end...........................................>>>

// ProfileDetailContainer.........................>>>
// ignore: must_be_immutable
class ProfileDetailContainer extends StatelessWidget {
  IconData? leadingIcon;
  Color? iconColor;
  Color? backgroundColor;
  String? title;
  String? subtitle;
  bool isContainer;
  VoidCallback? ontap;
  ProfileDetailContainer(
      {super.key,
      this.leadingIcon,
      this.ontap,
      this.backgroundColor = AppColors.primaryColor,
      this.title,
      this.subtitle,
      this.iconColor = AppColors.primaryColor,
      this.isContainer = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: isContainer == true
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                    BoxShadow(
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                        color: const Color(0xff333333).withOpacity(.10))
                  ])
            : const BoxDecoration(),
        child: Padding(
          padding: isContainer == true
              ? const EdgeInsets.symmetric(
                  horizontal: spacing_standard_new, vertical: spacing_middle)
              : const EdgeInsets.only(top: spacing_standard_new),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: backgroundColor!.withOpacity(.3),
                child: IconButton(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    icon: Icon(
                      leadingIcon,
                      color: iconColor,
                      size: 18,
                    )),
              ),
              isContainer == true
                  ? Padding(
                      padding: const EdgeInsets.only(left: spacing_middle),
                      child:
                          text(title.toString(), fontWeight: FontWeight.w500),
                    )
                  : Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(title.toString(),
                              color: AppColors.textGreyColor,
                              fontWeight: FontWeight.w500),
                          text(subtitle.toString(),
                              overflow: TextOverflow.ellipsis,
                              fontSize: textSizeMedium,
                              fontWeight: FontWeight.w500),
                        ],
                      ).paddingLeft(spacing_middle),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

// Text TextFromFeild end...........................................>>>
// ignore: must_be_immutable
class CustomLoadingIndicator extends StatelessWidget {
  Color? color;
  CustomLoadingIndicator({
    this.color = AppColors.primaryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: color,
      size: 50,
    );
  }
}

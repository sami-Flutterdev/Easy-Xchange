// FormField
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class textField extends StatelessWidget {
  String? hint;
  var height;
  List<TextInputFormatter>? inputformater;
  int? maxlength;
  var counterText;
  Widget? prefix, suffix, suffixWidget, prefixWidget;
  bool obscures;
  int? minline, maxline;
  var keyboardtype, errortext;
  Widget? labell;
  Function(String)? onchanged;
  FormFieldValidator<String>? validator;
  TextEditingController? controller;
  textField({
    this.hint,
    this.labell,
    this.errortext,
    this.counterText,
    this.keyboardtype,
    this.inputformater,
    this.maxlength,
    this.controller,
    this.obscures = false,
    this.prefix,
    this.onchanged,
    this.minline,
    this.maxline,
    this.height = 55.0,
    this.prefixWidget,
    this.suffixWidget,
    this.suffix,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: TextFormField(
            keyboardType: keyboardtype,
            obscureText: obscures,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            obscuringCharacter: "*",
            onChanged: onchanged,
            controller: controller,
            validator: validator,
            minLines: minline,
            inputFormatters: inputformater,
            maxLength: maxlength,
            maxLines: maxline,
            decoration: InputDecoration(
              errorText: errortext,
              errorMaxLines: null,
              focusedErrorBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              counterText: counterText,
              suffixIcon: suffix,
              prefixIcon: prefix,
              label: labell,
              hintText: hint,
              suffix: suffixWidget,
              prefix: prefixWidget,
              fillColor: AppColors.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.greyColor),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.greyColor),
                  borderRadius: BorderRadius.circular(8)),
            ))).paddingOnly(top: spacing_middle);
  }
}

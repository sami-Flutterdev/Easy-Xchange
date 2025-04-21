// import 'package:flutter/material.dart';
// import 'package:easy_xchange/assets/colors.dart';
// import 'package:easy_xchange/assets/spacing.dart';
// import 'package:easy_xchange/assets/strings.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class textButton extends StatelessWidget {
//   VoidCallback? ontap;
//   String? text;
//   Color? color;

//   textButton({
//     this.ontap,
//     this.color = primaryColor,
//     this.text,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//         onPressed: ontap,
//         child: Text(
//           text.toString(),
//           style: TextStyle(
//               fontSize: spacing_middle,
//               color:AppColors. color,
//               fontWeight: FontWeight.w400,
//               fontFamily: font_montserrat),
//         ));
//   }
// }
////pin code field

// class PinCodeTextfield extends StatelessWidget {
//   const PinCodeTextfield({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PinCodeTextField(
//       appContext: context,
//       length: 5,
//       obscureText: false,
//       animationType: AnimationType.fade,
//       cursorcolor:AppColors. primaryColor,
//       pinTheme: PinTheme(
//         fieldHeight: 50,
//         fieldWidth: 40,
//         shape: PinCodeFieldShape.box,
//         activecolor:AppColors. primaryColor,
//         selectedcolor:AppColors. primaryColor,
//         borderWidth: 2,
//         inactivecolor:AppColors. grey_color,
//       ),
//     );
//   }
// }

// //text widget

// Widget text(text,
//     {var fontSize,
//     Color? color,
//     var fontFamily,
//     var isCentered = false,
//     var maxLine,
//     var decoration,
//     var overFlow,
//     TextAlign? align,
//     var latterSpacing = 0.5,
//     bool textAllCaps = false,
//     var isLongText = false,
//     bool lineThrough = false,
//     var fontWeight}) {
//   return Text(
//     textAllCaps ? text! : text!,
//     textAlign: align,
//     maxLines: isLongText ? null : maxLine,
//     overflow: overFlow,
//     style: TextStyle(
//       fontFamily: fontFamily,
//       fontWeight: fontWeight,
//       fontSize: fontSize,
//       color:AppColors. color ?? blackColor,
//       // height: 1.5,
//       letterSpacing: latterSpacing,
//       decoration: decoration,
//     ),
//   );
// }
// class utils {
//  // toastMethod .....................
//   void toastMethod(message,
//       {backgroundColor = Colors.black, color = Colors.white}) {
//     Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 2,
//         backgroundColor:AppColors. backgroundColor,
//         color:AppColors. color,
//         fontSize: 16.0);
//   }
// }
// // Elevated button .....................................>>>
// // ignore: must_be_immutable
// class elevatedButton extends StatelessWidget {
//   VoidCallback? onPress;
//   var isStroked = false;
//   double? elevation;
//   Widget? child;
//   ValueChanged? onFocusChanged;
//   Color backgroundColor;
//   Color bodersideColor;
//   var height;
//   var width;
//   var borderRadius;
//   var loading;

//   elevatedButton(
//     BuildContext context, {
//     Key? key,
//     this.loading = false,
//     var this.isStroked = false,
//     this.onFocusChanged,
//     required var this.onPress,
//     this.elevation,
//     var this.child,
//     var this.backgroundColor = primaryColor,
//     var this.bodersideColor = primaryColor,
//     var this.borderRadius = 10.0,
//     var this.height = 50.0,
//     var this.width = double.infinity,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: ElevatedButton(
//           onFocusChange: onFocusChanged,
//           onPressed: onPress,
//           style: isStroked
//               ? ElevatedButton.styleFrom(
//                   backgroundColor:AppColors. Colors.transparent,
//                   shape: const RoundedRectangleBorder())
//               : ElevatedButton.styleFrom(
//                   elevation: elevation,
//                   side: BorderSide(color:AppColors. bodersideColor),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(borderRadius)),
//                   backgroundColor:AppColors. backgroundColor,
//                 ),
//           child: loading
//               ? const CustomLoadingIndicator(
//                   color:AppColors. Colors.white,
//                   strokeWidth: 2,
//                 )
//               : child),
//     );
//   }
// }

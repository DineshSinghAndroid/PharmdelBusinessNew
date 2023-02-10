// import 'package:apna_slot/Controller/WidgetController/StringDefine/StringDefine.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class CustomDialogBox {
//
//   static showCustomDialogBox({
//     required CallbackFunction onPress,
//     required BuildContext context,
//     required String title,
//     required String message,
//     required String buttonTitle,
//     String? subText,
//     String? image,
//   }) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
// /*            insetPadding: EdgeInsets.symmetric(
//                 vertical: Get.height * 0.16, horizontal: 10),*/
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0)), //this right here
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               // height: 400,
//               // color: Colors.amberAccent,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   /// Close Button
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           icon: const Icon(
//                             Icons.close,
//                           )),
//                     ],
//                   ),
//
//                   ///Dialog Image
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 15.0),
//                     child: Image.asset(image ?? strImgIntro1),
//                   ),
//
//                   /// title
//                   Visibility(
//                       visible: true,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10.0, horizontal: 10),
//                             child: buildTextLoginStyle(
//                                 text: title ?? "Thanks For Contact with US !"),
//                           ),
//                         ],
//                       )),
//
//                   /// SubTitle
//                   Visibility(
//                       visible: false,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 10.0, horizontal: 10),
//                             child: buildTextStyle18(
//                                 text: subText ?? "Title",
//                                 color: CustomColors.blackColor),
//                           ),
//                         ],
//                       )),
//
//                   /// Message Text
//                   Visibility(
//                       visible: true,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 10, right: 5, bottom: 5),
//                             child: buildTextStyle16(
//                                 text: message,
//                                 color: Colors.black,
//                                 maxLine: 5,
//                                 textAlign: TextAlign.center),
//                           ),
//                         ],
//                       )),
//
//                   /// Button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 20.0),
//                     child: CustomButtonWithWidth(
//                       titleColor: CustomColors.whiteColor,
//                       title: buttonTitle,
//                       color1: CustomColors.blackColor,
//                       color2: CustomColors.blackColor,
//                       width: Get.width * 0.4,
//                       onPress: onPress,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
//
// typedef CallbackFunction = void Function();

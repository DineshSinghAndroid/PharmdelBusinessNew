import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Helper/ColorController/CustomColors.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../Helper/TextController/FontFamily/FontFamily.dart';
import '../Button/ButtonCustom.dart';
import '../StringDefine/StringDefine.dart';

class PopupCustom {
  static userLogoutPopUP({required BuildContext context}) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return const LogoutPopUP();
        }).then((value) {
      PrintLog.printLog("Value is: $value");
      if (value == true) {
        AppSharedPreferences.clearSharedPref().then((value) {
          // Get.offAllNamed(loginScreenRoute);
        });
      }
    });
  }

  static seatNotAvailablePopUP(
      {required Function(dynamic) onValue,
      required BuildContext context,
      required Function()? onTap,
      required String message}) {
    return showDialog(
      context: context,
      builder: (_) {
        return Container();
      },
    ).then(onValue);
  }
}

class LogoutPopUP extends StatelessWidget {
  const LogoutPopUP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blackColor.withOpacity(0.3),
      // body: DelayedDisplay(
      //   child: Center(
      //     child: Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: Container(
      //         // height: 280,
      //         decoration: BoxDecoration(
      //             color: CustomColors.whiteColor,
      //             borderRadius: BorderRadius.circular(10.0)
      //         ),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Container(
      //               height: 110,
      //               width: 110,
      //               margin: const EdgeInsets.only(top: 10),
      //               child: Image.asset(strImgLogout),
      //             ),
      //             BuildText.buildText(text: kNotAuthenticated,size: 25,fontFamily: FontFamily.josefinBold),
      //             Padding(
      //               padding: const EdgeInsets.all(10.0),
      //               child: Wrap(
      //                   alignment: WrapAlignment.center,
      //                   children: [
      //                     BuildText.buildText(text: kAuthenticatedDes,color: CustomColors.greyColor,size: 16),
      //                   ]
      //               ),
      //             ),
      //             buildSizeBox(20.0, 0.0),
      //             Padding(
      //               padding: const EdgeInsets.only(bottom: 20),
      //               child: InkWell(
      //                 onTap: () async {
      //                   AppSharedPreferences.clearSharedPref().then((value) {
      //                     // Get.offAllNamed(loginScreenRoute);
      //                   });
      //                 },
      //                 child: Container(
      //                   height: 45,
      //                   width: 120,
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(10.0),
      //                     color: CustomColors.redColor,
      //                   ),
      //                   child: Center(
      //                     child: BuildText.buildText(text: kOk,color: CustomColors.whiteColor,size: 20.0,fontFamily: FontFamily.josefinBold),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

// class CustomDialogBox extends StatefulWidget {
//   final String? title, descriptions, btnDone, btnNo;
//   final Image? img;
//   final Widget? closeIcon, descriptionWidget;
//   final Widget? textField;
//   final Widget? cameraIcon;
//   final Widget? button1;
//   final Widget? button2;
//   final OnClicked? onClicked;
//   final Icon? icon;

//   const CustomDialogBox({Key? key, this.icon, this.button1, this.button2, this.cameraIcon, this.textField, this.onClicked, this.title, this.descriptions, this.btnDone, this.img, this.btnNo, this.closeIcon, this.descriptionWidget}) : super(key: key);

//   @override
//   _CustomDialogBoxState createState() => _CustomDialogBoxState();
// }

// class _CustomDialogBoxState extends State<CustomDialogBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 0,
//       insetPadding: const EdgeInsets.all(20),
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }

//   contentBox(context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.only(left: 10, top: 45, right: 10, bottom: 20),
//           margin: const EdgeInsets.only(top: 45),
//           decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
//             BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
//           ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               if (widget.title != null)
//                 BuildText.buildText(
//                   text: widget.title!,
//                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//                 ),
//               if (widget.title != null)
//                 buildSizeBox(15.0, 0.0),
//               if (widget.descriptionWidget != null) widget.descriptionWidget!,
//               if (widget.descriptions != null)
//                 BuildText.buildText(
//                   text: widget.descriptions!,
//                   style: const TextStyle(fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               if (widget.descriptions != null || widget.descriptionWidget != null)
//                 buildSizeBox(22.0, 0.0),
//               if (widget.textField != null) widget.textField!,
//               if (widget.textField != null)
//                 buildSizeBox(10.0, 0.0),
//               if (widget.cameraIcon != null) widget.cameraIcon!,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (widget.button1 != null) widget.button1!,
//                   const Spacer(),
//                   if (widget.button2 != null) widget.button2!,
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (widget.btnNo != null)
//                     Align(
//                       alignment: Alignment.bottomLeft,
//                       child: TextButton(
//                           // color: widget.btnDone == "End Route" ? Colors.grey : Colors.transparent,
//                           style: TextButton.styleFrom(
//                             fixedSize: const Size.fromHeight(30),
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                             if (widget.onClicked != null) widget.onClicked!(false);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 0.0, right: 10),
//                             child: Text(
//                               widget.btnNo!,
//                               style: TextStyle(fontSize: 18, color: widget.btnNo == "Reoptimise stops" ? Colors.blueAccent : Colors.black),
//                               textAlign: TextAlign.start,
//                             ),
//                           )),
//                     ),
//                   const Spacer(),
//                   if (widget.btnDone != null)
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: TextButton(
//                           style: TextButton.styleFrom(
//                             fixedSize: const Size.fromHeight(30),
//                           ),
//                           onPressed: () {
//                             // stopWatchTimer.onResetTimer();
//                             // stopWatchTimer.onEnded();
//                             Get.back();
//                             if (widget.onClicked != null) widget.onClicked!(true);
//                           },
//                           child: BuildText.buildText(
//                             text: widget.btnDone!,
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: widget.btnDone == "End Route"
//                                     ? Colors.red
//                                     : widget.btnDone == "Skip"
//                                         ? Colors.orange
//                                         : Colors.black),
//                           )),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         if (widget.closeIcon != null) widget.closeIcon!,
//         if (widget.img != null || widget.icon != null)
//           Positioned(
//             left: 20,
//             right: 20,
//             child: CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 45,
//               child: SizedBox(
//                   width: 60,
//                   height: 60,
//                   child: widget.descriptions == kUploadingMsg || widget.descriptions == kuploadingMsg1
//                       ? const CircularProgressIndicator(
//                           value: null,
//                           strokeWidth: 3.0,
//                         )
//                       : widget.img != null
//                           ? widget.img
//                           : widget.icon),
//             ),
//           ),
//       ],
//     );
//   }
// }

class EnterMilesDialog extends StatelessWidget {
  const EnterMilesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.blackColor.withOpacity(0.3),
      body: DelayedDisplay(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20)),
              height: 320,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
                child: Column(
                  children: [
                    BuildText.buildText(
                        text: kEnterMiles, size: 16, weight: FontWeight.w400),
                    buildSizeBox(5.0, 0.0),
                    BuildText.buildText(text: 'and'),
                    buildSizeBox(5.0, 0.0),
                    BuildText.buildText(
                        text: kTakeSpdMtrPic,
                        size: 16,
                        weight: FontWeight.w400),
                    buildSizeBox(20.0, 0.0),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: kPlsEntStrmiles,
                            labelStyle: TextStyle(
                                color: AppColors.blueColor, fontSize: 15),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: AppColors.blueColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    BorderSide(color: AppColors.blueColor))),
                      ),
                    ),
                    buildSizeBox(10.0, 0.0),
                    Image.asset(
                      strIMG_SpeedoMeter,
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: BuildText.buildText(
                                text: kNo, weight: FontWeight.w700, size: 16)),
                        TextButton(
                            onPressed: () {},
                            child: BuildText.buildText(
                                text: kYes, weight: FontWeight.w700, size: 16))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationRouteStartDialog extends StatefulWidget {
  const ConfirmationRouteStartDialog({super.key});

  @override
  State<ConfirmationRouteStartDialog> createState() =>
      _ConfirmationRouteStartDialogState();
}

class _ConfirmationRouteStartDialogState
    extends State<ConfirmationRouteStartDialog> {
  int? selectRadioTile = 0;
  int? selectRadiotile2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.blackColor.withOpacity(0.3),
      body: DelayedDisplay(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.43,
                width: Get.width,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: AppColors.greyColor.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Center(
                        child: BuildText.buildText(
                            text: kStartroute, weight: FontWeight.w500),
                      ),
                    ),
                    buildSizeBox(10.0, 0.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildText.buildText(
                              text: kStartRouteFrom,
                              weight: FontWeight.w500),
                          buildSizeBox(5.0, 0.0),
                          //Start route Radio Tile
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: selectRadioTile == 0
                                    ? AppColors.blueColor.withOpacity(0.7)
                                    : AppColors.greyColor.withOpacity(0.3),
                                border: Border.all(
                                    width: 0.4, color: Colors.grey.shade300)),
                            child: RadioListTile(
                              title: BuildText.buildText(text: kPharmacy),
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              activeColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              value: 1,
                              groupValue: selectRadioTile,
                              onChanged: (value) {
                                selectRadioTile = value;
                              },
                            ),
                          ),
                          buildSizeBox(5.0, 0.0),
                          Container(                            
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: AppColors.blueColor.withOpacity(0.7),
                                border: Border.all(
                                    width: 0.4, color: Colors.grey.shade300)),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              title:
                                  BuildText.buildText(text: kCurrentLocation),
                              activeColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              value: 2,
                              groupValue: selectRadioTile,
                              onChanged: (value) {
                                setState(() {
                                  selectRadioTile = value;
                                });
                              },
                            ),
                          ),
                          buildSizeBox(10.0, 0.0),

                          ///End Route Radio Tile
                          BuildText.buildText(
                              text: kEndRouteFrom,
                              weight: FontWeight.w500),
                          buildSizeBox(5.0, 0.0),
                          //Start route Radio Tile
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: selectRadiotile2 == 0
                                    ? AppColors.blueColor.withOpacity(0.7)
                                    : AppColors.greyColor.withOpacity(0.3),
                                border: Border.all(
                                    width: 0.4, color: Colors.grey.shade300)),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              title: BuildText.buildText(text: kPharmacy),
                              activeColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              value: 1,
                              groupValue: selectRadiotile2,
                              onChanged: (value) {
                                selectRadiotile2 = value;
                              },
                            ),
                          ),
                          buildSizeBox(5.0, 0.0),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: AppColors.blueColor.withOpacity(0.7),
                                border: Border.all(
                                    width: 0.4, color: Colors.grey.shade300)),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              title: BuildText.buildText(text: kHomeLocation),
                              activeColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              value: 2,
                              groupValue: selectRadiotile2,
                              onChanged: (value) {
                                setState(() {
                                  selectRadiotile2 = value;
                                });
                              },
                            ),
                          ),
                          buildSizeBox(10.0, 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: BuildText.buildText(
                                      text: kCancel,
                                      color: AppColors.whiteColor,
                                      size: 13),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: BuildText.buildText(
                                      text: kContinue,
                                      color: AppColors.whiteColor,
                                      size: 13),
                                ),
                              ),
                            ],
                          )
                          //   Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start                        ,
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       ButtonCustom(
                          //       onPress: (){},
                          //       text: kCancel,
                          //       buttonHeight: 40,
                          //       buttonWidth: 100,
                          //       backgroundColor: AppColors.greyColor,
                          //       borderRadius: BorderRadius.circular(8),
                          // ),
                          //    ButtonCustom(
                          //       onPress: (){},
                          //       text: kCancel,
                          //       buttonHeight: 40,
                          //       buttonWidth: 100,
                          //       backgroundColor: AppColors.blueColor,
                          //       borderRadius: BorderRadius.circular(8),
                          // ),
                          //     ],
                          //   )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

typedef OnClicked = void Function(bool value);

class NumberList {
  String? number;
  int? index;

  NumberList({this.number, this.index});
}

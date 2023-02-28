import 'dart:io';

import 'package:camera/camera.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Helper/ColorController/CustomColors.dart';
import '../../Helper/ImagePicker/ImagePicker.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../StringDefine/StringDefine.dart';


class CustomPopUp{
   static Widget ReArrangeRoutePopUp({required BuildContext context}){
    return WillPopScope(
            onWillPop: () => Future.value(true),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              insetPadding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                       BoxShadow(
                          color: AppColors.blackColor,
                          offset: const Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(strGIF_processing),
                    BuildText.buildText(
                      text: "Processing...",
                      size: 22,
                      color: AppColors.redColor,
                      weight: FontWeight.w600,                      
                    ),
                    buildSizeBox(30.0, 0.0),
                    BuildText.buildText(
                      text: kOptimizingRouteMsg,
                      size: 16,
                      textAlign: TextAlign.center,                      
                    ),
                    buildSizeBox(25.0, 0.0),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  offset: const Offset(0, 3))
                            ],
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Center(
                            child: BuildText.buildText(
                              text: "Check Again",
                              color: AppColors.whiteColor,)
                                ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
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



class EnterMilesDialog extends StatefulWidget {
  const EnterMilesDialog({super.key});

  @override
  State<EnterMilesDialog> createState() => _EnterMilesDialogState();
}

class _EnterMilesDialogState extends State<EnterMilesDialog> {
  XFile? imageFile;
  String? profileImage;
  CameraController? controller;

  ImagePickerController? imagePicker = Get.put(ImagePickerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePickerController>(
      init: imagePicker,
      builder: (controller) {
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
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 40),
                    child: Column(
                      children: [
                        BuildText.buildText(
                            text: kEnterMiles,
                            size: 16,
                            weight: FontWeight.w400),
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
                                    borderSide: BorderSide(
                                        color: AppColors.blueColor))),
                          ),
                        ),
                        buildSizeBox(10.0, 0.0),
                        InkWell(
                            onTap: () {
                              getImage("Camera", context);
                            },
                            child: SizedBox(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                 borderRadius: BorderRadius.circular(50.0),
                                child: imagePicker?.profileImage != null ?
                                              Image.file(File(imagePicker?.profileImage?.path ?? ""),fit: BoxFit.fitWidth)
                                                  : profileImage != null && profileImage.toString() != "" ?
                                Image.asset(
                                      strIMG_SpeedoMeter,
                                       height: 70,
                                   ) : Container()
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: BuildText.buildText(
                                    text: "NO",
                                    weight: FontWeight.w700,
                                    size: 16)),
                            TextButton(
                                onPressed: () {},
                                child: BuildText.buildText(
                                    text: kYes,
                                    weight: FontWeight.w700,
                                    size: 16))
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
      },
    );
  }

  void getImage(source, BuildContext context) {
    imagePicker?.getImage(source, context, "profileImage");
  }

  //  Future<void> initCamera() async {
  //   List<CameraDescription> cameras = await availableCameras();
  //   controller = CameraController(cameras[0], ResolutionPreset.medium);
  //   await controller!.initialize();
  //   setState(() {});
  // }
  //   Future imageSelector(BuildContext context, String pickerType) async {
  //   switch (pickerType) {
  //     case "gallery":
  //       imageFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);
  //       break;
  //     case "camera":
  //       imageFile = await ImagePicker.platform.getImage(source: ImageSource.camera);
  //       break;
  //   }

  //   if (imageFile != null) {
  //     PrintLog.printLog("You selected  image : ${imageFile!.path}");
  //     setState(() {
  //       debugPrint("SELECTED IMAGE PICK   $imageFile");
  //     });
  //   } else {
  //     print("You have not taken image");
  //   }
  // }
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
                              text: kStartRouteFrom, weight: FontWeight.w500),
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
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              title: BuildText.buildText(text: kCurrentLocation),
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
                              text: kEndRouteFrom, weight: FontWeight.w500),
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

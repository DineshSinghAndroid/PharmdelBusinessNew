import 'dart:io';

import 'package:camera/camera.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Helper/ImagePicker/ImagePicker.dart';
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
  LogoutPopUP({super.key, required this.onTapCancel, required this.onTapOK});
  VoidCallback? onTapCancel;
  VoidCallback? onTapOK;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(klogout),
        content: const Text("Are you sure you want to logout"),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: onTapCancel
          ),
          TextButton(
            child: const Text(
              'YES',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: onTapOK
          )
        ],
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
          backgroundColor: AppColors.blackColor.withOpacity(0.3),
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
    imagePicker?.getImage(source: source, context: context, type: "profileImage");
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



///Notification Info Dialog
class NotificationInfo extends StatefulWidget {

  String? notificationName;
  String? type;
  String? userName;
  String? message;
  String? dateAdded;

  NotificationInfo({
    required this.notificationName,
    required this.type,
    required this.userName,
    required this.message,
    required this.dateAdded,
    });  

  @override
  State<NotificationInfo> createState() => _NotificationInfoState();
}

class _NotificationInfoState extends State<NotificationInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.blackColor.withOpacity(0.3),
      body: DelayedDisplay(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: Get.width,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(                  
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildText.buildText(
                            text: "Notification Info",
                            size: 20,
                            weight: FontWeight.bold,                            
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    buildSizeBox(10.0, 0.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child:                     
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildText.buildText(
                                text: 'Notification Name - ',
                                size: 15,
                                weight: FontWeight.w500,                                
                              ),
                              buildSizeBox(0.0, 5.0),
                              Flexible(
                                child: BuildText.buildText(text: widget.notificationName ?? ""),
                              ),
                            ],
                          ),
                          buildSizeBox(8.0, 0.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildText.buildText(
                                text: 'Type - ',
                                size: 15,
                                weight: FontWeight.w500,                                
                              ),
                              buildSizeBox(0.0, 5.0),
                              Flexible(
                                child: BuildText.buildText(text: widget.type ?? ""),
                              ),
                            ],
                          ),
                          buildSizeBox(8.0, 0.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildText.buildText(
                                text: 'User - ',
                                size: 15,
                                weight: FontWeight.w500,                                
                              ),
                              buildSizeBox(0.0, 5.0),
                              Flexible(
                                child: BuildText.buildText(text: widget.userName ?? ""),
                              ),
                            ],
                          ),
                          buildSizeBox(8.0, 0.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildText.buildText(
                                text: 'Message - ',
                                size: 15,
                                weight: FontWeight.w500,                                
                              ),
                              buildSizeBox(0.0, 5.0),
                              Flexible(
                                child: BuildText.buildText(text: widget.message ?? ""),
                              ),
                            ],
                          ),
                          buildSizeBox(8.0, 0.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildText.buildText(
                                text: 'Date - ',
                                size: 15,
                                weight: FontWeight.w500,                                
                              ),
                              buildSizeBox(0.0, 5.0),
                              Flexible(
                                child: BuildText.buildText(text: widget.dateAdded ?? ""),
                              ),
                            ],
                          ),
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


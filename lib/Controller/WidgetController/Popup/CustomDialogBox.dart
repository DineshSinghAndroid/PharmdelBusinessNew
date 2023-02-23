
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Helper/Colors/custom_color.dart';
import '../../Helper/StringDefine/StringDefine.dart';
import '../Button/ButtonCustom.dart';
import '../StringDefine/StringDefine.dart';


class CustomDialogBox {

  static showCustomDialogBox({
    required CallbackFunction onPress,
    required BuildContext context,
    required String title,
    required String message,
    required String buttonTitle,
    String? subText,
    String? image,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)), //this right here
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 250,
              width: Get.width - 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close,
                          )),
                    ],
                  ),

                  // ///Dialog Image
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 15.0),
                  //     child: SizedBox(
                  //         height: 220,
                  //         child: Image.asset(image ?? "")),
                  //   ),
                  // ),

                  /// title
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: BuildText.buildText(
                            text: title   ,
                            size: 25,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),

                  /// Message Text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 5),
                        child: BuildText.buildText(
                            text: message,
                            color: Colors.black.withOpacity(0.5),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),

                  /// SubTitle
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: BuildText.buildText(
                            text: subText ?? "SubTitle",
                            color: AppColors.blackColor),
                      ),
                    ],
                  ),
                  const Spacer(),
                  /// Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 47),
                    child: ButtonCustom(
                      onPress: onPress,
                      text: buttonTitle,
                      buttonHeight: 50,
                      buttonWidth: Get.width,
                      backgroundColor: AppColors.colorAccent,
                    )
                  ),
                ],
              ),
            ),
          );
        });
  }

static forgotPassDialog({
    required CallbackFunction onPress,
    required BuildContext context,
    required String title,
    required TextEditingController controller,

  }) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)), //this right here
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 330,
              width: Get.width - 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [                                                    
                  /// title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: BuildText.buildText(
                        text: title,
                        size: 16,
                        textAlign: TextAlign.center),
                  ),

              SizedBox(
                height: 50,
                width: Get.width,
                child: TextFormField(
                controller: controller,                                        
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: kemail,
                    labelStyle:
                        TextStyle(color: AppColors.greyColor, fontSize: 15),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: AppColors.greyColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: AppColors.greyColor))),
                          ),
              ),

                  /// Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.zero,
                            child: ButtonCustom(
                              onPress: (){
                                Get.back();
                              },
                              text: kCancel,
                              textColor: AppColors.greyColor,
                              buttonHeight: 40,
                              buttonWidth: Get.width,
                              backgroundColor: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        buildSizeBox(0.0, 15.0),
                        Flexible(
                          flex: 1,
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.zero,
                            child: ButtonCustom(
                              onPress: onPress,
                              text: kSubmit,
                              buttonHeight: 40,
                              buttonWidth: Get.width,
                              textColor: AppColors.colorAccent,
                              backgroundColor: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}


typedef CallbackFunction = void Function();

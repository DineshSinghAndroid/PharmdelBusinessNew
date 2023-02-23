
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';

import '../../Helper/Colors/custom_color.dart';
import '../Button/ButtonCustom.dart';


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
                  Visibility(
                      visible: title != null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: BuildText.buildText(
                                text: title,
                                size: 25,
                                textAlign: TextAlign.center),
                          ),
                        ],
                      )),

                  /// Message Text
                  Visibility(
                      visible: message != null,
                      child: Column(
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
                      )),

                  /// SubTitle
                  Visibility(
                      visible: subText != null,
                      child: Column(
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
                      )),
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
}

typedef CallbackFunction = void Function();

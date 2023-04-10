
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/Helper/Colors/custom_color.dart';
import '../../../Controller/Helper/TextController/BuildText/BuildText.dart';

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


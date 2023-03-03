import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class DeliveryCardCustom extends StatelessWidget {
  String? name;
  String? address;
  String? status;
  VoidCallback? onTap;

  DeliveryCardCustom({super.key,required this.address, required this.name, required this.onTap, required this.status});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: Get.width,
          margin: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    color: Colors.grey.shade300)
              ]),
          child: Stack(
            children: [
              Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.zero,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BuildText.buildText(
                                  text: name!,
                                  size: 14,
                                  weight: FontWeight.bold),
                              InkWell(
                                onTap: () {},
                                child: const Icon(Icons.more_vert),
                              )
                            ],
                          ),
                          buildSizeBox(10.0, 0.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: BuildText.buildText(
                                    text: address!,
                                    color: AppColors.greyColor),
                              ),
                              BuildText.buildText(
                                  text: status!,
                                  color: AppColors.blueColorLight,
                                  size: 12,
                                  weight: FontWeight.w600),
                            ],
                          )
                        ],
                      ))),
            ],
          )),
    );
  }
}

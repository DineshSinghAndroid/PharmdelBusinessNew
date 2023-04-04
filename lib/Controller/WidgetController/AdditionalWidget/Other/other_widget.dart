import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class WidgetCustom{
  WidgetCustom._privateConstructor();
  static final WidgetCustom instance = WidgetCustom._privateConstructor();


  static Widget drawerBtn({required Function() onTap,required String title, required IconData icon}){
    return ListTile(
        onTap: onTap,
        visualDensity: const VisualDensity(vertical: -1,horizontal: -4),
        leading: Icon(icon,size: 20),
        title:BuildText.buildText(text: title)
    );
  }
  static Widget drawerPersonalInfoWidget({String? title, required IconData icon}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon( icon,color: Colors.grey,size: 12,),
          buildSizeBox(0.0, 10.0),
          BuildText.buildText(text: title ?? kNotFound)
        ],
      ),
    );
  }

  static Widget driverDasTopSelectWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  color: Colors.grey.shade300
              )
            ]),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.blueColorLight,
                weight: FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }


  static Widget pharmacyTopSelectWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: AppColors.whiteColor),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.blackColor,
                weight: FontWeight.w400,
              ),
            ),
             Icon(
              Icons.arrow_drop_down,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }

  static Widget pharmacySelectStaffWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.greyColor),
            color: AppColors.whiteColor),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.greyColor,
                weight: FontWeight.w400,
              ),
            ),
             Icon(
              Icons.arrow_drop_down,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }

  static Widget selectDeliveryScheduleWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.greyColor),
            color: AppColors.whiteColor),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.greenDarkColor,
                weight: FontWeight.w400,
              ),
            ),
             Icon(
              Icons.arrow_drop_down,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
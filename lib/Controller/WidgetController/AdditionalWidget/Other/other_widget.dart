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
}
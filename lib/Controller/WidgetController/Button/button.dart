import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Helper/Colors/custom_color.dart';

class BtnCustom{

  static btnSmall({required String title,Color? titleColor,required Function() onPressed,double? fontSize}){
    return SizedBox(
        height: 35.0,
        width: 110.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          onPressed:onPressed,
          child: BuildText.buildText(
              text: title,style: TextStyle(color: titleColor ?? AppColors.greyColor,fontWeight:FontWeight.bold,fontSize: fontSize ?? 13.0 )
          ),
        ));
  }
}
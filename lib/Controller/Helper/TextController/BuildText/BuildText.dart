import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
 import '../../Colors/custom_color.dart';
import '../FontFamily/FontFamily.dart';

class BuildText{
  static Widget buildTextForSplash({required String text, required Color color}) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontFamily: FontFamily.NexaRegular,
          letterSpacing: 2.0,
          fontSize: 16.0),
    );
  }
  static Widget buildText({required
  String text,
    TextStyle? style,
    TextDecoration?decoration,
    String?fontFamily,
    double? size,
    FontWeight? weight,
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines}){
    return Text(
        text,
        style: style ?? TextStyle(
          fontFamily: fontFamily ?? FontFamily.NexaRegular,
          fontSize: size ?? 14,
          fontWeight: weight,
          color: color ?? AppColors.blackColor,
          decoration: decoration ?? TextDecoration.none,
        ),
        textAlign: textAlign ?? TextAlign.start,
        overflow: overflow,
        maxLines: maxLines,
    );
  }

  
}

Widget buildSizeBox(height,width){
  return SizedBox(height: height, width: width,);
}

Widget buildSizeBoxRatio({required double height,required double width}) {
  return SizedBox(
    height: Get.height * height.toDouble()/100,
    width:Get.width * width.toDouble()/100,
  );
}
double getHeightRatio({required double value}) {
  return Get.height * value.toDouble()/100;
}

double getWidthRatio({required double value}) {
  return Get.width * value.toDouble()/100;
}

import 'package:flutter/cupertino.dart';
import '../../ColorController/CustomColors.dart';
import '../FontFamily/FontFamily.dart';

class BuildText{
  static Widget buildTextForSplash({required String text, required Color color}) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontFamily: FontFamily.josefinRegular,
          letterSpacing: 2.0,
          fontSize: 16.0),
    );
  }
  static Widget buildText({required String text,TextDecoration? decoration,String? fontFamily,double? size,Color? color}){
    return Text(
        text,
        style: TextStyle(
          fontFamily: fontFamily ?? FontFamily.josefinRegular,
          fontSize: size ?? 14,
          color: color ?? CustomColors.blackColor,
          decoration: decoration ?? TextDecoration.none,
        )

    );
  }
}

Widget buildSizeBox(height,width){
  return SizedBox(height: height, width: width,);
}
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
  static Widget buildText({required
  String text,
    TextStyle? style,
    TextDecoration?decoration,
    String?fontFamily,
    double? size,
    FontWeight? weight,
    Color? color}){
    return Text(
        text,
        style: style ?? TextStyle(
          fontFamily: fontFamily ?? FontFamily.josefinRegular,
          fontSize: size ?? 14,
          fontWeight: weight,
          color: color ?? CustomColors.blackColor,
          decoration: decoration ?? TextDecoration.none,
        )

    );
  }
}

Widget buildSizeBox(height,width){
  return SizedBox(height: height, width: width,);
}
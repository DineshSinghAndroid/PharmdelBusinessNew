
import 'package:flutter/material.dart';

class CustomColors{
  static Color loaderColor = const Color(0xFF00008B);
  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color greyColor = const Color(0xFF9E9E9E);
  static Color blueLightColor = const Color(0xFFc797f7);
  static Color blackColor =  Colors.black;
  static Color redColor =  Colors.red;
  static Color transparentColor =  Colors.transparent;

  static Color textcolor = const Color(0xFF5F5F5);
  static LinearGradient buttonColor = const LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    stops: [
      0.2,
      0.9,
    ],
    colors: <Color>[
      Color(0xff4CEDE9),
      Color(0xffC3FBFF),
    ],
  );
}
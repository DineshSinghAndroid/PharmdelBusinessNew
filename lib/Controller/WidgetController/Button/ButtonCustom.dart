

import 'package:flutter/material.dart';

import '../../Helper/ColorController/CustomColors.dart';

class ButtonCustom extends MaterialButton{

  final CalbackFunction onPress;
  String text;
  double? textSize;
  double? buttonWidth;
  double? buttonHeight;
  double? radius;
  Color? backgroundColor;
  Color? textColor;
  bool? useBorder;
  BorderRadius? borderRadius;
  ButtonCustom({
    required this.onPress,
    required this.text,
    required this.buttonWidth,
    required this.buttonHeight,
    this.textSize,
    this.radius,
    this.textColor,
    this.backgroundColor,
    this.useBorder,
    this.borderRadius
  }) : super(onPressed: onPress);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      splashColor: Colors.black12.withOpacity(0.10),
      borderRadius: BorderRadius.circular(50.0),
      onTap: onPress,
      child: Ink(
        decoration: BoxDecoration(
          //color: Colors.buttoncolor,
          color: backgroundColor ?? CustomColors.blackColor,
          border: useBorder == true ? Border.all(color: CustomColors.blackColor) : null,
          borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius ?? 50.0)),
        ),
        child: Container(
          height: buttonHeight,
          width: buttonWidth,
          alignment: Alignment.center,
          child: Text(
            text,style: TextStyle(color: textColor ?? Colors.white,fontSize: textSize ??  buttonHeight! * 0.35),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

}

class ButtonCustomWithBorder extends MaterialButton{

  final CalbackFunction onPress;
  String text;
  double? textSize;
  double? buttonWidth;
  double? buttonHeight;
  double? radius;
  Color? backgroundColor;
  Color? textColor;
  bool? useBorder;
  ButtonCustomWithBorder({
    required this.onPress,
    required this.text,
    required this.buttonWidth,
    required this.buttonHeight,
    this.textSize,
    this.radius,
    this.textColor,
    this.backgroundColor,
    this.useBorder
  }) : super(onPressed: onPress);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      splashColor: Colors.black12.withOpacity(0.10),
      borderRadius: BorderRadius.circular(50.0),
      onTap: onPress,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                color: CustomColors.blackColor,
                width: 1.5),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Text(
          text,style: TextStyle(color: textColor ?? Colors.white,fontSize: textSize ??  buttonHeight! * 0.50),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

}

typedef CalbackFunction = void Function();

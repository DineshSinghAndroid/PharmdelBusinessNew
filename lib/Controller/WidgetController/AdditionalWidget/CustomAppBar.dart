import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Helper/TextController/FontFamily/FontFamily.dart';

class CustomAppBar{

  static AppBar appBar({bool? showBackBtn,Color? backgroundColor,bool? centerTitle,double? elevation,double? leadingWidth,String? title, Color? titleColor,double? fontSize,required onTap, Color? leadingColor}){
    return AppBar(
      toolbarHeight: 55,
      title: Text(title ?? '',style: TextStyle(color: titleColor ?? Colors.black,fontSize: fontSize ?? 20, fontFamily: FontFamily.NexaRegular)),
      leading:
          Visibility(
            visible: showBackBtn ?? true,
            child: InkWell(
              onTap: onTap,
              child: Container(
                  alignment: Alignment.center,
                  width: 40,

                  child: IconButton(onPressed: (){},icon: Icon(Icons.arrow_back),color: leadingColor ?? Colors.black,)
              ),
            ),
          ),


      leadingWidth: leadingWidth ?? 50,
      elevation: elevation ?? 0,
      centerTitle: centerTitle ?? false,
      backgroundColor: backgroundColor ?? Colors.white,
    );
  }
}


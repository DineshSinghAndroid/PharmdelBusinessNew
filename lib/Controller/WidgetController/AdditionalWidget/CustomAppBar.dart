import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../Helper/TextController/FontFamily/FontFamily.dart';

class CustomAppBar{

  static AppBar appBar({bool? showBackBtn,Color? backgroundColor,bool? centerTitle,double? elevation,double? leadingWidth,String? title, Color? titleColor,double? fontSize, Function()? onTap, Color? leadingColor}){
    return AppBar(
      toolbarHeight: 55,
      title: Text(title ?? '',style: TextStyle(color: titleColor ?? Colors.black,fontSize: fontSize ?? 20, fontFamily: FontFamily.NexaRegular)),
      leading:
          Visibility(
            visible: showBackBtn ?? true,
            child: Container(
                alignment: Alignment.center,
                width: 40,
                child: IconButton(onPressed: onTap,icon: const Icon(Icons.arrow_back),color: leadingColor ?? AppColors.blackColor,)
            ),
          ),


      leadingWidth: leadingWidth ?? 50,
      elevation: elevation ?? 0,
      centerTitle: centerTitle ?? false,
      backgroundColor: backgroundColor ?? AppColors.blackColor,
    );
  }
}


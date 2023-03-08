import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';

import '../../Helper/TextController/BuildText/BuildText.dart';

class AppBarCustom {
  AppBarCustom._privateConstructor();
  static final AppBarCustom instance = AppBarCustom._privateConstructor();

  static PreferredSizeWidget appBarStyle1({String? title,required Function() onTap}) {
    return AppBar(
      leading: InkWell(
          onTap: onTap,
          child: Container(
              width: 70,
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              color: AppColors.transparentColor,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )
          )
      ),
      title: BuildText.buildText(text:title ?? ""),
      centerTitle: true,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,

    );
  }


}
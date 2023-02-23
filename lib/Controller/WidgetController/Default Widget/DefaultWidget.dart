import 'package:flutter/material.dart';

import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';

class DefaultWidget {
  static Widget whiteBg() {
    return Container(
      color: Colors.white,
    );
  }


  static Widget customCountBox({ String? text,  double? height,  double? width,  Color? backgroundColor, String? count, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? (){},
      child: Card(
        elevation: 3,
        margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
                      alignment: Alignment.center,
                      height: height ?? 40,
                      width: width ?? 60,
                      decoration: BoxDecoration(
                        color: backgroundColor ?? AppColors.greyColor,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildText.buildText(text: text ?? "Total",color: AppColors.whiteColor,size: 10),
                          BuildText.buildText(text: count ?? "0",color: AppColors.whiteColor,size: 10),
                        ],
                      ),
                    ),
      ),
    );
  }

   static Widget topCounter({required Color bgColor,required String label,required String counter, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 1, right: 1, top: 8.0, bottom: 5),
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: bgColor,
            boxShadow: [
              BoxShadow(spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  color: Colors.grey.shade300)
            ]),
        child: Column(
          children: [
            BuildText.buildText(
              text: label,
              style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white),
            ),
            BuildText.buildText(
              text: counter,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
            ),
          ],
        ),
      ),
    );
}

}
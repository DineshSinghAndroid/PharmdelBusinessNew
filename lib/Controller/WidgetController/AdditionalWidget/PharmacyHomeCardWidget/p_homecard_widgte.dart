import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../../RouteController/RouteNames.dart';

class PharmacyHomeCardWidget extends StatelessWidget {
  
  String? title;
  String? image;
  Color? backgroundColor;  
  
  PharmacyHomeCardWidget({super.key, required this.title, required this.image, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
                  onTap: (){
                    Get.toNamed(trackOrderScreen);
                   },
                  child: Container(
                    height: Get.height / 6,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          image ?? strIMG_DelTruck,
                          height: 40,
                          width: 40,
                        ),
                        buildSizeBox(20.0, 0.0),
                        BuildText.buildText(text: title ?? 'Title',
                        color: AppColors.whiteColor,
                        size: 24,
                        weight: FontWeight.w400,)
                      ],
                    ),
                  ),
                );
  }
}
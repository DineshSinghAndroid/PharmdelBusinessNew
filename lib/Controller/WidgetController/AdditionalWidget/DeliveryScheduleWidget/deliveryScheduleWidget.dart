import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';

class DeliveryScheduleWidgets {
  static customWidget ({required Color bgColor, required String title, Color? titleColor, IconData? icon, Color? iconColor, required VoidCallback onTap}){
    return Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: onTap,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.greyColor)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(icon,color: iconColor ?? AppColors.blackColor,),
                              BuildText.buildText(text: title,color: titleColor ?? AppColors.blackColor),
                            ],
                          ),
                        ),
                      ),
                    );
  }

  static customWidgetwithCheckbox({required Color bgColor, required bool checkBoxValue, VoidCallback? onTap,required Function(bool?) onChanged, required Widget title}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,                    
        padding: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Checkbox(                          
              activeColor: AppColors.colorOrange,
              visualDensity: const VisualDensity(horizontal: -4),
              value: checkBoxValue, 
              onChanged: onChanged),
            title
          ],
        ),
      ),
    );
  }

    static customWidgetwithoutCheckbox({required Color bgColor,required String title, VoidCallback? onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,                    
        padding: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [            
            BuildText.buildText(text:title,color: AppColors.whiteColor)
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../StringDefine/StringDefine.dart';

class DefaultWidget {
  DefaultWidget._privateConstructor();
  static final DefaultWidget instance = DefaultWidget._privateConstructor();

  static Widget whiteBg() {
    return Container(
      color: Colors.white,
    );
  }

  static Widget selectionWidget({required bool isSelected, required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: Get.width,
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: isSelected ? Colors.blue[300] : Colors.grey[100],
            border: Border.all(width: 0.4, color: Colors.grey.withOpacity(0.3))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 20,width: 20,
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2,color: isSelected ? AppColors.whiteColor:AppColors.greyColorDark)
              ),

              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.whiteColor: AppColors.transparentColor
                ),
              ),
            ),
            BuildText.buildText(text: title,weight: FontWeight.w500)
          ],
        ),
      ),
    );
  }

  static Widget cdWidget({ String? text,  double? height,  double? width,  Color? backgroundColor, String? count, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: AppColors.drugColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
        child: BuildText.buildText(text: "C.D.",size: 10,color: AppColors.whiteColor),
      ),
    );
  }

  static Widget fridgeWidget({ String? text,  double? height,  double? width,  Color? backgroundColor, String? count, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: AppColors.fridgeColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
        child: BuildText.buildText(text: kFridge,size: 10,color: AppColors.whiteColor),
      ),
    );
  }

  static Widget cdWidgetWithCheckBox({required bool isSelected, required Function() onTap,required String title}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.drugColor
        ),
        alignment: Alignment.centerLeft,
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(width: 2,color: isSelected ? AppColors.yetToStartColor:AppColors.greyColorDark ),
                  color: isSelected ? AppColors.yetToStartColor:AppColors.transparentColor
                ),
                child: Visibility(
                  visible: isSelected,
                  child: const FittedBox(
                    child:  Icon(Icons.check,color: Colors.white),
                  ),
                ),
              ),

              BuildText.buildText(
                  text: title,
                  color: AppColors.whiteColor),
            ],
          ),
        ),
      ),
    );
  }

  static Widget fridgeWidgetWithCheckBox({required bool isSelected, required Function() onTap,required String title,Color? bgColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: bgColor ?? AppColors.fridgeColor
        ),
        alignment: Alignment.centerLeft,
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(width: 2,color: isSelected ? AppColors.yetToStartColor:AppColors.greyColorDark ),
                    color: isSelected ? AppColors.yetToStartColor:AppColors.transparentColor
                ),
                child: Center(
                  child: Visibility(
                    visible: isSelected,
                    child: const FittedBox(
                        child: Icon(Icons.check,color: Colors.white,)
                    ),
                  ),
                ),
              ),

              BuildText.buildText(
                  text: title,
                  color: AppColors.whiteColor),
            ],
          ),
        ),
      ),
    );
  }

  static Widget orderStatusChangeRadioBtnWidget({ required bool isSelected,required String title,required Function() onTap,required Color activeColor,required Color containerColor}) {
    return SizedBox(
      height: 30,
      child: InkWell(
        onTap:onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 2,color: isSelected ? activeColor:AppColors.greyColorDark
                )
              ),
              child: Visibility(
                visible: isSelected,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor
                  ),
                ),
              ),
            ),

            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: BuildText.buildText(
                    text: title,size: 15,color: AppColors.whiteColor
                )
            ),
            buildSizeBox(0.0, 20.0),

          ],
        ),
      ),
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

   static Widget topCounter({required Color bgColor,required String label,required String counter, required VoidCallback onTap,String? selectedTopBtnName}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 1, right: 1, top: 8.0, bottom: 5),
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 12.0, bottom: 12.0),
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
                  fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            BuildText.buildText(
              text: counter,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ),
      ),
    );
}

   static Widget squareButton({required Color bgColor,required String label, required VoidCallback onTap,String? selectedTopBtnName}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 1, right: 1, top: 8.0, bottom: 5),
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: bgColor,
            boxShadow: [
              BoxShadow(spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  color: Colors.grey.shade300)
            ]),
        child: Center(
          child: BuildText.buildText(
            text: label,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
}

/// For Delivery Screen
  static deliveryScheduleTopWidget ({required Color bgColor, required String title, Color? titleColor, IconData? icon, Color? iconColor, required VoidCallback onTap}){
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                visible: icon != null,
                  child: Icon(icon,color: iconColor ?? AppColors.blackColor,size: 20,)
              ),
              BuildText.buildText(text: title,color: titleColor ?? AppColors.blackColor,size: 16),
            ],
          ),
        ),
      ),
    );
  }

  static customWidgetWithCheckbox({required Color bgColor, required bool checkBoxValue, VoidCallback? onTap,required Function(bool?) onChanged, required Widget title}){
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

  static customWidgetWithoutCheckbox({required Color bgColor,required String title, VoidCallback? onTap}){
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

  static Widget searchMedicineWidget({required String medicineName,required String vtmName,required String packSize,required bool isCDShow,required Function() onTap}){
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      padding: const EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor,
            offset: const Offset(0.0, 1.0),
            blurRadius: 3.0,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText.buildText(
                          text: '${medicineName} ' + (vtmName != "" ? '(${vtmName})' : '')),
                      buildSizeBox(2.0, 0.0),
                      const Divider(height: 2.0,),
                      buildSizeBox(4.0, 0.0),
                      Row(
                        children: [
                          BuildText.buildText(
                            text: kPackSize,
                            weight: FontWeight.bold,
                          ),
                          BuildText.buildText(
                              text: packSize ?? ""),
                          buildSizeBox(0.0, 10.0),

                          isCDShow == true ?
                          Container(
                              padding: const EdgeInsets.only(right: 10, left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: AppColors.redColor,
                              ),
                              child: BuildText.buildText(
                                text: 'CD',
                                color: AppColors.whiteColor,
                              )) : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
                buildSizeBox(0.0, 4.0),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    width: 70,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF37879f),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: BuildText.buildText(
                        text: kSelect,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            buildSizeBox(0.0, 4.0),
          ],
        ),
      ),
    );
  }

  static Widget checkBoxWithWidget({required Function(bool?) onChanged,required Function() onTap,required bool isSelected,required Color bgColor,required String title}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 5),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              activeColor: AppColors.colorOrange,
              visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
              value: isSelected,
              onChanged: onChanged,
            ),
            title.toLowerCase() != kFridge.toLowerCase() ?
            BuildText.buildText(
                text: title,
                color: AppColors.whiteColor
            ):Padding(
              padding:const EdgeInsets.only(right: 12.0),
              child: Image.asset(
                strIMG_Fridge,
                height: 21,
                color: AppColors.whiteColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
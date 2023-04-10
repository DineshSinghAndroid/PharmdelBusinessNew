import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class WidgetCustom{
  WidgetCustom._privateConstructor();
  static final WidgetCustom instance = WidgetCustom._privateConstructor();


  static Widget drawerBtn({required Function() onTap,required String title, required IconData icon}){
    return ListTile(
        onTap: onTap,
        visualDensity: const VisualDensity(vertical: -1,horizontal: -4),
        leading: Icon(icon,size: 20),
        title:BuildText.buildText(text: title)
    );
  }
  static Widget drawerPersonalInfoWidget({String? title, required IconData icon}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon( icon,color: Colors.grey,size: 12,),
          buildSizeBox(0.0, 10.0),
          BuildText.buildText(text: title ?? kNotFound)
        ],
      ),
    );
  }

  static Widget driverDasTopSelectWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  color: Colors.grey.shade300
              )
            ]),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.blueColorLight,
                weight: FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }


<<<<<<< HEAD
  static PopupMenuItem popUpMenuItems({
    required BuildContext context,
    required bool isCheckedCD,
    required bool isCheckedFridge,
  }){
    return PopupMenuItem(
        enabled: true,
        height: 30.0,
        onTap: () {},
        child: StatefulBuilder(
          builder: ((context, setstat) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop("cd");
                  },
                  child: Container(
                    color: AppColors.redColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          activeColor: AppColors.colorOrange,
                          visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                          value: isCheckedCD,
                          onChanged: (newValue) {
                            Navigator.of(context).pop("cd");
                          },
                        ),
                        BuildText.buildText(
                            text: 'C. D.',
                            color: AppColors.whiteColor),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                  height: 25,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),),

                InkWell(
                  onTap: (){
                    Navigator.of(context).pop("fridge");
                  },
                  child: Container(
                    color: AppColors.blueColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          activeColor: AppColors.colorOrange,
                          visualDensity: const VisualDensity( horizontal: -4,vertical: -4),
                          value: isCheckedFridge,
                          onChanged: (newValue) {
                            Navigator.of(context).pop("fridge");
                          },
                        ),
                        Padding(
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
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.only(
                      left: 4.0, right: 4.0),
                  height: 25,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black)),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop("cancel");
                  },
                  child: Row(
                    mainAxisSize:MainAxisSize.min,
                    children: [
                      const Icon(Icons.cancel_outlined,
                      ),
                      buildSizeBox(0.0, 5.0),
                      BuildText.buildText(text: kCancel)
                    ],
                  ),
                )
              ],
            );
          }),
        )
    );
  }



=======
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
  static Widget pharmacyTopSelectWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: AppColors.whiteColor),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.blackColor,
                weight: FontWeight.w400,
              ),
            ),
<<<<<<< HEAD
            Icon(
=======
             Icon(
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
              Icons.arrow_drop_down,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }

  static Widget pharmacySelectStaffWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.greyColor),
            color: AppColors.whiteColor),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.greyColor,
                weight: FontWeight.w400,
              ),
            ),
<<<<<<< HEAD
            Icon(
=======
             Icon(
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
              Icons.arrow_drop_down,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }

  static Widget selectDeliveryScheduleWidget({required String title,required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.greyColor),
            color: AppColors.whiteColor),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: BuildText.buildText(
                text: title,
                size: 14,
                color: AppColors.greenDarkColor,
                weight: FontWeight.w500,
              ),
            ),
<<<<<<< HEAD
            Icon(
=======
             Icon(
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
              Icons.arrow_drop_down,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
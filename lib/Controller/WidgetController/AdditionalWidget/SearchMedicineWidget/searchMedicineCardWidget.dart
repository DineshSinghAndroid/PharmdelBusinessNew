import 'package:flutter/material.dart';

import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class SearchMedicineCardWidget extends StatelessWidget {
  String? medicineName;
  String? packSize;
  String? vtmName;
  VoidCallback? onTapSelect;
  bool isCDShow = false;  

   SearchMedicineCardWidget({
  super.key,
  required this.medicineName,
  required this.packSize,
  required this.vtmName,
  required this.onTapSelect,
  required this.isCDShow
    });

  @override
  Widget build(BuildContext context) {
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
                              text: '${medicineName} ' + (vtmName != null ? '(${vtmName})' : '')),
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
                        onTap: onTapSelect,
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
}
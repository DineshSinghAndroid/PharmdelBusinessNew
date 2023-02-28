import 'dart:math';
import 'package:flutter/material.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/StringDefine/StringDefine.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class PateintListWidget extends StatefulWidget {
  PateintListWidget({super.key,
  required this.context,
  required this.firstName, 
  required this.address,
  required this.middleName,
  required this.lastName,
  required this.dob,
  required this.onTap});

  BuildContext? context;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dob;
  String? address;
  VoidCallback? onTap;

  @override
  State<PateintListWidget> createState() => _PateintListWidgetState();
}

class _PateintListWidgetState extends State<PateintListWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 1, bottom: 0, left: 3, right: 3),
        child: Card(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      BuildText.buildText(text: "$kName :", size: 14, color: AppColors.greyColor,),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14.0,color: AppColors.blackColor,),
                            children:  [
                              TextSpan(text: widget.firstName,style: const TextStyle(fontSize: 14,color: Colors.black),),
                              TextSpan(text: widget.middleName,style: const TextStyle(fontSize: 14,color: Colors.black)),
                              TextSpan(text: widget.lastName,style: const TextStyle(fontSize: 14,color: Colors.black)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText.buildText(
                        text: "$kAddress :",
                        size: 14,
                        color: AppColors.greyColor),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: BuildText.buildText(
                                  text: widget.address!,
                                  textAlign: TextAlign.left),
                            ),
                            // if (list != null && list.isNotEmpty && list[index]['alt_address'] != null && list[index]['alt_address'] != "" && list[index]['alt_address'].toString() == "t")
                            Image.asset(
                              strIMG_AltAdd,
                              height: 18,
                              width: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      BuildText.buildText(
                        text: kDOB,
                        size: 14,
                        color: AppColors.greyColor,
                      ),
                      BuildText.buildText(
                        text: widget.dob!,
                        size: 14,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
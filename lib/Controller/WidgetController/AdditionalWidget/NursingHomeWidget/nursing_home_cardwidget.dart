import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';

import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class NursingHomeCardWidget extends StatefulWidget {
  String? customerName;
  String? leadingText;
  String? address;
  bool? isShowFridge;
  bool? isShowCD;
  bool? isCheckedCD;
  bool? isCheckedFridge;
  String? orderId;
  int index;

    NursingHomeCardWidget({
    required this.customerName,
    required this.index,
    required this.leadingText,
    required this.address,
    required this.isShowFridge,
    required this.isShowCD,
    required this.isCheckedFridge,
    required this.isCheckedCD,
    required this.orderId
   });

  @override
  State<NursingHomeCardWidget> createState() => _NursingHomeCardWidgetState();
}

class _NursingHomeCardWidgetState extends State<NursingHomeCardWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NursingHomeController>(
      builder: (controller) {
        return Container(                  
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
                color: Colors.grey.shade300)
          ]),
      child: Card(
        color: AppColors.whiteColor,        
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            child: BuildText.buildText(
                              text: widget.leadingText ?? "",
                              color: AppColors.blackColor,
                              size: 10,
                            ),
                            backgroundColor: AppColors.colorOrange,
                            radius: 8.0,
                          ),
                          buildSizeBox(0.0, 5.0),
                          Expanded(
                            child: BuildText.buildText(
                              text: widget.customerName ?? "",
                              color: AppColors.blackColor,
                              size: 14,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Row(                            
                            children: <Widget>[
                              widget.isShowFridge == true ?
                              Container(
                                  height: 25,
                                  padding: const EdgeInsets.only(
                                      right: 5.0, left: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: AppColors.blueColor,
                                  ),
                                  child: Center(
                                      child: Image.asset(
                                    strIMG_Fridge,
                                    height: 21,
                                    color: AppColors.whiteColor,
                                  ))) : const SizedBox.shrink(),
                              buildSizeBox(0.0, 10.0),
                              widget.isShowCD == true ?
                              Container(
                                height: 25,
                                padding:
                                    const EdgeInsets.only(right: 5.0, left: 5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: AppColors.redColor),
                                child: Center(
                                  child: BuildText.buildText(
                                    text: 'C.D.',
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ) : const SizedBox.shrink(),
                            ],
                          ),
                          buildSizeBox(0.0, 10.0),
                          PopupMenuButton(
                              padding: EdgeInsets.zero,
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.greyColor,
                              ),
                              itemBuilder: (_) => [
                                    PopupMenuItem(
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
                                                    setstat(() {
                                                     controller.onTapWidgetCD(index:widget.index,context: context);
                                                    });
                                                  },
                                                  child: Container(
                                                    color: AppColors.redColor,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Checkbox(
                                                          activeColor: AppColors.blackColor,
                                                          visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                                          value: widget.isCheckedCD,
                                                          onChanged: (newValue) {
                                                            setstat((){
                                                               controller.onTapWidgetCD(index:widget.index,context: context);
                                                            });
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
                                                  // onTap: () => controller.onTapWidgetFridge(index:widget.index,context: context),
                                                  onTap: (){
                                                    setstat(() {
                                                     controller.onTapWidgetFridge(index:widget.index,context: context);
                                                    });
                                                  },
                                                  child: Container(
                                                    color: AppColors.blueColor,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Checkbox(
                                                          activeColor: AppColors.blackColor,
                                                          visualDensity: const VisualDensity( horizontal: -4,vertical: -4),
                                                          value: widget.isCheckedFridge,
                                                          onChanged: (newValue) {
                                                            setstat((){
                                                               controller.onTapWidgetFridge(index:widget.index,context: context);
                                                            });
                                                          },
                                                          // onChanged: (newValue) => controller.onTapWidgetFridge(index:widget.index,context: context),
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
                                                  onTap: () => controller.onTapWidgetCancel(index:widget.index,context: context),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.cancel_outlined,
                                                      ),
                                                      buildSizeBox(0.0, 5.0),
                                                      BuildText.buildText(
                                                          text: kCancel)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                        )),
                                  ])
                        ],
                      ),
                      buildSizeBox(3.0, 0.0),
                      BuildText.buildText(
                        text: widget.address ?? "",
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.greyColorDark)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

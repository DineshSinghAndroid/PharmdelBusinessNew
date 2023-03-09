import 'package:flutter/material.dart';

import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class NursingHomeCardWidget extends StatefulWidget {
  String? customerName;
  String? leadingText;

   NursingHomeCardWidget({
    required this.customerName,
    required this.leadingText
   });

  @override
  State<NursingHomeCardWidget> createState() => _NursingHomeCardWidgetState();
}

class _NursingHomeCardWidgetState extends State<NursingHomeCardWidget> {
  bool? isCheckedCD = false;
  bool? isCheckedFridge = false;
  @override
  Widget build(BuildContext context) {
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
                                  ))),
                              buildSizeBox(0.0, 10.0),
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
                              ),
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
                                          builder: ((context, setStat) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // pmrList[index].isCD = !pmrList[index].isCD;
                                                    // updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                    // setStat((){});
                                                    // setState(() {});
                                                    // Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    color: AppColors.redColor,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Checkbox(
                                                          activeColor: AppColors
                                                              .blackColor,
                                                          visualDensity:
                                                              const VisualDensity(
                                                                  horizontal: -4,
                                                                  vertical: -4),
                                                          value: isCheckedCD,
                                                          onChanged: (newValue) {
                                                            setState(() {
                                                              isCheckedCD =
                                                                  newValue;
                                                            });
                                                            setStat(() {});
                                                          },
                                                        ),
                                                        BuildText.buildText(
                                                            text: 'C. D.',
                                                            color: AppColors
                                                                .whiteColor),
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
                                                  onTap: () {
                                                    // pmrList[index].isFridge = !pmrList[index].isFridge;
                                                    // updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                    // setStat((){});
                                                    // setState(() {});
                                                    // Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    color: AppColors.blueColor,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Checkbox(
                                                          activeColor: AppColors
                                                              .blackColor,
                                                          visualDensity:
                                                              const VisualDensity(
                                                                  horizontal: -4,
                                                                  vertical: -4),
                                                          value: isCheckedFridge,
                                                          onChanged: (newValue) {
                                                            setState(() {
                                                              isCheckedFridge =
                                                                  newValue;
                                                            });
                                                            setStat(() {});
                                                            // updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                            // Navigator.pop(context);
                                                          },
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 12.0),
                                                          child: Image.asset(
                                                            strIMG_Fridge,
                                                            height: 21,
                                                            color: AppColors
                                                                .whiteColor,
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
                                                  onTap: () {
                                                    // cancelOrder(pmrList[index].orderId);
                                                    // Navigator.pop(context);
                                                  },
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
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

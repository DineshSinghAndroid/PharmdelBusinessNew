import 'package:flutter/material.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class PharmacyDeliveryCard extends StatelessWidget {

  bool isSelected;
  String deliveryStatus;
  Function() onTap;
  Function() onTapRoute;
  Function() onTapManual;
  Function() onTapDeliverNow;
  String customerName;
  String customerAddress;
  String altAddress;
  String nursingHomeId;
  String pmrType;
  String pmrId;
  String isCronCreated;
  String isStorageFridge;
  String isControlledDrugs;
  bool isBulkScanSwitched;
  int orderListType;
  List<PopupMenuEntry<dynamic>> popUpMenu;
  String orderId;
  String serviceName;
  String pharmacyName;
  String driverType;
  String parcelBoxName;
  String rescheduleDate;
  PharmacyDeliveryCard({super.key,
    required this.isSelected,
    required this.deliveryStatus,
    required this.onTap,
    required this.onTapRoute,
    required this.onTapManual,
    required this.onTapDeliverNow,
    required this.customerName,
    required this.customerAddress,
    required this.altAddress,
    required this.nursingHomeId,
    required this.pmrType,
    required this.pmrId,
    required this.isCronCreated,
    required this.isStorageFridge,
    required this.isControlledDrugs,
    required this.isBulkScanSwitched,
    required this.popUpMenu,
    required this.orderListType,
    required this.orderId,
    required this.serviceName,
    required this.pharmacyName,
    required this.driverType,
    required this.parcelBoxName,
    required this.rescheduleDate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: isSelected ? Colors.blue[100] : Colors.white,
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BuildText.buildText(
                      text: customerName,size: 14,weight: FontWeight.w700,maxLines: 2
                  ),
                  buildSizeBox(3.0, 5.0),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child:
                        /// Customer Address
                        BuildText.buildText(
                            text: customerAddress,
                            size: 12,
                            weight: FontWeight.w300,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          color: Colors.black87
                        ),
                      ),
                      buildSizeBox(0.0, 5.0),


                      Padding(
                        padding: EdgeInsets.only(top: deliveryStatus.toLowerCase() == "failed" ? 5.0 : 0.0),
                        child:
                        BuildText.buildText(
                            text: deliveryStatus ?? "",
                            size: 12,
                            weight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            color: deliveryStatus.toLowerCase() == kOutForDelivery ?
                            AppColors.yetToStartColor
                                : deliveryStatus == kDelivered ?
                            AppColors.deliveredColor
                                : deliveryStatus == kFailed ?
                            AppColors.failedColor
                                : deliveryStatus == kPickedUp ?
                            AppColors.pickedUp:AppColors.greenAccentColor
                        ),
                      )
                    ],
                  ),
                  buildSizeBox(0.0, 5.0),

                  orderListType == 4
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: onTapRoute,
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  color: Colors.blueAccent,
                                  boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(strImgSend,height: 14,width: 14,),
                                  buildSizeBox(0.0, 5.0),
                                  BuildText.buildText(text: kRoute, size: 12,weight: FontWeight.w500,color: AppColors.whiteColor),
                                  buildSizeBox(0.0, 5.0),
                                ],
                              ),
                            ),
                          ),

                          buildSizeBox(0.0, 1.0),

                          if (int.parse(orderId.toString()) > 0)
                            InkWell(
                              onTap: onTapManual,
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    color: AppColors.whiteColor,
                                    boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                                child: Column(
                                  children: <Widget>[
                                    BuildText.buildText(text: kManual, size: 12,weight: FontWeight.w500,color: AppColors.blackColor),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  )
                      : const SizedBox.shrink(),

                  Row(
                    children: [

                      if (nursingHomeId == "" || nursingHomeId == "0")
                        if (serviceName != "" && serviceName != "null")
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  color: Colors.redAccent,
                                  boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
                              child:
                                  BuildText.buildText(
                                      text:
                                      serviceName != ""
                                          ? serviceName.toString().length > 12
                                          ? serviceName.toString().substring(0, 12)
                                          : serviceName.toString()
                                          : "",
                                    maxLines: 2,color: AppColors.whiteColor,size: 12
                                  )
                         ),

                      if (serviceName != "null" && serviceName != "")
                        buildSizeBox(0.0, 10.0),

                      if (pharmacyName != "null" && pharmacyName != "" && driverType.toLowerCase() == kSharedDriver)
                        Flexible(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  color: Colors.orange,
                                  boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
                              child:
                              BuildText.buildText(
                                  text:
                                  pharmacyName != ""
                                      ? pharmacyName.toString().length > 16
                                      ? pharmacyName.toString().substring(0, 16)
                                      : pharmacyName.toString()
                                      : "",
                                  maxLines: 1,color: AppColors.whiteColor,size: 12
                              )
                          ),
                        ),
                      if (pharmacyName != "null" && pharmacyName != "" && driverType.toLowerCase() == kSharedDriver)
                        buildSizeBox(0.0, 10.0),

                      if (orderListType == 8 && parcelBoxName != "" && parcelBoxName != "null" && parcelBoxName.toString().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                child:
                                BuildText.buildText(
                                    text:
                                    parcelBoxName.toString().length > 8
                                        ? parcelBoxName.toString().substring(0, 8)
                                        : parcelBoxName.toString(),
                                    maxLines: 1,color: AppColors.whiteColor,size: 12
                                )
                              ),
                            ),
                          ],
                        )
                    ],
                  ),

                  if (orderListType == 6 && rescheduleDate != "null" && rescheduleDate != "")
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          BuildText.buildText(
                              text:"Booked : ",
                              maxLines: 1,color: AppColors.failedColor,size: 12
                          ),

                          BuildText.buildText(
                              text:rescheduleDate,
                              maxLines: 1,color: AppColors.failedColor,size: 12
                          ),

                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (deliveryStatus == kFailed)
          Positioned(
            right: 14.0,
            top: 5.0,
            child: GestureDetector(
              onTap: onTapDeliverNow,
              child: Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0.0, blurRadius: 3.0, offset: const Offset(0, 3))],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:
                  BuildText.buildText(text: kDeliverNow,color: AppColors.whiteColor,size: 12)
              ),
            ),
          ),
      ],
    );

  }
}

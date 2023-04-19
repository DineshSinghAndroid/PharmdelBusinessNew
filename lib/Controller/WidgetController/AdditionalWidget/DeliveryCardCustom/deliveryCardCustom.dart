import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Helper/Colors/custom_color.dart';
import '../../../Helper/TextController/BuildText/BuildText.dart';
import '../../StringDefine/StringDefine.dart';

class DeliveryCardCustom extends StatelessWidget {

  bool isSelected;
  String deliveryStatus;
  Function() onTap;
  Function() onTapRoute;
  Function() onTapManual;
  Function() onTapDeliverNow;
  Function() onTapMakeNext;
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
  int index;
  String bagSize;
  Function(dynamic) onPopUpMenuSelected;
  DeliveryCardCustom({super.key,
    required this.bagSize,
    required this.index,
    required this.onPopUpMenuSelected,
    required this.isSelected,
    required this.deliveryStatus,
    required this.onTap,
    required this.onTapRoute,
    required this.onTapManual,
    required this.onTapDeliverNow,
    required this.onTapMakeNext,
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
          color: isSelected ? Colors.blue[100] : int.parse(orderId.toString()) > 0 ? Colors.white : Colors.green[300],
          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [

                          Visibility(
                            visible: orderListType == 4,
                              child: CircleAvatar(
                                backgroundColor: Colors.orange[400],
                                radius: 8.0,
                                child: FittedBox(
                                    child: BuildText.buildText(
                                        text: "${index + 1}",size: 10,weight: FontWeight.w700,
                                    ),
                                ),
                              ),
                          ),
                          /// Customer name
                          BuildText.buildText(
                              text: customerName,size: 14,weight: FontWeight.w700,maxLines: 2
                          ),
                          buildSizeBox(0.0, 3.0),



                          if (nursingHomeId == "" || nursingHomeId == "0")
                            if (pmrType != "" && (pmrType == "titan" || pmrType == "nursing_box") && pmrId != "0" && pmrId != "" && pmrId.isNotEmpty)
                              BuildText.buildText(text: '(P/N : $pmrId) ',size: 14,color: AppColors.pnColor),
                          if (isCronCreated.toLowerCase() == "t") Image.asset(strImgAutomaticIcon, height: 14, width: 14),
                        ],
                      ),

                      Visibility(
                        visible: deliveryStatus.toLowerCase() == "outfordelivery" || deliveryStatus.toLowerCase() == "pickedup" || deliveryStatus.toLowerCase() == "received",
                          child: Row(
                            children: [
                                Visibility(
                                  visible: isStorageFridge.toLowerCase() == "t",
                                  child: Container(
                                      height: 20,
                                      padding: const EdgeInsets.only(right: 5.0, left: 5.0, top: 2.0, bottom: 2.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: AppColors.blueColor,
                                      ),
                                      child: Center(
                                          child: Image.asset(strImgFridge,height: 20, color: AppColors.whiteColor,)
                                      )
                                  ),
                                ),
                              buildSizeBox(0.0, 5.0),

                                Visibility(
                                  visible: isControlledDrugs.toLowerCase() == "t",
                                  child: Container(
                                    height: 20,
                                    padding: const EdgeInsets.only(right: 3.0, left: 3.0, top: 2.0, bottom: 2.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                      child: BuildText.buildText(text: 'C.D.',size: 12,color: AppColors.whiteColor),
                                    ),
                                  ),
                                ),
                              if (nursingHomeId == "" || nursingHomeId == "0" )
                                  Visibility(
                                    visible: isBulkScanSwitched && orderId != "0",
                                    child: PopupMenuButton(
                                        padding: EdgeInsets.zero,onSelected: onPopUpMenuSelected,
                                        itemBuilder: (_)=> popUpMenu,
                                        child: Icon(
                                          Icons.more_vert,
                                          color: AppColors.greyColor,
                                        )
                                    ),
                                  ),
                            ],
                          )
                      ),

                    ],
                  ),
                  buildSizeBox(3.0, 5.0),

                  /// Bag size parcel or home lbl
                  Visibility(
                    visible: orderListType == 4,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3,right: 5),
                      child: Row(
                        children: [

                            Visibility(
                              visible: bagSize != "null" && bagSize.isNotEmpty && bagSize != "",
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    color: AppColors.greenColor,
                                    boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.shopping_bag_outlined,size: 18,),
                                    BuildText.buildText(
                                        text: bagSize ?? "",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          buildSizeBox(0.0, 4.0),

                          if (nursingHomeId == "0")
                            if (serviceName != "" && serviceName != "null")
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                        color: Colors.red,
                                        boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 3, top: 3),
                                    child: BuildText.buildText(
                                      text: serviceName.length > 10 ? serviceName.toString().substring(0, 10) : serviceName ?? "",
                                      maxLines: 2,color: AppColors.whiteColor,size: 10
                                    ),
                                ),
                              ),
                          if (pharmacyName != "null" && pharmacyName != "" && driverType.toLowerCase() == kSharedDriver.toLowerCase())
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      color: Colors.orange,
                                      boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 3, top: 3),
                                  child: BuildText.buildText(
                                      text: pharmacyName.length > 14 ? pharmacyName.substring(0, 14) : pharmacyName ?? "",
                                      maxLines: 1,color: AppColors.whiteColor,size: 10
                                  ),
                              ),
                            ),
                          if (orderListType == 4 && parcelBoxName != "null" && parcelBoxName != "" && parcelBoxName.toString().isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                    child: BuildText.buildText(
                                        text: parcelBoxName.length > 8 ? parcelBoxName.substring(0, 8) : parcelBoxName ?? "",
                                        color: AppColors.pickedUp,size: 10
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),

                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: BuildText.buildText(
                                  text: customerAddress,
                                  size: 12,
                                  weight: FontWeight.w300,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  color: Colors.black87
                              ),
                            ),
                            buildSizeBox(0.0, 5.0),


                            Visibility(
                                visible: altAddress.toLowerCase() == "t",
                                child: Image.asset(strImgAltAdd,height: 18,width: 18, )
                            ),
                            buildSizeBox(0.0, 10.0),
                          ],
                        ),
                      ),



                      Visibility(
                        visible: orderListType != 4,
                        child: Padding(
                          padding: EdgeInsets.only(top: deliveryStatus.toLowerCase() == "failed" ? 5.0 : 0.0),
                          child:
                          BuildText.buildText(
                              text: deliveryStatus ?? "",
                              size: 12,
                              weight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              color: deliveryStatus.toLowerCase() == kOutForDelivery.toLowerCase() ?
                              AppColors.yetToStartColor
                                  : deliveryStatus.toLowerCase() == kDelivered.toLowerCase() ?
                              AppColors.deliveredColor
                                  : deliveryStatus.toLowerCase() == kFailed.toLowerCase() ?
                              AppColors.failedColor
                                  : deliveryStatus.toLowerCase() == kPickedUpDelivery.toLowerCase() ?
                              AppColors.fridgeColor
                                  : deliveryStatus.toLowerCase() == kReadyDelivery.toLowerCase() ?
                              AppColors.readyColor
                                  : deliveryStatus.toLowerCase() == kReceived.toLowerCase() ?
                              AppColors.readyColor:AppColors.greenAccentColor
                          ),
                        ),
                      )
                    ],
                  ),
                  buildSizeBox(0.0, 5.0),

                  /// Map Navigate Btn or Manual Btn
                      Visibility(
                        visible: orderListType == 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: onTapRoute,
                                    child: orderListType == 4 ?
                                    Container(
                                      // width: 100,
                                      // margin: const EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
                                      // padding: const EdgeInsets.all(10),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: const BorderRadius.all(Radius.circular(5)),
                                      //     color: Colors.blueAccent,
                                      //     boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                                      width: 35,
                                      margin: const EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                          boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.white.withOpacity(0.8))]
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(strImgSend,height: 12,width: 12,),
                                          // buildSizeBox(0.0, 5.0),
                                          // BuildText.buildText(text: kRoute, size: 12,weight: FontWeight.w500,color: AppColors.whiteColor),
                                          // buildSizeBox(0.0, 5.0),
                                        ],
                                      ),
                                    )
                                    : Container(
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

                                  const Spacer(),

                                  if (int.parse(orderId.toString()) > 0)
                                    InkWell(
                                      onTap: onTapManual,
                                      child: Container(
                                        // width: 70,
                                        margin: const EdgeInsets.only(left: 1, right: 1, top: 2, bottom: 2),
                                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
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

                                  if (index != 0 || orderId == "0")
                                    InkWell(
                                      onTap: onTapMakeNext,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 5, right: 1, top: 2, bottom: 2),
                                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            color: Colors.orange,
                                            boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                                        child: Column(
                                          children: <Widget>[
                                            BuildText.buildText(
                                                text: int.parse(orderId.toString()) > 0 ? kMakeNext:kArrived,size: 12, weight: FontWeight.w500, color: AppColors.whiteColor                                         ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                  Row(
                    children: [

                      /// Nursing home name
                      if (nursingHomeId == "" || nursingHomeId == "0")
                          Visibility(
                            visible: serviceName != "" && serviceName != "null" && orderListType != 4,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10.0),
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
                          ),

                        /// Pharmacy Name
                        // Visibility(
                        //   visible: pharmacyName != "null" && pharmacyName != "" && driverType.toLowerCase() == kSharedDriver,
                        //   child: Flexible(
                        //     child: Container(
                        //       margin: const EdgeInsets.only(right: 10.0),
                        //         decoration: BoxDecoration(
                        //             borderRadius: const BorderRadius.all(Radius.circular(5)),
                        //             color: Colors.orange,
                        //             boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4), color: Colors.grey.withOpacity(0.3))]),
                        //         padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
                        //         child:
                        //         BuildText.buildText(
                        //             text:
                        //             pharmacyName != ""
                        //                 ? pharmacyName.toString().length > 16
                        //                 ? pharmacyName.toString().substring(0, 16)
                        //                 : pharmacyName.toString()
                        //                 : "",
                        //             maxLines: 1,color: AppColors.whiteColor,size: 12
                        //         )
                        //     ),
                        //   ),
                        // ),

                      /// Parcel box name
                        Visibility(
                          visible: orderListType == 8 && parcelBoxName != "" && parcelBoxName != "null" && parcelBoxName.toString().isNotEmpty,
                          child: Row(
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
                                      maxLines: 1,color: AppColors.greyColorDark,size: 12
                                  )
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),

                  /// Reschedule Date
                    Visibility(
                      visible: orderListType == 6 && rescheduleDate != "null" && rescheduleDate != "",
                      child: Padding(
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
                    ),

                ],
              ),
            ),
          ),
        ),

          /// Deliver Now
          Visibility(
            visible: deliveryStatus.toLowerCase() == kFailed.toLowerCase(),
            child: Positioned(
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
          ),
      ],
    );

  }
}

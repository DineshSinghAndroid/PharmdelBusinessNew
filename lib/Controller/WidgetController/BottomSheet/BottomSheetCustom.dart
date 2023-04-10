<<<<<<< HEAD

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/BottomSheet/select_route_bottomsheet.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../../View/BulkDrop/bulk_drop_bottomsheet.dart';
import '../../../View/DeliverySchedule/exempt_bottom_sheet.dart';
import '../../../View/DeliverySchedule/rx_charge_bottom_sheet.dart';
import '../../../View/DeliverySchedule/rx_detail_bottom_sheet.dart';
import '../../Helper/Permission/PermissionHandler.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';
import '../../PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import '../../ProjectController/BulkDrop/bulk_drop_controller.dart';
import '../../ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../../ProjectController/OrderDetails/order_detail_controller.dart';
import '../AdditionalWidget/DeliveryScheduleWidget/deliveryScheduleWidget.dart';
import '../StringDefine/StringDefine.dart';
import 'exempt_bottom_sheet.dart';
import 'p_delivery_schedule_widget.dart';
import 'p_select_driver_bottom_sheet.dart';
import 'p_select_route_bottom_sheet.dart';

class BottomSheetCustom{
  BottomSheetCustom._privateConstructor();
  static final BottomSheetCustom instance = BottomSheetCustom._privateConstructor();

  static showRxDetailBottomSheet({required Function(dynamic) onValue,required BuildContext context}) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0.0),
              topLeft: Radius.circular(0.0),
            )
        ),
        context: context,
        backgroundColor: AppColors.transparentColor,
        builder: (builder){
          return const RxDetailBottomSheet();
        }
    ).then(onValue);
  }
  static showRxChargeBottomSheet({required Function(dynamic) onValue,required BuildContext context}) async {
    return showModalBottomSheet(
        isScrollControlled: false,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            )
        ),
        context: context,
        backgroundColor: Colors.white,
        builder: (builder){
          return RxChargeBottomSheet();
        }
    ).then(onValue);
  }

  static showExemptBottomSheet({required Function(dynamic) onValue,required BuildContext context}) async {
    return showModalBottomSheet(
        isScrollControlled: false,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            )
        ),
        context: context,
        backgroundColor: Colors.white,
        builder: (builder){
          return DriverExemptBottomSheet();
        }
    ).then(onValue);
  }

  static Future<void> showImagePickerBottomSheet({required BuildContext context,required Function(dynamic) onValue}) async {
    showModalBottomSheet(
        backgroundColor: AppColors.transparentColor,
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
                height: 110,
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop("Gallery");
                      },
                      child: Container(
                          padding: const EdgeInsets.only(top: 8,bottom: 8,left: 35,right: 35),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.themeColor,width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.photo_library,color: AppColors.themeColor,size: 30,),
                              BuildText.buildText(text: kGallery,size: 18,weight: FontWeight.w500),
                            ],
                          )
                      ),
                    ),
                    buildSizeBox(0.0,30.0),
                    InkWell(
                      onTap: () {
                        CheckPermission.checkCameraPermission(context).then((value) {
                          if(value == true){
                            Navigator.of(context).pop("Camera");
                          }
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.only(top: 8,bottom: 8,left: 35,right: 35),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.themeColor,width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.photo_camera,color: AppColors.themeColor,size: 30,),
                              BuildText.buildText(text: kCamera,size: 18,weight: FontWeight.w500),

                            ],
                          )
                      ),
                    ),
                  ],
                )
            ),
          );
        }).then(onValue);
  }

  static Future<void> share({required BuildContext context,required String link}) async {
    PrintLog.printLog('Share Tab');
    await Share.share(link,
      subject: "Pharmdel",
=======
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import 'package:pharmdel/Controller/WidgetController/BottomSheet/select_route_bottomsheet.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Model/PharmacyModels/P_MedicineListResponse/p_MedicineListResponse.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../../PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';
import '../../PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import '../../ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../AdditionalWidget/DeliveryScheduleWidget/deliveryScheduleWidget.dart';
import '../StringDefine/StringDefine.dart';
import 'p_delivery_schedule_bottomsheet.dart';
import 'p_select_driver_bottomsheet.dart';
import 'p_select_route_bottomsheet.dart';

class BottomSheetCustom {
  
  static Future<void> share(
      {required BuildContext context, required String link}) async {
    PrintLog.printLog('Share Tab');
    await Share.share(
      link,
      subject: "Apna Slot",
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
    );
  }

  static showSelectAddressBottomSheet(
      {required DriverDashboardCTRL controller,
      required Function(dynamic) onValue,
      required BuildContext context,
      required String listType,
      String? selectedID}) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(0.0),
          topLeft: Radius.circular(0.0),
        )),
        context: context,
        backgroundColor: AppColors.transparentColor,
        builder: (builder) {
          return SelectRouteBottomSheet(
            controller: controller,
            listType: listType,
            selectedID: selectedID,
          );
        }).then(onValue);
  }

<<<<<<< HEAD
  static showSelectRouteBottomSheet({required DriverDashboardCTRL controller,required Function(dynamic) onValue,required BuildContext context,required String listType,String? selectedID}) async {
=======
  static pShowSelectAddressBottomSheet(
      {required NursingHomeController controller,
      required Function(dynamic) onValue,
      required BuildContext context,
      required String listType,
      String? selectedID}) async {
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        )),
        context: context,
        backgroundColor: AppColors.whiteColor,
        builder: (builder) {
          return SizedBox(
              height: Get.height - 400,
              width: Get.width,
              child: PhramacySelectRouteBottomSheet(
                controller: controller,
                listType: listType,
                selectedID: selectedID,
              ));
        }).then(onValue);
  }

  static pSelectPharmacyStaff(
      {required PharmacyNotificationController controller,
      required Function(dynamic) onValue,
      required BuildContext context,
      String? selectedID}) async {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        )),
        context: context,
        backgroundColor: AppColors.whiteColor,
        builder: (builder) {
          return SizedBox(
              height: Get.height - 400,
              width: Get.width,
              child: PharmacyNotificationBottomSheet(
                controller: controller,
                selectedID: selectedID,
              ));
        }).then(onValue);
  }

  static selectMediaBottomsheet({required VoidCallback onTapGallery, required VoidCallback onTapCamera}) {
    return Container(
      height: 115,
      width: Get.width,
      decoration: BoxDecoration(
          color: AppColors.whiteColor, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: onTapGallery,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo,
                      color: AppColors.greyColor,
                    ),
                    buildSizeBox(0.0, 10.0),
                    BuildText.buildText(text: kGallery, size: 15),
                  ],
                ),
              ),
            ),
            Divider(
              color: AppColors.greyColorDark,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: onTapCamera,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: AppColors.greyColor,
                    ),
                    buildSizeBox(0.0, 10.0),
                    BuildText.buildText(text: kCamera, size: 15),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static RxDetailsBottomsheetCustom({
    required int itemCount,
    required TextEditingController quantityController,
    required TextEditingController daysController, 
    required VoidCallback onTapDelete,
    required bool? firdgeCheckValue, 
    required bool? cdCheckValue, 
    required String medicineName,
    required Function(bool?) onChangedCD,
    required Function(bool?) onChangedFridge}
    ){      
    return SizedBox(
          height: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.blackColor))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildText.buildText(text: kRxDetails,size: 18),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          alignment: Alignment.centerRight,
                          width: 50,
                          child: Icon(Icons.clear,color: AppColors.blackColor,)))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                  itemCount: itemCount,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildText.buildText(text: medicineName),
                        buildSizeBox(10.0, 0.0),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: quantityController,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  hintText: kQuantity,
                                  hintStyle: TextStyle(color: AppColors.greyColorDark,fontSize: 14),
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                )),
                            ),
                            buildSizeBox(0.0, 10.0),
                            Flexible(
                              child: TextFormField(                                                        
                                controller: daysController,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  hintText: kDays,
                                  hintStyle: TextStyle(color: AppColors.greyColorDark,fontSize: 14),
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                )),
                            ),
                            buildSizeBox(0.0, 50.0),
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              height: 40,
                              width: 50,
                              decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(5.0)),
                              child: InkWell(
                                onTap: onTapDelete,
                                child: Icon(
                                  Icons.delete,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        buildSizeBox(10.0, 0.0),
                        Row(
                          children: [
                            DeliveryScheduleWidgets.customWidgetwithCheckbox(
                            bgColor: AppColors.blueColor, 
                            title: Image.asset(strImgFridge,color: AppColors.whiteColor,height: 20,), 
                            checkBoxValue: firdgeCheckValue ?? false,
                            onChanged: onChangedFridge),
                            buildSizeBox(0.0, 5.0),
                              DeliveryScheduleWidgets.customWidgetwithCheckbox(
                            bgColor: AppColors.redColor, 
                            title: BuildText.buildText(text: 'C.D.',color: AppColors.whiteColor), 
                            checkBoxValue: cdCheckValue ?? false,
                            onChanged: onChangedCD),
                          ],
                        ),
                        buildSizeBox(8.0, 0.0),
                        Divider(color: AppColors.greyColor),
                      ],
                    );
                  },),
              )
            ],
          )
        );
  }

  static pDeliveryScheduleBottomSheet({
    required DeliveryScheduleController controller,
    required Function(dynamic) onValue,
    required BuildContext context,
    required String listType,
    String? selectedID,
    }) async {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            )
        ),
        context: context,
        backgroundColor: AppColors.whiteColor,
        builder: (builder){
          return SizedBox(
            height: Get.height - 400,
            width: Get.width,
            child: SelectDeliveryScheduleBottomsheet(controller: controller,listType: listType,selectedID: selectedID,));
        }
    ).then(onValue);
  }

<<<<<<< HEAD
  static showSelectExemptBottomSheet({required OrderDetailController controller,required Function(dynamic) onValue,required BuildContext context,required OrderDetailResponse orderDetail}) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            )
        ),
        context: context,
        isDismissible: true,
        backgroundColor: AppColors.whiteColor,
        builder: (builder){
          return Container(
            height: getHeightRatio(value: 50),
              child: ExemptBottomSheet(controller: controller,orderDetail: orderDetail,)
          );
        }
    ).then(onValue);
  }

  static showBulkDropBottomSheet({required BulkDropController controller,required Function(dynamic) onValue,required BuildContext context}) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        backgroundColor: AppColors.transparentColor,
        builder: (builder){
          return BulkDropBottomSheet(controller: controller);
        }
    ).then(onValue);
  }



  static showSelectAddressBottomSheet(
      {required DriverDashboardCTRL controller,
        required Function(dynamic) onValue,
        required BuildContext context,
        required String listType,
        String? selectedID}) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0.0),
              topLeft: Radius.circular(0.0),
            )),
        context: context,
        backgroundColor: AppColors.transparentColor,
        builder: (builder) {
          return SelectRouteBottomSheet(
            controller: controller,
            listType: listType,
            selectedID: selectedID,
          );
        }).then(onValue);
  }

  static pShowSelectAddressBottomSheet(
      {required NursingHomeController controller,
        required Function(dynamic) onValue,
        required BuildContext context,
        required String listType,
        String? selectedID}) async {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            )),
        context: context,
        backgroundColor: AppColors.whiteColor,
        builder: (builder) {
          return SizedBox(
              height: Get.height - 400,
              width: Get.width,
              child: PhramacySelectRouteBottomSheet(
                controller: controller,
                listType: listType,
                selectedID: selectedID,
              ));
        }).then(onValue);
  }

  static pSelectPharmacyStaff(
      {required PharmacyNotificationController controller,
        required Function(dynamic) onValue,
        required BuildContext context,
        String? selectedID}) async {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            )),
        context: context,
        backgroundColor: AppColors.whiteColor,
        builder: (builder) {
          return SizedBox(
              height: Get.height - 400,
              width: Get.width,
              child: PharmacyNotificationBottomSheet(
                controller: controller,
                selectedID: selectedID,
              ));
        }).then(onValue);
  }

  static selectMediaBottomsheet({required VoidCallback onTapGallery, required VoidCallback onTapCamera}) {
    return Container(
      height: 115,
      width: Get.width,
      decoration: BoxDecoration(
          color: AppColors.whiteColor, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: onTapGallery,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo,
                      color: AppColors.greyColor,
                    ),
                    buildSizeBox(0.0, 10.0),
                    BuildText.buildText(text: kGallery, size: 15),
                  ],
                ),
              ),
            ),
            Divider(
              color: AppColors.greyColorDark,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: onTapCamera,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: AppColors.greyColor,
                    ),
                    buildSizeBox(0.0, 10.0),
                    BuildText.buildText(text: kCamera, size: 15),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static RxDetailsBottomsheetCustom({
    required int itemCount,
    required TextEditingController quantityController,
    required TextEditingController daysController,
    required VoidCallback onTapDelete,
    required bool? firdgeCheckValue,
    required bool? cdCheckValue,
    required String medicineName,
    required Function(bool?) onChangedCD,
    required Function(bool?) onChangedFridge}
      ){
    return SizedBox(
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.blackColor))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BuildText.buildText(text: kRxDetails,size: 18),
                    InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                            alignment: Alignment.centerRight,
                            width: 50,
                            child: Icon(Icons.clear,color: AppColors.blackColor,)))
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                itemCount: itemCount,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText.buildText(text: medicineName),
                      buildSizeBox(10.0, 0.0),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                                controller: quantityController,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  hintText: kQuantity,
                                  hintStyle: TextStyle(color: AppColors.greyColorDark,fontSize: 14),
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                )),
                          ),
                          buildSizeBox(0.0, 10.0),
                          Flexible(
                            child: TextFormField(
                                controller: daysController,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  hintText: kDays,
                                  hintStyle: TextStyle(color: AppColors.greyColorDark,fontSize: 14),
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                                  ),
                                )),
                          ),
                          buildSizeBox(0.0, 50.0),
                          Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            height: 40,
                            width: 50,
                            decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(5.0)),
                            child: InkWell(
                              onTap: onTapDelete,
                              child: Icon(
                                Icons.delete,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildSizeBox(10.0, 0.0),
                      Row(
                        children: [
                          DeliveryScheduleWidgets.customWidgetwithCheckbox(
                              bgColor: AppColors.blueColor,
                              title: Image.asset(strImgFridge,color: AppColors.whiteColor,height: 20,),
                              checkBoxValue: firdgeCheckValue ?? false,
                              onChanged: onChangedFridge),
                          buildSizeBox(0.0, 5.0),
                          DeliveryScheduleWidgets.customWidgetwithCheckbox(
                              bgColor: AppColors.redColor,
                              title: BuildText.buildText(text: 'C.D.',color: AppColors.whiteColor),
                              checkBoxValue: cdCheckValue ?? false,
                              onChanged: onChangedCD),
                        ],
                      ),
                      buildSizeBox(8.0, 0.0),
                      Divider(color: AppColors.greyColor),
                    ],
                  );
                },),
            )
          ],
        )
    );
  }

  static pDeliveryScheduleBottomSheet({
    required DeliveryScheduleController controller,
    required Function(dynamic) onValue,
    required BuildContext context,
    required String listType,
    String? selectedID,
  }) async {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            )
        ),
        context: context,
        backgroundColor: AppColors.whiteColor,
        builder: (builder){
          return SizedBox(
              height: Get.height - 400,
              width: Get.width,
              child: SelectDeliveryScheduleBottomsheet(controller: controller,listType: listType,selectedID: selectedID,));
        }
    ).then(onValue);
  }

/// Use for share App
=======
  /// Use for share App
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
  // static showSharePopup({required context,required String shareLink}) async {
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       clipBehavior: Clip.antiAlias,
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //             topRight: Radius.circular(20.0),
  //             topLeft: Radius.circular(20.0),
  //           )
  //       ),
  //       context: context,
  //       backgroundColor: Colors.white,
  //       builder: (builder){
  //         return SafeArea(
  //             child: Wrap(
  //               children: [
  //                 Stack(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 30,right: 30,bottom: 10),
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Container(
  //                                 height: 115,
  //                                 width: 115,
  //                                 margin: const EdgeInsets.only(bottom: 20,top: 30),
  //                                 decoration: BoxDecoration(
  //                                     shape: BoxShape.circle,
  //                                     color: AppColors.bluearrowcolor.withOpacity(0.8),
  //                                     image:  DecorationImage(
  //                                         image: AssetImage(str_imgSharePopup),
  //                                         fit: BoxFit.cover
  //                                     )
  //                                 ),
  //                               ),
  //                               buildTextWithWeightOrSpacingHeight(
  //                                   "Invite friends & earn\namazing gadgets"
  //                                   , 18.0, TextAlign.center, FontFamily.montRegular, AppColors.signupcolor, FontWeight.w800, 0.3, 0.0),
  //                               buildSizedBox(15.0, 0.0),
  //                               InkWell(
  //                                 onTap: (){
  //                                   Clipboard.setData(ClipboardData(text: shareLink)).then((value) {
  //                                     ToastUtils.showToast("Link copied");
  //                                   });
  //                                 },
  //                                 child: DottedBorder(
  //                                   borderType: BorderType.RRect,
  //                                   radius: const Radius.circular(6),
  //                                   dashPattern: [2, 2],
  //                                   color: AppColors.greyColor,
  //                                   strokeWidth: 1,
  //                                   child: Container(
  //                                     height: 50,
  //                                     padding: const EdgeInsets.only(left: 20,right: 20),
  //                                     width: MediaQuery.of(context).size.width,
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(6),
  //                                       color: AppColors.transparentColor,
  //                                       // border: Border.all(width: 1,color: AppColors.greyColor)
  //                                     ),
  //                                     child: Center(
  //                                         child: Row(
  //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                           crossAxisAlignment: CrossAxisAlignment.center,
  //                                           children: [
  //                                             Expanded(
  //                                               child: buildTextWithWeightOrSpacingHeightWithLine(
  //                                                   shareLink, 14.0, TextAlign.left, FontFamily.montRegular, AppColors.darkGreyColor1, FontWeight.w600, 0.0, 0.0
  //                                               ),
  //                                             ),
  //                                             SvgPicture.asset(str_svgCopy),
  //                                           ],
  //                                         )
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               buildSizedBox(30.0, 0.0),
  //
  //                               Container(
  //                                 height: 50,
  //                                 width: MediaQuery.of(context).size.width,
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment: CrossAxisAlignment.center,
  //                                   children: [
  //                                     Expanded(
  //                                       child: InkWell(
  //                                         onTap: (){
  //                                           Navigator.of(context).pop(false);
  //                                         },
  //                                         child: Container(
  //                                             height: 50.0,
  //                                             padding: const EdgeInsets.only(left: 20,right: 20),
  //                                             decoration: BoxDecoration(
  //                                                 borderRadius: BorderRadius.circular(50.0),
  //                                                 color: AppColors.colorWhatsApp
  //                                             ),
  //                                             // margin: EdgeInsets.all(25),
  //                                             child: Row(
  //                                               mainAxisAlignment: MainAxisAlignment.center,
  //                                               crossAxisAlignment: CrossAxisAlignment.center,
  //                                               children: [
  //                                                 SvgPicture.asset(str_svgWhatsApp),
  //                                                 buildSizedBox(0.0, 5.0),
  //                                                 buildTextWithWeightOrSpacingHeight(
  //                                                     "Invite via Whatsapp", 14.0, TextAlign.left, FontFamily.montBold, AppColors.whiteColor, FontWeight.w900, 0.0, 0.0
  //                                                 )
  //                                               ],
  //                                             )
  //
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     buildSizedBox(0.0, 15.0),
  //                                     InkWell(
  //                                       onTap: (){
  //                                         Navigator.of(context).pop(true);
  //                                       },
  //                                       child: Container(
  //                                           height: 50.0,
  //                                           width: 50.0,
  //                                           decoration: BoxDecoration(
  //                                               shape: BoxShape.circle,
  //                                               gradient: LinearGradient(
  //                                                 begin: Alignment.centerLeft,
  //                                                 end: Alignment.centerRight,
  //                                                 colors: [
  //                                                   AppColors.skyColor,
  //                                                   AppColors.purpleColor
  //                                                 ],
  //                                               )
  //                                           ),
  //                                           // margin: EdgeInsets.all(25),
  //                                           child: Center(
  //                                             child:
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(bottom: 5),
  //                                               child: buildTextWithWeightOrSpacingHeight(
  //                                                   "...", 18.0, TextAlign.left, FontFamily.montRegular, AppColors.whiteColor, FontWeight.w900, 1.0, 0.0
  //                                               ),
  //                                             ),
  //                                           )
  //
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               )
  //                             ]
  //                         ),
  //                       ),
  //                     ),
  //                     Align(
  //                       alignment: Alignment.topRight,
  //                       child: InkWell(
  //                           onTap: (){
  //                             Navigator.pop(context);
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(top: 15.0,right: 15.0),
  //                             child: Icon(Icons.clear,color: AppColors.darkGreyColor1 ,size: 30.0,),
  //                           )
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             )
  //         );
  //       }
  //   ).then((value) {
  //     PrintLog.printLog("Value is: $value");
  //     if(value == true){
  //       ShareWidget.share(context: context,link: shareLink);
  //     }else if(value == false){
  //       LaunchUrlCustom.shareLinkOnWhatsapp(context: context, shareLink: shareLink);
  //     }
  //
  //   });
  // }
}

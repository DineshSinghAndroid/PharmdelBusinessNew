import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/Helper/Calender/calender.dart';
import '../../Controller/ProjectController/DeliverySchedule/driver_delivery_schedule_controller.dart';
import '../../Model/DriverRoutes/get_route_list_response.dart';
import '../../Model/GetDeliveryMasterData/get_delivery_master_data.dart';
import '../../Model/ParcelBox/parcel_box_response.dart';
import '../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../Model/ProcessScan/driver_process_scan.dart';

class DeliveryScheduleScreen extends StatefulWidget {
  final DriverProcessScanOrderInfo orderInfo;
  const DeliveryScheduleScreen({Key? key,required this.orderInfo}) : super(key: key);

  @override
  State<DeliveryScheduleScreen> createState() => _DeliveryScheduleScreenState();
}

class _DeliveryScheduleScreenState extends State<DeliveryScheduleScreen> {

  DriverDeliveryScheduleController delSchCtrl = Get.put(DriverDeliveryScheduleController());
  NursingHomeController nurHomeCtrl = Get.put(NursingHomeController());

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await delSchCtrl.assignOrderInfoData(orderInfo: widget.orderInfo);
    // await delSchCtrl.deliveryScheduleApi(context: context,pharmacyId: '0');
  }

  @override
  void dispose() {
    Get.delete<DriverDeliveryScheduleController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDeliveryScheduleController>(
      init: delSchCtrl,
      builder: (controller) {
        return WillPopScope(
          onWillPop: ()=> controller.onWillPop(context: context),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LoadScreen(
              widget: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBarCustom.appBarStyle2(
                  title: kDeliverySchedule,
                  centerTitle: false,
                  size: 18
                ),
                body: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      /// Customer Details
                      Visibility(
                        visible: controller.ctrlOrderInfo != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            BuildText.buildText(
                                text: "$kName${controller.ctrlOrderInfo?.firstName ?? ""} ${controller.ctrlOrderInfo?.middleName ?? ""} ${controller.ctrlOrderInfo?.lastName ?? ""}"),
                            buildSizeBox(controller.spaceBetweenCustomerDetail, 0.0),
                            BuildText.buildText(
                                text: "$kDob: ${controller.ctrlOrderInfo?.dob ?? ""}"),
                            buildSizeBox(controller.spaceBetweenCustomerDetail, 0.0),

                            BuildText.buildText(
                                text: "$kNHS: ${controller.ctrlOrderInfo?.nhsNumber ?? ""}"),
                            buildSizeBox(controller.spaceBetweenCustomerDetail, 0.0),

                            BuildText.buildText(
                                text: "$kPostCode: ${controller.ctrlOrderInfo?.postCode ?? ""}"),
                            buildSizeBox(controller.spaceBetweenCustomerDetail, 0.0),

                            BuildText.buildText(
                                text: "$kaddress: ${controller.ctrlOrderInfo?.address ?? ""}"),
                            buildSizeBox(controller.spaceBetweenCustomerDetail, 0.0),

                            BuildText.buildText(
                                text: "$kContact: ${controller.ctrlOrderInfo?.mobileNo ?? ""}"),
                            buildSizeBox(controller.spaceBetweenCustomerDetail, 0.0),

                            BuildText.buildText(
                                text: "$kEmail: ${controller.ctrlOrderInfo?.email ?? ""}"),
                            buildSizeBox(controller.spaceBetweenCustomerDetail, 0.0),

                          ],
                        ),
                      ),
                      Divider(color: AppColors.greyColorDark,),

                      /// Meds , Rx Image or Rx Details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [

                            /// Meds
                            DefaultWidget.deliveryScheduleTopWidget(
                              onTap: ()=> controller.onTapAddMedicine(),
                              icon: Icons.add,
                              title: kMeds,
                              bgColor: AppColors.blueColor,
                            ),
                            buildSizeBox(0.0, 10.0),

                            /// Rx Image
                            DefaultWidget.deliveryScheduleTopWidget(
                                onTap: ()=> controller.onTapRxImageBtn(context: context),
                                title: kRxImage,
                                bgColor: AppColors.colorOrange
                            ),
                            buildSizeBox(0.0, 10.0),

                            /// Rx Details
                            DefaultWidget.deliveryScheduleTopWidget(
                              title: kRxDetails,
                              bgColor: AppColors.greenDarkColor,
                              titleColor: AppColors.whiteColor,
                              onTap: ()=> controller.onTapRxDetails(context: context),
                            ),
                          ],
                        ),
                      ),

                      /// Rx Image List
                      Visibility(
                        visible: controller.rxImagesList.isNotEmpty,
                        child: Container(
                          height: 70,
                          width: Get.width,
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: controller.rxImagesList.length ?? 0,
                            itemBuilder: (BuildContext context, index) {
                              return  Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(color: Colors.grey)
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: Image.file(
                                              File(controller.rxImagesList[index].path ?? ""),
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.topCenter,
                                            ),
                                        )),
                                    Positioned(
                                      right: -5.0,
                                      top: -5.0,
                                      child: GestureDetector(
                                        onTap: ()=> controller.removeRxImage(index: index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red[400],
                                              borderRadius: BorderRadius.circular(50.0)
                                          ),
                                          child: const Icon(Icons.close,color: Colors.white,size: 17),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Divider(color: AppColors.greyColorDark,),

                      /// Select Service
                      Visibility(
                        visible: controller.drDashCtrl.deliveryMasterData != null && controller.drDashCtrl.deliveryMasterData?.services != null && controller.drDashCtrl.deliveryMasterData!.services!.isNotEmpty,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              '$kSelectService*',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),isExpanded: true,
                            items: controller.drDashCtrl.deliveryMasterData!.services!
                                .map((item) => DropdownMenuItem<DeliveryMasterDataShelf>(
                              value: item,
                              child: Text(
                                item.name ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )).toList(),
                            value: controller.selectedServices,
                            onChanged: (value)=> controller.onTapSelectService(value: value),
                            buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(controller.borderRadius),
                                    border: Border.all(color: AppColors.greyColor)
                                )
                            ),
                            menuItemStyleData: const MenuItemStyleData(),
                          ),
                        ),
                      ),

                      /// Bag size list
                      FittedBox(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10,bottom: 10),
                          height: 30,
                          child: Row(
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "$kBagSize ",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                    TextSpan(text: ":", style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.bagSizeList.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio(
                                        value: index,visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                        activeColor: AppColors.themeColor,
                                        groupValue: controller.bagSizeList.indexWhere((element) => element.isSelected == true),
                                        onChanged: (value)=>controller.onChangedBagSize(index: index),
                                      ),

                                      controller.bagSizeList[index].title != "C"
                                          ? BuildText.buildText(text: controller.bagSizeList[index].title)
                                          : const Icon(Icons.shopping_bag_outlined,size: 20,color: Colors.green),

                                      buildSizeBox(0.0, 10.0),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// Choose Date or Select Route
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: Get.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[

                            /// Select Date
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                      width: Get.width,
                                      height: 50,
                                      margin: const EdgeInsets.only(right: 15, top: 0, bottom: 0),
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(controller.borderRadius),
                                          border: Border.all(color: AppColors.greyColor)),
                                      child: InkWell(
                                          onTap: () async {
                                            PrintLog.printLog(driverType);
                                            if (driverType.toLowerCase() == kDedicatedDriver.toLowerCase()  && controller.drDashCtrl.isRouteStart) {
                                              return;
                                            }
                                            await controller.selectDate();
                                          },
                                          child: Container(
                                            height: 39,
                                            alignment: Alignment.centerLeft,
                                            child: RichText(
                                              text: TextSpan(
                                                style: Theme.of(context).textTheme.bodyText1,
                                                children: [
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 5, right: 10),
                                                      child: Image.asset(
                                                        strImgCalendar,
                                                        color: Colors.blueGrey,
                                                        fit: BoxFit.fill,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: controller.selectedDate == null ? kSchedule :
                                                      DateFormat("dd-MMM-yyyy").format(controller.selectedDate!),
                                                      style: const TextStyle(color: Colors.black87, fontSize: 13)
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      )
                                  )
                              ),

                            /// Route List
                              Visibility(
                                visible: controller.drDashCtrl.routeList != null && controller.drDashCtrl.routeList!.isNotEmpty,
                                child: Flexible(
                                  flex: 1,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      hint: Text(
                                        '$kSelectRoute*',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),isExpanded: true,
                                      items: controller.drDashCtrl.routeList!
                                          .map((item) => DropdownMenuItem<RouteList>(
                                        value: item,
                                        child: Text(
                                          item.routeName ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )).toList(),
                                      value: controller.selectedRoutePosition,
                                      onChanged: (value) => controller.onTapSelectRoute(route: value),
                                      buttonStyleData: ButtonStyleData(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(controller.borderRadius),
                                              border: Border.all(color: AppColors.greyColor)
                                          )
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      /// Select Driver && Select Status
                      Container(
                        height: 50,
                        width: Get.width,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10),

                        child: Row(
                          children: [

                            /// Select Driver
                              Visibility(
                                visible: controller.drDashCtrl.userType?.toLowerCase() == kPharmacy.toLowerCase() || controller.drDashCtrl.userType?.toLowerCase() == kPharmacyStaffString.toLowerCase(),
                                child: Flexible(
                                  flex: 1,
                                  child: controller.drDashCtrl.driverList.isNotEmpty
                                      ? DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      hint: Text(
                                        '$kSelectRoute*',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),isExpanded: true,
                                      items: controller.drDashCtrl.driverList
                                          .map((item) => DropdownMenuItem<DriverModel>(
                                        value: item,
                                        child: Text(
                                          item.firstName ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )).toList(),
                                      value: controller.selectedDriverPosition,
                                      onChanged: (value) => controller.onTapSelectDriver(context: context,value: value),
                                      buttonStyleData: ButtonStyleData(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(controller.borderRadius),
                                              border: Border.all(color: AppColors.greyColor)
                                          )
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(),
                                    ),
                                  )
                                      : Container(
                                        margin: const EdgeInsets.only(left: 2, bottom: 0, top: 5),
                                        alignment: Alignment.centerLeft,
                                        child: BuildText.buildText(text: kDriverNotAvailableSelectedRoute,color: AppColors.greyColor)
                                      )
                                ),
                              ),


                            if (controller.drDashCtrl.userType?.toLowerCase() == kPharmacy.toLowerCase() || controller.drDashCtrl.userType?.toLowerCase() == kPharmacyStaffString.toLowerCase())
                             buildSizeBox(0.0, 10.0),

                            Visibility(
                              visible: driverType.toLowerCase() == kDedicatedDriver.toLowerCase()
                                  ? !controller.drDashCtrl.isRouteStart
                                  ? true : false : true,

                              child: Flexible(
                                flex: 1,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      '$kSelectStatus*',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),isExpanded: true,
                                    items: controller.statusType
                                        .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    )).toList(),
                                    value: controller.selectedStatusType,
                                    onChanged: (value) => controller.onTapSelectOrderStatus(value: value),
                                    buttonStyleData: ButtonStyleData(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(controller.borderRadius),
                                            border: Border.all(color: AppColors.greyColor)
                                        )
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(),
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Select Nursing Home && Select Parcel Location
                      Container(
                        height: 50,
                        width: Get.width,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [

                            /// Nursing Home Select
                              Visibility(
                                visible: controller.drDashCtrl.deliveryMasterData != null && controller.drDashCtrl.deliveryMasterData?.nursingHomes != null && controller.drDashCtrl.deliveryMasterData!.nursingHomes!.isNotEmpty,
                                child: Flexible(
                                  flex: 1,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      hint: Text(
                                        kSelectNursHome,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),isExpanded: true,
                                      items: controller.drDashCtrl.deliveryMasterData!.nursingHomes!
                                          .map((item) => DropdownMenuItem<DeliveryMasterDataNursingHomes>(
                                        value: item,
                                        child: Text(
                                          item.nursingHomeName ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )).toList(),
                                      value: controller.selectedNursingHome,
                                      onChanged: (value) => controller.onTapSelectNursingHome(value: value),
                                      buttonStyleData: ButtonStyleData(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(controller.borderRadius),
                                              border: Border.all(color: AppColors.greyColor)
                                          )
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(),
                                    ),
                                  ),
                                ),
                              ),

                            if (controller.parcelBoxList != null && controller.parcelBoxList!.isNotEmpty && controller.selectedStatusType?.toLowerCase() == kPickedUp2.toLowerCase())
                              buildSizeBox(0.0, 15.0),

                              /// Parcel Box select
                              Visibility(
                                visible: controller.parcelBoxList != null && controller.parcelBoxList!.isNotEmpty && controller.selectedStatusType?.toLowerCase() == kPickedUp2.toLowerCase(),
                                child: Flexible(
                                  flex: 1,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      hint: Text(
                                        kParcelLocation,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),isExpanded: true,
                                      items: controller.parcelBoxList!
                                          .map((item) => DropdownMenuItem<ParcelBoxData>(
                                        value: item,
                                        child: Text(
                                          item.name ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )).toList(),
                                      value: controller.selectedParcelBox,
                                      onChanged: (value) => controller.onTapSelectParcelBox(value: value),
                                      buttonStyleData: ButtonStyleData(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(controller.borderRadius),
                                              border: Border.all(color: AppColors.greyColor)
                                          )
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      /// Subscription select or Delivery charge ctrl
                      Visibility(
                          visible: controller.drDashCtrl.selectedPharmacyInfo != null && controller.drDashCtrl.selectedPharmacyInfo?.isDelCharge != null &&  controller.drDashCtrl.selectedPharmacyInfo?.isDelCharge == "1",
                          child: Container(
                            height: 50,
                            width: Get.width,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                /// Select Delivery Subscription
                                Visibility(
                                  visible: controller.drDashCtrl.deliveryMasterData != null && controller.drDashCtrl.deliveryMasterData?.patientSubscriptions != null && controller.drDashCtrl.deliveryMasterData!.patientSubscriptions!.isNotEmpty,
                                  child: Flexible(
                                    flex: 1,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        hint: Text(
                                          '$kSelectSubscription*',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        isExpanded: true,
                                        items: controller.drDashCtrl.deliveryMasterData!.patientSubscriptions!
                                            .map((item) => DropdownMenuItem<DeliveryMasterDataPatientSubscriptions>(
                                          value: item,
                                          child: Text(
                                            item.name ?? "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        )).toList(),
                                        value: controller.selectedSubscriptions,
                                        onChanged: (value) => controller.onTapSelectSubscription(value: value),
                                        buttonStyleData: ButtonStyleData(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(controller.borderRadius),
                                                border: Border.all(color: AppColors.greyColor)
                                            )
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(),
                                      ),
                                    ),
                                  ),
                                ),

                                if (controller.selectedSubscriptions?.name == 'Per Delivery')
                                  buildSizeBox(0.0, 15.0),

                                  /// Show Delivery Charge TextField
                                  Visibility(
                                    visible: controller.selectedSubscriptions?.name == 'Per Delivery',
                                    child: Flexible(
                                      flex: 1,
                                      child: Container(
                                        width: Get.width,
                                        height: 50,
                                        margin: const EdgeInsets.only(right: 0, top: 0, bottom: 0),
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(controller.borderRadius),
                                            border: Border.all(color: AppColors.greyColor)),
                                        child: TextField(
                                          controller: controller.deliveryChargeController,
                                          minLines: 1,
                                          maxLines: null,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),

                              ],
                            ),
                          ),
                        ),

                      /// Fridge , CD, Paid or Exempt
                      Container(
                        height: 50,
                        width: Get.width,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[

                            /// Fridge
                            DefaultWidget.checkBoxWithWidget(
                              onChanged: (e)=>controller.onTapFridge(),
                                onTap: ()=>controller.onTapFridge(),
                                isSelected: controller.isFridgeSelected,
                                bgColor: AppColors.blueColor,
                                title: kFridge
                            ),
                            buildSizeBox(0.0, 10.0),

                            /// CD
                            DefaultWidget.checkBoxWithWidget(
                                onChanged: (e)=>controller.onTapCD(),
                                onTap: ()=>controller.onTapCD(),
                                isSelected: controller.isCdSelected,
                                bgColor: AppColors.redColor,
                                title: "C.D."
                            ),
                            buildSizeBox(0.0, 10.0),

                            /// Paid
                            DefaultWidget.checkBoxWithWidget(
                                onChanged: (e)=>controller.onTapPaid(context: context),
                                onTap: ()=>controller.onTapPaid(context: context),
                                isSelected: controller.selectedPaidData != null,
                                bgColor: AppColors.themeColor,
                                title: kPaid
                            ),
                            buildSizeBox(0.0, 10.0),

                            /// Exempt
                            Visibility(
                              visible: controller.drDashCtrl.deliveryMasterData != null && controller.drDashCtrl.deliveryMasterData?.exemptions != null && controller.drDashCtrl.deliveryMasterData!.exemptions!.isNotEmpty,
                              child: InkWell(
                                onTap: ()=> controller.onTapExempt(context: context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: AppColors.greenColor,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      SizedBox(
                                        height: 20,
                                        width: 25,
                                        child: Checkbox(
                                          activeColor: AppColors.themeColor,
                                          visualDensity: const VisualDensity(horizontal: -4),
                                          value: controller.selectedExemption != null ? true:false,
                                          onChanged: (newValue) {
                                            if(controller.selectedExemption != null){
                                              controller.onRemoveExempt();
                                            }else{
                                              controller.onTapExempt(context: context);
                                            }
                                          },
                                        ),
                                      ),
                                      BuildText.buildText(
                                          text: "$kExempt ${controller.selectedExemption != null && controller.selectedExemption?.serialId.toString() != "null" ? ": ${controller.selectedExemption?.serialId}" : ""}",
                                          color: AppColors.whiteColor
                                      ),

                                      const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),




                          ],
                        ),
                      ),

                      /// Existing Delivery Note
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BuildText.buildText(
                              text: kExistingDeliveryNote,color: AppColors.blueDeliveryNoteColor,size: 16
                          ),
                          buildSizeBox(2.0, 0.0),

                          Container(
                            width: Get.width,
                            height: 50,
                            margin: const EdgeInsets.only(right: 0, top: 0, bottom: 10),
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(controller.borderRadius),
                                border: Border.all(color: AppColors.greyColor)
                            ),
                            child: TextField(
                              controller: controller.existingNoteController,
                              minLines: 1,
                              maxLines: null,
                              readOnly: false,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: kExistingDeliveryNote
                              ),

                            ),
                          ),
                        ],
                      ),

                      /// Delivery Note
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BuildText.buildText(
                              text: kDeliveryNote,color: AppColors.blueDeliveryNoteColor,size: 16
                          ),

                          buildSizeBox(2.0, 0.0),

                          Container(
                            width: Get.width,
                            height: 50,
                            margin: const EdgeInsets.only(right: 0, top: 0, bottom: 10),
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(controller.borderRadius),
                                border: Border.all(color: AppColors.greyColor)
                            ),
                            child: TextField(
                              controller: controller.deliveryNoteController,
                              minLines: 1,
                              maxLines: null,
                              readOnly: false,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: kDeliveryNote
                              ),

                            ),
                          ),
                        ],
                      ),





                    ],
                  ),
                ),

                /// Book Delivery Button
                bottomNavigationBar: InkWell(
                  onTap: ()=> controller.onTapBookDelivery(context: context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.blueColorLight,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: BuildText.buildText(text: kBookDelivery,color: AppColors.whiteColor,size: 15,weight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              isLoading: controller.isLoading,
            ),
          ),
        );
        },
    );
  }
}
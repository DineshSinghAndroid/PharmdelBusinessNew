import 'package:countdown_widget/countdown_widget.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Redirect/redirect.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/Helper/ConnectionValidator/internet_check_return.dart';
import '../../../Controller/ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../../../Controller/StopWatchController/stop_watch_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/DeliveryCardCustom/deliveryCardCustom.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({Key? key}) : super(key: key);

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen>  with WidgetsBindingObserver implements BulkScanMode {

  DriverDashboardCTRL drDashCtrl = Get.put(DriverDashboardCTRL());


@override
void isSelected(bool isSelect) {
  // TODO: implement isSelected
}


 @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
  drDashCtrl.isAvlInternet = await InternetCheck.checkStatus();
  if(drDashCtrl.isAvlInternet) {
    await drDashCtrl.driverRoutesApi(context: context).then((value) async {
        await drDashCtrl.getParcelBoxApi(context: context).then((value) async {
          await drDashCtrl.vehicleListApi(context: context).then((value) async {
            await drDashCtrl.getDeliveryMasterData(context: context).then((value) async {
              if(driverType.toLowerCase() != kSharedDriver.toLowerCase()){
                await drDashCtrl.getPharmacyInfo(context: context).then((value) async {

                });
              }
            });
          });
        });
      });
  }

      drDashCtrl.onAssignPreviewsRout(context: context);

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardCTRL>(
      init: drDashCtrl,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async => false,
          child: LoadScreen(
            isLoaderChange: true,
            widget: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColors.whiteColor,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: AppColors.colorOrange,
                  iconTheme: IconThemeData(color: AppColors.blackColor),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 0),
                      child: Row(
                        children: [

                          /// Bulk Scan
                          BuildText.buildText(text: kBulkScan, size: 15),
                          Switch(
                            onChanged: (bool value) => controller.isBulkScanSwitchedValue(value),
                            value: controller.isBulkScanSwitched,
                            activeColor: Colors.blue,
                            activeTrackColor: Colors.blue,
                            inactiveThumbColor: Colors.black,
                            inactiveTrackColor: Colors.grey[400],
                          ),

                          /// Refresh
                          Visibility(
                            visible: controller.isRouteStart == false,
                            child: InkWell(
                                onTap: () => controller.onTapAppBarRefresh(context:context),
                                child: const Icon(Icons.refresh)
                            ),
                          ),

                          buildSizeBox(0.0, 10.0),

                          /// Map Navigate
                          controller.orderListType == 4 && controller.isRouteStart ?
                          InkWell(
                              onTap: ()=> controller.onTapAppBarMap(context: context),
                              child: Image.asset(strIMG_location,height: 25,color: AppColors.redColor,)
                          )
                          : const SizedBox.shrink(),

                          /// QR code
                          Visibility(
                            visible: controller.driverDashboardData?.orderCounts?.totalOrders != null && int.parse(controller.driverDashboardData?.orderCounts?.totalOrders.toString() ?? "0") > 0  && controller.isRouteStart == false,
                            child: InkWell(
                                onTap: ()=> controller.onTapAppBarQrCode(context: context),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(left: 0, right: 10),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
                                        child: Image.asset(strImgQrCode,
                                          color: AppColors.blackColor,
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            color: AppColors.deepOrangeColor2
                                        ),
                                        child: BuildText.buildText(
                                            text: controller.driverDashboardData?.orderCounts?.totalOrders?.toString() ?? "",
                                          weight: FontWeight.w300,size: 12
                                        )
                                      )
                                    ],
                                  ),
                                )
                                // Image.asset(strIMG_location,height: 25,color: AppColors.redColor,)
                            ),
                          ),


                          buildSizeBox(0.0, 10.0),

                          /// Notification
                          InkWell(
                              onTap: () {
                                Get.toNamed(notificationScreenRoute);
                              },
                              child: Stack(
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.notifications,
                                      size: 30,
                                    ),
                                  ),
                                  Visibility(
                                    visible: controller.driverDashboardData != null && controller.driverDashboardData?.notificationCount != null && controller.driverDashboardData!.notificationCount! > 0,
                                    child: Positioned(
                                      right: 1,
                                      top: 12,
                                      child: SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.redColor,
                                          child: BuildText.buildText(
                                            text: controller.driverDashboardData?.notificationCount != null && controller.driverDashboardData!.notificationCount! > 99
                                                ? "+99"
                                                : controller.driverDashboardData?.notificationCount?.toString() ?? ""
                                                ,
                                            size: 9,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                drawer:  DrawerDriver(),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: driverType.toLowerCase() == kDedicatedDriver.toLowerCase(),
                      child: Padding(
                        padding: EdgeInsets.only(left: controller.isRouteStart && controller.systemDeliveryTime != null && controller.stopWatchTimer != null ? Get.width * 24 / 100 : 0.0),
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.orange,
                          label: Column(
                            children: [
                              const Icon(Icons.qr_code_scanner,color: Colors.white,size: 25.0,),
                              BuildText.buildText(text: kScanQr, color: AppColors.whiteColor)
                            ],
                          ),
                          onPressed: () => controller.onTapScanRx(context: context),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.isRouteStart && controller.systemDeliveryTime != null && controller.stopWatchTimer != null && controller.stopWatchTimer?.rawTime != null,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 7.0, bottom: 7.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: controller.showIncreaseTime ? Colors.red : AppColors.timeLeftColor,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), spreadRadius: 3.0, blurRadius: 5.0, offset: const Offset(0, 2))]),
                          child: CountDownWidget(
                            duration: Duration(seconds: controller.systemDeliveryTime ?? 0),
                            builder: (context, duration) {
                              controller.systemDeliveryTime = duration.inSeconds;
                              AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.deliveryTime, variableValue: duration.inSeconds.toString());
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BuildText.buildText(text: kTimeLeft,color: AppColors.whiteColor),
                                  buildSizeBox(1.0, 0.0),

                                  StreamBuilder<int>(
                                    stream: controller.stopWatchTimer?.rawTime,
                                    initialData: 0,
                                    builder: (context, snap) {
                                      final value = snap.data;
                                      final displayTime = StopWatchTimer.getDisplayTime(value ?? 0, milliSecond: false);

                                      return BuildText.buildText(
                                          text: controller.showIncreaseTime ? "+ $displayTime" : displayTime,
                                          color: controller.showIncreaseTime ? AppColors.redColor : AppColors.whiteColor, weight: FontWeight.bold
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            onFinish: () {

                            },
                            onExpired: () {
                              // showBottomSheetTimesUp(context);
                            },
                          ),
                        ),
                    )
                  ],
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: Stack(
                  fit: StackFit.expand,
                  children: [

                    /// Background image
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(strIMG_HomeBg)
                    ),


                    /// Body
                    Column(
                      children: [

                        /// Select route or Parcel Location
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [

                              /// Select route
                              Expanded(
                                child: WidgetCustom.driverDasTopSelectWidget(
                                  title: controller.selectedRoute != null ? controller.selectedRoute?.routeName.toString() ?? "" : kSelectRoute,
                                  onTap:()=> controller.onTapSelectRoute(context:context,controller:controller),
                                ),
                              ),
                              buildSizeBox(0.0, 5.0),

                              /// Select Pharmacy only for Shared driver case
                              Visibility(
                                visible: driverType.toLowerCase() == kSharedDriver.toLowerCase(),
                                child: Expanded(
                                  child: WidgetCustom.driverDasTopSelectWidget(
                                    title: controller.selectedPharmacy != null ? controller.selectedPharmacy?.pharmacyName.toString() ?? "" : kSelectPhar,
                                    onTap:()=> controller.onTapSelectPharmacy(context:context,controller:controller),
                                  ),
                                ),
                              ),

                              /// Select Parcel box
                              Visibility(
                                visible: controller.isBulkScanSwitched == true && driverType.toLowerCase() != kSharedDriver.toLowerCase(),
                                child: Expanded(
                                  child: WidgetCustom.driverDasTopSelectWidget(
                                      title: controller.selectedParcelBox != null ? controller.selectedParcelBox?.name.toString() ?? "" : kParcelLocation,
                                      onTap:()=> controller.onTapSelectParcelLocation(context:context,controller:controller),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        /// Select Parcel Location only for shared driver
                        Visibility(
                          visible: controller.isBulkScanSwitched == true && driverType.toLowerCase() == kSharedDriver.toLowerCase(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [

                                /// Select Parcel box
                                Expanded(
                                  child: WidgetCustom.driverDasTopSelectWidget(
                                      title: controller.selectedParcelBox != null ? controller.selectedParcelBox?.name.toString() ?? "" : kParcelLocation,
                                      onTap:()=> controller.onTapSelectParcelLocation(context:context,controller:controller),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        ///Top counter widgets
                        Container(
                          width: Get.width,
                          margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// Total
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: DefaultWidget.topCounter(
                                          bgColor: AppColors.blueColor,
                                          label: kTotal,
                                          selectedTopBtnName: controller.selectedTopBtnName,
                                          counter: controller.driverDashboardData?.orderCounts?.totalOrders ?? "0",
                                          onTap: () => controller.onTapManTopDeliveryListBtn(context:context,btnType: 1),
                                      )
                              ),

                              /// Picked up or On the way
                              controller.isRouteStart ?
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: DefaultWidget.topCounter(
                                      bgColor: AppColors.yetToStartColor,
                                      label: kOnTheWay,
                                      selectedTopBtnName: controller.selectedTopBtnName,
                                      // counter: controller.driverDashboardData?.orderCounts?.outForDeliveryOrders ?? "0",
                                      counter: controller.orderListType == 4 ? controller.driverDashboardData != null && controller.driverDashboardData?.deliveryList != null && controller.driverDashboardData!.deliveryList!.isNotEmpty ? controller.isNextPharmacyAvailable != null && controller.isNextPharmacyAvailable! >= 0 ? "${controller.driverDashboardData!.deliveryList!.length - 1 }": "${controller.driverDashboardData?.deliveryList?.length}" : "0":controller.driverDashboardData?.orderCounts?.outForDeliveryOrders ?? "0",
                                      onTap: () => controller.onTapManTopDeliveryListBtn(context:context,btnType: 4),
                                      )) :
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: DefaultWidget.topCounter(
                                      bgColor: AppColors.textFieldBorderColor,
                                      label: kPickedUp,
                                      selectedTopBtnName: controller.selectedTopBtnName,
                                      counter: controller.driverDashboardData?.orderCounts?.pickedupOrders ?? "0",
                                      onTap: () => controller.onTapManTopDeliveryListBtn(context:context,btnType: 8),
                                      )),

                              /// Delivered
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: DefaultWidget.topCounter(
                                      bgColor: AppColors.greenDarkColor,
                                      label: kDelivered,
                                      selectedTopBtnName: controller.selectedTopBtnName,
                                      counter: controller.driverDashboardData?.orderCounts?.deliveredOrders ?? "0",
                                      onTap: () => controller.onTapManTopDeliveryListBtn(context:context,btnType: 5),
                                      )),

                              /// Failed
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: DefaultWidget.topCounter(
                                      bgColor: AppColors.redColor,
                                      label: kFailed,
                                      selectedTopBtnName: controller.selectedTopBtnName,
                                      counter: controller.driverDashboardData?.orderCounts?.faildOrders ?? "0",
                                      onTap: () => controller.onTapManTopDeliveryListBtn(context:context,btnType: 6),
                                      )),
                            ],
                          ),
                        ),

<<<<<<< HEAD
=======
                        controller.driverDashboardData != null &&
                            controller.driverDashboardData?.deliveryList != null &&
                            controller.driverDashboardData!.deliveryList!.isNotEmpty ?
                        ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 20,left: 8,right: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.driverDashboardData?.deliveryList?.length ?? 0,
                          itemBuilder: (context, i) {
                            return
                            DeliveryCardCustom(
                              /// onTap
                             onTap: ()=> controller.onTapDeliveryListItem(context: context,index: i),

                              /// onTap Route
                              onTapRoute: (){
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a

                        Visibility(
                          visible: controller.orderListType == 6 && controller.driverDashboardData?.deliveryList != null && controller.driverDashboardData!.deliveryList!.isNotEmpty ,
                            child: Container(
                              width: Get.width,
                              height: 50,
                              margin: const EdgeInsets.only(left: 10,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DelayedDisplay(
                                    child: DefaultWidget.squareButton(
                                        bgColor: AppColors.deepOrangeColor,
                                        label: controller.isAllSelected ? kUnSelectAll:kSelectAll,
                                        onTap: ()=> controller.onTapSelectAllFailed(context: context)
                                    ),
                                  ),
                                  Visibility(
                                    visible: controller.isShowReschedule,
                                    child: DelayedDisplay(
                                      child: DefaultWidget.squareButton(
                                          bgColor: AppColors.deepOrangeColor,
                                          label: kRescheduleNow,
                                          onTap: ()=> controller.onTapRescheduleNowFailed(context: context)

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),

                        controller.driverDashboardData != null && controller.driverDashboardData?.deliveryList != null && controller.driverDashboardData!.deliveryList!.isNotEmpty ?
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 20,left: 8,right: 8,bottom: 100),
                            physics: const ClampingScrollPhysics(),
                            itemCount: controller.driverDashboardData?.deliveryList?.length ?? 0,
                            itemBuilder: (context, i) {

                              return
                              DeliveryCardCustom(
                                /// onTap
                               onTap: ()=> controller.onTapDeliveryListItem(context: context,index: i),

                                /// onTap Manual
                                onTapManual: ()=> controller.onTapManualDelivery(context: context,index: i),

                                /// onTap Route
                                onTapRoute: ()=>
                                    RedirectCustom.mapRedirectWithCustomerAddress(
                                        latitude: controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.latitude ?? "0.0",
                                        longitude: controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.longitude ?? "0.0",
                                        customerDetailAddress: controller.driverDashboardData?.deliveryList?[i].customerDetials?.address ?? "",
                                        customerDetailAddress1: controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.address1 ?? controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.address2 ?? ""
                                    ),

                                /// onTap Make Next
                                onTapMakeNext: ()=> controller.onTapMakeNextOrder(context: context,orderData: controller.driverDashboardData?.deliveryList?[i],),

                                /// onTap DeliverNow
                                onTapDeliverNow: ()=> controller.onTapDeliverNow(context: context,index: i),

                                /// Customer Detail
                                customerName: "${controller.driverDashboardData?.deliveryList?[i].customerDetials?.title ?? ""} ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.firstName ?? ""} ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.middleName ?? ""}  ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.lastName ?? ""}",
                                customerAddress: "${controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.address1 ?? controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.address2 ?? ""} ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.postCode ?? ""}",
                                altAddress: controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.alt_address ?? "",
                                driverType: driverType,

                                isBulkScanSwitched: controller.isBulkScanSwitched,
                                isSelected: controller.driverDashboardData?.deliveryList?[i].isSelected ?? false,
                                nursingHomeId: controller.driverDashboardData?.deliveryList?[i].nursing_home_id ?? "",
                                pharmacyName: controller.driverDashboardData?.deliveryList?[i].pharmacyName ?? "",
                                index: i,
                                bagSize: controller.driverDashboardData?.deliveryList?[i].bagSize ?? "",

                                /// Order Detail
                                orderListType: controller.orderListType,
                                orderId: controller.driverDashboardData?.deliveryList?[i].orderId ?? "",
                                deliveryStatus: controller.driverDashboardData?.deliveryList?[i].status ?? "",
                                isControlledDrugs: controller.driverDashboardData?.deliveryList?[i].isControlledDrugs ?? "",
                                isCronCreated: controller.driverDashboardData?.deliveryList?[i].isCronCreated ?? "",
                                isStorageFridge: controller.driverDashboardData?.deliveryList?[i].isStorageFridge ?? "",
                                parcelBoxName: controller.driverDashboardData?.deliveryList?[i].parcelBoxName ?? "",
                                serviceName: controller.orderListType == 4 ? (controller.driverDashboardData?.deliveryList?[i].serviceName ?? "").toString() : (controller.driverDashboardData?.deliveryList?[i].customerDetials?.service_name ?? "").toString() ,
                                pmrId: controller.driverDashboardData?.deliveryList?[i].pr_id ?? "",
                                pmrType: controller.driverDashboardData?.deliveryList?[i].pmr_type ?? "",
                                rescheduleDate: controller.driverDashboardData?.deliveryList?[i].rescheduleDate ?? "",

                                /// PopUp Menu
                                popUpMenu: [
                                   WidgetCustom.popUpMenuItems(
                                      context: context,
                                      isCheckedCD: controller.driverDashboardData?.deliveryList?[i].isControlledDrugs.toString() == "t" ? true:false ,
                                      isCheckedFridge: controller.driverDashboardData?.deliveryList?[i].isStorageFridge.toString() == "t" ? true:false ,
                                  )
                                ],
                                onPopUpMenuSelected: (value)=> controller.onTapPopUpMenuSelection(context: context,value: value,index: i),


                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 15),
                              ) ;
                            },
                          ),
                        ) :
                        controller.isLoading == false && controller.isRouteStart == false && driverType.toLowerCase() == kSharedDriver.toLowerCase() && controller.selectedPharmacy == null && controller.selectedRoute?.routeId != null?
                        SizedBox(
                            height: getHeightRatio(value: 50),
                            width: getWidthRatio(value: 50),
                            child: Center(
                                child: BuildText.buildText(
                                    text: kSelectPharmacyFirst
                                )
                            )
                        ) :
                        controller.isLoading == false && controller.isRouteStart == false && controller.selectedRoute?.routeId != null ?
                        SizedBox(
                            height: getHeightRatio(value: 50),
                            width: getWidthRatio(value: 50),
                            child: Center(
                                child: BuildText.buildText(
                                    text: "${controller.orderListType == 1 ? kReady : controller.orderListType == 8 ? kPickedUp : controller.orderListType == 4 ? kOnTheWay : controller.orderListType == 5 ? kCompleted : controller.orderListType == 6 ? kFailed : ""} $kOrderNotFound"
                                )
                            )
                        ) :
                        controller.isLoading == false && controller.isRouteStart == false ?
                        SizedBox(
                          height: getHeightRatio(value: 50),
                            width: getWidthRatio(value: 50),
                            child: Center(
                                child: BuildText.buildText(
                                    text: kSelectRouteFirst
                                )
                            )
                        ) : const SizedBox.shrink(),

                        // Visibility(
                        //   visible: isVisiblePharmacyList,
                        //   child: Container(
                        //     margin: const EdgeInsets.only(top: 0, bottom: 10),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(5.0),
                        //         color: Colors.white,
                        //         boxShadow: [
                        //           BoxShadow(
                        //               spreadRadius: 1,
                        //               blurRadius: 10,
                        //               offset: const Offset(0, 4),
                        //               color: Colors.grey.shade300)
                        //         ]),
                        //     child: Column(
                        //       children: [
                        //         ListView.separated(
                        //           itemCount: controller.routesData?.pharmacyList?.length ?? 0,
                        //           shrinkWrap: true,
                        //           physics: const NeverScrollableScrollPhysics(),
                        //           itemBuilder: (context, index) {
                        //             // PharmacyList pharmacy = pharmacyList[index];
                        //             return InkWell(
                        //               onTap: () {
                        //                 // setState(() {
                        //                 //   selectedPharmacyDropDown =
                        //                 //   pharmacyList[index];
                        //                 //   _selectedPharmacyPosition = index;
                        //                 // });
                        //               },
                        //               child: Container(
                        //                 width: MediaQuery.of(context).size.width,
                        //                 padding: const EdgeInsets.only(left: 13.0,right: 10.0,top: 12,bottom: 12),
                        //                 color:
                        //                 // pharmacy == selectedPharmacyDropDown //route == selectedRoute//_selectedRoutePosition == index ?
                        //                 Colors.blue[50],
                        //                 // : Colors.transparent,
                        //                 child: BuildText.buildText(
                        //                   text: controller.routesData?.pharmacyList?[index].pharmacyName ?? "",
                        //                   size: 14,
                        //                   color: AppColors.blueColorLight,
                        //                   weight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //           separatorBuilder: (BuildContext context, int index) {
                        //             return const Divider(height: 1);
                        //           },
                        //         ),
                        //         const Divider(height: 1),
                        //         Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12, bottom: 12),
                        //           child: Row(
                        //             children: [
                        //               Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: InkWell(
                        //                   onTap: () {
                        //                     setState(() {
                        //                       // selectedPharmacyDropDown =
                        //                       //     selectedPharmacy;
                        //                       // _isVisiblePharmacyList = false;
                        //                       // hideTote = false;
                        //                     });
                        //                   },
                        //                   child: BuildText.buildText(
                        //                       text: kCancel,
                        //                       size: 14,
                        //                       weight: FontWeight.w800,
                        //                       color: AppColors.redColor,
                        //                       textAlign: TextAlign.center
                        //                   ),
                        //                 ),
                        //               ),
                        //               Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: InkWell(
                        //                   onTap: () {
                        //                     // if (_selectedPharmacyPosition < 0) {
                        //                     //   Fluttertoast.showToast(
                        //                     //       msg: "Choose Pharmacy First");
                        //                     //   return;
                        //                     // }
                        //                     // setState(() {
                        //                     //   _isVisiblePharmacyList = false;
                        //                     //   selectedPharmacy =
                        //                     //   pharmacyList[_selectedPharmacyPosition];
                        //                     //   pharmacyId =
                        //                     //   "${selectedPharmacy.pharmacyId}";
                        //                     //   hideTote = false;
                        //                     // });
                        //                   },
                        //                   child: BuildText.buildText(
                        //                       text: kConfirm,
                        //                       size: 14,
                        //                       color: AppColors.greenAccentColor,
                        //                       weight: FontWeight.w800,
                        //                       textAlign: TextAlign.center
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        ///Parcel Location
                        // Visibility(
                        //   visible: isToteList,
                        //   child: Container(
                        //     margin: const EdgeInsets.only(top: 0, bottom: 10),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(5.0),
                        //         color: Colors.white,
                        //         //border: Border.all(color: Colors.grey[400]),
                        //         boxShadow: [
                        //           BoxShadow(
                        //               spreadRadius: 1,
                        //               blurRadius: 10,
                        //               offset: const Offset(0, 4),
                        //               color: Colors.grey.shade300)
                        //         ]),
                        //     child: Column(
                        //       children: [
                        //         ListView.separated(
                        //           itemCount: 2,
                        //           // parcelBoxList != null &&
                        //           //     parcelBoxList.isNotEmpty
                        //           //     ? parcelBoxList.length
                        //           //     : 0,
                        //           shrinkWrap: true,
                        //           physics: const NeverScrollableScrollPhysics(),
                        //           itemBuilder: (context, index) {
                        //             // ParcelBoxData nusingList = parcelBoxList[index];
                        //             return InkWell(
                        //               onTap: () {
                        //                 // setState(() {
                        //                 //   totePosition = index;
                        //                 // });
                        //               },
                        //               child: Container(
                        //                 width: MediaQuery.of(context).size.width,
                        //                 padding: const EdgeInsets.only(left: 13.0,right: 10.0,top: 12,bottom: 12),
                        //                 color:
                        //                 // totePosition ==
                        //                 //     index //route == selectedRoute//_selectedRoutePosition == index ?
                        //                 AppColors.blueColor,
                        //                 // : Colors.transparent,
                        //                 child: BuildText.buildText(
                        //                   text: kParcelLocation,
                        //                   size: 14,
                        //                   color: AppColors.blueColorLight,
                        //                   weight: FontWeight.w400,
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //           separatorBuilder: (BuildContext context, int index) {
                        //             return const Divider(height: 1);
                        //           },
                        //         ),
                        //         const Divider(height: 1),
                        //         Container(
                        //           width: MediaQuery.of(context).size.width,
                        //           padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12, bottom: 12),
                        //           child: Row(
                        //             children: <Widget>[
                        //               Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: InkWell(
                        //                   onTap: () {
                        //                     // setState(() {
                        //                     //   _isToteList = false;
                        //                     //   hideTote = false;
                        //                     // });
                        //                   },
                        //                   child: BuildText.buildText(
                        //                     text: kCancel,
                        //                     size: 14,
                        //                     color: AppColors.redColor,
                        //                     weight: FontWeight.w800,
                        //                   ),
                        //                 ),
                        //               ),
                        //               Flexible(
                        //                 flex: 1,
                        //                 fit: FlexFit.tight,
                        //                 child: InkWell(
                        //                   onTap: () {
                        //                     // if (totePosition < 0) {
                        //                     //   Fluttertoast.showToast(
                        //                     //       msg: "Choose Nursing Home");
                        //                     //   return;
                        //                     // }
                        //                     // setState(() {
                        //                     //   _isToteList = false;
                        //                     //   _selectedTotePosition = totePosition;
                        //                     //   logger.i(_selectedTotePosition);
                        //                     //   hideTote = false;
                        //                     // });
                        //                   },
                        //                   child: BuildText.buildText(
                        //                     text: kConfirm,
                        //                     size: 14,
                        //                     color: AppColors.greenColor,
                        //                     weight: FontWeight.w800,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    ///Select Route
                    // Positioned(
                    //   top: 60,
                    //   child: Visibility(
                    //     visible: isVisibleRouteList,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    //       child: Container(
                    //         height: 350,
                    //         margin: const EdgeInsets.only(top: 0, bottom: 10),
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(5.0),
                    //             color: AppColors.whiteColor,
                    //             boxShadow: [
                    //               BoxShadow(
                    //                   spreadRadius: 1,
                    //                   blurRadius: 10,
                    //                   offset: const Offset(0, 4),
                    //                   color: Colors.grey.shade300)
                    //             ]),
                    //         child: Column(
                    //           children: [
                    //             SizedBox(
                    //               height: 300,
                    //               width: Get.width,
                    //               child: ListView.separated(
                    //                 itemCount: controller.routesData?.routeList?.length ?? 0,
                    //                 // routeList.length,
                    //                 shrinkWrap: true,
                    //                 physics: const AlwaysScrollableScrollPhysics(),
                    //                 itemBuilder: (context, index) {
                    //                   // RouteList route = routeList[index];
                    //                   return InkWell(
                    //                     onTap: () {
                    //                       // setState(() {
                    //                       //   selectedRouteDropDown = routeList[index];
                    //                       //   _selectedRoutePosition = index;
                    //                       // });
                    //                     },
                    //                     child: Container(
                    //                       width: MediaQuery.of(context).size.width,
                    //                       padding: const EdgeInsets.only(left: 13.0,right: 10.0,top: 12,bottom: 12),
                    //                       color:
                    //                       // route ==
                    //                       // selectedRouteDropDown //route == selectedRoute//_selectedRoutePosition == index
                    //                       // ?
                    //                       Colors.blue[50],
                    //                       // : Colors.transparent,
                    //                       child: BuildText.buildText(
                    //                         text: controller.routesData?.routeList?[index].routeName ?? "",
                    //                         // "${route.routeName ?? "Select Pharmacy"}",
                    //                         size: 14,
                    //                         color: AppColors.blueColorLight,
                    //                         weight: FontWeight.w400,
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //                 separatorBuilder: (BuildContext context, int index) {
                    //                   return const Divider(height: 1);
                    //                 },
                    //               ),
                    //             ),
                    //             const Divider(height: 1),
                    //             Container(
                    //               width: MediaQuery.of(context).size.width,
                    //               padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12, bottom: 12),
                    //               child: Row(
                    //                 children: <Widget>[
                    //                   Flexible(
                    //                     flex: 1,
                    //                     fit: FlexFit.tight,
                    //                     child: InkWell(
                    //                       onTap: () {
                    //                         // setState(() {
                    //                         //   selectedRouteDropDown = selectedRoute;
                    //                         //   _isVisibleRouteList = false;
                    //                         //   hideTote = false;
                    //                         // });
                    //                       },
                    //                       child: BuildText.buildText(
                    //                           text: kCancel,
                    //                           size: 14,
                    //                           color: AppColors.redColor,
                    //                           weight: FontWeight.w800,
                    //                           textAlign: TextAlign.center
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Flexible(
                    //                     flex: 1,
                    //                     fit: FlexFit.tight,
                    //                     child: InkWell(
                    //                       onTap: () {
                    //                         // if (_selectedRoutePosition < 0) {
                    //                         //   Fluttertoast.showToast(
                    //                         //       msg: "Choose Route First");
                    //                         //   return;
                    //                         // }
                    //                         // setState(() {
                    //                         //   selectedType =
                    //                         //       WebConstant.Status_total;
                    //                         //   _isVisibleRouteList = false;
                    //                         //   hideTote = false;
                    //                         //   selectedRoute =
                    //                         //   routeList[_selectedRoutePosition];
                    //
                    //                         //   routeId = "${selectedRoute.routeId}";
                    //                         //   SharedPreferences.getInstance().then((
                    //                         //       value) {
                    //                         //     value.setString(
                    //                         //         WebConstant.ROUTE_ID, routeId);
                    //                         //   });
                    //                         //   setState(() {
                    //                         //     isProgressAvailable = true;
                    //                         //   });
                    //                         //   orderListType = 1;
                    //                         //   fetchDeliveryList(0);
                    //                         // });
                    //                       },
                    //                       child: BuildText.buildText(
                    //                           text: kConfirm,
                    //                           size: 14,
                    //                           color: AppColors.greenAccentColor,
                    //                           weight: FontWeight.w800,
                    //                           textAlign: TextAlign.center
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                /// Bottom Navigation bar
                bottomNavigationBar: controller.bottomNavigationBarDashboard(context: context,ctrl: controller)
            ),
            isLoading: controller.isLoading,
          ),
        );
      },
    );
  }




  // Future<void> selectWithTypeCount(String status) async {
  //   isDelivery = false;
  //   if (routeId.isEmpty) {
  //     ToastCustom.showToast(msg: "Select route and try again!");
  //   } else {
  //     setState(() {
  //       page = 0;
  //       lastPageLength = -1;
  //       selectedType = status;

  //       if (!isProgressAvailable!) {
  //         setState(() {
  //           isProgressAvailable = true;
  //         });
  //       }

  //       if (status == kStatusOutForDelivery) {
  //         selectedType = kStatusOutForDelivery;
  //         getParcelList(0);
  //       } else {
  //         fetchDeliveryList(0);
  //       }
  //     });
  //   }
  // }
}


abstract class BulkScanMode {
  void isSelected(bool isSelect);
}


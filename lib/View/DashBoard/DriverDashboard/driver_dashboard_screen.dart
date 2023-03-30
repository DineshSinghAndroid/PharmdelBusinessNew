import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Default Functions/defaultFunctions.dart';
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
  // await drDashCtrl.driverDashboardApi(context: context,routeID: "1");
      await drDashCtrl.driverRoutesApi(context: context).then((value) async {
        await drDashCtrl.getParcelBoxApi(context: context);
      });

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardCTRL>(
      init: drDashCtrl,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async => false,
          child: LoadScreen(
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
                          InkWell(
                              onTap: () => controller.onTapAppBarRefresh(context:context),
                              child: const Icon(Icons.refresh)
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
                          controller.receivedCount == 0 || controller.isRouteStart ?
                          const SizedBox.shrink() :
                          InkWell(
                              onTap: ()=> controller.onTapAppBarQrCode(context: context),
                              child: Image.asset(strIMG_location,height: 25,color: AppColors.redColor,)
                          ),


                          buildSizeBox(0.0, 10.0),
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
                                  Positioned(
                                    right: 1,
                                    top: 12,
                                    child: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.redColor,
                                        child: BuildText.buildText(
                                          text: controller.driverDashboardData?.notificationCount.toString() ?? "",
                                          //controller.notificationCountData?.list ?? "",
                                          // notification_count != null
                                          //     ? notification_count > 99
                                          //     ? "+99"
                                          //     : notification_count.toString()
                                          //     : "",
                                          size: 9,
                                          color: AppColors.whiteColor,
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
                drawer: const DrawerDriver(),
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.orange,
                      label: Column(
                        children: [
                          const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          BuildText.buildText(
                              text: kScanRx, color: AppColors.whiteColor)
                        ],
                      ),
                      onPressed: () {
                        Get.toNamed(searchPatientScreenRoute);
                        // Get.toNamed(scanPrescriptionScreenRoute);
                        DefaultFuntions.barcodeScanning();
                      },
                    ),
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

                              /// Select Parcel box
                              controller.isBulkScanSwitched == true ?
                              Expanded(
                                child: WidgetCustom.driverDasTopSelectWidget(
                                    title: controller.selectedParcelBox != null ? controller.selectedParcelBox?.name.toString() ?? "" : kSelectPhar,
                                    onTap:()=> controller.onTapSelectParcelLocation(context:context,controller:controller),
                                ),
                              ) : const SizedBox.shrink(),

                            ],
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
                                          onTap: () => controller.onTapMaTopDeliveryListBtn(context:context,btnType: 1),
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
                                      counter: controller.driverDashboardData?.orderCounts?.outForDeliveryOrders ?? "0",
                                      onTap: () => controller.onTapMaTopDeliveryListBtn(context:context,btnType: 4),
                                      )) :
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: DefaultWidget.topCounter(
                                      bgColor: AppColors.textFieldBorderColor,
                                      label: kPickedUp,
                                      selectedTopBtnName: controller.selectedTopBtnName,
                                      counter: controller.driverDashboardData?.orderCounts?.pickedupOrders ?? "0",
                                      onTap: () => controller.onTapMaTopDeliveryListBtn(context:context,btnType: 8),
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
                                      onTap: () => controller.onTapMaTopDeliveryListBtn(context:context,btnType: 5),
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
                                      onTap: () => controller.onTapMaTopDeliveryListBtn(context:context,btnType: 6),
                                      )),
                            ],
                          ),
                        ),

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

                              },

                              /// onTap Manual
                              onTapManual: (){

                              },

                              /// onTap DeliverNow
                              onTapDeliverNow: (){

                              },

                              /// Customer Detail
                              customerName: "${controller.driverDashboardData?.deliveryList?[i].customerDetials?.title ?? ""} ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.firstName ?? ""} ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.middleName ?? ""}  ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.lastName ?? ""}",
                              customerAddress: "${controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.address1 ?? controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.address2 ?? ""} ${controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.postCode ?? ""}",
                              altAddress: controller.driverDashboardData?.deliveryList?[i].customerDetials?.customerAddress?.alt_address ?? "",
                              driverType: driverType,

                              isBulkScanSwitched: controller.isBulkScanSwitched,
                              isSelected: controller.driverDashboardData?.deliveryList?[i].isSelected ?? false,
                              nursingHomeId: controller.driverDashboardData?.deliveryList?[i].nursing_home_id ?? "",
                              pharmacyName: controller.driverDashboardData?.deliveryList?[i].pharmacyName ?? "",

                              /// Order Detail
                              orderListType: controller.orderListType,
                              orderId: controller.driverDashboardData?.deliveryList?[i].orderId ?? "",
                              deliveryStatus: controller.driverDashboardData?.deliveryList?[i].status ?? "",
                              isControlledDrugs: controller.driverDashboardData?.deliveryList?[i].isControlledDrugs ?? "",
                              isCronCreated: controller.driverDashboardData?.deliveryList?[i].isCronCreated ?? "",
                              isStorageFridge: controller.driverDashboardData?.deliveryList?[i].isStorageFridge ?? "",
                              parcelBoxName: controller.driverDashboardData?.deliveryList?[i].parcelBoxName ?? "",
                              serviceName: controller.driverDashboardData?.deliveryList?[i].serviceName ?? "",
                              pmrId: controller.driverDashboardData?.deliveryList?[i].pr_id ?? "",
                              pmrType: controller.driverDashboardData?.deliveryList?[i].pmr_type ?? "",
                              rescheduleDate: controller.driverDashboardData?.deliveryList?[i].rescheduleDate ?? "",

                              /// PopUp Menu
                              popUpMenu: [],


                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 15),
                            ) ;
                          },
                        )
                        : controller.isRouteStart == false ?
                        SizedBox(
                          height: getHeightRatio(value: 50),
                            width: getWidthRatio(value: 50),
                            child: Center(child: BuildText.buildText(text: kSelectRouteFirst))
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
                // bottomNavigationBar:
                // isPickedUp == true ?
                // InkWell(
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) {
                //         return   const ConfirmationRouteStartDialog();
                //       },
                //     );
                //   },
                //   child: Container(
                //     color: AppColors.blueColor,
                //     padding: const EdgeInsets.all(16),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         BuildText.buildText(
                //             text: kStartRoute,
                //             color: AppColors.whiteColor,
                //             size: 16,
                //             weight: FontWeight.w700),
                //       ],
                //     ),
                //   ),
                // ) : const SizedBox.shrink()
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


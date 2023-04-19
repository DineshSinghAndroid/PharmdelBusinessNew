import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/Helper/TimeChecker/timer_checker.dart';
import 'package:pharmdel/View/CreatePatientScreen.dart/createPatientScreen.dart';
import 'package:pharmdel/View/OrderDetails/order_detail_screen.dart';
import 'package:xml2json/xml2json.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../../Model/DriverDashboard/get_pharmacy_info_response.dart';
import '../../../Model/DriverDashboard/reschedule_delivery_response.dart';
import '../../../Model/DriverDashboard/update_storage_or_cd_response.dart';
import '../../../Model/DriverRoutes/get_route_list_response.dart';
import '../../../Model/Enum/enum.dart';
import '../../../Model/GetDeliveryMasterData/get_delivery_master_data.dart';
import '../../../Model/NotificationCount/notification_count_response.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../../Model/ParcelBox/parcel_box_response.dart';
import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Model/VehicleList/vehicleListResponse.dart';
import '../../../View/DashBoard/DriverDashboard/start_route_popup_screen.dart';
import '../../../View/MapScreen/map_screen.dart';
import '../../../View/SearchPatient/search_patient.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../DB_Controller/MyDatabase.dart';
import '../../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../Helper/ConnectionValidator/internet_check_return.dart';
import '../../Helper/Permission/PermissionHandler.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/Redirect/redirect.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../RouteController/RouteNames.dart';
import '../../StopWatchController/stop_watch_controller.dart';
import '../../WidgetController/AppUpdatePopUp/app_update_popup.dart';
import '../../WidgetController/BottomSheet/BottomSheetCustom.dart';
import '../../WidgetController/GoToDashboard/go_to_dashboard.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/Popup/PopupCustom.dart';
import '../../WidgetController/Popup/popup.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../WidgetController/Toast/ToastCustom.dart';
import '../LocalDBController/local_db_controller.dart';
import '../../Helper/SentryExemption/sentry_exemption.dart';

class DriverDashboardCTRL extends GetxController{

  ApiController apiCtrl = ApiController();
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  /// Internet Check
  bool isAvlInternet = false;
  bool isDialogShowing = false;

  bool isShowRouteStartDialog = false;

  /// Driver list
  List<DriverModel> driverList = [];
  DriverModel? selectedDriver;

  /// Reschedule or Failed selection
  bool isAllSelected = false;
  bool isShowReschedule = false;
  List<String> selectedOrderIDsForReschedule = [];

  String? userType;
  bool isBulkScanSwitched = false;
  String? bulkScanDate;
  bool isRouteStart = false;

  /// Date Format
  final DateFormat formatter = DateFormat("dd-MM-yyyy");

  /// System Delivery Time
  int? systemDeliveryTime;
  StopWatchTimer? stopWatchTimer;
  bool showIncreaseTime = false;


  /// Get rout Data
  RouteList? selectedRoute;
  PharmacyList? selectedPharmacy;

  PharmacyList? selectedStartRoutePharmacy;
  PharmacyList? selectedEndRoutePharmacy;

  List<RouteList>? routeList;
  List<AllRouteList>? allRouteList;
  List<PharmacyList>? pharmacyList;
  List<PharmacyList> endRoutePharmacyList = [];
  List<NHomeList>? nHomeList;
  bool? status;
  bool? isOrderAvailable;
  String? vehicleInspection;
  String? vehicleId;

  /// Parcel box list
  List<ParcelBoxData>? parcelBoxList;
  ParcelBoxData? selectedParcelBox;

  /// Selected top btn
  String selectedTopBtnName = "";
  int orderListType = 1;
  // String? selectedPharmacyID;

  /// Selected Pharmacy Info
  GetPharmacyInfoResponse? selectedPharmacyInfo;



  /// Vehicle list
  List<VehicleListData>? vehicleListData;
  VehicleListData? selectedVehicleData;

  /// Get Deliver list data
  GetDeliveryApiResponse? driverDashboardData;

  /// Location Array
  // List<LocationData> locationArray = [];
  LocationData? locationData;
  Location? location;

  /// Completed data upload ctrl
  LocalDBController dbCTRL = Get.put(LocalDBController());

  /// Is Next Pharmacy Available
  int? isNextPharmacyAvailable;

  /// Get Delivery Master Data Use in Delivery Schedule
  GetDeliveryMasterDataResponse? deliveryMasterData;

  /// Location
  String currentLatitude = "0";
  String currentLongitude = "0";

  @override
  void onInit() {
    onInitUse();
    super.onInit();
  }

  Future<void> onInitUse()async{
    currentLatitude = await CheckPermission.getLatitude(Get.overlayContext!) ?? "0";
    currentLongitude = await CheckPermission.getLongitude(Get.overlayContext!) ?? "0";
    PrintLog.printLog("Current Lat_Long: currentLatitude=$currentLatitude  currentLongitude=$currentLongitude");
  }


  void isBulkScanSwitchedValue(bool value){
    isBulkScanSwitched = value;
    update();
  }

  Future<void> onTapAppBarMap({required BuildContext context}) async {
    isAvlInternet = await InternetCheck.checkStatus();
    if(!isAvlInternet){
      PrintLog.printLog("No Internet........On Tap MapScreen");
      showNoInternetCustomPopUp();
      return;
    }

      Get.toNamed(mapScreenRoute,
        arguments: MapScreen(
            driverId: userID,
            list: driverDashboardData?.deliveryList,
            routeId: selectedRoute?.routeId.toString() ?? ""
        )
    );
  }

  Future<void> onTapAppBarQrCode({required BuildContext context,int? scanOrderMainId,}) async {
    TimeCheckerCustom.checkLastTime(context: context);

    isAvlInternet = await InternetCheck.checkStatus();
    if(!isAvlInternet){
      PrintLog.printLog("No Internet........On Tap QR");
      showNoInternetCustomPopUp(subTitle: scanOrderMainId != null && scanOrderMainId != 0 ? kPleaseCompleteManually:"");
      return;
    }

    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes != "-1") {
        FlutterBeep.beep();

        if (orderListType == 4) {

          await orderDetailApi(
              context: Get.overlayContext!,
              orderID: barcodeScanRes,
              isScan:  true,
              isComplete:  true,
              orderIdMain: scanOrderMainId ?? 0,
              routeID: selectedRoute?.routeId.toString() ?? "0"
          );

        } else if (orderListType != 4) {
          orderListType = 1;
          await orderDetailApi(
              context: Get.overlayContext!,
              orderID: barcodeScanRes,
              isScan:  true,
              isComplete:  false,
              orderIdMain:  0,
              routeID: selectedRoute?.routeId.toString() ?? "0"
          );
        } else {
          ToastCustom.showToast(msg: kFormatNotCorrect);
        }
      } else {
        ToastCustom.showToast(msg: kFormatNotCorrect);
      }
    } on PlatformException {
      barcodeScanRes = kFailedToGetPlatformVersion;
    }

  }

  Future<void> onTapAppBarNotification({required BuildContext context}) async{
    isAvlInternet = await InternetCheck.checkStatus();
    if(!isAvlInternet){
      PrintLog.printLog("No Internet........On Tap Notification");
      showNoInternetCustomPopUp();
      return;
    }

    Get.toNamed(notificationScreenRoute);
  }

  Future<void> onTapAppBarRefresh({required BuildContext context})async {
    await driverRoutesApi(context: context).then((value) async {
      await getParcelBoxApi(context: context).then((value) async {
        if(selectedRoute != null && selectedRoute?.routeId != null) {
          await driverDashboardApi(context: context);
        }
      });
    });
    // vehicleListApi(context: context);
    update();
  }

  /// Show No internet Custom PopUP
  Future<void> showNoInternetCustomPopUp({String? subTitle})async{
      PopupCustom.showNoInternetPopUpWhenOffline(
          context: Get.overlayContext!,
          subTitle: subTitle,
          onValue: (value){

          }
      );
  }

  /// On Tap Scan Rx
  Future<void> onTapScanRx({required BuildContext context})async{
    // Ex____:NoSuchMethodError: Class 'List<String>' has no instance method 'split'.
    // dbCTRL.checkPendingCompleteDataInDB(context: context);
    // bool isfff = false;
    // isfff = await dbCTRL.isFoundOrderInCompleted(orderID: "1062061") ?? false;
    // print("tes................$isfff...");
    //
    // await MyDatabase().getAllOrderCompleteData().then((value) async {
    //   await Future.forEach(value, (element) async {
    //     print("object.....${element.deliveryId.split(",").join(",")}");
    //     // await MyDatabase().deleteCompletedDeliveryByOrderId(element.deliveryId.split(",").join(","));
    //   });
    // });

    // await MyDatabase().deleteCompletedDeliveryByOrderId("1062061".toString());
    // [1062061, 1062048, 1062088, 1062138, 1062325]
    // 1062061, 1062048, 1062088, 1062138, 1062325
    // PrintLog.printLog("Clicked on Scan RX");
    // CheckPermission.getCurrentLocation(
    //     context: context,
    //     onChangedLocation: (e){
    //
    //     }
    // );

    ///
    isAvlInternet = await InternetCheck.checkStatus();
    if(!isAvlInternet){
      showNoInternetCustomPopUp();
      return;
    }else if(driverType.toLowerCase() == kSharedDriver.toLowerCase()){
      if(selectedPharmacy == null){
        PopupCustom.simpleTruckDialogBox(
          context: Get.overlayContext!,
          title: kAlert,
          subTitle: kPleaseSelectPharmacy,
          btnBackTitle: "",
          btnActionTitle: kOk,
          btnActionColor: AppColors.themeColor,
          onValue: (value){},
        );
        return;
      }else{
        await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.pharmacyID, variableValue: selectedPharmacy?.pharmacyId ?? "");
      }
    }

    if(selectedRoute != null){
      if(isBulkScanSwitched){
        Get.toNamed(scanPrescriptionScreenRoute)?.then((value) {
          PrintLog.printLog("Scan Prescription value is: $value");
          if(value == "search"){
            Get.toNamed(searchPatientScreenRoute,arguments: SearchPatientScreen(isScan: true))?.then((value1) async {
              if(value1 == "created"){
                if(isRouteStart){
                  await getDeliveriesWithRouteStart(context: context);
                }else{
                  await driverDashboardApi(context: context);
                }
              }
            });
          }else if(value == "create"){
            Get.toNamed(driverCreatePatientScreenRoute,arguments: DriverCreatePatientScreen(isScanPrescription: true));
          }
        });
      }else{
        Get.toNamed(searchPatientScreenRoute,arguments: SearchPatientScreen(isScan: true))?.then((value1) async {
          if(value1 == "created"){
            if(isRouteStart){
              await getDeliveriesWithRouteStart(context: context);
            }else{
              await driverDashboardApi(context: context);
            }
          }else if(value1 == "search"){
            Get.toNamed(searchPatientScreenRoute,arguments: SearchPatientScreen(isScan: false))?.then((value1) async {

              if(value1 == "created"){
                if(isRouteStart){
                  await getDeliveriesWithRouteStart(context: context);
                }else{
                  await driverDashboardApi(context: context);
                }
              }
            });
          }
        });
      }


    }else{
      PopupCustom.simpleTruckDialogBox(
        context: Get.overlayContext!,
        title: kAlert,
        subTitle: kPleaseSelectRoute,
        btnBackTitle: "",
        btnActionTitle: kOk,
        btnActionColor: AppColors.themeColor,
        onValue: (value){},
      );
    }

  }

  Future<void> onAssignPreviewsRout({required BuildContext context}) async {
    onInitUse();
    isAvlInternet = await InternetCheck.checkStatus();
    if(isAvlInternet) {
      if(routeList != null && routeList!.isNotEmpty){
        String routeID = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID) ?? "" ;
        if(routeID != ""){
          int checkRoute = routeList!.indexWhere((element) => element.routeId.toString() == routeID.toString());
          selectedRoute = routeList?[checkRoute];
          String isRouteValue = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.isStartRoute) ?? "" ;
          if(isRouteValue.toLowerCase() == "true"){
            selectWithTypeCount(context: context,orderListNum: 4);
          }else{
            await driverDashboardApi(context: context).then((value) async {

            });
          }

        }
      }
    }else{

      authToken = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.authToken) ?? "";
      userID = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId) ?? "";
      userType = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType) ?? "";
      if(selectedRoute == null){
        RouteList data = RouteList();
        data.routeId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID) ?? "";
        data.routeName = "";
        data.branchId = "";
        data.companyId = "";
        data.isActive = "";
        selectedRoute = data;
      }
      isRouteStart = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.isStartRoute).toString().toLowerCase() == "true" ? true:false;
      if(isRouteStart){
        orderListType=4;
        checkCompleteDataInDB(context: context,isUpdateFailed: false).then((value) async {
          await checkEndRouteData();
        });
      }
    }

    if (!isRouteStart) {
      await AppSharedPreferences.removeValueToSharedPref(variableName: AppSharedPreferences.deliveryTime);
      if (stopWatchTimer != null) {
        PrintLog.printLog("stopwatch disposed");
        showIncreaseTime = false;
        stopWatchTimer?.dispose();
        stopWatchTimer = null;
      }
    }

    bulkScanDate = formatter.format(DateTime.now());

  }

  Future<void> checkEndRouteData()async {
    if(driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty ){
      if(driverDashboardData?.deliveryList?[0].orderId == "0"){
        endRouteApi(context: Get.overlayContext!);
      }
    }
  }

  void onTapSelectRoute({required BuildContext context,required controller}){
    PrintLog.printLog("Clicked on Select route");
    if(isRouteStart) {
      ToastCustom.showToast(msg: kChangeRouteMsg);
    }else{
      BottomSheetCustom.showSelectRouteBottomSheet(
        controller: controller,
        context: context,
        selectedID: selectedRoute?.routeId,
        listType: "route",
        onValue: (value) async {
          if(value != null){
            selectedRoute = value;
            if(driverType.toLowerCase() != kSharedDriver.toLowerCase()) {
              await driverDashboardApi(context: context).then((value) async {
                await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.routeID, variableValue: selectedRoute?.routeId ?? "");
                update();
              });
            }else{
              update();
            }
            PrintLog.printLog("Selected ParcelBox: ${selectedRoute?.routeName}");
          }
        },
      );

    }
  }

  void onTapSelectParcelLocation({required BuildContext context,required controller}){
    PrintLog.printLog("Clicked on Select parcel location");
    if(isRouteStart){
      ToastCustom.showToast(msg: kChangeRouteMsg);
    }else {
      BottomSheetCustom.showSelectRouteBottomSheet(
        controller: controller,
        context: context,
        listType: "parcel",
        selectedID: selectedParcelBox?.id,
        onValue: (value){
          if(value != null){
            selectedParcelBox = value;
            update();
            PrintLog.printLog("Selected ParcelBox: ${selectedParcelBox?.name}");
          }
        },
      );
    }
  }

  void onTapSelectPharmacy({required BuildContext context,required controller}){
    PrintLog.printLog("Clicked on Select parcel location");
    if(isRouteStart){
      ToastCustom.showToast(msg: kChangeRouteMsg);
    }if(selectedRoute == null){
      ToastCustom.showToast(msg: kSelectRouteFirst);
    }else {
      BottomSheetCustom.showSelectRouteBottomSheet(
        controller: controller,
        context: context,
        listType: "pharmacy",
        selectedID: selectedPharmacy?.pharmacyId,
        onValue: (value) async {
          if(value != null){
            if(driverType.toLowerCase() == kSharedDriver.toLowerCase()) {
              selectedPharmacy = value;
              await driverDashboardApi(context: context).then((value) async {
                await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.routeID, variableValue: selectedRoute?.routeId ?? "");
                update();
              });
            }
            PrintLog.printLog("Selected ParcelBox: ${selectedPharmacy?.pharmacyName}");
          }
        },
      );
    }
  }

  void onTapPopUpMenuSelection({required BuildContext context,required String value,required int index}){
    PrintLog.printLog("PopUpMenu Selected value is: $value");
    if(value == "cd"){
      if(driverDashboardData?.deliveryList?[index].isControlledDrugs.toString() == "t"){
        driverDashboardData?.deliveryList?[index].isControlledDrugs = "f";
      }else{
        driverDashboardData?.deliveryList?[index].isControlledDrugs = "t";
      }
    }else if(value == "fridge"){
      if(driverDashboardData?.deliveryList?[index].isStorageFridge.toString() == "t"){
        driverDashboardData?.deliveryList?[index].isStorageFridge = "f";
      }else{
        driverDashboardData?.deliveryList?[index].isStorageFridge = "t";
      }
    }else if(value == "cancel"){
      deleteOrderByOrderID(
        context: context,
        index: index,
        orderID: driverDashboardData?.deliveryList?[index].orderId ?? "",
      );
    }
    if(value == "cd" || value == "fridge"){
      updateStorageOrCD(
          context: context,
          orderID: driverDashboardData?.deliveryList?[index].orderId ?? "",
          cd: driverDashboardData?.deliveryList?[index].isControlledDrugs ?? "",
          fridge: driverDashboardData?.deliveryList?[index].isStorageFridge ?? "",
      );
    }
    update();
  }

  Future<void> onTapManTopDeliveryListBtn({required BuildContext context,required int btnType}) async {
    orderListType = btnType;
    PrintLog.printLog("Clicked on Btn Type: $btnType..Order_list_type: $orderListType");
    isAvlInternet = await InternetCheck.checkStatus();
    if(!isAvlInternet && isRouteStart == true && orderListType != 4){

      PrintLog.printLog("No Internet........OrderListType::$orderListType");
      showNoInternetCustomPopUp();
      return;
    }else if(orderListType == 4 && !isAvlInternet){
      getAllOutForDeliveryDataFromDB();
      return;
    }


    if(selectedRoute?.routeId == null || selectedRoute?.routeId.toString() == "" || selectedRoute?.routeId.toString() == "null"){
      ToastCustom.showToast(msg: kFirstSelectRoute);
    }else if(driverType.toLowerCase() == kSharedDriver.toLowerCase() && selectedPharmacy == null ){
      ToastCustom.showToast(msg: kSelectPharmacyFirst);
    }else if(selectedRoute?.routeId != null && selectedRoute?.routeId.toString() != "" && selectedRoute?.routeId.toString() != "null") {
      if(orderListType != 4) {
        await driverDashboardApi(context: context);
      }else{
        await getDeliveriesWithRouteStart(context: context);
      }
    }else{
      ToastCustom.showToast(msg: kFirstSelectRoute);
    }
  }

  Future<void> onTapDeliveryListItem({required BuildContext context,required int index}) async {
    if(orderListType == 4){
      onTapAppBarQrCode(
          context: context,
          scanOrderMainId: driverDashboardData?.deliveryList?[index].nursing_home_id == null || driverDashboardData?.deliveryList?[index].nursing_home_id == "" ||driverDashboardData?.deliveryList?[index].nursing_home_id == "null" || driverDashboardData?.deliveryList?[index].nursing_home_id == "0" ? int.parse(driverDashboardData?.deliveryList?[index].orderId.toString() ?? "0") : 0
      );
    }else{
      if (orderListType == 6) {
        if (driverType.toLowerCase() == kDedicatedDriver.toLowerCase()) {
          driverDashboardData?.deliveryList?[index].isSelected = !driverDashboardData!.deliveryList![index].isSelected!;
          isShowReschedule = driverDashboardData!.deliveryList!.any((element) => element.isSelected == true);
          bool isFoundFalse = driverDashboardData!.deliveryList!.any((element) => element.isSelected == false);
          isAllSelected = isFoundFalse == true ? false:true;
        }
      }
      else if (driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kOutForDelivery || orderListType == 4) {
        orderListType = 4;
        bool isInternet = await ConnectionValidator().check();
        if( isInternet == true){
          scanBarcodeNormal(
              context: Get.overlayContext!,
              isOutForDelivery: true,
              customerId: int.parse(driverDashboardData?.deliveryList?[index].customerDetials?.customerId.toString() ?? "0"),
              orderId: driverDashboardData?.deliveryList?[index].nursing_home_id == null || driverDashboardData?.deliveryList?[index].nursing_home_id == "" ||driverDashboardData?.deliveryList?[index].nursing_home_id == "null" || driverDashboardData?.deliveryList?[index].nursing_home_id == "0" ? int.parse(driverDashboardData?.deliveryList?[index].orderId.toString() ?? "0") : 0
          );

        }else{
          PopupCustom.showOnlyManualDeliveryPopUp(
              context: Get.overlayContext!,
              onValue: (value){

              }
          );
        }


      }
      else if (driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kReadyDelivery.toLowerCase() ||
          driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kReadyForDelivery.toLowerCase() ||
          driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kPickedUpDelivery.toLowerCase() ||
          driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kReceived.toLowerCase() ||
          driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kRequested.toLowerCase()) {
        if (!isRouteStart) {

          orderDetailApi(
              context: context,
              routeID: selectedRoute?.routeId.toString() ?? "0",
              orderID: driverDashboardData?.deliveryList?[index].orderId ?? "",
              isScan: false, isComplete:  false,orderIdMain:  0
          );
        } else if (isRouteStart) {
          PopupCustom.showAlertRouteStartedPopUp(context: context);
        }
      }
      update();
    }

  }

  /// Manual Delivery
  Future<void> onTapManualDelivery({required BuildContext context,required int index})async{

    if(isRouteStart){
      await dbCTRL.getOrderDetailsDB(
          delivery: driverDashboardData!.deliveryList![index],
          isComplete: true,
          isScan: false
      ).then((value) {
        PrintLog.printLog("Related Products Length: ${value?.relatedOrders?.length}");
        PrintLog.printLog("deliveryStatusDesc: ${value?.deliveryStatusDesc}");

        if(value != null && value.deliveryStatusDesc?.toLowerCase() == kOutForDelivery.toLowerCase()){
          if(value.relatedOrders != null && value.relatedOrders!.length > 1 ){
            /// Multiple Deliveries
            PrintLog.printLog('Multiple DB deliveries::::::::::::${value.bagSize}');
            showAlertOrderPopUp(context: context,deliveryDetails: value);
          }else{

            /// Single Delivery
            Get.toNamed(orderDetailScreenRoute,arguments: OrderDetailScreen(detailData: value,isMultipleDeliveries: false,))?.then((value) {
              if(orderListType == 4 && value != "back"){
                PrintLog.printLog("Check Uploaded Order: 1");
                checkCompleteDataInDB(context: context,isUpdateFailed: false);
              }
            });
            PrintLog.printLog('Single DB delivery::::::::::::');
          }
        }
      });

    }else{
      orderDetailApi(
          context: context,
          routeID: selectedRoute?.routeId.toString() ?? "0",
          orderID: driverDashboardData?.deliveryList?[index].orderId ?? "",
          isScan: false, isComplete:  true,orderIdMain:  0
      );
    }
  }

  /// Make Next Order
  Future<void> onTapMakeNextOrder({required BuildContext context,DeliveryPojoModal? orderData})async{

    isAvlInternet = await InternetCheck.checkStatus();
    if(!isAvlInternet){
      showNoInternetCustomPopUp();
      return;
    }

    if(orderData?.orderId != null && orderData?.orderId.toString() != "null" && int.parse(orderData?.orderId.toString() ?? "0") > 0) {
      PrintLog.printLog("Make Next Order ID:${orderData?.orderId}");
      if (orderData?.sortBy != null && orderData!.sortBy!.isNotEmpty && orderData.sortBy?.toLowerCase() == "pharmacy"){

        PopupCustom.simpleTruckDialogBox(
          context: Get.overlayContext!,
          isShowClearBtn: true,
          title: kAlert,
          subTitle: kPharmacyAlreadyMakeThisRouteSubTitle,
          btnBackTitle: kNo,
          btnActionTitle: kYes,

          onValue: (value){
            if(value.toString() == "yes"){
              PopupCustom.simpleTruckDialogBox(
                context: Get.overlayContext!,
                isShowClearBtn: true,
                title: kReOptimiseRemainingStops,
                subTitle: kReOptimisePopUpSubTitle,
                btnBackTitle: kReOptimiseStops,
                btnActionTitle: kSkip,
                btnActionColor: AppColors.themeColor,
                onValue: (value){
                  if(value.toString() == "no"){
                    makeNextOrderApi(context: context,orderID: orderData.orderId.toString() ?? "0",optimizeStatus: "1",isShowBigLoader: true);
                  }else if(value.toString() == "yes"){
                    makeNextOrderApi(context: context,orderID: orderData.orderId.toString() ?? "0",optimizeStatus: "2");
                  }
                },
              );
            }
          },
        );
      }else{
        PopupCustom.simpleTruckDialogBox(
          context: Get.overlayContext!,
          isShowClearBtn: true,
          title: kReOptimiseRemainingStops,
          subTitle: kReOptimisePopUpSubTitle,
          btnBackTitle: kReOptimiseStops,
          btnActionTitle: kSkip,
          btnActionColor: AppColors.themeColor,
          onValue: (value){
            if(value.toString() == "no"){
              makeNextOrderApi(context: context,orderID: orderData?.orderId.toString() ?? "0",optimizeStatus: "1",isShowBigLoader: true);
            }else if(value.toString() == "yes"){
              makeNextOrderApi(context: context,orderID: orderData?.orderId.toString() ?? "0",optimizeStatus: "2");
            }
          },
        );
      }

    }
  }



  /// Failed Delivered Now
  Future<void> onTapDeliverNow({required BuildContext context,required int index})async{
    OrderDetailResponse getOrderDetailResponse = OrderDetailResponse();
    getOrderDetailResponse.relatedOrders?.clear();
    List<RelatedOrders> failedRelatedOrders = [];


    RelatedOrders relatedOrders = RelatedOrders();
    DeliveryPojoModal order = driverDashboardData!.deliveryList![index];

    relatedOrders.orderId = order.orderId.toString();
    relatedOrders.parcelBoxName = order.customerDetials?.surgeryName;
    relatedOrders.subsId = order.subsId.toString();
    relatedOrders.rxCharge = order.rxCharge;
    relatedOrders.rxInvoice = order.rxInvoice.toString();
    relatedOrders.delCharge = order.delCharge;
    relatedOrders.bagSize = order.bagSize;
    relatedOrders.isDelCharge = order.isDelCharge.toString();
    relatedOrders.isPresCharge = order.isSubsCharge.toString();
    relatedOrders.exemption = order.exemption;
    relatedOrders.prId = order.pharmacyId.toString();
    relatedOrders.paymentStatus = order.paymentStatus;
    relatedOrders.pharmacyName = order.pharmacyName;
    relatedOrders.totalControlledDrugs = order.totalControlledDrugs.toString();
    relatedOrders.totalStorageFridge = order.totalStorageFridge.toString();
    relatedOrders.nursingHomeId = order.nursing_home_id.toString();
    relatedOrders.userId = order.customerDetials?.customerId.toString();
    relatedOrders.mobileNo = order.customerDetials?.mobile;
    relatedOrders.fullName = (order.customerDetials?.title != null ? order.customerDetials!.title! + " " : "") +
        (order.customerDetials?.firstName != null ? "${order.customerDetials?.firstName} " : "") +
        (order.customerDetials?.middleName != null ? order.customerDetials?.middleName ?? "": "") +
        (order.customerDetials?.lastName != null ? " ${order.customerDetials?.lastName}" : "");
    relatedOrders.fullAddress = order.customerDetials?.address;
    relatedOrders.isStorageFridge = order.isStorageFridge == "t" ? true : false; // need to add
    relatedOrders.deliveryNotes = order.deliveryNotes; // need to add
    relatedOrders.isSelected = false;
    relatedOrders.isCronCreated = order.isCronCreated;
    relatedOrders.altAddress = order.customerDetials?.customerAddress?.alt_address;
    relatedOrders.existingDeliveryNotes = order.existingDeliveryNotes; // need to add
    relatedOrders.isControlledDrugs = order.isControlledDrugs == "t" ? true : false; // need to add
    relatedOrders.pmrType = order.pmr_type;
    relatedOrders.prId = order.pr_id;

    failedRelatedOrders.add(relatedOrders);

    /// Related Order List Added
    getOrderDetailResponse.relatedOrders = failedRelatedOrders;

    /// Exemptions List Added
    getOrderDetailResponse.exemptions = await dbCTRL.getExemptionList();


    getOrderDetailResponse.orderId = order.orderId;
    getOrderDetailResponse.pharmacyId = order.pharmacyId;
    getOrderDetailResponse.delCharge = order.isDelCharge;
    getOrderDetailResponse.rxCharge = order.rxCharge;
    getOrderDetailResponse.rxInvoice = order.rxInvoice;
    getOrderDetailResponse.delCharge = order.delCharge;
    getOrderDetailResponse.subsId = order.subsId;
    getOrderDetailResponse.totalControlledDrugs = order.totalControlledDrugs;
    getOrderDetailResponse.totalStorageFridge = order.totalStorageFridge;
    getOrderDetailResponse.nursingHomeId = order.nursing_home_id;
    getOrderDetailResponse.isPresCharge = order.isPresCharge;
    getOrderDetailResponse.relatedOrderCount = "${getOrderDetailResponse.relatedOrders?.length ?? 0}";
    getOrderDetailResponse.deliveryRemarks = ""; // no need to add
    getOrderDetailResponse.deliveryTo = ""; // no need to add
    getOrderDetailResponse.deliveryStatusDesc = order.status;
    getOrderDetailResponse.parcelName = order.parcelBoxName;
    getOrderDetailResponse.exemption = order.exemption;
    getOrderDetailResponse.paymentStatus = order.paymentStatus;
    getOrderDetailResponse.bagSize = order.bagSize;
    getOrderDetailResponse.routeId = order.routeId;
    getOrderDetailResponse.prId = order.pr_id;
    getOrderDetailResponse.customerId = order.customerDetials?.customerId;
    getOrderDetailResponse.isControlledDrugs = order.isControlledDrugs == "t" ? true : false;
    getOrderDetailResponse.isStorageFridge = order.isStorageFridge == "t" ? true : false;
    getOrderDetailResponse.deliveryNote = order.deliveryNotes;
    getOrderDetailResponse.exitingNote = order.existingDeliveryNotes;
    getOrderDetailResponse.customer = Customer();
    getOrderDetailResponse.customer?.altAddress = order.customerDetials?.customerAddress?.alt_address;

    /// Doubt Method
    getOrderDetailResponse.customer?.mobile = order.customerDetials?.customerAddress?.postCode?.contains("#") != null && int.parse(order.customerDetials?.customerAddress?.postCode?.split("#").length.toString() ?? "0") > 1
        ? order.customerDetials?.customerAddress?.postCode?.split("#")[1]
        : "";

    getOrderDetailResponse.customer?.fullAddress = order.customerDetials?.address;
    getOrderDetailResponse.customer?.fullName = (order.customerDetials?.title != null ? order.customerDetials!.title! + " " : "") +
        (order.customerDetials?.firstName != null ? order.customerDetials!.firstName! + " " : "") +
        (order.customerDetials?.middleName != null ? order.customerDetials?.middleName ?? "": "") +
        (order.customerDetials?.lastName != null ? " " + order.customerDetials!.lastName!: "");


    if(getOrderDetailResponse.relatedOrders != null && getOrderDetailResponse.relatedOrders!.isNotEmpty){
      Get.toNamed(orderDetailScreenRoute,arguments: OrderDetailScreen(detailData: getOrderDetailResponse,isMultipleDeliveries: false,))?.then((value) {
        if(value != "back"){
          PrintLog.printLog("Check Uploaded Order: 1");
          checkCompleteDataInDB(context: context,isUpdateFailed: true);
        }
      });
    }

  }

  /// On Tap SelectAll Failed
  Future<void> onTapSelectAllFailed({required BuildContext context})async{
    if(orderListType == 6 && driverDashboardData != null && driverDashboardData?.deliveryList != null){
      if(isAllSelected){
        driverDashboardData?.deliveryList?.forEach((element) {
          element.isSelected = false;
        });
        isAllSelected = false;
        isShowReschedule = false;
      }else{
        driverDashboardData?.deliveryList?.forEach((element) {
          element.isSelected = true;
        });
        isAllSelected = true;
        isShowReschedule = true;
      }
    }
    update();
  }


  /// On Tap Reschedule Failed
  Future<void> onTapRescheduleNowFailed({required BuildContext context})async{
    await InternetCheck.check();
    selectedOrderIDsForReschedule.clear();

    bool isSelectedReschedule = driverDashboardData?.deliveryList?.any((element) => element.isSelected == true) ?? false;

    if(isSelectedReschedule){
      if(selectedRoute != null && selectedRoute?.routeId != null){
        driverDashboardData?.deliveryList?.forEach((element) {
          if(element.isSelected == true){
            selectedOrderIDsForReschedule.add(element.orderId ?? "0");
          }
        });

        PopupCustom.showReschedulePopUp(
          context: context,
          selectedOrderIDs: selectedOrderIDsForReschedule,
          onValue: (value){

          },
        );
      }
    }


  }

  /// Route list api
  Future<GetRouteListResponse?> driverRoutesApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "pharmacyId":"0"
    };

    String url = WebApiConstant.GET_DRIVER_ROUTES;

    await apiCtrl.getDriverRoutesApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if (result.status == true) {

            userType = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType);
            routeList = result.routeList;
            allRouteList = result.allRouteList;
            pharmacyList = result.pharmacyList;
            nHomeList = result.nHomeList;
            status = result.status;
            isOrderAvailable = result.isOrderAvailable;
            vehicleInspection = result.vehicleInspection;
            vehicleId = result.vehicleId;

            endRoutePharmacyList.clear();
            if(result.pharmacyList != null) {
              endRoutePharmacyList.addAll(result.pharmacyList!);
            }
            PharmacyList selectPharmacy1 = PharmacyList();
            selectPharmacy1.pharmacyName = "Home Location";
            selectPharmacy1.pharmacyId = "0";
            selectPharmacy1.address = "";
            selectPharmacy1.lat = "0.0";
            selectPharmacy1.lng = "0.0";
            endRoutePharmacyList.add(selectPharmacy1);


            AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.vehicleId, variableValue: result.vehicleId.toString());


            changeLoadingValue(false);
            changeSuccessValue(true);

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
          }

        } catch (_) {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");
        }

      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }



  /// Get delivery list api
  Future<GetDeliveryApiResponse?> driverDashboardApi({required BuildContext context, }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    isShowReschedule = false;
    isAllSelected = false;

    Map<String, dynamic> dictparm = {
      "routeId":selectedRoute?.routeId,
      "page":"1",
      "PageSize":"500",
      "Status":orderListType
    };

    String url = WebApiConstant.GET_DELIVERY_LIST;

    await apiCtrl.getDriverDashboardApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {
              driverDashboardData = result;

              if(result.exemptions != null && result.exemptions!.isNotEmpty){
                dbCTRL.saveExemptions(exemptions: driverDashboardData!.exemptions!);
              }
              if(driverDashboardData?.checkUpdateApp != null) {
                AppUpDatePopUp.checkUpdate(context: context,checkUpdateApp: driverDashboardData!.checkUpdateApp!);
              }

              changeLoadingValue(false);
              changeSuccessValue(true);

            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog(result.message);
            }

          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


  /// Get Pharmacy Info api
  Future<GetPharmacyInfoResponse?> getPharmacyInfo({required BuildContext context}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "pharmacyId": selectedPharmacy?.pharmacyId ?? AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.pharmacyID),
    };

    String url = WebApiConstant.GET_PHARMACY_INFO;

    await apiCtrl.getPharmacyInfoApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
          try {
              selectedPharmacyInfo = result;
              changeLoadingValue(false);
              changeSuccessValue(true);
          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


  /// Parcel box list api
  Future<GetParcelBoxApiResponse?> getParcelBoxApi({required BuildContext context}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "driverId":userID
    };

    String url = WebApiConstant.GET_PHARMACY_PARCEL_BOX_URL;

    await apiCtrl.getParcelBoxApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if (result.error == false) {
            parcelBoxList = result.data;
            changeLoadingValue(false);
            changeSuccessValue(true);

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
          }

        } catch (_) {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");
        }

      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  ///Vehicle List Api
  Future<VehicleListApiResponse?> vehicleListApi({required BuildContext context}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "":""
    };

    String url = WebApiConstant.GET_VEHICLE_LIST_URL;

    await apiCtrl.getVehicleListApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {

              // if(isStartRoute){
                if (result.list != null && result.list!.isNotEmpty) {
                  if (result.list!.length > 1) {
                    selectedVehicleData?.id = "0";
                    selectedVehicleData?.name = "Please Select Vehicle";
                    selectedVehicleData?.color = "";
                    selectedVehicleData?.vehicleType = "";
                    selectedVehicleData?.modal = "";
                    selectedVehicleData?.regNo = "";
                  } else {
                    selectedVehicleData = result.list?[0];
                  }
                  if(vehicleId != ""){
                    int indexVehicle = result.list!.indexWhere((element) => element.id.toString() == vehicleId);
                    if(indexVehicle >= 0){
                      selectedVehicleData = result.list?[indexVehicle];
                    }
                  }
                  vehicleListData = result.list;
                }

              // }

              changeLoadingValue(false);
              changeSuccessValue(true);

            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog("Status : ${result.status}");
            }

          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.status);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  /// Vehicle Info
  Future<void> checkVehicleInfoOnStartRoute({required BuildContext context, required bool isRouteStart})async{
    if(vehicleListData != null && vehicleListData!.isNotEmpty && isRouteStart == true){
      if(isRouteStart){
        if (vehicleListData!.length > 1) {
          selectedVehicleData?.id = "0";
          selectedVehicleData?.name = "Please Select Vehicle";
          selectedVehicleData?.color = "";
          selectedVehicleData?.vehicleType = "";
          selectedVehicleData?.modal = "";
          selectedVehicleData?.regNo = "";
        } else {
          selectedVehicleData = vehicleListData?[0];
        }
        update();
      }
    }else{
      await vehicleListApi(context: context);
    }

  }

  /// Scan Barcode Normal
  Future<void> scanBarcodeNormal({required BuildContext context,required bool isOutForDelivery,required  int customerId,required int orderId}) async {
    // checkLastTime(context);
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes != "-1") {
        FlutterBeep.beep();

        if (isOutForDelivery ) {
          orderDetailApi(context: context,orderID: barcodeScanRes,isScan:  true,isComplete:  true,orderIdMain:  0,routeID: selectedRoute?.routeId.toString() ?? "0");orderDetailApi(context: context,orderID: barcodeScanRes,isScan:  true,isComplete:  true,orderIdMain:  0,routeID: selectedRoute?.routeId.toString() ?? "0");
        } else if (!isOutForDelivery) {
          orderListType = 1;
          orderDetailApi(context: context,orderID: barcodeScanRes,isScan:  true,isComplete:  false,orderIdMain:  0,routeID: selectedRoute?.routeId.toString() ?? "0");
        } else {
          ToastCustom.showToast(msg: "Format not correct!");
        }
      } else {
        ToastCustom.showToast(msg: "Format not correct!");
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // if (!mounted) return;


    try {
      final parser = Xml2Json();
      parser.parse(barcodeScanRes);
      var json = parser.toGData();
      PrintLog.printLog(json);
    } catch (_, stackTrace) {
      SentryExemption.sentryExemption(_, stackTrace);
    }
  }

  ///Order Details Api
  Future<OrderDetailResponse?> orderDetailApi({required BuildContext context,required String orderID,required String routeID,required bool isScan,required bool isComplete, required int orderIdMain}) async {
    await InternetCheck.check();

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "OrderId":orderID,
      "driverId": AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId),
      "isScan":isScan,
      "routeId":routeID,
      "isComplete":isComplete,
      "orderIdMain":orderIdMain
    };

    String url = WebApiConstant.SCAN_ORDER_BY_DRIVER;

    await apiCtrl.getOrderDetailApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if(result.orderId == null || result.message != null && result.message!.contains("wrong bag") ){
            changeLoadingValue(false);
            changeSuccessValue(false);

            PopupCustom.errorDialogBox(
              onValue: (value){},
              topWidget: SizedBox(
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Lottie.network(
                    "https://assets6.lottiefiles.com/private_files/lf30_uDAsLk.json",
                  ),
                ),
              ),
              context: context,
              btnActionTitle: kOkay,
              title: kWrongBag,
              subTitle: result.message ?? "",
            );

          }else{
            if ((result.message == "") || isComplete || result.deliveryStatusDesc.toString().toLowerCase() == "received" ||
                result.deliveryStatusDesc.toString().toLowerCase() == "ready" || result.deliveryStatusDesc.toString().toLowerCase() == "requested" ||
                result.deliveryStatusDesc.toString().toLowerCase() == "pickedUp") {
              if (result.deliveryStatusDesc.toString().toLowerCase() == "completed") {
                ToastCustom.showToast(msg: kThisOrderAlreadyCompleted);
              } else {

                // await MyDatabase().getExemptionsList().then((value) async {
                //   modal.exemptions = [];
                //   if (value != null && value.isNotEmpty) {
                //     await Future.forEach(value, (element) {
                //       ExemptionsList exemptions = ExemptionsList();
                //       exemptions.id = element.exemptionId;
                //       exemptions.serialId = element.serialId;
                //       exemptions.name = element.name;
                //
                //       modal.exemptions.add(exemptions);
                //     });
                //   }
                // });

                if(result.relatedOrders != null && result.relatedOrders!.length > 1 && result.deliveryStatusDesc?.toLowerCase() != kPickedUp2.toLowerCase()){
                   PrintLog.printLog('Multiple deliveries::::::::::::${result.bagSize}');
                  showAlertOrderPopUp(context: context,deliveryDetails: result);
                }else{
                  result.exemptions = driverDashboardData != null && driverDashboardData?.exemptions != null ? driverDashboardData!.exemptions! : await dbCTRL.getExemptionList();
                  Get.toNamed(orderDetailScreenRoute,arguments: OrderDetailScreen(detailData: result,isMultipleDeliveries: false,))?.then((value) {
                    if(orderListType == 4 && value != "back"){
                      PrintLog.printLog("Check Uploaded Order: 1");
                      checkCompleteDataInDB(context: context,isUpdateFailed: false);
                    }

                  });
                  PrintLog.printLog('Single delivery::::::::::::');
                }

                PrintLog.printLog('ScanDetailPage ${result.delCharge}');
                PrintLog.printLog('result.relatedOrders:: ${result.relatedOrders?.length}');
                // showAlertOrderPopUp(deliveryDetails: result,context: context);
              }
            } else if (result.message != null) {
              ToastCustom.showToast(msg: result.message ?? "");
            } else {
              orderListType = 1;
            }
            changeLoadingValue(false);
            changeSuccessValue(true);
          }
 

        } catch (_) {

          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");

        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  /// Update Storage Or CD Api
  Future<UpdateOrderStorageOrCDResponse?> updateStorageOrCD({required BuildContext context,required String orderID,required String cd,required String fridge,}) async {
    await InternetCheck.check();

    changeEmptyValue(false);
    // changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "orderId":orderID,
      "storage_type_cd": cd,
      "storage_type_fr":fridge,
    };


    String url = WebApiConstant.UPDATE_STORAGE_BY_ORDER_ID;

    await apiCtrl.updateStorageOrCDApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if(result.error == false && result.data?.toLowerCase() == "success"){
            changeLoadingValue(false);
            changeSuccessValue(true);
          }else{
            changeLoadingValue(false);
            changeSuccessValue(false);
          }


        } catch (_) {

          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");

        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  ///Order Details Api
  Future<void> deleteOrderByOrderID({required BuildContext context,required String orderID,required int index,}) async {
    await InternetCheck.check();

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "OrderId":orderID,
    };

    String url = WebApiConstant.DELETE_ORDER_BY_ORDER_ID;

    await apiCtrl.deleteOrderByOrderIDApi(context:context,url: url, formData: dictparm)
        .then((result) async {
      if(result != null){
        try {
          if(result.data != null && result.data?.toLowerCase() == "success"){
            driverDashboardData?.deliveryList?.removeAt(index);
            if(orderListType == 1){
              driverDashboardData?.orderCounts?.totalOrders = (int.parse(driverDashboardData?.orderCounts?.totalOrders.toString() ?? "0") - 1).toString() ?? "";
            }else if(orderListType == 8){
              driverDashboardData?.orderCounts?.pickedupOrders = (int.parse(driverDashboardData?.orderCounts?.pickedupOrders.toString() ?? "0") - 1).toString() ?? "";
            }else if(orderListType == 4){
              driverDashboardData?.orderCounts?.outForDeliveryOrders = (int.parse(driverDashboardData?.orderCounts?.outForDeliveryOrders.toString() ?? "0") - 1).toString() ?? "";
            }else if(orderListType == 5){
              driverDashboardData?.orderCounts?.deliveredOrders = (int.parse(driverDashboardData?.orderCounts?.deliveredOrders.toString() ?? "0") - 1).toString() ?? "";
            }else if(orderListType == 6){
              driverDashboardData?.orderCounts?.faildOrders = (int.parse(driverDashboardData?.orderCounts?.faildOrders.toString() ?? "0") - 1).toString() ?? "";
            }
            changeLoadingValue(false);
            changeSuccessValue(true);

          }else{
            changeLoadingValue(false);
            changeSuccessValue(false);
          }

        } catch (_) {

          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");

        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

 /// Order Details Api
  Future<void> makeNextOrderApi({required BuildContext context,required String orderID,required String optimizeStatus,bool? isShowBigLoader}) async {
    await InternetCheck.check();

    if(isShowBigLoader == true) {
      isShowRouteStartDialog = true;
      PopupCustom.showLoadingDialogOnRouteStarting();
    }

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "orderid":orderID,
      "routeId": selectedRoute?.routeId ?? "0",
      "optimizeStatus": optimizeStatus,
      "latitude": currentLatitude,
      "longitude": currentLongitude,
      // "latitude": locationArray.last.latitude.toString(),
      // "longitude": locationArray.last.longitude.toString(),
    };

    String url = WebApiConstant.MAKE_NEXT_BY_DRIVER;

    await apiCtrl.makeNextApi(context:context,url: url, dictParameter: dictparm)
        .then((result) async {
      if(result != null){
        if(isShowRouteStartDialog) {
          Get.back(closeOverlays: true);
          isShowRouteStartDialog = false;
        }
        try {
          if(result.error == false){
            changeLoadingValue(false);
            changeSuccessValue(true);
            if (optimizeStatus == "1") {
              if (result.isOptimize == false) {

                PopupCustom.simpleTruckDialogBox(
                    context: context,
                  title: kAlert,
                  subTitle: result.message,
                  btnActionTitle: kOk,
                  onValue: (value) async {
                    await getAllOutForDeliveryDataFromDB().then((value) {

                    });
                  },
                );

              } else {
                ToastCustom.showToast(msg: result.message ?? "");
                orderListType = 4;
                getDeliveriesWithRouteStart(context: context);

              }
            } else {
              ToastCustom.showToast(msg: result.message ?? "");
              orderListType = 4;
              getDeliveriesWithRouteStart(context: context);

            }

          }else{
            changeLoadingValue(false);
            changeSuccessValue(false);
          }

        } catch (_) {

          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");

        }
      }else{
        if(isShowRouteStartDialog) {
          Get.back(closeOverlays: true);
          isShowRouteStartDialog = false;
        }
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  /// Show Alert PopUp
  Future<void> showAlertOrderPopUp({required BuildContext context,required OrderDetailResponse deliveryDetails}) async {
    PopupCustom.simpleTruckDialogBox(
        context: context,
        title: kMultipleDelivery,
        subTitle: "${deliveryDetails.relatedOrders!.length - 1} $kMoreDeliveryForThisAddress",
        onValue: (value){
          if(value.toString().toLowerCase() == kYes.toLowerCase()){

            PopupCustom.showMultipleDeliveryListPopUp(
                context: context,
              orderModal: deliveryDetails,
              onValue: (value) async {
                  if(value != false && value != null){
                    List<RelatedOrders> selectedRelatedOrders = [];
                    deliveryDetails.relatedOrders?.forEach((element) {
                      if(element.isSelected) {
                        selectedRelatedOrders.add(element);
                      }
                    });
                    deliveryDetails.relatedOrders = selectedRelatedOrders;
                    deliveryDetails.exemptions = driverDashboardData != null && driverDashboardData?.exemptions != null ? driverDashboardData!.exemptions!:await dbCTRL.getExemptionList();
                    Get.toNamed(orderDetailScreenRoute,arguments: OrderDetailScreen(detailData: deliveryDetails,isMultipleDeliveries: true,))?.then((value) {
                      if(orderListType == 4 && value != "back"){
                        PrintLog.printLog("Check Uploaded Order: 2");
                        checkCompleteDataInDB(context: context,isUpdateFailed: false);

                      }
                    });
                  }
              },
            );
          }else{
            Get.toNamed(orderDetailScreenRoute,arguments: OrderDetailScreen(detailData: deliveryDetails,isMultipleDeliveries: false,))?.then((value) {
              if(orderListType == 4 && value != "back"){
                PrintLog.printLog("Check Uploaded Order: 3");
                checkCompleteDataInDB(context: context,isUpdateFailed: false);

              }
            });
          }
        }
    );
  }




  /// BottomNavigation Bar Dashboard
  Widget bottomNavigationBarDashboard({required BuildContext context, required DriverDashboardCTRL ctrl}){
    return
      orderListType == 1 ? const SizedBox.shrink()

        : orderListType == 8 && driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty && !isRouteStart ?
          /// Start Route
         ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          onPressed: () async {
            await checkVehicleInfoOnStartRoute(context: context,isRouteStart: true).then((value) async {
              PopupCustom.confirmationPopupForStartRoute(
                  context: context,
                  ctrl: ctrl,
                  onValue: (value) async {
                    PrintLog.printLog("On Tap Starting Route::::");
                    if(value != null){
                      StartOrEndRouteID popUpData = value;
                      PrintLog.printLog("Value..startRouteID: ${popUpData.startRouteID}");
                      PrintLog.printLog("Value..endRouteID: ${popUpData.endRouteID}");

                      await startRoutesApi(
                          context: context,
                        startRouteId: popUpData.startRouteID.toString(),
                        endRouteId: popUpData.endRouteID.toString(),
                        pharmacyID: driverType.toLowerCase() == kSharedDriver.toLowerCase() ? selectedPharmacy?.pharmacyId:"0"
                      ).then((value) async {
                        if(isSuccess == true){
                          Navigator.of(context).pop(true);
                          await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.startRouteId, variableValue: popUpData.startRouteID.toString());
                            await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.endRouteId, variableValue: popUpData.endRouteID.toString());
                        }
                      });
                    }
                  }
              );
              // if (locationArray.isNotEmpty) {
              //   PrintLog.printLog("Staring routeitssss ");
              //   PopupCustom.confirmationPopupForStartRoute(
              //       context: context,
              //     ctrl: ctrl,
              //     onValue: (value){
              //
              //     }
              //   );
              //
              // } else {
              //   PrintLog.printLog("Unable to start routeitssss..${locationArray.length} ");
              //   await getLocationData(context: context);
              // }
            });

          },
          child: Container(
            color: AppColors.blueColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildText.buildText(
                    text: kStartRoute,
                    color: AppColors.whiteColor,
                    size: 16,
                    weight: FontWeight.w700),
              ],
            ),
          ),
        )

        /// Bulk drop or End route
        : isRouteStart && orderListType == 4 ?
              Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

                /// Bulk Drop btn
                Visibility(
                  visible: driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty,
                  child: Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        bool checkInternet = await ConnectionValidator().check();
                        if (!checkInternet) {
                          showNoInternetCustomPopUp();
                        } else {
                          Get.toNamed(instructionScreenRoute)?.then((value) {
                            if (isRouteStart) {
                              orderListType = 4;
                              checkCompleteDataInDB(context: context,isUpdateFailed: false);
                              // selectWithTypeCount( context: context,orderListNum: orderListType);
                            }
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10,right: 20,top: 10,bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BuildText.buildText(text: kBulkDrop.toUpperCase(),size: 16,color: AppColors.whiteColor,weight: FontWeight.w700),
                            buildSizeBox(0.0, 5.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty ?
                  buildSizeBox(0.0, 20.0):const SizedBox.shrink(),


              /// Ent Route
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greyColor,
                  ),
                  onPressed: () async {
                    bool checkInternet = await ConnectionValidator().check();
                    if (!checkInternet) {
                      showNoInternetCustomPopUp();
                    } else {
                      checkOfflineDeliveryAvailable(context: context,value: false);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        BuildText.buildText(text: kEndRoute.toUpperCase(),size: 16,color: AppColors.whiteColor,weight: FontWeight.w700),
                        buildSizeBox(0.0, 5.0),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        : isRouteStart && orderListType == 4 && driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty ?

          /// Comment buk drop button
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                Get.toNamed(instructionScreenRoute)?.then((value) {
                    if (isRouteStart) {
                      orderListType = 4;
                      selectWithTypeCount( context: context,orderListNum: orderListType);
                    }
                });

              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BuildText.buildText(text: kBulkDrop.toUpperCase(),size: 16,color: AppColors.whiteColor,weight: FontWeight.w700),
                    buildSizeBox(0.0, 5.0),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink();
  }

  /// Start Route api
  Future<void> startRoutesApi({required BuildContext context,required String startRouteId,required String endRouteId,String? pharmacyID,})async{
    PrintLog.printLog("Clicked on Continue:::234:::23");

    if(!isShowRouteStartDialog) {
      PopupCustom.showLoadingDialogOnRouteStarting();
    }


    changeEmptyValue(false);
    // changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "routeId":selectedRoute?.routeId ?? "",
      "startRouteId":startRouteId,
      "endRouteId":endRouteId,
      "latitude": currentLatitude,
      "longitude":currentLongitude,
      // "latitude": locationArray.last.latitude.toString(),
      // "longitude":locationArray.last.longitude.toString(),
      "pharmacyID": pharmacyID ?? selectedPharmacy?.pharmacyId ?? AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.pharmacyID),
      "vehicle_id": selectedVehicleData != null ? selectedVehicleData?.id : vehicleId ?? "",
    };

    String url = WebApiConstant.GET_UPDATE_ORDER_STATUS_WITH_START_ROUTES;
    PrintLog.printLog("Clicked on Continue:::234:::$url");

    await apiCtrl.startRoutesAPI(context:context,url: url, dictParameter: dictparm)
        .then((result) async {

      PrintLog.printLog("Clicked on Continue:::234:::url");

      if(result != null){
        /// Use For Hid Show Start Route Dialog
        if(isShowRouteStartDialog) {
          Get.back(closeOverlays: true);
          isShowRouteStartDialog = false;
        }
        try {
          if (result.toString().toLowerCase() == kOutForDelivery.toLowerCase()) {
            isRouteStart = true;
            orderListType = 4;
            // await driverDashboardApi(context: context);
            await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.isStartRoute, variableValue: "true");
            changeLoadingValue(false);
            changeSuccessValue(true);
            selectWithTypeCount(context: context,orderListNum: orderListType);
            PrintLog.printLog(result.data);

          }else if(result.data.startsWith("{\"error\":true")){
            changeLoadingValue(false);
            changeSuccessValue(false);

            Map<dynamic, dynamic> map = jsonDecode(result.data);
            if (map != null && map["message"] != null) {
              PopupCustom.simpleDialogBox(
                  onValue: (value){

                  },
                  context: context,
                  msg: map["message"].toString()
              );
            }

          } else {

            await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.isStartRoute, variableValue: "");
            ToastCustom.showToast(msg: result.data.toString());
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.data);


          }

        } catch (_) {

          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");


        }

      }else{
        /// Use For Hid Show Start Route Dialog
        if(isShowRouteStartDialog) {
          Get.back(closeOverlays: true);
          isShowRouteStartDialog = false;
        }
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);

      }
    });
    update();
  }


  void selectWithTypeCount({required BuildContext context,required int orderListNum}) async {
    if (selectedRoute?.routeId != null && selectedRoute?.routeId != "" && selectedRoute!.routeId!.isNotEmpty) {
      orderListType = orderListNum;
        if (orderListNum == 4) {
          orderListType = 4;
            await getDeliveriesWithRouteStart(context: context).then((value) async {
              await checkEndRouteData();
            });
          /// await getParcelBoxApi(context: context);
        } else {
          await driverDashboardApi(context: context);
        }

    update();
    } else {
      ToastUtils.showCustomToast(context, kSelectRouteAgain);
    }
  }

  /// On Start Route Get Deliveries
  Future<GetDeliveryApiResponse?> getDeliveriesWithRouteStart({required BuildContext context,bool? isShowBigLoader,bool? isHideSmallLoader}) async {
    await InternetCheck.check();
    if(isShowBigLoader == true) {
      isShowRouteStartDialog = true;
      PopupCustom.showLoadingDialogOnRouteStarting();
    }

    changeEmptyValue(false);
    changeLoadingValue(isHideSmallLoader == true ? false : true );
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "driverId": userID,
      "routeId": selectedRoute?.routeId ?? "0",
      "latitude": currentLatitude,
      "longitude": currentLongitude,
      // "latitude": locationArray.last.latitude.toString(),
      // "longitude":locationArray.last.longitude.toString(),

    };

    String url = WebApiConstant.GET_SORTEDLIST_BY_DURATION;

    await apiCtrl.getDeliveriesWithRouteStartApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if(isShowRouteStartDialog) {
          Get.back(closeOverlays: true);
          isShowRouteStartDialog = false;
        }
        try {
          if (result.status == true) {
            // driverDashboardData = result;
            orderListType = 4;
            isRouteStart = result.isStart ?? false;

            if(result.systemTime != null && result.systemTime!.isNotEmpty && driverType.toLowerCase() != kSharedDriver.toLowerCase()){
              systemDeliveryTime = int.parse(result.systemTime.toString() ?? "0");
              await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.deliveryTime, variableValue: result.systemTime.toString());
            }

            /// Save list in DB
            if(result.deliveryList != null && result.deliveryList!.isNotEmpty && isRouteStart){
              await dbCTRL.saveOutForDeliverList(deliveryList: result.deliveryList ?? []);
            }


            await dbCTRL.getOutForDeliverList().then((value) async {
              if(value.isNotEmpty){
                GetDeliveryApiResponse data = GetDeliveryApiResponse();
                data.deliveryList = value;
                data.status = result.status;
                data.pageNumber = result.pageNumber;
                data.pageSize = result.pageSize;
                data.totalRecords = result.totalRecords;
                data.orderCounts = result.orderCounts;
                data.isStart = result.isStart;
                data.message = result.message;
                data.isOrderAvailable = result.isOrderAvailable;
                data.checkUpdateApp = result.checkUpdateApp;
                data.notificationCount = result.notificationCount;
                data.exemptions = dbCTRL.getExemptions;
                data.onLunch = result.onLunch;
                data.systemTime = result.systemTime;

                driverDashboardData = data;
                driverDashboardData?.totalRecords = value.length;
                 isNextPharmacyAvailable = value.indexWhere((element) => element.orderId == "0");
              }else{
                orderListType = 4;
                // selectWithTypeCount(context: context,orderListNum: orderListType);
              }
              PrintLog.printLog("deliveryTime $systemDeliveryTime");

              if(systemDeliveryTime == null){
                String timeDelivery = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deliveryTime) ?? "";
                systemDeliveryTime = timeDelivery != "null" && timeDelivery != "" ? int.parse(timeDelivery.toString() ?? "0"):0;
              }


                if (stopWatchTimer == null) {
                  stopWatchTimer = StopWatchTimer(
                    mode: StopWatchMode.countDown,
                    onEnded: () {
                      update();
                    },
                    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(systemDeliveryTime ?? 0), // millisecond => minute.
                  );
                  stopWatchTimer?.secondTime.listen((value) async {
                   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.deliveryTime, variableValue: value.toString());

                    if (value <= 0) {
                      showIncreaseTime = true;
                      stopWatchTimer = StopWatchTimer(
                        mode: StopWatchMode.countUp,
                        presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0), // millisecond => minute.
                      );
                      stopWatchTimer?.onStartTimer();
                      update();
                    }
                  });
                  stopWatchTimer?.onStartTimer();
                }

            });

            changeLoadingValue(false);
            changeSuccessValue(true);

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
          }

        } catch (_) {

          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");

        }
      }else{
        if(isShowRouteStartDialog) {
          Get.back(closeOverlays: true);
          isShowRouteStartDialog = false;
        }
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


  /// Get Out for delivery list from DB
  Future<void> getAllOutForDeliveryDataFromDB()async{
    await dbCTRL.getOutForDeliverList().then((value) async {
      if(value.isNotEmpty){
        GetDeliveryApiResponse data = GetDeliveryApiResponse();
        data.deliveryList = await dbCTRL.getOutForDeliverList();
        data.status = true;
        data.pageNumber = 1;
        data.pageSize = 500;
        data.totalRecords = null;
        data.orderCounts = null;
        data.isStart = true;
        data.message = "";
        data.isOrderAvailable = null;
        data.checkUpdateApp = null;
        data.notificationCount = null;
        data.exemptions =  await dbCTRL.getExemptionList();
        data.onLunch = null;
        data.systemTime = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deliveryTime);

        driverDashboardData = data;
        driverDashboardData?.totalRecords = value.length;
        isNextPharmacyAvailable = value.indexWhere((element) => element.orderId == "0");

        update();
      }else{
        orderListType = 4;
        PrintLog.printLog("No delivery are available");
      }

      if(systemDeliveryTime == null){
        String timeDelivery = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deliveryTime) ?? "0";
        systemDeliveryTime = timeDelivery != "null" && timeDelivery != "" ? int.parse(timeDelivery.toString() ?? "0") :0;
      }

      if (stopWatchTimer == null) {
        stopWatchTimer = StopWatchTimer(
          mode: StopWatchMode.countDown,
          onEnded: () {
            update();
          },
          presetMillisecond: StopWatchTimer.getMilliSecFromSecond(systemDeliveryTime ?? 0), // millisecond => minute.
        );
        stopWatchTimer?.secondTime.listen((value) async {
          await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.deliveryTime, variableValue: value.toString());

          if (value <= 0) {
            showIncreaseTime = true;
            stopWatchTimer = StopWatchTimer(
              mode: StopWatchMode.countUp,
              presetMillisecond: StopWatchTimer.getMilliSecFromSecond(0), // millisecond => minute.
            );
            stopWatchTimer?.onStartTimer();
            // update();
          }
        });
        stopWatchTimer?.onStartTimer();
      }

    });
    update();
  }


  /// Check Offline Delivery Available
  Future<void> checkOfflineDeliveryAvailable({required BuildContext context,required bool value}) async {
    var completeAllList = await MyDatabase().getAllOrderCompleteData();
    if (completeAllList != null && completeAllList.isNotEmpty) {

      isDialogShowing = true;
      showDialog(
          context: Get.overlayContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: CustomDialogBox(
                icon: const Icon(Icons.timer),
                title: kAlert,
                descriptions: kUpdatingAndEndingRouteMsg,
              ),
            );
          }
      );
      await dbCTRL.checkPendingCompleteDataInDB(context: context).then((value) async {
        await endRouteApi(context: context);
      });

    } else {
      if (driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty && !value) {

        PopupCustom.simpleTruckDialogBox(
            context: Get.overlayContext!,
            title: kAlert,
            subTitle: kEndRouteWarning,
            btnActionTitle: kEndRoute,
            btnActionColor: AppColors.redColor,
            onValue: (value) async {
              if(value.toString() == "yes") {
                await endRouteApi(context: context);
              }
            },
        );
      } else{
        await endRouteApi(context: Get.overlayContext!);
      }
    }
  }

  /// End route api
  Future<void> endRouteApi({required BuildContext context}) async {
    await InternetCheck.check();
    if(isDialogShowing == true){
      Get.back();
    }

    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    String url = "";
    if (userType?.toLowerCase() == kPharmacy.toLowerCase() || userType?.toLowerCase() == kPharmacyStaffString.toLowerCase()) {
      changeLoadingValue(false);
      changeSuccessValue(false);
      GoToDashboard.go(userType: userType ?? "");
      return;
    } else {

      Map<String, dynamic> dictparm = {
        "routeId": selectedRoute?.routeId ,
      };
      url = WebApiConstant.END_ROUTE_BY_DRIVER;

      apiCtrl.endRoutesAPI(context: context,url: url,dictParameter: dictparm).then((response) async {

        try {
          if (response != null) {
            if (response.data.toString().toLowerCase() == "true") {
              changeLoadingValue(false);
              changeSuccessValue(true);
              var deliveryListData = await MyDatabase().getAllOutForDeliveriesOnly();
              systemDeliveryTime = null;
              if (deliveryListData == null || deliveryListData.isEmpty) {
                AppSharedPreferences.removeValueToSharedPref(variableName: AppSharedPreferences.deliveryTime);
                if (stopWatchTimer != null) {
                  PrintLog.printLog("stopwatch disposed");
                  showIncreaseTime = false;
                  stopWatchTimer?.dispose();
                  stopWatchTimer = null;
                }
              }


              AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.isStartRoute, variableValue: "false");

              isRouteStart = false;
              if(!isRouteStart){
                orderListType = 8;
                await driverDashboardApi(context: context);
              }
              // if (isAutoEndRoute) autoEndRoutePopUp();
              // autoEndRoutePopUp(context: context);
            }else{
              changeLoadingValue(false);
              changeSuccessValue(false);
            }
          }else{
            changeLoadingValue(false);
            changeSuccessValue(false);
          }
        } catch (e, stackTrace) {
          changeLoadingValue(false);
          changeSuccessValue(false);
          changeErrorValue(true);
          SentryExemption.sentryExemption(e, stackTrace);
          String jsonUser = jsonEncode(e);
          ToastCustom.showToast(msg: jsonUser);
        }
      }).catchError((onError) async {
        changeLoadingValue(false);
        changeSuccessValue(false);
        changeErrorValue(true);
        String jsonUser = jsonEncode(onError);
        ToastCustom.showToast(msg: jsonUser);
      });
    }
    update();
  }

  /// Get Driver list Api
  Future<void> getDriverList({required BuildContext context, required String routeId}) async {
    await InternetCheck.check();

    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);



    Map<String, dynamic> dictparm = {"routeId": routeId};

    await apiCtrl.requestGetForDriverListApi(context: context, url: WebApiConstant.Get_PHARMACY_DriverList_ByRoute, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
          driverList.clear();
          DriverModel driverModel = DriverModel();
          driverModel.driverId = "0";
          driverModel.firstName = "Select Driver";
          driverList.add(driverModel);

          List data = result.data;
          data.forEach((element) {
            DriverModel model = DriverModel();
            model.driverId = element["driverId"].toString();
            model.firstName = element["firstName"].toString();
            model.middleNmae = element["middleNmae"].toString();
            model.lastName = element["lastName"].toString();
            model.mobileNumber = element["mobileNumber"].toString();
            model.emailId = element["emailId"].toString();
            model.routeId = element["routeId"].toString();
            model.route = element["route"].toString();
            driverList.add(model);
          });

          PrintLog.printLog("Total Driver list Length: ${driverList.length}");
          changeLoadingValue(false);
          changeSuccessValue(true);

        } catch (_) {
          changeLoadingValue(false);
          changeSuccessValue(false);
          changeErrorValue(true);

          PrintLog.printLog("Exception : $_");
        }
      } else {
        changeLoadingValue(false);
        changeSuccessValue(false);

      }
    });
    update();

  }

  /// Reschedule Order Api
  Future<RescheduleDeliveryResponse?> getRescheduleOrderApi({
    required BuildContext context,
    required String orderId,
    required String rescheduleDate,
    required String driverId,
    required String routeId,
  }) async {

    await InternetCheck.check();

    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

      Map<String, dynamic> dictparm = {
        "orderId": orderId,
        "rescheduleDate": rescheduleDate,
        "driverId": driverId,
        "routeId": routeId,
      };

      apiCtrl.rescheduleOrderApi(context: context,url: WebApiConstant.RESCHEDULE_DELIVERY_URL,dictParameter: dictparm).then((response) async {

        try {
          if (response != null) {
            if (response.error == false) {
              Get.back();
              changeLoadingValue(false);
              changeSuccessValue(true);

              PopupCustom.simpleTruckDialogBox(
                  onValue: (value){
                    if(value.toString().toLowerCase() == "yes"){
                      driverDashboardApi(context: context);
                    }
                  },
                  context: context,
                title: kAlert,
                subTitle: response.message ?? "",
                btnBackTitle: "",
                btnActionTitle: kOk,

              );

            }else{
              changeLoadingValue(false);
              changeSuccessValue(false);
            }
          }else{
            changeLoadingValue(false);
            changeSuccessValue(false);
          }
        } catch (e, stackTrace) {
          changeLoadingValue(false);
          changeSuccessValue(false);
          changeErrorValue(true);
          SentryExemption.sentryExemption(e, stackTrace);

        }
      }).catchError((onError) async {
        changeLoadingValue(false);
        changeSuccessValue(false);
        changeErrorValue(true);

      });

    update();
  }


  /// Get Delivery Master Data Api use for Delivery Schedule
  Future<GetDeliveryMasterDataResponse?> getDeliveryMasterData({required BuildContext context, String? pharmacyId}) async {
    await InternetCheck.check();

    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);



    Map<String, dynamic> dictparm = {"pharmacyId": pharmacyId ?? "0"};

    await apiCtrl.getDeliveryMasterDataApi(context: context, url: WebApiConstant.GET_DELIVERY_MASTER_DATA_API, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
          deliveryMasterData = result;
          changeLoadingValue(false);
          changeSuccessValue(true);

        } catch (_) {
          changeLoadingValue(false);
          changeSuccessValue(false);
          changeErrorValue(true);

          PrintLog.printLog("Exception : $_");
        }
      } else {
        changeLoadingValue(false);
        changeSuccessValue(false);

      }
    });
    update();

  }

  /// Get Location
  // Future getLocationData({required BuildContext context}) async {
  //   CheckPermission.checkLocationPermission(context).then((value) async {
  //
  //       locationData = await CheckPermission.getCurrentLocation(
  //           context: context,
  //       onChangedLocation: (LocationData currentLocation){
  //         locationArray.add(currentLocation);
  //         if (locationArray.length > 5) locationArray.removeAt(0);
  //             PrintLog.printLog("Onchanged Location Method calling.....${currentLocation.latitude}");
  //       }
  //       );
  //
  //     // locationData = await checkLocationPermission();
  //       if(locationData != null){
  //         locationArray.add(locationData!);
  //       }
  //
  //       print("Tes2....${locationData?.latitude}");
  //
  //   });
  // }



  /// Local DB Method
  Future<void> checkCompleteDataInDB({required BuildContext context,required bool isUpdateFailed})async{
    isAvlInternet = await ConnectionValidator().check();
    if(isAvlInternet && isUpdateFailed != true) {
      await MyDatabase().getAllOrderCompleteData().then((value) async {
        await removeOrderInDashboardList(value: value);
      });

      await dbCTRL.checkPendingCompleteDataInDB(context: context).then((value) async {
        // await driverDashboardApi(context: context);
        await getDeliveriesWithRouteStart(context: context,isHideSmallLoader: true);
      });
    }else if(isAvlInternet && isUpdateFailed == true){
      await MyDatabase().getAllOrderCompleteData().then((value) async {
        await removeOrderInDashboardList(value: value);
      });

      await dbCTRL.checkPendingCompleteDataInDB(context: context).then((value) {
        driverDashboardData?.deliveryList?.clear();
        driverDashboardApi(context: context);
      });

    }else{
      getAllOutForDeliveryDataFromDB().then((value) {

      });
    }
  }

  /// Remove Order
  Future<void> removeOrderInDashboardList({required List<order_complete_data> value })async{
    if(driverDashboardData != null && driverDashboardData?.deliveryList !=null && driverDashboardData!.deliveryList!.isNotEmpty){
      await Future.forEach(value, (element) async {
      var newValue = element.deliveryId.toString().split(",");

      newValue.forEach((element2) {
        int indexAvl =  driverDashboardData!.deliveryList!.indexWhere((element) => element.orderId.toString() == element2.toString());
        if(indexAvl >= 0){
          driverDashboardData?.deliveryList?.removeAt(indexAvl);
          update();
        }
      });

    });

    }
  }




  ///---------///--------///---------///--------///---------///--------///---------///--------///---------///--------

  NotificationCountApiResponse? notificationCountData;

  Future<NotificationCountApiResponse?> notificationCountApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "":""
    };

    String url = WebApiConstant.GET_NOTIFICATION_COUNT;

    await apiCtrl.getNotificationCountApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {
              notificationCountData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);


            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog(result.message);
            }

          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }




  void changeSuccessValue(bool value){
    isSuccess = value;
    update();
  }
  void changeLoadingValue(bool value){
    isLoading = value;
    update();
  }
  void changeEmptyValue(bool value){
    isEmpty = value;
    update();
  }
  void changeNetworkValue(bool value){
    isNetworkError = value;
    update();
  }
  void changeErrorValue(bool value){
    isError = value;
    update();
  }


  _toRadians(double degree) {
    return degree * pi / 180;
  }


  getDistance(startLatitude, startLongitude, endLatitude, endLongitude) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  void autoEndRoutePopUp({context}) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset(strIMG_DelTruck),
            title: kAlert,
            btnDone: kOkay,
            descriptions: kRouteEnd,
          );
        });
  }

  void reArrangingRoutePopup(context) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomPopUp.ReArrangeRoutePopUp(context: context);
        });
  }

  void openCalender(StateSetter sateState1, BuildContext context) {
    DateTime date = DateTime.now();
    String selectedDate;
    String selectedDateTimeStamp;

    showDatePicker(
        context: context,
        initialDate: DateTime(date.year, date.month, date.day),
        firstDate: DateTime(date.year, date.month, date.day),
        lastDate: DateTime(2050),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.orangeAccent),
                buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child!);
        }).then((pickedDate) {
      if (pickedDate == null) return;
      sateState1(() {
        selectedDate = formatter.format(pickedDate);
        selectedDateTimeStamp = pickedDate.millisecondsSinceEpoch.toString();
      });
    });
  }

}
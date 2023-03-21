import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_GetDeliveryListController/P_get_delivery_list_controller.dart';
import '../P_NursingHomeController/p_nursinghome_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class PDeliveriesScreenController extends GetxController {
  final ApiController _apiCtrl = ApiController();


  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  int selectedDriverPosition = 0;
  bool todaySelected = false;
  bool tomorrowSelected = false;
  bool otherDateSelected = false;


  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController  getRouteListController = Get.put(PharmacyGetRouteListController());

  NursingHomeController getNurHomeCtrl = Get.put(NursingHomeController());
  GetDeliveryListController getDeliveryListController = Get.put(GetDeliveryListController());


  int selectedRouteID = 0;
   String? accessToken, userType;

  String selectedDate = "";
  String showDatedDate = "";
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  @override
  void onInit() {
    super.onInit();
    final DateTime now = DateTime.now();
    selectedDate = formatter.format(now);
    showDatedDate = formatterShow.format(now);
    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString(AppSharedPreferences.authToken);
      userType = value.getString(AppSharedPreferences.userType) ?? "";
    });
  }


  ///Select Route
  void onTapSelectedRoute(
      {required BuildContext context, required controller}) {
    PrintLog.printLog("Clicked on Select route");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: getRouteListController.selectedroute?.routeId,
      listType: "route",
      onValue: (value) async {
        if (value != null) {
          getRouteListController.selectedroute = value;
          await getDriverListController.getDriverList(
              context: context, routeId: getRouteListController.selectedroute?.routeId);
          update();
          PrintLog.printLog("Selected Route: ${getRouteListController.selectedroute?.routeName}");
        }
      },
    );
  }

  ///Select Driver
  void onTapSelectedDriver(
      {required BuildContext context,
        required controller})
  {
    PrintLog.printLog("Clicked on Select driver");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: getDriverListController.selectedDriver?.driverId,
      listType: "driver",
      onValue: (value) async {
        if (value != null) {
          getDriverListController.selectedDriver = value;
          update();
          PrintLog.printLog("Selected Driver is::::: ${getDriverListController.selectedDriver?.firstName}");
          PrintLog.printLog("Selected Driver id::::: ${getDriverListController.selectedDriver?.driverId}");
        }
      },
    );
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



  onTodayTap() {

    if (getRouteListController.selectedroute?.routeId != 0) {

      todaySelected = true;
      tomorrowSelected = false;
      otherDateSelected = false;
      print(getRouteListController.selectedroute?.routeId.toString());
      getDeliveryListController.getDeliveryList(routeID: getRouteListController.selectedroute?.routeId??'0',
          driverId: getDriverListController.selectedDriver?.driverId??'0');
    } else {
      ToastCustom.showToast(msg: kSelectRoute);
     }
  }

 }

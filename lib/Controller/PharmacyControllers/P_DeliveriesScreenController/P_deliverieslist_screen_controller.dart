import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/CustomDialogBox.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/PharmacyModels/P_FetchDeliveryListModel/P_fetch_delivery_list_model.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_NursingHomeController/p_nursinghome_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class PDeliveriesScreenController extends GetxController {
  final ApiController _apiCtrl = ApiController();

  String selectedTopBtnName = "";
  int orderListType = 1;
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  int selectedDriverPosition = 0;
  bool todaySelected = true;
  bool tomorrowSelected = false;
  bool otherDateSelected = false;

  ///delivery list
  P_FetchDeliveryListModel? getDeliveryResponse;
  List<ListData> totalList = [];
  List<ListData> pickedUpList = [];
  List<ListData> deliveredList = [];
  List<ListData> failedList = [];
  List userDetails = [];

  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController getRouteListController = Get.put(PharmacyGetRouteListController());

  NursingHomeController getNurHomeCtrl = Get.put(NursingHomeController());

  int selectedRouteID = 0;
  String? accessToken, userType;

  String selectedDate = "";
  String showDatedDate = "";
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  var date = '';

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
  void onTapSelectedRoute({required BuildContext context, required controller}) {
    PrintLog.printLog("Clicked on Select route");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: getRouteListController.selectedroute?.routeId,
      listType: "route",
      onValue: (value) async {
        if (value != null) {
          getRouteListController.selectedroute = value;
          await getDriverListController.getDriverList(context: context, routeId: getRouteListController.selectedroute?.routeId);
          update();
          PrintLog.printLog("Selected Route: ${getRouteListController.selectedroute?.routeName}");
        }
      },
    );
  }

  ///Select Driver
  void onTapSelectedDriver({required BuildContext context, required controller}) {
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
          onTodayTap();
          PrintLog.printLog("Selected Driver is::::: ${getDriverListController.selectedDriver?.firstName}");
          PrintLog.printLog("Selected Driver id::::: ${getDriverListController.selectedDriver?.driverId}");
        }
      },
    );
  }

  onTodayTap() {
    if (getRouteListController.selectedroute?.routeId != 0 && getDriverListController.selectedDriver?.driverId != 0) {
      todaySelected = true;
      tomorrowSelected = false;
      otherDateSelected = false;
      print("Selected route id is ::>>" + getRouteListController.selectedroute!.routeId.toString());
      fetchDeliveryList(routeID: getRouteListController.selectedroute?.routeId ?? '0', driverId: getDriverListController.selectedDriver?.driverId ?? '0', dateType: 1).then((value) {
        print(pickedUpList[0]);
      });
    } else {
      ToastCustom.showToast(msg: kSelectRoute);
    }
    update();
  }

  onTomorrowTap() {
    if (getRouteListController.selectedroute?.routeId != 0) {
      todaySelected = false;
      tomorrowSelected = true;
      otherDateSelected = false;
      print(getRouteListController.selectedroute?.routeId.toString());
      fetchDeliveryList(routeID: getRouteListController.selectedroute?.routeId ?? '0', driverId: getDriverListController.selectedDriver?.driverId ?? '0', dateType: 2);
    } else {
      ToastCustom.showToast(msg: kSelectRoute);
    }
    update();
  }

  onOtherDayTap() {
    if (getRouteListController.selectedroute?.routeId != 0) {
      todaySelected = false;
      tomorrowSelected = false;
      otherDateSelected = true;
      print(getRouteListController.selectedroute?.routeId.toString());
      fetchDeliveryList(routeID: getRouteListController.selectedroute?.routeId ?? '0', driverId: getDriverListController.selectedDriver?.driverId ?? '0', dateType: 3);
    } else {
      ToastCustom.showToast(msg: kSelectRoute);
    }
    update();
  }

  void changeSuccessValue(bool value) {
    isSuccess = value;
    update();
  }

  void changeLoadingValue(bool value) {
    isLoading = value;
    update();
  }

  void changeEmptyValue(bool value) {
    isEmpty = value;
    update();
  }

  void changeNetworkValue(bool value) {
    isNetworkError = value;
    update();
  }

  void changeErrorValue(bool value) {
    isError = value;
    update();
  }

  ///fetch delivery list

  Future<P_FetchDeliveryListModel?> fetchDeliveryList({context, required routeID, required driverId, required int dateType}) async {
    if (dateType == 1) {
      date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      update();
    } else if (dateType == 2) {
      final now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      final tomorrow = DateTime(now.year, now.month, (now.day + 1));
      date = formatter.format(tomorrow);
      update();
    } else if (dateType == 3) {
      date = selectedDate;

      update();
    }
    PrintLog.printLog("GET DELIVERY LIST INITIALIZED ");
    Map<String, dynamic> dictparm = {
      "routeId": routeID,
      "dateTime": date,
      "driverId": driverId,
    };
    String url = WebApiConstant.GET_PHARMACY_DELIVERY_LIST;
    await _apiCtrl.fetchPharmacyDeliveryListapi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
          getDeliveryResponse = result;
          assignDatatoLists(result: result);

          PrintLog.printLog("result.....${result.list?.length.toString()}");
        } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
        }
      } else {
        CustomLoading().show(context, false);

        update();
      }
    });
    update();
    CustomLoading().show(context, false);
  }

  assignDatatoLists({required result}) {
    totalList.clear();
    pickedUpList.clear();
    deliveredList.clear();
    failedList.clear();

    result.list.forEach((element) {
      if (element.deliveryStatusDesc == "PickedUp") {
        pickedUpList.add(element);
        print("PickedUp ${pickedUpList.length}");
      } else if (element.deliveryStatusDesc == "Received") {
        totalList.add(element);
        print("totalList ${totalList.length}");
      } else if (element.deliveryStatusDesc == "Completed") {
        deliveredList.add(element);
        print("deliveredList ${deliveredList.length}");
      } else if (element.deliveryStatusDesc == "Failed") {
        failedList.add(element);
        print("Failed ${failedList.length}");
      }
    });
  }

  onTotalListTap({
    required BuildContext context,
    required int orderId,
    required String patientName,
    required String patientAddress,
    required String patientMobileNumber,
    required String DeliveryNotes,
    required String ExistingNotes,
  }) {
    totalList.indexWhere((element) => element.orderId == orderId);
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CustomDialogBox(
          title: "Order Id $orderId",
          button2: Text("Update Status"),
          descriptionWidget: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Details',
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
              Column(

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patientName ?? ""),
                  Text(patientAddress ?? ""),
                  Text(patientMobileNumber ?? ""),
                  Row(
                    children: [

                      const Text("DeliveryNotes:"),
                      Text(DeliveryNotes ?? ""),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Existing Notes:"),

                      Text(ExistingNotes ?? ""),
                    ],
                  ),
                ],
              )
            ],
          ),
          button1: const Text("Cancel"),
        );
      },
    );
  }
}

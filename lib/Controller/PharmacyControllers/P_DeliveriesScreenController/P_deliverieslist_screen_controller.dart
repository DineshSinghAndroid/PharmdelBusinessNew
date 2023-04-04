import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/CustomDialogBox.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/ParcelBox/parcel_box_response.dart';
import '../../../Model/PharmacyModels/P_FetchDeliveryListModel/P_fetch_delivery_list_model.dart';
import '../../WidgetController/AdditionalWidget/Other/other_widget.dart';
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

  ///Dropdown select type
  String selectTypeDropdownValue = 'PickedUp';
  var selectStatus = [
    'Completed',
    'Failed',
    'Cancelled',
    'Received',
    'Requested',
    'Ready',
    'PickedUp',
  ];

  ///Dropdown select Parcle Box
  String selectParcleBoxLocation = 'Parcel Box 1';
  var selectParcleBoxLocaitonItems = [
    'Parcel Box 1',

  ];
  ///parcel list
  List<ParcelBoxData>? parcelBoxList;

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

  TextEditingController deliveryRemarkController = TextEditingController();
  int selectedRouteID = 0;
  String? accessToken, userType;

  String selectedDate = "";
  String showDatedDate = "";
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  var date = '';

  bool checkBoxValue = false;


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
          getParcelBoxApi(context: context);
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
      PrintLog.printLog("Selected route id is ::>>${getRouteListController.selectedroute!.routeId}");
      fetchDeliveryList(routeID: getRouteListController.selectedroute?.routeId ?? '0', driverId: getDriverListController.selectedDriver?.driverId ?? '0', dateType: 1).then((value) {
        PrintLog.printLog(pickedUpList[0]);
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
      PrintLog.printLog(getRouteListController.selectedroute?.routeId.toString());
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
      PrintLog.printLog(getRouteListController.selectedroute?.routeId.toString());
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

  ///Get parcel box data
  Future<GetParcelBoxApiResponse?> getParcelBoxApi({required BuildContext context}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {"driverId": getDriverListController.selectedDriver?.driverId};

    String url = WebApiConstant.GET_PHARMACY_PARCEL_BOX_URL;

    await _apiCtrl.getParcelBoxApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        try {
          if (result.error == false) {
            parcelBoxList = result.data;
            print("Hello world parcel box testing ${result.data![0].name}");
            result.data == null ? changeEmptyValue(true) : changeEmptyValue(false);
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
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    // if (Ts != null) {
    //   var now = DateTime.now();
    //   var berlinWallFellDate = DateTime.utc(Ts!.year, Ts!.month, Ts!.day);
    //   if (berlinWallFellDate.compareTo(now) < 0) {
    //     subExpiryPopUp(context);
    //   }
    // }
    update();
  }

  ///Assign data to each list after driver select
  assignDatatoLists({required result}) {
    totalList.clear();
    pickedUpList.clear();
    deliveredList.clear();
    failedList.clear();
    result.list.forEach((element) {
      if (element.deliveryStatusDesc == "PickedUp") {
        pickedUpList.add(element);
        PrintLog.printLog("PickedUp ${pickedUpList.length}");
      } else if (element.deliveryStatusDesc == "Received") {
        totalList.add(element);
        PrintLog.printLog("totalList ${totalList.length}");
      } else if (element.deliveryStatusDesc == "Completed") {
        deliveredList.add(element);
        PrintLog.printLog("deliveredList ${deliveredList.length}");
      } else if (element.deliveryStatusDesc == "Failed") {
        failedList.add(element);
        PrintLog.printLog("Failed ${failedList.length}");
      }
    });
  }
///List tap
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
        return onListTapPopup(orderId, patientName, patientAddress, patientMobileNumber, DeliveryNotes, ExistingNotes);
      },
    );
  }
///List Tap Popup
  CustomDialogBox onListTapPopup(int orderId, String patientName, String patientAddress, String patientMobileNumber, String DeliveryNotes, String ExistingNotes) {
    return CustomDialogBox(
      title: "Order Id $orderId",
      descriptionWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              kPatientDetails,
              style: TextStyle(color: Colors.orange, fontSize: 20),
            ),
          ),
          buildSizeBox(10.0, 0.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "$kname :",
                    style: TS.CTS(16.0, Colors.black, FontWeight.bold),
                  ),
                  Text(
                    "$patientName",
                    style: TS.CTS(16.0, Colors.black, FontWeight.normal),
                  ),
                ],
              ),
              buildSizeBox(10.0, 0.0),
              Row(
                children: [
                  Text(
                    "$kaddress :",
                    style: TS.CTS(16.0, Colors.black, FontWeight.bold),
                  ),
                  Text(
                    "$patientAddress",
                    style: TS.CTS(16.0, Colors.black, FontWeight.normal),
                  ),
                ],
              ),
              buildSizeBox(10.0, 0.0),
              Row(
                children: [
                  Text(
                    "$kMobileNumber :",
                    style: TS.CTS(16.0, Colors.black, FontWeight.bold),
                  ),
                  Text(
                    patientMobileNumber,
                    style: TS.CTS(16.0, Colors.black, FontWeight.normal),
                  ),
                ],
              ),
              buildSizeBox(10.0, 0.0),
              Row(
                children: [
                  Text(
                    "$kDeliveryNote :",
                    style: TS.CTS(16.0, Colors.black, FontWeight.bold),
                  ),
                  Text(DeliveryNotes),
                ],
              ),
              buildSizeBox(10.0, 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$kExistingDelNote :",
                    style: TS.CTS(16.0, Colors.black, FontWeight.bold),
                  ),
                  Expanded(child: Text(ExistingNotes ?? "")),
                ],
              ),
              buildSizeBox(10.0, 0.0),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    hint: const Text("Select Status"),
                    value: selectTypeDropdownValue,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: selectStatus.map((String selectStatus) {
                      return DropdownMenuItem(
                        value: selectStatus,
                        child: Text(selectStatus),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      selectTypeDropdownValue = value!;
                      update();
                    },
                  ),
                ),
              ),
              buildSizeBox(10.0, 0.0),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    hint: const Text("Select Parcle Location"),
                    value: selectParcleBoxLocation,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: selectParcleBoxLocaitonItems.map((String selectParcleBoxLocation) {
                      return DropdownMenuItem(
                        value: selectParcleBoxLocation,
                        child: Text(selectParcleBoxLocation),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      selectParcleBoxLocation = value!;
                      update();
                    },
                  ),
                ),
              ),
              WidgetCustom.pharmacyTopSelectWidget(
                title:
                parcelBoxList![1].name.toString() != null ?  parcelBoxList![1].name.toString() ??"": 'Select Parcel Box',
                onTap: () {
                  update();

                }),

              buildSizeBox(10.0, 0.0),
              CustomTextField(
                readOnly: false,
                hintText: "Delivery Remark",
                controller: deliveryRemarkController,
                keyboardType: TextInputType.text,
              ),
              Wrap(
                children: [
                  Container(
                    width: Get.width / 2.4,
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: AppColors.colorOrange,
                            visualDensity: const VisualDensity(horizontal: -4),
                            value: checkBoxValue,
                            onChanged: (value) {
                              PrintLog.printLog("value $value");
                            }),
                        const Text("Read Delivery Note")
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width / 2.7,
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: AppColors.colorOrange,
                            visualDensity: const VisualDensity(horizontal: -4),
                            value: checkBoxValue,
                            onChanged: (value) {
                              PrintLog.printLog("value $value");
                            }),
                        const Text("Cd Check")
                      ],
                    ),
                  ),
                  Container(
                    width: Get.width / 2.7,
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: AppColors.colorOrange,
                            visualDensity: const VisualDensity(horizontal: -4),
                            value: checkBoxValue,
                            onChanged: (value) {
                              PrintLog.printLog("value $value");
                            }),
                        const Text("Frieze Check")
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      button1: MaterialButton(
        child: const Text(kCancel),
        onPressed: () {
          Get.back();
        },
      ),
      button2: MaterialButton(
        child: const Text(kUpdateStatus),
        onPressed: () {},
      ),
    );
  }
}

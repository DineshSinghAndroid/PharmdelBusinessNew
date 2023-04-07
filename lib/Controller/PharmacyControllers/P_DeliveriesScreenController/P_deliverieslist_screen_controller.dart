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
import '../P_GetParcelBoxLocationController/p_get_parcel_box_location_controller.dart';
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

  ///delivery list
  P_FetchDeliveryListModel? getDeliveryResponse;
  List<ListData> totalList = [];
  List<ListData> pickedUpList = [];
  List<ListData> deliveredList = [];
  List<ListData> failedList = [];
  List userDetails = [];

  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController getRouteListController = Get.put(PharmacyGetRouteListController());
  GetParcelBoxLocationController getParcelBoxController = Get.put(GetParcelBoxLocationController());

  NursingHomeController getNurHomeCtrl = Get.put(NursingHomeController());

  TextEditingController deliveryRemarkController = TextEditingController();
  TextEditingController deliveryToController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController rxChargeController = TextEditingController();
  int selectedRouteID = 0;
  String? accessToken, userType;

  String selectedDate = "";
  String showDatedDate = "";
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  var date = '';

  ///read notes and other , listTap Popup
  bool readDelNoteCheckbox = false;
  bool cdCheckCheckbox = false;
  bool fridzeCheckCheckbox = false;
  bool submitError = true;

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
          PrintLog.printLog("Selected Driver is::::: ${getDriverListController.selectedDriverPosition}");

          await getParcelBoxController.getParcelBoxApi(context: context, driverId: getDriverListController.selectedDriver?.driverId ?? "0");
          await onTodayTap();

          PrintLog.printLog("Selected Driver id::::: ${getDriverListController.selectedDriver?.driverId}");
        }
      },
    );
  }

  onTodayTap() async {
    if (getRouteListController.selectedroute?.routeId != 0 && getDriverListController.selectedDriver?.driverId != 0) {
      todaySelected = true;
      tomorrowSelected = false;
      otherDateSelected = false;
      PrintLog.printLog("Selected route id is ::>>${getRouteListController.selectedroute?.routeId}");
      await fetchDeliveryList(routeID: getRouteListController.selectedroute?.routeId ?? '0', driverId: getDriverListController.selectedDriver?.driverId ?? '0', dateType: 1).then((value) {
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

          ///two list coming, sorted and normal , change to sorted list if any issue comes out
          assignDataToLists(result: result);
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

  ///Assign data to each list after driver select
  assignDataToLists({required result}) {
    totalList.clear();
    pickedUpList.clear();
    deliveredList.clear();
    failedList.clear();
    result.list.forEach((element) async {
      if (element.deliveryStatusDesc == "PickedUp" || element.deliveryStatusDesc == "OutForDelivery") {
        pickedUpList.add(element);
        PrintLog.printLog("PickedUp list ${pickedUpList.length}");
      } else if (element.deliveryStatusDesc == "Received" || element.deliveryStatusDesc == "Requested" || element.deliveryStatusDesc == "Ready") {
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
    required String deliveryNotes,
    required String existingNotes,
    required String patientBagSize,
    required String isCdType,
    required String isFridze,
    required String rxCharge,
    required int rxInvoice,
    required String delCharge,
    required String exemptionName,
  }) {
    totalList.indexWhere((element) => element.orderId == orderId);
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return onListTapPopup(orderId, patientName, patientAddress, patientMobileNumber, deliveryNotes, existingNotes, patientBagSize, isCdType, isFridze, rxCharge, rxInvoice, delCharge);
      },
    );
  }

  ///List Tap Popup
  SingleChildScrollView onListTapPopup(int orderId, String patientName, String patientAddress, String patientMobileNumber, String deliveryNotes, String existingNotes, String patientBagSize, String isCdType, String isFridze, String rxCharge, int? rxInvoice, String delCharge) {
    return SingleChildScrollView(
      child: SafeArea(
        child: CustomDialogBox(
          title: "Order Id:- $orderId $submitError",
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
                        patientName,
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
                      Expanded(
                        child: Text(
                          patientAddress,
                          style: TS.CTS(16.0, Colors.black, FontWeight.normal),
                        ),
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
                      Text(deliveryNotes),
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
                      Expanded(child: Text(existingNotes ?? "")),
                    ],
                  ),
                  buildSizeBox(10.0, 0.0),

                  ///del type select box select
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

                  ///Parcel box select
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
                        hint: const Text("Select Parcel Location"),
                        value: getParcelBoxController.selectParcelBoxLocation,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: getParcelBoxController.ParcleBoxList?.map((parcelBox) {
                          return DropdownMenuItem(
                            value: parcelBox.name,
                            child: Text(parcelBox.name.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          getParcelBoxController.selectParcelBoxLocation = value.toString();
                          update();
                        },
                      ),
                    ),
                  ),
                  buildSizeBox(10.0, 0.0),

                  ///Deliver to
                  CustomTextField(
                    readOnly: false,
                    hintText: "Delivery To",
                    controller: deliveryToController,
                    keyboardType: TextInputType.text,
                  ),
                  buildSizeBox(10.0, 0.0),

                  ///Delivery Remark widget
                  CustomTextField(
                    readOnly: false,
                    hintText: "Delivery Remark",
                    controller: deliveryRemarkController,
                    keyboardType: TextInputType.text,
                  ),
                  buildSizeBox(10.0, 0.0),

                  ///Delivery charge and Rx Charge
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(  horizontal: 5,vertical: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: [

                              const Text("Delivery Charge: "),
                              Text(delCharge??"0.0",style: const TextStyle(color: Colors.green),),
                            ],
                          ),
                        ),
                      ),

                      buildSizeBox(0.0, 10.0),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(20))),
                          child:      Row(
                        children: [

                        const Text("Rx Charges: "),
                        Text(rxCharge??"0.0",style: const TextStyle(color: Colors.green),),
                        ],
                      ),
                        ),
                      ),
                    ],
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
                                value: readDelNoteCheckbox,
                                onChanged: (value) {
                                  readDelNoteCheckbox = !readDelNoteCheckbox;
                                  PrintLog.printLog("value $value");
                                  update();
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
                                activeColor: AppColors.redColor,
                                visualDensity: const VisualDensity(horizontal: -4),
                                value: cdCheckCheckbox,
                                onChanged: (value) {
                                  cdCheckCheckbox = !cdCheckCheckbox;
                                  update();
                                }),
                            const Text("Cd Check")
                          ],
                        ),
                      ),
                      Container(
                        width: Get.width / 2,
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: AppColors.colorOrange,
                                visualDensity: const VisualDensity(horizontal: -4),
                                value: fridzeCheckCheckbox,
                                onChanged: (value) {
                                  fridzeCheckCheckbox = !fridzeCheckCheckbox;
                                  update();
                                  PrintLog.printLog("value $value");
                                }),
                            const Text("Frieze Check")
                          ],
                        ),
                      ),
                      if (patientBagSize != "")
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          width: 100,
                          decoration: const BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(30))),
                          child: Row(
                            children: [const Text("Bag Size:"), Text(patientBagSize.toString() ?? "")],
                          ),
                        )
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
            onPressed: () {
              ///check delivery note and existing note
              if (deliveryNotes.toString().isNotEmpty || existingNotes.toString().isNotEmpty) {
                print("deliveryNotes ::>>$deliveryNotes");
                print("existingNotes ::>>$existingNotes");
              }

              ///check cd and frieze
              if (isCdType.toString() == "t" || isFridze.toString() == "t") {
              } else {
                submitError == false;
                update();
                print("submitError  >>$submitError");
              }
            },
          ),
        ),
      ),
    );
  }

  void checkValidations() {}
}

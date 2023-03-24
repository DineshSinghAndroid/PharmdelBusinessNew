import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:xml2json/xml2json.dart';

import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../../Model/DriverRoutes/get_route_list_response.dart';
import '../../../Model/Enum/enum.dart';
import '../../../Model/NotificationCount/notificationCountResponse.dart';
import '../../../Model/OrderDetails/orderdetails_response.dart';
import '../../../Model/ParcelBox/parcel_box_response.dart';
import '../../../Model/VehicleList/vehicleListResponse.dart';
import '../../../View/MapScreen/map_screen.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../Helper/ConnectionValidator/internet_check_return.dart';
import '../../Helper/Permission/PermissionHandler.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../RouteController/RouteNames.dart';
import '../../WidgetController/BottomSheet/BottomSheetCustom.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/Popup/PopupCustom.dart';
import '../../WidgetController/Popup/popup.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../WidgetController/Toast/ToastCustom.dart';
import '../MainController/main_controller.dart';

class DriverDashboardCTRL extends GetxController {
  ApiController apiCtrl = ApiController();
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  bool isBulkScanSwitched = false;
  bool isRouteStart = false;

  // String selectedType = "total";
  int receivedCount = 0;
  int? selectedRoutId;

  /// isShowReSchedule
  bool isShowReSchedule = false;

  /// Get rout Data
  RouteList? selectedRoute;
  List<RouteList>? routeList;
  List<AllRouteList>? allRouteList;
  List<PharmacyList>? pharmacyList;
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

  /// Vehicle list
  List<VehicleListData>? vehicleListData;
  VehicleListData? selectedVehicleData;

  /// Get Deliver list data
  GetDeliveryApiResponse? driverDashboardData;

  /// Location Array
  List<LocationData> locationArray = [];
  LocationData? locationData;
  Location? location;

  void isBulkScanSwitchedValue(bool value) {
    isBulkScanSwitched = value;
    update();
  }

  void onTapAppBarMap({required BuildContext context}) {
    Get.toNamed(mapScreenRoute,
        arguments: MapScreen(driverId: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId), routeId: selectedRoutId.toString() ?? ""));
  }

  void onTapAppBarQrCode({required BuildContext context}) {
    Get.toNamed(mapScreenRoute,
        arguments: MapScreen(driverId: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId), routeId: selectedRoutId.toString() ?? ""));
  }

  void onTapSelectRoute({required BuildContext context, required controller}) {
    PrintLog.printLog("Clicked on Select route");
    if (isRouteStart) {
      ToastCustom.showToast(msg: kChangeRouteMsg);
    } else {
      BottomSheetCustom.showSelectAddressBottomSheet(
        controller: controller,
        context: context,
        selectedID: selectedRoute?.routeId,
        listType: "route",
        onValue: (value) async {
          if (value != null) {
            selectedRoute = value;
            await driverDashboardApi(context: context).then((value) {
              update();
            });
            PrintLog.printLog("Selected ParcelBox: ${selectedRoute?.routeName}");
          }
        },
      );
    }
  }

  void onTapSelectParcelLocation({required BuildContext context, required controller}) {
    PrintLog.printLog("Clicked on Select parcel location");
    if (isRouteStart) {
      ToastCustom.showToast(msg: kChangeRouteMsg);
    } else {
      BottomSheetCustom.showSelectAddressBottomSheet(
        controller: controller,
        context: context,
        listType: "parcel",
        selectedID: selectedParcelBox?.id,
        onValue: (value) {
          if (value != null) {
            selectedParcelBox = value;
            update();
            PrintLog.printLog("Selected ParcelBox: ${selectedParcelBox?.name}");
          }
        },
      );
    }
  }

  Future<void> onTapMaTopDeliveryListBtn({required BuildContext context, required int btnType}) async {
    orderListType = btnType;
    PrintLog.printLog("Clicked on Btn Type: $btnType..Order_list_type: $orderListType");
    if (selectedRoute?.routeId != null && selectedRoute?.routeId.toString() != "" && selectedRoute?.routeId.toString() != "null") {
      await driverDashboardApi(context: context);
    } else {
      ToastCustom.showToast(msg: kFirstSelectRoute);
    }
  }

  Future<void> onTapDeliveryListItem({required BuildContext context, required int index}) async {
    if ((driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kFailedDelivery)) {
      if (driverType.toLowerCase() == kDedicatedDriver) {
        driverDashboardData?.deliveryList?[index].isSelected = !driverDashboardData!.deliveryList![index].isSelected!;

        /// getCheckSelected
        var data = driverDashboardData?.deliveryList?.where((element) => element.isSelected == true);
        if (data != null && data.isNotEmpty) {
          isShowReSchedule = data.first.isSelected ?? false;
        } else {
          isShowReSchedule = false;
        }
        update();
      }
    } else if (driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kOutForDelivery) {
      orderListType = 4;
      orderListType != 1
          ? scanBarcodeNormal(
              context: context,
              isOutForDelivery: true,
              customerId: int.parse(driverDashboardData?.deliveryList?[index].customerDetials?.customerId.toString() ?? "0"),
              orderId: driverDashboardData?.deliveryList?[index].nursing_home_id == null ||
                      driverDashboardData?.deliveryList?[index].nursing_home_id == "" ||
                      driverDashboardData?.deliveryList?[index].nursing_home_id == "null" ||
                      driverDashboardData?.deliveryList?[index].nursing_home_id == "0"
                  ? int.parse(driverDashboardData?.deliveryList?[index].orderId.toString() ?? "0")
                  : 0)
          : null;
    } else if ((driverDashboardData?.deliveryList?[index].status?.toLowerCase() == kReadyDelivery) ||
        (driverDashboardData?.deliveryList?[index].status?.toLowerCase() == "readyfordelivery") ||
        driverDashboardData?.deliveryList?[index].status?.toLowerCase() == "pickedup" ||
        (driverDashboardData?.deliveryList?[index].status?.toLowerCase() == "received") ||
        (driverDashboardData?.deliveryList?[index].status?.toLowerCase() == "requested")) {
      if (!isRouteStart) {
        orderDetailApi(
            context: context,
            routeID: selectedRoute?.routeId.toString() ?? "0",
            orderID: driverDashboardData?.deliveryList?[index].orderId ?? "",
            isScan: false,
            isComplete: false,
            orderIdMain: 0);
      } else if (isRouteStart) {
        PopupCustom.showAlertRouteStartedPopUp(context: context);
      }
    }
  }

  Future<void> onTapAppBarRefresh({required BuildContext context}) async {
    // await driverRoutesApi(context: context);
    // await getParcelBoxApi(context: context,driverID: userID);
    // vehicleListApi(context: context);
    update();
  }

  /// Route list api
  Future<GetRouteListResponse?> driverRoutesApi({
    required BuildContext context,
  }) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {"pharmacyId": "0"};

    String url = WebApiConstant.GET_DRIVER_ROUTES;

    await apiCtrl.getDriverRoutesApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        try {
          if (result.status == true) {
            routeList = result.routeList;
            allRouteList = result.allRouteList;
            pharmacyList = result.pharmacyList;
            nHomeList = result.nHomeList;
            status = result.status;
            isOrderAvailable = result.isOrderAvailable;
            vehicleInspection = result.vehicleInspection;
            vehicleId = result.vehicleId;

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
    update();
  }

  /// Get delivery list api
  Future<GetDeliveryApiResponse?> driverDashboardApi({
    required BuildContext context,
  }) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {"routeId": selectedRoute?.routeId, "page": "1", "PageSize": "30", "Status": orderListType};

    String url = WebApiConstant.GET_DELIVERY_LIST;

    await apiCtrl.getDriverDashboardApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        if (result.status != false) {
          try {
            if (result.status == true) {
              driverDashboardData = result;
              result == null ? changeEmptyValue(true) : changeEmptyValue(false);
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
          PrintLog.printLog(result.message);
        }
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  /// Parcel box list api
  Future<GetRouteListResponse?> getParcelBoxApi({required BuildContext context}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {"driverId": userID};

    String url = WebApiConstant.GET_PHARMACY_PARCEL_BOX_URL;

    await apiCtrl.getParcelBoxApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
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
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  ///Vehicle List Api
  Future<VehicleListApiResponse?> vehicleListApi({required BuildContext context, required bool isStartRoute}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {"": ""};

    String url = WebApiConstant.GET_VEHICLE_LIST_URL;

    await apiCtrl.getVehicleListApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        if (result.status != false) {
          try {
            if (result.status == true) {
              if (isStartRoute) {
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
                  vehicleListData = result.list;
                }
              }

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
        } else {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.status);
        }
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  /// Scan Barcode Normal
  Future<void> scanBarcodeNormal({required BuildContext context, required bool isOutForDelivery, required int customerId, required int orderId}) async {
    // checkLastTime(context);
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes != "-1") {
        FlutterBeep.beep();

        if (isOutForDelivery) {
          orderDetailApi(context: context, orderID: barcodeScanRes, isScan: true, isComplete: true, orderIdMain: 0, routeID: selectedRoutId.toString());
        } else if (!isOutForDelivery) {
          orderListType = 1;
          orderDetailApi(context: context, orderID: barcodeScanRes, isScan: true, isComplete: false, orderIdMain: 0, routeID: selectedRoutId.toString());
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

  ///Order Details Api // model check
  Future<OrderModal?> orderDetailApi(
      {required BuildContext context, required String orderID, required String routeID, required bool isScan, required bool isComplete, required int orderIdMain}) async {
    await InternetCheck.check();

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "OrderId": orderID,
      "driverId": AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId),
      "isScan": isScan,
      "routeId": routeID,
      "isComplete": isComplete,
      "orderIdMain": orderIdMain
    };

    String url = WebApiConstant.SCAN_ORDER_BY_DRIVER;

    await apiCtrl.getOrderDetailApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        try {
          if ((result.message == "") ||
              isComplete ||
              result.deliveryStatusDesc.toString().toLowerCase() == "received" ||
              result.deliveryStatusDesc.toString().toLowerCase() == "ready" ||
              result.deliveryStatusDesc.toString().toLowerCase() == "requested" ||
              result.deliveryStatusDesc.toString().toLowerCase() == "pickedUp") {
            if (result.deliveryStatusDesc.toString().toLowerCase() == "completed") {
              ToastCustom.showToast(msg: "This order already completed.");
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
              PrintLog.printLog('ScanDetailPage ${result.delCharge}');
              showAlertOrderPopUp(deliveryDetails: result, context: context);
            }
          } else if (result.message != null) {
            ToastCustom.showToast(msg: result.message ?? "");
          } else {
            orderListType = 1;
          }
          changeLoadingValue(false);
          changeSuccessValue(true);
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
    update();
  }

  Future<void> showAlertOrderPopUp({required BuildContext context, required OrderModal deliveryDetails}) async {
    try {
      if (deliveryDetails != null && deliveryDetails.related_orders != null && deliveryDetails.related_orders!.isNotEmpty && deliveryDetails.related_orders!.length > 1) {
        if (deliveryDetails.related_order_count != null && deliveryDetails.related_order_count! > 0) {
          showDialog<ConfirmAction>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context1) {
                return CustomDialogBox(
                  img: Image.asset(strImgDelTruck),
                  title: kMultipleDelivery,
                  btnDone: kYes,
                  btnNo: kNo,
                  descriptions: "${deliveryDetails.related_order_count} $kMoreDeliveryForThisAddress",
                  onClicked: (value) {
                    // showOrderList(deliveryDetails, value);
                  },
                );
              });
        } else {
          // showOrderList(deliveryDetails, true);
        }
      } else {
        if (deliveryDetails.deliveryStatusDesc == "PickedUp") {
          // await MyDatabase().getExemptionsList().then((value) async {
          //   deliveryDetails.exemptions = [];
          //   if (value != null && value.isNotEmpty) {
          //     await Future.forEach(value, (element) {
          //       ExemptionsList exemptions = ExemptionsList();
          //       exemptions.id = element.exemptionId;
          //       exemptions.serialId = element.serialId;
          //       exemptions.name = element.name;
          //
          //       deliveryDetails.exemptions.add(exemptions);
          //     });
          //   }
          // });

          // deliveryDetails.related_orders?.clear();
          // ReletedOrders reletedOrders = ReletedOrders();
          // reletedOrders.orderId = deliveryDetails.orderId;
          // reletedOrders.pharmacyId = deliveryDetails.pharmacyId;
          // reletedOrders.rxCharge = deliveryDetails.rxCharge;
          // reletedOrders.rxInvoice = deliveryDetails.rxInvoice;
          // reletedOrders.delCharge = deliveryDetails.delCharge;
          // reletedOrders.subsId = deliveryDetails.subsId;
          // reletedOrders.isDelCharge = deliveryDetails.isDelCharge;
          // reletedOrders.isPresCharge = deliveryDetails.isPresCharge;
          // reletedOrders.exemption = deliveryDetails.exemption;
          // reletedOrders.paymentStatus = deliveryDetails.paymentStatus;
          // reletedOrders.bagSize = deliveryDetails.bagSize;
          // reletedOrders.parcelName = deliveryDetails.customer?.surgeryName;
          // reletedOrders.pharmacyName = "";
          // reletedOrders.userId = deliveryDetails.customerId;
          // reletedOrders.fullName = (deliveryDetails.title != null ? deliveryDetails.title + " " : "") +
          //     (deliveryDetails.firstName != null ? "${deliveryDetails.firstName} " : "") +
          //     (deliveryDetails.middleName != null ? deliveryDetails.middleName : "") +
          //     (deliveryDetails.lastName != null ? " ${deliveryDetails.lastName}" : "");
          // reletedOrders.fullAddress = deliveryDetails.address?.alt_address;
          // reletedOrders.isStorageFridge = deliveryDetails.isStorageFridge;
          // reletedOrders.deliveryNotes = ""; // need to add
          // reletedOrders.isSelected = false;
          // reletedOrders.isCronCreated = "f";
          // reletedOrders.alt_address = deliveryDetails.address?.alt_address;
          // reletedOrders.existing_delivery_notes = deliveryDetails.exitingNote; // need to add
          // reletedOrders.isControlledDrugs = deliveryDetails.isControlledDrugs;
          // reletedOrders.pmr_type = deliveryDetails.pmr_type;
          // reletedOrders.pr_id = deliveryDetails.pr_id;
          // deliveryDetails.related_orders?.add(reletedOrders);
        }
        if (deliveryDetails != null && deliveryDetails.related_orders != null && deliveryDetails.related_orders!.isNotEmpty && deliveryDetails.related_orders!.length == 1) {
          PrintLog.printLog('Delivery222');
        }
        // redirectToDetailsPage(deliveryDetails, deliveryDetails.related_orders[0].orderId, deliveryDetails.related_orders?[0].rxInvoice, deliveryDetails.delCharge, deliveryDetails.subsId);
      }
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      PrintLog.printLog(e);
    }
  }

  /// Get Deliveries With Route Api
  Future<VehicleListApiResponse?> getDeliveriesApi({required BuildContext context, required bool isStartRoute}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {"": ""};

    String url = WebApiConstant.GET_VEHICLE_LIST_URL;

    await apiCtrl.getVehicleListApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        if (result.status != false) {
          try {
            if (result.status == true) {
              if (isStartRoute) {
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
                  vehicleListData = result.list;
                }
              }

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
        } else {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.status);
        }
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  /// BottomNavigation Bar Dashboard
  Widget bottomNavigationBarDashboard({required BuildContext context}) {
    return orderListType != 1
        ? orderListType == 8 && driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty && !isRouteStart
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () async {
                  // await vehicleListApi(context: context,isStartRoute: true).then((value) {
                  //   if (locationArray.isNotEmpty) {
                  //     PrintLog.printLog("Staring routeitssss ");
                  //     confirmationPopupForStartRoute();
                  //   } else {
                  //     PrintLog.printLog("Unable to start routeitssss ");
                  //     getLocationData(context: context);
                  //   }
                  // });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "START ROUTE",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 5,
                        height: 0,
                      ),
                      //SvgPicture.asset("assets/fast_forward.svg", height: 18, width: 18, color: Colors.white,)
                    ],
                  ),
                ),
              )
            : (isRouteStart && orderListType == 4) //&& !isProgressAvailable
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              onPressed: () async {
                                // bool checkInternet = await ConnectionValidator().check();
                                // if (!checkInternet) {
                                //   PopupCustom.noInternetPopUp(context: context,msg: kInternetNotAvailable);
                                // } else
                                //   Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestionScreen())).then((value) {
                                //     if (isRouteStart) {
                                //       orderListType = 4;
                                //       selectWithTypeCount(WebConstant.Status_out_for_delivery);
                                //     }
                                //   });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    BuildText.buildText(text: kBulkDrop.toUpperCase(), size: 16, color: AppColors.whiteColor, weight: FontWeight.w700),
                                    buildSizeBox(0.0, 5.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (driverDashboardData != null && driverDashboardData?.deliveryList != null && driverDashboardData!.deliveryList!.isNotEmpty) buildSizeBox(0.0, 20.0),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                            ),
                            onPressed: () async {
                              bool checkInternet = await ConnectionValidator().check();
                              if (!checkInternet) {
                                PopupCustom.noInternetPopUp(context: context, msg: kInternetNotAvailable);
                              } else {
                                // checkOfflineDeliveryAvailable(false);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  BuildText.buildText(text: kEndRoute.toUpperCase(), size: 16, color: AppColors.whiteColor, weight: FontWeight.w700),
                                  buildSizeBox(0.0, 5.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : (isRouteStart &&
                        orderListType == 4 &&
                        driverDashboardData != null &&
                        driverDashboardData?.deliveryList != null &&
                        driverDashboardData!.deliveryList!.isNotEmpty) //&& !isProgressAvailable
                    ?

                    /// Comment buk drop button
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SuggestionScreen())).then((value) {
                          //   if (isRouteStart) {
                          //     orderListType = 4;
                          //     selectWithTypeCount(WebConstant.Status_out_for_delivery);
                          //   }
                          // });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              BuildText.buildText(text: kBulkDrop.toUpperCase(), size: 16, color: AppColors.whiteColor, weight: FontWeight.w700),
                              buildSizeBox(0.0, 5.0),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
        : const SizedBox.shrink();
  }

  // void selectWithTypeCount({required BuildContext context,required int orderListType}) async {
  //   isDelivery = false;
  //   if (selectedRoute?.routeId != null && selectedRoute?.routeId != "" && selectedRoute!.routeId!.isNotEmpty) {

  //       if (orderListType == 4) {
  //         orderListType = 4;
  //         getParcelList(0);
  //       } else {
  //         fetchDeliveryList(0);
  //       }

  //   update();
  //   } else {
  //     ToastUtils.showCustomToast(context, kSelectRouteAgain);
  //   }
  // }

  /// Get Location
  Future getLocationData({required BuildContext context}) async {
    CheckPermission.checkLocationPermission(context).then((value) async {
      if (value == true) {
        locationData = await location?.getLocation();
        location?.changeSettings(distanceFilter: 10, accuracy: LocationAccuracy.high);
        location?.enableBackgroundMode(enable: true);
        location?.onLocationChanged.listen((LocationData currentLocation) {
          locationArray.add(currentLocation);
          if (locationArray.length > 5) locationArray.removeAt(0);
        });
      } else {
        await location?.requestPermission();
      }
    });
  }

  ///---------///--------///---------///--------///---------///--------///---------///--------///---------///--------

  NotificationCountApiResponse? notificationCountData;

  Future<NotificationCountApiResponse?> notificationCountApi({
    required BuildContext context,
  }) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {"": ""};

    String url = WebApiConstant.GET_NOTIFICATION_COUNT;

    await apiCtrl.getNotificationCountApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        if (result.status != false) {
          try {
            if (result.status == true) {
              notificationCountData = result;
              result == null ? changeEmptyValue(true) : changeEmptyValue(false);
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
          PrintLog.printLog(result.message);
        }
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
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

  // Future getLocationData({required BuildContext context}) async {
  //   CheckPermission.checkLocationPermission(context).then((value) async {
  //     Location? location;
  //     LocationData? locationData;
  //     PermissionStatus? permissionGranted;
  //     List<LocationData> locationArray = [];
  //     if (value == true) {
  //       if (location == null) location = Location();
  //       locationData = await location.getLocation();
  //       if (locationData != null) {
  //         locationArray.add(locationData);
  //       }
  //       if (permissionGranted == PermissionStatus.denied) {
  //         permissionGranted = await location.requestPermission();
  //         if (permissionGranted != PermissionStatus.granted) {
  //           return;
  //         }
  //       }
  //       if (permissionGranted == PermissionStatus.granted) {
  //         locationData = await location.getLocation();
  //         location.changeSettings(
  //             distanceFilter: 10, accuracy: LocationAccuracy.high);
  //         location.enableBackgroundMode(enable: true);
  //         location.onLocationChanged.listen((LocationData currentLocation) {
  //           locationArray.add(currentLocation);
  //           if (locationArray.length > 5) locationArray.removeAt(0);
  //         });
  //       }
  //     }
  //   });
  // }

  _toRadians(double degree) {
    return degree * pi / 180;
  }

  void onClieck(bool value) {
    // if (value) endRoute(false);
  }

  getDistance(startLatitude, startLongitude, endLatitude, endLongitude) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(_toRadians(startLatitude)) * cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  void autoEndRoutePopUp(context) {
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

  void endRoutePopup(context) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset(strIMG_DelTruck),
            title: kAlert,
            btnDone: kEndRoute,
            btnNo: kNo,
            onClicked: onClieck,
            descriptions: kEndRouteWarning,
          );
        });
  }

  void openCalender(StateSetter sateState1, BuildContext context) {
    DateTime date = DateTime.now();
    String selectedDate;
    String selectedDateTimeStamp;
    final DateFormat formatter = DateFormat("dd-MM-yyyy");
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

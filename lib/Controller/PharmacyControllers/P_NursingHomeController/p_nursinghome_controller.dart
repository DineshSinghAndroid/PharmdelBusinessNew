import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/WidgetController/AdditionalWidget/Default%20Functions/defaultFunctions.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Model/PharmacyModels/P_GetBoxesResponse/p_getBoxesApiResponse.dart';
import '../../../Model/PharmacyModels/P_NursingHomeOrderResponse/p_nursingHomeOrderResponse.dart';
import '../../../Model/PharmacyModels/P_NursingHomeResponse/p_nursingHomeResponse.dart';
import '../../../Model/PharmacyModels/P_UpdateNursingOrderResponse/p_updateNursingOrderResponse.dart';
import '../../../main.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../RouteController/RouteNames.dart';
import '../../WidgetController/BottomSheet/BottomSheetCustom.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/Toast/ToastCustom.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class NursingHomeController extends GetxController {
  ApiController apiCtrl = ApiController();
  List<NursingHome> nursingHomeList = [];
  List<NursingOrdersData>? nursingOrdersData;
  NursingHome? selectedNursingHome;
  List<BoxesData> boxesListData = [];
  BoxesData? selectedBox;
  UpdateNursingOrderApiResposne? updateOrderData;
  String selectedDate = "";
  String showDatedDate = "";

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');


  /// On Tap CD 
  void onTapWidgetCD({required int index,required BuildContext context})async{
    PrintLog.printLog("onTapWidgetCD.....$index");
  
  nursingOrdersData?[index].isControlledDrugs = nursingOrdersData?[index].isControlledDrugs?.toLowerCase() == "t" ? "f":"t";
  update();

    await getUpdateNursingOrderApi(
      context: context, 
      orderId: nursingOrdersData?[index].orderId ?? "", 
      storageTypeCD: nursingOrdersData?[index].isControlledDrugs, 
      storageTypeFR:nursingOrdersData?[index].isStorageFridge
    ); 
  }

  /// On Tap Fridge 
  void onTapWidgetFridge({required int index,required BuildContext context})async{
    PrintLog.printLog("onTapWidgetFridge.....$index");
  
  nursingOrdersData?[index].isStorageFridge = nursingOrdersData?[index].isStorageFridge?.toLowerCase() == "t" ? "f":"t";
  update();

    await getUpdateNursingOrderApi(
      context: context, 
      orderId: nursingOrdersData?[index].orderId ?? "", 
      storageTypeCD: nursingOrdersData?[index].isControlledDrugs, 
      storageTypeFR:nursingOrdersData?[index].isStorageFridge
    ); 
  }


/// On Tap Cancel Button
  void onTapWidgetCancel({required int index,required BuildContext context}){ 
    PrintLog.printLog("onTapWidgetCancel.....$index");

  }


  ///Get Driver List Controller
  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  ///Get Route List Controller
  PharmacyGetRouteListController getRouteListController = Get.put(PharmacyGetRouteListController());

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
              context: context, routeId: '23');
          update();
          PrintLog.printLog("Selected Route: ${getRouteListController.selectedroute?.routeName}");
        }
      },
    );
  }

  ///Select Driver
  void onTapSelectedDriver(
      {required BuildContext context,
      required controller,
      required String driverId}) {
    PrintLog.printLog("Clicked on Select driver");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: getDriverListController.selectedDriver?.driverId,
      listType: "driver",
      onValue: (value) async {
        if (value != null) {
          getDriverListController.selectedDriver = value;
          await getDriverListController
              .getDriverList(context: context, routeId: driverId)
              .then((value) {
            update();
          });
          PrintLog.printLog("Selected Driver: ${getDriverListController.selectedDriver?.firstName}");
        }
      },
    );
  }

  ///Select Nursing Home
  void onTapSelectNursingHome(
      {required BuildContext context, required controller}) {
    PrintLog.printLog("Clicked on Select Nursing Home");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: selectedNursingHome?.id,
      listType: "nursing home",
      onValue: (value) async {
        if (value != null) {
          selectedNursingHome = value;
          await nursingHomeApi(context: context).then((value) async {
            await boxesApi(context: context, nursingId: '87134');
            update();
          });
          PrintLog.printLog("Selected Nursing Home: ${selectedNursingHome?.nursingHomeName}");
        }
      },
    );
  }

  ///Select Tote
  void onTapSelectTote(
      {required BuildContext context,
      required controller,      
      required String selectDate}) {
    PrintLog.printLog("Clicked on Select Tote");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: selectedBox?.id,
      listType: kSelectTote,
      onValue: (value) async {
        if (value != null) {
          selectedBox = value;
          await boxesApi(context: context, nursingId: selectedNursingHome?.id ?? "").then((value) {
            update();
          }).then((value) async {
            await nursingHomeOrderApi(
              context: context,
              dateTime: selectDate,
              nursingHomeId: selectedNursingHome?.id ?? "",
              driverId: getDriverListController.selectedDriver?.driverId ?? "",
              routeId: getRouteListController.selectedroute?.routeId ?? "",
              toteBoxId: selectedBox?.id ?? "",
            );
          });
          PrintLog.printLog("Selected Tote: ${selectedBox?.boxName}");
        }
      },
    );
  }

  void onTapSelectScanRx() {
    if (getRouteListController.selectedroute?.routeId == null) {
      ToastCustom.showToast(msg: kPlsSlctRoute);
    } else if (getDriverListController.selectedDriver?.driverId == null) {
      ToastCustom.showToast(msg: kPlsSlctDriver);
    } else if (selectedNursingHome?.id == null) {
      ToastCustom.showToast(msg: kPlsSlctNurHome);
    } else if (selectedBox?.id == null) {
      ToastCustom.showToast(msg: kPlsSlctTote);
    } else {
      DefaultFuntions.barcodeScanning();
      Get.toNamed(searchPatientScreenRoute);
    }
  }

  void onTapSelectCloseTote() {
    if (nursingOrdersData != null && nursingOrdersData!.isNotEmpty) {
      Get.back();
    } else {
      ToastCustom.showToast(msg: kPunchSomeDel);
    }
  }


  //  onTapSelectDate({required BuildContext context,}){
  //    PrintLog.printLog("Clicked on Select Date");
  //    DefaultFuntions.datePickerCustom(
  //     context: context,
  //     onTap: ()async{
  //       final DateTime? picked = await showDatePicker(
  //                         builder: (context, child) {
  //                           return Theme(
  //                             data: Theme.of(context).copyWith(
  //                           colorScheme: ColorScheme.light(
  //                           primary: AppColors.colorOrange,
  //                           onPrimary: AppColors.whiteColor,
  //                           onSurface: AppColors.blackColor,
  //                         )),
  //                         child: child!,
  //                           );
  //                         },
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(DateTime.now().year,
  //                             DateTime.now().month, DateTime.now().day),
  //                         lastDate: DateTime(2101));
  //                     if (picked != null) {
  //                       selectedDate = formatter.format(picked);
  //                       showDatedDate = formatterShow.format(picked);
  //                       update();
  //                     }
  //     },
  //     showDate: showDatedDate);
  // }

  ///Nursing Home Controller
  Future<NursingHomeApiResponse?> nursingHomeApi({context}) async {
    nursingHomeList.clear();
    await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {};
    String url = WebApiConstant.GET_PHARMACY_NURSING_HOME;
    await apiCtrl
        .getNursingHomeApi(
            context: context,
            url: url,
            dictParameter: dictparm,
            token: authToken)
        .then((result) {
      if (result != null) {
        try {
          nursingHomeList.addAll(result.nursingHomeData!);
        } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
          ToastCustom.showToast(msg: result.message ?? "");
        }
      } else {
        CustomLoading().show(context, false);

        PrintLog.printLog(result?.message);
        ToastCustom.showToast(msg: result?.message ?? "");
        update();
      }
    });
    update();
    CustomLoading().show(context, false);
  }

  ///Get Boxes Controller
  Future<GetBoxesApiResponse?> boxesApi(
      {required BuildContext context, required String nursingId}) async {
    boxesListData.clear();
    await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {"nursing_id": nursingId};
    String url = WebApiConstant.GET_PHARMACY_BOXES;
    await apiCtrl.getBoxesApi(context: context,url: url,dictParameter: dictparm,token: authToken)
        .then((result) {
      if (result != null) {
        try {
          boxesListData.addAll(result.boxesdata!);
        } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
          ToastCustom.showToast(msg: result.message ?? "");
        }
      } else {
        CustomLoading().show(context, false);

        PrintLog.printLog(result?.message);
        ToastCustom.showToast(msg: result?.message ?? "");
        update();
      }
    });
    update();
    CustomLoading().show(context, false);
  }

  ///Update Nursing Order Controller
  Future<UpdateNursingOrderApiResposne?> getUpdateNursingOrderApi({
    required BuildContext context,
    required String? orderId,
    required String? storageTypeCD,
    required String? storageTypeFR,
  }) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "orderId": orderId,
      "storage_type_cd": storageTypeCD,
      "storage_type_fr": storageTypeFR,
    };

    String url = WebApiConstant.GET_PHARMACY_UPDATE_NURSING_ORDER;

    await apiCtrl.updateNursingOrderApi(context: context,url: url,dictParameter: dictparm,token: authToken).then((result) async {
      if (result != null) {
          try {
            if (result.error == false) {
              updateOrderData = result;
              PrintLog.printLog(result.data);
              PrintLog.printLog(result.message);
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

  ///Get Nursing Order List Controller
  Future<NursingOrderApiResponse?> nursingHomeOrderApi({
    required BuildContext context,
    required String? routeId,
    required String? dateTime,
    String? driverId,
    String? nursingHomeId,
    String? toteBoxId,
  }) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "routeId": routeId,
      "dateTime": dateTime,
      "driverId": driverId,
      "nursing_home_id": nursingHomeId,
      "tote_box_id": toteBoxId,
    };

    String url = WebApiConstant.GET_PHARMACY_DELIVERY_LIST;

    await apiCtrl.getNursingHomeOrderApi(context: context,url: url,dictParameter: dictparm,token: authToken).then((result) async {
      if (result != null) {
        if (result.status != 'false') {
          try {
            if (result.status == 'true') {
              nursingOrdersData = result.nursingOrderData;
              result.nursingOrderData == null
                  ? changeEmptyValue(true)
                  : changeEmptyValue(false);
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
}

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/ProjectController/QrCodeController/qr_response.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:xml2json/xml2json.dart';

import '../../../Model/CreateOrder/driver_create_order_response.dart';
import '../../../Model/ProcessScan/driver_process_scan_response.dart';
import '../../../View/DeliverySchedule/delivery_schedule_screen.dart';
import '../../WidgetController/Popup/popup.dart';
import '../DriverDashboard/driver_dashboard_ctrl.dart';
import '../MainController/main_controller.dart';

class QrCodeController extends GetxController{

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  DriverProcessScanOrderInfo? orderInfo;
  DriverDashboardCTRL driverDasCtrl = Get.find();

  String qrType = "";
  String qrCodeResult = "";
  String amount = "";

  PmrModel? pmrModel;
  List<PmrModel> pmrList = [];


  String? startRouteId;
  String? endRouteId;
  double? startLat;
  double? startLng;


  @override
  void onInit() {
    startRouteId =  AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.startRouteId);
    endRouteId =  AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.endRouteId);
    Future.delayed(const Duration(seconds: 2),(){
      startLat = double.parse(CheckPermission.getLatitude(Get.overlayContext!).toString() ?? "0.0") ?? 0.0;
      startLng = double.parse(CheckPermission.getLongitude(Get.overlayContext!).toString() ?? "0.0") ?? 0.0;
    });

    super.onInit();
  }


  /// On Tap Customer List Widget
  Future<void> onTapListWidget({required BuildContext context})async{
    if(driverDasCtrl.isBulkScanSwitched){
      await updateCustomerWithCreateOrder(context: context,orderInfo: orderInfo!);
    }else{
      Get.offNamed(deliveryScheduleScreenRoute,arguments: DeliveryScheduleScreen(orderInfo: orderInfo!));
    }
  }

  Future<String> getTitle({required String title})async{
    String tittle = "";
    if (title == "Mr") {
      tittle = "M";
    } else if (title.toLowerCase() == "Miss".toLowerCase()) {
      tittle = "S";
    } else if (title.toLowerCase() == "Mrs".toLowerCase()) {
      tittle = "F";
    } else if (title.toLowerCase() == "Ms".toLowerCase()) {
      tittle = "Q";
    } else if (title.toLowerCase() == "Captain".toLowerCase()) {
      tittle = "C";
    } else if (title.toLowerCase() == "Dr".toLowerCase()) {
      tittle = "D";
    } else if (title.toLowerCase() == "Prof".toLowerCase()) {
      tittle = "P";
    } else if (title.toLowerCase() == "Rev".toLowerCase()) {
      tittle = "R";
    } else if (title.toLowerCase() == "Mx".toLowerCase()) {
      tittle = "X";
    }
    return tittle;
  }

  Future<String> getGender({required String title})async{
    String gender = "M";
    if (title.endsWith("Mrs") || title.endsWith("Miss") || title.endsWith("Ms")) {
      gender = "F";
    }
    return gender;
  }


  /// Get Process Scan Api
  Future<DriverProcessScan?> getProcessScan({required BuildContext context}) async {
    FocusScope.of(context).unfocus();

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "scan_type":qrType,
      "prescription_info":qrCodeResult,
      "pharmacyId":"0"
    };

    String url = WebApiConstant.PROCESS_SCAN_URL;

    await apiCtrl.processScanApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if (result.error == false) {
            if(result.isExist != 1){
              if(result.data != null){
                if(result.data?.orderInfo != null){
                  orderInfo = result.data?.orderInfo;
                  // if(isScan){
                  orderInfo?.title = result.data?.orderInfo?.title != null ? result.data?.orderInfo?.title["0"] : "";
                  orderInfo?.firstName = result.data?.orderInfo?.firstName != null ? result.data?.orderInfo?.firstName["0"] : "";
                  orderInfo?.middleName = result.data?.orderInfo?.middleName != null ? result.data?.orderInfo?.middleName["0"] : "";
                  orderInfo?.lastName = result.data?.orderInfo?.lastName != null ? result.data?.orderInfo?.lastName["0"] : "";
                  orderInfo?.nursingHomeId = result.data?.orderInfo?.nursingHomeId != null ? result.data?.orderInfo?.nursingHomeId["0"] : "";
                  orderInfo?.address = result.data?.orderInfo?.address != null ? result.data?.orderInfo?.address["0"] : "";
                  orderInfo?.postCode = result.data?.orderInfo?.postCode != null ? result.data?.orderInfo?.postCode["0"] : "";
                  orderInfo?.nhsNumber = result.data?.orderInfo?.nhsNumber != null ? result.data?.orderInfo?.nhsNumber["0"] : "";
                  // }
                  PrintLog.printLog("Order Info Found::::::::");
                  if(result.data?.orderInfo?.patientsList != null && result.data!.orderInfo!.patientsList!.userId!.isNotEmpty && result.data!.orderInfo!.patientsList!.userId![0].toString().isNotEmpty){
                    if(driverDasCtrl.isBulkScanSwitched){
                      await updateCustomerWithCreateOrder(context: context,orderInfo: orderInfo!);
                    }else{
                      Get.offNamed(deliveryScheduleScreenRoute,arguments: DeliveryScheduleScreen(orderInfo: orderInfo!));
                    }
                  }else{
                    userNotExitsDialog(context: context,orderInfoNew: orderInfo!);
                  }

                }
                result.data == null ? changeEmptyValue(true):changeEmptyValue(false);
                changeLoadingValue(false);
                changeSuccessValue(true);
                PrintLog.printLog(result.message);
              }else{
                changeLoadingValue(false);
                changeSuccessValue(false);
                PrintLog.printLog(result.message);
              }
            }else{
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog(result.message);
            }

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PopupCustom.errorDialogBox(
              onValue: (value){},
              context: context,
              title: kError,
              subTitle: result.message ?? "",
            );
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

  /// Update Customer With Create Order Api
  Future<DriverCreateOrderApiResponse?> updateCustomerWithCreateOrder({required BuildContext context,required DriverProcessScanOrderInfo orderInfo}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);


    String dob = orderInfo.userId != null && orderInfo.userId == "0" ? DateFormat('dd/MM/yyyy').format(DateTime.parse(orderInfo.dob ?? "")) ?? "" : orderInfo.dob ?? "";
    Map<String, dynamic> dictparm = {
      "order_type": "manual",
      "pharmacyId": 0,
      "otherpharmacy": false,
      "pmr_type": "0",
      "endRouteId": driverDasCtrl.isRouteStart ? "$endRouteId" : "0",
      "startRouteId": driverDasCtrl.isRouteStart ? "$startRouteId" : "0",
      "nursing_home_id": orderInfo.nursingHomeId,
      "tote_box_id": driverDasCtrl.selectedParcelBox != null ? driverDasCtrl.selectedParcelBox?.id :"",
      "start_lat": driverDasCtrl.isRouteStart ? "$startLat" : "",
      "start_lng": driverDasCtrl.isRouteStart ? "$startLng" : "",
      "del_subs_id": 0,
      "exemption": 0,
      "paymentStatus": "",
      "bag_size": "",
      "patient_id": orderInfo.userId,
      "pr_id": "",
      "lat": "",
      //na
      "lng": "",
      //na
      "parcel_box_id": driverDasCtrl.selectedParcelBox != null ? "${driverDasCtrl.selectedParcelBox?.id}" : "0",
      "surgery_name": "",
      "surgery": "",
      "amount": "",
      "email_id": "",
      "mobile_no_2": "",
      "dob": "$dob",
      "nhs_number": orderInfo.nhsNumber ?? "",
      "title": await getTitle(title: orderInfo.title ?? ""),
      "first_name": orderInfo.patientsList?.customerName ?? "",
      "middle_name": orderInfo.middleName ?? "",
      "last_name": orderInfo.lastName ?? "",
      "address_line_1": orderInfo.address ?? "",
      "country_id": "",
      "post_code": orderInfo.postCode ?? "",
      "gender": await getGender(title: orderInfo.title ?? ""),
      "preferred_contact_type": "",
      "delivery_type": "Delivery",
      "driver_id": userID,
      "delivery_route": driverDasCtrl.selectedRoute != null ? driverDasCtrl.selectedRoute?.routeId : "0",
      "storage_type_cd": "f",
      "storage_type_fr": "f",
      "delivery_status": driverDasCtrl.isRouteStart ? "4"
          : driverDasCtrl.selectedParcelBox == null ? "8" : "2",
      "nursing_homes_id": 0,
      "shelf": "",
      "delivery_service": orderInfo.defaultService,
      "doctor_name": "",
      "doctor_address": "",
      "new_delivery_notes": "",
      "existing_delivery_notes": orderInfo.defaultDeliveryNote,
      "del_charge": "",
      "rx_charge": "",
      "subs_id": "",
      "rx_invoice": "",
      "branch_notes": "",
      "surgery_notes": "",
      "medicine_name": [],
      "prescription_images": [],
      "delivery_date": driverDasCtrl.bulkScanDate,
    };
    String url = WebApiConstant.UPDATE_CUSTOMER_WITH_CREATE_ORDER;

    await apiCtrl.driverCreateOrderApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if (result.error == false) {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
            if(result.data != null){
              Navigator.of(context).pop("created");
            }

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
            PopupCustom.errorDialogBox(
              onValue: (value){},
              context: context,
              title: kError,
              subTitle: result.message ?? "",
            );
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


  /// first step
  buildQrView({required BuildContext context,}) async {
    try {
      var barcodeScanRes;


      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.BARCODE);

      qrType = "4";
      PrintLog.printLog("Barcode ScanResult : $barcodeScanRes");

      if (barcodeScanRes != "-1") {
        if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.contains("-")
            && barcodeScanRes.split("-").length > 4) {
          qrType = "4";
          await loadPrescription(qrResult: barcodeScanRes,context: context);
        }
        else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("pharm")) {
          qrType = "5";
          await loadPrescription(qrResult: barcodeScanRes,context: context);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("<xml>")) {
          qrType = "1";
          await loadPrescription(qrResult: barcodeScanRes,context: context);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("PSL") && barcodeScanRes.contains(";") && barcodeScanRes.split(";").length > 2) {
          qrType = "4";
          await loadPrescription(qrResult: barcodeScanRes,context: context);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.contains(";") && barcodeScanRes.split(";").length > 2) {
          qrType = "6";
          await loadPrescription(qrResult: barcodeScanRes,context: context);
        }
        else if (barcodeScanRes != null && int.tryParse(barcodeScanRes) != null) {
          qrType = "2";
          await loadPrescription(qrResult: barcodeScanRes,context: context);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.length > 2) {
          qrType = "3";
          await loadPrescription(qrResult: barcodeScanRes,context: context);
        } else {
          ToastCustom.showToast(msg: "QR data not available !");
          Navigator.of(context).pop(true);
        }

      } else if (barcodeScanRes == "-1") {
        if (driverType.toLowerCase() != kSharedDriver.toLowerCase()) {
          Navigator.of(context).pop("search");
        } else {
          ToastCustom.showToast(msg: "Data not fetching. Plz try again !");
          Navigator.of(context).pop(true);
        }
      } else {
        ToastCustom.showToast(msg: "Data not fetching. Plz try again !");
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      PrintLog.printLog("UNABLE TO PRINT ");

      String barcodeScanRes;
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      PrintLog.printLog("barcodeScanRes:$barcodeScanRes");
      PrintLog.printLog("Exception....$_....");
    }
  }


  Future<void> loadPrescription({required String qrResult,required BuildContext context}) async {

    PrintLog.printLog("QR Result: $qrResult");
    PrintLog.printLog("QR Type: $qrType");

    qrCodeResult = qrResult;

    bool isAddPrescription = true;

    try {
      if (qrType == "1") {
        Xml2Json parser = Xml2Json();
        parser.parse(qrResult);

        var json = parser.toGData();

        pmrModel = pmrModelFromJson(json);

        for (PmrModel pmrModel in pmrList) {
          if (pmrModel.xml?.patientInformation?.nhs != pmrModel.xml?.patientInformation?.nhs) {
            ToastCustom.showToast(msg: "Different patient prescriptions, please check and try again!");
            isAddPrescription = false;
            break;
          }
          if (pmrModel.xml?.sc?.id == pmrModel.xml?.sc?.id) {
            ToastCustom.showToast(msg: "This prescription already added!");
            isAddPrescription = false;
            break;
          }
        }
        if (isAddPrescription) {
          PrintLog.printLog("tes....$pmrModel");
          if(driverDasCtrl.isBulkScanSwitched) {
            await getProcessScan(context: context);
          }else{
            // Navigator.of(context).pop({"scan_type":qrType,
            //   "prescription_info":qrCodeResult,});
          }
        } else {
          Navigator.of(context).pop(true);
        }
      }
      else if (qrType == "4" || qrType == "5" || qrType == "6") {
        pmrModel = PmrModel();
        Xml xml = Xml();
        Sc sc = Sc();
        Pa patientInformation = Pa();
        List<Dd> dd = [];
        pmrModel?.xml = xml;
        pmrModel?.xml?.dd = dd;
        pmrModel?.xml?.sc = sc;
        pmrModel?.xml?.patientInformation = patientInformation;
        if (qrType == "4") {
          if (qrCodeResult.contains(";")) {
            print("print_scan ${qrCodeResult}");
            pmrModel?.xml?.sc?.id = qrCodeResult.split(";")[1] ?? "";
            amount = qrCodeResult.split(";").last;
          }
        } else if (qrType == "5") {
          pmrModel?.xml?.sc?.id = qrCodeResult;
        }
        PrintLog.printLog("tes....$pmrModel");
        if(driverDasCtrl.isBulkScanSwitched) {
          await getProcessScan(context: context);
        }else{
          // Navigator.of(context).pop({"scan_type":qrType,
          //   "prescription_info":qrCodeResult,});
        }
        // postDataAndVerifyUser(pmrModel);
      } else if (qrType == "3" || qrType == "2"){
        pmrModel = PmrModel();
        Xml xml = Xml();
        Sc sc = Sc();
        Pa patientInformation = Pa();
        List<Dd> dd = [];
        pmrModel?.xml = xml;
        pmrModel?.xml?.dd = dd;
        pmrModel?.xml?.sc = sc;
        pmrModel?.xml?.patientInformation = patientInformation;
        amount = "";
        PrintLog.printLog("tes....$pmrModel");
        if(driverDasCtrl.isBulkScanSwitched) {
          await getProcessScan(context: context);
        }else{
          // Navigator.of(context).pop({"scan_type":qrType,
          //   "prescription_info":qrCodeResult,});
        }
        // postDataAndVerifyUser(pmrModel);
      }
    } catch (_, stackTrace) {
      PrintLog.printLog("Exception:$_");
      SentryExemption.sentryExemption(_, stackTrace);
      ToastCustom.showToast(msg: "Format not correct!");
      Navigator.of(context).pop(true);
    }
  }

  /// PopUp User Not Exits
  void userNotExitsDialog({required BuildContext context,required DriverProcessScanOrderInfo orderInfoNew}) {

    PopupCustom.simpleTruckDialogBox(
      context: context,
      title: kAlert,
      subTitle: kUserNotRegisterContinueToCreate,
      btnBackTitle: kNo,
      btnActionTitle: kCreate.toUpperCase(),
      onValue: (value){
        PrintLog.printLog("Value is: $value");
        if(value == "yes"){
          Get.offNamed(deliveryScheduleScreenRoute,arguments: DeliveryScheduleScreen(orderInfo: orderInfoNew));
        }else{
          Get.back();
        }
      },
    );

    // showDialog<void>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context1) {
    //     return WillPopScope(
    //       onWillPop: () async => false,
    //       child: AlertDialog(
    //         title: BuildText.buildText(text: kPharmdel),
    //         content: SingleChildScrollView(
    //           child: ListBody(
    //             children: <Widget>[
    //               BuildText.buildText(text: kUserNotRegisterContinueToCreate),
    //             ],
    //           ),
    //         ),
    //         actions: <Widget>[
    //           InkWell(
    //             child: Container(
    //                 padding: const EdgeInsets.all(10),
    //                 child: BuildText.buildText(text: kNo,color: AppColors.blueColor)
    //             ),
    //             onTap: () {
    //               Navigator.of(context1).pop();
    //               Navigator.of(context).pop(false);
    //             },
    //           ),
    //           InkWell(
    //             child: Container(
    //                 padding: const EdgeInsets.all(10),
    //                 child: BuildText.buildText(text: kCreate.toUpperCase(),color: AppColors.blueColor)
    //             ),
    //             onTap: () {
    //               Navigator.of(context1).pop("create");
    //             },
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
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
}
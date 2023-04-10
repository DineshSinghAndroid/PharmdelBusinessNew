import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:pharmdel/Controller/ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/View/DeliverySchedule/delivery_schedule_screen.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Model/CreateOrder/driver_create_order_response.dart';
import '../../../Model/GetPatient/getPatientApiResponse.dart';
import '../../../Model/ProcessScan/driver_process_scan.dart';
import '../../../main.dart';


class SearchPatientController extends GetxController{

  ApiController apiCtrl = ApiController();

  DriverDashboardCTRL driverDasCtrl = Get.find();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  TextEditingController searchTextCtrl = TextEditingController();
  List<PatientData>? patientData;
  DriverProcessScanOrderInfo? orderInfo;

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

  /// On Typing Patient Name
  Future<void> onTypingText({required String value,required BuildContext context})async{
        if(value.toString().trim().isNotEmpty && value.length > 3){
          await getPatientApi(context: context, firstName: value.toString().trim());
        }else{
          patientData?.clear();
          update();
        }
  }

  /// On Tap Patient Tile
  Future<void> onTapPatient({required BuildContext context,required int index})async{
        if(patientData != null && patientData!.isNotEmpty){
          PrintLog.printLog("Patient ID: ${patientData?[index].customerId}");
          if(patientData?[index].customerId != null){
            await getProcessScan(context: context,patientID: patientData?[index].customerId ?? "");
          }else{
            ToastCustom.showToast(msg: kOrderIdNotFound);
          }

        }

  }

  /// Get Patient list Api
  Future<GetPatientApiResposne?> getPatientApi({required BuildContext context,required String firstName}) async {

    changeEmptyValue(false);
    // changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "firstName":firstName
    };

    String url = WebApiConstant.GET_PATIENT_LIST_URL;

    await apiCtrl.getPatientApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {
              patientData = result.list;
              result.list == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);
              PrintLog.printLog(result.message);

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

  /// Get Process Scan Api
  Future<DriverProcessScan?> getProcessScan({required BuildContext context,required String patientID}) async {
    FocusScope.of(context).unfocus();

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "patientid":patientID
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
                    PrintLog.printLog("Order Info Data Added::::::::");
                    if(driverDasCtrl.isBulkScanSwitched){
                      await updateCustomerWithCreateOrder(context: context,orderInfo: result.data!.orderInfo!);
                    }else{
                      Get.offNamed(deliveryScheduleScreenRoute,arguments: DeliveryScheduleScreen(orderInfo: result.data!.orderInfo!));
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
      "first_name": orderInfo.firstName ?? "",
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


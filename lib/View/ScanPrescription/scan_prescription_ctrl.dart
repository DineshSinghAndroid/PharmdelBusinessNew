import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../Controller/ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';


class DriverScanPrescriptionController extends GetxController{

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  bool isAvlInternet = false;

  DriverDashboardCTRL driverDasCtrl = Get.find();



  @override
  void onInit() {
    super.onInit();
  }

  // Future<DriverProfileApiResponse?> driverProfileApi() async {
  //
  //   changeEmptyValue(false);
  //   changeLoadingValue(true);
  //   changeNetworkValue(false);
  //   changeErrorValue(false);
  //   changeSuccessValue(false);
  //
  //   Map<String, dynamic> dictparm = {
  //     "":""
  //   };
  //
  //   String url = WebApiConstant.GET_DRIVER_PROFILE_URL;
  //
  //   await apiCtrl.getDriverProfileApi(url: url, dictParameter: dictparm,token: authToken)
  //       .then((result) async {
  //     if(result != null){
  //       if (result.status != "false") {
  //         try {
  //           if (result.status == "true") {
  //             driverProfileData = result;
  //             versionCode = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.appVersion) ?? "";
  //             showWages = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.showWages) ?? "";
  //             startMile = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.startMiles) ?? "";
  //             endMile = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.endMiles) ?? "";
  //             onBreak = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.lunchBreakStatus).toString().toLowerCase() == "true" ? true:false;
  //
  //             if(onBreak == true){
  //               Future.delayed(
  //                 const Duration(seconds: 1),
  //                     () => Get.toNamed(lunchBreakScreenRoute),
  //               );
  //             }
  //             changeLoadingValue(false);
  //             changeSuccessValue(true);
  //
  //           } else {
  //             changeLoadingValue(false);
  //             changeSuccessValue(false);
  //             PrintLog.printLog("Status : ${result.status}");
  //           }
  //
  //         } catch (_) {
  //           changeSuccessValue(false);
  //           changeLoadingValue(false);
  //           changeErrorValue(true);
  //           PrintLog.printLog("Exception : $_");
  //         }
  //       }else{
  //         changeSuccessValue(false);
  //         changeLoadingValue(false);
  //         changeErrorValue(true);
  //         PrintLog.printLog(result.status);
  //       }
  //     }else{
  //       changeSuccessValue(false);
  //       changeLoadingValue(false);
  //       changeErrorValue(true);
  //     }
  //   });
  //   update();
  // }




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


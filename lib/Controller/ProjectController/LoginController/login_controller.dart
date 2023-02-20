import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadingScreen.dart';
import 'package:pharmdel/main.dart';

import '../../../Model/Login/login_model.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

class LoginController extends GetxController {

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  LoginModel? loginModel;

  Future<LoginModel?> loginApi({
    required BuildContext context,
    required String userMail,
    required String userPass,
    required String deviceName,


  }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "email":userMail,
      "password":userPass,
      "device_name":'device',
      "fcm_token":'',

    };

    String url = WebApiConstant.LOGINURL_DRIVER;

    await apiCtrl.loginApi(context:context,url: url,
        dictParameter: dictparm,token:authToken)
        .then((result) async {
       if(result != null){
        if (result.error != true) {
          try {
            if (result.error == false) {
              await saveUserData(loginData: result);

              loginModel = result;
              result == null ?
              changeEmptyValue(true): changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);
              ToastCustom.showToast(msg: result.message ?? "");



            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog(result.message);
              ToastCustom.showToast(msg: result.message ?? "");

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
          ToastCustom.showToast(msg: result.message ?? "");

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

}


Future<void> saveUserData({LoginModel? loginData})async{
  await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userId, variableValue: loginData?.userId.toString() ?? "");
  await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.driverType, variableValue: loginData?.userType.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.customerID, variableValue: loginData?.customerId.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userName, variableValue: loginData?.name.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.pharmacyID, variableValue: loginData?.pharmacyId.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.authToken, variableValue: loginData?.token.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userPin, variableValue: loginData?.pin.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.startMiles, variableValue: loginData?.startMiles.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.endMiles, variableValue: loginData?.endMiles.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.showWages, variableValue: loginData?.showWages.toString() ?? "");
  authToken = loginData?.token.toString() ?? "";

}


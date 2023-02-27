
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:pharmdel/main.dart';
import '../../../Model/ForgotPassword/forgotPasswordResponse.dart';
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
    ForgotPasswordApiResponse? forgotPassData;

  Future<LoginModel?> loginApi({required BuildContext context, required String userMail, required String userPass,})async{

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "email":userMail,
      "password":userPass,
      "device_name":'android',
      "fcm_token":authToken,
    };


    String url = WebApiConstant.LOGINURL_DRIVER;

    await apiCtrl.getLoginApi(context:context,url: url,dictParameter: dictparm,token:'')
        .then((result) async {
       if(result != null){
        if (result.error != true) {
          try {
            if (result.error == false) {
              await saveUserData(userData: result);
              loginModel = result;
              Get.toNamed(homeScreenRoute);
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


    Future<ForgotPasswordApiResponse?> forgotPasswordApi({required BuildContext context, required String customerEmail,})async{

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "customerEmail":customerEmail,
    };


    String url = WebApiConstant.FORGOT_PASSWORD_URL;

    await apiCtrl.getForgotPasswordApi(context:context,url: url,dictParameter: dictparm,token:'')
        .then((result) async {
       if(result != null){
        if (result.error != true) {
          try {
            if (result.error == false) {            
              forgotPassData = result;              
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


Future<void> saveUserData({LoginModel? userData})async{
  await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userId, variableValue: userData?.userId.toString() ?? "");
  await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.driverType, variableValue: userData?.userType.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.customerID, variableValue: userData?.customerId.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userName, variableValue: userData?.name.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.pharmacyID, variableValue: userData?.pharmacyId.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.authToken, variableValue: userData?.token.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userPin, variableValue: userData?.pin.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.startMiles, variableValue: userData?.startMiles.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.endMiles, variableValue: userData?.endMiles.toString() ?? "");
   await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.showWages, variableValue: userData?.showWages.toString() ?? "");
  authToken = userData?.token.toString() ?? "";

}


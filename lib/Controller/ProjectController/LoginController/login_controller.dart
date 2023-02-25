
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:pharmdel/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    required BuildContext context, required String userMail, required String userPass,})
  async{


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
          ToastCustom.showToast(msg: result.message ?? "");

          try {
            if (result.error == false) {
              await saveUserData(userData: result);
              loginModel = result;
              _loginCheck();
              ToastCustom.showToast(msg: result.message ?? "");
            } else {
              PrintLog.printLog(result.message);
              ToastCustom.showToast(msg: result.message ?? "");
            }
          } catch (_) {

            PrintLog.printLog("Exception : $_");
            ToastCustom.showToast(msg: result.message ?? "");


          }
        }else{

          PrintLog.printLog(result.message);
          ToastCustom.showToast(msg: result.message ?? "");

        }
      }else{

       }
    });
    update();
  }



  Future<void> _loginCheck() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(kQuickPin, loginModel?.pin.toString()??"");
    if (loginModel!.pin != "") {
      if (loginModel!.userType == "Driver") {
        Get.toNamed(homeScreenRoute);
      }
      else if (loginModel!.userType == "Pharmacy Staff") {
        Get.toNamed(pharmacyHomePage);
      }
    }
    else if(loginModel!.pin == "" ){
      Get.toNamed(setupPinScreenRoute);
    }
    else {
ToastCustom.showToast(msg: loginModel!.message??'');
    }

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


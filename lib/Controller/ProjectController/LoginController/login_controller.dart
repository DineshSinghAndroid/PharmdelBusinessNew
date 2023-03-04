import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/ForgotPassword/forgotPasswordResponse.dart';
import '../../../Model/Login/login_model.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../Helper/TextController/TextValidator/TextValidator.dart';
import '../../RouteController/RouteNames.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

class LoginController extends GetxController {

  TextEditingController passCT = TextEditingController();
  TextEditingController emailCT = TextEditingController();
  TextEditingController forgotEmailCT = TextEditingController();

  bool isEmail = false;
  bool isPassword = false;
  bool eyeHide = true;



  bool isCheck = false;
  bool savePassword = true;

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  LoginModel? loginModel;
  ForgotPasswordApiResponse? forgotPassData;


  void textFieldDispose() {
    passCT.dispose();
    emailCT.dispose();
    super.dispose();
  }

  void onChangedCheckBoxValue({required bool value}){
    savePassword = value;
    update();
  }

  Future<void> onTapEye() async {
    eyeHide = !eyeHide;
    update();
  }

  Future<void> onTapLogin({required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    isEmail = TxtValidation.normalTextField(emailCT);
    isPassword = TxtValidation.normalTextField(passCT);

    if(!isEmail && !isPassword){
      await loginApi(context: context, userMail: emailCT.text.toString().trim(), userPass: passCT.text.toString().trim()).then((value) {

      });
    }

    update();
  }

  void showForgotPassword({required BuildContext context}){
    showDialog(
        context: context,
        builder: (context) => CustomDialogBox(
          title: kForgotPassword,
          textField: TextFormField(
            decoration: InputDecoration(
                border: const OutlineInputBorder()
                ,hintText: kEnterEmail
            ),
            controller: forgotEmailCT,
          ),
          descriptions: kEnterYourEmailID,
          button1: MaterialButton(
            onPressed: () async {
              if(forgotEmailCT.text !='') {
                await forgotPasswordApi(context: context, customerEmail: forgotEmailCT.text.toString().trim());
                Navigator.pop(context);
              }
              else{
                ToastCustom.showToast(msg: kEnterYourEmailID);
              }
            },
            child: const Text(kSubmit),
          ),
          button2: MaterialButton(
            onPressed: () {Navigator.pop(context);
            Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        )
    );

  }

  Future<LoginModel?> loginApi({ required BuildContext context, required String userMail, required String userPass}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "email": userMail,
      "password": userPass,
      "device_name": 'android',
      "fcm_token": authToken,
    };

    String url = WebApiConstant.LOGINURL_DRIVER;

    await apiCtrl.getLoginApi(context: context, url: url, dictParameter: dictparm, token: '').then((result) async {
      if (result != null) {
        if (result.error != true) {

          try {
            if (result.error == false) {
              await saveUserData(userData: result);
              loginModel = result;
              _loginCheck();
              ToastCustom.showToast(msg: result.message ?? "");
              changeLoadingValue(false);
              changeSuccessValue(true);
            } else {
              PrintLog.printLog(result.message);
              ToastCustom.showToast(msg: result.message ?? "");
              changeLoadingValue(false);
              changeSuccessValue(false);
            }
          } catch (_) {
            PrintLog.printLog("Exception : $_");
            ToastCustom.showToast(msg: result.message ?? "");
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
          }
        } else {
          // LoadScreen
          // CustomLoading().show(context, false);
          PrintLog.printLog(result.message);
          ToastCustom.showToast(msg: result.message ?? "");
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  Future<ForgotPasswordApiResponse?> forgotPasswordApi({
    required BuildContext context,
    required String customerEmail,
  }) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "customerEmail": customerEmail,
    };

    String url = WebApiConstant.FORGOT_PASSWORD_URL;

    await apiCtrl.getForgotPasswordApi(context: context, url: url, dictParameter: dictparm, token: '').then((result) async {
      if (result != null) {
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
        } else {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
          ToastCustom.showToast(msg: result.message ?? "");
        }
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


  Future<void> _loginCheck() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AppSharedPreferences.userPin, loginModel!.pin.toString());
    prefs.setString(AppSharedPreferences.userType, loginModel!.userType.toString() );
    prefs.setString(AppSharedPreferences.userId, loginModel!.userId.toString()  );

    if (loginModel!.pin != "") {
      if (loginModel!.userType == "Driver") {
        Get.toNamed(securePinScreenRoute);
      } else if (loginModel!.userType == "Pharmacy Staff") {
        Get.toNamed(securePinScreenRoute);
      }
    } else if (loginModel!.pin == "") {
      Get.toNamed(setupPinScreenRoute,arguments: 'false');
    } else {
      ToastCustom.showToast(msg: loginModel!.message ?? '');
    }
  }

  Future<void> saveUserData({LoginModel? userData}) async {

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

    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userEmail, variableValue: userData?.email.toString() ?? "");
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userMobile, variableValue: userData?.mobile.toString() ?? "");
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.companyID, variableValue: userData?.companyId.toString() ?? "");
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.routeID, variableValue: userData?.routeId.toString() ?? "");
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.isStartRoute, variableValue: userData?.isStartRoute.toString() ?? "");
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.driverType, variableValue: userData?.driverType.toString() ?? "");
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userStatus, variableValue: userData?.status.toString() ?? "");

    authToken = userData?.token.toString() ?? "";
    userID = userData?.userId.toString() ?? "";
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

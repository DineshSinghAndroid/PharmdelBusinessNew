import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/popup.dart';
import 'package:pharmdel/View/OnBoarding/SetupPin/setupPin.dart';
import '../../../Model/ForgotPassword/forgotPasswordResponse.dart';
import '../../../Model/Login/login_model.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Firebase/FirebaseMessaging/FirebaseMessaging.dart';
import '../../Helper/DeviceInfo/DeviceInfo.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/SecureStorage/secure_storage.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../Helper/TextController/TextValidator/TextValidator.dart';
import '../../RouteController/RouteNames.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

class LoginController extends GetxController {

  TextEditingController passCT = TextEditingController();
  TextEditingController emailCT = TextEditingController();
  TextEditingController forgotEmailCT = TextEditingController();

  bool isEmail = false;
  bool isPassword = false;
  bool eyeHide = true;
  bool isForgotEmail = false;
  bool savePassword = true;

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;


  @override
  void onInit() {
    autoFillUser();
    // emailCT.text = "ddk@gmail.com";
    // passCT.text = "Admin@1234";
    super.onInit();
  }

  Future<void> autoFillUser() async {
    // FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    // secureStorage.write(key: "NAME", value: "one");
    // // await SecureStorageCustom.save(key: "name",value: "one");
    // String tes = await SecureStorageCustom.getValue(key: "NAME",) ?? "";
    // print("tesx.....");
    // print("tesx.....${tes}..");
    // if(await SecureStorageCustom.getValue(key: "name") != "") {
    //   emailCT.text = SecureStorageCustom.getValue(key: "name").toString();
    //   passCT.text = SecureStorageCustom.getValue(key: "password").toString();
    //   update();
    // }

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      PrintLog.printLog("App version: $version");
      PrintLog.printLog("BuildNumber: $buildNumber");
      await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.appVersion, variableValue: version);
    });
    update();

  }

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
        if(savePassword){
          SecureStorageCustom.save(key: "name",value: emailCT.text.toString().trim());
          SecureStorageCustom.save(key: "password",value: passCT.text.toString().trim());
        }
      });
    }

    update();
  }

  Future<void> onTapForgotPasswordSubmit({required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    isForgotEmail = TxtValidation.normalTextField(forgotEmailCT);

    if(!isForgotEmail){
      await forgotPasswordApi(context: context, customerEmail: forgotEmailCT.text.toString().trim()).then((value) {

      });
    }
    update();
  }

  Future<void> showForgotPassword({required BuildContext context,required LoginController ctrl}) async {
    forgotEmailCT.text = await SecureStorageCustom.getValue(key: "name");
    isForgotEmail = false;
    PopupCustom.forgotPasswordPopUP(
        onValue: (value){

        },
        context: context,
        ctrl: ctrl
    );
  }

  Future<LoginModel?> loginApi({ required BuildContext context, required String userMail, required String userPass}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    String? deviceType = await DeviceInfoCustom.getPlatForm();
    String fcmToken = await FirebaseMessagingCustom.getToken() ?? "";

    Map<String, dynamic> dictparm = {
      "email": userMail,
      "password": userPass,
      "device_name": deviceType,
      "fcm_token": fcmToken,
    };

    String url = WebApiConstant.LOGINURL_DRIVER;

    await apiCtrl.getLoginApi(context: context, url: url, dictParameter: dictparm, token: '').then((result) async {
      if (result != null) {
          try {
            if (result.error == false) {
              await saveUserData(userData: result).then((value){
                String checkIsForgot = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.forgotMPin).toString();
                if (result.pin.toString() != "") {
                  if (checkIsForgot != "" && checkIsForgot != "null") {
                    Get.toNamed(setupPinScreenRoute,arguments: SetupPinScreen(isChangePin: false,));
                  }else if (result.userType.toString().toLowerCase() == "driver") {
                    Get.toNamed(securePinScreenRoute);
                  } else if (result.userType.toString().toLowerCase() == "pharmacy staff") {
                    Get.toNamed(securePinScreenRoute);
                  }
                } else if (result.pin.toString() == "") {
                  Get.toNamed(setupPinScreenRoute,arguments: SetupPinScreen(isChangePin: false,));
                }
              });

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
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  Future<ForgotPasswordApiResponse?> forgotPasswordApi({required BuildContext context,required String customerEmail,}) async {
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
          try {
            if (result.error == false) {
              changeLoadingValue(false);
              changeSuccessValue(true);
              Get.back();

              PopupCustom.emailSentPopUP(
                  context: context,msg: result.message ?? "",
                  onValue: (value){

                    }
              );
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


  Future<void> saveUserData({LoginModel? userData}) async {
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userId, variableValue: userData?.userId.toString() ?? "");
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userType, variableValue: userData?.userType.toString() ?? "");
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pharmdel/Controller/Helper/Permission/PermissionHandler.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/popup.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/View/OnBoarding/SetupPin/setupPin.dart';
import '../../../Model/ForgotPassword/forgotPasswordResponse.dart';
import '../../../Model/Login/login_model.dart';
import '../../../Model/UpdateMiles/update_miles_response.dart';
import '../../../Model/VehicleList/vehicleListResponse.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Firebase/FirebaseMessaging/FirebaseMessaging.dart';
import '../../Helper/Base64/base_64_converter.dart';
import '../../Helper/DeviceInfo/DeviceInfo.dart';
import '../../Helper/ImagePicker/ImagePicker.dart';
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

  ImagePickerController? imagePicker = Get.put(ImagePickerController());


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

  LoginModel? loginData;

  /// Vehicle list
  List<VehicleListData>? vehicleListData;
  VehicleListData? selectedVehicleData;


  @override
  void onInit() {
<<<<<<< HEAD

=======
    emailCT.text = "pk@gmail.com";
    passCT.text = "Admin@1234";
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
    autoFillUser();
     emailCT.text = "md@gmail.com";
    passCT.text = "Admin@1234";

    //  emailCT.text = "sdk@gmail.com";
    // passCT.text = "Admin@1234";
    //  emailCT.text = "sikandershared@test.com";
    // passCT.text = "Admin@1234";
     super.onInit();
  }

  Future<void> autoFillUser() async {

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

  Future<void> onTapLogin({required BuildContext context,required LoginController ctrl}) async {
    FocusScope.of(context).unfocus();
    isEmail = TxtValidation.normalTextField(emailCT);
    isPassword = TxtValidation.normalTextField(passCT);

    if(!isEmail && !isPassword){
      await loginApi(context: context, ctrl: ctrl,userMail: emailCT.text.toString().trim(), userPass: passCT.text.toString().trim()).then((value) {
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

  Future<LoginModel?> loginApi({ required BuildContext context, required String userMail, required String userPass,required LoginController ctrl}) async {

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
              loginData = result;
              await saveUserData(userData: result).then((value){
                String checkIsForgot = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.forgotMPin).toString();
                if (result.pin.toString() != "") {
                  if (checkIsForgot != "" && checkIsForgot != "null") {
                    Get.toNamed(setupPinScreenRoute,arguments: SetupPinScreen(isChangePin: false,));
                  }else if (result.userType.toString().toLowerCase() == "driver") {
                    Get.toNamed(securePinScreenRoute);
                  } else if (result.userType.toString().toLowerCase() == "pharmacy staff" || result.userType.toString().toLowerCase() == "pharmacy") {
                    Get.toNamed(securePinScreenRoute);
                  }
                } else if (result.pin.toString() == "") {
                  Get.toNamed(setupPinScreenRoute,arguments: SetupPinScreen(isChangePin: false,));
                }
              });

              if(result.showWages.toString() == "1" && result.startMiles == null || result.showWages.toString() == "1" && result.startMiles == ""){
                 vehicleListApi(context: context).then((value) {
                  if(vehicleListData != null && vehicleListData!.isNotEmpty){
                    selectedVehicleData = null;
                    selectVehiclePopUp(context: context,ctrl: ctrl).then((value) {
                      imagePicker?.speedometerImage = null;
                    });
                  }
                });
              }


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

  ///Vehicle List Api
  Future<VehicleListApiResponse?> vehicleListApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    // changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "":""
    };

    String url = WebApiConstant.GET_VEHICLE_LIST_URL;

    await apiCtrl.getVehicleListApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
          try {
            if (result.status == true) {
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
                  String vehicleId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.vehicleId) ?? "";
                  if(vehicleId != "" && vehicleId != "0" && vehicleId != "null"){
                    int indexVehicle = result.list!.indexWhere((element) => element.id.toString() == vehicleId);
                    if(indexVehicle >= 0){
                      selectedVehicleData = result.list?[indexVehicle];
                    }
                  }
                  vehicleListData = result.list;
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

      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  /// Update Vehicle Miles Api
  Future<UpdateVehicleMilesResponse?> updateVehicleMilesApi({
    required BuildContext context,
    String? entryType,
    required String startMiles,
    String? endMiles,
    String? endMilesImage,
    required String lat,
    required String lng,
    required String vehicleID,
    required String startMileImage,
  }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);
    
    Map<String, dynamic> dictparm = {
      "entry_type": entryType ?? "start",
      "start_miles": int.parse(startMiles.toString()),
      "end_miles": endMiles ?? "0",
      "end_miles_image": endMilesImage ?? "",
      "lat": lat,
      "lng": lng,
      "vehicle_id": vehicleID,
      "start_mile_image": startMileImage,
    };

    String url = WebApiConstant.UPDATE_MILES;

    await apiCtrl.updateMilesApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {

      if(result != null){
          try {
            if (result.status?.toLowerCase() == kTrue.toLowerCase()) {
              await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.vehicleId, variableValue: vehicleID);
              await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.startMiles, variableValue: startMiles);
              changeLoadingValue(false);
              changeSuccessValue(true);
              Get.back();

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

      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  Future<void> getSpeedometerImage({required BuildContext context}) async {
    imagePicker?.getImage(source: "Camera", context: context,type:  "speedometerImage").then((value) {
      update();
    });
    // imagePicker?.getImage("Gallery", context, "speedometerImage").then((value) {
    //   update();
    // });
  }

  Future<void> selectVehiclePopUp({required BuildContext context,required LoginController ctrl})async{
      PopupCustom.showChooseVehiclePopUp(
          context: context,
          ctrl: ctrl,
          onValue: (value) {

          }
      );
  }

  Future<void> onTapOkaySelectVehiclePopUP({required BuildContext context,required String startMiles})async {
    CheckPermission.checkLocationPermission(context).then((value) async {
      if(value == true){
          await updateVehicleMilesApi(
              context: context,
              startMiles: startMiles,
              lat: await CheckPermission.getLatitude(context) ?? "",
              lng: await CheckPermission.getLongitude(context) ?? "",
              vehicleID: selectedVehicleData?.id ?? "",
              startMileImage: await Base64ConverterCustom.fileToBase64(filePath: imagePicker?.speedometerImage?.path ?? "") ?? ""
          );
      }else{
        ToastUtils.showCustomToast(context, kPleaseOnLocaionPermission);
      }
    });

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
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.isAddressUpdated, variableValue: userData?.isAddressUpdated.toString() ?? "");

    authToken = userData?.token.toString() ?? "";
    userID = userData?.userId.toString() ?? "";
    driverType = userData?.driverType.toString() ?? "";
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

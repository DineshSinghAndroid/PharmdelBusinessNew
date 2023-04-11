import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/Permission/PermissionHandler.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/popup.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Model/DriverProfile/profile_driver_response.dart';
import '../../../Model/Enum/enum.dart';
import '../../../Model/LunchBreak/lunchBreakResponse.dart';
import '../../../main.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/Camera/CameraScreen.dart';
import '../../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../RouteController/RouteNames.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../DriverDashboard/driver_dashboard_ctrl.dart';
import '../LoginController/login_controller.dart';



class DriverProfileController extends GetxController{


  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  bool isAvlInternet = false;


  LoginController loginCTRL = Get.put(LoginController());
  DriverDashboardCTRL dashCTRL = Get.put(DriverDashboardCTRL());

  DriverProfileApiResponse? driverProfileData;
  String versionCode = "";
  String showWages = "";
  String endMile = "";
  String startMile = "";
  String vehicleId = "";

  bool onBreak = false;







  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData()async{
    await driverProfileApi();
  }

  Future<DriverProfileApiResponse?> driverProfileApi() async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "":""
    };

    String url = WebApiConstant.GET_DRIVER_PROFILE_URL;

    await apiCtrl.getDriverProfileApi(url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != "false") {
          try {
            if (result.status == "true") {
              driverProfileData = result;
              vehicleId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.vehicleId) ?? "";
              versionCode = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.appVersion) ?? "";
              showWages = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.showWages) ?? "";
              startMile = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.startMiles) ?? "";
              endMile = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.endMiles) ?? "";
              onBreak = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.lunchBreakStatus).toString().toLowerCase() == "true" ? true:false;

              if(onBreak == true){
                Future.delayed(
                  const Duration(seconds: 1),
                      () => Get.toNamed(lunchBreakScreenRoute),
                );
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
          PrintLog.printLog(result.status);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  Future<void> onTapEnterMiles()async{

    PrintLog.printLog(
        "ShowWages:${showWages.toString()}"
        "\nStartMile:$startMile"
        "\nEndMile:$endMile"
    );

    if (showWages.toString() == "1"  && (startMile == "" || startMile == "0" || startMile.isEmpty)) {

        if(loginCTRL.vehicleListData != null && loginCTRL.vehicleListData!.isNotEmpty){
          loginCTRL.selectedVehicleData = null;
          loginCTRL.selectVehiclePopUp(context: Get.overlayContext!,ctrl: loginCTRL).then((value) {
            loginCTRL.imagePicker?.speedometerImage = null;
          });
        }else{
          changeLoadingValue(true);
          loginCTRL.vehicleListApi(context: Get.overlayContext!).then((value) {
            changeLoadingValue(false);
            if(loginCTRL.vehicleListData != null && loginCTRL.vehicleListData!.isNotEmpty){
              loginCTRL.selectedVehicleData = null;
              loginCTRL.selectVehiclePopUp(context: Get.overlayContext!,ctrl: loginCTRL).then((value) {
                loginCTRL.imagePicker?.speedometerImage = null;
              });
            }
          });
        }

    } else if (showWages.toString() == "1" && (endMile == "" || endMile == "0" || endMile.isEmpty)) {
      showStartMilesDialog(context: Get.overlayContext!);
    } else {
      PopupCustom.simpleTruckDialogBox(
        context: Get.overlayContext!,
          title: kAlert,
          subTitle: kYouHaveEnteredStartAndEndMiles,
          btnActionTitle: kOkay,
          btnBackTitle: "",
          onValue: (value){

          },
      );
    }

  }

  void showStartMilesDialog({context}) async {
    bool checkStartMiles = false;
    TextEditingController startMilesController = TextEditingController();
    File? image;
    String base64Image='';
    DriverProfileController ctrl = Get.find();
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context1) {
          return GetBuilder<DriverProfileController>(
            init: ctrl,
              builder: (controller) {
            return LoadScreen(
              widget: CustomDialogBox(
                descriptionWidget: Column(
                  children: [
                    BuildText.buildText(
                        text: kEnterMiles,size: 16
                    ),
                   BuildText.buildText(
                        text: "&",size: 17,color: AppColors.colorOrange
                    ),
                    BuildText.buildText(
                        text: kTakeSpdMtrPic,size: 16
                    ),

                  ],
                ),
                button2: TextButton(
                  onPressed: () async {
                    if (startMilesController.text.toString().toString().isEmpty) {
                      Fluttertoast.showToast(msg: kPleaseEnterStartMiles);
                    } else if (image == null) {
                      Fluttertoast.showToast(msg: kTakeSpeedometerPicture);
                    } else {
                      changeLoadingValue(true);
                        Map<String, dynamic> prams = {
                          "entry_type": "start",
                          "start_miles": int.tryParse(startMilesController.text.toString().trim()),
                          "end_miles": 0,
                          "end_miles_image": "",
                          "lat": await CheckPermission.getLatitude(Get.overlayContext!),
                          "lng": await CheckPermission.getLatitude(Get.overlayContext!),
                          "start_mile_image":
                          base64Image != null && base64Image.isNotEmpty
                              ? base64Image
                              : "",
                        };
                       await  loginCTRL.updateVehicleMilesApi(
                            context: context,
                            startMiles: startMilesController.text.toString().trim(),
                            lat: await CheckPermission.getLatitude(Get.overlayContext!) ?? "",
                            lng: await CheckPermission.getLatitude(Get.overlayContext!) ?? "",
                            vehicleID: dashCTRL.selectedVehicleData?.id ?? "0",
                            startMileImage: base64Image != null && base64Image.isNotEmpty
                                ? base64Image : "",
                        ).then((value){
                         changeLoadingValue(false);
                         if(loginCTRL.isSuccess){
                           AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.startMiles, variableValue: startMilesController.text.toString().trim());
                           Get.back();
                         }else{
                           Get.back();
                         }
                       });

                    }
                  },
                  child: BuildText.buildText(
                      text: kOkay,size: 18,
                  ),
                ),
                button1: TextButton(
                  onPressed: () {
                   Get.back();
                  },
                  child: BuildText.buildText(
                    text: kNo,size: 18,
                  ),

                ),
                textField: TextField(
                  controller: startMilesController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.blue),
                  autofocus: false,
                  onChanged: (value) {
                    update();
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
                  ],
                  decoration: InputDecoration(
                    labelText: "Please enter start miles",
                    fillColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.blue),
                    filled: true,
                    errorText: checkStartMiles ? "Enter Start Miles" : null,
                    contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                cameraIcon: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CameraScreen()))
                                .then((value) async {
                              if (value != null) {
                                  image = File(value);
                                update();
                                final imageData = await image!.readAsBytes();
                                base64Image = base64Encode(imageData);
                              }
                            });
                          },
                          child: SizedBox(
                            height: 75.0,
                            child: Image.asset(strImgSpeedometer),
                          ),
                        ),
                        if (image != null)
                          buildSizeBox(0.0, 10.0),

                        if (image != null)
                          SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                      ],
                    ),

                    buildSizeBox(5.0,0.0),
                  ],
                ),
              ),
              isLoading: controller.isLoading,
            );
          });
        }
        );
  }



  Future<void> onTapBreak({required bool value}) async {

    lunchBreakApi(
        context: Get.overlayContext!,
        statusBreak: 1
    ).then((value) {});

  }

  Future<void> onTapEndBreak() async {

    if(onBreak){
      PopupCustom.simpleTruckDialogBox(
        context: Get.overlayContext!,
        onValue: (value) async {
          if(value == "yes"){
            PrintLog.printLog("Lunch break end calling.....");
            lunchBreakApi(
                context: Get.overlayContext!,
                statusBreak: 0
            ).then((value) { });
          }
        },
        title: kEndBreak,
        subTitle: kAreYouSureToEndBreak,
        btnBackTitle: kNo,
        btnActionTitle: kYes,
      );
    }
  }


  Future<LunchBreakApiResponse?> lunchBreakApi({required BuildContext context, required int statusBreak})async{

    isAvlInternet = await ConnectionValidator().check();
    if(!isAvlInternet) {
      PopupCustom.showNoInternetPopUpWhenOffline(
        context: Get.overlayContext!,
        onValue: (value){

        }
    );
    }else{

      if(statusBreak == 1){
        onBreak = true;
      }else{
        onBreak = false;
      }

      changeEmptyValue(false);
      changeLoadingValue(true);
      changeNetworkValue(false);
      changeErrorValue(false);
      changeSuccessValue(false);

      Map<String, dynamic> dictparm = {
        // "lat":lat,
        // "lng":lng,
        "lat": await CheckPermission.getLatitude(Get.overlayContext!,) ?? "0",
        "lng": await CheckPermission.getLongitude(Get.overlayContext!,) ?? "0",
        "is_start":statusBreak,
      };


      await apiCtrl.getLunchBreakApi(context:context,url: WebApiConstant.LUNCH_BREAK_URL,dictParameter: dictparm,token:authToken)
          .then((result) async {
        if(result != null){
          try {
            if (result.status?.toLowerCase() == "true") {
              changeLoadingValue(false);
              changeSuccessValue(true);

              PrintLog.printLog("Lunch Break Api Response: ${result.status.toString()}");

              if(statusBreak == 1) {
                onBreak = true;
                dashCTRL.stopWatchTimer?.onStopTimer();
                await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.lunchBreakStatus, variableValue: "true");
                Future.delayed(
                  const Duration(seconds: 1),
                      () => Get.toNamed(lunchBreakScreenRoute),
                );
              }else {
                onBreak = false;
                dashCTRL.stopWatchTimer?.onStartTimer();
                await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.lunchBreakStatus, variableValue: "false");
                Get.back();
              }

            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
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


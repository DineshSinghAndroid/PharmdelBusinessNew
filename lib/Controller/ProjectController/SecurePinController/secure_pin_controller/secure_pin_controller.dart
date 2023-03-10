import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ApiController/ApiController.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Helper/PrintLog/PrintLog.dart';
import '../../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../../RouteController/RouteNames.dart';
import '../../../WidgetController/Toast/ToastCustom.dart';

class SecurePinController extends GetxController {
  ApiController apiCtrl = ApiController();
  String ? userName;

  String ? userType;
  String? userPin;

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  FocusNode pin1focusNode = FocusNode();
  FocusNode pin2focusNode = FocusNode();
  FocusNode pin3focusNode = FocusNode();
  FocusNode pin4focusNode = FocusNode();

  List numbers = ["1","2","3","4","5","6","7", "8", "9",];



  @override
  void onInit() {
    super.onInit();
    getSharePrefsValue();

  }

  void assignValueInField({required String value}) {
    if (controller1.text.isEmpty) {
      controller1.text = value;
    } else if (controller2.text.isEmpty) {
      controller2.text = value;
    } else if (controller3.text.isEmpty) {
      controller3.text = value;
    } else if (controller4.text.isEmpty) {
      controller4.text = value;
    }
    if (controller1.text.toString().trim().isNotEmpty &&
        controller2.text.toString().trim().isNotEmpty &&
        controller3.text.toString().trim().isNotEmpty &&
        controller4.text.toString().trim().isNotEmpty) {

      String enteredPin = "${controller1.text.toString().trim()}${controller2.text.toString().trim()}${controller3.text.toString().trim()}${controller4.text.toString().trim()}";
      PrintLog.printLog("userPin is ::::$userPin");
      PrintLog.printLog("Entered Pin is ::::$enteredPin");
      if(enteredPin == userPin){
        openHomeScreen();
       }
      else{
        clearPin();
        ToastCustom.showToast(msg: kPinDoesNotMatched);
      }
     }
    update();
  }


  void disposeCTRL() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    pin1focusNode.dispose();
    pin2focusNode.dispose();
    pin3focusNode.dispose();
    pin4focusNode.dispose();
  }

  void clearCTRL() {
    controller1.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
  }

  void nextField(String value, FocusNode focusNode, [FocusNode? focusNode1]) {
    if (value.length == 1) {
      focusNode.requestFocus();
    } else {
      focusNode1?.requestFocus();
    }
    update();
  }

  Future<void> openHomeScreen() async {

     if (userType == "Driver") {
      Get.offAllNamed(driverDashboardScreenRoute);
    } else if (userType == "Pharmacy Staff") {
      Get.offAllNamed(pharmacyHomePage);
    } else {
      ToastCustom.showToast(msg: "something went wrong");
    }
  }

  void clearPin() {
    controller1.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
  }


  Future<void> getSharePrefsValue() async {
      userType = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType);
      userPin = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userPin);
      userName = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userName);
    update();
  }
}
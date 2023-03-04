import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmdel/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Controller/RouteController/RouteNames.dart';
import '../../../Controller/WidgetController/Toast/ToastCustom.dart';
import '../../../Model/SetupPin/setupPin_model.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';

class SetupMPinController extends GetxController {
  String existingPin = "";
  String userType = "";

  @override
  Future<void> onInit() async {
    final prefs = await SharedPreferences.getInstance();
    existingPin = prefs.getString(AppSharedPreferences.userPin) ?? "";
    userType = prefs.getString(AppSharedPreferences.userType) ?? "";

    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    txtOldPin.dispose();
    newPin1.dispose();
    newPin1.dispose();
    txtOldPin.dispose();
    newPin2.dispose();

    // TODO: implement onClose
    super.onClose();
  }

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;
  SetUpPinModel? setUpPinModel;
  TextEditingController txtOldPin = TextEditingController();
  TextEditingController newPin1 = TextEditingController();
  TextEditingController newPin2 = TextEditingController();

  bool isOld = true, isNew = true, isConfirm = true;
  FocusNode? myFocusNode;
  var focusOldPin = FocusNode();
  var focusPin = FocusNode();
  var focusConfirmPin = FocusNode();

  Future<SetUpPinModel?> setupNewPinAPi(
      {BuildContext? context, required int pin}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "pin": pin,
    };
    PrintLog.printLog("This is dict-param$dictparm");
    String url = WebApiConstant.SETPIV_DRIVER;

    await apiCtrl.setMPinAPi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      PrintLog.printLog("Setup m pin result is :::::>>>>>${result!.message.toString()}");
      if (result != null) {
        if (result.error != true) {
          try {
            if (result.error == false) {
              ToastCustom.showToast(msg: result.message);
              changeLoadingValue(false);
              changeSuccessValue(true);
            } else {
              ToastCustom.showToast(msg: result.message);
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
        } else {
          ToastCustom.showToast(msg: result.message ?? "3");
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }
      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
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

  void setPin() async {
    myFocusNode?.requestFocus();

    if (newPin1.text.length == 4 && newPin2.text.length == 4 && newPin2.text == newPin1.text) {
      await setupNewPinAPi(pin: int.parse(newPin2.text)).then((value) async {
        final prefs = await SharedPreferences.getInstance();

        prefs.setString(AppSharedPreferences.userPin, newPin2.text);
        print("PIN value set to shared prefs is ::::::???????:>>>>>>>>${newPin2.text}");

        if (userType == "Pharmacy Staff") {
          Get.toNamed(pharmacyHomePage);
        } else if (userType == "Driver") {
          Get.toNamed(homeScreenRoute);
        } else {
          ToastCustom.showToast(msg: "Something Went Wrong");
        }
      });
    } else {
      ToastCustom.showToast(msg: "Please Retry");
    }
    newPin2.clear();
    newPin1.clear();
    txtOldPin.clear();
  }

  void changePin() async {
    myFocusNode?.requestFocus();

    if (newPin1.text.length == 4 && newPin2.text.length == 4 && newPin2.text == newPin1.text && existingPin.length == 4 && txtOldPin.text == existingPin) {
      await setupNewPinAPi(pin: int.parse(newPin2.text)).then((value) async {
        final prefs = await SharedPreferences.getInstance();

        prefs.setString(AppSharedPreferences.userPin, newPin2.text ?? "");
        print("PIN value set to shared prefs is ::::::???????:>>>>>>>>${newPin2.text}");

        if (userType == "Pharmacy Staff") {
          Get.toNamed(pharmacyHomePage);
        } else if (userType == "Driver") {
          Get.toNamed(homeScreenRoute);
        } else {
          ToastCustom.showToast(msg: "Something Went Wrong");
        }
      });
    } else {
      print(txtOldPin.toString() + newPin1.toString() + newPin2.toString() + existingPin);
      ToastCustom.showToast(msg: "Please Retry");
    }
    newPin2.clear();
    newPin1.clear();
    txtOldPin.clear();
  }
}

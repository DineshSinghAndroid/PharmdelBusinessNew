import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/main.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Controller/RouteController/RouteNames.dart';
import '../../../Controller/WidgetController/Toast/ToastCustom.dart';
import '../../../Model/SetupPin/setupPin_model.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../Helper/TextController/TextValidator/TextValidator.dart';

class SetupMPinController extends GetxController {

  TextEditingController oldMPinCTRL = TextEditingController();
  TextEditingController newMPinCTRL = TextEditingController();
  TextEditingController confirmMPinCTRL = TextEditingController();


  bool eyeHideOld = true;
  bool eyeHideNew = true;
  bool eyeHideConfirm = true;

  bool isOldMPin = false;
  bool isValidOldMPin = false;
  bool isCorrectOldMPin = false;

  bool isNewMPin = false;
  bool isValidNewMPin = false;

  bool isConfirmMPin = false;
  bool isValidConfirmMPin = false;
  bool isCorrectConfirmMPinNotMatched = false;




  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  Future<void> onTapEyeOld() async {
    eyeHideOld = !eyeHideOld;
    update();
  }

  Future<void> onTapEyeNew() async {
    eyeHideNew = !eyeHideNew;
    update();
  }

  Future<void> onTapEyeConfirm() async {
    eyeHideConfirm = !eyeHideConfirm;
    update();
  }

  Future<void> onTapSubmit({required BuildContext context,required bool isChangeMPin}) async {
    FocusScope.of(context).unfocus();

    isOldMPin = TxtValidation.normalTextField(oldMPinCTRL);
    isValidOldMPin = TxtValidation.validateMPinTextField(oldMPinCTRL);

    if(!isOldMPin && !isValidOldMPin || isChangeMPin == false){

      isNewMPin = TxtValidation.normalTextField(newMPinCTRL);
      isValidNewMPin = TxtValidation.validateMPinTextField(newMPinCTRL);
      isConfirmMPin = TxtValidation.normalTextField(confirmMPinCTRL);
      isValidConfirmMPin = TxtValidation.validateMPinTextField(confirmMPinCTRL);

      if(newMPinCTRL.text.toString().trim() != confirmMPinCTRL.text.toString().trim()){
        isCorrectConfirmMPinNotMatched = true;

      }else if(!isNewMPin && !isValidNewMPin && !isConfirmMPin && !isValidConfirmMPin){
        isCorrectConfirmMPinNotMatched = false;
        String newEnteredPin = newMPinCTRL.text.toString().trim();
        if(isChangeMPin == false){
          PrintLog.printLog("isChangeMPin Success:::1:$isChangeMPin");
          await setUpNewPinAPi(context: context,pin: newEnteredPin);

        }else if(isChangeMPin == true){

          String userPin = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userPin) ?? "";
          PrintLog.printLog("Old Pin:$userPin\nNew Pin:$newEnteredPin \n:IsChangePin:$newEnteredPin ");

          if(userPin.toString() == oldMPinCTRL.text.toString().trim()){
            PrintLog.printLog("Success:$userPin:::$isChangeMPin");
            await setUpNewPinAPi(context: context,pin: newEnteredPin);
          }else{
            ToastCustom.showToast(msg: kSetupPinNotMatchToastString);
            PrintLog.printLog("Failed ...old pin wrong:$userPin:::$isChangeMPin");
          }

        }

      }

    }
    update();
  }

  Future<SetUpPinModel?> setUpNewPinAPi({BuildContext? context, required String pin}) async {
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
      if (result != null) {
        try {
          if (result.error == false) {
            ToastCustom.showToast(msg: result.message ?? "");
            changeLoadingValue(false);
            changeSuccessValue(true);
            String userType = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType) ?? "";
            PrintLog.printLog("Driver Type:::${userType.toString().toLowerCase()}");
            await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userPin, variableValue: pin.toString());
            if (userType.toString().toLowerCase() == "driver") {
              Get.offAllNamed(driverDashboardScreenRoute);
            } else if (userType.toString().toLowerCase() == "pharmacy staff") {
              Get.offAllNamed(pharmacyHomePage);
            }
            await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.forgotMPin, variableValue: "");

            ToastCustom.showToast(msg: result.message ?? "");
          } else {
            ToastCustom.showToast(msg: result.message ?? "");
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
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  Future<void> onTapCancel()async {
    await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.forgotMPin, variableValue: "");
    Get.back();
    Get.delete<SetupMPinController>();
  }

  Future<void> disposeTxtCtrl()async {
    oldMPinCTRL.dispose();
    newMPinCTRL.dispose();
    confirmMPinCTRL.dispose();
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

  // void setPin() async {
  //   myFocusNode?.requestFocus();
  //
  //   if (newPin1.text.length == 4 && newPin2.text.length == 4 && newPin2.text == newPin1.text) {
  //     await setupNewPinAPi(pin: int.parse(newPin2.text)).then((value) async {
  //       final prefs = await SharedPreferences.getInstance();
  //
  //       prefs.setString(AppSharedPreferences.userPin, newPin2.text);
  //       print("PIN value set to shared prefs is ::::::???????:>>>>>>>>${newPin2.text}");
  //
  //       if (userType == "Pharmacy Staff") {
  //         Get.toNamed(pharmacyHomePage);
  //       } else if (userType == "Driver") {
  //         Get.toNamed(homeScreenRoute);
  //       } else {
  //         ToastCustom.showToast(msg: "Something Went Wrong");
  //       }
  //     });
  //   } else {
  //     ToastCustom.showToast(msg: "Please Retry");
  //   }
  //   newPin2.clear();
  //   newPin1.clear();
  //   txtOldPin.clear();
  // }

  // void changePin() async {
  //   myFocusNode?.requestFocus();
  //
  //   if (newPin1.text.length == 4 && newPin2.text.length == 4 && newPin2.text == newPin1.text && existingPin.length == 4 && txtOldPin.text == existingPin) {
  //     await setupNewPinAPi(pin: int.parse(newPin2.text)).then((value) async {
  //       final prefs = await SharedPreferences.getInstance();
  //
  //       prefs.setString(AppSharedPreferences.userPin, newPin2.text ?? "");
  //       print("PIN value set to shared prefs is ::::::???????:>>>>>>>>${newPin2.text}");
  //
  //       if (userType == "Pharmacy Staff") {
  //         Get.toNamed(pharmacyHomePage);
  //       } else if (userType == "Driver") {
  //         Get.toNamed(homeScreenRoute);
  //       } else {
  //         ToastCustom.showToast(msg: "Something Went Wrong");
  //       }
  //     });
  //   } else {
  //     print(txtOldPin.toString() + newPin1.toString() + newPin2.toString() + existingPin);
  //     ToastCustom.showToast(msg: "Please Retry");
  //   }
  //   newPin2.clear();
  //   newPin1.clear();
  //   txtOldPin.clear();
  // }
}

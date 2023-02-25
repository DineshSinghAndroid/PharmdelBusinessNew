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
import '../../Helper/StringDefine/StringDefine.dart';

class SetupMPinController extends GetxController {
  String strPin ="";
  String userType ="";
  @override
  Future<void> onInit() async {
    final prefs = await SharedPreferences.getInstance();
      strPin = prefs.getString(kQuickPin)??"";
    userType = prefs.getString(kUSERTYPE)??"";

    // TODO: implement onInit
    super.onInit();
  }
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;
  SetUpPinModel? setUpPinModel;
  TextEditingController txtOldPin = TextEditingController();
  TextEditingController txtEnterOtp = TextEditingController();
  TextEditingController txtConfirmOtp = TextEditingController();


  bool isOld = true, isNew = true, isConfirm = true;
  FocusNode? myFocusNode;
  var focusPin = FocusNode();
  var focusConfirmPin = FocusNode();
  Future<SetUpPinModel?> setupMpinApi({  BuildContext? context, required int pin}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "pin": pin,
    };
PrintLog.printLog("This is dictparam" +dictparm.toString());
    String url = WebApiConstant.SETPIV_DRIVER;

    await apiCtrl.setMPinAPi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) async {
      PrintLog.printLog("Setup m pin result is :::::>>>>>${result!.message.toString()}");
       if (result != null) {
        if (result.error != true) {
          try {
            if (result.error == false) {
              ToastCustom.showToast(msg: result.message ?? "1");
              changeLoadingValue(false);
              changeSuccessValue(true);
            } else {
              ToastCustom.showToast(msg: result.message ?? "2");
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
  void validatePin()async{
    myFocusNode?.requestFocus();


    if( txtEnterOtp.text.length == 4 && txtConfirmOtp.text.length == 4 &&
        txtConfirmOtp.text == txtEnterOtp.text){
  await setupMpinApi(
      pin: int.parse(txtConfirmOtp.text)).then((value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(kQuickPin, txtConfirmOtp.text??"");
    print("PIN value set to shared prefs is ::::::???????:>>>>>>>>${kQuickPin.toString()}")
    ;

    if(userType == "Pharmacy Staff"){
          Get.toNamed(pharmacyHomePage);
        }
       else if(userType == "Driver"){
          Get.toNamed(homeScreenRoute);
        }
       else{
         ToastCustom.showToast(msg: "Something Went Wrong");
        }
  });
}
  else{
    ToastCustom.showToast(msg: "Please Retry");
    }
  }
}

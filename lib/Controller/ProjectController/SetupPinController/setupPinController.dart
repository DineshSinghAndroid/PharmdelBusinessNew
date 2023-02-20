
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Controller/RouteController/RouteNames.dart';
import '../../../Controller/WidgetController/Toast/ToastCustom.dart';
import '../../../Model/SetupPin/setupPin_model.dart';


class SetupMPinController extends GetxController{

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  Future<SetupMPinApiResponse?> setupMpinApi({required BuildContext context, required int pin}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "pin":pin,     
    };

    String url = WebApiConstant.SETPIV_DRIVER;

    await apiCtrl.setupMPinApi(context:context,url: url, dictParameter: dictparm,token: "")
        .then((result) async {

      if(result != null){
        if (result.error != true) {          
          try {
            if (result.error == false) {             
              ToastCustom.showToast(msg: result.message ?? "");                            
              changeLoadingValue(false);
              changeSuccessValue(true);
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
        }else{
          ToastCustom.showToast(msg: result.message ?? "");
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
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



import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:pharmdel/Model/LunchBreak/lunchBreakResponse.dart';
import 'package:pharmdel/main.dart';
import '../../../Model/ForgotPassword/forgotPasswordResponse.dart';
import '../../../Model/Login/login_model.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';

class LunchBreakController extends GetxController {

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

 
    Future<LunchBreakApiResponse?> lunchBreakApi({required BuildContext context,required String lat, required String lng, required String isStart})async{

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "lat":lat,
      "lng":lng,
      "is_start":isStart,
    };


    String url = WebApiConstant.LUNCH_BREAK_URL;

    await apiCtrl.getLunchBreakApi(context:context,url: url,dictParameter: dictparm,token:'')
        .then((result) async {
       if(result != null){
        if (result.status != true) {
          try {
            if (result.status == false) {                                     
              changeLoadingValue(false);
              changeSuccessValue(true);              
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


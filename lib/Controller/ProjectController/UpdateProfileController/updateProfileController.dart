import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/UpdateProfile/updateProfileResponse.dart';

class UpdateProfileController extends GetxController {

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

 
    Future<UpdateProfileApiResponse?> updateProfileApi({required BuildContext context,required String addressLine1, required String addressLine2, required String town, required String postCode })async{

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "addressline1":addressLine1,
      "addressline2":addressLine2,
      "town":town,
      "postcode":postCode,
    };

    String url = WebApiConstant.GET_UPDATE_PROFILE_URL;

    await apiCtrl.getUpdateProfileApi(context:context,url: url,dictParameter: dictparm,token:authToken)
        .then((result) async {
       if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {
              ToastCustom.showToast(msg: "${result.message}");                                  
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


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/popup.dart';
import '../../../Model/UpdateProfile/updateProfileResponse.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';

class UpdateProfileController extends GetxController {

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;


  TextEditingController addressController = TextEditingController();
  TextEditingController addressController2 = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();

  bool isAddress1 = false;
  bool isAddress2 = false;
  bool isTown = false;
  bool isPostCode = false;

  String userName = "";

  double textFieldSpace = 20.0;


  void initData({required String address1,required String address2,required String townName,required String postCode,required String name,}) async {
    addressController.text = address1.toString().trim();
    addressController2.text = address2.toString().trim();
    townController.text = townName.toString().trim();
    postCodeController.text = postCode.toString().trim();
    userName = name.toString().trim().substring(0,1);
    update();
  }

  Future<void> onTapUpdateAddress({required BuildContext context})async{
    FocusScope.of(context).unfocus();
    isAddress1 = TxtValidation.normalTextField(addressController);
    // isAddress2 = TxtValidation.normalTextField(addressController2);
    // isTown = TxtValidation.normalTextField(townController);
    isPostCode = TxtValidation.normalTextField(postCodeController);

    if(!isAddress1 && !isPostCode){
      await updateProfileApi(
          context: context,
          addressLine1: addressController.text.toString().trim(),
          addressLine2: addressController2.text.toString().trim(),
          town: townController.text.toString().trim(),
          postCode: postCodeController.text.toString().trim()
      );
    }
    update();
  }

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
          try {
            if (result.status == true) {
              ToastCustom.showToast(msg: "${result.message}");                                  
              changeLoadingValue(false);
              changeSuccessValue(true);
            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);

              PopupCustom.errorDialogBox(
                onValue: (value){},
                context: context,
                title: kError,
                subTitle: result.message ?? "",
              );
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


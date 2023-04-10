import 'package:flutter/cupertino.dart';
import 'package:pharmdel/Controller/ApiController/ApiController.dart';
import 'package:pharmdel/Controller/ApiController/WebConstant.dart';
 import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../Helper/PrintLog/PrintLog.dart';


class VirClickImagesController extends ChangeNotifier {
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  Future<void> virUpload({required BuildContext context, required dictData}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);


    String url = WebApiConstant.INSPECTION_SUBMIT;

    await apiCtrl.virUploadApi(context: context, url: url, dictData: dictData, token: authToken).then((result) async {
      try {
        if (result != null) {
          if (result.error != true) {
            changeLoadingValue(false);
            changeSuccessValue(true);
          } else {
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
      } catch (_) {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
        PrintLog.printLog("Exception : $_");
      }
    });
    notifyListeners();
  }

  void changeSuccessValue(bool value) {
    isSuccess = value;
    notifyListeners();
  }

  void changeLoadingValue(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void changeEmptyValue(bool value) {
    isEmpty = value;
    notifyListeners();
  }

  void changeNetworkValue(bool value) {
    isNetworkError = value;
    notifyListeners();
  }

  void changeErrorValue(bool value) {
    isError = value;
    notifyListeners();
  }
}

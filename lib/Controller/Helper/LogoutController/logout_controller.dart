import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../WidgetController/Popup/PopupCustom.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

import '../PrintLog/PrintLog.dart';
class LogoutController extends GetxController{

  ApiController apiCtrl = ApiController();


  Future logoutApi(context) async {

    Map<String, dynamic> dictParm = {
      "":""
    };

    String url = WebApiConstant.Logout;

  await apiCtrl.getLogoutApi(context: context, url: url,dictParameter: dictParm, token: authToken).then((result) async {
    if (result != null) {
      if (result.error != true) {
        PrintLog.printLog("Logout Success");
        ToastCustom.showToast(msg: result ?? "");
        try {
          if (result.error == false) {
            ToastCustom.showToast(msg: result ?? "");
              Get.offAndToNamed(loginScreenRoute);
          } else {
              PrintLog.printLog(result);
              ToastCustom.showToast(msg: result ?? "");
            }
          } catch (_) {
            PrintLog.printLog("Exception : $_");
            ToastCustom.showToast(msg: result ?? "");
          }
        } else {
          PrintLog.printLog(result);
          ToastCustom.showToast(msg: result ?? "");
        }
      }
  });
    }

    validateAndLogout(context) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return  DelayedDisplay(
        child: LogoutPopUP(
          onTapCancel: () {
            Get.back();
          },
          onTapOK: () async {
            await logoutApi(context);
          },
        ),
      );
    },
  );
  // Navigator.pop(context, true);
}
  }


 

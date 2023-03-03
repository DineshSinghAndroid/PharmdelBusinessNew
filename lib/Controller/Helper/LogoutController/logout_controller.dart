import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/Enum/enum.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

import '../PrintLog/PrintLog.dart';
class LogoutController extends GetxController{

  ApiController apiCtrl = ApiController();

  validateAndLogout(context) {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(klogout),
          content: const Text("Are you sure you want to logout"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                //  Navigator.pop(_ctx);
              },
            ),
            TextButton(
              child: const Text(
                'YES',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                // AppSharedPreferences.clearSharedPref();
                await logoutApi(context);
              },
            )
          ],
        );
      },
    );
    // Navigator.pop(context, true);
  }

  Future logoutApi(context) async {
    CustomLoading().show(context, true);

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
              CustomLoading().show(context, false).then((value) {
                Get.offAndToNamed(loginScreenRoute);
              },);
            } else {
              CustomLoading().show(context, false);

              PrintLog.printLog(result);
              ToastCustom.showToast(msg: result ?? "");
            }
          } catch (_) {
            PrintLog.printLog("Exception : $_");
            ToastCustom.showToast(msg: result ?? "");
          }
        } else {
          CustomLoading().show(context, false);

          PrintLog.printLog(result);
          ToastCustom.showToast(msg: result ?? "");
        }
      }
    });
  }

}
import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/Enum/enum.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

import '../PrintLog/PrintLog.dart';

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
              logoutApi(context);
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

  String url = WebApiConstant.Logout;

  await apiCtrl.getLogoutApi(context: context, url: url, token: authToken).then((result) async {
    if (result != null) {
      if (result.error != true) {
        ToastCustom.showToast(msg: result.message ?? "");

        try {
          if (result.error == false) {
            ToastCustom.showToast(msg: result.message ?? "");
            CustomLoading().show(context, false);
          } else {
            CustomLoading().show(context, false);

            PrintLog.printLog(result.message);
            ToastCustom.showToast(msg: result.message ?? "");
          }
        } catch (_) {
          PrintLog.printLog("Exception : $_");
          ToastCustom.showToast(msg: result.message ?? "");
        }
      } else {
        CustomLoading().show(context, false);

        PrintLog.printLog(result.message);
        ToastCustom.showToast(msg: result.message ?? "");
      }
    }
  });
}

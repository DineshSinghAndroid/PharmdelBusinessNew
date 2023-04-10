import 'package:flutter/material.dart';
import 'package:pharmdel/Controller/Helper/PrintLog/PrintLog.dart';
import '../../../View/OnBoarding/EnterPin/securePin.dart';
import '../../../main.dart';
import '../Shared Preferences/SharedPreferences.dart';

class TimeCheckerCustom{
  TimeCheckerCustom._privateConstructor();
  static final TimeCheckerCustom instance = TimeCheckerCustom._privateConstructor();

 static Future<void> checkLastTime({required BuildContext context}) async {
   PrintLog.printLog("Last Timer Checked:::::::");
   int time = int.parse(AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userDeliveryLastTime) ?? "");
   DateTime dt = time != null ? DateTime.fromMillisecondsSinceEpoch(time) : DateTime.now();
   DateTime dateNow = DateTime.now();

   final difference = dateNow.difference(dt).inMinutes;

   if (difference < 30) {
     setLastTime();
   } else {
     if (!isTimeCheckDialogBox) {
       isTimeCheckDialogBox = true;
       showDialog(
           context: context,
           barrierDismissible: false,
           builder: (BuildContext context1) {
             return WillPopScope(
                 onWillPop: () async => false,
                 child: const SecurePin()
             );
           });
     }
   }
 }

 static Future<void> setLastTime() async {
   DateTime now = DateTime.now();
   AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.userDeliveryLastTime,variableValue: now.millisecondsSinceEpoch.toString()) ?? "";
 }

}
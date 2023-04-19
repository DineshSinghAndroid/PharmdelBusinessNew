

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pharmdel/Controller/Helper/PrintLog/PrintLog.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../Helper/Redirect/redirect.dart';
import '../../Helper/SentryExemption/sentry_exemption.dart';
import '../Popup/popup.dart';
import '../StringDefine/StringDefine.dart';

class AppUpDatePopUp{
  AppUpDatePopUp._privateConstructor();
  static final AppUpDatePopUp instance = AppUpDatePopUp._privateConstructor();

  static bool isShowUpdatePopUp = false;

  static Future<void> checkUpdate({required BuildContext context,required CheckUpdateApp checkUpdateApp})async{
    isShowUpdatePopUp = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.isShowAppUpdatePopUp).toString().toLowerCase() == "true" ? true:false;
    if(isShowUpdatePopUp == false){
      try {
        if (Platform.isAndroid) {
          update(context: context,
              severAndroidVersion: int.parse(checkUpdateApp.appVersion ?? "0"),
              severIosVersion: int.parse(checkUpdateApp.iosAppVersion ?? "0"),
              isForceUpdate: checkUpdateApp.forceUpdate.toString().toLowerCase() == 'true' ? true:false,
              msg: checkUpdateApp.message ?? ""
          );
        }else if(Platform.isIOS) {
          update(context: context,
              severAndroidVersion: int.parse(checkUpdateApp.appVersion ?? "0"),
              severIosVersion: int.parse(checkUpdateApp.iosAppVersion ?? "0"),
              isForceUpdate: checkUpdateApp.iosForceUpdate.toString().toLowerCase() == 'true' ? true:false,
              msg: checkUpdateApp.iosMessage ?? ""
          );
        }
      } catch(e){
        PrintLog.printLog("App Update Error:$e");
      }
    }

  }

  static Future<void> update({required BuildContext context,required int severAndroidVersion,required int severIosVersion,required bool isForceUpdate,required String msg})async{
      try {
        if (Platform.isAndroid) {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
            int appVersion = int.parse(packageInfo.buildNumber);
          if (appVersion < severAndroidVersion) {
            await showDialog(context: context, severAndroidVersion: severAndroidVersion,severIosVersion: severIosVersion,isForceUpdate: isForceUpdate, msg: msg);
          }
        });
        } else if (Platform.isIOS) {
          int iosAppVersion = int.parse(kIosAppVersion);
          if (iosAppVersion < severIosVersion) {
            await showDialog(context: context, severAndroidVersion: severAndroidVersion,severIosVersion: severIosVersion,isForceUpdate: isForceUpdate, msg: msg);
          }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
      }

  }

  static Future<void> showDialog({required BuildContext context,required int severAndroidVersion,required int severIosVersion,required bool isForceUpdate,required String msg})async{

    PopupCustom.appUpdateDialogBox(
      msg: msg,
      isShowExit: isForceUpdate ? false:true,
      context: context,
      onValue: (value) async {
        await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.isShowAppUpdatePopUp, variableValue: "true");

        if(value == "yes"){
          if(Platform.isIOS){
            RedirectCustom.storeRedirect(urlString: kAppStoreUrl).then((value) async {
              if(isForceUpdate){
                await update(context: context, severAndroidVersion: severAndroidVersion, severIosVersion: severIosVersion, isForceUpdate: isForceUpdate, msg: msg);
              }
            });
          }else{
            RedirectCustom.storeRedirect(urlString: kPlayStoreUrl).then((value) async {
              if(isForceUpdate){
                await update(context: context, severAndroidVersion: severAndroidVersion, severIosVersion: severIosVersion, isForceUpdate: isForceUpdate, msg: msg);
              }
            });
          }
        }
      },
    );
  }
}
import 'package:get/get.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';

class SplashController extends GetxController {
  String userId = "";
  String userType = "";
  String userPin = "";

  @override
  void onInit() {
    checkLogin();
    super.onInit();
  }

  Future<void> checkLogin() async {
    await SharedPreferences.getInstance().then((value) {
      userId = value.getString(AppSharedPreferences.userId) ?? "";
      userType = value.getString(AppSharedPreferences.userType) ?? "";
      userPin = value.getString(AppSharedPreferences.userPin) ?? "";
      PrintLog.printLog("User Id is $userId , \n user pin is $userPin  \n user type is $userType");
    });
    runSplash();
  }

  runSplash() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if(userPin != '' ){
        Get.offAndToNamed(securePinScreenRoute);
      } else {
        Get.offAndToNamed(loginScreenRoute);
      }
    });
  }

  Future<void> setLastTime() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    prefs.setInt(kUserLastTime, now.millisecondsSinceEpoch);
  }

}

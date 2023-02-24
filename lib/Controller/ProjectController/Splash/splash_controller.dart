

import 'package:get/get.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../Helper/StringDefine/StringDefine.dart';

class SplashController extends GetxController {
  String userId = "";

  @override
  void onInit() {
    checkLogin();
    super.onInit();
  }

  Future<void> checkLogin() async {
    await SharedPreferences.getInstance().then((value) {
      userId = value.getString(AppSharedPreferences.userId) ?? "";

    });
    runSplash();

  }

  runSplash() {
    Future.delayed(const Duration(seconds: 3), () {

      if (userId != "") {
        Get.toNamed(homeScreenRoute);

        print("Going to Home Screen");

      } else {
        Get.toNamed(loginScreenRoute);
        print("Going to Login Screen");

      }
    });
  }
  Future<void> setLastTime() async {
  final prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  prefs.setInt(kUserLastTime, now.millisecondsSinceEpoch);
}
}

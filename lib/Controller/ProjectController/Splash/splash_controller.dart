

import 'package:get/get.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Helper/Shared Preferences/SharedPreferences.dart';

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
        Get.toNamed(loginScreenRoute);

        print("Going to Home Screen");

      } else {
        Get.toNamed(setupPinScreenRoute);
        print("Going to Login Screen");

      }
    });
  }
}

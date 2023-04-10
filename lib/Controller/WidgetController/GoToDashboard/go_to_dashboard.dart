import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../RouteController/RouteNames.dart';
import '../Toast/ToastCustom.dart';

class GoToDashboard{

  static Future<void> go({required String userType})async{
    if (userType.toString().toLowerCase() == "driver") {
      Get.offAllNamed(driverDashboardScreenRoute);
    } else if (userType.toString().toLowerCase() == "pharmacy staff") {
      Get.offAllNamed(pharmacyHomePage);
    } else if (userType.toString().toLowerCase() == "pharmacy") {
      Get.offAllNamed(pharmacyHomePage);
    } else {
      ToastCustom.showToast(msg: "something went wrong");
    }
  }

  static Future<void> popUntil({required BuildContext context})async{
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
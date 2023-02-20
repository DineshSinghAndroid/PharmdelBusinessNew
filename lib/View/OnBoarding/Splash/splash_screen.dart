import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Controller/Helper/StringDefine/StringDefine.dart';
import '../../../Controller/ProjectController/Splash/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

SplashController splashController = SplashController();

class _SplashScreenState extends State<SplashScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  SplashController splashCT = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: splashCT,
        builder: (controller) {
          return Scaffold(
              appBar: null,
              key: scaffoldKey,
              body: Center(
                child: SafeArea(
                    child: SingleChildScrollView(
                        child: Center(
                            child: Column(
                  children: [
                    Image.asset(
                      strimg_logo,
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: 80),
                   CircularProgressIndicator(color: AppColors.colorAccent,)
                  ],
                )))),
              ));
        });
  }
  Future<void> setLastTime() async {
  final prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  // prefs.setInt(WebConstant.USER_LASTTIME, now.millisecondsSinceEpoch);
}
}

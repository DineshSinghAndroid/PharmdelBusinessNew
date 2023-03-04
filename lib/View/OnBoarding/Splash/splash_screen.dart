import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import '../../../Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../../Controller/ProjectController/Splash/splash_controller.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  SplashController splashCT = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: splashCT,
        builder: (controller) {
          return Scaffold(
              body: Center(
                child: SafeArea(
                    child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                              children: [
                                Image.asset(strimg_logo,height: 200,width: 200,),
                                buildSizeBox(80.0,0.0),
                                CircularProgressIndicator(color: AppColors.colorAccent,)
                              ],
                          )
                        )
                    )
                ),
              ));
        });
  }
}

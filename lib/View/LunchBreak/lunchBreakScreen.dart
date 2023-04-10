import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/Button/ButtonCustom.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/ProjectController/DriverProfile/driverProfileController.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class LunchBreakScreen extends StatefulWidget {
  const LunchBreakScreen({super.key});

  @override
  State<LunchBreakScreen> createState() => _LunchBreakScreenState();
}

class _LunchBreakScreenState extends State<LunchBreakScreen> {

  DriverProfileController drawerCtrl = Get.find();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverProfileController>(
      init: drawerCtrl,
      builder: (controller){
        return WillPopScope(
          onWillPop: () async => false,
          child: LoadScreen(
            widget: Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(top: 100,bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //     height: 300,
                    //     width: double.infinity,
                    //     child: Lottie.network(strLottieLunchBreak)
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                        height: 300,
                        width: Get.width,
                        child: Image.asset(kSplashLogo)
                    ),
                    buildSizeBox(40.0, 0.0),

                    BuildText.buildText(
                      text: kYouAreOnBreak,
                      textAlign: TextAlign.center,
                      weight: FontWeight.bold,
                      color: AppColors.blackColor,
                      size: 25,
                    ),

                    buildSizeBox(30.0, 0.0),
                    ButtonCustom(
                      onPress: ()=> controller.onTapEndBreak(),
                      text: kEndBreak,
                      buttonWidth: Get.width - 60,
                      buttonHeight: 50,textSize: 20,
                      backgroundColor: AppColors.colorOrange,
                      textColor: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    const Spacer(),

                    BuildText.buildText(
                      text: kEndBreakMsg,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w700,
                      color: AppColors.blackColor,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
            isLoading: controller.isLoading,
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/ProjectController/LunchBreakController.dart/lunchBreakController.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:pharmdel/Controller/WidgetController/Button/ButtonCustom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';

class LunchBreakScreen extends StatefulWidget {
  const LunchBreakScreen({super.key});

  @override
  State<LunchBreakScreen> createState() => _LunchBreakScreenState();
}

class _LunchBreakScreenState extends State<LunchBreakScreen> {

  LunchBreakController LchBrkCtrl = Get.put(LunchBreakController());

  double lat = 0.0;
  double lng = 0.0;
  int value = 0;

  @override
  void initState() {
    LchBrkCtrl.getLocationData(lat: lat, lng: lng, context: context);
    super.initState();
  }

  // Future<void> init()async{
  //   LchBrkCtrl.isNetworkError = false;
  //   LchBrkCtrl.isEmpty = false;
  //   if (await ConnectionValidator().check()) {
  //     await LchBrkCtrl.lunchBreakApi(context: context,lat: lat,lng: lng,isStart: 0);
  //   } else {
  //     LchBrkCtrl.isNetworkError = true;
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100,bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300, 
              width: double.infinity, 
              child: Lottie.network(strLottieLunchBreak)),
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
              onPress: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool? isUserOnbreak = prefs.getBool("UserOnBreak");
                // if (isUserOnbreak == true){
                  await LchBrkCtrl.lunchBreakApi(context: context, lat: lat, lng: lng, statusBreak: 0).then((value) {
                    prefs.setBool("UserOnBreak", false);
                    Future.delayed(
                  const Duration(seconds: 1,),
                  () => Get.toNamed(homeScreenRoute),
                );
                  },);
                // }                
              }, 
              text: kEndBreak,               
              buttonWidth: Get.width - 60, 
              buttonHeight: 50,
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
    );
  }
}
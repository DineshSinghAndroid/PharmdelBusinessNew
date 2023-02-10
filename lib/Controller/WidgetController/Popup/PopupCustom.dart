import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import '../../Helper/ColorController/CustomColors.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../Helper/TextController/FontFamily/FontFamily.dart';


class PopupCustom{


  static userLogoutPopUP({required BuildContext context}){
    return showDialog(barrierDismissible: true,
        context: context,
        builder: (_){
          return const LogoutPopUP();
        }
    ).then((value) {
      PrintLog.printLog("Value is: $value");
      if(value == true){
        AppSharedPreferences.clearSharedPref().then((value) {
          // Get.offAllNamed(loginScreenRoute);
        });
      }
    });
  }


  static seatNotAvailablePopUP({ required Function(dynamic) onValue,required BuildContext context,required Function()? onTap,required String message}){
    return showDialog(
      context: context,
      builder: (_) {
        return Container();
      },).then(onValue);
  }

}





class LogoutPopUP extends StatelessWidget {
  const LogoutPopUP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.blackColor.withOpacity(0.3),
      // body: DelayedDisplay(
      //   child: Center(
      //     child: Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: Container(
      //         // height: 280,
      //         decoration: BoxDecoration(
      //             color: CustomColors.whiteColor,
      //             borderRadius: BorderRadius.circular(10.0)
      //         ),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Container(
      //               height: 110,
      //               width: 110,
      //               margin: const EdgeInsets.only(top: 10),
      //               child: Image.asset(strImgLogout),
      //             ),
      //             BuildText.buildText(text: kNotAuthenticated,size: 25,fontFamily: FontFamily.josefinBold),
      //             Padding(
      //               padding: const EdgeInsets.all(10.0),
      //               child: Wrap(
      //                   alignment: WrapAlignment.center,
      //                   children: [
      //                     BuildText.buildText(text: kAuthenticatedDes,color: CustomColors.greyColor,size: 16),
      //                   ]
      //               ),
      //             ),
      //             buildSizeBox(20.0, 0.0),
      //             Padding(
      //               padding: const EdgeInsets.only(bottom: 20),
      //               child: InkWell(
      //                 onTap: () async {
      //                   AppSharedPreferences.clearSharedPref().then((value) {
      //                     // Get.offAllNamed(loginScreenRoute);
      //                   });
      //                 },
      //                 child: Container(
      //                   height: 45,
      //                   width: 120,
      //                   decoration: BoxDecoration(
      //                     borderRadius: BorderRadius.circular(10.0),
      //                     color: CustomColors.redColor,
      //                   ),
      //                   child: Center(
      //                     child: BuildText.buildText(text: kOk,color: CustomColors.whiteColor,size: 20.0,fontFamily: FontFamily.josefinBold),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}


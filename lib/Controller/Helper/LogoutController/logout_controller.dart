import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../WidgetController/Popup/PopupCustom.dart';
import '../PrintLog/PrintLog.dart';
class LogoutController extends GetxController{

  ApiController apiCtrl = ApiController();


  Future logoutApi({required BuildContext context,required String userType}) async {

    String url = userType.toString().toLowerCase() == "pharmacy" && userType.toString().toLowerCase() == "pharmacy staff" ?
    WebApiConstant.LOGOUT_URL_PHARMACY : WebApiConstant.Logout_URL;
    PrintLog.printLog("User Type: $userType \nurl: $url \nToken: $authToken");

      await apiCtrl.logOutApi(context: context,url: url).then((value) {

      });
    }

  validateAndLogout({required BuildContext context,required String userType}) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return  DelayedDisplay(
                child: LogoutPopUP(
                  onTapCancel: () {
                    Get.back();
                  },
                  onTapOK: () async {
                    await logoutApi(context:context,userType: userType);
                  },
                ),
              );
            },
          );
    }
}


 

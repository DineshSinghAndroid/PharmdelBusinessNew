import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/CreateNotification/createNotificationResponse.dart';

class DriverCreateNotificationController extends GetxController {
  final ApiController apiController = ApiController();

  TextEditingController notificationNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String customerId = '';

  String accessToken = "";
  String userType = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    init();
  }

  void init() async {
    await SharedPreferences.getInstance().then((value) async {
      // print(value);
      accessToken = value.getString(AppSharedPreferences.authToken)!;
      userType = value.getString(AppSharedPreferences.userType)!;
    });
  }

  checkValidation(context) {
    if (messageController.text.isEmail || notificationNameController.text.isEmpty) {
      ToastCustom.showToast(msg: "Enter Name and message");
    } else {
      saveNotificataionApi(context: context);
    }
  }

  Future<void> saveNotificataionApi({required context}) async {
    await CustomLoading().show(context, true);
    CustomLoading().show(context, true);
    Map<String, dynamic> data = {
      "name": notificationNameController.text.toString().trim() ?? "",
      "message": messageController.text.toString().trim() ?? "",
      "patient_id": customerId ?? "",
    };
    print(data);
    String url = WebApiConstant.SAVE_DRIVER_NOTFICATION;
    await apiController.driverCreateNotification(url: url, context: context, dictParameter: data, token: authToken).then((result) async {
      if (result != null) {
        print(result.toString());
        CustomLoading().show(context, false);

        try {
          if (result.status != false) {
            ToastCustom.showToast(msg: result.message,);
            print("Hello world  testing ${result.data.toString()}");
          } else {
            PrintLog.printLog(result.message);
          }
        } catch (_) {}
      }
    });
    CustomLoading().show(context, false);
  }
}

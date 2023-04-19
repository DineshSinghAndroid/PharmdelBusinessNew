import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/Notification/create_notification_response.dart';
import '../../../Model/Notification/notiffication_response.dart';

class CreateNotificationController extends GetxController {
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  TextEditingController notificationNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  bool isName = false;
  bool isMessage = false;


  /// On Tap Submit
  Future<void> onTapSubmit({required BuildContext context})async{
    FocusScope.of(context).unfocus();
    isName = TxtValidation.normalTextField(notificationNameController);
    isMessage = TxtValidation.normalTextField(messageController);
    if(!isName && !isMessage){
      await sendNotificationApi(context: context);
    }
    update();
  }

  /// Send Notification Api
  Future<CreateNotificationApiResponse?> sendNotificationApi({required BuildContext context}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "name": notificationNameController.text.toString().trim() ?? "",
      "message": messageController.text.toString().trim() ?? "",
      "patient_id": AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId),
    };

    await apiCtrl.driverCreateNotification(context: context, url: WebApiConstant.SAVE_DRIVER_NOTFICATION, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
        try {
          if (result.status == true) {
            DateTime date = DateTime.now();
            changeLoadingValue(false);
            changeSuccessValue(true);
            NotificationData data = NotificationData();
            data.name = notificationNameController.text.toString().trim() ?? "";
            data.message = messageController.text.toString().trim() ?? "";
            data.id = "0";
            data.created = "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}";
            Navigator.of(context).pop(data);

            ToastCustom.showToast(msg: result.message ?? "");
          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
          }
        } catch (_) {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");
        }

      } else {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  void changeSuccessValue(bool value) {
    isSuccess = value;
    update();
  }

  void changeLoadingValue(bool value) {
    isLoading = value;
    update();
  }

  void changeEmptyValue(bool value) {
    isEmpty = value;
    update();
  }

  void changeNetworkValue(bool value) {
    isNetworkError = value;
    update();
  }

  void changeErrorValue(bool value) {
    isError = value;
    update();
  }
}

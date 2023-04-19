import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Model/Notification/notiffication_response.dart';
import '../../../main.dart';
import '../../RouteController/RouteNames.dart';

class NotificationController extends GetxController {
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  int? screenIndexValue;
  List<NotificationData>? receivedNotificationData;
  List<NotificationData>? sendNotificationData;

  RefreshController refreshController = RefreshController();


  /// Go to create notification
  Future<void> onTapCreateNotification({required BuildContext context})async {
    Get.toNamed(createNotificationRoute)?.then((value) {
      if(value != null){
        NotificationData data = NotificationData();
        data.name = value.name;
        data.message = value.message;
        data.id = value.id;
        data.created = value.created;
        // sendNotificationData?.add(data);
        sendNotificationData?.insert(0, data);

        update();
      }
    });
  }

  /// On Refresh
  Future<void> onRefresh({required BuildContext context, required int screenIndex})async {
    refreshController.refreshCompleted();
    await notificationApi(context: context,screenIndex: screenIndex);
  }

  Future<NotificationApiResponse?> notificationApi({required BuildContext context, required int screenIndex}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    screenIndexValue = screenIndex;

    Map<String, dynamic> dictparm = {
      "type": screenIndexValue == 0 ? "Receive":"Send"
    };

    await apiCtrl.getNotificationApi(context: context, url: WebApiConstant.NOTIFICATION_URL, dictParameter: dictparm, token: authToken).then((result) async {
      if (result != null) {
          try {
            if (result.status == true) {

              if(result.data != null && screenIndexValue == 0){
                receivedNotificationData = result.data;
              }

              if(result.data != null && screenIndexValue == 1){
                sendNotificationData = result.data;
              }

              result.data == null || result.data!.isEmpty ? changeEmptyValue(true) : changeEmptyValue(false);

              changeLoadingValue(false);
              changeSuccessValue(true);
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

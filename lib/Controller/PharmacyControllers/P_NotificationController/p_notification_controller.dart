import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/CreateNotification/createNotificationResponse.dart';
import '../../../Model/Notification/NotifficationResponse.dart';
import '../../../Model/PharmacyModels/P_SentNotificationResponse/p_sentNotificationRsponse.dart';
import '../../../Model/SaveNotification/saveNotificationResponse.dart';


class PharmacyNotificationController extends GetxController{


  ApiController apiCtrl = ApiController();
  List<NotificationData>? notificationData;
  CreateNotificationData? createNotificationData;
  SaveNotificationApiResponse? saveNotification;
  StaffList? selectedStaff;
  List<SentNotificationData> sentNotificationList = [];
  bool? noRecordFound;
  bool getNextPage = false;
  int pageNo = 1;  

  TextEditingController notificationNameController = TextEditingController();
  TextEditingController notificationMessageController = TextEditingController();
  TextEditingController pharStaffController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  @override
  void onInit() {    
    super.onInit();   
  }

  ///Select Pharmacy Satff
  void updateStaffValue(value){
    selectedStaff = value;
    update();
  }
  


  ///Select Pharmacy Staff
  void onTapSelectStaff(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Select staff");
    BottomSheetCustom.pSelectPharmacyStaff(
      controller: controller,
      context: context,
      selectedID: selectedStaff?.userId,
      onValue: (value) async {
        if (value != null) {
          selectedStaff = value;
          update();
          PrintLog.printLog("Selected staff: ${selectedStaff?.name}");
        }
      },
    );
  }

  ///OnTap Submit Button
  void onTapSubmit({required BuildContext context})async{
    if(notificationNameController.text.isEmpty){
      ToastCustom.showToast(msg: 'Enter notification name');
    } else if(selectedStaff == null){
      ToastCustom.showToast(msg: 'Select pharmacy staff');
    } else if(notificationMessageController.text.isEmpty){
      ToastCustom.showToast(msg: 'Enter notification message');
    } else{
      await saveNotificationApi(
    context: context,
    name: notificationNameController.text.toString().trim(), 
    userList: selectedStaff?.userId ?? "", 
    message: notificationMessageController.text.toString().trim(), 
    role: selectedStaff?.role ?? "");
    }
    update();
  }

  ///Recieve Notification Controller
  Future<NotificationApiResponse?> notificationApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "":""
    };

    String url = WebApiConstant.GET_PHARMACY_NOTIFICATION;

    await apiCtrl.getNotificaitonApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {          
          try {            
            if (result.status == true) {              
              notificationData = result.data;
              result.data == null ? changeEmptyValue(true):changeEmptyValue(false);
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
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  ///Sent Notification Controller
  Future<SentNotificationApiResponse?> sentNotificationApi({required BuildContext context,required int pageNo}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "page":pageNo
    };

    String url = WebApiConstant.GET_SENT_NOTIFICATION_URL;

    await apiCtrl.getSentNotificationApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
          if(pageNo == 1){
        changeNextPageValue(true);
        sentNotificationList.clear();
      }
      if(result != null){
        if (result.status != false) {          
          try {            
            if (result.status == true) {                                         
              if(pageNo == 1){
                result.sentNotificationData != null && result.sentNotificationData!.isEmpty ? changeEmptyValue(true):changeEmptyValue(false);
              }
              if(result.sentNotificationData != null && result.sentNotificationData!.isNotEmpty){
                changeNextPageValue(true);
                sentNotificationList.addAll(result.sentNotificationData!);
              }else{
                changeNextPageValue(false);
              }
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
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


    ///Create Notification Controller
  Future<CreateNotificationApiResponse?> createNotificationApi({required BuildContext context,}) async {    
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "":""
    };

    String url = WebApiConstant.GET_PHARMACY_CREATE_NOTIFICATION;

    await apiCtrl.getCreateNotificationApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {        
        if (result != null && result.status != null && result.status != false) {
          try {
            if (result.status == true) {
              createNotificationData = result.data;
              result.data == null ? changeEmptyValue(true):changeEmptyValue(false);
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
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result?.message);
        }

    });
    update();
  }


  ///Save Notification Controller
    Future<SaveNotificationApiResponse?> saveNotificationApi({
      required BuildContext context,
      required String name,
      required String userList,
      required String message,
      required String role,
      }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "name":name,
    "user_list":userList,
    "message":message,
    "role":role,
    };

    String url = WebApiConstant.GET_PHARMACY_SAVE_NOTIFICATION;

    await apiCtrl.getSaveNotificationApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {          
          try {            
            if (result.status == true) {              
              saveNotification = result;                                          
              result == null ? changeEmptyValue(true):changeEmptyValue(false);               
              changeLoadingValue(false);
              changeSuccessValue(true);
              Navigator.of(context).pop(true);
              ToastCustom.showToast(msg: "Notification Sent Successfully");

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
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  void changeNextPageValue(bool value){
    getNextPage = value;
    update();
  }
  void changeSuccessValue(bool value){
    isSuccess = value;
    update();
  }
  void changeLoadingValue(bool value){
    isLoading = value;
    update();
  }
  void changeEmptyValue(bool value){
    isEmpty = value;
    update();
  }
  void changeNetworkValue(bool value){
    isNetworkError = value;
    update();
  }
  void changeErrorValue(bool value){
    isError = value;
    update();
  }

}


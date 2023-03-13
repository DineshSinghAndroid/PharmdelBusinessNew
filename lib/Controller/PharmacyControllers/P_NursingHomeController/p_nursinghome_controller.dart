import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Model/PharmacyModels/P_GetBoxesResponse/p_getBoxesApiResponse.dart';
import '../../../Model/PharmacyModels/P_NursingHomeOrderResponse/p_nursingHomeOrderResponse.dart';
import '../../../Model/PharmacyModels/P_NursingHomeResponse/p_nursingHomeResponse.dart';
import '../../../Model/PharmacyModels/P_UpdateNursingOrderResponse/p_updateNursingOrderResponse.dart';
import '../../../main.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/Toast/ToastCustom.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';


class NursingHomeController extends GetxController{

  ApiController apiCtrl = ApiController();
  List<NursingOrdersData>? nursingOrdersData;
  List<BoxesData> boxesListData = [];
  String? selectedBoxValue = BoxesData().boxName;
  List<NursingHome> nursingHomeList = [];  
  String? selectedNursingValue = NursingHome().nursingHomeName;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

 ///Get Driver List Controller
 GetDriverListController getDriverListController = Get.put(GetDriverListController());

 ///Get Route List Controller
 PharmacyGetRouteListController getRouteListController = Get.put(PharmacyGetRouteListController());
 


///Nursing Home Controller
Future<NursingHomeApiResponse?> nursingHomeApi({context}) async {
  nursingHomeList.clear();
    await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {};
    String url = WebApiConstant.GET_PHARMACY_NURSING_HOME;
    await apiCtrl.getNursingHomeApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
           nursingHomeList.addAll(result.nursingHomeData!);

         } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
          ToastCustom.showToast(msg: result.message ?? "");
        }
      } else {
        CustomLoading().show(context, false);

        PrintLog.printLog(result?.message);
        ToastCustom.showToast(msg: result?.message ?? "");
        update();
      }
    });
    update();
    CustomLoading().show(context, false);
  }


  ///Get Boxes Controller
  Future<GetBoxesApiResponse?> boxesApi({required BuildContext context, required String nursingId}) async {    
  boxesListData.clear();
    await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {
      "nursing_id":nursingId
    };
    String url = WebApiConstant.GET_PHARMACY_BOXES;
    await apiCtrl.getBoxesApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
           boxesListData.addAll(result.boxesdata!);

         } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
          ToastCustom.showToast(msg: result.message ?? "");
        }
      } else {
        CustomLoading().show(context, false);

        PrintLog.printLog(result?.message);
        ToastCustom.showToast(msg: result?.message ?? "");
        update();
      }
    });
    update();
    CustomLoading().show(context, false);
  }


///Update Nursing Order Controller
Future<UpdateNursingOrderApiResposne?> getUpdateNursingOrderApi({
  required BuildContext context,
  required String? orderId,
  required String? storageTypeCD,
  required String? storageTypeFR,

  }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "orderId":orderId,
    "storage_type_cd":storageTypeCD,
    "storage_type_fr":storageTypeFR,  
    };

    String url = WebApiConstant.GET_PHARMACY_UPDATE_NURSING_ORDER;

    await apiCtrl.updateNursingOrderApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.error != true) {          
          try {            
            if (result.error == false) {                                                    
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

///Get Nursing Order List Controller
Future<NursingOrderApiResponse?> nursingHomeOrderApi({
  required BuildContext context,
  required String? routeId,
  required String? dateTime,
   String? driverId,
   String? nursingHomeId,
   String? toteBoxId,
  }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "routeId":routeId,
    "dateTime":dateTime,
    "driverId":driverId,
    "nursing_home_id":nursingHomeId,
    "tote_box_id":toteBoxId,
    };

    String url = WebApiConstant.GET_PHARMACY_DELIVERY_LIST;

    await apiCtrl.getNursingHomeOrderApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != 'false') {          
          try {            
            if (result.status == 'true') {              
              nursingOrdersData = result.nursingOrderData;              
              result.nursingOrderData == null ? changeEmptyValue(true):changeEmptyValue(false);
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





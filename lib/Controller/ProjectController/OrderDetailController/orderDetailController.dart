import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Model/OrderDetails/orderdetails_response.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../main.dart';



class OrderDetailController extends GetxController{

  ApiController apiCtrl = ApiController();
  OrderDetailApiResponse? orderDetailData;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  Future<OrderDetailApiResponse?> orderDetailApi({
    required BuildContext context,
    required String orderID,
    required String routeID,
    required bool isScan,
    required bool isComplete,
    required bool orderIdMain
    }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "OrderId":orderID,
    "isScan":isScan,
    "routeId":routeID,
    "isComplete":isComplete,
    "orderIdMain":orderIdMain
    };

    String url = WebApiConstant.SCAN_ORDER_BY_DRIVER;

    await apiCtrl.getOrderDetailApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
          try {
              orderDetailData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);

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


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Model/DriverList/driverListResponse.dart';
import '../../../Model/DriverRoutes/driverRoutesResponse.dart';
import '../../../main.dart';


class NursingHomeController extends GetxController{

  ApiController apiCtrl = ApiController();
  DriverListApiResponse? driverListData;
  DriverRoutesApiResposne? routesData;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;






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


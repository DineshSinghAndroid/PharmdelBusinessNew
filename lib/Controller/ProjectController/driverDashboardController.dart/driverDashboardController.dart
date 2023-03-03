import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:pharmdel/Model/DriverDashboard/driverDashboardResponse.dart';
import 'package:pharmdel/Model/NotificationCount/notificationCountResponse.dart';
import '../../../Model/DriverProfile/profileDriverResponse.dart';
import '../../../Model/Enum/enum.dart';
import '../../../Model/OrderDetails/orderdetails_response.dart';
import '../../../Model/VehicleList/vehicleListResponse.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../../Model/DriverRoutes/driverRoutesResponse.dart';
import '../../../main.dart';
import '../../Helper/Permission/PermissionHandler.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/Popup/PopupCustom.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';


class DriverDashboardController extends GetxController{


  ApiController apiCtrl = ApiController();
  DriverDashboardApiresponse? driverDashboardData;
  NotificationCountApiResponse? notificationCountData;
  DriverRoutesApiResposne? routesData;
  OrderDetailApiResponse? orderDetailData;
  VehicleListApiResponse? vehicleListData;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  

  Future<DriverDashboardApiresponse?> driverDashboardApi({required BuildContext context, required String routeID, }) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "routeId":routeID,
    "page":"2",
    "PageSize":"30",
    "Status":true
    };

    String url = WebApiConstant.GET_DELIVERY_LIST;

    await apiCtrl.getDriverDashboardApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {
              driverDashboardData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
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

  Future<NotificationCountApiResponse?> notificationCountApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "":""
    };

    String url = WebApiConstant.GET_NOTIFICATION_COUNT;

    await apiCtrl.getNotificationCountApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {              
              notificationCountData = result;                                                                    
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
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


   Future<DriverRoutesApiResposne?> driverRoutesApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "":""
    };

    String url = WebApiConstant.GET_DRIVER_ROUTES;

    await apiCtrl.getDriverRoutesApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {          
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {              
              routesData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
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

    ///Order Details Controller
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

  ///Vehicle List Controller
  Future<DriverProfileApiResponse?> vehicleListApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "":""
    };

    String url = WebApiConstant.GET_VEHICLE_LIST_URL;

    await apiCtrl.getVehicleListApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != "false") {
          try {
            if (result.status == "true") {
              vehicleListData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);
             
            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog("Status : ${result.status}");
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
          PrintLog.printLog(result.status);
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

    Future getLocationData({required BuildContext context}) async { 
    CheckPermission.checkLocationPermission(context).then((value) async {
      Location? location;
      LocationData? locationData;
      PermissionStatus? permissionGranted;
      List<LocationData> locationArray = [];
      if (value == true) {
        if (location == null) location = Location();
        locationData = await location.getLocation();
        if (locationData != null) {
          locationArray.add(locationData);
        }
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != PermissionStatus.granted) {
            return;
          } 
        }
        if (permissionGranted == PermissionStatus.granted) {
          locationData = await location.getLocation();
          location.changeSettings(
              distanceFilter: 10, accuracy: LocationAccuracy.high);
          location.enableBackgroundMode(enable: true);
          location.onLocationChanged.listen((LocationData currentLocation) {      
            locationArray.add(currentLocation);
            if (locationArray.length > 5) locationArray.removeAt(0);
          });
        }
      }
    });
  }

  _toRadians(double degree) {
    return degree * pi / 180;
  }

  void onClieck(bool value) {
    // if (value) endRoute(false);
  }

   getDistance(startLatitude, startLongitude, endLatitude, endLongitude) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
            pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));    
    return earthRadius * c;
  }


  void autoEndRoutePopUp(context) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset(strIMG_DelTruck),
            title: kAlert,
            btnDone: kOkay,
            descriptions: kRouteEnd,
          );
        });
  }


  void reArrangingRoutePopup(context) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomPopUp.ReArrangeRoutePopUp(context: context);
        });
  }


    void noInternetPopUp(String msg,context) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset(strIMG_Sad),
            title: kAlert,
            btnDone: kOkay,
            btnNo: "",
            descriptions: msg,
          );
        });
  }


  void endRoutePopup(context) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset(strIMG_DelTruck),
            title: kAlert,
            btnDone: kEndRoute,
            btnNo: kNo,
            onClicked: onClieck,
            descriptions: kEndRouteWarning,
          );
        });
  }


  void openCalender(StateSetter sateState1, BuildContext context) {
    DateTime date = DateTime.now();
     String selectedDate;
     String selectedDateTimeStamp;
     final DateFormat formatter = DateFormat("dd-MM-yyyy");
    showDatePicker(
        context: context,
        initialDate: DateTime(date.year, date.month, date.day),
        firstDate: DateTime(date.year, date.month, date.day),
        lastDate: DateTime(2050),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.orangeAccent),
              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ), 
            child: child!);
        }).then((pickedDate) {
      if (pickedDate == null) return;
      sateState1(() {
        selectedDate = formatter.format(pickedDate);
        selectedDateTimeStamp = pickedDate.millisecondsSinceEpoch.toString();
      });
    });
  }  

}


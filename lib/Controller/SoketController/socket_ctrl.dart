import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/SoketController/socket_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../DB_Controller/MyDatabase.dart';
import '../Helper/SentryExemption/sentry_exemption.dart';
import '../ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../ProjectController/LocalDBController/local_db_controller.dart';
import '../ProjectController/MainController/main_controller.dart';


class SocketController extends GetxController{
  StreamSocket streamSocket = StreamSocket();
  LocalDBController dbCtrl = Get.put(LocalDBController());
  DriverDashboardCTRL dashCtrl = Get.put(DriverDashboardCTRL());

  IO.Socket? locationSocket;
  Map<String, dynamic>? library;

  String? routeID;
  String? pharmacyID;
  bool isRouteStart = false;
  bool isAvlInternet = false;

  bool showAlertDialogForDriver = false;

  Timer? timerRunEveryThreeSec;


  @override
  void onInit() {
    locationSocket = IO.io(WebApiConstant.SOCKET_URL, IO.OptionBuilder().setTransports(['websocket']).build());
    routeID = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID);
    pharmacyID = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.pharmacyID);
    isRouteStart = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.isStartRoute).toString().toLowerCase() == "true" ? true:false;
    // initialCall();
    super.onInit();
  }

  Future<void> initialCall()async{
    /// This method send order check in socket or is avl complete data then Upload data api call
    await sendChatToServerThroughTimer();

    /// No need for timer because complete data upload on delivery timer or onNetwork connect
    // await completedDataThroughTimer().then((value) async {
    // });
  }

  /// Socket Init
  Future<void> connectAndListen() async {
    PrintLog.printLog("Socket Connect And Listen:::::::::::::::");
    try {
      if (locationSocket != null && locationSocket!.connected) {
        sendLocationInSocket();
      } else {
        locationSocket?.onConnect((_) async {
          PrintLog.printLog('Calling Socket :::::::::::::::::OnConnect');
          PrintLog.printLog('OnConnect Response :::::::::::::::::$_');
          sendLocationInSocket();
          completedDataUploadStartOnSocketConnect();
        });
      }

      //When an event recieved from server, data is added to the stream
      locationSocket?.on('sendLocationToClient', (data) {
        PrintLog.printLog('Calling Socket :::::::::::::::::SendLocationToClient');
        PrintLog.printLog('SendLocationToClient Response :::::::::::::::::$data');
        streamSocket.addLocationResponse(data);
      });
      locationSocket?.onDisconnect((_) {
        PrintLog.printLog('Calling Socket :::::::::::::::::OnDisconnect');
        PrintLog.printLog('OnDisconnect Response :::::::::::::::::$_');
      });
      locationSocket?.onConnectError((data) {
        PrintLog.printLog('Calling Socket :::::::::::::::::OnConnectError');
        PrintLog.printLog('OnConnectError Response :::::::::::::::::$data');
      });
      locationSocket?.onConnect((data) {
        PrintLog.printLog('Calling Socket :::::::::::::::::OnConnect2');
        PrintLog.printLog('OnConnect2 Response :::::::::::::::::$data');
        // getLocation();
      });
      // socket.connect();
    } catch (ex, stackTrace) {
      SentryExemption.sentryExemption(ex, stackTrace);
      PrintLog.printLog('Socket Exemption:::::::::::::::::$ex');

    }
  }

  /// Send Location
  Future<void> sendLocationInSocket()async {
    await CheckPermission.checkLocationPermission(Get.overlayContext!,).then((value) async {
      if(value == true){
        if(authToken != ""){
          if (locationSocket != null && locationSocket!.connected) {
            if (driverType.toLowerCase() == kDedicatedDriver.toLowerCase() || driverType.toLowerCase() == kSharedDriver.toLowerCase()) {
              library = {
                "driver_id": userID,
                "pharmacy_id": pharmacyID ?? "",
                "device_name": "android",
                "route_id": routeID ?? "",
                "latitude": await CheckPermission.getLatitude(Get.overlayContext!,),
                "longitude": await CheckPermission.getLatitude(Get.overlayContext!,),
                // "latitude": "${currentLocation.latitude}",
                // "longitude": "${currentLocation.longitude}",
              };
              PrintLog.printLog("Sending location in Socket:${jsonEncode(library)}");
              locationSocket?.emit('sendLocationToServer', jsonEncode(library));
            }
          }
        }
      }
    });

  }

  /// Send Chat To Server
  Future<void> sendChatToServer({required event})async {
    var completeAllList = await MyDatabase().getAllOrderCompleteData();
    if (event != null) {

      Map valueMap = json.decode(event);
      isRouteStart = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.isStartRoute).toString().toLowerCase() == "true" ? true:false;
      await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.deviceId, variableValue: valueMap["device_id"] ?? "");
      PrintLog.printLog("Socket Send Chat To Server ::::::::::::\nMap:$valueMap");

      if (valueMap["driver_id"] == userID && valueMap["device_name"] == "admin") {
        if (valueMap["state"] == "driver_check" && isRouteStart) {
          Map<String, String> library = {
            "driver_id": userID ?? "",
            "route_id": routeID ?? "",
            "device_id": valueMap["device_id"],
            "online_status": "online",
            "offline_order_status": completeAllList.isEmpty ? "not_available" : "available",
            // offline order available
            "sorting_started": "false",
            "device_name": "android",
            "state": "driver_check",
            "token": authToken
          };
          PrintLog.printLog("Socket Send Chat To Server ::::::::::::\nLibrary:${jsonEncode(library)}");

          locationSocket?.emit('sendChatToServer', jsonEncode(library));
        } else if (valueMap["state"] == "reDriver_check" && isRouteStart) {
          Map<String, String> library = {
            "driver_id": userID ?? "",
            "route_id": routeID ?? "",
            "online_status": "online",
            "device_id": valueMap["device_id"],
            "offline_order_status": completeAllList.isEmpty ? "not_available" : "available",
            // offline order available
            "sorting_started": "false",
            "device_name": "android",
            "state": "reDriver_check",
            "token": authToken
          };
          PrintLog.printLog("Socket Send Chat To Server ::::::::::::\nLibrary:${jsonEncode(library)}");
          locationSocket?.emit('sendChatToServer', jsonEncode(library));
        } else if (valueMap["state"] == "reorder_check" && isRouteStart) {
          if (valueMap["sorting_started"]) {
            if (!showAlertDialogForDriver) {
              showAlertDialogForDriver = true;
              reArrangingRoutePopup(message: valueMap["message"]);
            }
          } else {
            if (showAlertDialogForDriver) {
              Get.back();
              showAlertDialogForDriver = false;
            }
          }
        }
      }
    }
  }

  /// ReOrder PopUp
  void reArrangingRoutePopup({required String message}) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              insetPadding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// Image
                    const Image(image: AssetImage(strGifProcessing)),
                    /// Title
                    BuildText.buildText(text: kProcessing,size: 22,weight: FontWeight.w600, color: AppColors.redColor ),
                    buildSizeBox(30.0, 0.0),

                    /// Message
                    BuildText.buildText(text: message ?? "",size: 16,textAlign: TextAlign.center),
                    buildSizeBox(25.0, 0.0),

                    /// Btn
                    InkWell(
                      onTap: ()=> Navigator.of(context).pop(true),
                      child: Container(
                        height: 45,
                        width: Get.width * 60 / 100,
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3), blurRadius: 5.0, spreadRadius: 3.0, offset: const Offset(0, 3)
                              )
                            ],
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Center(
                          child: BuildText.buildText(text: kCheckAgain,color: AppColors.whiteColor),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          );
        }).then((value)=>onTapPopUp(value: value));
  }

  /// On Tap PopUp Check Again
  Future<void> onTapPopUp({required value})async{

    if(value == true){
      isAvlInternet = await ConnectionValidator().check();
      if (!isAvlInternet) {
        ToastCustom.showToast(msg: kInternetNotAvailable2);
        return;
      }

      if (locationSocket != null && locationSocket!.disconnected) {
        if (showAlertDialogForDriver) {
            Get.back();
          showAlertDialogForDriver = false;
        }
      } else {
        var completeAllList = await MyDatabase().getAllOrderCompleteData();
        Map<String, String> library = {
          "driver_id": userID ?? "",
          "route_id": routeID ?? "",
          "device_id": AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deviceId) ?? "",
          "online_status": "online",
          "offline_order_status": completeAllList.isEmpty ? "not_available" : "available",
          // offline order available
          "sorting_started": "false",
          "device_name": "android",
          "state": "reorder_check",
          "token": authToken
        };
        PrintLog.printLog("Socket Send Chat To Server ::::::::::::\nLibrary:${jsonEncode(library)}");
        locationSocket?.emit('sendChatToServer', jsonEncode(library));

      }
    }

  }


  /// Uploaded Data Socket onConnect
  Future<void> completedDataUploadStartOnSocketConnect()async {
    PrintLog.printLog("Uploaded Data Start On Socket Connect::::::::::::");
    isAvlInternet = await ConnectionValidator().check();
    if (isAvlInternet) {
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      if (authToken != "" && completeAllList.isNotEmpty) {
        PrintLog.printLog("Upload Completed Data Through Socket::::::::::::");
        await dbCtrl.checkPendingCompleteDataInDB(context: Get.overlayContext!).then((value) async {
          if(dashCtrl.driverDashboardData != null && dashCtrl.driverDashboardData?.deliveryList != null && dashCtrl.driverDashboardData?.deliveryList?.length == 1 ){
            if(dashCtrl.driverDashboardData?.deliveryList?[0].orderId == "0"){
              dashCtrl.endRouteApi(context: Get.overlayContext!);
            }
          }
          // completeAllList = await MyDatabase().getAllOrderCompleteData();
          // if (authToken != "" && completeAllList.isNotEmpty) {
          //   await dbCtrl.checkPendingCompleteDataInDB(context: Get.overlayContext!);
          // }
        });
      }
    }
  }

  /// Timer Functionality:::::::::::

  /// Uploaded Data Timer
  Future<void> completedDataThroughTimer()async {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      timerRunEveryThreeSec = timer;
      PrintLog.printLog("Uploaded Data Timer Running::::::::::::");
      isAvlInternet = await ConnectionValidator().check();
      if (isAvlInternet) {
        var completeAllList = await MyDatabase().getAllOrderCompleteData();
          if (authToken != "" && completeAllList.isNotEmpty) {
            PrintLog.printLog("Upload Completed Data Through Socket::::::::::::");
            await dbCtrl.checkPendingCompleteDataInDB(context: Get.overlayContext!);
          }
      }
    });
  }

  /// Send Chat To Server - Order check state::
  Future<void> sendChatToServerThroughTimer()async {
    Timer.periodic(const Duration(seconds: 60), (timer) async {
      timerRunEveryThreeSec = timer;

      PrintLog.printLog('Send chat to server order check :::::::::::::');

      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      if (completeAllList.isEmpty) {
        timerRunEveryThreeSec?.cancel();

        Map<String, String> library = {
          "driver_id": userID ?? "",
          "route_id": routeID ?? "",
          "online_status": "online",
          "device_id": AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deviceId) ?? "",
          "offline_order_status": completeAllList.isEmpty ? "not_available" : "available",
          // offline order available
          "sorting_started": "false",
          "device_name": "android",
          "state": "order_check",
          "token": authToken
        };

        PrintLog.printLog('Send chat to server order check :::::::::::::\nDic_Data:${jsonEncode(library)}');
        locationSocket?.emit('sendChatToServer', jsonEncode(library));

      }else{
        completedDataUploadStartOnSocketConnect();
      }
    });
  }
}
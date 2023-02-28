import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:sizer/sizer.dart';
<<<<<<< HEAD
import 'package:socket_io_client/socket_io_client.dart';
import '../../../Model/Enum/enum.dart';
import '../../DB_Controller/MyDatabase.dart';
=======
import '../../../PHARMACY/P_Views/P_Home/Pharmacy_home_age.dart';
>>>>>>> d9abbda302f6e1b2b9e93e6385c7868d9059fda1
import '../../RouteController/Route.dart'as router;
import '../../StopWatchController/stop_watch_controller.dart';


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  bool isUploading = false;
  var isDelivery = false;
  Timer? timer1;
  bool showAlertDialogForDriver = false;
  int? deliveryTime;
  StopWatchTimer? stopWatchTimer;
  bool UserOnBreak = false;


  String? driverId;
  String? routeId;
  bool? isRouteStart;

  @override
  void initState() {
    connectAndListen();
    init();
    super.initState();
  }

  Future<void> init()async{
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      timer1 = timer;
      bool checkInternet = await ConnectionValidator().check();
      if (checkInternet) {
        if (!isUploading) {
          var tokenList = await MyDatabase().getToken();
          if (tokenList != null && tokenList.isNotEmpty) {
            isUploading = true;
            updateSignature();
          }
        }
      } else {
        isUploading = false;
      }
    });

    if (streamSocket.getResponse != null) {
      streamSocket.getResponse.listen((event) async {
        driverId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId) ?? "";
        routeId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID) ?? "";
        isRouteStart = AppSharedPreferences.getBoolValueFromSharedPref(variableName: AppSharedPreferences.isRouteStart) ?? false;

        var completeAllList = await MyDatabase().getAllOrderCompleteData();
        var token = await MyDatabase().getToken();
        if (event != null) {
          Map valueMap = json.decode(event);
          await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.deviceID, variableValue: valueMap["device_id"] ?? "");

          if (valueMap["driver_id"] == driverId && valueMap["device_name"] == "admin") {
            if (valueMap["state"] == "driver_check" && isRouteStart!) {
              Map<String, String> library = {
                "driver_id": driverId ?? "",
                "route_id": routeId ?? "",
                "device_id": valueMap["device_id"],
                "online_status": "online",
                "offline_order_status": completeAllList.isEmpty ? "not_available" : "available",
                // offline order available
                "sorting_started": "false",
                "device_name": "android",
                "state": "driver_check",
                "token": token.first.token.toString()
              };

              PrintLog.printLog(jsonEncode(library));
              socket.emit('sendChatToServer', jsonEncode(library));
            } else if (valueMap["state"] == "reDriver_check" && isRouteStart!) {
              Map<String, String> library = {
                "driver_id": driverId ?? "",
                "route_id": routeId ?? "",
                "online_status": "online",
                "device_id": valueMap["device_id"],
                "offline_order_status": completeAllList.isEmpty ? "not_available" : "available",
                // offline order available
                "sorting_started": "false",
                "device_name": "android",
                "state": "reDriver_check",
                "token": token.first.token.toString()
              };
              PrintLog.printLog(jsonEncode(library));
              socket.emit('sendChatToServer', jsonEncode(library));
            } else if (valueMap["state"] == "reorder_check" && isRouteStart!) {
              if (valueMap["sorting_started"]) {
                if (!showAlertDialogForDriver) {
                  showAlertDialogForDriver = true;
                  reArrangingRoutePopup(valueMap["message"]);
                }
              } else {
                if (showAlertDialogForDriver) {
                  Navigator.pop(context);
                  showAlertDialogForDriver = false;
                }
              }
            }
          }
        }
      });
    }
    dialogDismissTimer();
  }

  void connectAndListen() {
    try {
      socket.onConnect((_) async {
        // socket.emit('sendChatToServer', 'test');
        String driverId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId) ?? "";
        String routeId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID) ?? "";
        bool isLogin = authToken != null ? true : false;
        bool isRouteStart = AppSharedPreferences.getBoolValueFromSharedPref(variableName: AppSharedPreferences.isRouteStart) ?? false;

        String deviceId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deviceID) ?? "";
        var completeAllList = await MyDatabase().getAllOrderCompleteData();
        var token = await MyDatabase().getToken();
        PrintLog.printLog("isLogin $isLogin");
        PrintLog.printLog("isRouteStart $isRouteStart");
        if (isRouteStart && isLogin) {
          Map<String, String> library = {
            "driver_id": driverId,
            "route_id": routeId,
            "online_status": "online",
            "device_id": deviceId,
            "offline_order_status": completeAllList.isNotEmpty ? "not_available" : "available",
            "sorting_started": "false",
            "device_name": "android",
            "state": "reorder_check",
            "token": token != null && token.isNotEmpty ? token.first.token.toString() : ""
          };
          PrintLog.printLog(jsonEncode(library));
          socket.emit('sendChatToServer', jsonEncode(library));
        }
      });

      //When an event recieved from server, data is added to the stream
      socket.on('sendChatToClient', (data) {
        streamSocket.addResponse(data);
        streamSocket.addResponseOutForDelivery(data);
      });
      socket.onDisconnect((_) {
        PrintLog.printLog('disconnect');
      });
      socket.onConnectError((data) {
        PrintLog.printLog(data);
      });
      socket.onConnect((data) {
        PrintLog.printLog('2nd onConnect');
        PrintLog.printLog(data);
      });
      // socket.connect();
    } catch (ex, stackTrace) {
      SentryExemption.sentryExemption(ex, stackTrace);
      PrintLog.printLog(ex);
    }
  }
  Future<void> updateSignature() async {
    String accessToken = "";
    PrintLog.printLog("accessToken : $accessToken");

    MyDatabase().getAllOrderCompleteData().then((value) async {
      PrintLog.printLog("updateSignature value : $value");
      if(value != null && value.isNotEmpty){
        await Future.forEach(value, (element) async {
          var tokenList = await MyDatabase().getToken();
          if(tokenList != null && tokenList.isNotEmpty){
            accessToken = tokenList.last.token;
          }
          if(tokenList != null && tokenList.isNotEmpty) {
            ApiController apiCTRL = ApiController();
            Map<String, dynamic> prams = {
              "remarks": element.remarks,
              "deliveredTo": element.deliveredTo,
              "deliveryId": element.deliveryId.toString().split(","),
              "routeId": element.routeId,
              "exemption": element.exemptionId,
              "paymentStatus": element.paymentStatus,
              "driverId": element.userId,
              "payment_method": element.paymentMethode,
              "del_charge": element.addDelCharge,
              "payment_remark": element.notPaidReason,
              "subs_id": element.subsId,
              "rx_invoice": element.rxInvoice,
              "rx_charge": element.rxCharge,
              "mobileNo": element.param1,
              "failed_remark": element.param2,
              "customerRemarks": element.customerRemarks,
              "baseSignature": element.baseSignature,
              "DeliveryStatus": element.deliveryStatus,
              "rescheduleDate": element.reschudleDate,
              "customerImage": element.baseImage,
              "questionAnswerModels": "", //widget.arrAns
              "latitude": 0.00,
              "longitude": 0.00
            };

            PrintLog.printLog("URL: ${WebApiConstant.DELIVERY_SIGNATURE_UPLOAD_URL}");
            PrintLog.printLog("Prams: $prams");

            await apiCTRL
                .postFormBackgroundDataAPI(context: context,url: WebApiConstant.DELIVERY_SIGNATURE_UPLOAD_URL, formData:  prams)
                .then((response) async {
              try {
                if (response != null) {
                  if (response.data["Unauthenticated"] == false) {//
                    await clearTokenTable();
                    if (value.last == element) {
                      isUploading = false;
                    }
                  } else {
                    var data = json.decode(response.data);
                    if (data["status"] == true || data["status"] == 'true') {
                      await MyDatabase().deleteCompletedDeliveryById(element);
                      if (value.last == element) {
                        updateSignature();
                      }
                    } else {
                      if (value.last == element) {
                        isUploading = false;
                      }
                    }
                  }
                } else {
                  if (value.last == element) {
                    isUploading = false;
                  }
                }
              } catch (e, stackTrace) {
                SentryExemption.sentryExemption(e, stackTrace);
                if (value.last == element) {
                  isUploading = false;
                }
              }
            }, onError: (error, stackTrace) {
              SentryExemption.sentryExemption(e, stackTrace);
              if (value.last == element) {
                isUploading = false;
              }
            });
          }else{
            if (value.last == element) {
              isUploading = false;
            }
          }
        });
      }else{
        isUploading = false;
      }
    });

  }

  Future<int> clearTokenTable() async {
    await MyDatabase().deleteToken();
    return Future.value(1);
  }

  Future<void> dialogDismissTimer() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      timer1 = timer;
      PrintLog.printLog('Dashboard Background Service');

      String driverId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId) ?? "";
      String routeId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID) ?? "";
      String deviceId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deviceID) ?? "";
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      var token = await MyDatabase().getToken();
      if (completeAllList == null || completeAllList.isEmpty) {
        timer1?.cancel();
        Map<String, String> library = {
          "driver_id": driverId,
          "route_id": routeId,
          "online_status": "online",
          "device_id": deviceId,
          "offline_order_status": completeAllList.isEmpty ? "not_available" : "available",
          // offline order available
          "sorting_started": "false",
          "device_name": "android",
          "state": "order_check",
          "token": token != null && token.isNotEmpty ? token.first.token.toString() : ""
        };
        PrintLog.printLog("dialogDissmissTimer: ${jsonEncode(library)}");
        socket.emit('sendChatToServer', jsonEncode(library));
      }
    });
  }

  void reArrangingRoutePopup(String message) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
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
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage("assets/processing.gif"),
                    ),
                    const Text(
                      "Processing...",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.red),
                    ),
                    buildSizeBox(30.0, 0.0),
                    Text(
                      message ?? "",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    buildSizeBox(25.0, 0.0),

                    InkWell(
                      onTap: () async {
                        bool checkInternet = await ConnectionValidator().check();
                        if (!checkInternet) {
                          ToastCustom.showToast(msg: kInternetNotAvailable);
                          return;
                        }
                        if (socket.disconnected) {
                          if (showAlertDialogForDriver) {
                            Navigator.pop(context);
                            showAlertDialogForDriver = false;
                          }
                        } else {
                          String driverId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId) ?? "";
                          String routeId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID) ?? "";
                          String deviceId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.deviceID) ?? "";

                          var completeAllList = await MyDatabase().getAllOrderCompleteData();
                          var token = await MyDatabase().getToken();
                          Map<String, String> library = {
                            "driver_id": driverId,
                            "route_id": routeId,
                            "online_status": "online",
                            "device_id": deviceId,
                            "offline_order_status": completeAllList.isNotEmpty ? "not_available" : "available",
                            "sorting_started": "false",
                            "device_name": "android",
                            "state": "reorder_check",
                            "token": token != null && token.isNotEmpty ? token.first.token.toString() : ""
                          };
                          PrintLog.printLog(jsonEncode(library));
                          socket.emit('sendChatToServer', jsonEncode(library));
                        }
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(0, 3)
                              )
                            ],
                            borderRadius: BorderRadius.circular(50.0)),
                        child: const Center(child: Text(kCheckAgain, style: TextStyle(color: Colors.white))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }


  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {

    switch (state) {
      case AppLifecycleState.resumed:
        PrintLog.printLog("app in resumed");
        // if(timer1 != null && !timer1.isActive)
        //   timer1.();
        break;
      case AppLifecycleState.inactive:
        PrintLog.printLog("app in inactive");
        break;
      case AppLifecycleState.paused:
        PrintLog.printLog("apppp in paused");
        if (timer1 != null && timer1!.isActive) timer1?.cancel();
        break;
      case AppLifecycleState.detached:
        PrintLog.printLog("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Sizer(
      builder: (context, orientation, deviceType) {
<<<<<<< HEAD
        return const OverlaySupport.global(
            child: GetMaterialApp(
            initialRoute: splashScreenRoute,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: router.generateRoute,
            // initialRoute: splashScreenRoute,
            title: "Pharmdel Business",
          )
=======
        return const GetMaterialApp(
          initialRoute: splashScreenRoute,
          // home: PharmacyHomeScreen(),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router.generateRoute,
           title: "Pharmdel Business",
>>>>>>> d9abbda302f6e1b2b9e93e6385c7868d9059fda1
        );

      },
    );
  }
}

class SentryExemption {
  static sentryExemption(e, stackTrace) async {
    // await Sentry.captureException(
    //   e,
    //   stackTrace: stackTrace,
    // );
  }
}

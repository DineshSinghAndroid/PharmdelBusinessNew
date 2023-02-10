// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

// import 'package:location/location.dart';
// import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pharmdel_business/provider/GetMedicineProvider.dart';
import 'package:pharmdel_business/provider/fetchDataProvider.dart';
import 'package:pharmdel_business/provider/repeat_prescription_imageProvider.dart';
import 'package:pharmdel_business/stop_watch_timer.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/branch_admin_dashboard.dart';
import 'package:pharmdel_business/ui/driver_user_type/StreamSocket.dart';
import 'package:pharmdel_business/ui/privacy_policy_screen.dart';
import 'package:pharmdel_business/ui/splash_screen.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:pharmdel_business/util/sentryExeptionHendler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'CONTROLLERS/ProjectController/VirController/vir_controller.dart';
import 'DB/MyDatabase.dart';
import 'data/api_call_fram.dart';
import 'data/web_constent.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

// class LocationHandler{
//   Future<void> getUseLatLong(Function(LocationData) callback) async {
//
//     Location location = new Location();
//
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     LocationData _locationData;
//
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _locationData = await location.getLocation();
//     callback.call(_locationData);
//
//   }
//
// }

StreamSocket streamSocket = StreamSocket();
int deliveryTime;
StopWatchTimer stopWatchTimer;
bool UserOnBreak = false;
Logger logger = Logger();

// int remainingTIme;
IO.Socket socket = IO.io(WebConstant.SOCKET_URL, OptionBuilder().setTransports(['websocket']).build());

void connectAndListen() {
  try {
    socket.onConnect((_) async {
      logger.i('connected');

      // socket.emit('sendChatToServer', 'test');

      var value = await SharedPreferences.getInstance();
      String driverId = value.getString(WebConstant.USER_ID);
      String routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
      bool isLogin = value.getBool(WebConstant.IS_LOGIN) != null ? value.getBool(WebConstant.IS_LOGIN) : false;
      bool isRouteStart = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      String deviceId = value.getString(WebConstant.DEVICE_ID) ?? "";
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      var token = await MyDatabase().getToken();
      logger.w("isLogin $isLogin");
      logger.w("isRouteStart $isRouteStart");
      if (isRouteStart && isLogin) {
        Map<String, String> library = {
          "driver_id": driverId,
          "route_id": routeId,
          "online_status": "online",
          "device_id": deviceId,
          "offline_order_status": "${completeAllList.isNotEmpty ? "not_available" : "available"}",
          "sorting_started": "false",
          "device_name": "android",
          "state": "reorder_check",
          "token": token != null && token.isNotEmpty ? token.first.token.toString() : ""
        };
        logger.i(jsonEncode(library));
        socket.emit('sendChatToServer', jsonEncode(library));
      }
    });

    //When an event recieved from server, data is added to the stream
    socket.on('sendChatToClient', (data) {
      streamSocket.addResponse(data);
      streamSocket.addResponseOutForDelivery(data);
    });
    socket.onDisconnect((_) {
      logger.e('disconnect');
    });
    socket.onConnectError((data) {
      logger.e(data);
    });
    socket.onConnect((data) {
      logger.w('2nd onConnect');
      logger.i(data);
    });
    // socket.connect();
  } catch (ex, stackTrace) {
    SentryExemption.sentryExemption(ex, stackTrace);
    logger.e(ex);
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // await initializeService();
  connectAndListen();
  // await SentryFlutter.init(
  //       (options) => options.dsn = WebConstant.SENTRY_KEY,
  //   appRunner: () => runApp(MultiProvider(
  //       providers: providers,
  //       child: MaterialApp(
  //           debugShowCheckedModeBanner: false,
  //           home: MyApp()))),
  // );
  runApp(MultiProvider(providers: providers, child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())));

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    AppleNotification iOS = message.notification?.apple;
    if (Platform.isAndroid) {
      if (notification != null && android != null && !kIsWeb) {
        FlutterRingtonePlayer.playNotification();

        showOverlayNotification(
          (context) {
            // logger.i("onLaunch1: $message");
            // logger.i("title : ${notification.title}");
            // logger.i("body : ${notification.body}");
            return Dismissible(
              onDismissed: (direction) {
                OverlaySupportEntry.of(context).dismiss(animate: false);
              },
              direction: DismissDirection.horizontal,
              key: Key(getRandomString(10)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: SafeArea(
                  child: Card(
                    color: Color(0xff17a2b8),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 25),
                    child: ListTile(
                      minVerticalPadding: 0.0,
                      visualDensity: VisualDensity(vertical: -2, horizontal: -4),
                      leading: Container(
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: Colors.orange[600],
                        ),
                      ),
                      title: Text(
                        notification.title ?? "Notification",
                        maxLines: 5,
                        style: TextStyle(color: Colors.white),
                      ),
                      horizontalTitleGap: 25.0,
                      subtitle: Text(
                        notification.body ?? "",
                        maxLines: 5,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            OverlaySupportEntry.of(context).dismiss();
                          }),
                    ),
                  ),
                ),
              ),
            );
          },
          duration: Duration(hours: 12),
        );
      }
    } else {
      if (notification != null && iOS != null && !kIsWeb) {
        FlutterRingtonePlayer.playNotification();

        showOverlayNotification((context) {
          // logger.i("onLaunch1: $message");
          // logger.i("title : ${notification.title}");
          // logger.i("body : ${notification.body}");
          return Dismissible(
            onDismissed: (direction) {
              OverlaySupportEntry.of(context).dismiss(animate: false);
            },
            direction: DismissDirection.up,
            key: Key(getRandomString(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SafeArea(
                child: Card(
                  color: Color(0xff17a2b8),
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 25),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      minVerticalPadding: 0.0,
                      visualDensity: VisualDensity(vertical: -2, horizontal: -4),
                      horizontalTitleGap: 25.0,
                      leading: Container(
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: Colors.orange[600],
                        ),
                      ),
                      title: Text(
                        notification.title ?? "Notification",
                        maxLines: 5,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        notification.body ?? "",
                        maxLines: 5,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            OverlaySupportEntry.of(context).dismiss();
                          }),
                    ),
                  ),
                ),
              ),
            ),
          );
        }, duration: Duration(hours: 12));
      }
    }
  });

  if (!kIsWeb) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,
//
//       // this will executed when app is in foreground in separated isolate
//       onForeground: onStart,
//
//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
// }

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
// void onIosBackground() {
//   WidgetsFlutterBinding.ensureInitialized();
//   logger.i('FLUTTER BACKGROUND FETCH');
// }
bool isUploading = false;
// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // if (Platform.isIOS) FlutterBackgroundServiceIOS.registerWith();
//   // if (Platform.isAndroid) FlutterBackgroundServiceAndroid.registerWith();
//
//   final service = FlutterBackgroundService();
//   service.onDataReceived.listen((event) {
//     if (event["action"] == "tokenChangd") {
//       logger.i('For Ground Service');
//       // service.setAsForegroundService();
//       return;
//     }
//
//     if (event["action"] == "setAsBackground") {
//       logger.i('FLUTTER BACKGROUND Service');
//       service.setAsBackgroundService();
//     }
//
//     if (event["action"] == "stopService") {
//       logger.i('FLUTTER BACKGROUND StopService');
//       service.stopService();
//     }
//     logger.i('Background Service');
//   });
//
//
//   // bring to foreground
//   // service.setAsForegroundService();
//   Timer.periodic(const Duration(seconds: 10), (timer) async {
//     if (!(await service.isRunning())) timer.cancel();
//     logger.i('timer services');
//     bool checkInternet = await ConnectionValidator().check();
//     if (checkInternet ) {
//       logger.i("Internet Available ");
//       // await updateLocation();
//     }else{
//       logger.i("Internet Not Available ");
//     }
//   });
// }
// Location location;
// bool _serviceEnabled;
// List<LocationData> locationArray;
// DateTime lastLocationUpdated;
// Map<String, Object> prams;
// String driverId, routeId;
// getCurrentLocation() async {
//   bool checkInternet = await ConnectionValidator().check();
//   if (!checkInternet) {
//     // Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
//     return;
//   }
//   await SharedPreferences.getInstance().then((value){
//         driverId = value.getString(WebConstant.USER_ID);
//         routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
//       });
//  currentPosition = Geolocator
//       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true);
//  await currentPosition.then((value){
//    if(value != null){
//      prams = {
//        'driverId': "$driverId",
//        'routeId': "$routeId",
//        'latitude': value.latitude,
//        'longitude': value.longitude,
//      };
//      saveSocketData(prams);
//    }
//  });
// }
//  updateLocation(context) async{
//    bool checkInternet = await ConnectionValidator().check();
//    if (!checkInternet) {
//      // Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
//      return;
//    }
//    await SharedPreferences.getInstance().then((value){
//      driverId = value.getString(WebConstant.USER_ID);
//      routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
//    });
//    bool isPermission = false;
//
//    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
//      if (value) {
//        if (location == null) location = Location();
//        _serviceEnabled = await location.serviceEnabled();
//        if (!_serviceEnabled) {
//          _serviceEnabled = await location.requestService();
//          if (!_serviceEnabled) {
//            return;
//          }
//        }
//
//        if (location == null) location = Location();
//        location.changeSettings(
//            distanceFilter: 10, accuracy: LocationAccuracy.high);
//        location.onLocationChanged.listen((LocationData currentLocation) {
//          // Fluttertoast.showToast(msg: "Location Update2");
//          if (locationArray.length > 0) {
//            int tempDriverId = int.parse(driverId);
//            int tempRouteId = int.parse(routeId);
//            prams = {
//              "driverId": "$tempDriverId",
//              "routeId": "$tempRouteId",
//            };
//              if (lastLocationUpdated.isBefore(DateTime.now())) {
//                lastLocationUpdated = DateTime(
//                    DateTime
//                        .now()
//                        .year,
//                    DateTime
//                        .now()
//                        .month,
//                    DateTime
//                        .now()
//                        .day,
//                    DateTime
//                        .now()
//                        .hour,
//                    DateTime
//                        .now()
//                        .minute,
//                    DateTime
//                        .now()
//                        .second + 30);
//                // print(lastLocationUpdated);
//                prams["latitude"] = "${currentLocation.latitude}";
//                prams["longitude"] = "${currentLocation.longitude}";
//                // logger.i("test $prams");
//                logger.i("testttttt1234");
//                // if (routeId != "0" && isRouteStart)
//                  saveSocketData(prams);
//              }
//              //channel.sink.add("$prams");
//          }
//          locationArray.add(currentLocation);
//          if (locationArray.length > 5) locationArray.removeAt(0);
//        });
//      }
//    });
//  }
// Future<void> saveSocketData(Map<String, dynamic> prams1) async {
//   String accessToken = "";
//   await SharedPreferences.getInstance().then((value){
//     accessToken = value.getString(WebConstant.ACCESS_TOKEN);
//   });
//   ApiCallFram _apiCallFram = ApiCallFram();
//   _apiCallFram
//       .postDataAPI(
//       WebConstant.SAVE_DATA_WITH_SOCKET, accessToken, prams1, null)
//       .then((response) {
//     try {
//       // Fluttertoast.showToast(msg: "Update");
//       if (response != null) {
//         logger.i("${response.body}");
//          // Map<String, Object> data = json.decode(response.body);
//         // Fluttertoast.showToast(msg: data["message"]);
//       }
//     } catch (e,stackTrace) {
//       logger.i("Exception : $e");
//       SentryExemption.sentryExemption(e, stackTrace);
//     }
//   }, onError: (error, stackTrace) {
//
//   });
// }

Future<void> updateSignature() async {
  String accessToken = "";
  // logger.w("accessToken : $accessToken");

  MyDatabase().getAllOrderCompleteData().then((value) async {
    //update signature value was hide by me dk
    // logger.w("updateSignature value : $value");
    if (value != null && value.isNotEmpty) {
      await Future.forEach(value, (element) async {
        var tokenList = await MyDatabase().getToken();
        if (tokenList != null && tokenList.isNotEmpty) {
          accessToken = tokenList.last.token;
        }
        if (tokenList != null && tokenList.isNotEmpty) {
          ApiCallFram _apiCallFram = ApiCallFram();
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
          logger.w(WebConstant.DELIVERY_SIGNATURE_UPLOAD_URL);
          logger.i(prams);
          await _apiCallFram
              .postFormBackgroundDataAPI(WebConstant.DELIVERY_SIGNATURE_UPLOAD_URL, accessToken, prams)
              .then((response) async {
            try {
              if (response != null) {
                logger.w(response.body);
                if (response.body == "Unauthenticated") {
                  await clearTokenTable();
                  if (value.last == element) {
                    isUploading = false;
                  }
                } else {
                  var data = json.decode(response.body);
                  if (data["status"] == true || data["status"] == 'true') {
                    // var list = await MyDatabase().getAllOrderCompleteData();
                    await MyDatabase().delecteCompletedDeliveryById(element);
                    // list = await  MyDatabase().getAllOrderCompleteData();
                    // logger.i(list.length);
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
        } else {
          if (value.last == element) {
            isUploading = false;
          }
        }
      });
    } else {
      isUploading = false;
    }
  });
}

Future<int> clearTokenTable() async {
  await MyDatabase().deleteToken();
  return Future.value(1);
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<GetMedicineProvider>(create: (_) => GetMedicineProvider()),
  ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
  ChangeNotifierProvider<FetchCustomerData>(create: (_) => FetchCustomerData()),
  ChangeNotifierProvider<RepeatPrescriptionImageProvider>(create: (_) => RepeatPrescriptionImageProvider()),
  ChangeNotifierProvider<VirController>(create: (_) => VirController()),
];
var isDelivery = false;

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) =>
    String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

void globalForegroundService() {
  // debugPrint("current datetime is ${DateTime.now()}");
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer timer1;

  bool showAlertDailogForDeriver = false;

  ///final NotificationService _ns = NotificationService();
  //NotificationService.instance.myVarFunc();
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
        var value = await SharedPreferences.getInstance();
        String driverId = value.getString(WebConstant.USER_ID);
        String routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
        bool isRouteStart = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
        var completeAllList = await MyDatabase().getAllOrderCompleteData();
        var token = await MyDatabase().getToken();
        if (event != null) {
          Map valueMap = json.decode(event);
          // logger.i("response getting: $valueMap");
          value.setString(WebConstant.DEVICE_ID, valueMap["device_id"] ?? "");
          if (valueMap["driver_id"] == driverId && valueMap["device_name"] == "admin") {
            if (valueMap["state"] == "driver_check" && isRouteStart) {
              Map<String, String> library = {
                "driver_id": driverId,
                "route_id": routeId,
                "device_id": valueMap["device_id"],
                "online_status": "online",
                "offline_order_status": "${completeAllList.isEmpty ? "not_available" : "available"}",
                // offline order available
                "sorting_started": "false",
                "device_name": "android",
                "state": "driver_check",
                "token": token.first.token.toString()
              };
              logger.i(jsonEncode(library));
              socket.emit('sendChatToServer', jsonEncode(library));
            } else if (valueMap["state"] == "reDriver_check" && isRouteStart) {
              Map<String, String> library = {
                "driver_id": driverId,
                "route_id": routeId,
                "online_status": "online",
                "device_id": valueMap["device_id"],
                "offline_order_status": "${completeAllList.isEmpty ? "not_available" : "available"}",
                // offline order available
                "sorting_started": "false",
                "device_name": "android",
                "state": "reDriver_check",
                "token": token.first.token.toString()
              };
              logger.i(jsonEncode(library));
              socket.emit('sendChatToServer', jsonEncode(library));
            } else if (valueMap["state"] == "reorder_check" && isRouteStart) {
              if (valueMap["sorting_started"]) {
                if (!showAlertDailogForDeriver) {
                  showAlertDailogForDeriver = true;
                  reArrangingRoutePopup(valueMap["message"]);
                }
              } else {
                if (showAlertDailogForDeriver) {
                  Navigator.pop(context);
                  showAlertDailogForDeriver = false;
                }
              }
            }
          }
        }
      });
    }
    dialogDissmissTimer();
  }

  Future<void> dialogDissmissTimer() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      timer1 = timer;
      logger.i('Dashboard Background Service');
      var value = await SharedPreferences.getInstance();
      String driverId = value.getString(WebConstant.USER_ID);
      String routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
      String deviceId = value.getString(WebConstant.DEVICE_ID) ?? "";
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      var token = await MyDatabase().getToken();
      if (completeAllList == null || completeAllList.isEmpty) {
        timer1.cancel();
        Map<String, String> library = {
          "driver_id": driverId,
          "route_id": routeId,
          "online_status": "online",
          "device_id": deviceId,
          "offline_order_status": "${completeAllList.isEmpty ? "not_available" : "available"}",
          // offline order available
          "sorting_started": "false",
          "device_name": "android",
          "state": "order_check",
          "token": token != null && token.isNotEmpty ? token.first.token.toString() : ""
        };
        logger.i("dialogDissmissTimer: ${jsonEncode(library)}");
        socket.emit('sendChatToServer', jsonEncode(library));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // fcmService.initialise();
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Pharmdel Business',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Nunito',
        ),
        // home: DropPin(),
        home: SplashScreen(),
        // routes: routes,
      ),
    );
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
              insetPadding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image(
                      image: new AssetImage("assets/processing.gif"),
                    ),
                    Text(
                      "Processing...",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.red),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      message ?? "",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    InkWell(
                      onTap: () async {
                        bool checkInternet = await ConnectionValidator().check();
                        if (!checkInternet) {
                          Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
                          return;
                        }
                        if (socket.disconnected) {
                          if (showAlertDailogForDeriver) {
                            Navigator.pop(context);
                            showAlertDailogForDeriver = false;
                          }
                        } else {
                          var value = await SharedPreferences.getInstance();
                          String driverId = value.getString(WebConstant.USER_ID);
                          String routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
                          String deviceId = value.getString(WebConstant.DEVICE_ID) ?? "";
                          var completeAllList = await MyDatabase().getAllOrderCompleteData();
                          var token = await MyDatabase().getToken();
                          Map<String, String> library = {
                            "driver_id": driverId,
                            "route_id": routeId,
                            "online_status": "online",
                            "device_id": deviceId,
                            "offline_order_status": "${completeAllList.isNotEmpty ? "not_available" : "available"}",
                            "sorting_started": "false",
                            "device_name": "android",
                            "state": "reorder_check",
                            "token": token != null && token.isNotEmpty ? token.first.token.toString() : ""
                          };
                          logger.i(jsonEncode(library));
                          socket.emit('sendChatToServer', jsonEncode(library));
                        }
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300], blurRadius: 5.0, spreadRadius: 3.0, offset: Offset(0, 3))
                            ],
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Center(child: Text(WebConstant.Check_Again, style: TextStyle(color: Colors.white))),
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
    // print(
    //     "..................................................111$state........................");
    switch (state) {
      case AppLifecycleState.resumed:
        logger.i("app in resumed");
        // if(timer1 != null && !timer1.isActive)
        //   timer1.();
        break;
      case AppLifecycleState.inactive:
        logger.w("app in inactive");
        break;
      case AppLifecycleState.paused:
        logger.w("apppp in paused");
        if (timer1 != null && timer1.isActive) timer1.cancel();
        break;
      case AppLifecycleState.detached:
        logger.e("app in detached");
        break;
    }
  }
}

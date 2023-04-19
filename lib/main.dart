import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'Controller/ApiController/WebConstant.dart';
import 'Controller/Firebase/FirebaseMessaging/FirebaseMessaging.dart';
import 'Controller/Helper/Dimensions/Dimensions.dart';
import 'Controller/Helper/PrintLog/PrintLog.dart';
import 'Controller/Helper/Shared Preferences/SharedPreferences.dart';
import 'Controller/ProjectController/MainController/main_controller.dart';
import 'Controller/SoketController/socket_ctrl.dart';




String authToken = "";
String userID = "";
String driverType = "";

bool isTimeCheckDialogBox = false;


StreamController<int> msgController = StreamController<int>.broadcast();
SocketController socketCtrl = Get.put(SocketController());

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
    await Firebase.initializeApp();
    await FirebaseMessagingCustom.setUpNotification();
    await FirebaseMessagingCustom.getInstance();

    /// Socket
    HttpOverrides.global = MyHttpOverrides();
    socketCtrl.connectAndListen();

    runApp(
        const MyApp()
    );
  }, (error, stackTrace) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    FirebaseMessaging.onMessage.listen((event) {
      PrintLog.printLog("event1: ${event.messageId}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      PrintLog.printLog("event2: ${event.messageId}");
    });
  });

  await AppSharedPreferences.getInstance().then((value) => {
    authToken = value?.getString(AppSharedPreferences.authToken) ?? "",
    userID = value?.getString(AppSharedPreferences.userId) ?? "",
    driverType = value?.getString(AppSharedPreferences.driverType) ?? "",
    PrintLog.printLog("Auth Token is: $authToken\nUser ID is: $userID\nDriver Type is: $driverType\nFcm Token is: ${value?.getString(AppSharedPreferences.fcmToken) ?? ""}"),
  });
}



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}




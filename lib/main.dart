import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'Controller/ApiController/WebConstant.dart';
import 'Controller/Firebase/FirebaseMessaging/FirebaseMessaging.dart';
import 'Controller/Helper/Dimensions/Dimensions.dart';
import 'Controller/Helper/PrintLog/PrintLog.dart';
import 'Controller/Helper/Shared Preferences/SharedPreferences.dart';
import 'Controller/ProjectController/MainController/main_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Controller/SoketController/socket_controller.dart';


String authToken = "";
String userID = "";

StreamController<int> msgController = StreamController<int>.broadcast();
double addHeight = Dimensions.screenHeight;
double addWidth = Dimensions.screenWidth;

// int remainingTIme;
IO.Socket socket = IO.io(WebApiConstant.SOCKET_URL, OptionBuilder().setTransports(['websocket']).build());
StreamSocket streamSocket = StreamSocket();


Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
    await Firebase.initializeApp();
    await FirebaseMessagingCustom.setUpNotification();
    await FirebaseMessagingCustom.getInstance();
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
    PrintLog.printLog("Auth Token is: $authToken\nUser ID is: $userID\nFcm Token is: ${value?.getString(AppSharedPreferences.fcmToken) ?? ""}"),
  });
}





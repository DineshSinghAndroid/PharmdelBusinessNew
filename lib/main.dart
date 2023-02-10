import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Controller/Firebase/FirebaseMessaging/FirebaseMessaging.dart';
import 'Controller/Helper/PrintLog/PrintLog.dart';
import 'Controller/Helper/Shared Preferences/SharedPreferences.dart';
import 'Controller/ProjectController/MainController/main_controller.dart';



String authToken = "";
StreamController<int> msgController = StreamController<int>.broadcast();


Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
    // await Firebase.initializeApp();
    // await FirebaseMessagingCustom.setUpNotification();
    // await FirebaseMessagingCustom.getInstance();
    runApp(
        const MyApp()
    );
  }, (error, stackTrace) {
    // // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // FirebaseMessaging.onMessage.listen((event) {
    //   PrintLog.printLog("event1: ${event.messageId}");
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   PrintLog.printLog("event2: ${event.messageId}");
    // });
  });

  await AppSharedPreferences.getInstance().then((value) => {
    authToken = value?.getString(AppSharedPreferences.authToken) ?? "",
    PrintLog.printLog("Auth Token is: $authToken"),
    PrintLog.printLog("Fcm Token is: ${value?.getString(AppSharedPreferences.fcmToken) ?? ""}")
  });
}





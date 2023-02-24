

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../main.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import 'FirebaseMessaging.dart';



// msgController
class FirebaseMessagingCustom {
  static FirebaseMessaging? _instance;

  ///Mark - Notification
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', //id
      'High Importance Notifications', //title
      importance: Importance.high,
      playSound: true
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



  static Future<FirebaseMessaging?> getInstance() async {
    if (_instance == null) {
      // await setUpNotification();
      _instance = FirebaseMessaging.instance;
      PrintLog.printLog("FirebaseMessaging init success:::::::");
      return _instance;
    }
    return _instance;
  }

  static Future<String?> getToken() async {
    return await _instance?.getToken();
  }
  static Future<String?> getApnsToken() async {
    return await _instance?.getAPNSToken();
  }

  static Future<bool?> isTest() async {
    return  await _instance?.isSupported();
  }

  static Future<void> setUpNotification()async{
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> notificationFuncCall({required BuildContext context})async{

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// Request Permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      PrintLog.printLog('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      PrintLog.printLog('User granted provisional permission');
    } else {
      PrintLog.printLog('User declined or has not accepted permission');
    }


    if(Platform.isIOS){
      PrintLog.printLog("Platform Apple");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AppleNotification? apple = message.notification?.apple;
        PrintLog.printLog("tes...Notification");

        if(notification != null && apple != null){
          PrintLog.printLog("Notification value added in ctr....ios");
          msgController.add(1);
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                iOS: DarwinNotificationDetails(
                    presentAlert: true,
                    // sound: true,
                    subtitle: notification.title,
                    // badgeNumber: 1,
                    // presentBadge: true,
                    presentSound: true
                ),
              )
          );
        }
      });


      /// On Background :::
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        PrintLog.printLog("A new omMessageOpenedApp event was published!");
        RemoteNotification? notification = message.notification;
        RemoteMessage? messageData = message;
        AndroidNotification android = message.notification!.android!;
        if(notification != null && android != null){
          routeNavigate(context: context,routeValue: int.parse(messageData.data["route_id"].toString()));
        }
      });

    }else if(Platform.isAndroid){
      PrintLog.printLog("Notification......Platform Android");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PrintLog.printLog("A new onMessage event was published!");

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if(notification != null && android != null){
          PrintLog.printLog("Notification value added in ctr....android");
          msgController.add(1);

          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      // channel.description,
                      color: Colors.transparent,
                      playSound: true,
                      icon: "@mipmap/ic_launcher"
                  )
              )
          );
        }
      });

      /// On Background :::
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        PrintLog.printLog("A new omMessageOpenedApp event was published!");
        RemoteNotification? notification = message.notification;
        RemoteMessage messageData = message;
        AndroidNotification? android = message.notification?.android;
        if(notification != null && android != null){
          routeNavigate(context: context,routeValue: int.parse(messageData.data["route_id"].toString()));
        }
      });
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async{
    if(message.messageId != null) {
      msgController.add(1);
      PrintLog.printLog("Notification value added in ctr....Background");
    }
  }

  static Future routeNavigate({required BuildContext context,required int routeValue})async{
    PrintLog.printLog("Route Navigation Call....");
    /// on_apple=4, on_pricing=3, on_newActivity=1, on_notification=2
    if(routeValue == 1){
      // Navigator.pushReplacementNamed(context, dashboardScreenRoute);
    }else if(routeValue == 2){
      // Navigator.pushNamed(context, notificationScreenRoute);
    }else if(routeValue == 3){
      // Navigator.pushNamed(context, pricingScreenRoute);
    }else if(routeValue == 4){
      // Navigator.pushNamed(context, myApplesNowScreenRoute);
    }
  }



}
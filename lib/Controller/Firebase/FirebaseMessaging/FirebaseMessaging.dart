import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../../main.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../ProjectController/MainController/main_controller.dart';
import 'FirebaseMessaging.dart';



// msgController
class FirebaseMessagingCustom {
  static FirebaseMessaging? _instance;
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();
  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


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
          FlutterRingtonePlayer.playNotification();
          PrintLog.printLog("Notification value added in ctr....ios");
          msgController.add(1);
          showOverlayNotification((context) {
            // logger.i("onLaunch1: $message");
            // logger.i("title : ${notification.title}");
            // logger.i("body : ${notification.body}");
            return Dismissible(
              onDismissed: (direction) {
                OverlaySupportEntry.of(context)?.dismiss(animate: false);
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
                        visualDensity: const VisualDensity(vertical: -2, horizontal: -4),
                        horizontalTitleGap: 25.0,
                        leading: Container(
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.notifications,
                            size: 30,
                            color: Colors.orange[600],
                          ),
                        ),
                        title: Text(
                          notification.title ?? "Notification",
                          maxLines: 5,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          notification.body ?? "",
                          maxLines: 5,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              OverlaySupportEntry.of(context)?.dismiss();
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }, duration: Duration(hours: 12));
          // flutterLocalNotificationsPlugin.show(
          //     notification.hashCode,
          //     notification.title,
          //     notification.body,
          //     NotificationDetails(
          //       iOS: DarwinNotificationDetails(
          //           presentAlert: true,
          //           // sound: true,
          //           subtitle: notification.title,
          //           // badgeNumber: 1,
          //           // presentBadge: true,
          //           presentSound: true
          //       ),
          //     )
          // );
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
          FlutterRingtonePlayer.playNotification();

          showOverlayNotification(
                (context) {
              // logger.i("onLaunch1: $message");
              // logger.i("title : ${notification.title}");
              // logger.i("body : ${notification.body}");
              return Dismissible(
                onDismissed: (direction) {
                  OverlaySupportEntry.of(context)?.dismiss(animate: false);
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
                              OverlaySupportEntry.of(context)?.dismiss();
                            }),
                      ),
                    ),
                  ),
                ),
              );
            },
            duration: const Duration(hours: 12),
          );
          // flutterLocalNotificationsPlugin.show(
          //     notification.hashCode,
          //     notification.title,
          //     notification.body,
          //     NotificationDetails(
          //         android: AndroidNotificationDetails(
          //             channel.id,
          //             channel.name,
          //             // channel.description,
          //             color: Colors.transparent,
          //             playSound: true,
          //             icon: "@mipmap/ic_launcher"
          //         )
          //     )
          // );
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
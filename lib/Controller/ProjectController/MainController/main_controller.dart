import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:sizer/sizer.dart';
import '../../RouteController/Route.dart'as router;
import '../../SoketController/socket_ctrl.dart';


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  SocketController socketCtrl = Get.put(SocketController());


  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init()async{
    if (socketCtrl.streamSocket.getResponse != null) {
      socketCtrl.streamSocket.getResponse.listen((event) async {
        socketCtrl.sendChatToServer(event: event);
      });
    }
  }


  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {

    switch (state) {
      case AppLifecycleState.resumed:
        PrintLog.printLog("Main App Lifecycle State::::::::: Resumed");
        break;
      case AppLifecycleState.inactive:
        PrintLog.printLog("Main App Lifecycle State::::::::: InActive");
        break;
      case AppLifecycleState.paused:
        PrintLog.printLog("Main App Lifecycle State::::::::: Paused");
        // if (timer1 != null && timer1.isActive) timer1.cancel();
        break;
      case AppLifecycleState.detached:
        PrintLog.printLog("Main App Lifecycle State::::::::: Detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Sizer(
      builder: (context, orientation, deviceType) {
        return const OverlaySupport.global(
            child: GetMaterialApp(
            initialRoute: splashScreenRoute,
              // home: PharmacyHomeScreen(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: router.generateRoute,
             title: "Pharmdel Business",
          )
        );
      },
    );
  }

}



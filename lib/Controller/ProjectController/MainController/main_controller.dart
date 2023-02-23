import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pharmdel/View/OnBoarding/Login/login_screen.dart';
import 'package:sizer/sizer.dart';
import '../../RouteController/Route.dart'as router;
import '../../RouteController/RouteNames.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Sizer(
      builder: (context, orientation, deviceType) {
        return const GetMaterialApp(
          initialRoute: splashScreenRoute,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router.generateRoute,
          // initialRoute: splashScreenRoute,          
          title: "Pharmdel Business",
        );
      },
    );
  }
}

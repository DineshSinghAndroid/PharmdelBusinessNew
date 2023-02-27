import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pharmdel/View/OnBoarding/Login/login_screen.dart';
import 'package:sizer/sizer.dart';
import '../../../PHARMACY/P_Views/P_Home/Pharmacy_home_age.dart';
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
          // home: PharmacyHomeScreen(),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router.generateRoute,
           title: "Pharmdel Business",
        );
      },
    );
  }
}

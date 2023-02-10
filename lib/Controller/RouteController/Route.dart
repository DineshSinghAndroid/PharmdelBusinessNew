import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../View/Splash/splash_screen.dart';
import 'RouteNames.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case splashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());

    // case introScreenRoute:
    //   return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const IntroScreen());


    // case dashboardScreenRoute:
    //   final args = settings.arguments as DashboardScreen;
    //   return PageTransition(type: PageTransitionType.bottomToTop,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: DashboardScreen(screenIndex: args.screenIndex,));


    default:
      return MaterialPageRoute(builder: (context) => SplashScreen());
  }
}

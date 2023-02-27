import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmdel/PHARMACY/P_Views/P_Home/HomePage.dart';
import 'package:pharmdel/View/DashBoard/HomeScreen/homeScreen.dart';
import 'package:pharmdel/View/HowToOperate.dart/PdfScreen.dart';
import 'package:pharmdel/View/LunchBreak/lunchBreakScreen.dart';
import 'package:pharmdel/View/OnBoarding/Login/login_screen.dart';
import 'package:pharmdel/View/OnBoarding/SetupPin/setupPin.dart';
import 'package:pharmdel/View/OnBoarding/Splash/splash_screen.dart';
import 'package:pharmdel/View/UpdateAddressScreen.dart/updateAddressScreen.dart';

import '../../View/CreatePatientScreen.dart/createPatientScreen.dart';
import '../../View/CustomerListScreem.dart/customerlist.dart';
import '../../View/NotificationScreen/notificationScreen.dart';
import 'RouteNames.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case splashScreenRoute: return MaterialPageRoute(builder: (context) => const SplashScreen());
    case loginScreenRoute: return MaterialPageRoute(builder: (context) => const LoginScreen());
    case setupPinScreenRoute: return MaterialPageRoute(builder: (context) =>  const SetupPinScreen(isChangePassword: false,));

  // case securePinScreenRoute:
  //     return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  SecurePin());


  case homeScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const HomeScreen());

  case customerListScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  CustomerListScreen());    

  case notificationScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const NotificatinScreen());        


  case createPatientScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const CreatePatientScreen());        


  case updateAddressScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const UpdateAddressScreen());        


  case pdfViewScreenRoute:
  final args = settings.arguments as PdfViewScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:   PdfViewScreen(pdfUrl: args.pdfUrl,));        


  case lunchBreakScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const LunchBreakScreen());    
    // case introScreenRoute:
    //   return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const IntroScreen());









      //Pharmacy
    case pharmacyHomePage:
       return PageTransition(type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center, child:   PharmacyHomeScreen( ));


    default:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}

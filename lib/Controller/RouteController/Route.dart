import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmdel/View/DashBoard/HomeScreen/homeScreen.dart';
import 'package:pharmdel/View/HowToOperate.dart/PdfScreen.dart';
import 'package:pharmdel/View/LunchBreak/lunchBreakScreen.dart';
import 'package:pharmdel/View/OnBoarding/Login/login_screen.dart';
import 'package:pharmdel/View/OnBoarding/SetupPin/setupPin.dart';
import 'package:pharmdel/View/OnBoarding/Splash/splash_screen.dart';
import 'package:pharmdel/View/ScanPrescription/scan_prescription.dart';
import 'package:pharmdel/View/SearchPatient/search_patient.dart';
import 'package:pharmdel/View/UpdateAddressScreen.dart/updateAddressScreen.dart';

import '../../PHARMACY/P_Views/P_Home/Pharmacy_home_age.dart';
import '../../View/CreatePatientScreen.dart/createPatientScreen.dart';
import '../../View/CustomerListScreem.dart/customerlist.dart';
import '../../View/MapScreen/map_screen.dart';
import '../../View/NotificationScreen/notificationScreen.dart';
import '../../View/OnBoarding/EnterPin/securePin.dart';
import 'RouteNames.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreenRoute:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    case loginScreenRoute:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case securePinScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: SecurePin());

    case homeScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const HomeScreen());

    case customerListScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: CustomerListScreen());

    case notificationScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const NotificatinScreen());

    case createPatientScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300),
          alignment: Alignment.center, child: const CreatePatientScreen());

    case updateAddressScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const UpdateAddressScreen());

    case pdfViewScreenRoute:
      final args = settings.arguments as PdfViewScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300),alignment: Alignment.center,child: PdfViewScreen(pdfUrl: args.pdfUrl));



    case setupPinScreenRoute:
      final args = settings.arguments;
      print(settings.arguments.toString());
      return MaterialPageRoute(
          builder: (context) => SetupPinScreen(
                isChangePin: args.toString(),
              ));

      case lunchBreakScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const LunchBreakScreen());
   case lunchBreakScreenRoute:
   case lunchBreakScreenRoute:
       return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const LunchBreakScreen());


  case scanPrescriptionScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const ScanPrescriptionScreen());


  case mapScreenRoute:
  final args = settings.arguments as MapScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  MapScreen(driverId: args.driverId, routeId: args.routeId));


  case searchPatientScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const SearchPatientScreen());            
      // case introScreenRoute:
     // case introScreenRoute:
     //   return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const IntroScreen());

    //Pharmacy
    case pharmacyHomePage:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: PharmacyHomeScreen());

    default:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}

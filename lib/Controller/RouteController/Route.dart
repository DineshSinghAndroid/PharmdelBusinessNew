import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmdel/PHARMACY/P_Views/P_DeliveryScheduleManual/p_delivery_schedule_manual.dart';
import 'package:pharmdel/PHARMACY/P_Views/P_DisplayMapRoutes/p_display_map_routes_screen.dart';
import 'package:pharmdel/PHARMACY/P_Views/P_Notification/pharmacy_notification_screen.dart';
import 'package:pharmdel/PHARMACY/P_Views/P_NursingHome/p_nursing_home_screen.dart';
import 'package:pharmdel/PHARMACY/P_Views/p_CreateNotification/p_create_notification_screen.dart';
import 'package:pharmdel/View/HowToOperate.dart/PdfScreen.dart';
import 'package:pharmdel/View/LunchBreak/lunchBreakScreen.dart';
import 'package:pharmdel/View/OnBoarding/Login/login_screen.dart';
import 'package:pharmdel/View/OnBoarding/SetupPin/setupPin.dart';
import 'package:pharmdel/View/OnBoarding/Splash/splash_screen.dart';
import 'package:pharmdel/View/ScanPrescription/scan_prescription.dart';
import 'package:pharmdel/View/SearchPatient/search_patient.dart';
import 'package:pharmdel/View/UpdateAddressScreen.dart/updateAddressScreen.dart';
import '../../PHARMACY/P_Views/P_Home/Pharmacy_home_page.dart';
import '../../PHARMACY/P_Views/P_TrackOrder/pharmacy_track_order_screen.dart';
import '../../PHARMACY/P_Views/p_DeliveryList/p_deliverylist_screen.dart';
import '../../PHARMACY/P_Views/p_SearchMedicine/p_search_medicine_screen.dart';
import '../../View/CreatePatientScreen.dart/createPatientScreen.dart';
import '../../View/CustomerListScreem.dart/customerlist.dart';
import '../../View/DashBoard/DriverDashboard/driver_dashboard_screen.dart';
import '../../View/DashBoard/DriverDashboard/show_order_list_screen.dart';
import '../../View/MapScreen/map_screen.dart';
import '../../View/NotificationScreen/notificationScreen.dart';
import '../../View/OnBoarding/EnterPin/securePin.dart';
import '../../View/UpdateStatusScreen/updatestatus_screen.dart';
import 'RouteNames.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreenRoute:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    case loginScreenRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());


    case securePinScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: SecurePin());

    case driverDashboardScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const DriverDashboardScreen());

    case customerListScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: CustomerListScreen());

    case notificationScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const NotificatinScreen());

    case createPatientScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300),
          alignment: Alignment.center, child: const CreatePatientScreen());

    case updateAddressScreenRoute:
    final args = settings.arguments as UpdateAddressScreen;
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  UpdateAddressScreen(address1: args.address1,address2: args.address2,postCode: args.postCode,townName: args.townName,));

    case pdfViewScreenRoute:
      final args = settings.arguments as PdfViewScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300),alignment: Alignment.center,child: PdfViewScreen(pdfUrl: args.pdfUrl));


    case updateStatusScreenRoute:      
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300),alignment: Alignment.center,child: const UpdateStatusScreen());  


     case pharmacyNotificationScreenRoute:      
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300),alignment: Alignment.center,child: const PharmacyNotificationScreen());    



    case setupPinScreenRoute:
      final args = settings.arguments as SetupPinScreen;
      return MaterialPageRoute( builder: (context) => SetupPinScreen( isChangePin: args.isChangePin));

      case lunchBreakScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const LunchBreakScreen());


  case scanPrescriptionScreenRoute:
  final args = settings.arguments as ScanPrescriptionScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: ScanPrescriptionScreen(bulkScanDate: args.bulkScanDate,driverId: args.driverId,isAssignSelf: args.isAssignSelf,isBulkScan: args.isBulkScan,isRouteStart: args.isRouteStart,nursingHomeId: args.nursingHomeId,parcelBoxId: args.parcelBoxId,pharmacyId: args.pharmacyId,routeId: args.routeId,toteId: args.toteId,type: args.type,pmrList: args.pmrList,prescriptionList: args.prescriptionList,));


  case mapScreenRoute:
  final args = settings.arguments as MapScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  MapScreen(driverId: args.driverId, routeId: args.routeId));


  case searchPatientScreenRoute:
  final args = settings.arguments as SearchPatientScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: SearchPatientScreen(bulkScanDate: args.bulkScanDate,driverId: args.driverId,driverType: args.driverType,isBulkScan: args.isBulkScan,isRouteStart: args.isRouteStart,nursingHomeId: args.nursingHomeId,parcelBoxId: args.parcelBoxId,routeId: args.routeId,toteId: args.toteId,));
      // case introScreenRoute:
     // case introScreenRoute:
     //   return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const IntroScreen());

    case showOrderListScreenRoute:
      return MaterialPageRoute(builder: (context) => ShowOrderListScreen());


  ///Pharmacy
  case pharmacyHomePage:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  PharmacyHomeScreen());


  case pharmacyDeliveryListScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:   const PharmacyDeliveryListScreen());                  

  case pharmacyTrackOrderScreen:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  TrackOrderScreenPharmacy());


  case pharmacyCreateNotificationScreeenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const CreateNotificationScreen());    



  case nursingHomeScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const NursingHomeScreen());


  case displayMapRoutesScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const DisplayMapRoutesScreen());    


  case deliveryScheduleScreenRoute:
  final args = settings.arguments as PharmacyDeliveryScheduleManual;
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  PharmacyDeliveryScheduleManual(address: args.address,contact: args.contact,firstName: args.firstName,dob: args.dob,email: args.email,nhs: args.nhs,postCode: args.postCode,lastName: args.lastName,middleName: args.middleName,));        


  case searchMedicineScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const SearchMedicineScreen());            

    default:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}

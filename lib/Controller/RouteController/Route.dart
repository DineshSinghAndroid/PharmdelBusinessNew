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
import '../../PHARMACY/P_Views/P_DeliveryScheduleManual/p_delivery_schedule_manual.dart';
import '../../PHARMACY/P_Views/P_DisplayMapRoutes/p_display_map_routes_screen.dart';
import '../../PHARMACY/P_Views/P_Home/Pharmacy_home_page.dart';
import '../../PHARMACY/P_Views/P_ScanPrescription/p_scan_prescription_screen.dart';
import '../../PHARMACY/P_Views/P_TrackOrder/pharmacy_track_order_screen.dart';
import '../../PHARMACY/P_Views/P_delivery_schedule/p_delivery_schedule.dart';
import '../../PHARMACY/P_Views/p_DeliveryList/p_deliverylist_screen.dart';
<<<<<<< HEAD
import '../../View/BulkDrop/bulk_drop_screen.dart';
=======
import '../../PHARMACY/P_Views/p_SearchMedicine/p_search_medicine_screen.dart';
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
import '../../View/CreatePatientScreen.dart/createPatientScreen.dart';
import '../../View/CustomerListScreem.dart/customerlist.dart';
import '../../View/DashBoard/DriverDashboard/driver_dashboard_screen.dart';
import '../../View/DeliverySchedule/delivery_schedule_screen.dart';
import '../../View/OrderDetails/order_detail_screen.dart';
import '../../View/Instructions/instructions_screen.dart';
import '../../View/MapScreen/map_screen.dart';
import '../../View/NotificationScreen/notificationScreen.dart';
import '../../View/OnBoarding/EnterPin/securePin.dart';
import '../../View/SearchMedicine/search_medicine_screen.dart';
import '../../View/SignOrImage/sign_image_screen.dart';
import '../../View/UpdateStatusScreen/updatestatus_screen.dart';
import '../ProjectController/DriverDashboard/reschedule_pop_up.dart';
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

    case driverCreatePatientScreenRoute:
      final args = settings.arguments as DriverCreatePatientScreen;
      return MaterialPageRoute( builder: (context) => DriverCreatePatientScreen(isScanPrescription: args.isScanPrescription,));

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

  case p_scanPrescriptionScreenRoute:
    final args = settings.arguments as P_ScanPrescriptionScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  P_ScanPrescriptionScreen(bulkScanDate: args.bulkScanDate,type: args.type,driverId: args.driverId,isAssignSelf: args.isAssignSelf,isBulkScan: args.isBulkScan,isRouteStart: args.isRouteStart,nursingHomeId: args.nursingHomeId,parcelBoxId: args.parcelBoxId,pharmacyId:  args.pharmacyId,pmrList: args.pmrList,routeId: args.routeId,toteId: args.toteId,prescriptionList: args.prescriptionList,));

    case displayMapRoutesScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const DisplayMapRoutesScreen());

    case deliveryScheduleManualScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  PharmacyDeliveryScheduleManual());



    case mapScreenRoute:
  final args = settings.arguments as MapScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  MapScreen(driverId: args.driverId, routeId: args.routeId, list: args.list));


  case searchPatientScreenRoute:
<<<<<<< HEAD
    return MaterialPageRoute(builder: (context) => const SearchPatientScreen());

  case searchMedicineScreenRoute:
    return MaterialPageRoute(builder: (context) => const SearchMedicineScreen());

  case deliveryScheduleScreenRoute:
    final args = settings.arguments as DeliveryScheduleScreen;
    return MaterialPageRoute(builder: (context) => DeliveryScheduleScreen(orderInfo: args.orderInfo,));

=======
  final args = settings.arguments as SearchPatientScreen;
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: SearchPatientScreen(bulkScanDate: args.bulkScanDate,driverId: args.driverId,driverType: args.driverType,isBulkScan: args.isBulkScan,isRouteStart: args.isRouteStart,nursingHomeId: args.nursingHomeId,parcelBoxId: args.parcelBoxId,routeId: args.routeId,toteId: args.toteId,));
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
      // case introScreenRoute:
     // case introScreenRoute:
     //   return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const IntroScreen());

    case orderDetailScreenRoute:
      final args = settings.arguments as OrderDetailScreen;
      return MaterialPageRoute(builder: (context) => OrderDetailScreen(orderDetail: args.orderDetail,));

    case bulkDeliveryListScreenRoute:
      return MaterialPageRoute(builder: (context) => const BulkDeliveryListScreen());

    case instructionScreenRoute:
      return MaterialPageRoute(builder: (context) => const InstructionScreen());

    case signOrImageScreenRoute:
      final args = settings.arguments as SignOrImageScreen;
      return MaterialPageRoute(builder: (context) =>  SignOrImageScreen(addDelCharge: args.addDelCharge,amount: args.amount,deliveredTo: args.deliveredTo,delivery: args.delivery,exemptionId: args.exemptionId,failedRemark: args.failedRemark,isCdDelivery: args.isCdDelivery,mobileNo: args.mobileNo,notPaidReason: args.notPaidReason,orderIDs:args.orderIDs,outForDelivery: args.outForDelivery,paymentStatus: args.paymentStatus,paymentType: args.paymentType,remarks: args.remarks,rescheduleDate: args.rescheduleDate,routeId: args.routeId,rxCharge: args.rxCharge,rxInvoice: args.rxInvoice,selectedStatusCode: args.selectedStatusCode,subsId: args.subsId,));

    case reschedulePopUpScreenRoute:
      final args = settings.arguments as ReschedulePopUp;
      return MaterialPageRoute(builder: (context) =>  ReschedulePopUp(selectedOrderIDs:args.selectedOrderIDs,));


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


  case deliveryScheduleManualScreenRoute:  
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  PharmacyDeliveryScheduleManual());        


  case searchMedicineScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  const SearchMedicineScreen());


  case deliveryScheduleScreenRoute:
  final args = settings.arguments as DeliveryScheduleScreen;
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: DeliveryScheduleScreen(amount: args.amount,isPatient: args.isPatient,orderInfo: args.orderInfo,type: args.type,otherPharmacy: args.otherPharmacy,pharmacyId: args.pharmacyId,pmrList: args.pmrList,prescriptionList: args.prescriptionList,));

    default:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}

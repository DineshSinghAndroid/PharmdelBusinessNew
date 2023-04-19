import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
import '../../PHARMACY/P_Views/p_DeliveryList/p_deliverylist_screen.dart';
import '../../View/BulkDrop/bulk_drop_screen.dart';
import '../../View/CreatePatientScreen.dart/createPatientScreen.dart';
import '../../View/CustomerListScreem.dart/customerlist.dart';
import '../../View/DashBoard/DriverDashboard/driver_dashboard_screen.dart';
import '../../View/DeliverySchedule/delivery_schedule_screen.dart';
import '../../View/NotificationScreen/create_notification.dart';
import '../../View/OrderDetails/order_detail_screen.dart';
import '../../View/Instructions/instructions_screen.dart';
import '../../View/MapScreen/map_screen.dart';
import '../../View/NotificationScreen/notification_screen.dart';
import '../../View/OnBoarding/EnterPin/securePin.dart';
import '../../View/SearchMedicine/search_medicine_screen.dart';
import '../../View/SignOrImage/sign_image_screen.dart';
import '../../View/UpdateStatusScreen/updatestatus_screen.dart';
import '../../View/VirUploadScreens/VechileInspection_Report_Screen.dart';
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
      return MaterialPageRoute( builder: (context) => const NotificationScreen());

    case createNotificationRoute:
      return MaterialPageRoute( builder: (context) => const CreateNotification());

    case driverCreatePatientScreenRoute:
      final args = settings.arguments as DriverCreatePatientScreen;
      return MaterialPageRoute( builder: (context) => DriverCreatePatientScreen(isScanPrescription: args.isScanPrescription,));

    case updateAddressScreenRoute:
    final args = settings.arguments as UpdateAddressScreen;
    return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:  UpdateAddressScreen(address1: args.address1,address2: args.address2,postCode: args.postCode,townName: args.townName,driverName: args.driverName,userType: args.userType,));


      ///Update Vir report
  case virUploadScreenRoute:
    return MaterialPageRoute( builder: (context) => VechicleInspectionReportScreen());

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
    return MaterialPageRoute( builder: (context) => const ScanPrescriptionScreen());

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
    final args = settings.arguments as SearchPatientScreen;
    return MaterialPageRoute(builder: (context) => SearchPatientScreen(isScan: args.isScan,));

  case searchMedicineScreenRoute:
    return MaterialPageRoute(builder: (context) => const SearchMedicineScreen());

  case deliveryScheduleScreenRoute:
    final args = settings.arguments as DeliveryScheduleScreen;
    return MaterialPageRoute(builder: (context) => DeliveryScheduleScreen(orderInfo: args.orderInfo,));

      // case introScreenRoute:
     // case introScreenRoute:
     //   return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const IntroScreen());

    case orderDetailScreenRoute:
      final args = settings.arguments as OrderDetailScreen;
      return MaterialPageRoute(builder: (context) => OrderDetailScreen(detailData: args.detailData,isMultipleDeliveries: args.isMultipleDeliveries,));

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
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const PharmacyHomeScreen());


  case pharmacyDeliveryListScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft,duration: const Duration(milliseconds: 300), alignment: Alignment.center, child:   const PharmacyDeliveryListScreen());                  

  case pharmacyTrackOrderScreen:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const TrackOrderScreenPharmacy());


  case pharmacyCreateNotificationScreeenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const CreateNotificationScreen());



    case nursingHomeScreenRoute:
      return PageTransition(type: PageTransitionType.rightToLeft, duration: const Duration(milliseconds: 300), alignment: Alignment.center, child: const NursingHomeScreen());

    default:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
  }
}

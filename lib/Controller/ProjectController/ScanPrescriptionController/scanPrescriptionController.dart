
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_ProcessScanController/p_processScanController.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Model/PharmacyModels/P_ProcessScanApiResponse/p_processScanResponse.dart';
import '../../../Model/PmrResponse/pmrResponse.dart';
import '../../../View/SearchPatient/search_patient.dart';
import '../../PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';
import '../../WidgetController/Popup/popup.dart';


class ScanPrescriptionController extends GetxController{

  ApiController apiCtrl = ApiController();
  PmrApiResponse? pmrData;
  OrderInfo? orderInfo;

  Location location =  Location();
  var barcodeScanRes;
  String qrType = "";
  double? startLat;
  double? startLng;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

   Future<void> getLocationData({required BuildContext context}) async {
    CheckPermission.checkLocationPermission(context).then((value) async {      
      var position = await GeolocatorPlatform.instance.getCurrentPosition();
      startLat = position.latitude;
      startLng = position.longitude;
      PrintLog.printLog("latitude : $startLat");
      PrintLog.printLog("latitude : $startLng");
    });
  }

  ///onTap Select Customer
  void selectCustomer({required String userId, required String altAddress, dynamic position}){
    pmrData?.xml?.customerId = userId;
    pmrData?.xml?.alt_address = altAddress;    
    
    pmrData?.xml?.patientInformation?.firstName = orderInfo?.patientList?.customerName?[position];
    
    pmrData?.xml?.patientInformation?.dob = orderInfo?.patientList?.dob![position] ?? pmrData?.xml?.patientInformation?.dob;
    
    pmrData?.xml?.patientInformation?.address = orderInfo?.patientList?.address != null ? orderInfo?.patientList?.address![position] ?? pmrData?.xml?.patientInformation?.address : pmrData?.xml?.patientInformation?.address;
    
    pmrData?.xml?.patientInformation?.nursing_home_id = orderInfo?.patientList?.nursing_home_id != null ? orderInfo?.patientList?.nursing_home_id![position].toString() ?? pmrData?.xml?.patientInformation?.address : pmrData?.xml?.patientInformation?.address;
    
    pmrData?.xml?.patientInformation?.postCode = orderInfo?.prescriptionId ?? "";

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_delivery_route != null && orderInfo!.patientList!.default_delivery_route!.isNotEmpty) {
      orderInfo?.defaultDeliveryRoute = orderInfo?.patientList?.default_delivery_route?[position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_delivery_type != null && orderInfo!.patientList!.default_delivery_type!.isNotEmpty) {
      orderInfo?.defaultDeliveryType = orderInfo?.patientList?.default_delivery_type?[position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_delivery_note != null && orderInfo!.patientList!.default_delivery_note!.isNotEmpty) {
      orderInfo?.defaultDeliveryNote = orderInfo?.patientList?.default_delivery_note?[position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_branch_note != null && orderInfo!.patientList!.default_branch_note!.isNotEmpty) {
      orderInfo?.defaultBranchNote = orderInfo?.patientList?.default_branch_note?[position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_surgery_note != null && orderInfo!.patientList!.default_surgery_note!.isNotEmpty) {
      orderInfo?.defaultSurgeryNote = orderInfo?.patientList?.default_surgery_note?[position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_service != null && orderInfo!.patientList!.default_service!.isNotEmpty) {
      orderInfo?.defaultService = orderInfo?.patientList?.default_service?[position];
    } 
  } 

  ///User Not Exist Dialog
  void userNotExistDialog({required BuildContext context}){
    PopupCustom.userNotExistDialog(
      context: context, 
      title: 'Pharmdel', 
      msg: 'User not registered, Continue to create a new user', 
      onTapNo: (){
        Get.back();        
      }, 
      onTapCreate: (){});
  }


///Process Scan Controller
PharmacyProcessScanController getProcessScanController = Get.put(PharmacyProcessScanController());

///Create Order Controller
DeliveryScheduleController getDeliveryScheduleController = Get.put(DeliveryScheduleController());

/// Build QR View
Future<void> buildQrView({required BuildContext context, required String qrCodeType})async {
  try{
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);

    qrType = qrCodeType;
    PrintLog.printLog("QR Type : $barcodeScanRes");

    if(barcodeScanRes != "-1"){
      if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.contains("-") && barcodeScanRes.split("-").length > 4){
        qrType = "4";
        qrCodeType = "4";
      }
     else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("pharm")) {
          qrType = "5";
          qrCodeType = "5";          
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("<xml>")) {
          qrCodeType = "1";
          qrType = "1";          
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("PSL") && barcodeScanRes.contains(";") && barcodeScanRes.split(";").length > 2) {
          qrCodeType = "4";
          qrType = "4";
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.contains(";") && barcodeScanRes.split(";").length > 2) {
          qrCodeType = "6";
          qrType = "6";
        } else if (barcodeScanRes != null && int.tryParse(barcodeScanRes) != null) {
          qrCodeType = "2";
          qrType = "2";
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.length > 2) {
          qrCodeType = "3";
          qrType = "3";
        } else {
          ToastCustom.showToast(msg: "QR data not available !");
          Navigator.of(context).pop(true);          
        }
  } else if (barcodeScanRes == "-1"){
    if(driverType.toLowerCase() != kSharedDriver){
      Get.back();
      Get.toNamed(searchPatientScreenRoute,
        arguments: SearchPatientScreen(
          bulkScanDate: "",
          driverId: "",
          driverType: "",
          isBulkScan: false,
          isRouteStart: false,
          nursingHomeId: "",
          parcelBoxId: "",
          routeId: "",
          toteId: "",
        ));
    }else {
      ToastCustom.showToast(msg: "Data not fetching. Plz try again !");
      Navigator.of(context).pop(true);
    }
  } else{
    ToastCustom.showToast(msg: "Data not fetching. Plz try again !");
    Navigator.of(context).pop(true);
  }
  } 
  catch(_){    
    String? barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
    PrintLog.printLog(barcodeScanRes);
    PrintLog.printLog("Exception....$_....");      
  }
}


  void changeSuccessValue(bool value){
    isSuccess = value;
    update();
  }
  void changeLoadingValue(bool value){
    isLoading = value;
    update();
  }
  void changeEmptyValue(bool value){
    isEmpty = value;
    update();
  }
  void changeNetworkValue(bool value){
    isNetworkError = value;
    update();
  }
  void changeErrorValue(bool value){
    isError = value;
    update();
  }

}

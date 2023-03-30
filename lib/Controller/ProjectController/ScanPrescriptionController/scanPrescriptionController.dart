
import 'package:get/get.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_ProcessScanController/p_processScanController.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Model/PharmacyModels/P_ProcessScanApiResponse/p_processScanResponse.dart';
import '../../../Model/PmrResponse/pmrResponse.dart';
import '../../PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';


class ScanPrescriptionController extends GetxController{

  ApiController apiCtrl = ApiController();
  PmrApiResponse? pmrData;
  OrderInfo? orderInfo;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

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
      orderInfo?.defaultDeliveryRoute = orderInfo?.patientList?.default_delivery_route![position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_delivery_type != null && orderInfo!.patientList!.default_delivery_type!.isNotEmpty) {
      orderInfo?.defaultDeliveryType = orderInfo?.patientList?.default_delivery_type![position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_delivery_note != null && orderInfo!.patientList!.default_delivery_note!.isNotEmpty) {
      orderInfo?.defaultDeliveryNote = orderInfo?.patientList?.default_delivery_note![position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_branch_note != null && orderInfo!.patientList!.default_branch_note!.isNotEmpty) {
      orderInfo?.defaultBranchNote = orderInfo?.patientList?.default_branch_note![position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_surgery_note != null && orderInfo!.patientList!.default_surgery_note!.isNotEmpty) {
      orderInfo?.defaultSurgeryNote = orderInfo?.patientList?.default_surgery_note![position];
    }

    if (orderInfo != null && orderInfo?.patientList != null && orderInfo?.patientList?.default_service != null && orderInfo!.patientList!.default_service!.isNotEmpty) {
      orderInfo?.defaultService = orderInfo?.patientList?.default_service![position];
    }
  }


  ///onTap Add New Customer
  void onTapAddNewCustomer(){
    
  }


///Process Scan Controller
PharmacyProcessScanController getProcessScanController = Get.put(PharmacyProcessScanController());

///Create Order Controller
DeliveryScheduleController getDeliveryScheduleController = Get.put(DeliveryScheduleController());


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


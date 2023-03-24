import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/Notification/NotifficationResponse.dart';
import '../../../Model/ParcelBox/parcel_box_response.dart';
import '../../../Model/PharmacyModels/P_CreateOrderApiResponse/p_createOrderResponse.dart';
import '../../../Model/PharmacyModels/P_DeliveryScheduleResponse/p_DeliveryScheduleResposne.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';


class DeliveryScheduleController extends GetxController{

  ApiController apiCtrl = ApiController();

  TextEditingController existingNoteController = TextEditingController();
  TextEditingController deliveryNoteController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController daysController = TextEditingController();

  DeliveryScheduleApiResponse? deliveryScheduleData;
  NursingHomes? selectedNursingHome;
  PatientSubscriptions? selectedDeliveryCharge;
  Shelf? selectedService;
  Exemptions? selectedExemption;
  List<ParcelBoxData>? parcelBoxList;
  ParcelBoxData? selectedParcelBox;
  OrderData? orderData;

  List<String> bagSizeList = ["S", "M", "L", "C",];
  List paidList = [
    {
      "id": 0,
      "value": "1",
      "isSelected": false,
    },
    {
      "id": 1,
      "value": "2",
      "isSelected": false,
    },
    {
      "id": 2,
      "value": "3",
      "isSelected": false,
    },
    {
      "id": 3,
      "value": "4",
      "isSelected": false,
    },
    {
      "id": 4,
      "value": "5",
      "isSelected": false,
    },
    {
      "id": 5,
      "value": "6",
      "isSelected": false,
    },
  ];
  List<String> statusItems = [
    'Received',
    'Requested',
    'Ready',
    'PickedUp',
  ];
  String selectedStatus = "Received";

  int bagId = -1;
  bool fridgeSelected = false;
  bool controlDrugSelected = false;
  bool paidSelected = false;
  bool exemptSelected = false;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  String selectedDate = "";
  String showDatedDate = "";

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');
  
  ///Select Status
void onTapSelectStatus(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Select Status");
    BottomSheetCustom.pDeliveryScheduleBottomSheet(
      controller: controller,
      context: context,
      listType: 'received',
      selectedID: '0',
      onValue: (value) async {
        print("test value ${value}");
        if (value != null) {          
          selectedStatus = value;
          update();
          PrintLog.printLog("Selected Nursing Home: ${statusItems}");
        }
      },
    );
  }

  ///Select Nursing home
  void onTapSelectNursingHome(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Select Nursing Home");
    BottomSheetCustom.pDeliveryScheduleBottomSheet(
      controller: controller,
      context: context,
      listType: 'nursing home',
      selectedID: selectedNursingHome?.id,
      onValue: (value) async {
        if (value != null) {
          selectedNursingHome = value;
          update();
          PrintLog.printLog("Selected Nursing Home: ${selectedNursingHome?.name}");
        }
      },
    );
  }

  /// Selected Delivery Charge
  void onTapSeletedDeliveryCharge(
      {required BuildContext context,
      required controller}) {    
    PrintLog.printLog("Clicked on Select Delivery Charge");
    BottomSheetCustom.pDeliveryScheduleBottomSheet(
      controller: controller,
      context: context,
      listType: kSelDelCharge,
      selectedID: selectedDeliveryCharge?.id,
      onValue: (value) async {
        if (value != null) {
          selectedDeliveryCharge = value;
          if(selectedDeliveryCharge?.name == "Per Delivery"){
           deliveryChargeController.text = selectedDeliveryCharge?.price ?? "";
          }
          update();
          PrintLog.printLog("Selected Delivery Charge: ${selectedDeliveryCharge?.name}");
        }
      },
    );
  }

  ///Select Route
  void onTapSelectedRoute(
      {required BuildContext context, required controller}) {
    PrintLog.printLog("Clicked on Select route");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: getRouteListController.selectedroute?.routeId,
      listType: "route",
      onValue: (value) async {
        if (value != null) {
          getRouteListController.selectedroute = value;
          await getDriverListController.getDriverList(
              context: context, routeId: getRouteListController.selectedroute?.routeId);
          update();
          PrintLog.printLog("Selected Route: ${getRouteListController.selectedroute?.routeName}");
        }
      },
    );
  }

  ///Select Driver
  void onTapSelectedDriver(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Select driver");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: getDriverListController.selectedDriver?.driverId,
      listType: "driver",
      onValue: (value) async {
        if (value != null) {
          getDriverListController.selectedDriver = value;
          await getParcelBoxApi(context: context,driverId: getDriverListController.selectedDriver?.driverId ?? "",)
              .then((value) {
            update();
          }); 
          PrintLog.printLog("Selected Driver: ${getDriverListController.selectedDriver?.firstName}");
        }
      },
    );
  }

   ///Select Service
  void onTapSelectService(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Select service");
    BottomSheetCustom.pDeliveryScheduleBottomSheet(
      controller: controller,
      context: context,
      selectedID: selectedService?.id,
      listType: "service",
      onValue: (value) async {
        if (value != null) {
          selectedService = value;
         update();
          PrintLog.printLog("Selected Driver: ${selectedService?.name}");
        }
      },
    );
  }

  ///Select Parcel Box
  void onTapSelectParcelLocation(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Select Parcel Location");
    BottomSheetCustom.pDeliveryScheduleBottomSheet(
      controller: controller,
      context: context,
      selectedID: selectedParcelBox?.id,
      listType: "parcel location",
      onValue: (value) async {
        if (value != null) {
          selectedParcelBox = value;
         update();
          PrintLog.printLog("Selected Parcel Location: ${selectedParcelBox?.name}");
        }
      },
    );
  }

  ///Select Exemption
  void onTapExempt(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Exempt");
    BottomSheetCustom.pDeliveryScheduleBottomSheet(
      controller: controller,
      context: context,
      selectedID: selectedExemption?.id,
      listType: "exempt",
      onValue: (value) async {
        if (value != null) {
          exemptSelected = value;                  
         update();
          PrintLog.printLog("Selected Exempt: ${selectedExemption?.code}");
        }
      },
    );
  }
  
   onTapGallery({required BuildContext context,}){
    imgPickerController.getImage("Gallery", context, "documentImage");
  }

  void onTapCamera({required BuildContext context}){
    imgPickerController.getImage("Camera", context, "documentImage");
  }


///Image Picker Controller
ImagePickerController imgPickerController = Get.put(ImagePickerController());

/// Get Driver Controller
GetDriverListController getDriverListController = Get.put(GetDriverListController());

/// Get Route Controller
PharmacyGetRouteListController  getRouteListController = Get.put(PharmacyGetRouteListController());


  /// Delivery Schedule Controller
  Future<NotificationApiResponse?> deliveryScheduleApi({required BuildContext context,required String pharmacyId}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "pharmacyId":pharmacyId
    };

    String url = WebApiConstant.GET_PHARMACY_DELIVERY_MASTER_URL;

    await apiCtrl.getDeliveryScheduleApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
          try {                                
              deliveryScheduleData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);

          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }       
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }

  Future<GetParcelBoxApiResponse?> getParcelBoxApi({required BuildContext context,required String driverId}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "driverId":driverId
    };

    String url = WebApiConstant.GET_PHARMACY_PARCEL_BOX_URL;

    await apiCtrl.getParcelBoxApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if (result.error == false) {
            parcelBoxList = result.data;
            result.data == null ? changeEmptyValue(true):changeEmptyValue(false);
            changeLoadingValue(false);
            changeSuccessValue(true);

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
          }

        } catch (_) {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");
        }

      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


/// Create Order Controller
  Future<CreateOrderApiResponse?> createOrderApi({
    required BuildContext context, 
    required String firstName,
    required String middleName,
    required String lastName,
    required String postCode,
    required String addressLine1,
    required String nhsNumber,
    required String dob,
    required String mobileNumber,
    required String emailId,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "order_type": "manual",
      "pharmacyId": 0,
      "otherpharmacy": false,
      "pmr_type": "0",
      "endRouteId": "",
      "startRouteId": "",
      "start_lat": "",
      "start_lng": "",
      "del_subs_id": selectedDeliveryCharge?.id ?? "",
      "exemption": selectedExemption?.id ?? "",      
      "paymentStatus": "", 
      "bag_size": "",
      "patient_id": "",
      "pr_id": "",
      "lat": "",      
      "lng": "",
      "parcel_box_id": selectedParcelBox?.id ?? "",
      "surgery_name": "",
      "surgery": "",
      "amount": "",
      "email_id": emailId,
      "mobile_no_2": mobileNumber,
      "dob": dob,
      "nhs_number": nhsNumber,
      "title": "",
      "first_name": firstName,
      "middle_name": middleName,
      "last_name": lastName,
      "address_line_1": addressLine1,
      "country_id": "",
      "post_code": postCode,
      "gender": "",
      "preferred_contact_type": "",
      "delivery_type": "",
      "driver_id": getDriverListController.selectedDriver?.driverId ?? "",
      "delivery_route": getRouteListController.selectedroute?.routeId ?? "",
      "storage_type_cd": controlDrugSelected,
      "storage_type_fr": controlDrugSelected,
      "delivery_status": "",
      "nursing_homes_id":selectedNursingHome?.id ?? "",
      "shelf": selectedService?.id ?? "",
      "delivery_service":"",
      "doctor_name": "",
      "doctor_address": "",
      "new_delivery_notes": deliveryNoteController.text.toString().trim(),
      "existing_delivery_notes": existingNoteController.text.toString().trim(),
      "del_charge": deliveryChargeController.text.toString().trim(),
      "rx_charge": deliveryScheduleData?.rxCharge ?? "",
      "subs_id": selectedDeliveryCharge?.id ?? "",
      "rx_invoice": "",
      "branch_notes": "",
      "surgery_notes": "",
      "medicine_name": "",
      "prescription_images": "",
      "delivery_date": selectedDate,
    };

    String url = WebApiConstant.GET_PHARMACY_CREATE_ORDER_URL;

    await apiCtrl.getCreateOrderApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if(result.error != true){
          try {
              orderData = result.data;              
              result.data == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);

          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }
        }else{
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }       
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
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


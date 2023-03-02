import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';

 import '../../../Model/CreatePatientModel/create_patient_model.dart';
import '../../../Model/UpdateCustomerWithOrder/UpdateCustomerWithOrder.dart';
import '../../ApiController/ApiController.dart';
import '../../Helper/Permission/PermissionHandler.dart';

class CreatePatientController extends GetxController {
  ApiController apiCtrl = ApiController();
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  // CreatePatientModel? createPatientModel;

  bool isBulkScan = false;
  String? toteId;

  // BulkScanMode callPickedApi;
  String? bulkScanDate;
  String? nursingHomeId;
  String? driverId;
  String? routeId;
  int? parcelBoxId;

  // callGetOrderApi ?callApi;
  String accessToken = "";
  int? pharmacyId;
  bool otherPharmacy = false;

  @override
  void onInit() {
    // nhsNoCtrl.text = widget.result??
    //     "";

    // getLocationData(context);

    // TODO: implement onInit
    super.onInit();
  }

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController middleNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nhsNoCtrl = TextEditingController();
  TextEditingController searchAddress = TextEditingController();
  TextEditingController addressLine1Ctrl = TextEditingController();
  TextEditingController addressLine2Ctrl = TextEditingController();
  TextEditingController townCtrl = TextEditingController();
  TextEditingController postCodeCtrl = TextEditingController();

  // PmrModel model;
  // int endRouteId;
  // int startRouteId;
  double? startLat;
  double? startLng;
  bool isStartRoute = false;

  final List<String> selectTitle = [
    "Mr",
    "Miss",
    "Mrs",
    "Ms",
    "Captain",
    "Dr",
    "Prof",
    "Rev",
    "Mx",
  ];
  String? selectedTitleValue;
  final List<String> selectGender = [
    "Male",
    "Female",
    "Other",
  ];
  String? selectedGenderValue;

  void getLocationData(context) async {
    CheckPermission.checkLocationPermission(context).then((value) async {
      if (value == true) {
        var position = await GeolocatorPlatform.instance.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
        startLat = position.latitude;
        startLng = position.longitude;
      }
    });
  }

  // OrderInfoResponse orderInfo;
  // FlutterGooglePlacesSdk googlePlace;
  // List<AutocompletePrediction> prediction = [];
  // List<Dd> prescriptionList = List();
  // List<PmrModel> pmrList = List();
  // String titleValue;
  // String genderValue;

  btnPress(BuildContext context) {
    if (selectedTitleValue != null &&
        selectedGenderValue != null &&
        nameCtrl.text.isNotEmpty &&
        lastNameCtrl.text.isNotEmpty &&
        addressLine1Ctrl.text.isNotEmpty &&
        townCtrl.text.isNotEmpty &&
        postCodeCtrl.text.isNotEmpty) {
      createPatient(context: context);
    } else {
      ToastCustom.showToast(msg: "Please Complete All Required Fields");
    }
  }

  CreatePatientModelResponse? createPatientModelResponse;

  Future<CreatePatientModelResponse?> createPatient({context,}) async {

    CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {
      "title": selectedTitleValue,
      "first_name": nameCtrl.text.toString().trim(),
      "last_name": lastNameCtrl.text.toString().trim(),
      "address_line_1": addressLine1Ctrl.text.toString().trim(),
      "address_line_2": addressLine2Ctrl.text.toString().trim(),
      "town_name": townCtrl.text.toString().trim(),
      "post_code": postCodeCtrl.text.toString().trim(),
      "mobile_no": mobileCtrl.text.toString().trim(),
      "email_id": emailCtrl.text.toString().trim(),
      "nhs_number": nhsNoCtrl.text.toString().trim(),
      "middle_name": middleNameCtrl.text.toString().trim(),
      "country_id": "",
      "gender": selectedGenderValue,
    };
    String url = WebApiConstant.CREATE_PATIENT_URL;
    await apiCtrl.createPatientApi(context: context, url: url,
        dictParameter: dictparm, token: authToken).then((_result) {
      if (_result != null) {
        if (_result.error != true) {
          ToastCustom.showToast(msg: _result.message ?? "");
          try {
            if (_result.error == false) {
              createPatientModelResponse = _result;
              ToastCustom.showToast(msg: _result.message ?? "");

              CustomLoading().show(context, false);
              createPatientDone();
            } else {
              CustomLoading().show(context, false);
              PrintLog.printLog(_result.message);
              ToastCustom.showToast(msg: _result.message ?? "");
            }
          } catch (_) {
            CustomLoading().show(context, false);

            PrintLog.printLog("Exception : $_");
            ToastCustom.showToast(msg: _result.message ?? "");
          }
        }
        else {
          CustomLoading().show(context, false);

          PrintLog.printLog(_result.message);
          ToastCustom.showToast(msg: _result.message ?? "");
          update();
        }
      }
    });
    update();
    CustomLoading().show(context, false);

  }

  void createPatientDone() async{
    nameCtrl.clear();
    middleNameCtrl.clear();
    lastNameCtrl.clear();
    emailCtrl.clear();
    nhsNoCtrl.clear();
    postCodeCtrl.clear();
    mobileCtrl.clear();
    addressLine2Ctrl.clear();
    addressLine1Ctrl.clear();
    townCtrl.clear();
    postCodeCtrl.clear();
    update();
  }






  //Create Order Controller ****************//
  // PmrModel model;
  int ? endRouteId;
  int ? startRouteId;
  // OrderInfoResponse ? orderInfo;






  Future<UpdateCustomerWithOrderModel?> createOrder({context,}) async {

    CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {
      "order_type": "scan",
      "pharmacyId": pharmacyId,
      "endRouteId": isStartRoute ? "$endRouteId" : "0",
      "startRouteId": isStartRoute ? "$startRouteId" : "0",
      "nursing_home_id": nursingHomeId,
      "tote_box_id": toteId,
      "start_lat": isStartRoute ? "$startLat" : "",
      "start_lng": isStartRoute ? "$startLng" : "",
      "del_charge": "",
      "rx_charge": "",
      "subs_id": "",
      "rx_invoice": "",
      "del_subs_id": 0,
      "nursing_homes_id": 0,
      "pmr_type": "2",
      "otherpharmacy": otherPharmacy,
      // "titan_scan_info": orderInfo.titanScaInfo != null ? orderInfo.titanScaInfo : "",
      "amount": "0",
      "exemption": "",
      //_exemptSelected ? selectedExemptionId != null ? selectedExemptionId : 0 : 0,
      "paymentStatus": "",
      "bag_size": "",
      // "patient_id": orderInfo.userId ?? 0,
      // "pr_id": pmrList[0].xml.sc != null ? pmrList[0].xml.sc.id ?? "" : "",
      "lat": "",

      "lng": "",

      "parcel_box_id": parcelBoxId != null ? "${parcelBoxId}" : "0",
      // "surgery_name": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.companyName ?? "" : "",
      // "surgery": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.i ?? "" : "",
      "email_id": "",
      // "mobile_no_2": pmrList[0].xml.patientInformation.mobileNo ?? "",
      // "dob": "$dob",
      // "nhs_number": pmrList[0].xml.patientInformation.nhs ?? "",
      // "title": tittle ?? "",
      // "first_name": pmrList[0].xml.patientInformation.firstName ?? "",
      // "middle_name": pmrList[0].xml.patientInformation.middleName != null && pmrList[0].xml.patientInformation.middleName != "null" ? pmrList[0].xml.patientInformation.middleName : "",
      // "last_name": pmrList[0].xml.patientInformation.lastName != null ? (pmrList[0].xml.patientInformation.lastName != "null" ? pmrList[0].xml.patientInformation.lastName : "") : "",
      // "address_line_1": pmrList[0].xml.patientInformation.address ?? "",
      "country_id": "",
      // "post_code": pmrList[0].xml.patientInformation.postCode ?? "",
      // "gender": gender,
      "preferred_contact_type": "",
      "delivery_type": "Delivery",
      "driver_id": driverId,
      "delivery_route": routeId,
      "storage_type_cd": "f",
      "storage_type_fr": "f",
      "delivery_status": isStartRoute
          ? "4"
          : toteId == null || toteId!.isEmpty
          ? "8"
          : "2",
      "shelf": "",
      // "delivery_service": orderInfo.default_service,
      // "doctor_name": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.doctorName ?? "" : "",
      // "doctor_address": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.address ?? "" : "",
      "new_delivery_notes": "",
      // "existing_delivery_notes": orderInfo != null && orderInfo.default_delivery_note != null && orderInfo.default_delivery_note != "" ? orderInfo.default_delivery_note : "",
      "branch_notes": "",
      "surgery_notes": "",
      "medicine_name": [],
      "delivery_date": bulkScanDate,
      "prescription_images": [],
    };


    String url = WebApiConstant.UPDATE_CUSTOMER_WITH_ORDER;
    await apiCtrl.createPatientApi(context: context, url: url,
        dictParameter: dictparm, token: authToken).then((_result) {
      if (_result != null) {
        if (_result.error != true) {
          ToastCustom.showToast(msg: _result.message ?? "");
          try {
            if (_result.error == false) {
              createPatientModelResponse = _result;
              ToastCustom.showToast(msg: _result.message ?? "");

              CustomLoading().show(context, false);
              createPatientDone();
            } else {
              CustomLoading().show(context, false);
              PrintLog.printLog(_result.message);
              ToastCustom.showToast(msg: _result.message ?? "");
            }
          } catch (_) {
            CustomLoading().show(context, false);

            PrintLog.printLog("Exception : $_");
            ToastCustom.showToast(msg: _result.message ?? "");
          }
        }
        else {
          CustomLoading().show(context, false);

          PrintLog.printLog(_result.message);
          ToastCustom.showToast(msg: _result.message ?? "");
          update();
        }
      }
    });
    update();
    CustomLoading().show(context, false);

  }

}




import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../ApiController/ApiController.dart';
import '../../Helper/Permission/PermissionHandler.dart';

class CreatePatientController extends GetxController{
  ApiController apiCtrl = ApiController();
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;
  // CreatePatientModel? createPatientModel;

  String result = "";
  bool isBulkScan = false;
  String ? toteId;
  // BulkScanMode callPickedApi;
  String ?bulkScanDate;
  String? nursingHomeId;
  String ? driverId;
  String ? routeId;
  int ? parcelBoxId;
  // callGetOrderApi ?callApi;
  String accessToken = "";
  int ? pharmacyId;
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
  double ? startLng;
  bool isStartRoute = false;

  void getLocationData( context ) async {
    CheckPermission.checkLocationPermission(context ).
    then((value) async {
      if (value == true) {
        var position = await
        GeolocatorPlatform.instance.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
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



}
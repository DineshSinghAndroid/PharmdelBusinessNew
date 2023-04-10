import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Model/CreatePatientModel/driver_create_patient_response.dart';
import '../../GeoCoder/GoogleAddresResponse/google_api_response.dart';

class CreatePatientController extends GetxController {
  ApiController apiCtrl = ApiController();
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  final List<SurNameTitle> selectTitle = [
    SurNameTitle(showTitle: "Mr",sendTitle: "M"),
    SurNameTitle(showTitle: "Miss",sendTitle: "S"),
    SurNameTitle(showTitle: "Mrs",sendTitle: "F"),
    SurNameTitle(showTitle: "Ms",sendTitle: "Q"),
    SurNameTitle(showTitle: "Captain",sendTitle: "C"),
    SurNameTitle(showTitle: "Dr",sendTitle: "D"),
    SurNameTitle(showTitle: "Prof",sendTitle: "P"),
    SurNameTitle(showTitle: "Rev",sendTitle: "R"),
    SurNameTitle(showTitle: "Mx",sendTitle: "X"),

  ];

  final List<SurNameTitle> selectGender = [
    SurNameTitle(showTitle: "Male",sendTitle: "M"),
    SurNameTitle(showTitle: "Female",sendTitle: "F"),
    SurNameTitle(showTitle: "Other",sendTitle: "M"),
  ];

  SurNameTitle? selectedTitleValue;
  SurNameTitle? selectedGenderValue;

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController middleNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nhsNoCtrl = TextEditingController();
  TextEditingController startTypingCtrl = TextEditingController();
  TextEditingController searchAddress = TextEditingController();
  TextEditingController addressLine1Ctrl = TextEditingController();
  TextEditingController addressLine2Ctrl = TextEditingController();
  TextEditingController townCtrl = TextEditingController();
  TextEditingController postCodeCtrl = TextEditingController();

<<<<<<< HEAD
=======
  // PmrModel model;
  // int endRouteId;
  // int startRouteId;
  double? startLat;
  double? startLng;
  bool isStartRoute = false;

  final List<SurNameTitle> selectTitle = [
    SurNameTitle(showTitle: "Mr",sendTitle: "M"),
    SurNameTitle(showTitle: "Miss",sendTitle: "S"),
    SurNameTitle(showTitle: "Mrs",sendTitle: "F"),
    SurNameTitle(showTitle: "Ms",sendTitle: "Q"),
    SurNameTitle(showTitle: "Captain",sendTitle: "C"),
    SurNameTitle(showTitle: "Dr",sendTitle: "D"),
    SurNameTitle(showTitle: "Prof",sendTitle: "P"),
    SurNameTitle(showTitle: "Rev",sendTitle: "R"),
    SurNameTitle(showTitle: "Mx",sendTitle: "X"),
   
  ];
  SurNameTitle? selectedTitleValue;

  final List<SurNameTitle> selectGender = [
    SurNameTitle(showTitle: "Male",sendTitle: "M"),
    SurNameTitle(showTitle: "Female",sendTitle: "F"),
    SurNameTitle(showTitle: "Other",sendTitle: "M"),
  ];

  SurNameTitle? selectedGenderValue;

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

  btnPress(BuildContext context) async {
    
    if(
      selectedTitleValue != null &&
      selectedGenderValue != null &&
      nameCtrl.text.isNotEmpty &&
      lastNameCtrl.text.isNotEmpty &&
      addressLine1Ctrl.text.isNotEmpty &&
      townCtrl.text.isNotEmpty &&
      postCodeCtrl.text.isNotEmpty
    ){
      await createPatient(context: context);
    } else {
      ToastCustom.showToast(msg: "Please Complete All Required Fields");
    }

    
    // if (selectedTitleValue != null &&
    //     selectedGenderValue != null &&
    //     nameCtrl.text.isNotEmpty &&
    //     lastNameCtrl.text.isNotEmpty &&
    //     addressLine1Ctrl.text.isNotEmpty &&
    //     townCtrl.text.isNotEmpty &&
    //     postCodeCtrl.text.isNotEmpty) {
    //  await createPatient(context: context);
    // } else {
    //   ToastCustom.showToast(msg: "Please Complete All Required Fields");
    // }
  }

  CreatePatientModelResponse? createPatientModelResponse;

  Future<CreatePatientModelResponse?> createPatient({context,}) async {
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a

  bool isFirstName = false;
  bool isLastName = false;
  bool isAddressLine1 = false;
  bool isAddressLine2 = false;
  bool isTownName = false;
  bool isPostCode = false;

<<<<<<< HEAD
  bool isHideStartTypingCTRL = false;
  bool isStartTyping = false;
=======
    Map<String, dynamic> dictparm = {
      "title": selectedTitleValue?.sendTitle,
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
      "gender": selectedGenderValue?.sendTitle,
    };
    print("test ${dictparm}");
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
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a

  double spaceBetween = 10;

  FlutterGooglePlacesSdk? googlePlace;
  List<AutocompletePrediction> prediction = [];
  String? pharmacyID;

  List<GoogleAddressResults>? googleAddressListData;


  /// Clear All Text Field
  Future<void> clearAllField() async{
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
    startTypingCtrl.clear();
    selectedTitleValue = null;
    selectedGenderValue = null;
    update();
  }

  /// On Changed StartTyping Controller
  Future<void> onChangedStartTyping({required String value})async{
    isStartTyping = false;
    if(value == " "){
      startTypingCtrl.clear();
    }

    if (value.trim().isNotEmpty) {
      FindAutocompletePredictionsResponse? result = await googlePlace?.findAutocompletePredictions(value.trim());
      prediction = result != null && result.predictions.isNotEmpty ? result.predictions:[];
    } else {
      prediction.clear();
    }
    update();
  }

  /// On Tap Suggestion List
  Future<void> onTapSuggestionListItem({required int index})async{
    await getGoogleAddress(primaryText: prediction[index].primaryText ?? "",secondaryText: prediction[index].secondaryText ?? "").then((value) async {
      if(googleAddressListData != null){
        await assignAddress(data: googleAddressListData ?? []);
      }
    });
  }

  Future<void> assignAddress({required List<GoogleAddressResults> data})async{
    addressLine1Ctrl.clear();
    addressLine2Ctrl.clear();
    townCtrl.clear();
    postCodeCtrl.clear();
    startTypingCtrl.clear();
    isHideStartTypingCTRL = true;

    if(data.isNotEmpty && data[0].geometry != null && data[0].geometry?.location != null){
      Placemark? placeMark = await CheckPermission.getPlaceMarkWithLatLng(latitude: data[0].geometry?.location?.lat.toString() ?? "", longitude: data[0].geometry?.location?.lng.toString() ?? "");
      PrintLog.printLog("Position-country: ${placeMark?.country}");
      if(placeMark != null){

        addressLine1Ctrl.text = "${placeMark.street ?? ""}, ${placeMark.subLocality ?? ""}, ${placeMark.locality ?? ""}";

        addressLine2Ctrl.text = placeMark.administrativeArea ?? "";
        townCtrl.text = "${placeMark.subAdministrativeArea ?? ""}, ${placeMark.administrativeArea ?? ""}";
         postCodeCtrl.text = placeMark.postalCode ?? "";

          prediction.clear();
        update();
      }
    }

    update();
  }


  Future<GoogleAddressApiResponse?> getGoogleAddress({required String primaryText,required String secondaryText}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);


    await apiCtrl.getGoogleAddressApi(primaryText: primaryText,secondaryText: secondaryText).then((result) async {
      if (result != null) {
        try {
          if (result.status.toString().toLowerCase() == "ok" && result.status != null) {
            googleAddressListData = result.results;
            changeLoadingValue(false);
            changeSuccessValue(true);
          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
          }
        } catch (_) {
          PrintLog.printLog("Exception : $_");
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


  /// Validate Field
  Future<bool> filledValidate({required BuildContext context})async{
    FocusScope.of(context).unfocus();

    if(selectedTitleValue == null){
      ToastCustom.showToast(msg: kSelectTitle);
    }else if(selectedGenderValue == null){
      ToastCustom.showToast(msg: kSelectGender);
    }else{
      isFirstName = TxtValidation.normalTextField(nameCtrl);
      isLastName = TxtValidation.normalTextField(lastNameCtrl);
      isStartTyping = TxtValidation.normalTextField(startTypingCtrl);
      if(!isStartTyping || !isFirstName && !isLastName){
        if(isHideStartTypingCTRL){
          isAddressLine1 = TxtValidation.normalTextField(nameCtrl);
          isAddressLine2 = TxtValidation.normalTextField(nameCtrl);
          isTownName = TxtValidation.normalTextField(nameCtrl);
          isPostCode = TxtValidation.normalTextField(nameCtrl);

          if(isStartTyping && !isAddressLine1 && !isAddressLine2 && !isTownName && !isPostCode){
            return true;
          }else{
            ToastCustom.showToast(msg: kEnterYourCorrectAddress);
          }
        }else{
          ToastCustom.showToast(msg: kEnterYourCorrectAddress);
        }
      }

    }
    update();
    return false;
  }

  /// On Tap Create Patient
  Future<void> onTapSaveAndCreate({required BuildContext context,required bool isScanPrescription})async{
    if(await filledValidate(context: context) == true){
      await createPatient(context: context,isScanPrescription: isScanPrescription);
    }
  }

  /// Create Order Api
  Future<DriverCreatePatientApiResponse?> createPatient({required BuildContext context,required bool isScanPrescription}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);


    Map<String, dynamic> dictparm = {
      "title": selectedTitleValue?.sendTitle,
      "gender": selectedGenderValue?.sendTitle,
      "first_name": nameCtrl.text.toString().trim(),
      "middle_name": middleNameCtrl.text.toString().trim(),
      "last_name": lastNameCtrl.text.toString().trim(),
      "address_line_1": addressLine1Ctrl.text.toString().trim(),
      "address_line_2": addressLine2Ctrl.text.toString().trim(),
      "town_name": townCtrl.text.toString().trim(),
      "post_code": postCodeCtrl.text.toString().trim(),
      "mobile_no": mobileCtrl.text.toString().trim(),
      "email_id": emailCtrl.text.toString().trim(),
      "nhs_number": nhsNoCtrl.text.toString().trim(),
      "country_id": "",
    };


    await apiCtrl.driverCreatePatientApi(context: context, url: WebApiConstant.CREATE_PATIENT_URL,
        dictParameter: dictparm).then((result) {
      if (result != null) {
        if (result.error != true) {
          try {
            if (result.error == false) {
              changeLoadingValue(false);
              changeSuccessValue(true);
              ToastCustom.showToast(msg: result.message ?? "");
              if(isScanPrescription){
                Get.back();
              }else{
                clearAllField();
              }
              isHideStartTypingCTRL = false;

            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog(result.message);
              ToastCustom.showToast(msg: result.message ?? "");
            }
          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
            ToastCustom.showToast(msg: result.message ?? "");
          }
        }
        else {
          changeSuccessValue(false);
          changeLoadingValue(false);
          PrintLog.printLog(result.message);
          ToastCustom.showToast(msg: result.message ?? "");
        }
      }
    }
    );
    update();
  }

  /// Process Scan Api
  // Future<ProcessScanApiResponse?> processScanApi({required BuildContext context}) async {
  //   changeEmptyValue(false);
  //   changeLoadingValue(true);
  //   changeNetworkValue(false);
  //   changeErrorValue(false);
  //   changeSuccessValue(false);
  //
  //
  //   Map<String, dynamic> dictparm = {
  //     "scan_type": "2",
  //     "pharmacyId": ,
  //
  //   };
  //
  //   await apiCtrl.driverProcessScanApi(context: context, url: WebApiConstant.REGISTEER_CUSTOMER_WITH_ORDER,
  //       dictParameter: dictparm).then((result) {
  //     if (result != null) {
  //       if (result.error != true) {
  //         try {
  //           if (result.error == false) {
  //             changeLoadingValue(false);
  //             changeSuccessValue(true);
  //             ToastCustom.showToast(msg: result.message ?? "");
  //             if(isScanPrescription){
  //
  //             }else{
  //               clearAllField();
  //             }
  //
  //           } else {
  //             changeLoadingValue(false);
  //             changeSuccessValue(false);
  //             PrintLog.printLog(result.message);
  //             ToastCustom.showToast(msg: result.message ?? "");
  //           }
  //         } catch (_) {
  //           changeSuccessValue(false);
  //           changeLoadingValue(false);
  //           changeErrorValue(true);
  //           PrintLog.printLog("Exception : $_");
  //           ToastCustom.showToast(msg: result.message ?? "");
  //         }
  //       }
  //       else {
  //         changeSuccessValue(false);
  //         changeLoadingValue(false);
  //         PrintLog.printLog(result.message);
  //         ToastCustom.showToast(msg: result.message ?? "");
  //       }
  //     }
  //   }
  //   );
  //   update();
  // }

  void changeSuccessValue(bool value) {
    isSuccess = value;
    update();
  }

  void changeLoadingValue(bool value) {
    isLoading = value;
    update();
  }

  void changeEmptyValue(bool value) {
    isEmpty = value;
    update();
  }

  void changeNetworkValue(bool value) {
    isNetworkError = value;
    update();
  }

  void changeErrorValue(bool value) {
    isError = value;
    update();
  }

}

class SurNameTitle{
<<<<<<< HEAD
  String showTitle;
  String sendTitle;

  SurNameTitle({required this.sendTitle,required this.showTitle});

=======
   String showTitle;
   String sendTitle;

   SurNameTitle({required this.sendTitle,required this.showTitle});

>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
}

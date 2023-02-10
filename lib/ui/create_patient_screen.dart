//@dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
// import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/ProcessScanResponse.dart';
import 'package:pharmdel_business/model/pmr_model.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/bulk_scan.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/delivery_schedule.dart';
import 'package:pharmdel_business/ui/driver_user_type/dashboard_driver.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:pharmdel_business/util/custom_loading.dart';
import 'package:pharmdel_business/util/permission_utils.dart';
import 'package:pharmdel_business/util/sentryExeptionHendler.dart';
import 'package:pharmdel_business/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class CreatePatientScreen extends StatefulWidget {
  String result = "";
  bool isBulkScan = false;
  String toteId;
  BulkScanMode callPickedApi;
  String bulkScanDate;
  String nursingHomeId;
  String driverId;
  String routeId;
  int parcelBoxId;
  callGetOrderApi callApi;

  CreatePatientScreen({Key key, this.result, this.isBulkScan, this.callPickedApi, this.toteId, this.nursingHomeId, this.bulkScanDate, this.driverId, this.routeId, this.parcelBoxId, this.callApi}) : super(key: key);

  @override
  State<CreatePatientScreen> createState() => _CreatePatientScreenState();
}

class _CreatePatientScreenState extends State<CreatePatientScreen> {
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
  PmrModel model;
  int endRouteId;
  int startRouteId;
  double startLat;
  double startLng;
  bool isStartRoute = false;

  OrderInfoResponse orderInfo;
  FlutterGooglePlacesSdk googlePlace;
  List<AutocompletePrediction> prediction = [];
  List<Dd> prescriptionList = List();
  List<PmrModel> pmrList = List();
  String titleValue;
  String genderValue;

  ApiCallFram _apiCallFram = ApiCallFram();

  String accessToken = "";
  int pharmacyId;

  bool otherPharmacy = false;

  @override
  void initState() {
    nhsNoCtrl.text = widget.result ?? "";
    getLocationData();
    init();
    super.initState();
  }

  @override
  void dispose() {
    CustomLoading();
    super.dispose();
  }

  getLocationData() async {
    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
      if (value) {
        var position = await GeolocatorPlatform.instance.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
        startLat = position.latitude;
        startLng = position.longitude;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: materialAppThemeColor,
          title: Text(
            "Create Patient",
            style: TextStyle(color: appBarTextColor),
          ),
          elevation: 1.0,
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  logger.i("8::::::::::::::::========>");

                  Navigator.pop(context, false);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: appBarTextColor,
                ),
              ))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                            height: 50,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1.0, color: Colors.grey[500]),
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: titleValue,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                underline: SizedBox(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    titleValue = newValue;
                                  });
                                },
                                items: <String>[
                                  "Mr",
                                  "Miss",
                                  "Mrs",
                                  "Ms",
                                  "Captain",
                                  "Dr",
                                  "Prof",
                                  "Rev",
                                  "Mx",
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Select Title",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                            height: 50,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1.0, color: Colors.grey[500]),
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: genderValue,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.black),
                                underline: SizedBox(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    genderValue = newValue;
                                  });
                                },
                                items: <String>[
                                  "Male",
                                  "Female",
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Select Gender",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 50.0,
                          child: TextFormField(
                            controller: nameCtrl,
                            keyboardType: TextInputType.name,
                            style: SemiBold16Style,
                            textInputAction: TextInputAction.next,
                            // onFieldSubmitted: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },
                            decoration: InputDecoration(
                              labelText: "First name",
                              labelStyle: Light14Style.copyWith(color: hintTextColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 50.0,
                          child: TextFormField(
                            controller: middleNameCtrl,
                            keyboardType: TextInputType.name,
                            style: SemiBold16Style,
                            textInputAction: TextInputAction.next,
                            // onFieldSubmitted: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },
                            decoration: InputDecoration(
                              labelText: "Middle name (optional)",
                              labelStyle: Light14Style.copyWith(color: hintTextColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 50.0,
                          child: TextFormField(
                            controller: lastNameCtrl,
                            keyboardType: TextInputType.name,
                            style: SemiBold16Style,
                            textInputAction: TextInputAction.next,
                            // onFieldSubmitted: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },
                            decoration: InputDecoration(
                              labelText: "Last name",
                              labelStyle: Light14Style.copyWith(color: hintTextColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: mobileCtrl,
                          keyboardType: TextInputType.phone,
                          style: SemiBold16Style,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // onFieldSubmitted: (v){
                          //   FocusScope.of(context).requestFocus(focusPin);
                          // },
                          decoration: InputDecoration(
                            labelText: "Mobile number (optional)",
                            labelStyle: Light14Style.copyWith(color: hintTextColor),
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.text,
                          style: SemiBold16Style,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (v){
                          //   FocusScope.of(context).requestFocus(focusPin);
                          // },
                          decoration: InputDecoration(
                            labelText: "Email (optional)",
                            labelStyle: Light14Style.copyWith(color: hintTextColor),
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: nhsNoCtrl,
                          keyboardType: TextInputType.number,
                          style: SemiBold16Style,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (v){
                          //   FocusScope.of(context).requestFocus(focusPin);
                          // },
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: "NHS number (optional)",
                            labelStyle: Light14Style.copyWith(color: hintTextColor),
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (addressLine1Ctrl.text.toString().trim() != null && addressLine1Ctrl.text.toString().trim().isNotEmpty)
                    Column(
                      children: [
                        TextFormField(
                          controller: addressLine1Ctrl,
                          keyboardType: TextInputType.name,
                          style: SemiBold16Style,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) async {
                            if (value != null && value.isNotEmpty) {
                              var result = await googlePlace.findAutocompletePredictions(value);
                              prediction = result != null
                                  ? result.predictions != null
                                      ? result.predictions
                                      : null
                                  : null;
                              setState(() {});
                            } else {
                              prediction = null;
                              setState(() {});
                            }
                          },
                          // onFieldSubmitted: (v){
                          //   FocusScope.of(context).requestFocus(focusPin);
                          // },
                          decoration: InputDecoration(
                            labelText: "Address line 1",
                            labelStyle: Light14Style.copyWith(color: hintTextColor),
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: addressLine2Ctrl,
                          keyboardType: TextInputType.name,
                          style: SemiBold16Style,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (v){
                          //   FocusScope.of(context).requestFocus(focusPin);
                          // },
                          decoration: InputDecoration(
                            labelText: "Address line 2",
                            labelStyle: Light14Style.copyWith(color: hintTextColor),
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: townCtrl,
                          keyboardType: TextInputType.name,
                          style: SemiBold16Style,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (v){
                          //   FocusScope.of(context).requestFocus(focusPin);
                          // },
                          decoration: InputDecoration(
                            labelText: "Town name",
                            labelStyle: Light14Style.copyWith(color: hintTextColor),
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: postCodeCtrl,
                          keyboardType: TextInputType.name,
                          style: SemiBold16Style,
                          textInputAction: TextInputAction.next,
                          // onFieldSubmitted: (v){
                          //   FocusScope.of(context).requestFocus(focusPin);
                          // },
                          decoration: InputDecoration(
                            labelText: "Post code",
                            labelStyle: Light14Style.copyWith(color: hintTextColor),
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (addressLine1Ctrl.text.toString().trim() == null || addressLine1Ctrl.text.toString().trim().isEmpty)
                    TextFormField(
                      controller: searchAddress,
                      keyboardType: TextInputType.name,
                      style: SemiBold16Style,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) async {
                        if (value != null && value.isNotEmpty) {
                          var result = await googlePlace.findAutocompletePredictions(value);
                          prediction = result != null
                              ? result.predictions != null
                                  ? result.predictions
                                  : null
                              : null;
                          setState(() {});
                        } else {
                          prediction = null;
                          setState(() {});
                        }
                      },
                      // onFieldSubmitted: (v){
                      //   FocusScope.of(context).requestFocus(focusPin);
                      // },
                      decoration: InputDecoration(
                        labelText: "Search Address",
                        labelStyle: Light14Style.copyWith(color: hintTextColor),
                        contentPadding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 50.0,
                  ),
     
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleValue == null || titleValue.isEmpty) {
                          Fluttertoast.showToast(msg: "Select title");
                        } else if (genderValue == null || genderValue.isEmpty) {
                          Fluttertoast.showToast(msg: "Select gender");
                        } else if (nameCtrl.text.toString().trim() == null || nameCtrl.text.toString().trim().isEmpty) {
                          Fluttertoast.showToast(msg: "Enter name");
                        } else if (lastNameCtrl.text.toString().trim() == null || lastNameCtrl.text.toString().trim().isEmpty) {
                          Fluttertoast.showToast(msg: "Enter last name");
                        } else if (addressLine1Ctrl.text.toString().trim() == null || addressLine1Ctrl.text.toString().trim().isEmpty) {
                          Fluttertoast.showToast(msg: "Enter address line 1");
                        } else if (townCtrl.text.toString().trim() == null || townCtrl.text.toString().trim().isEmpty) {
                          Fluttertoast.showToast(msg: "Enter town name");
                        } else if (postCodeCtrl.text.toString().trim() == null || postCodeCtrl.text.toString().trim().isEmpty) {
                          Fluttertoast.showToast(msg: "Enter postcode");
                        } else {
                          createPatient();
                        }
                      },
                      child: new Text(
                        "Save & Create",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.yetToStartColor,
                        foregroundColor: Colors.white.withOpacity(0.4),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (prediction != null && prediction.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 290.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 3.0, blurRadius: 5.0, offset: Offset(0, 5))]),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: prediction.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            getAddress("${prediction[index].primaryText ?? ""}" + " ${prediction[index].secondaryText ?? ""}");
                            prediction = null;
                            setState(() {});
                          },
                          title: Text("${prediction[index].primaryText ?? ""}" + " ${prediction[index].secondaryText ?? ""}"),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void getAddress(String result) async {
    addressLine1Ctrl.clear();
    addressLine2Ctrl.clear();
    townCtrl.clear();
    postCodeCtrl.clear();
    var result1 = await Geocoder.local.findAddressesFromQuery(result);
    logger.i("Locality: ${result1[0].locality}");
    logger.i("AddressLine: ${result1[0].addressLine}");
    logger.i("AdminArea: ${result1[0].adminArea}");
    logger.i("PostalCode: ${result1[0].postalCode}");
    logger.i("CountryCode: ${result1[0].countryCode}");
    logger.i("CountryName: ${result1[0].countryName}");
    logger.i("Coordinates: ${result1[0].coordinates}");
    logger.i("FeatureName: ${result1[0].featureName}");
    logger.i("SubAdminArea: ${result1[0].subAdminArea}");
    logger.i("SubLocality: ${result1[0].subLocality}");
    logger.i("SubThoroughFare: ${result1[0].subThoroughfare}");
    logger.i("ThoroughFare: ${result1[0].thoroughfare}");
    getAddressLine1(result1[0].addressLine, result1[0].postalCode ?? "");
    addressLine1Ctrl.text = result1[0].thoroughfare ?? getAddressLine1(result1[0].addressLine, result1[0].postalCode ?? "");
    townCtrl.text = "${result1[0].subAdminArea ?? ""}, " + "${result1[0].adminArea ?? ""}";
    postCodeCtrl.text = result1[0].postalCode;
    setState(() {});
  }

  getAddressLine1(String S, String postCode) {
    String kept = S.substring(0, S.indexOf(","));
    String remainder = S.substring(S.indexOf(",") + 1, S.length);
    addressLine2Ctrl.text = getAddressLine2(remainder).contains(postCode) ? getAddressLine2(remainder).replaceAll(postCode, "") : getAddressLine2(remainder);
    return kept;
  }

  String getAddressLine2(String S) {
    String remainder = S.substring(0, S.contains(",") ? S.indexOf(",") : S.length);
    return remainder;
  }

  void init() async {
    googlePlace = FlutterGooglePlacesSdk("AIzaSyABVHBSqEHd7dYsEmV3hDOq9dkl5WbJuTw");
    await SharedPreferences.getInstance().then((value) async {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      pharmacyId = value.getInt(WebConstant.PHARMACY_ID) ?? 0;
      endRouteId = value.getInt(WebConstant.END_ROUTE_AT) ?? 0;
      if (widget.toteId == null || widget.toteId.isEmpty)
        isStartRoute = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      else
        isStartRoute = false;
      startRouteId = value.getInt(WebConstant.START_ROUTE_FROM) ?? 0;
    });
  }

  Future<void> postDataAndVerifyUser() async {
    // await ProgressDialog(context, isDismissible: false).show();
    model = PmrModel();
    Xml xml = Xml();
    Sc sc = Sc();
    Pa patientInformation = Pa();
    List<Dd> dd = List();
    model.xml = xml;
    model.xml.dd = dd;
    model.xml.sc = sc;
    model.xml.patientInformation = patientInformation;
    await CustomLoading().showLoadingDialog(context, true);
    // model.xml.patientInformation.nhs = "";
    String url = WebConstant.REGISTER_CUSTOMER_WITH_ORDER + "?scan_type=2&pharmacyId=$pharmacyId";
    logger.i(url);
    _apiCallFram.postFormDataAPI(url, accessToken, widget.result, context).then((response) async {
      // ProgressDialog(context, isDismissible: false).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          logger.i("${response.body}");

          if (response != null && response.body != null && response.body == "Unauthenticated") {
            Fluttertoast.showToast(msg: "Authentication Failed. Login again");
              CustomLoading().showLoadingDialog(context, false);
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            prefs.remove('userId');
            prefs.remove('name');
            prefs.remove('email');
            prefs.remove('mobile');
            prefs.remove('route_list');
            logger.i("7::::::::::::::::========>");

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(),
                ),
                ModalRoute.withName('/login_screen'));
            return;
          }
          Map<String, Object> data = json.decode(response.body);
          if (data["isExist"] != null && data["isExist"] != 1 && data["error"] == false) {
            if (data["error"] == false) {
              setState(() {
                //Navigator.of(context).pop(true);
                // print(data);
                ProcessScanResponse response1 = ProcessScanResponse.fromJson(data);

                if (response1 != null && response1.data != null && response1.data.orderInfo != null && response1.data.orderInfo.patientsList != null && response1.data.orderInfo.patientsList.userId.isNotEmpty && response1.data.orderInfo.patientsList.userId[0].toString().isNotEmpty) {
                  // if (response1.data.orderInfo.patientsList.userId.length ==
                  //     1) {
                  otherPharmacy = response1.data.orderInfo.otherpharmacy != null ? response1.data.orderInfo.otherpharmacy : false;
                  if (response1.data.orderInfo.nhs_matched == true) {
                    orderInfo = response1.data.orderInfo;

                    model.xml.alt_address = orderInfo.patientsList.alt_address != null ? orderInfo.patientsList.alt_address[0] : "";

                    model.xml.patientInformation.firstName = orderInfo.firstName.s0 != null ? orderInfo.firstName.s0 : "";

                    model.xml.patientInformation.middleName = orderInfo.middleName != null
                        ? orderInfo.middleName.s0 != null
                            ? orderInfo.middleName.s0
                            : ""
                        : "";

                    model.xml.patientInformation.lastName = orderInfo.lastName != null
                        ? orderInfo.lastName.s0 != null
                            ? orderInfo.lastName.s0
                            : ""
                        : "";

                    model.xml.patientInformation.address = orderInfo.address != null
                        ? orderInfo.address.s0 != null
                            ? orderInfo.address.s0 ?? ""
                            : ""
                        : "";

                    model.xml.patientInformation.nhs = orderInfo.nhsNumber != null
                        ? orderInfo.nhsNumber.s0 != null
                            ? orderInfo.nhsNumber.s0 ?? ""
                            : ""
                        : "";

                    model.xml.patientInformation.nursing_home_id = orderInfo.nursing_home_id != null
                        ? orderInfo.nursing_home_id.s0 != null
                            ? orderInfo.nursing_home_id.s0 ?? ""
                            : ""
                        : "";

                    model.xml.patientInformation.mobileNo = orderInfo.mobile_no_new != null ? orderInfo.mobile_no_new : "";
                    model.xml.patientInformation.email_id = orderInfo.email_id != null ? orderInfo.email_id : "";
                    model.xml.patientInformation.postCode = orderInfo.postCode != null
                        ? orderInfo.postCode.s0 != null
                            ? orderInfo.postCode.s0 ?? ""
                            : orderInfo.postCode.s0
                        : "";
                    model.xml.patientInformation.dob = orderInfo.dob != null ? orderInfo.dob : "";

                    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_delivery_route != null && orderInfo.patientsList.default_delivery_route.isNotEmpty && orderInfo.patientsList.default_delivery_route.length > 0) {
                      orderInfo.default_delivery_route = orderInfo.patientsList.default_delivery_route[0];
                    }

                    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_delivery_type != null && orderInfo.patientsList.default_delivery_type.isNotEmpty && orderInfo.patientsList.default_delivery_type.length > 0) {
                      orderInfo.default_delivery_type = orderInfo.patientsList.default_delivery_type[0];
                    }

                    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_delivery_note != null && orderInfo.patientsList.default_delivery_note.isNotEmpty && orderInfo.patientsList.default_delivery_note.length > 0) {
                      orderInfo.default_delivery_note = orderInfo.patientsList.default_delivery_note[0];
                    }

                    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_branch_note != null && orderInfo.patientsList.default_branch_note.isNotEmpty && orderInfo.patientsList.default_branch_note.length > 0) {
                      orderInfo.default_branch_note = orderInfo.patientsList.default_branch_note[0];
                    }

                    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_surgery_note != null && orderInfo.patientsList.default_surgery_note.isNotEmpty && orderInfo.patientsList.default_surgery_note.length > 0) {
                      orderInfo.default_surgery_note = orderInfo.patientsList.default_surgery_note[0];
                    }

                    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_service != null && orderInfo.patientsList.default_service.isNotEmpty && orderInfo.patientsList.default_service.length > 0) {
                      orderInfo.default_service = orderInfo.patientsList.default_service[0];
                    }
                    pmrList.add(model);
                    prescriptionList.addAll(model.xml.dd);
                    if (widget.isBulkScan) {
                      createOrder();
                    } else
                      logger.i("6::::::::::::::::========>");

                    Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliverySchedule(
                                    prescriptionList: prescriptionList,
                                    pmrList: pmrList,
                                    callApi: widget.callPickedApi,
                                    type: "2",
                                    amount: "0.0",
                                    orderInof: orderInfo,
                                    otherPharmacy: otherPharmacy,
                                    pharmacyId: int.tryParse(pharmacyId.toString()),
                                  )));
                  }
                }
                // if (widget.isAssignSelf) {
                //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AssignToSelf(prescriptionList: widget.prescriptionList, pmrList: widget.pmrList,)));
                // } else {
                //   Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => DeliverySchedule(
                //                 prescriptionList: widget.prescriptionList,
                //                 pmrList: widget.pmrList,
                //               )));
                // }
              });
            } else {
              Fluttertoast.showToast(msg: data["message"]);
              await CustomLoading().showLoadingDialog(context, false);
            }
          } else {
            showDialog<void>(
              context: context,

              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context2) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: Text('Pharmdel'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          //Text('This is a demo alert dialog.'),
                          Text(data["message"]),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Ok',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        onTap: () {
                          if(mounted) {
                            logger.i("5::::::::::::::::========>");

                            Navigator.of(context2).pop();
                            Navigator.of(context).pop(false);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      } catch (e, stackTrace) {
        // print(e);
        SentryExemption.sentryExemption(e, stackTrace);
        logger.i(e);
        Fluttertoast.showToast(msg: "Something went wrong. Please try again...");
        await CustomLoading().showLoadingDialog(context, false);
      }
    });
  }

  Future<void> createPatient() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      return;
    }
    String gender = "M";
    if (genderValue != null && genderValue.isNotEmpty) if (genderValue == "Female") {
      gender = "F";
    }
    String tittle = "";
    if (titleValue == "Mr") {
      tittle = "M";
    } else if (titleValue == "Miss") {
      tittle = "S";
    } else if (titleValue == "Mrs") {
      tittle = "F";
    } else if (titleValue == "Ms") {
      tittle = "Q";
    } else if (titleValue == "Captain") {
      tittle = "C";
    } else if (titleValue == "Dr") {
      tittle = "D";
    } else if (titleValue == "Prof") {
      tittle = "P";
    } else if (titleValue == "Rev") {
      tittle = "R";
    } else if (titleValue == "Mx") {
      tittle = "X";
    }
    Map<String, dynamic> dictPram = {
      "title": tittle,
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
      "gender": gender,
    };
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.CREATE_PATIENT_URL);
    _apiCallFram.postDataAPI(WebConstant.CREATE_PATIENT_URL, accessToken, dictPram, context).then((response) async {
      // CustomLoading().showLoadingDialog(context, false);
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          Fluttertoast.showToast(msg: "Authentication Failed. Login again");
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          prefs.remove('userId');
          prefs.remove('name');
          prefs.remove('email');
          prefs.remove('mobile');
          prefs.remove('route_list');
          logger.i("4::::::::::::::::========>");

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              ModalRoute.withName('/login_screen'));
          return;
        }
        try {
          if (response != null) {
            if (response.body != null && response.body.isNotEmpty) {
              logger.i("Response Body : ${response.body}");
              var data = json.decode(response.body);
              if (!data["error"]) {
                logger.i("log");
                if (widget.result != null && widget.result.isNotEmpty)
                  await postDataAndVerifyUser();
                else {
                  titleValue = null;
                  genderValue = null;
                  nameCtrl.clear();
                  middleNameCtrl.clear();
                  lastNameCtrl.clear();
                  mobileCtrl.clear();
                  emailCtrl.clear();
                  nhsNoCtrl.clear();
                  addressLine1Ctrl.clear();
                  addressLine2Ctrl.clear();
                  townCtrl.clear();
                  postCodeCtrl.clear();
                }
               await CustomLoading().showLoadingDialog(context, false);
                if(mounted)
                Navigator.pop(context);
                logger.i("3::::::::::::::::========>");

              } else if (data["error"]) {
                CustomLoading().showLoadingDialog(context, false);
                Fluttertoast.showToast(msg: data["message"]);
              }
            }
          }
        } catch (_, stackTrace) {
          // print(_);
          SentryExemption.sentryExemption(_, stackTrace);
          logger.i(_);
          Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
          // progressDialog.hide();
          await CustomLoading().showLoadingDialog(context, false);
          // await CustomLoading().showLoadingDialog(context, true);
        }
      } catch (_, stackTrace) {
        logger.i(_);
        SentryExemption.sentryExemption(_, stackTrace);
        await CustomLoading().showLoadingDialog(context, false);
        // print(_);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }

  Future<void> createOrder() async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    // model.xml.patientInformation.nhs = "";
    String url = WebConstant.UUDATE_CUSTOMER_WITH_ORDER;
    logger.i(url);
    String gender = "M";
    if (pmrList[0].xml.patientInformation.salutation != null) if (pmrList[0].xml.patientInformation.salutation.endsWith("Mrs") || pmrList[0].xml.patientInformation.salutation.endsWith("Miss") || pmrList[0].xml.patientInformation.salutation.endsWith("Ms")) {
      gender = "F";
    }
    String tittle = "";
    if (pmrList[0].xml.patientInformation.salutation == "Mr") {
      tittle = "M";
    } else if (pmrList[0].xml.patientInformation.salutation == "Miss") {
      tittle = "S";
    } else if (pmrList[0].xml.patientInformation.salutation == "Mrs") {
      tittle = "F";
    } else if (pmrList[0].xml.patientInformation.salutation == "Ms") {
      tittle = "Q";
    } else if (pmrList[0].xml.patientInformation.salutation == "Captain") {
      tittle = "C";
    } else if (pmrList[0].xml.patientInformation.salutation == "Dr") {
      tittle = "D";
    } else if (pmrList[0].xml.patientInformation.salutation == "Prof") {
      tittle = "P";
    } else if (pmrList[0].xml.patientInformation.salutation == "Rev") {
      tittle = "R";
    } else if (pmrList[0].xml.patientInformation.salutation == "Mx") {
      tittle = "X";
    }
    String dob = pmrList[0].xml.customerId == 0 && pmrList[0].xml.patientInformation != null && pmrList[0].xml.patientInformation.dob != null ? "${pmrList[0].xml.patientInformation.dob.isNotEmpty ? DateFormat('dd/MM/yyyy').format(DateTime.parse(pmrList[0].xml.patientInformation.dob)) : "" ?? ""}" : pmrList[0].xml.patientInformation.dob;
    Map<String, dynamic> data = {
      "order_type": "scan",
      "pharmacyId": pharmacyId,
      "endRouteId": isStartRoute ? "$endRouteId" : "0",
      "startRouteId": isStartRoute ? "$startRouteId" : "0",
      "nursing_home_id": widget.nursingHomeId,
      "tote_box_id": widget.toteId,
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
      "titan_scan_info": orderInfo.titanScaInfo != null ? orderInfo.titanScaInfo : "",
      "amount": "0",
      "exemption": "",
      //_exemptSelected ? selectedExemptionId != null ? selectedExemptionId : 0 : 0,
      "paymentStatus": "",
      "bag_size": "",
      "patient_id": orderInfo.userId ?? 0,
      "pr_id": pmrList[0].xml.sc != null ? pmrList[0].xml.sc.id ?? "" : "",
      "lat": "",
      //na
      "lng": "",
      //na
      "parcel_box_id": widget.parcelBoxId != null ? "${widget.parcelBoxId}" : "0",
      "surgery_name": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.companyName ?? "" : "",
      "surgery": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.i ?? "" : "",
      "email_id": "",
      "mobile_no_2": pmrList[0].xml.patientInformation.mobileNo ?? "",
      "dob": "$dob",
      "nhs_number": pmrList[0].xml.patientInformation.nhs ?? "",
      "title": tittle ?? "",
      "first_name": pmrList[0].xml.patientInformation.firstName ?? "",
      "middle_name": pmrList[0].xml.patientInformation.middleName != null && pmrList[0].xml.patientInformation.middleName != "null" ? pmrList[0].xml.patientInformation.middleName : "",
      "last_name": pmrList[0].xml.patientInformation.lastName != null ? (pmrList[0].xml.patientInformation.lastName != "null" ? pmrList[0].xml.patientInformation.lastName : "") : "",
      "address_line_1": pmrList[0].xml.patientInformation.address ?? "",
      "country_id": "",
      "post_code": pmrList[0].xml.patientInformation.postCode ?? "",
      "gender": gender,
      "preferred_contact_type": "",
      "delivery_type": "Delivery",
      "driver_id": widget.driverId,
      "delivery_route": widget.routeId,
      "storage_type_cd": "f",
      "storage_type_fr": "f",
      "delivery_status": isStartRoute
          ? "4"
          : widget.toteId == null || widget.toteId.isEmpty
              ? "8"
              : "2",
      "shelf": "",
      "delivery_service": orderInfo.default_service,
      "doctor_name": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.doctorName ?? "" : "",
      "doctor_address": pmrList[0].xml.doctorInformation != null ? pmrList[0].xml.doctorInformation.address ?? "" : "",
      "new_delivery_notes": "",
      "existing_delivery_notes": orderInfo != null && orderInfo.default_delivery_note != null && orderInfo.default_delivery_note != "" ? orderInfo.default_delivery_note : "",
      "branch_notes": "",
      "surgery_notes": "",
      "medicine_name": [],
      "delivery_date": widget.bulkScanDate,
      "prescription_images": [],
    };
    _apiCallFram.postDataAPI(url, accessToken, data, context).then((response) async {
      // await ProgressDialog(context, isDismissible: false).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          logger.i("${response.body}");
          Map<String, Object> data = json.decode(response.body);
          if (data["error"] == false) {
            await CustomLoading().showLoadingDialog(context, false);
logger.i("1::::::::::::::::========>");
            if(mounted)
            Navigator.of(context).pop(false);
            if (widget.toteId == null || widget.toteId.isEmpty) {
              widget.callPickedApi.isSelected(true);
            } else
              widget.callApi.isCallApi(true);
          }
        }
      } catch (e, stackTrace) {
        // print(e);
        SentryExemption.sentryExemption(e, stackTrace);
        logger.i(e);
        Fluttertoast.showToast(msg: "Something went wrong. Please try again...");
        await CustomLoading().showLoadingDialog(context, false);
        if(mounted)
          logger.i("2::::::::::::::::========>");

        Navigator.of(context).pop(true);
      }
    });
  }
}

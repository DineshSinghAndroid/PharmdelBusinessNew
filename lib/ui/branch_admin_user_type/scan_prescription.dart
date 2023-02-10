// @dart=2.9

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/Notification.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/ProcessScanResponse.dart';
import 'package:pharmdel_business/model/pmr_model.dart';
import 'package:pharmdel_business/ui/create_patient_screen.dart';
import 'package:pharmdel_business/ui/driver_user_type/dashboard_driver.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';

import '../../main.dart';
import '../../util/constants.dart';
import '../../util/custom_loading.dart';
import '../../util/permission_utils.dart';
import '../../util/sentryExeptionHendler.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import 'PataintList.dart';
import 'bulk_scan.dart';
import 'customer_list.dart';
import 'delivery_schedule.dart';

class Scan_Prescription extends StatefulWidget {
  List<Dd> prescriptionList = List();
  List<PmrModel> pmrList = List();
  bool isAssignSelf = false;
  bool isBulkScan;
  String type;
  String driverId;
  String routeId;
  String bulkScanDate;
  String nursingHomeId;
  int parcelBoxId;
  String toteId;
  int pharmacyId;
  bool isRouteStart;
  callGetOrderApi callApi;
  BulkScanMode callPickedApi;

  Scan_Prescription({Key key, this.prescriptionList, this.pmrList, this.isAssignSelf, this.parcelBoxId, this.routeId, this.callApi, this.driverId, this.nursingHomeId, this.callPickedApi, this.isRouteStart, this.toteId, this.bulkScanDate, this.type, this.isBulkScan, this.pharmacyId}) : super(key: key);

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<Scan_Prescription> implements CustomerSelectedListner {
  bool noRecordFound = false;
  bool otherPharmacy = false;
  List<NotificationList> dataList = [];

  ApiCallFram _apiCallFram = ApiCallFram();

  String accessToken = "";

  var userType;

  String result;

  PmrModel model;

  OrderInfoResponse orderInfo;

  String amount = "";
  String qrType = "";
  String driverType = "";
  int endRouteId;
  int startRouteId;
  double startLat;
  double startLng;
  bool isStartRoute = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) async {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      userType = value.getString(WebConstant.USER_TYPE) ?? "";
      endRouteId = value.getInt(WebConstant.END_ROUTE_AT) ?? 0;
      if (widget.toteId == null || widget.toteId.isEmpty)
        isStartRoute = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      else
        isStartRoute = false;
      startRouteId = value.getInt(WebConstant.START_ROUTE_FROM) ?? 0;
      driverType = value.getString(WebConstant.DRIVER_TYPE) ?? "";
      getLocationData();
      _buildQrView(context);
    });
    if (widget.pharmacyId == null) {
      widget.pharmacyId = 0;
    }
    checkLastTime(context);
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

  ///position code lat lng

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: materialAppThemeColor,
        title: Text(
          "Customer List",
          style: TextStyle(color: appBarTextColor),
        ),
        // backgroundColor: CustomColors.darkPinkColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: appBarTextColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.userId != null && orderInfo.patientsList.userId.length > 0 && orderInfo.patientsList.userId[0].toString().isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderInfo != null ? orderInfo.patientsList.userId.length : 0,
                        itemBuilder: (context, i) {
                          return CustomerListWidgetNew(orderInfo, i, this);
                        }),
                  )
                : SizedBox(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MaterialButton(
                onPressed: () {
                  if (widget.type == "4" || widget.type == "6" || widget.type == "3" || widget.type == "2") {
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
                    //
                    // model.xml.patientInformation.firstName =
                    //     orderInfo.patientsList != null
                    //         ? orderInfo.patientsList.customerName[0]
                    //         : model.xml.patientInformation.firstName;

                    model.xml.patientInformation.address = orderInfo.patientsList.address != null ? orderInfo.patientsList.address[0] ?? model.xml.patientInformation.address : model.xml.patientInformation.address;

                    model.xml.patientInformation.nhs = orderInfo.nhsNumber != null
                        ? orderInfo.nhsNumber.s0 != null
                            ? orderInfo.nhsNumber.s0
                            : ""
                        : "";

                    model.xml.patientInformation.mobileNo = orderInfo.mobile_no_new != null ? orderInfo.mobile_no_new : "";
                    model.xml.patientInformation.email_id = orderInfo.email_id != null ? orderInfo.email_id : "";

                    model.xml.patientInformation.postCode = orderInfo.postCode != null ? orderInfo.postCode.s0 ?? "" : orderInfo.postCode.s0;
                    model.xml.patientInformation.dob = "";
                    if (widget.type == "4") {
                      if (!result.startsWith("pharm") && result.contains(";")) {
                        model.xml.sc.id = result.split(";")[1];
                        amount = result.split(";").last;
                      }
                      // else {
                      //   model.xml.sc.id = result;
                      // }
                    } else {
                      amount = "";
                    }
                  }
                  model.xml.alt_address = "";
                  model.xml.customerId = 0;
                  model.xml.isAddNewCustomer = true;
                  widget.pmrList.add(model);
                  widget.prescriptionList.addAll(model.xml.dd);

                  // print(model.xml.patientInformation.dob);
                  if (widget.isBulkScan) {
                    createOrder();
                  } else
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliverySchedule(
                                  prescriptionList: widget.prescriptionList,
                                  callApi: widget.callPickedApi,
                                  pmrList: widget.pmrList,
                                  type: qrType,
                                  orderInof: orderInfo,
                                  amount: amount,
                                  otherPharmacy: otherPharmacy,
                                  pharmacyId: widget.pharmacyId,
                                )));
                },
                color: Colors.orange,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      "Add New Customer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  @override
  void onClickListner() {}

  @override
  void isSelected(dynamic userid, dynamic position, dynamic alt_address) {
    model.xml.customerId = userid;
    model.xml.alt_address = alt_address;
    // model.xml.patientInformation.nhs = orderInfo.patientsList.nhsNumber[position].toString();
    model.xml.patientInformation.firstName = orderInfo.patientsList.customerName[position];
    model.xml.patientInformation.dob = orderInfo.patientsList.dob[position] ?? model.xml.patientInformation.dob;
    model.xml.patientInformation.address = orderInfo.patientsList.address != null ? orderInfo.patientsList.address[position] ?? model.xml.patientInformation.address : model.xml.patientInformation.address;

    model.xml.patientInformation.nhs = orderInfo.patientsList.address != null ? orderInfo.patientsList.nhsNumber[position] ?? model.xml.patientInformation.nhs : model.xml.patientInformation.nhs;

    model.xml.patientInformation.nursing_home_id = orderInfo.patientsList.nursing_home_id != null ? orderInfo.patientsList.nursing_home_id[position].toString() ?? model.xml.patientInformation.nursing_home_id : model.xml.patientInformation.nursing_home_id;

    logger.i(model.xml.patientInformation.nursing_home_id);
    model.xml.patientInformation.postCode = orderInfo.postCode != null ? orderInfo.postCode.s0 ?? "" : orderInfo.postCode.s0;
    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_delivery_route != null && orderInfo.patientsList.default_delivery_route.isNotEmpty) {
      orderInfo.default_delivery_route = orderInfo.patientsList.default_delivery_route[position];
    }

    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_delivery_type != null && orderInfo.patientsList.default_delivery_type.isNotEmpty) {
      orderInfo.default_delivery_type = orderInfo.patientsList.default_delivery_type[position];
    }

    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_delivery_note != null && orderInfo.patientsList.default_delivery_note.isNotEmpty) {
      orderInfo.default_delivery_note = orderInfo.patientsList.default_delivery_note[position];
    }

    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_branch_note != null && orderInfo.patientsList.default_branch_note.isNotEmpty) {
      orderInfo.default_branch_note = orderInfo.patientsList.default_branch_note[position];
    }

    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_surgery_note != null && orderInfo.patientsList.default_surgery_note.isNotEmpty) {
      orderInfo.default_surgery_note = orderInfo.patientsList.default_surgery_note[position];
    }

    if (orderInfo != null && orderInfo.patientsList != null && orderInfo.patientsList.default_service != null && orderInfo.patientsList.default_service.isNotEmpty) {
      orderInfo.default_service = orderInfo.patientsList.default_service[position];
    }

    widget.pmrList.add(model);
    widget.prescriptionList.addAll(model.xml.dd);
    if (widget.isBulkScan) {
      createOrder();
    } else
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DeliverySchedule(
                    prescriptionList: widget.prescriptionList,
                    pmrList: widget.pmrList,
                    callApi: widget.callPickedApi,
                    type: qrType,
                    orderInof: orderInfo,
                    amount: amount,
                    otherPharmacy: otherPharmacy,
                    pharmacyId: widget.pharmacyId,
                  )));
  }

  Future<Widget> _buildQrView(BuildContext context) async {
    try {
      var barcodeScanRes;

      // barcodeScanRes = FlutterBarcodeScanner.getBarcodeStreamReceiver(
      //     '#ff6666', 'Cancel', true, ScanMode.BARCODE)
      //     .listen((barcodeScanRes) => print(barcodeScanRes));
      // logger.i("ENTERED IN BARCODE BLOCK");

      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);

      qrType = widget.type;
      logger.i("QR Type : ${barcodeScanRes}");

      if (barcodeScanRes != "-1") {
        if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.contains("-") && barcodeScanRes.split("-").length > 4) {
          qrType = "4";
          widget.type = "4";
          loadPrescription(barcodeScanRes);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("pharm")) {
          qrType = "5";
          widget.type = "5";
          loadPrescription(barcodeScanRes);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("<xml>")) {
          widget.type = "1";
          qrType = "1";
          loadPrescription(barcodeScanRes);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.startsWith("PSL") && barcodeScanRes.contains(";") && barcodeScanRes.split(";").length > 2) {
          widget.type = "4";
          widget.type = "4";
          qrType = "4";
          loadPrescription(barcodeScanRes);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.contains(";") && barcodeScanRes.split(";").length > 2) {
          widget.type = "6";
          qrType = "6";
          loadPrescription(barcodeScanRes);
        } else if (barcodeScanRes != null && int.tryParse(barcodeScanRes) != null) {
          widget.type = "2";
          qrType = "2";
          loadPrescription(barcodeScanRes);
        } else if (barcodeScanRes != null && barcodeScanRes.isNotEmpty && barcodeScanRes.length > 2) {
          widget.type = "3";
          qrType = "3";
          loadPrescription(barcodeScanRes);
        } else {
          Fluttertoast.showToast(msg: "QR data not available !");
          Navigator.of(context).pop(true);
        }
      } else if (barcodeScanRes == "-1") {
        if (driverType != Constants.sharedDriver) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatainttList(
                isBulkScan: widget.isBulkScan,
                routeId: widget.routeId,
                driverId: widget.driverId,
                callApi: widget.callApi,
                parcelBoxId: widget.parcelBoxId,
                isRouteStart: isStartRoute,
                callPickedApi: widget.callPickedApi,
                bulkScanDate: widget.bulkScanDate,
                toteId: widget.toteId,
                nursingHomeId: widget.nursingHomeId,
              ),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "Data not fetching. Plz try again !");
          Navigator.of(context).pop(true);
        }
      } else {
        Fluttertoast.showToast(msg: "Data not fetching. Plz try again !");
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      logger.e("UNABLE TO PRINT ");

      String barcodeScanRes;
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);

      logger.i("Exception....$_....");
    }
  }

  void loadPrescription(String result1) {
    result = result1;
    bool isAddPrescription = true;
    logger.i("QR Type 1: ${result1}");
    logger.i("QR Type 2: ${widget.type}");
    try {
      if (widget.type == "1") {
        final parser = Xml2Json();
        parser.parse(result);
        var json = parser.toGData();
        model = pmrModelFromJson(json);

        for (PmrModel pmrModel in widget.pmrList) {
          if (pmrModel.xml.patientInformation.nhs != model.xml.patientInformation.nhs) {
            Fluttertoast.showToast(msg: "Different patient prescriptions, please check and try again!");
            isAddPrescription = false;
            break;
          }
          if (pmrModel.xml.sc.id == model.xml.sc.id) {
            Fluttertoast.showToast(msg: "This prescription already added!");
            isAddPrescription = false;
            break;
          }
        }
        if (isAddPrescription) {
          postDataAndVerifyUser(model);
        } else {
          Navigator.of(context).pop(true);
        }
      } else if (widget.type == "4" || widget.type == "5" || widget.type == "6") {
        model = PmrModel();
        Xml xml = Xml();
        Sc sc = Sc();
        Pa patientInformation = Pa();
        List<Dd> dd = List();
        model.xml = xml;
        model.xml.dd = dd;
        model.xml.sc = sc;
        model.xml.patientInformation = patientInformation;
        if (widget.type == "4") {
          if (result.contains(";")) {
            logger.i("print_scan ${result1}");
            model.xml.sc.id = result.split(";")[1] ?? "";
            amount = result.split(";").last;
          }
        } else if (widget.type == "5") {
          model.xml.sc.id = result;
        }
        postDataAndVerifyUser(model);
      } else if (widget.type == "3" || widget.type == "2") {
        model = PmrModel();
        Xml xml = Xml();
        Sc sc = Sc();
        Pa patientInformation = Pa();
        List<Dd> dd = List();
        model.xml = xml;
        model.xml.dd = dd;
        model.xml.sc = sc;
        model.xml.patientInformation = patientInformation;
        amount = "";
        postDataAndVerifyUser(model);
      }
    } catch (_, stackTrace) {
      logger.i(_);
      SentryExemption.sentryExemption(_, stackTrace);
      Fluttertoast.showToast(msg: "Format not correct!");
      Navigator.of(context).pop(true);
      // logger.i(".Exception.............................................${_}....");
    }
  }

  Future<void> postDataAndVerifyUser(PmrModel model) async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    // model.xml.patientInformation.nhs = "";
    String url = WebConstant.REGISTER_CUSTOMER_WITH_ORDER + "?scan_type=${qrType}&pharmacyId=${widget.pharmacyId}";
    logger.i(url);
    _apiCallFram.postFormDataAPI(url, accessToken, result, context).then((response) async {
      // ProgressDialog(context, isDismissible: false).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          logger.i("${response.body}");

          if (response != null && response.body != null && response.body == "Unauthenticated") {
            Fluttertoast.showToast(msg: "Authentication Failed. Login again");
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            prefs.remove('userId');
            prefs.remove('name');
            prefs.remove('email');
            prefs.remove('mobile');
            prefs.remove('route_list');
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
                logger.i("testteeeee");

                if (response1 != null && response1.data != null && response1.data.orderInfo != null && response1.data.orderInfo.patientsList != null && response1.data.orderInfo.patientsList.userId.isNotEmpty && response1.data.orderInfo.patientsList.userId[0].toString().isNotEmpty) {
                  // if (response1.data.orderInfo.patientsList.userId.length ==
                  //     1) {
                  otherPharmacy = response1.data.orderInfo.otherpharmacy != null ? response1.data.orderInfo.otherpharmacy : false;
                  if (response1.data.orderInfo.nhs_matched == true || widget.type == "5") {
                    orderInfo = response1.data.orderInfo;

                    model.xml.customerId = orderInfo.patientsList.userId[0];

                    model.xml.alt_address = orderInfo.patientsList.alt_address != null ? orderInfo.patientsList.alt_address[0] : "";

                    if (widget.type == "4" || widget.type == "3" || widget.type == "5" || widget.type == "6" || widget.type == "2") {
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
                      if (widget.type == "4") {
                        if (!result.startsWith("pharm") && result.contains(";")) {
                          model.xml.sc.id = result.split(";")[1];
                        } else {
                          model.xml.sc.id = result;
                        }
                      }
                    } else {
                      // model.xml.patientInformation.nhs = orderInfo.patientsList.nhsNumber[0];
                      model.xml.patientInformation.firstName = orderInfo.patientsList != null ? orderInfo.patientsList.customerName[0] : model.xml.patientInformation.firstName;

                      model.xml.patientInformation.dob = orderInfo.patientsList.dob != null ? orderInfo.patientsList.dob[0] ?? model.xml.patientInformation.dob : model.xml.patientInformation.dob;
                      model.xml.patientInformation.address = orderInfo.patientsList.address != null ? orderInfo.patientsList.address[0] ?? model.xml.patientInformation.address : model.xml.patientInformation.address;
                      model.xml.patientInformation.nhs = orderInfo.patientsList.address != null ? orderInfo.patientsList.nhsNumber[0] ?? model.xml.patientInformation.nhs : model.xml.patientInformation.nhs;

                      model.xml.patientInformation.nursing_home_id = orderInfo.patientsList.nursing_home_id != null ? orderInfo.patientsList.nursing_home_id[0] ?? model.xml.patientInformation.nursing_home_id : model.xml.patientInformation.nursing_home_id;

                      model.xml.patientInformation.postCode = orderInfo.postCode != null ? orderInfo.postCode.s0 ?? "" : orderInfo.postCode.s0;
                    }

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
                    widget.pmrList.add(model);
                    widget.prescriptionList.addAll(model.xml.dd);
                    if (widget.isBulkScan) {
                      createOrder();
                    } else
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliverySchedule(
                                    prescriptionList: widget.prescriptionList,
                                    pmrList: widget.pmrList,
                                    callApi: widget.callPickedApi,
                                    type: qrType,
                                    amount: amount,
                                    orderInof: orderInfo,
                                    otherPharmacy: otherPharmacy,
                                    pharmacyId: widget.pharmacyId,
                                  )));
                  } else if (response1.data.orderInfo.patientsList.userId.length > 0) {
                    orderInfo = response1.data.orderInfo;
                    // showCustomerList(context, response1.data.orderInfo, model);
                  }
                } else {
                  orderInfo = response1.data.orderInfo;
                  userNotExitsDialog();
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
              userNotExitsDialog();
            }
          } else {
            showDialog<void>(
              context: context,

              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context2) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: Text('Pharmdel '),
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
                          Navigator.of(context2).pop();
                          Navigator.of(context).pop(false);
                        },
                      ),
                      if (data["isExist"] == 1)
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Create',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context2);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatePatientScreen(
                                          result: result,
                                          isBulkScan: widget.isBulkScan,
                                          routeId: widget.routeId,
                                          driverId: widget.driverId,
                                          callApi: widget.callApi,
                                          parcelBoxId: widget.parcelBoxId,
                                          callPickedApi: widget.callPickedApi,
                                          bulkScanDate: widget.bulkScanDate,
                                          toteId: widget.toteId,
                                          nursingHomeId: widget.nursingHomeId,
                                        )));
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
        Navigator.of(context).pop(true);
      }
    });
  }

  void userNotExitsDialog() {
    showDialog<void>(
      context: context,

      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context1) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Pharmdel'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  //Text('This is a demo alert dialog.'),
                  Text('User not registered, Continue to create a new user'),
                ],
              ),
            ),
            actions: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                onTap: () {
                  Navigator.of(context1).pop();
                  Navigator.of(context).pop(false);
                },
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'CREATE',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                onTap: () {
                  Navigator.of(context1).pop();
                  if (widget.type == "4" || widget.type == "6" || widget.type == "3" || widget.type == "2") {
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

                    model.xml.patientInformation.mobileNo = orderInfo.mobile_no_new != null ? orderInfo.mobile_no_new : "";
                    model.xml.patientInformation.email_id = orderInfo.email_id != null ? orderInfo.email_id : "";

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

                    model.xml.patientInformation.postCode = orderInfo.postCode != null
                        ? orderInfo.postCode.s0 != null
                            ? orderInfo.postCode.s0 ?? ""
                            : orderInfo.postCode.s0
                        : "";
                    model.xml.patientInformation.dob = orderInfo.dob != null ? orderInfo.dob : "";
                    if (widget.type == "4") {
                      if (result.contains(";")) model.xml.sc.id = result.split(";")[1];
                    }
                    // else {
                    //   model.xml.sc.id = result;
                    // }
                  }
                  model.xml.customerId = 0;
                  model.xml.isAddNewCustomer = true;
                  widget.pmrList.add(model);
                  widget.prescriptionList.addAll(model.xml.dd);
                  if (widget.isBulkScan) {
                    createOrder();
                  } else
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliverySchedule(
                                  prescriptionList: widget.prescriptionList,
                                  pmrList: widget.pmrList,
                                  callApi: widget.callPickedApi,
                                  isPatient: false,
                                  type: qrType,
                                  amount: amount,
                                  orderInof: orderInfo,
                                  otherPharmacy: otherPharmacy,
                                  pharmacyId: widget.pharmacyId,
                                )));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> createOrder() async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    // model.xml.patientInformation.nhs = "";
    String url = WebConstant.UUDATE_CUSTOMER_WITH_ORDER;
    logger.i(url);
    String gender = "M";
    if (widget.pmrList[0].xml.patientInformation.salutation != null) if (widget.pmrList[0].xml.patientInformation.salutation.endsWith("Mrs") || widget.pmrList[0].xml.patientInformation.salutation.endsWith("Miss") || widget.pmrList[0].xml.patientInformation.salutation.endsWith("Ms")) {
      gender = "F";
    }
    String tittle = "";
    if (widget.pmrList[0].xml.patientInformation.salutation == "Mr") {
      tittle = "M";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Miss") {
      tittle = "S";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Mrs") {
      tittle = "F";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Ms") {
      tittle = "Q";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Captain") {
      tittle = "C";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Dr") {
      tittle = "D";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Prof") {
      tittle = "P";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Rev") {
      tittle = "R";
    } else if (widget.pmrList[0].xml.patientInformation.salutation == "Mx") {
      tittle = "X";
    }
    String dob = widget.pmrList[0].xml.customerId == 0 && widget.pmrList[0].xml.patientInformation != null && widget.pmrList[0].xml.patientInformation.dob != null ? "${widget.pmrList[0].xml.patientInformation.dob.isNotEmpty ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.pmrList[0].xml.patientInformation.dob)) : "" ?? ""}" : widget.pmrList[0].xml.patientInformation.dob;
    Map<String, dynamic> data = {
      "order_type": "scan",
      "pharmacyId": widget.pharmacyId,
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
      "pmr_type": qrType,
      "otherpharmacy": otherPharmacy,
      "titan_scan_info": orderInfo.titanScaInfo != null ? orderInfo.titanScaInfo : "",
      "amount": amount,
      "exemption": "",
      //_exemptSelected ? selectedExemptionId != null ? selectedExemptionId : 0 : 0,
      "paymentStatus": "",
      "bag_size": "",
      "patient_id": widget.pmrList[0].xml.customerId,
      "pr_id": widget.pmrList[0].xml.sc != null ? widget.pmrList[0].xml.sc.id ?? "" : "",
      "lat": "",
      //na
      "lng": "",
      //na
      "parcel_box_id": widget.parcelBoxId != null ? "${widget.parcelBoxId}" : "0",
      "surgery_name": widget.pmrList[0].xml.doctorInformation != null ? widget.pmrList[0].xml.doctorInformation.companyName ?? "" : "",
      "surgery": widget.pmrList[0].xml.doctorInformation != null ? widget.pmrList[0].xml.doctorInformation.i ?? "" : "",
      "email_id": "",
      "mobile_no_2": widget.pmrList[0].xml.patientInformation.mobileNo ?? "",
      "dob": "$dob",
      "nhs_number": widget.pmrList[0].xml.patientInformation.nhs ?? "",
      "title": tittle ?? "",
      "first_name": widget.pmrList[0].xml.patientInformation.firstName ?? "",
      "middle_name": widget.pmrList[0].xml.patientInformation.middleName != null && widget.pmrList[0].xml.patientInformation.middleName != "null" ? widget.pmrList[0].xml.patientInformation.middleName : "",
      "last_name": widget.pmrList[0].xml.patientInformation.lastName != null ? (widget.pmrList[0].xml.patientInformation.lastName != "null" ? widget.pmrList[0].xml.patientInformation.lastName : "") : "",
      "address_line_1": widget.pmrList[0].xml.patientInformation.address ?? "",
      "country_id": "",
      "post_code": widget.pmrList[0].xml.patientInformation.postCode ?? "",
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
      "doctor_name": widget.pmrList[0].xml.doctorInformation != null ? widget.pmrList[0].xml.doctorInformation.doctorName ?? "" : "",
      "doctor_address": widget.pmrList[0].xml.doctorInformation != null ? widget.pmrList[0].xml.doctorInformation.address ?? "" : "",
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
        Navigator.of(context).pop(true);
      }
    });
  }
}

abstract class CustomerSelectedListner {
  void isSelected(dynamic userid, dynamic position, dynamic alt_address);
}

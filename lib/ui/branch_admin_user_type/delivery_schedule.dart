// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ftoast/ftoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/DeliveryMasterDataResponse.dart';
import 'package:pharmdel_business/model/ProcessScanResponse.dart';
import 'package:pharmdel_business/model/driver_model.dart';
import 'package:pharmdel_business/model/parcel_box_api_response.dart';
import 'package:pharmdel_business/model/pmr_model.dart';
import 'package:pharmdel_business/model/route_model.dart';
import 'package:pharmdel_business/provider/repeat_prescription_imageProvider.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/branch_admin_dashboard.dart';
import 'package:pharmdel_business/util/CustomDialogBox.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';

import '../../main.dart';
import '../../model/MedicineReaponse.dart';
import '../../util/custom_color.dart';
import '../../util/custom_loading.dart';
import '../../util/permission_utils.dart';
import '../../util/sentryExeptionHendler.dart';
import '../../util/text_style.dart';
import '../driver_user_type/dashboard_driver.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import 'medicine_list.dart';

class DeliverySchedule extends StatefulWidget {
  List<Dd> prescriptionList = List();
  List<PmrModel> pmrList = List();
  bool isPatient = false;
  OrderInfoResponse orderInof;
  String type;
  String amount;
  bool otherPharmacy;
  int pharmacyId;
  BulkScanMode callApi;

  DeliverySchedule({this.prescriptionList, this.pmrList, this.orderInof, this.isPatient, this.amount, this.callApi, this.type, this.otherPharmacy, this.pharmacyId});

  StateDeliverySchedule createState() => StateDeliverySchedule();
}

class StateDeliverySchedule extends State<DeliverySchedule> {
  ApiCallFram _apiCallFram = ApiCallFram();
  FToast fToast;
  String accessToken = "";
  String scannedData, selectedRoute;
  DateTime selectedDate;
  List<RouteList> routeList = [];
  List<ParcelBoxData> parcelBoxList = [];
  List<Shelf> shelfList = [];
  List<Shelf> servicesList = [];
  List<NursingHome> nursingHomeLIst = [];
  List<String> deliveryTypeList = [];
  List<Surgery> surgeryList = [];

  String routeID;
  String driverType = "";

  List<DriverModel> driverList = [];
  bool isShowDoctorDetails = false;
  TextEditingController recentNoteController = TextEditingController();
  TextEditingController surgeryController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  ScrollController _controller;
  bool isScrollDown = false;

  int _selectedRoutePosition = 0;
  int _selectedShelfPosition = 0;
  int _selectedServicePosition = 0;
  int _selectedNursingHomePosition = 0;
  int _selectedDeliveryTypePosition = 0;
  int _selectedDriverPosition = 0;

  bool _isCollection = false;

  BuildContext context1;

  // ProgressDialog progressDialog;

  var _fridgeSelected = false;

  var _controlSelected = false;

  String dropdownValue = 'Received';

  List<MedicineDataList> medicineMainList = [];

  FocusNode focus = FocusNode();

  List<TextEditingController> _controllersDays = new List();
  List<TextEditingController> _controllersQty = new List();

  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController preChargeController = TextEditingController();

  String totalAmount = "0.00";
  String rxCharge;
  int dailyId;
  String datetime;
  DateTime Ts;

  dynamic subExpDate;

  String userType = "";
  String userID = "";
  String perDelivey = '';

  RepeatPrescriptionImageProvider imagePicker;

  ParcelBoxData parcelDropdownValue;

  List<String> paymentExemptionList = ["No exemption - Patient pays", "Is under 16 years of age", "Is 16, 17 or 18 in full-time eduction", "Is 60 years of age or over", "Has a valid maternity exemption certificate"];

  List<String> bagSizeList = ["S", "M", "L", "C"];
  int id = -1;

  var _paidSelected = false;
  var _exemptSelected = false;
  String selectedCharge = "";
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

  List<PatientSubscription> patientSubList = [];
  List<Exemptions> exemptionsList = [];

  int selectedExemptionId;

  String selectedExemption = "";

  int isPresCharge;
  int isDelCharge;
  int startRouteId;
  int endRouteId;
  int pharmacyId;
  double startLat;
  double startLng;
  int selectedSubscription = 0;

  bool isStartRoute = false;

  @override
  void initState() {
    super.initState();
    // progressDialog = ProgressDialog(context, isDismissible: true);
    fToast = FToast();
    // if(widget.type == '4')
    //   if(widget.amount != "0" && widget.amount != "0.0" && widget.amount != "0.00" && widget.amount != "")
    // recentNoteController..text = "£ ${widget.amount}";
    if (widget.orderInof != null && widget.orderInof.default_surgery_note != null && widget.orderInof.default_surgery_note != "") {
      surgeryController..text = widget.orderInof.default_surgery_note;
    }

    if (widget.orderInof != null && widget.orderInof.delivery_note != null && widget.orderInof.delivery_note != "") {
      recentNoteController..text = widget.orderInof.delivery_note;
    }

    if (widget.orderInof != null && widget.orderInof.default_branch_note != null && widget.orderInof.default_branch_note != "") {
      branchController..text = widget.orderInof.default_branch_note;
    }

    if (widget.orderInof != null && widget.orderInof.subExpDate != null) {
      subExpDate = widget.orderInof.subExpDate;
      logger.i('Expiry Subscription Date: $subExpDate');

      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(subExpDate);
      Ts = DateTime.fromMillisecondsSinceEpoch(subExpDate);
      datetime = tsdate.year.toString() + "/" + tsdate.month.toString() + "/" + tsdate.day.toString();
      print(datetime);

      logger.i('Converted Date Date: $datetime');
      // subExpiryPopUp('${patientSubList[selectedSubscription].name} Subscription Expired by $datetime');
    }
    getLocationData();
    selectedDate = DateTime.now();
    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      userType = value.getString(WebConstant.USER_TYPE) ?? "";
      driverType = value.getString(WebConstant.DRIVER_TYPE);
      userID = value.getString(WebConstant.USER_ID) ?? "";
      routeID = value.getString(WebConstant.ROUTE_ID) ?? "";
      isStartRoute = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      endRouteId = value.getInt(WebConstant.END_ROUTE_AT) ?? 0;
      startRouteId = value.getInt(WebConstant.START_ROUTE_FROM) ?? 0;
      pharmacyId = value.getInt(WebConstant.PHARMACY_ID) ?? 0;
      if (userType == 'Pharmacy' || userType == "Pharmacy Staff")
        dropdownValue = 'Received';
      else
        dropdownValue = 'PickedUp';
      if (userType != 'Pharmacy' && userType != "Pharmacy Staff")
        getPharmacyInfo(pharmacyId);
      else {
        getRoutes();
        isPresCharge = value.getInt(WebConstant.IS_PRES_CHARGE);
        isDelCharge = value.getInt(WebConstant.IS_DEL_CHARGE);
      }
    });
    imagePicker = Provider.of<RepeatPrescriptionImageProvider>(context, listen: false);
    imagePicker.imageList = [];
    imagePicker.images = [];
    //scanBarcodeNormal();
    _controller = ScrollController()
      ..addListener(() {
        setState(() {
          isScrollDown = _controller.position.userScrollDirection == ScrollDirection.forward;
        });
      });
    if (widget.orderInof.paymentExemption != null) {
      selectedExemptionId = widget.orderInof.paymentExemption;
      // if(selectedExemptionId != 2)
      //   _paidSelected = true;
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

  void getImage(ImageSource source, BuildContext context) {
    Provider.of<RepeatPrescriptionImageProvider>(context, listen: false).getImage(source, context);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage(ImageSource.gallery, context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImage(ImageSource.camera, context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    context1 = context;
    // print(widget.pmrList[0].xml.patientInformation.firstName);
    imagePicker = Provider.of<RepeatPrescriptionImageProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text('Delivery Schedule', style: TextStyleblueGrey14),
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.only(right: 10),
          //     padding: EdgeInsets.only(left: 5, right: 5),
          //     child: InkWell(
          //         onTap: () {
          //           _onWillPop();
          //         },
          //         child: Icon(
          //           Icons.home,
          //           color: Colors.blueGrey,
          //         )),
          //   )
          // ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
            SingleChildScrollView(
                controller: _controller,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //Patient Info ------------------------------------------------------------------------------------

                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                        // color: Colors.orange[100],
                        child: Column(
                          children: [
                            // Container(
                            //   margin: EdgeInsets.only(left: 0, bottom: 5),
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     "PATIENT INFO",
                            //     style: TextStyle(
                            //         color: Colors.blueGrey,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w800),
                            //   ),
                            // ),
                            if (widget.pmrList != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("${widget.pmrList.length > 0 ? "${widget.pmrList[0].xml.patientInformation.salutation ?? ""}"
                                    " ${widget.pmrList[0].xml.patientInformation.firstName != null && widget.pmrList[0].xml.patientInformation.firstName != "null" ? widget.pmrList[0].xml.patientInformation.firstName : ""} "
                                    "${widget.pmrList[0].xml.patientInformation.middleName != null && widget.pmrList[0].xml.patientInformation.middleName != "null" ? widget.pmrList[0].xml.patientInformation.middleName : ""} "
                                    "${widget.pmrList[0].xml.patientInformation.lastName != null ? (widget.pmrList[0].xml.patientInformation.lastName != "null" ? widget.pmrList[0].xml.patientInformation.lastName : "") : ""}" : ""}"),
                              ),
                            if (widget.pmrList != null && widget.type != "5")
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.pmrList[0].xml.customerId == 0 ? "DOB: ${widget.pmrList.length > 0 && widget.pmrList[0].xml.patientInformation != null && widget.pmrList[0].xml.patientInformation.dob != null ? "${widget.pmrList[0].xml.patientInformation.dob.isNotEmpty ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.pmrList[0].xml.patientInformation.dob)) : "" ?? ""}" : ""}" : "DOB : ${widget.pmrList[0].xml.patientInformation.dob ?? ""}"),
                              ),
                            if (widget.pmrList != null && widget.type != "5")
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("NHS: ${widget.pmrList.length > 0 ? "${widget.pmrList[0].xml.patientInformation.nhs ?? ""}" : ""}"),
                              ),
                            if (widget.pmrList != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text("Address: ${widget.pmrList.length > 0 ? "${widget.pmrList[0].xml.patientInformation.address ?? ""}"
                                          ", Post Code: ${widget.pmrList[0].xml.patientInformation.postCode ?? ""} " : ""}"),
                                    ),
                                    if (widget.pmrList != null && widget.pmrList.isNotEmpty && widget.pmrList[0] != null && widget.pmrList[0].xml != null && widget.pmrList[0].xml.alt_address != null && widget.pmrList[0].xml.alt_address != "" && widget.pmrList[0].xml.alt_address.toString() == "t")
                                      Image.asset(
                                        "assets/alt-add.png",
                                        height: 18,
                                        width: 18,
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),

                      //Doctor Details------------------------------------------------------------------------------
                      if (widget.pmrList[0].xml.doctorInformation != null)
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                          color: Colors.green[100],
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isShowDoctorDetails = !isShowDoctorDetails;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 0, bottom: 5, top: 0),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "SURGERY",
                                          style: TextStyleblueGrey14,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("(${widget.pmrList.length > 0 ? "${widget.pmrList[0].xml.doctorInformation.companyName ?? ")"}" : ""})"),
                                        Spacer(),
                                        isShowDoctorDetails
                                            ? Icon(
                                                Icons.keyboard_arrow_up,
                                                color: Colors.blueGrey,
                                              )
                                            : Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.blueGrey,
                                              )
                                      ],
                                    )),
                              ),
                              isShowDoctorDetails
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text("${widget.pmrList.length > 0 ? "${widget.pmrList[0].xml.doctorInformation.doctorName ?? ""}" : ""}"),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Surgery: ${widget.pmrList.length > 0 ? "${widget.pmrList[0].xml.doctorInformation.companyName ?? ""}" : ""}"),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Address: ${widget.pmrList.length > 0 ? "${widget.pmrList[0].xml.doctorInformation.address ?? ""}" : ""}"),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                            ],
                          ),
                        ),
                      if (widget.type == "1")
                        Divider(
                          color: Colors.grey,
                        ),
                      //Medication------------------------------------------------------------------------------
                      if (widget.type != "5")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (widget.type == "1") {
                                  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
                                  if (barcodeScanRes != "-1") {
                                    loadPrescription(barcodeScanRes);
                                  } else {
                                    // Fluttertoast.showToast(
                                    //     msg: "Format not correct!");
                                  }
                                } else if (widget.type == "4" || widget.type == "3" || widget.type == "2" || widget.type == "6") {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineList())).then((value) {
                                    // print(value);
                                    if (value.drugInfo != null && value.drugInfo > 0) {
                                      value.isControlDrug = true;
                                    }
                                    bool checkValid = false;
                                    medicineMainList.forEach((element) {
                                      if (value.id == element.id) {
                                        checkValid = true;
                                      }
                                    });
                                    if (!checkValid) {
                                      if (value != null) {
                                        medicineMainList.add(value);
                                        setState(() {});
                                      }
                                    } else
                                      showToast("Medicine is already Selected");
                                  });
                                }
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.blue, border: Border.all(color: Colors.grey[400])),
                                margin: EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.type == "4" || widget.type == "3" || widget.type == "2" || widget.type == "6" ? "+ Meds" : "+ Meds",
                                  textAlign: TextAlign.center,
                                  style: TextStylewhite14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Container(
                                  width: 90,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.orange, border: Border.all(color: Colors.grey[400])),
                                  margin: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Rx Image",
                                    textAlign: TextAlign.center,
                                    style: TextStylewhite14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: materialAppThemeColor,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                                                    child: Text(
                                                      "Rx Details",
                                                      style: Bold20Style,
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.only(right: 15)),
                                                  Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (widget.type == "1")
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  separatorBuilder: (context, index) => Divider(
                                                    color: Colors.grey,
                                                  ),
                                                  itemCount: widget.prescriptionList.length,
                                                  itemBuilder: (context, index) {
                                                    Dd prescription = widget.prescriptionList[index];

                                                    return Padding(
                                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text("${prescription.d ?? ""}"),
                                                            ),
                                                            Container(
                                                              child: Text("${prescription.q ?? ""}"),
                                                            ),
                                                            Container(
                                                              child: Text("${prescription.ddDo ?? ""}"),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Container(
                                                                    height: 30,
                                                                    padding: EdgeInsets.only(right: 5),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                      color: Colors.blue,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          visualDensity: VisualDensity(horizontal: -4),
                                                                          value: widget.prescriptionList[index].drugsTypeFr != null ? widget.prescriptionList[index].drugsTypeFr : false,
                                                                          onChanged: (newValue) {
                                                                            setState(() {
                                                                              widget.prescriptionList[index].drugsTypeFr = newValue;
                                                                            });
                                                                          },
                                                                        ),
                                                                        Image.asset(
                                                                          "assets/fridge.png",
                                                                          height: 21,
                                                                          color: Colors.white,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 25,
                                                                  ),
                                                                  Container(
                                                                    height: 30,
                                                                    padding: EdgeInsets.only(right: 5),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                      color: Colors.red,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Checkbox(
                                                                          visualDensity: VisualDensity(horizontal: -4),
                                                                          value: widget.prescriptionList[index].drugsTypeCD != null ? widget.prescriptionList[index].drugsTypeCD : false,
                                                                          onChanged: (newValue) {
                                                                            setState(() {
                                                                              widget.prescriptionList[index].drugsTypeCD = newValue;
                                                                            });
                                                                          },
                                                                        ),
                                                                        new Text(
                                                                          'C. D.',
                                                                          style: TextStyle6White,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            if (widget.type == "4" || widget.type == "3" || widget.type == "6" || widget.type == "2")
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  separatorBuilder: (context, index) => Divider(
                                                    color: Colors.grey,
                                                  ),
                                                  itemCount: medicineMainList.length,
                                                  itemBuilder: (context, index) {
                                                    _controllersDays.add(new TextEditingController());
                                                    _controllersQty.add(new TextEditingController());
                                                    return Column(
                                                      children: [
                                                        ListTile(
                                                          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                          minVerticalPadding: 5.0,
                                                          title: Text(
                                                            medicineMainList[index].name ?? "",
                                                            style: TextStyleblueGrey14,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(left: 18.0),
                                                              width: 100,
                                                              height: 50,
                                                              child: new TextFormField(
                                                                style: TextStyleblueGrey14,
                                                                controller: _controllersQty[index],
                                                                textCapitalization: TextCapitalization.words,
                                                                textInputAction: TextInputAction.done,
                                                                // keyboardType: TextInputType.number,
                                                                keyboardType: TextInputType.numberWithOptions(signed: true),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                ],
                                                                autofocus: false,
                                                                enabled: true,
                                                                maxLength: 50,
                                                                maxLines: 1,
                                                                onChanged: (value) {
                                                                  medicineMainList[index].quntity = value;
                                                                  setState(() {});
                                                                },
                                                                decoration: new InputDecoration(counter: Offstage(), contentPadding: EdgeInsets.only(left: 10.0), hintText: "Quantity", border: new OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(5.0)))),
                                                                onFieldSubmitted: (v) {
                                                                  FocusScope.of(context).requestFocus(focus);
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left: 18.0),
                                                              width: 100,
                                                              height: 50,
                                                              child: new TextFormField(
                                                                style: TextStyleblueGrey14,
                                                                controller: _controllersDays[index],
                                                                textCapitalization: TextCapitalization.words,
                                                                textInputAction: TextInputAction.done,
                                                                // keyboardType: TextInputType.phone,
                                                                keyboardType: TextInputType.numberWithOptions(signed: true),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                ],
                                                                autofocus: false,
                                                                enabled: true,
                                                                maxLength: 50,
                                                                maxLines: 1,
                                                                decoration: new InputDecoration(counter: Offstage(), contentPadding: EdgeInsets.only(left: 10.0), hintText: "Days", border: new OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(5.0)))),
                                                                onFieldSubmitted: (v) {
                                                                  FocusScope.of(context).requestFocus(focus);
                                                                },
                                                                onChanged: (value) {
                                                                  medicineMainList[index].days = value;
                                                                  setState(() {});
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(child: Container()),
                                                            Container(
                                                              margin: EdgeInsets.only(right: 10.0),
                                                              height: 40,
                                                              width: 50,
                                                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(5.0)),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  medicineMainList.removeAt(index);
                                                                  _controllersDays.removeAt(index);
                                                                  _controllersQty.removeAt(index);
                                                                  // medicineList.removeWhere((item) => item.id == medicineList[index].id);
                                                                  setState(() {});
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 18.0, top: 2, bottom: 10),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                height: 30,
                                                                padding: EdgeInsets.only(right: 15),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  color: Colors.blue,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Checkbox(
                                                                      visualDensity: VisualDensity(horizontal: -4),
                                                                      value: medicineMainList[index].isFridge != null ? medicineMainList[index].isFridge : false,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          medicineMainList[index].isFridge = newValue;
                                                                        });
                                                                      },
                                                                    ),
                                                                    Image.asset(
                                                                      "assets/fridge.png",
                                                                      height: 21,
                                                                      color: Colors.white,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                height: 30,
                                                                padding: EdgeInsets.only(right: 15),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                  color: Colors.red,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Checkbox(
                                                                      visualDensity: VisualDensity(horizontal: -4),
                                                                      value: medicineMainList[index].isControlDrug != null ? medicineMainList[index].isControlDrug : false,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          medicineMainList[index].isControlDrug = newValue;
                                                                        });
                                                                      },
                                                                    ),
                                                                    new Text(
                                                                      'C. D.',
                                                                      style: TextStyle6White,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          height: 2.0,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.green, border: Border.all(color: Colors.grey[400])),
                                margin: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 10),
                                alignment: Alignment.center,
                                child: Text(
                                  "Rx Details",
                                  textAlign: TextAlign.center,
                                  style: TextStyleblueGrey14,
                                ),
                              ),
                            ),
                          ],
                        ),

                      Container(
                        height: imagePicker.images.length > 0 ? 70 : 0,
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 70,
                              child: ListView.builder(
                                // physics: AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: imagePicker.images.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      imagePicker.images.length > index && imagePicker.images[index] != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                  imagePicker.showImage(imagePicker.images[index]);
                                                },
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.grey)),
                                                        //isImageSelected == index ? Colors.red : Colors.grey)),
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(5.0),
                                                            child: Image.file(
                                                              File(imagePicker.images[index].path),
                                                              fit: BoxFit.cover,
                                                            ))),
                                                    Positioned(
                                                      right: -5.0,
                                                      top: -5.0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          imagePicker.removeImage(index);
                                                          if (imagePicker.images.length > 0) imagePicker.showImage(imagePicker.images[index - 1]);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(color: Colors.red[400], borderRadius: BorderRadius.circular(50.0)),
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                            size: 17,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.grey)),
                                              ),
                                            ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.type == "1")
                        Divider(
                          color: Colors.grey,
                        ),

                      //Delivery Info ------------------------------------------------------------------------------------
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: widget.type == "1" ? 0 : 5, bottom: 10),
                        // color: Colors.blue[100],
                        child: Column(
                          children: [
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       left: 0, bottom: 0, top: 0, right: 5),
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     "DELIVERY INFO",
                            //     style: TextStyle(
                            //         color: Colors.blueGrey,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w800),
                            //   ),
                            // ),
                            Row(
                              children: [
                                // Flexible(
                                //   flex: 1,
                                //   child: deliveryTypeList.length > 0
                                //       ? Container(
                                //           width:
                                //               MediaQuery.of(context).size.width,
                                //           margin: EdgeInsets.only(
                                //               top: 10, bottom: 10, right: 15),
                                //           padding: const EdgeInsets.only(
                                //               left: 10.0, right: 10.0),
                                //           decoration: BoxDecoration(
                                //               borderRadius:
                                //                   BorderRadius.circular(10.0),
                                //               // color: Colors.blueGrey,
                                //               border: Border.all(
                                //                   color: Colors.grey[400])),
                                //           child: DropdownButtonHideUnderline(
                                //             child: DropdownButton(
                                //               isExpanded: true,
                                //               value:
                                //                   _selectedDeliveryTypePosition,
                                //               items: [
                                //                 for (String route
                                //                     in deliveryTypeList)
                                //                   DropdownMenuItem(
                                //                     child: Text("${route}",
                                //                         overflow: TextOverflow
                                //                             .ellipsis,
                                //                         style: TextStyle(
                                //                             color: Colors
                                //                                 .black87)),
                                //                     value: deliveryTypeList
                                //                         .indexOf(route),
                                //                   ),
                                //               ],
                                //               onChanged: (int value) {
                                //                 setState(() {
                                //                   // Collection removed
                                //                   // if (value == 0) {
                                //                   //   _isCollection = true;
                                //                   // } else {
                                //                   //   _isCollection = false;
                                //                   // }
                                //                   _isCollection = false;
                                //                   _selectedDeliveryTypePosition =
                                //                       value;
                                //                 });
                                //               },
                                //             ),
                                //           ))
                                //       :SizedBox(),
                                // ),
                                Flexible(
                                  flex: 1,
                                  child: servicesList.length > 0
                                      ? Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              // color: Colors.blueGrey,
                                              border: Border.all(color: Colors.grey[400])),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                isDense: true,
                                                value: _selectedServicePosition,
                                                items: [
                                                  for (Shelf route in servicesList)
                                                    DropdownMenuItem(
                                                      child: Text("${route.name}", overflow: TextOverflow.ellipsis, style: Bold16Style),
                                                      value: servicesList.indexOf(route),
                                                    ),
                                                ],
                                                onChanged: (int value) {
                                                  setState(() {
                                                    _selectedServicePosition = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ))
                                      : SizedBox(),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Container(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Bag Size ",
                                              style: TextStyleGreen14,
                                            ),
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.shopping_bag_outlined,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                            ),
                                            TextSpan(text: ":", style: TextStyleGreen14),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: bagSizeList.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Radio(
                                                value: index,
                                                groupValue: id,
                                                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                onChanged: (int val) {
                                                  setState(() {
                                                    id = val;
                                                    logger.i(bagSizeList[id]);
                                                  });
                                                },
                                              ),
                                              bagSizeList[index] != "C"
                                                  ? Text(
                                                      "${bagSizeList[index]}",
                                                    )
                                                  : Icon(
                                                      Icons.shopping_bag_outlined,
                                                      size: 20,
                                                      color: Colors.green,
                                                    ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  if (!_isCollection)
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.only(right: 15, bottom: 5.0),
                                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                // color: Colors.blueGrey,
                                                border: Border.all(color: Colors.grey[400])),
                                            child: InkWell(
                                                onTap: () {
                                                  if (driverType == Constants.dadicatedDriver && isStartRoute) {
                                                    return;
                                                  }
                                                  openCalender();
                                                },
                                                child: Container(
                                                  height: 39,
                                                  alignment: Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context).textTheme.bodyText1,
                                                      children: [
                                                        //TextSpan(text: 'Created with '),
                                                        WidgetSpan(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 5, right: 10),
                                                            child: Image.asset(
                                                              'assets/calendar.png',
                                                              color: Colors.blueGrey,
                                                              fit: BoxFit.fill,
                                                              height: 20,
                                                              width: 20,
                                                            ),
                                                          ),
                                                        ),

                                                        TextSpan(text: "${selectedDate == null ? "Schedule" : DateFormat("dd-MMM-yyyy").format(selectedDate)}", style: TextStyleblueGrey14),
                                                      ],
                                                    ),
                                                  ),
                                                )))),
                                  if (routeList != null && routeList.isNotEmpty && !_isCollection)
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(bottom: 5),
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              // color: Colors.blueGrey,
                                              border: Border.all(color: Colors.grey[400])),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: IgnorePointer(
                                                ignoring: driverType == Constants.dadicatedDriver
                                                    ? !isStartRoute
                                                        ? false
                                                        : true
                                                    : false,
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  value: _selectedRoutePosition,
                                                  items: [
                                                    for (RouteList route in routeList)
                                                      DropdownMenuItem(
                                                        child: Text("${route.routeName}", overflow: TextOverflow.ellipsis, style: TextStyleGreen14),
                                                        value: routeList.indexOf(route),
                                                      ),
                                                  ],
                                                  onChanged: (int value) {
                                                    setState(() {
                                                      _selectedRoutePosition = value;
                                                      if (userType == 'Pharmacy' || userType == "Pharmacy Staff") getDriversByRoute(routeList[_selectedRoutePosition]);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                ],
                              ),
                            ),
                            /*   Container(
                          margin: EdgeInsets.only(left: 2,top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text("Choose driver",style: TextStyle(color: Colors.blueGrey,fontSize: 14),),
                      ),*/

                            Row(
                              children: [
                                if (userType == 'Pharmacy' || userType == "Pharmacy Staff")
                                  Flexible(
                                    flex: 1,
                                    child: !_isCollection
                                        ? driverList.length > 0
                                            ? Container(
                                                width: MediaQuery.of(context).size.width,
                                                margin: EdgeInsets.only(top: 0, bottom: 5),
                                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    // color: Colors.blueGrey,
                                                    border: Border.all(color: Colors.grey[400])),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      isExpanded: true,
                                                      isDense: true,
                                                      value: _selectedDriverPosition,
                                                      items: [
                                                        for (DriverModel route in driverList)
                                                          DropdownMenuItem(
                                                            child: Text("${route.firstName}", overflow: TextOverflow.ellipsis, style: TextStyleGreen14),
                                                            value: driverList.indexOf(route),
                                                          ),
                                                      ],
                                                      onChanged: (int value) {
                                                        setState(() {
                                                          _selectedDriverPosition = value;
                                                        });
                                                        getParcelBoxData(driverList[_selectedDriverPosition].driverId.toString());
                                                      },
                                                    ),
                                                  ),
                                                ))
                                            : Container(
                                                margin: EdgeInsets.only(left: 2, bottom: 10, top: 10),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Driver not available on selected route!",
                                                  style: TextStyleGreen14,
                                                ),
                                              )
                                        : SizedBox(),
                                  ),
                                if (userType == 'Pharmacy' || userType == "Pharmacy Staff")
                                  if (!_isCollection)
                                    SizedBox(
                                      width: 10,
                                    ),
                                Visibility(
                                  visible: driverType == Constants.dadicatedDriver
                                      ? !isStartRoute
                                          ? true
                                          : false
                                      : true,
                                  child: Flexible(
                                    flex: 1,
                                    child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(top: 0, bottom: 5),
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            // color: Colors.blueGrey,
                                            border: Border.all(color: Colors.grey[400])),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              isDense: true,
                                              value: dropdownValue,
                                              items: <String>[
                                                'Received',
                                                'Requested',
                                                'Ready',
                                                'PickedUp',
                                              ].map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(color: "Out For Delivery" != value ? Colors.black : Colors.grey),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String newValue) {
                                                if ("Out For Delivery" != newValue)
                                                  setState(() {
                                                    dropdownValue = newValue;
                                                  });
                                              },
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (nursingHomeLIst != null && nursingHomeLIst.isNotEmpty)
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(bottom: 5.0),
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            // color: Colors.blueGrey,
                                            border: Border.all(color: Colors.grey[400])),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              isDense: true,
                                              value: _selectedNursingHomePosition,
                                              items: [
                                                for (NursingHome nursingHome in nursingHomeLIst)
                                                  DropdownMenuItem(
                                                    child: Text("${nursingHome.nursing_home_name}", overflow: TextOverflow.ellipsis, style: TextStyleGreen14),
                                                    value: nursingHomeLIst.indexOf(nursingHome),
                                                  ),
                                              ],
                                              onChanged: (int value) {
                                                setState(() {
                                                  _selectedNursingHomePosition = value;
                                                });
                                              },
                                            ),
                                          ),
                                        )),
                                  ),
                                if (parcelBoxList != null && parcelBoxList.isNotEmpty && dropdownValue == "PickedUp")
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                if (parcelBoxList != null && parcelBoxList.isNotEmpty && dropdownValue == "PickedUp")
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(bottom: 5.0),
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            // color: Colors.blueGrey,
                                            border: Border.all(color: Colors.grey[400])),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              isDense: true,
                                              value: parcelDropdownValue,
                                              items: parcelBoxList.map<DropdownMenuItem<ParcelBoxData>>((ParcelBoxData parcelBoxList) {
                                                return DropdownMenuItem<ParcelBoxData>(
                                                  value: parcelBoxList,
                                                  child: Text("${parcelBoxList.name}", overflow: TextOverflow.ellipsis, style: TextStyleGreen14),
                                                );
                                              }).toList(),
                                              onChanged: (ParcelBoxData newValue) {
                                                setState(() {
                                                  parcelDropdownValue = newValue;
                                                });
                                              },
                                            ),
                                          ),
                                        )),
                                  ),
                              ],
                            ),
                            // if(isDelCharge != null && isDelCharge == 1)
                            //   Container(
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Container(
                            //             width: dailyId == 4 ? MediaQuery.of(context).size.width/ 2.4 : MediaQuery.of(context).size.width/1.13,
                            //             margin: const EdgeInsets.only(
                            //                 bottom: 5.0),
                            //             padding: const EdgeInsets.only(
                            //                 left: 10.0, right: 10.0, top: 3.0,bottom: 3.0),
                            //             decoration: BoxDecoration(
                            //                 borderRadius:
                            //                 BorderRadius.circular(10.0),
                            //                 // color: Colors.blueGrey,
                            //                 border: Border.all(
                            //                     color: Colors.grey[400])),
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            //               child: DropdownButtonHideUnderline(
                            //                 child: DropdownButton(
                            //                   isExpanded: true,
                            //                   isDense: true,
                            //                   value: selectedSubscription,
                            //                   items: [
                            //                     for (var nursingHome in patientSubList)
                            //                       DropdownMenuItem(
                            //                         child: Text("${nursingHome.name}",
                            //                             overflow: TextOverflow
                            //                                 .ellipsis,
                            //                             style: TextStyle(
                            //                                 color: Colors
                            //                                     .black87)),
                            //                         value: patientSubList
                            //                             .indexOf(nursingHome),
                            //                       ),
                            //                   ],
                            //                   onChanged: (int value) {
                            //                     setState(() {
                            //                       dailyId = patientSubList[value].id;
                            //                       selectedSubscription = value;
                            //                     });
                            //                   },
                            //                 ),
                            //               ),
                            //             )),
                            //         if(dailyId == 4)
                            //           Container(
                            //             width: MediaQuery.of(context).size.width / 2.2,
                            //             margin: const EdgeInsets.only(
                            //                 bottom: 5.0),
                            //             padding: const EdgeInsets.only(
                            //               left: 10.0, right: 10.0,),
                            //             //margin: EdgeInsets.only(bottom: 30),
                            //             child: Padding(
                            //               padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                            //               child: TextField(
                            //                   controller: deliveryChargeController,
                            //                   minLines: 1,
                            //                   maxLines: null,
                            //                   decoration: InputDecoration(
                            //                     contentPadding: EdgeInsets.only(
                            //                         left: 10.0, right: 10.0),
                            //                     hintText: 'Delivery Charge',
                            //                     hintStyle: TextStyle(color: Colors.grey),
                            //                     //filled: true,
                            //                     fillColor: Colors.white70,
                            //                     enabledBorder: OutlineInputBorder(
                            //                       borderRadius: BorderRadius.all(
                            //                           Radius.circular(10.0)),
                            //                       borderSide: BorderSide(
                            //                           color: Colors.grey[400], width: 1),
                            //                     ),
                            //                     focusedBorder: OutlineInputBorder(
                            //                       borderRadius: BorderRadius.all(
                            //                           Radius.circular(10.0)),
                            //                       borderSide: BorderSide(
                            //                           color: Colors.grey[400], width: 1),
                            //                     ),
                            //                   )),
                            //             ),
                            //           ),
                            //       ],
                            //     ),
                            //   ),

                            if (isDelCharge != null && isDelCharge == 1)
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          // width: perDelivey == 'Per Delivery' ? MediaQuery.of(context).size.width/ 2.4 : MediaQuery.of(context).size.width/1.13,
                                          margin: const EdgeInsets.only(bottom: 5.0),
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              // color: Colors.blueGrey,
                                              border: Border.all(color: Colors.grey[400])),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                isDense: true,
                                                value: selectedSubscription,
                                                items: [
                                                  for (var nursingHome in patientSubList)
                                                    DropdownMenuItem(
                                                      child: Text("${nursingHome.name}", overflow: TextOverflow.ellipsis, style: TextStyleGreen14),
                                                      value: patientSubList.indexOf(nursingHome),
                                                    ),
                                                ],
                                                onChanged: (int value) {
                                                  setState(() {
                                                    // dailyId = patientSubList[value].id;
                                                    perDelivey = patientSubList[value].name;
                                                    if (perDelivey == 'Per Delivery') deliveryChargeController.text = widget.orderInof.delCharge ?? patientSubList[value].price;
                                                    //   deliveryChargeController.text = patientSubList[value].price;
                                                    selectedSubscription = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          )),
                                    ),
                                    if (perDelivey == 'Per Delivery')
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          // width: MediaQuery.of(context).size.width / 2.2,
                                          margin: const EdgeInsets.only(bottom: 5.0),
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 0.0,
                                          ),
                                          //margin: EdgeInsets.only(bottom: 30),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                            child: TextField(
                                                controller: deliveryChargeController,
                                                minLines: 1,
                                                maxLines: null,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                                                  hintText: 'Delivery Charge',
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  //filled: true,
                                                  fillColor: Colors.white70,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(color: Colors.grey[400], width: 1),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    borderSide: BorderSide(color: Colors.grey[400], width: 1),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                            Container(
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _fridgeSelected = !_fridgeSelected;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      padding: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.blue,
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            visualDensity: VisualDensity(horizontal: -4),
                                            value: _fridgeSelected,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _fridgeSelected = newValue;
                                              });
                                            },
                                          ),
                                          Image.asset(
                                            "assets/fridge.png",
                                            height: 21,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _controlSelected = !_controlSelected;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      padding: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.red,
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            visualDensity: VisualDensity(horizontal: -4),
                                            value: _controlSelected,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _controlSelected = newValue;
                                              });
                                            },
                                          ),
                                          new Text(
                                            'C. D.',
                                            style: TextStyle6White,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _paidSelected = !_paidSelected;
                                      setState(() {});
                                      if (_paidSelected) paidBottomSheet(context);
                                      if (!_paidSelected) {
                                        paidList.forEach((element) {
                                          element["isSelected"] = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      padding: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.orange,
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            visualDensity: VisualDensity(horizontal: -4),
                                            value: _paidSelected,
                                            onChanged: (newValue) {
                                              logger.i('selectedExemptionId: $selectedExemptionId');
                                              //  logger.i('paymentExemption ${widget.orderInof.paymentExemption}');
                                              setState(() {
                                                _paidSelected = newValue;
                                              });
                                              if (_paidSelected) paidBottomSheet(context);
                                              if (!_paidSelected) {
                                                paidList.forEach((element) {
                                                  element["isSelected"] = false;
                                                });
                                              }
                                            },
                                          ),
                                          new Text(
                                            'Paid',
                                            style: TextStyle6White,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  if (exemptionsList != null && exemptionsList.isNotEmpty && exemptionsList.length > 0)
                                    InkWell(
                                      onTap: () {
                                        if ((widget.orderInof.exemption == null || widget.orderInof.exemption.isEmpty) && (selectedExemptionId == null)) {
                                          _exemptSelected = !_exemptSelected;
                                          setState(() {});
                                          if (_exemptSelected) exemptBottomSheet(context);
                                        }
                                        if ((widget.orderInof.exemption != null && widget.orderInof.exemption.isNotEmpty) || (selectedExemptionId != null)) exemptBottomSheet(context);
                                      },
                                      child: Container(
                                        height: 30,
                                        padding: EdgeInsets.only(right: 5, left: 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.green,
                                        ),
                                        child: Row(
                                          children: [
                                            if ((widget.orderInof.exemption == null || widget.orderInof.exemption.isEmpty) && (selectedExemptionId == null))
                                              Checkbox(
                                                visualDensity: VisualDensity(horizontal: -4),
                                                value: _exemptSelected,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _exemptSelected = newValue;
                                                  });
                                                  if (_exemptSelected) exemptBottomSheet(context);
                                                },
                                              ),
                                            new Text(
                                              'Exempt ${selectedExemption != null && selectedExemption.isNotEmpty ? ": " + selectedExemption : widget.orderInof.exemption != null && widget.orderInof.exemption.isNotEmpty ? ": " + widget.orderInof.exemption : ""}',
                                              style: TextStyle6White,
                                            ),
                                            if ((widget.orderInof.exemption != null && widget.orderInof.exemption.isNotEmpty) || (selectedExemptionId != null))
                                              InkWell(
                                                onTap: () {
                                                  exemptBottomSheet(context);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (_isCollection)
                              shelfList.length > 0
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 5, bottom: 5),
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          // color: Colors.blueGrey,
                                          border: Border.all(color: Colors.grey[400])),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            isDense: true,
                                            value: _selectedShelfPosition,
                                            items: [
                                              for (Shelf route in shelfList)
                                                DropdownMenuItem(
                                                  child: Text("${route.name}", overflow: TextOverflow.ellipsis, style: TextStyle8Black),
                                                  value: shelfList.indexOf(route),
                                                ),
                                            ],
                                            onChanged: (int value) {
                                              setState(() {
                                                _selectedShelfPosition = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ))
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          // color: Colors.blueGrey,
                                          border: Border.all(color: Colors.grey[400])),
                                      child: Text(
                                        "Service not available!",
                                        style: TextStyleblueGrey14,
                                      ),
                                    ),
                            Container(
                              margin: EdgeInsets.only(left: 2, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Existing Delivery Note",
                                style: TextStyleblueGrey14,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // color: Colors.blueGrey,
                                  border: Border.all(color: Colors.grey[400])),
                              child: Text(widget.orderInof != null && widget.orderInof.default_delivery_note != null && widget.orderInof.default_delivery_note != "" ? widget.orderInof.default_delivery_note : "Existing Delivery Note"),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Delivery Note",
                                style: TextStyleblueGrey14,
                              ),
                            ),
                            Container(
                              //margin: EdgeInsets.only(bottom: 30),
                              child: TextField(
                                  controller: recentNoteController,
                                  minLines: 1,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    hintText: 'Delivery Notes',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    //filled: true,
                                    fillColor: Colors.white70,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.grey[400], width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.grey[400], width: 1),
                                    ),
                                  )),
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(left: 2, top: 10),
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     "Surgery Note",
                            //     style: TextStyle(
                            //         color: Colors.blueGrey, fontSize: 14),
                            //   ),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.only(bottom: 0),
                            //   child: TextField(
                            //       controller: surgeryController,
                            //       minLines: 1,
                            //       maxLines: null,
                            //       decoration: InputDecoration(
                            //         contentPadding: EdgeInsets.only(
                            //             left: 10.0, right: 10.0),
                            //         hintText: 'Surgery Note',
                            //         hintStyle: TextStyle(color: Colors.grey),
                            //         //filled: true,
                            //         fillColor: Colors.white70,
                            //         enabledBorder: OutlineInputBorder(
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(10.0)),
                            //           borderSide: BorderSide(
                            //               color: Colors.grey[400], width: 1),
                            //         ),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(10.0)),
                            //           borderSide: BorderSide(
                            //               color: Colors.grey[400], width: 1),
                            //         ),
                            //       )),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.only(left: 2, top: 10),
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     "Branch Note",
                            //     style: TextStyle(
                            //         color: Colors.blueGrey, fontSize: 14),
                            //   ),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.only(bottom: 30),
                            //   child: TextField(
                            //       controller: branchController,
                            //       minLines: 1,
                            //       maxLines: null,
                            //       decoration: InputDecoration(
                            //         contentPadding: EdgeInsets.only(
                            //             left: 10.0, right: 10.0),
                            //         hintText: 'Branch Note',
                            //         hintStyle: TextStyle(color: Colors.grey),
                            //         //filled: true,
                            //         fillColor: Colors.white70,
                            //         enabledBorder: OutlineInputBorder(
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(10.0)),
                            //           borderSide: BorderSide(
                            //               color: Colors.grey[400], width: 1),
                            //         ),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(10.0)),
                            //           borderSide: BorderSide(
                            //               color: Colors.grey[400], width: 1),
                            //         ),
                            //       )),
                            // ),
                          ],
                        ),
                      ),

                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 80),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              // if (widget.pmrList.length == 0 ||
                              //     widget.prescriptionList.length == 0) {
                              //   showToast("You don't have any prescription, Add and try again.");
                              // } else {
                              //
                              // }

                              if (!_isCollection) {
                                if (selectedDate == null) {
                                  showToast("Schedule delivery and try again.");
                                  return;
                                }
                                if (userType == 'Pharmacy' || userType == "Pharmacy Staff") if (driverList.length == 0) {
                                  showToast("Select route driver and try again.");
                                  return;
                                }
                                if (_selectedRoutePosition == 0) {
                                  showToast("Select route and try again.");
                                  return;
                                }
                                if (userType == 'Pharmacy' || userType == "Pharmacy Staff") if (_selectedDriverPosition == 0) {
                                  showToast("Select driver and try again.");
                                  return;
                                }
                              }
                              /* for(Dd prescription in widget.prescriptionList){
                                  if(prescription.drugsType == null){
                                    showToast( "Choose drugs type and try again.");
                                    return;
                                  }
                                }*/
                              PmrModel model = widget.pmrList[0];
                              model.xml.dd = widget.prescriptionList;
                              model.xml.deliveryDate = selectedDate;
                              model.xml.recentDeliveryNote = recentNoteController.text;
                              model.xml.surgeryNote = surgeryController.text;
                              model.xml.routeId = routeList[_selectedRoutePosition].routeId;

                              postDataAndVerifyUser(model);
                            },
                            child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                child: Text("Book Delivery", style: TextStyle6White))),
                      )
                    ],
                  ),
                ))
          ],
        ),
        // floatingActionButton: AnimatedOpacity(
        //   opacity: isScrollDown ? 0 : 1,
        //   curve: Curves.easeInOut,
        //   duration: Duration(milliseconds: 1000),
        //   child: FloatingActionButton(
        //     //backgroundColor: CustomColors.yetToStartColor,
        //     clipBehavior: Clip.hardEdge,
        //     onPressed: () async {
        //       String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        //           "#7EC3E6", "Cancel", true, ScanMode.QR);
        //       print(barcodeScanRes);
        //       if (barcodeScanRes != "-1") {
        //         loadPrescription(barcodeScanRes);
        //       } else {
        //         showToast( "Format not correct!");
        //       }
        //       // Navigator.push(
        //       //     context,
        //       //     MaterialPageRoute(
        //       //         builder: (context) => PrescriptionBarScanner(
        //       //               prescriptionList: widget.prescriptionList,
        //       //               pmrList: widget.pmrList,
        //       //               isAssignSelf: false,
        //       //             ))).then((value) {
        //       //   loadPrescription(value);
        //       // });
        //     },
        //     child: Icon(Icons.add),
        //   ),
        // ),
      ),
    );
  }

  void exemptBottomSheet(context) {
    int index1;
    if (selectedCharge != null && exemptionsList != null && exemptionsList.isNotEmpty) {
      exemptionsList.forEach((element) {
        element.isSelected = false;
      });
      var index = exemptionsList.indexWhere((element) => element.id == selectedExemptionId);
      if (index >= 0) {
        exemptionsList[index].isSelected = true;
        exemptionsList[index].id = exemptionsList[index].id;
        exemptionsList[index].serialId = exemptionsList[index].serialId;
        exemptionsList[index].code = exemptionsList[index].code;
      }
    }
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStat) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black)),
                      color: materialAppThemeColor,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                          child: Text(
                            "Payment Exemption",
                            style: Bold20Style,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            _exemptSelected = false;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                      itemCount: exemptionsList.length > 0 ? exemptionsList.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setStat(() {
                                  for (var element in exemptionsList) {
                                    element.isSelected = false;
                                  }
                                  exemptionsList[index].isSelected = !exemptionsList[index].isSelected;
                                  index1 = index;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: exemptionsList[index].isSelected,
                                    visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                    onChanged: (values) {
                                      setStat(() {
                                        for (var element in exemptionsList) {
                                          element.isSelected = false;
                                        }
                                        exemptionsList[index].isSelected = !exemptionsList[index].isSelected;
                                        index1 = index;
                                      });
                                    },
                                  ),
                                  Flexible(child: Text("${exemptionsList[index].serialId != null && exemptionsList[index].serialId.isNotEmpty ? exemptionsList[index].serialId + " - " : ''}" + "${exemptionsList[index].code != null && exemptionsList[index].code.isNotEmpty ? exemptionsList[index].code : ''}"))
                                ],
                              ),
                            ),
                            if (index == exemptionsList.length - 1)
                              SizedBox(
                                height: 10.0,
                              )
                          ],
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (index1 != null) {
                        selectedCharge = '';
                        selectedExemption = exemptionsList[index1].serialId;
                        selectedExemptionId = exemptionsList[index1].id;
                        setState(() {});
                      }
                      if (selectedExemptionId == 2) {
                        paidBottomSheet(context);
                      }
                      if (selectedExemptionId != 2) {
                        _paidSelected = false;
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: CustomColors.yetToStartColor, boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 3),
                        )
                      ]),
                      child: Center(
                        heightFactor: 2.5,
                        child: Text(
                          "Select",
                          style: TextStyle20White,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void paidBottomSheet(context) {
    paidList.forEach((element) {
      element["isSelected"] = false;
    });
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStat) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black)),
                      color: materialAppThemeColor,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                          child: Text("Rx Charge", style: Bold20Style),
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _paidSelected = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                      ),
                      itemCount: paidList.length > 0 ? paidList.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setStat(() {
                                  for (var element in paidList) {
                                    element["isSelected"] = false;
                                  }
                                  paidList[index]["isSelected"] = !paidList[index]["isSelected"];
                                  selectedCharge = paidList[index]["value"];
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: paidList[index]["isSelected"],
                                    visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                    onChanged: (selected) {
                                      setStat(() {
                                        for (var element in paidList) {
                                          element["isSelected"] = false;
                                        }
                                        paidList[index]["isSelected"] = !paidList[index]["isSelected"];
                                        selectedCharge = paidList[index]["value"];
                                      });
                                    },
                                  ),
                                  Flexible(child: Text("x ${paidList[index]["value"]}"))
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _paidSelected = true;
                      selectedExemptionId = 2;
                      selectedExemption = "";
                      widget.orderInof.exemption = "";
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(color: CustomColors.yetToStartColor, boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1.0,
                          blurRadius: 5.0,
                          offset: Offset(0, 3),
                        )
                      ]),
                      child: Center(
                        heightFactor: 2.5,
                        child: Text(
                          "Select",
                          style: TextStyle6White,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  void subExpiryPopUp(String msg) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/sad.png"),
            title: "Alert...",
            btnDone: "Okay",
            btnNo: "",
            descriptions: msg,
          );
        });
  }

  void customToast(String msg, IconData check_circle, MaterialColor green) {
    FToast.toast(
      context,
      toast: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[100], border: Border.all(color: Colors.grey[400])),
        margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              check_circle,
              color: green,
              size: 80,
            ),
            SizedBox(height: 10),
            Text(
              msg,
              style: Bold16Style,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      duration: 3000,
    );
  }

  showToast(String message) {
    FToast.toast(context, msg: message);
  }

  Future<bool> _onWillPop() async {
    FocusScope.of(context).requestFocus(FocusNode());
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text("Warning"),
            content: new Text("Are you sure you want to cancel all prescriptions!"),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text("No"),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text("Yes"),
              ),
            ],
          ),
        )) ??
        false;
  }

  void openCalender() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: Colors.orangeAccent),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        }).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  Future<void> getPharmacyInfo(int pharmacyId) async {
    // if (!progressDialog.isShowing())
    //   progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.GET_PHARMACY_INFO + "?pharmacyId=$pharmacyId");
    _apiCallFram.getDataRequestAPI(WebConstant.GET_PHARMACY_INFO + "?pharmacyId=$pharmacyId", accessToken, context).then((response) async {
      // progressDialog.hide();
      getRoutes();
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          showToast("Authentication Failed. Login again");
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
        try {
          if (response != null) {
            logger.i(response.body);
            var model = json.decode(response.body);
            setState(() {
              isPresCharge = model["is_pres_charge"];
              isDelCharge = model["is_del_charge"];
              logger.i("isPresCharge: $isPresCharge");
            });
          }
        } catch (_, stackTrace) {
          // print(_);
          SentryExemption.sentryExemption(_, stackTrace);
          logger.i(_);
          showToast(WebConstant.ERRORMESSAGE);
          // progressDialog.hide();
          await CustomLoading().showLoadingDialog(context, false);
        }
      } catch (_, stackTrace) {
        logger.i(_);
        SentryExemption.sentryExemption(_, stackTrace);
        // print(_);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  Future<void> getRoutes() async {
    routeList.clear();
    // RouteList route = RouteList();
    // route.routeName = "Select Route";
    // routeList.add(route);
    // if (!progressDialog.isShowing()) progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    _apiCallFram.getDataRequestAPI(WebConstant.GET_ROUTE_URL_PHARMACY + "?pharmacyId=${widget.pharmacyId}", accessToken, context).then((response) async {
      // progressDialog.hide();
      logger.i('Delivery CHarge 0002');
      getDeliveryMasterData();

      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          showToast("Authentication Failed. Login again");
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
        try {
          if (response != null) {
            RouteModel model = routeModelFromJson(response.body);
            setState(() {
              RouteList routeListSeletecd = RouteList();
              routeListSeletecd.routeId = 0;
              routeListSeletecd.branchId = 0;
              routeListSeletecd.companyId = 0;
              routeListSeletecd.routeName = "Select Route";
              routeList.clear();
              routeList.add(routeListSeletecd);
              routeList.addAll(model.routeList);
              // print(routeList.length);

              if (widget.orderInof != null && widget.orderInof.default_delivery_type != null && widget.orderInof.default_delivery_type.toString().toLowerCase() == "collection") {
                // _isCollection = true;
              }
              if (userType.toLowerCase() == 'driver' && routeID != null) {
                widget.orderInof.default_delivery_route = routeID.toString();
              }
              if (widget.orderInof != null && widget.orderInof.default_delivery_route != null && widget.orderInof.default_delivery_route != "" && routeList.isNotEmpty && !_isCollection) {
                RouteList routeListSeletecd = RouteList();
                routeListSeletecd.routeId = widget.orderInof.default_delivery_route;
                int indexss = routeList.indexWhere((innerElement) => innerElement.routeId.toString() == widget.orderInof.default_delivery_route);
                if (indexss > 0) {
                  _selectedRoutePosition = indexss;
                  if (userType == 'Pharmacy' || userType == "Pharmacy Staff") getDriversByRoute(routeList[_selectedRoutePosition]);
                }
              } else {
                if (routeList.isNotEmpty && !_isCollection && routeList.length == 2) {
                  _selectedRoutePosition = 1;
                  if (userType == 'Pharmacy' || userType == "Pharmacy Staff") getDriversByRoute(routeList[_selectedRoutePosition]);
                }
              }
            });

            // if (routeList.length > 0) {
            //   getDriversByRoute(routeList[_selectedRoutePosition]);
            // }
          }
        } catch (_, stackTrace) {
          // print(_);
          SentryExemption.sentryExemption(_, stackTrace);
          logger.i(_);
          showToast(WebConstant.ERRORMESSAGE);
          // progressDialog.hide();
          await CustomLoading().showLoadingDialog(context, false);
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        // print(_);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  Future<void> getParcelBoxData(String driverId) async {
    parcelBoxList.clear();

    // if (!progressDialog.isShowing()) progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId");
    _apiCallFram.getDataRequestAPI(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId", accessToken, context).then((response) async {
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          showToast("Authentication Failed. Login again");
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
        try {
          if (response != null) {
            logger.i(response.body);
            GetParcelBoxApiResponse model = parcelBoxFromJson(response.body);
            setState(() {
              ParcelBoxData parcelBoxListSelected = ParcelBoxData();
              parcelBoxListSelected.id = 0;
              parcelBoxListSelected.name = "Parcel location";
              parcelDropdownValue = parcelBoxListSelected;
              parcelBoxList.clear();
              parcelBoxList.add(parcelBoxListSelected);
              parcelBoxList.addAll(model.data);
            });

            // if (routeList.length > 0) {
            //   getDriversByRoute(routeList[_selectedRoutePosition]);
            // }
          }
        } catch (_, stackTrace) {
          SentryExemption.sentryExemption(_, stackTrace);
          // print(_);
          logger.i(_);
          showToast(WebConstant.ERRORMESSAGE);
          // progressDialog.hide();
          await CustomLoading().showLoadingDialog(context, false);
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        // print(_);
        showToast(WebConstant.ERRORMESSAGE);
      }
      if (Ts != null) {
        var now = new DateTime.now();
        var berlinWallFellDate = new DateTime.utc(Ts.year, Ts.month, Ts.day);
        if (berlinWallFellDate.compareTo(now) < 0) {
          print("DT1 is before DT2");
          subExpiryPopUp('Your ${patientSubList[selectedSubscription].name} Subscription Expired by $datetime');
        }
      }
    });
  }

  // void getDeliveryMasterData() {
  //   routeList.clear();
  //   // RouteList route = RouteList();
  //   // route.routeName = "Select Route";
  //   // routeList.add(route);
  //   // if (!progressDialog.isShowing()) progressDialog.show();
  //   String url = WebConstant.GET_DeliveryMasterData_URL_PHARMACY + "?pharmacyId=${widget.pharmacyId}";
  //   logger.i(url);
  //   logger.i(accessToken);
  //   _apiCallFram
  //       .getDataRequestAPI(url,
  //           accessToken, context)
  //       .then((response) async {
  //     getParcelBoxData(userID);
  //     try {
  //       if (response != null &&
  //           response.body != null &&
  //           response.body == "Unauthenticated") {
  //         showToast("Authentication Failed. Login again");
  //         final prefs = await SharedPreferences.getInstance();
  //         prefs.remove('token');
  //         prefs.remove('userId');
  //         prefs.remove('name');
  //         prefs.remove('email');
  //         prefs.remove('mobile');
  //         prefs.remove('route_list');
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => LoginScreen(),
  //             ),
  //             ModalRoute.withName('/login_screen'));
  //         return;
  //       }
  //       try {
  //         if (response != null) {
  //           DeliveryMasterDataResponse model =
  //               DeliveryMasterDataResponse.fromJson(json.decode(response.body));
  //           setState(() {
  //             Shelf selectShelf = Shelf();
  //             selectShelf.name = "Select Shelf";
  //             selectShelf.id = 0;
  //             shelfList.clear();
  //             shelfList.add(selectShelf);
  //             shelfList.addAll(model.shelf);
  //
  //             Shelf selectService = Shelf();
  //             selectService.name = "Select Service";
  //             selectService.id = 0;
  //             servicesList.clear();
  //             nursingHomeLIst.clear();
  //             servicesList.add(selectService);
  //             servicesList.addAll(model.services);
  //             deliveryTypeList = model.deliveryType;
  //             //Nursing Home
  //             NursingHome selectNursingHome = NursingHome();
  //             selectNursingHome.nursing_home_name = "Select Nursing Home";
  //             selectNursingHome.id = 0;
  //             nursingHomeLIst.add(selectNursingHome);
  //             if(model.nursingHome != null &&model.nursingHome.isNotEmpty  )
  //               nursingHomeLIst.addAll(model.nursingHome);
  //
  //
  //             PatientSubscription patientSub = PatientSubscription();
  //             patientSub.id = 0;
  //             patientSub.name = "Select Delivery Charge";
  //             patientSub.noOfDays = 0;
  //             patientSubList.clear();
  //             patientSubList.add(patientSub);
  //             if(model != null && model.patientSub != null && model.patientSub.isNotEmpty){
  //               patientSubList.addAll(model.patientSub);
  //             }
  //             if (widget.orderInof != null &&
  //                 widget.orderInof.delSubsId != null) {
  //               int index = patientSubList.indexWhere((element) =>
  //               element.id == widget.orderInof.delSubsId);
  //                 selectedSubscription = index;
  //             }
  //             // print(routeList.length);
  //
  //             if (widget.orderInof != null &&
  //                 widget.orderInof.default_delivery_type != null &&
  //                 widget.orderInof.default_delivery_type != "" &&
  //                 widget.orderInof.default_delivery_type
  //                         .toString()
  //                         .toLowerCase() ==
  //                     "collection" &&
  //                 deliveryTypeList.length > 0) {
  //               _selectedDeliveryTypePosition = 0;
  //             }
  //
  //             exemptionsList.clear();
  //             if(model.exemptions != null && model.exemptions.isNotEmpty && model.exemptions.length > 0){
  //               exemptionsList.addAll(model.exemptions);
  //             }
  //
  //             if (widget.orderInof != null &&
  //                 widget.orderInof.default_service != null &&
  //                 widget.orderInof.default_service != "") {
  //               int index = servicesList.indexWhere((element) =>
  //                   element.id == widget.orderInof.default_service);
  //               if (index > 0) {
  //                 _selectedServicePosition = index;
  //               }
  //             }
  //             logger.i(widget.pmrList[0].xml.patientInformation.nhs);
  //
  //             if(widget.pmrList != null && widget.pmrList.isNotEmpty){
  //               if(widget.pmrList[0].xml != null && widget.pmrList[0].xml.patientInformation != null && widget.pmrList[0].xml.patientInformation.nursing_home_id != null){
  //                 int index = nursingHomeLIst.indexWhere((element) =>
  //                 element.nursing_home_id.toString() ==widget.pmrList[0].xml.patientInformation.nursing_home_id.toString());
  //                 if (index > 0) {
  //                   _selectedNursingHomePosition = index;
  //                 }
  //               }
  //             }
  //             // if (widget.orderInof != null &&
  //             //     widget.orderInof.nursing_home_id != null &&
  //             //     widget.orderInof.nursing_home_id.s0 != "") {
  //             //   int index = nursingHomeLIst.indexWhere((element) =>
  //             //   element.nursing_home_id.toString() == widget.orderInof.nursing_home_id.s0);
  //             //   if (index > 0) {
  //             //     _selectedNursingHomePosition = index;
  //             //   }
  //             // }
  //           });
  //         }
  //       } catch (_,stackTrace) {
  //         SentryExemption.sentryExemption(_, stackTrace);
  //         logger.i(_);
  //         showToast(WebConstant.ERRORMESSAGE);
  //         // ProgressDialog(context).hide();
  //       }
  //     } catch (_,stackTrace) {
  //       SentryExemption.sentryExemption(_, stackTrace);
  //       logger.i(_);
  //       showToast(WebConstant.ERRORMESSAGE);
  //     }
  //   });
  // }

  void getDeliveryMasterData() {
    routeList.clear();
    _apiCallFram.getDataRequestAPI(WebConstant.GET_DeliveryMasterData_URL_PHARMACY + "?pharmacyId=${0}", accessToken, context).then((response) async {
      getParcelBoxData(userID);
      // progressDialog.hide();
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          showToast("Authentication Failed. Login again");
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
        } else
          try {
            if (response != null) {
              DeliveryMasterDataResponse model = DeliveryMasterDataResponse.fromJson(json.decode(response.body));
              logger.i(response.body);
              logger.i('Delivery CHarge 0001');
              setState(() {
                Shelf selectShelf = Shelf();
                selectShelf.name = "Select Shelf";
                selectShelf.id = 0;
                shelfList.clear();
                shelfList.add(selectShelf);
                shelfList.addAll(model.shelf);
                rxCharge = model.rxCharge;

                Shelf selectService = Shelf();
                selectService.name = "Select Service";
                selectService.id = 0;
                servicesList.clear();
                servicesList.add(selectService);
                servicesList.addAll(model.services);

                deliveryTypeList = model.deliveryType;
                // print(routeList.length);
                PatientSubscription patientSub = PatientSubscription();
                patientSub.id = 0;
                patientSub.name = "Select Delivery Charge";
                patientSub.noOfDays = 0;
                patientSubList.clear();
                patientSubList.add(patientSub);
                if (model != null && model.patientSub != null && model.patientSub.isNotEmpty) {
                  patientSubList.addAll(model.patientSub);
                }

                logger.i('Patient List length: ${patientSubList.length}');
                if (widget.orderInof != null && widget.orderInof.delSubsId != null) {
                  int index = patientSubList.indexWhere((element) => element.id == widget.orderInof.delSubsId);

                  logger.i('$index');

                  logger.i('Delivery CHarge 0003');
                  selectedSubscription = 0;
                  //  selectedSubscription = widget.orderInof.delSubsId;
                  //  dailyId = index;

                  //    perDelivey = patientSubList[index].name;
                  //    deliveryChargeController.text = patientSubList[index].price;

                  // patientSubList.forEach((element) {
                  //    if(index == element.id){
                  //      perDelivey = element.name;
                  //    }
                  // });
                  //perDelivey = ;

                  logger.i('selectedSubscription  INDEX: ${widget.orderInof.delSubsId}');
                  logger.i('selectedSubscription : ${widget.orderInof.delSubsId}');
                }

                // Surgery surgery = Surgery();
                // surgeryList.clear();
                // surgery.name = "Select Surgery";
                // surgery.mobileNo = "N/A";
                // surgery.id = 0;
                // surgeryList.add(surgery);
                // surgeryList.addAll(model.surgery);
                //
                // if (widget.orderInof != null &&
                //     widget.orderInof.surgeryName != null &&
                //     widget.orderInof.surgeryName != "" &&
                //     surgeryList.length > 0) {
                //   int index = surgeryList.indexWhere((element) =>
                //   element.name == widget.orderInof.surgeryName);
                // //  _selectedSurgeryPosition = index;
                // }

                exemptionsList.clear();
                if (model.exemptions != null && model.exemptions.isNotEmpty && model.exemptions.length > 0) {
                  exemptionsList.addAll(model.exemptions);
                }
                if (widget.orderInof != null && widget.orderInof.paymentExemption != null && exemptionsList != null && exemptionsList.length > 0) {
                  int index = exemptionsList.indexWhere((element) => element.id == widget.orderInof.paymentExemption);
                  if (exemptionsList[index].serialId != null && exemptionsList[index].serialId != "") widget.orderInof.exemption = exemptionsList[index].serialId;
                  exemptionsList[index].isSelected = true;
                }

                NursingHome selectNursingHome = NursingHome();
                selectNursingHome.nursing_home_name = "Select Nursing Home";
                selectNursingHome.id = 0;
                nursingHomeLIst.add(selectNursingHome);
                if (model.nursingHome != null && model.nursingHome.isNotEmpty) nursingHomeLIst.addAll(model.nursingHome);

                if (widget.orderInof != null && widget.orderInof.default_delivery_type != null && widget.orderInof.default_delivery_type != "" && widget.orderInof.default_delivery_type.toString().toLowerCase() == "collection" && deliveryTypeList.length > 0) {
                  _selectedDeliveryTypePosition = 0;
                }

                if (widget.orderInof != null && widget.orderInof.default_service != null && widget.orderInof.default_service != "") {
                  int index = servicesList.indexWhere((element) => element.id == widget.orderInof.default_service);
                  if (index > 0) {
                    _selectedServicePosition = index;
                  }
                }
                if (widget.orderInof != null && widget.orderInof.nursing_home_id != null && widget.orderInof.nursing_home_id != "") {
                  int index = nursingHomeLIst.indexWhere((element) => element.nursing_home_id.toString() == widget.orderInof.nursing_home_id.toString());
                  if (index > 0) {
                    _selectedNursingHomePosition = index;
                  }
                }
              });
            }
          } catch (_, stackTrace) {
            SentryExemption.sentryExemption(_, stackTrace);
            showToast(WebConstant.ERRORMESSAGE);
          }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  Future<void> getDriversByRoute(RouteList route) async {
    // if (!progressDialog.isShowing()) progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    String parms = "?routeId=${route.routeId ?? ""}";
    _apiCallFram.getDataRequestAPI("${WebConstant.GetPHARMACYDriverListByRoute}$parms", accessToken, context).then((response) async {
      // print(response);
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      driverList.clear();
      // ProgressDialog(context, isDismissible: false).show();
      DriverModel driverModel = new DriverModel();
      driverModel.driverId = 0;
      driverModel.firstName = "Select Driver";
      driverList.add(driverModel);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          showToast("Authentication Failed. Login again");
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
        if (response != null) {
          setState(() {
            _selectedDriverPosition = 0;
            driverList.addAll(driverModelFromJson(response.body));
            if (driverList.isNotEmpty && driverList.length == 2) {
              _selectedDriverPosition = 1;
              getParcelBoxData(driverList[_selectedDriverPosition].driverId.toString());
            }
          });
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  void loadPrescription(String resultData) {
    bool isAddPrescription = true;
    try {
      // print(resultData);
      final parser = Xml2Json();
      parser.parse(resultData);
      var json = parser.toGData();
      // print(json.toString());
      PmrModel model = pmrModelFromJson(json);
      // print(
      //     "..${model.xml.dd.length}.................................................");
      if (widget.pmrList[0].xml.patientInformation.nhs == model.xml.patientInformation.nhs) {
        for (PmrModel pmrModel in widget.pmrList) {
          if (pmrModel.xml.sc.id == model.xml.sc.id) {
            customToast("This prescription already added!", Icons.warning_amber_rounded, Colors.orange);
            isAddPrescription = false;
            return;
          }
        }
        customToast("This prescription added!", Icons.check_circle, Colors.green);
        setState(() {
          if (isAddPrescription) {
            widget.pmrList.add(model);
            widget.prescriptionList.addAll(model.xml.dd);
          }
        });
      } else {
        customToast("This prescription not belongs to existing patient", Icons.warning_amber_rounded, Colors.red);
      }
    } catch (_, stackTrace) {
      SentryExemption.sentryExemption(_, stackTrace);
      customToast("This prescription is invalid", Icons.warning_amber_rounded, Colors.orange);
      // print(".Exception.................................................$_");
    }
  }

  Future<void> postDataAndVerifyUser(PmrModel model) async {
    // progressDialog.show();

    await CustomLoading().showLoadingDialog(context, true);
    List<Map<String, dynamic>> medicineList = [];

    if (widget.type == "4" || widget.type == "3" || widget.type == "6" || widget.type == "2") {
      if (medicineMainList != null && medicineMainList.isNotEmpty) {
        medicineMainList.forEach((element) {
          Map<String, dynamic> medicine1 = {
            "drug_type_cd": element.isControlDrug != null
                ? element.isControlDrug
                    ? "t"
                    : "f"
                : "f",
            "drug_type_fr": element.isFridge != null
                ? element.isFridge
                    ? "t"
                    : "f"
                : "f",
            "pr_id": widget.pmrList[0].xml.sc.id ?? "",
            "medicine_name": element.name ?? "",
            "dosage": "",
            "quantity": element.quntity ?? "",
            "remark": "",
            "days": element.days ?? "",
          };
          medicineList.add(medicine1);
        });
      }
    } else {
      if (widget.prescriptionList != null && widget.prescriptionList.isNotEmpty) {
        widget.prescriptionList.forEach((element) {
          Map<String, dynamic> medicine1 = {
            "drug_type_cd": element.drugsTypeCD != null
                ? element.drugsTypeCD
                    ? "t"
                    : "f"
                : "f",
            "drug_type_fr": element.drugsTypeFr != null
                ? element.drugsTypeFr
                    ? "t"
                    : "f"
                : "f",
            "pr_id": widget.pmrList[0].xml.sc.id ?? "",
            "medicine_name": element.d ?? "",
            "dosage": element.ddDo ?? "",
            "quantity": element.q ?? "",
            "remark": "",
            "days": element.sq ?? "",
          };
          medicineList.add(medicine1);
        });
      }
    }
    String gender = "M";
    if (widget.pmrList[0].xml.patientInformation.salutation != null) if (widget.pmrList[0].xml.patientInformation.salutation.endsWith("Mrs") || widget.pmrList[0].xml.patientInformation.salutation.endsWith("Miss") || widget.pmrList[0].xml.patientInformation.salutation.endsWith("Ms")) {
      gender = "F";
    }
    int status = 0;
    if (dropdownValue == "Received") {
      status = 2;
    } else if (dropdownValue == "Requested") {
      status = 1;
    } else if (dropdownValue == "Ready") {
      status = 3;
    } else if (dropdownValue == "PickedUp") {
      status = 8;
    }
    if (driverType == Constants.dadicatedDriver && isStartRoute) {
      status = 4;
    }
    String driverID = "";
    if (userType == 'Pharmacy' || userType == "Pharmacy Staff") {
      driverID = _selectedDriverPosition != 0 ? driverList[_selectedDriverPosition].driverId.toString() : "";
    } else {
      driverID = userID;
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
      "start_lat": isStartRoute ? "$startLat" : "",
      "start_lng": isStartRoute ? "$startLng" : "",
      "del_charge": deliveryChargeController.text.toString().trim(),
      "rx_charge": rxCharge,
      "subs_id": patientSubList[selectedSubscription].id,
      "rx_invoice": selectedExemptionId == 2 ? selectedCharge : "",
      "del_subs_id": selectedSubscription > 0 ? patientSubList[selectedSubscription].id : 0,
      "nursing_homes_id": _selectedNursingHomePosition != 0 ? nursingHomeLIst[_selectedNursingHomePosition].nursing_home_id : 0,
      "pmr_type": widget.type,
      "otherpharmacy": widget.otherPharmacy,
      "titan_scan_info": widget.orderInof.titanScaInfo != null ? widget.orderInof.titanScaInfo : "",
      "amount": widget.amount,
      "exemption": selectedExemptionId,
      //_exemptSelected ? selectedExemptionId != null ? selectedExemptionId : 0 : 0,
      "paymentStatus": selectedExemptionId == 2
          ? selectedCharge != null && selectedCharge.isNotEmpty
              ? selectedCharge
              : ""
          : "",
      "bag_size": id != -1
          ? bagSizeList[id] != null && bagSizeList[id].isNotEmpty
              ? bagSizeList[id]
              : ""
          : "",
      "patient_id": widget.pmrList[0].xml.customerId,
      "pr_id": widget.pmrList[0].xml.sc != null ? widget.pmrList[0].xml.sc.id ?? "" : "",
      "lat": "",
      //na
      "lng": "",
      //na
      "parcel_box_id": parcelDropdownValue != null && parcelDropdownValue.id != null ? parcelDropdownValue.id : 0,
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
      "delivery_type": deliveryTypeList[_selectedDeliveryTypePosition] ?? "",
      "driver_id": driverID,
      "delivery_route": _selectedRoutePosition != 0 ? routeList[_selectedRoutePosition].routeId : "",
      "storage_type_cd": _controlSelected ? "t" : "f",
      "storage_type_fr": _fridgeSelected ? "t" : "f",
      "delivery_status": status.toString(),
      "shelf": _selectedShelfPosition != 0 ? shelfList[_selectedShelfPosition].id : "",
      "delivery_service": _selectedServicePosition != 0 ? servicesList[_selectedServicePosition].id : "",
      "doctor_name": widget.pmrList[0].xml.doctorInformation != null ? widget.pmrList[0].xml.doctorInformation.doctorName ?? "" : "",
      "doctor_address": widget.pmrList[0].xml.doctorInformation != null ? widget.pmrList[0].xml.doctorInformation.address ?? "" : "",
      "new_delivery_notes": recentNoteController.text != null
          ? recentNoteController.text.toString() != "null"
              ? recentNoteController.text.toString().trim()
              : ""
          : "",
      "existing_delivery_notes": widget.orderInof != null && widget.orderInof.default_delivery_note != null && widget.orderInof.default_delivery_note != "" ? widget.orderInof.default_delivery_note : "",
      "branch_notes": branchController.text.toString().trim(),
      "surgery_notes": surgeryController.text.toString().trim(),
      "medicine_name": medicineList,
      "delivery_date": selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate) : "",
      "prescription_images": imagePicker.imageList != null ? imagePicker.imageList : [],
    };
    // print(data);
    logger.i(WebConstant.UUDATE_CUSTOMER_WITH_ORDER);
    logger.i(data);
    // print(jsonEncode(data));
    logger.i(data);
    _apiCallFram.postDataAPI(WebConstant.UUDATE_CUSTOMER_WITH_ORDER, accessToken, data, context).then((response) async {
      // print(response);
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          // print("${response.body}");
          Map<String, Object> data = json.decode(response.body);
          if (data["error"] == false) {
            customToast(data["message"], Icons.check_circle, Colors.green);
            Navigator.of(context).pop(false);
            widget.callApi.isSelected(true);
            // if(driverType == Constants.sharedDriver || driverType == Constants.dadicatedDriver) {
            //   Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => DashboardDriver(0),
            //       ),
            //       ModalRoute.withName('/dashboard_driver'));
            // }else{
            //   Navigator.of(context).pop(false);
            // }
          } else {
            customToast(data["message"], Icons.warning_amber_rounded, Colors.orange);
          }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        //ProgressDialog(context).hide();
        print("Exception : $e");
      }
    });
  }
}

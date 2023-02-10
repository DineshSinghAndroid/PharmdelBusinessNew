// @dart=2.9

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:ftoast/ftoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/DeliveryMasterDataResponse.dart';
import 'package:pharmdel_business/model/MedicineReaponse.dart';
import 'package:pharmdel_business/model/ProcessScanPatientResponse.dart';
import 'package:pharmdel_business/model/driver_model.dart';
import 'package:pharmdel_business/model/route_model.dart';
import 'package:pharmdel_business/provider/repeat_prescription_imageProvider.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/branch_admin_dashboard.dart';
import 'package:pharmdel_business/ui/driver_user_type/dashboard_driver.dart';
import 'package:pharmdel_business/util/CustomDialogBox.dart';
import 'package:pharmdel_business/util/text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../model/parcel_box_api_response.dart';
import '../../util/calling_util.dart';
import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../util/custom_color.dart';
import '../../util/custom_loading.dart';
import '../../util/permission_utils.dart';
import '../../util/sentryExeptionHendler.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import 'medicine_list.dart';

class DeliveryScheduleManual extends StatefulWidget {
  OrderInfo orderInof;

  var prescriptionList = [];
  BulkScanMode callApi;

  DeliveryScheduleManual({this.orderInof, this.callApi});

  StateDeliverySchedule createState() => StateDeliverySchedule();
}

class StateDeliverySchedule extends State<DeliveryScheduleManual> {
  ApiCallFram _apiCallFram = ApiCallFram();
  FToast fToast;
  String accessToken = "";
  String userType = "";
  String userID = "";
  String scannedData, selectedRoute;
  DateTime selectedDate;
  List<RouteList> routeList = [];
  List<Shelf> shelfList = [];
  List<Shelf> servicesList = [];
  List<String> deliveryTypeList = [];
  List<Surgery> surgeryList = [];

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
  int _selectedDeliveryTypePosition = 0;
  int _selectedSurgeryPosition = 0;
  int _selectedDriverPosition = 0;

  bool _isCollection = false;

  BuildContext context1;

  // ProgressDialog progressDialog;

  var _fridgeSelected = false;

  var _controlSelected = false;
  var _paidSelected = false;
  var _exemptSelected = false;

  List<MedicineDataList> medicineList = [];

  FocusNode focus = FocusNode();

  List<TextEditingController> _controllersDays = new List();
  List<TextEditingController> _controllersQty = new List();

  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController preChargeController = TextEditingController();

  String totalAmount = "0.00";
  String rxCharge;

  dynamic subExpDate;

  String dropdownValue = 'Received';
  ParcelBoxData parcelDropdownValue;
  RepeatPrescriptionImageProvider imagePicker;

  String routeID;
  List<NursingHome> nursingHomeLIst = [];
  int _selectedNursingHomePosition = 0;
  RepeatPrescriptionImageProvider provider;

  List<ParcelBoxData> parcelBoxList = [];
  List<String> selectedExemptions = [];
  int selectedExemptionId;

  List<String> bagSizeList = ["S", "M", "L", "C"];

  int id = -1;

  List<Exemptions> exemptionsList = [];
  List<PatientSubscription> patientSubList = [];
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

  String selectedExemption = "";

  int selectedSubscription = 0;
  int dailyId;
  String perDelivey = '';
  String datetime;
  DateTime Ts;
  bool isStartRoute = false;
  int isPresCharge;
  int startRouteId;
  int endRouteId;
  int isDelCharge;
  double startLat;
  double startLng;
  int pharmacyId;

  String driverType = "";

  @override
  Widget build(BuildContext context) {
    context1 = context;
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
          //     margin: EdgeInsets.ondely(right: 10),
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
                            if (widget.orderInof != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("${widget.orderInof != null ? "${widget.orderInof.title ?? ""}"
                                    " ${widget.orderInof.firstName ?? ""} "
                                    "${widget.orderInof.middleName ?? ""} "
                                    "${widget.orderInof.lastName ?? ""}" : ""}"),
                              ),
                            if (widget.orderInof != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.orderInof.userId == 0 ? "DOB: ${widget.orderInof != null ? "${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.orderInof.dob)) ?? ""}" : ""}" : "DOB : ${widget.orderInof.dob}"),
                              ),
                            if (widget.orderInof != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("NHS: ${widget.orderInof != null ? "${widget.orderInof.nhsNumber ?? ""}" : ""}"),
                              ),
                            if (widget.orderInof != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text("Address: ${widget.orderInof != null ? "${widget.orderInof.address ?? ""}"
                                          ", Post Code: ${widget.orderInof.postCode ?? ""} " : ""}"),
                                    ),
                                    if (widget.orderInof != null && widget.orderInof.alt_address != null && widget.orderInof.alt_address != "" && widget.orderInof.alt_address == "t")
                                      Image.asset(
                                        "assets/alt-add.png",
                                        height: 18,
                                        width: 18,
                                      ),
                                  ],
                                ),
                              ),
                            if (widget.orderInof != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    if (widget.orderInof.mobile_no != null && widget.orderInof.mobile_no.isNotEmpty) {
                                      makePhoneCall(widget.orderInof.mobile_no);
                                    }
                                  },
                                  child: Text("Contact: ${widget.orderInof != null ? "${widget.orderInof.mobile_no ?? ""}" : ""}"),
                                ),
                              ),
                            if (widget.orderInof != null)
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Email: ${widget.orderInof != null ? "${widget.orderInof.email ?? ""}" : ""}"),
                              ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 0.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                        // color: Colors.yellow[100],
                        child: Column(
                          children: [
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       left: 15, bottom: 0, top: 0, right: 15),
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     "MEDICINE INFO",
                            //     style: TextStyle(
                            //         color: Colors.blueGrey,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w800),
                            //   ),
                            // ),
                            // ListView.builder(
                            //   physics: NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   itemCount: medicineList.length,
                            //   itemBuilder: (BuildContext context, index) {
                            //     _controllersDays
                            //         .add(new TextEditingController());
                            //     _controllersQty
                            //         .add(new TextEditingController());
                            //
                            //     return Column(
                            //       children: [
                            //         ListTile(
                            //           visualDensity: VisualDensity(
                            //               horizontal: 0, vertical: -4),
                            //           minVerticalPadding: 5.0,
                            //           title: Text(
                            //             medicineList[index].name ?? "",
                            //             style: TextStyle(
                            //                 fontSize: 15,
                            //                 fontWeight: FontWeight.bold),
                            //           ),
                            //         ),
                            //         Row(
                            //           children: [
                            //             Container(
                            //               margin: EdgeInsets.only(left: 18.0),
                            //               width: 100,
                            //               height: 50,
                            //               child: new TextFormField(
                            //                 style: TextStyle(fontSize: 17),
                            //                 controller: _controllersQty[index],
                            //                 textCapitalization:
                            //                     TextCapitalization.words,
                            //                 textInputAction:
                            //                     TextInputAction.done,
                            //                 keyboardType: TextInputType.number,
                            //                 autofocus: false,
                            //                 enabled: true,
                            //                 maxLength: 50,
                            //                 maxLines: 1,
                            //                 onChanged: (value) {
                            //                   medicineList[index].quntity =
                            //                       value;
                            //                   setState(() {});
                            //                 },
                            //                 decoration: new InputDecoration(
                            //                     counter: Offstage(),
                            //                     contentPadding:
                            //                         EdgeInsets.only(left: 10.0),
                            //                     hintText: "Quantity",
                            //                     border: new OutlineInputBorder(
                            //                         borderRadius:
                            //                             const BorderRadius.all(
                            //                                 const Radius
                            //                                         .circular(
                            //                                     5.0)))),
                            //                 onFieldSubmitted: (v) {
                            //                   FocusScope.of(context)
                            //                       .requestFocus(focus);
                            //                 },
                            //               ),
                            //             ),
                            //             Container(
                            //               margin: EdgeInsets.only(left: 18.0),
                            //               width: 100,
                            //               height: 50,
                            //               child: new TextFormField(
                            //                 style: TextStyle(fontSize: 17),
                            //                 controller: _controllersDays[index],
                            //                 textCapitalization:
                            //                     TextCapitalization.words,
                            //                 textInputAction:
                            //                     TextInputAction.done,
                            //                 keyboardType: TextInputType.number,
                            //                 autofocus: false,
                            //                 enabled: true,
                            //                 maxLength: 50,
                            //                 maxLines: 1,
                            //                 decoration: new InputDecoration(
                            //                     counter: Offstage(),
                            //                     contentPadding:
                            //                         EdgeInsets.only(left: 10.0),
                            //                     hintText: "Days",
                            //                     border: new OutlineInputBorder(
                            //                         borderRadius:
                            //                             const BorderRadius.all(
                            //                                 const Radius
                            //                                         .circular(
                            //                                     5.0)))),
                            //                 onFieldSubmitted: (v) {
                            //                   FocusScope.of(context)
                            //                       .requestFocus(focus);
                            //                 },
                            //                 onChanged: (value) {
                            //                   medicineList[index].days = value;
                            //                   setState(() {});
                            //                 },
                            //               ),
                            //             ),
                            //             Expanded(child: Container()),
                            //             Container(
                            //               margin: EdgeInsets.only(right: 10.0),
                            //               height: 40,
                            //               width: 50,
                            //               decoration: BoxDecoration(
                            //                   color: Colors.redAccent,
                            //                   borderRadius:
                            //                       BorderRadius.circular(5.0)),
                            //               child: InkWell(
                            //                 onTap: () {
                            //                   medicineList.removeAt(index);
                            //                   _controllersDays.removeAt(index);
                            //                   _controllersQty.removeAt(index);
                            //                   // medicineList.removeWhere((item) => item.id == medicineList[index].id);
                            //                   setState(() {});
                            //                 },
                            //                 child: Icon(
                            //                   Icons.delete,
                            //                   color: Colors.white,
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Container(
                            //           margin: EdgeInsets.only(
                            //               left: 18.0, top: 2, bottom: 10),
                            //           child: Row(
                            //             children: <Widget>[
                            //               Text(
                            //                 "Storage : ",
                            //                 style: TextStyle(
                            //                     color: Colors.orangeAccent),
                            //               ),
                            //               Container(
                            //                 height: 30,
                            //                 padding: EdgeInsets.only(right: 15),
                            //                 decoration: BoxDecoration(
                            //                   borderRadius:
                            //                       BorderRadius.circular(10.0),
                            //                   color: Colors.blue,
                            //                 ),
                            //                 child: Row(
                            //                   children: [
                            //                     Checkbox(
                            //                       value: medicineList[index]
                            //                                   .isFridge !=
                            //                               null
                            //                           ? medicineList[index]
                            //                               .isFridge
                            //                           : false,
                            //                       onChanged: (newValue) {
                            //                         setState(() {
                            //                           medicineList[index]
                            //                               .isFridge = newValue;
                            //                         });
                            //                       },
                            //                     ),
                            //                     new Text(
                            //                       'FRIDGE',
                            //                       style: TextStyle(
                            //                           color: Colors.white),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //               SizedBox(
                            //                 width: 10,
                            //               ),
                            //               Container(
                            //                 height: 30,
                            //                 padding: EdgeInsets.only(right: 15),
                            //                 decoration: BoxDecoration(
                            //                   borderRadius:
                            //                       BorderRadius.circular(10.0),
                            //                   color: Colors.red,
                            //                 ),
                            //                 child: Row(
                            //                   children: [
                            //                     Checkbox(
                            //                       value: medicineList[index]
                            //                                   .isControlDrug !=
                            //                               null
                            //                           ? medicineList[index]
                            //                               .isControlDrug
                            //                           : false,
                            //                       onChanged: (newValue) {
                            //                         setState(() {
                            //                           medicineList[index]
                            //                                   .isControlDrug =
                            //                               newValue;
                            //                         });
                            //                       },
                            //                     ),
                            //                     new Text(
                            //                       'C. D.',
                            //                       style: TextStyle(
                            //                           color: Colors.white),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //         Divider(
                            //           height: 2.0,
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineList())).then((value) {
                                        // print(value);
                                        if (value.drugInfo != null && value.drugInfo > 0) {
                                          value.isControlDrug = true;
                                        }
                                        bool checkValid = false;
                                        medicineList.forEach((element) {
                                          if (value.id == element.id) {
                                            checkValid = true;
                                          }
                                        });
                                        if (!checkValid) {
                                          if (value != null) {
                                            medicineList.add(value);
                                            setState(() {});
                                          }
                                        } else
                                          showToast("Medicine is already Selected");
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Container(
                                      width: 100,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.blue, border: Border.all(color: Colors.grey[400])),
                                      margin: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "+ Meds",
                                        textAlign: TextAlign.center,
                                        style: Bold16Style,
                                      ),
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
                                      child: Text("Rx Image", textAlign: TextAlign.center, style: TextStylewhite14),
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
                                                    border: Border(bottom: BorderSide(color: Colors.black)),
                                                    color: materialAppThemeColor,
                                                    // borderRadius: BorderRadius.only(
                                                    //     topLeft: Radius.circular(10),
                                                    //     topRight:
                                                    //     Radius.circular(10)),
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
                                                Expanded(
                                                  child: ListView.separated(
                                                    shrinkWrap: true,
                                                    separatorBuilder: (context, index) => Divider(
                                                      color: Colors.grey,
                                                    ),
                                                    itemCount: medicineList.length,
                                                    itemBuilder: (context, index) {
                                                      _controllersDays.add(new TextEditingController());
                                                      _controllersQty.add(new TextEditingController());
                                                      return Column(
                                                        children: [
                                                          ListTile(
                                                            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                                            minVerticalPadding: 5.0,
                                                            title: Text(
                                                              medicineList[index].name ?? "",
                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(left: 18.0),
                                                                width: 100,
                                                                height: 50,
                                                                child: new TextFormField(
                                                                  style: TextStyle(fontSize: 17),
                                                                  controller: _controllersQty[index],
                                                                  textCapitalization: TextCapitalization.words,
                                                                  textInputAction: TextInputAction.done,
                                                                  //   keyboardType: TextInputType.number,
                                                                  keyboardType: TextInputType.numberWithOptions(signed: true),
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                  ],
                                                                  autofocus: false,
                                                                  enabled: true,
                                                                  maxLength: 50,
                                                                  maxLines: 1,
                                                                  onChanged: (value) {
                                                                    medicineList[index].quntity = value;
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
                                                                  style: TextStyle(fontSize: 17),
                                                                  controller: _controllersDays[index],
                                                                  textCapitalization: TextCapitalization.words,
                                                                  textInputAction: TextInputAction.done,
                                                                  // keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
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
                                                                    medicineList[index].days = value;
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
                                                                    medicineList.removeAt(index);
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
                                                                // Text(
                                                                //   "Storage : ",
                                                                //   style: TextStyle(
                                                                //       color: Colors.orangeAccent),
                                                                // ),
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
                                                                        value: medicineList[index].isFridge != null ? medicineList[index].isFridge : false,
                                                                        onChanged: (newValue) {
                                                                          setState(() {
                                                                            medicineList[index].isFridge = newValue;
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
                                                                  padding: EdgeInsets.only(right: 5),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                    color: Colors.red,
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Checkbox(
                                                                        visualDensity: VisualDensity(horizontal: -4),
                                                                        value: medicineList[index].isControlDrug != null ? medicineList[index].isControlDrug : false,
                                                                        onChanged: (newValue) {
                                                                          setState(() {
                                                                            medicineList[index].isControlDrug = newValue;
                                                                          });
                                                                        },
                                                                      ),
                                                                      new Text(
                                                                        'C. D.',
                                                                        style: TextStyle(color: Colors.white),
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
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: imagePicker.images.length > 0 ? 70 : 0,
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 45,
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

                      Divider(
                        color: Colors.grey,
                        height: 0.0,
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(
                      //       left: 15, right: 0, top: 0, bottom: 0),
                      //   // color: Colors.red[100],
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         margin: EdgeInsets.only(
                      //             left: 0, bottom: 0, top: 0, right: 5),
                      //         alignment: Alignment.centerLeft,
                      //         child: Text(
                      //           "SURGERY INFO",
                      //           style: TextStyle(
                      //               color: Colors.blueGrey,
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w800),
                      //         ),
                      //       ),
                      //       Container(
                      //           width: MediaQuery.of(context).size.width,
                      //           margin: EdgeInsets.only(
                      //               top: 10, bottom: 10, right: 15),
                      //           padding: const EdgeInsets.only(
                      //               left: 10.0, right: 10.0),
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //               // color: Colors.blueGrey,
                      //               border:
                      //                   Border.all(color: Colors.grey[400])),
                      //           child: DropdownButtonHideUnderline(
                      //             child: DropdownButton(
                      //               isExpanded: true,
                      //               value: _selectedSurgeryPosition,
                      //               items: [
                      //                 for (Surgery route in surgeryList)
                      //                   DropdownMenuItem(
                      //                     child: Text("${route.name}",
                      //                         overflow: TextOverflow.ellipsis,
                      //                         style: TextStyle(
                      //                             color: Colors.black87)),
                      //                     value: surgeryList.indexOf(route),
                      //                   ),
                      //               ],
                      //               onChanged: (int value) {
                      //                 setState(() {
                      //                   _selectedSurgeryPosition = value;
                      //                 });
                      //               },
                      //             ),
                      //           )),
                      //     ],
                      //   ),
                      // ),
                      // Divider(
                      //   color: Colors.grey,
                      // ),
                      //Delivery Info ------------------------------------------------------------------------------------
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
                        // color: Colors.blue[100],
                        child: Column(
                          children: [
                            // Container(
                            //   margin: EdgeInsets.only(
                            //       left: 0, bottom: 0, top: 0, right: 0),
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
                                //           margin: EdgeInsets.only(top: 5.0,bottom: 5, right: 15),
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
                                //                   _isCollection = false;
                                //                   _selectedDeliveryTypePosition = value;
                                //                 });
                                //               },
                                //             ),
                                //           ))
                                //       : SizedBox(),
                                // ),
                                Flexible(
                                  flex: 1,
                                  child: servicesList.length > 0
                                      ? Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 5.0, bottom: 5),
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
                                                      child: Container(
                                                        child: Text("${route.name ?? ""}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
                                                      ),
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
                                  height: 30,
                                  child: Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Bag Size ",
                                              style: TextStyle(color: Colors.green),
                                            ),
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.shopping_bag_outlined,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                            ),
                                            TextSpan(text: ":", style: TextStyle(color: Colors.green)),
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
                                              SizedBox(
                                                width: 8.0,
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
                                            margin: EdgeInsets.only(right: 15, top: 0, bottom: 5),
                                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                // color: Colors.blueGrey,
                                                border: Border.all(color: Colors.grey[400])),
                                            child: InkWell(
                                                onTap: () {
                                                  logger.i(driverType);
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

                                                        TextSpan(text: "${selectedDate == null ? "Schedule" : DateFormat("dd-MMM-yyyy").format(selectedDate)}", style: TextStyle(color: Colors.black87, fontSize: 13)),
                                                      ],
                                                    ),
                                                  ),
                                                )))),
                                  if (routeList != null && routeList.isNotEmpty && !_isCollection)
                                    Flexible(
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
                                                          child: Text("${route.routeName}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
                                                          value: routeList.indexOf(route),
                                                        ),
                                                    ],
                                                    onChanged: (int value) {
                                                      setState(() {
                                                        _selectedRoutePosition = value;
                                                        if (userType == 'Pharmacy' || userType == "Pharmacy Staff") getDriversByRoute(routeList[_selectedRoutePosition]);
                                                      });
                                                    }),
                                              ),
                                            ),
                                          )),
                                    ),
                                ],
                              ),
                            ),
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
                                                            child: Text("${route.firstName}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
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
                                                margin: EdgeInsets.only(left: 2, bottom: 0, top: 5),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Driver not available on selected route!",
                                                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
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
                                                    child: Text("${nursingHome.nursing_home_name}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
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
                                                  child: Text("${parcelBoxList.name}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
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
                            // Row(
                            //   children: [
                            //     if(selectedSubscription == 5 && isDelCharge != null && isDelCharge == 1)
                            //       Flexible(
                            //         flex: 1,
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(left: 4.0,right: 4.0,bottom: 4.0),
                            //           child: new TextField(
                            //             controller: deliveryChargeController,
                            //             textInputAction: TextInputAction.next,
                            //             keyboardType: TextInputType.number,
                            //             style: TextStyle(color: Colors.blue),
                            //             autofocus: false,
                            //             inputFormatters: <TextInputFormatter>[
                            //               FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
                            //             ],
                            //             onChanged: (val){
                            //               calculateAmount();
                            //             },
                            //             decoration: new InputDecoration(
                            //               labelText: "Delivery Charge",
                            //               fillColor: Colors.white,
                            //               labelStyle: TextStyle(color: Colors.blue),
                            //               filled: true,
                            //               contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                            //               border: new OutlineInputBorder(
                            //                 borderRadius: BorderRadius.circular(50.0),
                            //                 borderSide: BorderSide(color: Colors.blue),),
                            //               focusedBorder: OutlineInputBorder(
                            //                 borderRadius: BorderRadius.circular(50.0),
                            //                 borderSide: BorderSide(color: Colors.blue),),
                            //               enabledBorder: OutlineInputBorder(
                            //                 borderRadius: BorderRadius.circular(50.0),
                            //                 borderSide: BorderSide(color: Colors.blue),),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     if(selectedSubscription == 5)
                            //       SizedBox(
                            //         width: 5.0,
                            //       ),
                            //     if(selectedSubscription == 5 && isPresCharge != null && isPresCharge == 1)
                            //       Flexible(
                            //         flex: 1,
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(left: 4.0,right: 4.0,bottom: 4.0),
                            //           child: new TextField(
                            //             controller: preChargeController,
                            //             textInputAction: TextInputAction.next,
                            //             keyboardType: TextInputType.number,
                            //             style: TextStyle(color: Colors.green),
                            //             autofocus: false,
                            //             inputFormatters: <TextInputFormatter>[
                            //               FilteringTextInputFormatter.digitsOnly
                            //             ],
                            //             onChanged: (v){
                            //               calculateAmount();
                            //             },
                            //             decoration: new InputDecoration(
                            //               labelText: "Rx Charge",
                            //               prefix: Text("9.18 x "),
                            //               labelStyle: TextStyle(color: Colors.green),
                            //               fillColor: Colors.white,
                            //               filled: true,
                            //               contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                            //               border: new OutlineInputBorder(
                            //                 borderRadius: BorderRadius.circular(50.0),
                            //                 borderSide: BorderSide(color: Colors.green),),
                            //               focusedBorder: OutlineInputBorder(
                            //                 borderRadius: BorderRadius.circular(50.0),
                            //                 borderSide: BorderSide(color: Colors.green),),
                            //               enabledBorder: OutlineInputBorder(
                            //                 borderRadius: BorderRadius.circular(50.0),
                            //                 borderSide: BorderSide(color: Colors.green),),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //   ],
                            // ),
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
                                                      child: Text("${nursingHome.name}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
                                                      value: patientSubList.indexOf(nursingHome),
                                                    ),
                                                ],
                                                onChanged: (int value) {
                                                  setState(() {
                                                    // dailyId = patientSubList[value].id;
                                                    perDelivey = patientSubList[value].name;
                                                    if (perDelivey == 'Per Delivery') deliveryChargeController.text = widget.orderInof.delCharge ?? patientSubList[value].price;
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
                                  // Text(
                                  //   "Storage : ",
                                  //   style:
                                  //       TextStyle(color: Colors.orangeAccent),
                                  // ),
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
                                          // new Text(
                                          //   'FRIDGE',
                                          //   style: TextStyle(color: Colors.white),
                                          // ),
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
                                      _controlSelected = !_controlSelected;
                                      setState(() {});
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
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
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
                                          activeColor: Colors.blue,
                                          value: _paidSelected,
                                          onChanged: (newValue) {
                                            logger.i('selectedExemptionId: $selectedExemptionId');
                                            logger.i('paymentExemption ${widget.orderInof.paymentExemption}');
                                            setState(() {
                                              _paidSelected = newValue;
                                            });
                                            if (_paidSelected) paidBottomSheet(context);
                                          },
                                        ),
                                        new Text(
                                          'Paid',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
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
                                        padding: EdgeInsets.only(left: 5, right: 5),
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
                                              style: TextStyle(color: Colors.white),
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
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                                  child: Text("${route.name}", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black87)),
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
                                        style: TextStyle(color: Colors.redAccent[200], fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                            Container(
                              margin: EdgeInsets.only(left: 2, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Existing Delivery Note",
                                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
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
                                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
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
                              // medicine list validation removed
                              // if (medicineList.length == 0) {
                              //   Fluttertoast.showToast(
                              //       msg:
                              //           "You don't have any medicine, Add and try again.");
                              // } else {
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
                                if (userType == 'Pharmacy' || userType == "Pharmacy Staff") ;

                                //Use only when driver sould be compulsary to deliver

                                // if (_selectedDriverPosition == 0) {
                                //   showToast("Select driver and try again.");
                                //   return;
                                // }
                              }

                              bool isValidate = true;
                              for (int i = 0; i < medicineList.length; i++) {
                                isValidate = false;
                                if (medicineList[i].days.isNotEmpty && medicineList[i].days != "") {
                                  if (medicineList[i].days.contains(".") || medicineList[i].days.contains("-") || medicineList[i].days.contains(",")) {
                                    showToast("Please enter a Valid Day");
                                    break;
                                  }
                                  bool checkValidDay = RegExp(r'[0-9]$').hasMatch(medicineList[i].days);
                                  if (!checkValidDay) {
                                    showToast("Please enter a Valid Day");
                                  } else {
                                    if (double.parse(medicineList[i].days.toString()) > 0) {
                                      isValidate = true;
                                    } else {
                                      showToast("Please enter a value greater than or equal to 1");
                                      break;
                                    }
                                  }
                                } else {
                                  isValidate = true;
                                }
                              }
                              /* for(Dd prescription in widget.prescriptionList){
                 if(prescription.drugsType == null){
                 showToast( "Choose drugs type and try again.");
                  return;
                 }
                }*/
                              if (isValidate) postDataAndVerifyUser();
                              // }
                            },
                            child: Container(
                                height: 45,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                child: Text("Book Delivery",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )))),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void calculateAmount() {
    var deliveryCharge = double.tryParse(deliveryChargeController.text.toString().trim());
    var preAmount = double.tryParse(preChargeController.text.toString().trim());
    if (deliveryCharge != null && preAmount != null) {
      preAmount = (9.18 * preAmount);
      totalAmount = (deliveryCharge + preAmount).toStringAsFixed(2);
    } else {
      if (preAmount == null && deliveryCharge != null)
        totalAmount = "${(deliveryCharge + 9.18).toStringAsFixed(2)}";
      else
        totalAmount = "0.00";
    }
    setState(() {});
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
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      duration: 3000,
    );
  }

  void exemptBottomSheet(context) {
    int index1;
    if (selectedExemptionId != null) {
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
                          child: Text("Payment Exemption", style: Bold20Style),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: exemptionsList[index].isSelected,
                                    visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                    onChanged: (values) {
                                      setStat(() {
                                        for (var element in exemptionsList) {
                                          element.isSelected = false;
                                        }
                                        exemptionsList[index].isSelected = values;
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
                        logger.i(selectedExemptionId);
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
                          style: TextStylewhite20,
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
                if (widget.orderInof != null && widget.orderInof.delSubsId != null) {
                  int index = patientSubList.indexWhere((element) => element.id == widget.orderInof.delSubsId);
                  selectedSubscription = index;
                  //  selectedSubscription = widget.orderInof.delSubsId;
                  //  dailyId = index;
                  perDelivey = patientSubList[index].name;
                  deliveryChargeController.text = widget.orderInof.delCharge ?? patientSubList[index].price;
                  //     deliveryChargeController.text = patientSubList[index].price;
                  // patientSubList.forEach((element) {
                  //    if(index == element.id){
                  //      perDelivey = element.name;
                  //    }
                  // });
                  //perDelivey = ;

                  logger.i('selectedSubscription  INDEX: ${widget.orderInof.delSubsId}');
                  logger.i('selectedSubscription : ${widget.orderInof.delSubsId}');
                }

                Surgery surgery = Surgery();
                surgeryList.clear();
                surgery.name = "Select Surgery";
                surgery.mobileNo = "N/A";
                surgery.id = 0;
                surgeryList.add(surgery);
                surgeryList.addAll(model.surgery);

                if (widget.orderInof != null && widget.orderInof.surgeryName != null && widget.orderInof.surgeryName != "" && surgeryList.length > 0) {
                  int index = surgeryList.indexWhere((element) => element.name == widget.orderInof.surgeryName);
                  _selectedSurgeryPosition = index;
                }

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

  void getImage(ImageSource source, BuildContext context) {
    Provider.of<RepeatPrescriptionImageProvider>(context, listen: false).getImage(source, context);
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

  Future<void> getParcelBoxData(String driverId) async {
    parcelBoxList.clear();

    // if (!progressDialog.isShowing()) progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    _apiCallFram.getDataRequestAPI(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId", accessToken, context).then((response) async {
      // progressDialog.hide();
      // subExpiryPopUp('Subscription Expired');
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
      if (Ts != null) {
        var now = new DateTime.now();
        var berlinWallFellDate = new DateTime.utc(Ts.year, Ts.month, Ts.day);
        if (berlinWallFellDate.compareTo(now) < 0) {
          subExpiryPopUp('Your ${patientSubList[selectedSubscription].name} Subscription Expired at $datetime');
        }
      }
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
    logger.i(WebConstant.GET_ROUTE_URL_PHARMACY);
    // if (!progressDialog.isShowing()) progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    _apiCallFram.getDataRequestAPI(WebConstant.GET_ROUTE_URL_PHARMACY + "?pharmacyId=${0}", accessToken, context).then((response) async {
      // progressDialog.hide();
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
          }
        } catch (_, stackTrace) {
          SentryExemption.sentryExemption(_, stackTrace);
          showToast(WebConstant.ERRORMESSAGE);
          // progressDialog.hide();
          await CustomLoading().showLoadingDialog(context, false);
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // progressDialog = ProgressDialog(context, isDismissible: true);

    fToast = FToast();
    selectedDate = DateTime.now();
    if (widget.orderInof != null && widget.orderInof.default_surgery_note != null && widget.orderInof.default_surgery_note != "") {
      surgeryController..text = widget.orderInof.default_surgery_note;
    }
    if (widget.orderInof != null && widget.orderInof.default_branch_note != null && widget.orderInof.default_branch_note != "") {
      branchController..text = widget.orderInof.default_branch_note;
    }

    if (widget.orderInof != null && widget.orderInof.subExpDate != null) {
      subExpDate = widget.orderInof.subExpDate;
      logger.i('Expiry Subscription Date: $subExpDate');

      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(subExpDate * 1000);
      Ts = DateTime.fromMillisecondsSinceEpoch(subExpDate * 1000);
      datetime = tsdate.year.toString() + "/" + tsdate.month.toString() + "/" + tsdate.day.toString();
      print(datetime);

      logger.i('Converted Date Date: $datetime');
      // subExpiryPopUp('${patientSubList[selectedSubscription].name} Subscription Expired by $datetime');
    }

    if (widget.orderInof.paymentExemption != null) {
      selectedExemptionId = widget.orderInof.paymentExemption;
      // if(selectedExemptionId != 2)
      //   _paidSelected = true;
    }
    getLocationData();

    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      driverType = value.getString(WebConstant.DRIVER_TYPE);
      userType = value.getString(WebConstant.USER_TYPE) ?? "";
      userID = value.getString(WebConstant.USER_ID) ?? "";
      routeID = value.getString(WebConstant.ROUTE_ID) ?? "";
      pharmacyId = value.getInt(WebConstant.PHARMACY_ID) ?? 0;
      isStartRoute = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      endRouteId = value.getInt(WebConstant.END_ROUTE_AT) ?? 0;
      startRouteId = value.getInt(WebConstant.START_ROUTE_FROM) ?? 0;
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

    //scanBarcodeNormal();
    _controller = ScrollController()
      ..addListener(() {
        setState(() {
          isScrollDown = _controller.position.userScrollDirection == ScrollDirection.forward;
        });
      });
    checkLastTime(context);
    provider = Provider.of<RepeatPrescriptionImageProvider>(context, listen: false);
    provider.imageList = [];
    provider.images = [];
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
                          style: TextStyle20White,
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

  Future<void> postDataAndVerifyUser() async {
    // await ProgressDialog(context, isDismissible: true).show();
    await CustomLoading().showLoadingDialog(context, true);
    List<Map<String, dynamic>> medicineList1 = [];
    if (medicineList != null && medicineList.isNotEmpty) {
      medicineList.forEach((element) {
        Map<String, dynamic> medicine1 = {
          "drug_type_cd": element != null && element.isControlDrug ? "t" : "f",
          "drug_type_fr": element != null && element.isFridge ? "t" : "f",
          "pr_id": "",
          "medicine_name": element.name,
          "dosage": "",
          "quantity": element.quntity ?? "",
          "remark": "",
          "days": element.days ?? "",
        };
        medicineList1.add(medicine1);
      });
    }
    String gender = "M";
    if (widget.orderInof.title.endsWith("Mrs") || widget.orderInof.title.endsWith("Miss") || widget.orderInof.title.endsWith("Ms")) {
      gender = "F";
    }

    String driverID = "";
    if (userType == 'Pharmacy' || userType == "Pharmacy Staff") {
      driverID = _selectedDriverPosition != 0 ? driverList[_selectedDriverPosition].driverId.toString() : "";
    } else {
      driverID = userID;
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
    String tittle = "";
    if (widget.orderInof.title == "Mr") {
      tittle = "M";
    } else if (widget.orderInof.title == "Miss") {
      tittle = "S";
    } else if (widget.orderInof.title == "Mrs") {
      tittle = "F";
    } else if (widget.orderInof.title == "Ms") {
      tittle = "Q";
    } else if (widget.orderInof.title == "Captain") {
      tittle = "C";
    } else if (widget.orderInof.title == "Dr") {
      tittle = "D";
    } else if (widget.orderInof.title == "Prof") {
      tittle = "P";
    } else if (widget.orderInof.title == "Rev") {
      tittle = "R";
    } else if (widget.orderInof.title == "Mx") {
      tittle = "X";
    }
    String dob = widget.orderInof.userId == 0 ? "${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.orderInof.dob)) ?? ""}" : widget.orderInof.dob;
    Map<String, dynamic> data = {
      "order_type": "manual",
      "pharmacyId": 0,
      "otherpharmacy": false,
      "pmr_type": "0",
      "endRouteId": isStartRoute ? "$endRouteId" : "0",
      "startRouteId": isStartRoute ? "$startRouteId" : "0",
      "start_lat": isStartRoute ? "$startLat" : "",
      "start_lng": isStartRoute ? "$startLng" : "",
      "del_subs_id": selectedSubscription > 0 ? patientSubList[selectedSubscription].id : 0,
      "exemption": selectedExemptionId != null ? selectedExemptionId : 0,
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
      "patient_id": widget.orderInof.userId,
      "pr_id": "",
      "lat": "",
      //na
      "lng": "",
      //na
      "parcel_box_id": parcelDropdownValue != null && parcelDropdownValue.id != null ? parcelDropdownValue.id : 0,
      "surgery_name": _selectedSurgeryPosition > 0 ? surgeryList[_selectedSurgeryPosition].name : "",
      "surgery": _selectedSurgeryPosition > 0 ? surgeryList[_selectedSurgeryPosition].id : "",
      "amount": "",
      "email_id": "",
      "mobile_no_2": "",
      "dob": "$dob",
      "nhs_number": widget.orderInof.nhsNumber ?? "",
      "title": tittle ?? "",
      "first_name": widget.orderInof.firstName ?? "",
      "middle_name": widget.orderInof.middleName ?? "",
      "last_name": widget.orderInof.lastName ?? "",
      "address_line_1": widget.orderInof.address ?? "",
      "country_id": "",
      "post_code": widget.orderInof.postCode ?? "",
      "gender": gender,
      "preferred_contact_type": "",
      "delivery_type": deliveryTypeList[_selectedDeliveryTypePosition] ?? "",
      "driver_id": driverID,
      "delivery_route": _selectedRoutePosition != 0 ? routeList[_selectedRoutePosition].routeId : "",
      "storage_type_cd": _controlSelected ? "t" : "f",
      "storage_type_fr": _fridgeSelected ? "t" : "f",
      "delivery_status": status.toString(),
      "nursing_homes_id": _selectedNursingHomePosition != 0 ? nursingHomeLIst[_selectedNursingHomePosition].nursing_home_id : 0,
      "shelf": _selectedShelfPosition != 0 ? shelfList[_selectedShelfPosition].id : "",
      "delivery_service": _selectedServicePosition != 0 ? servicesList[_selectedServicePosition].id : "",
      "doctor_name": "",
      "doctor_address": "",
      "new_delivery_notes": recentNoteController.text != null
          ? recentNoteController.text.toString() != "null"
              ? recentNoteController.text.toString().trim()
              : ""
          : "",
      "existing_delivery_notes": widget.orderInof != null && widget.orderInof.default_delivery_note != null && widget.orderInof.default_delivery_note != "" ? widget.orderInof.default_delivery_note : "",
      "del_charge": deliveryChargeController.text.toString().trim(),
      "rx_charge": rxCharge,
      "subs_id": patientSubList[selectedSubscription].id,
      "rx_invoice": selectedExemptionId == 2 ? selectedCharge : "",
      "branch_notes": branchController.text.toString().trim(),
      "surgery_notes": surgeryController.text.toString().trim(),
      "medicine_name": medicineList1,
      "prescription_images": provider.imageList != null ? provider.imageList : [],
      "delivery_date": selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate) : "",
    };
    logger.i(data);
    logger.i(WebConstant.UUDATE_CUSTOMER_WITH_ORDER);
    _apiCallFram.postDataAPI(WebConstant.UUDATE_CUSTOMER_WITH_ORDER, accessToken, data, context).then((response) async {
      // print(response);
      // ProgressDialog(context, isDismissible: true).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          // print("${response.body}");
          Map<String, Object> data = json.decode(response.body);
          if (data["error"] != null && data["error"] == false) {
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
        // ProgressDialog(context, isDismissible: true).hide();
        // print("Exception : $e");
        await CustomLoading().showLoadingDialog(context, false);
      }
    });
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
}

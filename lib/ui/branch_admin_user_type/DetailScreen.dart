// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/exemptionList.dart';
import 'package:pharmdel_business/presenter/delivery_update_presenter.dart';
import 'package:pharmdel_business/util/CustomDialogBox.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_call_fram.dart';
import '../../main.dart';
import '../../model/parcel_box_api_response.dart';
import '../../util/calling_util.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../../util/text_style.dart';
import '../collect_order.dart';
import '../login_screen.dart';
import '../splash_screen.dart';

class DetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.

  final String name;
  final String driverId;
  final String id;
  final String pNo;
  final List<Exemptions> exemptionList;
  final String pmr_type;
  final String address;
  final String deliveryNote;
  final String deliveryStatus;
  final String deliveryDate;
  final String deliveryId;
  final String parcelBoxName;
  final Function function;
  final String mobile;
  final String route;
  final String recentDeliveryNote;
  final String deliveryStatusDesc;
  final String exitingNote;
  final String delivered_to;
  final String isStorageFridge;
  final String isControlledDrugs;

  String exemption;
  String delCharge;
  double rxCharge;
  int rxInvoice;

  String paymentStatus;

  String bagSize;

  String subsId;

  // In the constructor, require a Todo.
  DetailScreen({this.name, this.id, this.driverId, this.address, this.deliveryNote, this.pmr_type, this.deliveryStatus, this.deliveryDate, this.deliveryId, this.delCharge, this.rxCharge, this.rxInvoice, this.subsId, this.mobile, this.exemptionList, this.parcelBoxName, this.route, this.recentDeliveryNote, this.deliveryStatusDesc, this.function, this.delivered_to, this.pNo, this.isStorageFridge, this.isControlledDrugs, this.exemption, this.bagSize, this.paymentStatus, this.exitingNote});

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> implements DeliveryUpdateCotract {
  String dropdownValue = 'Received';
  String deliveryName, remarks;
  var yetToStartColor = const Color(0xFFF8A340);
  var blue = const Color(0xFF2188e5);
  DeliveryUpdatePresenter _presenter;
  String userId, token;

//  ProgressDialog progressDialog;
  final deliveryToController = TextEditingController();
  final remarkController = TextEditingController();
  bool isCustomerNote = false, isFridgeNote = false, isDeliveryNote = false, isControlledDrugs = false, isControlNote = false;

  var isCheked = false;
  final DateFormat formatter = DateFormat("dd-MM-yyyy");

  String selectedDate;
  String selectedDateTimeStamp;
  ApiCallFram _apiCallFram = ApiCallFram();

  List<ParcelBoxData> parcelBoxList = [];

  // ProgressDialog progressDialog;
  ParcelBoxData parcelDropdownValue;

  bool _exemptSelected = false;

  bool _paidSelected = false;

  int selectedExemptionId;

  String selectedExemption;
  List<String> paymentTypeList = ["Cash", "Card", "Not paid"];

  int val = 0;

  TextEditingController preChargeController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String totalAmount = "0.00";

  int isPresCharge;
  int isDelCharge;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    deliveryToController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  void init() async {
    logger.i('gggggggg');
    logger.i("status: ${widget.deliveryStatusDesc}");
    logger.i("status: ${widget.rxCharge}");
    // progressDialog = ProgressDialog(context, isDismissible: true);
    selectedDate = formatter.format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    selectedDateTimeStamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).millisecondsSinceEpoch.toString();

    deliveryToController.text = widget.delivered_to == null || widget.delivered_to.isEmpty || widget.delivered_to == "null" ? "N/A" : widget.delivered_to;
    _presenter = new DeliveryUpdatePresenter(this);
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    isPresCharge = prefs.getInt(WebConstant.IS_PRES_CHARGE);
    isDelCharge = prefs.getInt(WebConstant.IS_DEL_CHARGE);

    // print(widget.deliveryStatusDesc);
    // print(widget.deliveryStatus);
    setState(() {
      if (widget.deliveryStatus == '1') {
        dropdownValue = 'PickedUp';
      } else if (widget.deliveryStatus == '2') {
        dropdownValue = 'PickedUp';
      } else if (widget.deliveryStatus == '3') {
        dropdownValue = 'PickedUp';
      } else if (widget.deliveryStatus == '4') {
        dropdownValue = 'Out For Delivery';
      } else if (widget.deliveryStatus == '5') {
        dropdownValue = 'Completed';
      } else if (widget.deliveryStatus == '6') {
        dropdownValue = 'Failed';
      } else if (widget.deliveryStatus == '7') {
        dropdownValue = 'PickedUp';
      } else if (widget.deliveryStatus == '9') {
        dropdownValue = 'Cancelled';
      }
    });
    if (dropdownValue == "PickedUp") getParcelBoxData(widget.driverId);
  }

  @override
  void initState() {
    super.initState();
    preChargeController.text = '${widget.rxInvoice != null ? widget.rxInvoice > 0 ? widget.rxInvoice : 0 : 0}';
    deliveryChargeController.text = '${widget.delCharge != null ? widget.rxInvoice > 0 ? widget.delCharge : 0 : 0}';
    calculateAmount();
    init();
    checkLastTime(context);
  }

  @override
  Widget build(BuildContext context) {
    var form = new Form(
      child: new Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: new TextField(
              controller: deliveryToController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              autofocus: false,
              enabled: true,
              style: TextStyle(decoration: TextDecoration.none),
              decoration: new InputDecoration(
                  labelText: "Delivery to",
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.grey[200]),
                  )),
            ),
          ),

          SizedBox(
            height: 5.0,
          ),
          //Delivery Remark Commented by Ram Kumawat
          //-------------------------------------------------------------------------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: new TextField(
              controller: remarkController,
              /* onSaved: (val) => remarks = val,
            validator: (val) {
              return val.trim().isEmpty ? "Delivery remark" : null;
            },*/
              //initialValue: widget.name,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: new InputDecoration(
                  labelText: "Delivery remark",
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.grey[200]),
                  )
                  /*border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0)))*/
                  ),
            ),
          ),
          if (dropdownValue == "Completed")
            SizedBox(
              height: 8.0,
            ),
          Row(
            children: [
              if (dropdownValue == "Completed" && deliveryChargeController.text != null && deliveryChargeController.text != "0")
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
                    child: new TextField(
                      controller: deliveryChargeController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.blue),
                      autofocus: false,
                      readOnly: true,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
                      onChanged: (val) {
                        calculateAmount();
                      },
                      decoration: new InputDecoration(
                        labelText: "Delivery Charge",
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.blue),
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ),
              if (dropdownValue == "Completed")
                SizedBox(
                  width: 5.0,
                ),
              if (dropdownValue == "Completed" && preChargeController.text != "0")
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 8.0),
                    child: new TextField(
                      controller: preChargeController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.green),
                      autofocus: false,
                      readOnly: true,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        calculateAmount();
                      },
                      decoration: new InputDecoration(
                        labelText: "Rx Charge",
                        prefix: Text("${widget.rxCharge != null ? widget.rxCharge : 0} x "),
                        labelStyle: TextStyle(color: Colors.green),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (dropdownValue == "Failed1")
            Row(
              children: [
                Checkbox(
                  visualDensity: VisualDensity(vertical: -4.0),
                  activeColor: CustomColors.yetToStartColor,
                  value: this.isCheked,
                  onChanged: (bool value) {
                    setState(() {
                      this.isCheked = value;
                    });
                  },
                ),
                Text(
                  "Reschedule Delivery",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          if (isCheked)
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 5.0),
              child: InkWell(
                onTap: () {
                  openCalender();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[700]), borderRadius: BorderRadius.circular(50.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(selectedDate ?? ""),
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 20.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    //map = json.decode(todo);
    // {orderId: 20, deliveryId: 3, customerName: Ramesh Thiru,
    // address: 123 Main Street,2nd Extension,Coimbatore,England,641041, deliveryNote: To home,
    // deliveryStatus: 0, deliveryDate: 2020-03-05T00:00:00}
    // Use the Todo to create the UI.
    const gray = const Color(0xFFEEEFEE);
    double c_width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: materialAppThemeColor,
          title: Text(
            "Order ID : ${widget.id != null ? widget.id : ""}${widget.pmr_type != null && (widget.pmr_type == "titan" || widget.pmr_type == "nursing_box") && widget.pNo != null && widget.pNo.isNotEmpty ? ", P/N : ${widget.pNo}" : ""}",
            style: TextStyle(color: appBarTextColor),
          ),
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back,
                    color: appBarTextColor,
                  ),
                ),
              ))),
      body: Stack(
        children: [
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     //height: MediaQuery.of(context).size.height/1.5,
          //     width: MediaQuery.of(context).size.width,
          //     child: Image.asset(
          //       "assets/bottom_bg.png",
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      new Expanded(
                          child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: CustomColors.yetToStartColor,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "Patient Details",
                                        style: Regular16Style.copyWith(color: CustomColors.yetToStartColor),
                                      ),
                                      Spacer(),
                                      if (widget.parcelBoxName != null && widget.parcelBoxName.toString().isNotEmpty)
                                        if (widget.deliveryStatusDesc == WebConstant.Status_out_for_delivery || widget.deliveryStatusDesc == "PickedUp")
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                                    child: Text(
                                                      "${widget.parcelBoxName.length > 8 ? widget.parcelBoxName.substring(0, 8) : widget.parcelBoxName ?? ""}",
                                                      style: TextStyle(
                                                        color: CustomColors.pickedUp,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 28.0),
                                    child: FittedBox(
                                      child: Text(
                                        "${widget.name ?? ""}",
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 31.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Text(
                                            "${widget.address ?? ""}",
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () async {
                                              // if (Platform.isAndroid) {
                                              //   final AndroidIntent intent = new AndroidIntent(
                                              //       action: 'action_view',
                                              //       data: Uri.encodeFull(
                                              //           "https://www.google.com/maps/dir/?api=1&origin=${_locationData.latitude},${_locationData.longitude}"
                                              //               "&destination=${widget.orderModel.customer.fullAddress.latitude},${widget.orderModel.customer.fullAddress.longitude}"
                                              //       ),
                                              //       package: 'com.google.android.apps.maps');
                                              //   intent.launch();
                                              // } else {
                                              if (widget.address != null && widget.address != "" && widget.address.isNotEmpty) {
                                                MapsLauncher.launchQuery("${widget.address ?? widget.address ?? ""}");

                                                // MapsLauncher.launchCoordinates(
                                                //     widget
                                                //         .orderModel.customer.latitude,
                                                //     widget.orderModel.customer
                                                //         .longitude);
                                              } else {
                                                Fluttertoast.showToast(msg: "Address not found");
                                              }

                                              // String url = "https://www.google.com/maps/dir/?api=1&origin=${_latLng[0]}&destination=${_latLng[0]}&travelmode=driving&dir_action=navigate";
                                              //}
                                            },
                                            child: Image.asset(
                                              "assets/google-maps-icon.png",
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.mobile != null && widget.mobile.isNotEmpty && widget.mobile != "")
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 30.0),
                                            child: Text("${widget.mobile ?? ""}", textAlign: TextAlign.left),
                                          ),
                                          flex: 3),
                                      if (widget.mobile != null && widget.mobile.isNotEmpty && widget.mobile != "")
                                        InkWell(
                                            onTap: () {
                                              if (widget.mobile != null && widget.mobile.isNotEmpty && widget.mobile != "") {
                                                makePhoneCall(widget.mobile);
                                              } else {
                                                Fluttertoast.showToast(msg: "Phone number not available");
                                              }
                                            },
                                            child: CircleAvatar(
                                                backgroundColor: Colors.green,
                                                radius: 15.0,
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.white,
                                                  size: 22,
                                                ))),
                                    ],
                                  ),
                                  if (widget.mobile != null && widget.mobile.isNotEmpty && widget.mobile != "")
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  if (widget.deliveryNote != null && widget.deliveryNote != "" && widget.deliveryNote.isNotEmpty && widget.deliveryNote != "null")
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        'New Delivery Note',
                                        style: TextStyle(fontSize: 16, color: CustomColors.yetToStartColor),
                                      ),
                                    ),
                                  if (widget.deliveryNote != null && widget.deliveryNote != "" && widget.deliveryNote.isNotEmpty && widget.deliveryNote != "null")
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            // new TextSpan(
                                            //   text: "${widget.orderModel.oldRecentDeliveryNote ?? ""}",
                                            //   style: TextStyle(
                                            //       fontSize: 14,
                                            //       color: Colors.blueAccent),
                                            // ),
                                            new TextSpan(text: "${(widget.deliveryNote != "null" ? widget.deliveryNote : "") ?? ""}", style: new TextStyle(fontSize: 14, color: Colors.blue[900])),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (widget.exitingNote != null && widget.exitingNote != "" && widget.exitingNote.isNotEmpty)
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  if (widget.exitingNote != null && widget.exitingNote != "" && widget.exitingNote.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        'Existing Note',
                                        style: TextStyle(fontSize: 16, color: CustomColors.yetToStartColor),
                                      ),
                                    ),
                                  if (widget.exitingNote != null && widget.exitingNote != "" && widget.exitingNote.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            // new TextSpan(
                                            //   text: "${widget.orderModel.oldRecentDeliveryNote ?? ""}",
                                            //   style: TextStyle(
                                            //       fontSize: 14,
                                            //       color: Colors.blueAccent),
                                            // ),
                                            new TextSpan(text: "${widget.exitingNote ?? ""}", style: new TextStyle(fontSize: 14, color: Colors.blue[900])),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[700]), borderRadius: BorderRadius.circular(50.0)),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.black,
                              ),
                              onChanged: (String newValue) {
                                if (newValue == "Completed") {
                                  calculateAmount();
                                }
                                if ("Out For Delivery" != newValue)
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                if ("PickedUp" == newValue) getParcelBoxData(widget.driverId);
                              },
                              items: <String>[
                                'Out For Delivery',
                                'Completed',
                                'Failed',
                                'Cancelled',
                                'Received',
                                // 'ReadyForPickup',
                                'Requested',
                                'Ready',
                                'PickedUp',
                                // "OutForDelivery"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: "Out For Delivery" != value ? Colors.black : Colors.grey),
                                  ),
                                );
                              }).toList(),
                            ),
                          )),
                    ),
                  ),
                  if (dropdownValue == "PickedUp" && parcelBoxList != null && parcelBoxList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey[700]), borderRadius: BorderRadius.circular(50.0)),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
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
                            )),
                      ),
                    ),
                  form,
                  Container(
                    child: Row(
                      children: <Widget>[
                        widget.deliveryNote != null && widget.deliveryNote != "" && widget.deliveryNote != "null" || widget.exitingNote != null && widget.exitingNote != "" && widget.exitingNote != "null"
                            ? Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4.0, right: 15.0, top: 5, bottom: 10),
                                  child: Container(
                                    height: CustomColors.chkButtonHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.grey[100],
                                      // border: Border.all(color: Colors.blue)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          onChanged: (checked) {
                                            setState(() {
                                              isDeliveryNote = checked;
                                            });
                                          },
                                          value: isDeliveryNote,
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "Read Delivery Note  ",
                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.isStorageFridge == null || widget.isStorageFridge == "f"
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 4.0,
                                    right: 5.0,
                                  ),
                                  child: Container(
                                    height: CustomColors.chkButtonHeight,
                                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: CustomColors.fridgeColor,
                                      // border: Border.all(color: Colors.blue)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          visualDensity: VisualDensity(horizontal: -4),
                                          onChanged: (checked) {
                                            setState(() {
                                              isFridgeNote = checked;
                                            });
                                          },
                                          value: isFridgeNote,
                                          checkColor: Colors.white,
                                          activeColor: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 2,
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
                              ),
                        widget.isControlledDrugs == null || widget.isControlledDrugs == "f"
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 2.0,
                                    right: 5.0,
                                  ),
                                  child: Container(
                                    height: CustomColors.chkButtonHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: CustomColors.drugColor,
                                      // border: Border.all(color: Colors.blue)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          visualDensity: VisualDensity(horizontal: -4),
                                          onChanged: (checked) {
                                            setState(() {
                                              isControlledDrugs = checked;
                                            });
                                          },
                                          value: isControlledDrugs,
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "Controlled Drugs",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // if(widget.paymentStatus != null && widget.paymentStatus.isNotEmpty && widget.paymentStatus != "unPaid")
                      //   Container(
                      //     height: 30,
                      //     padding: EdgeInsets.only(right: 5),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50.0),
                      //       color: Colors.orange,
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Checkbox(
                      //           visualDensity: VisualDensity(horizontal: -4),
                      //           value: _paidSelected,
                      //           onChanged: (newValue) {
                      //             setState(() {
                      //               _paidSelected = newValue;
                      //             });
                      //           },
                      //         ),
                      //         new Text(
                      //           "${widget.paymentStatus ?? ""}",
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      if (widget.exemption != null && widget.exemption.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(right: 5, left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.green,
                            ),
                            child: Row(
                              children: [
                                new Text(
                                  "Exempt : ${selectedExemption != null && selectedExemption.isNotEmpty ? selectedExemption : widget.exemption ?? ""}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                if (dropdownValue == "Completed" && widget.exemptionList != null && widget.exemptionList.isNotEmpty)
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
                      if (widget.bagSize != null && widget.bagSize.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(right: 5, left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.green,
                            ),
                            child: Row(
                              children: [
                                new Text(
                                  "Bag Size : ${widget.bagSize}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (dropdownValue == "Completed")
                    deliveryChargeController.text == '0' && preChargeController.text == '0'
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 15.0),
                                      child: Text(
                                        "Payment Type",
                                        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: paymentTypeList.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Radio(
                                                  value: val,
                                                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                  groupValue: index,
                                                  onChanged: (value) {
                                                    val = index;
                                                    logger.i(paymentTypeList[val]);
                                                    setState(() {});
                                                  }),
                                              Text(paymentTypeList[index]),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Amount",
                                        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "£ $totalAmount",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  if (paymentTypeList[val] == "Not paid")
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0, top: 4.0),
                      child: new TextField(
                        controller: commentController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        onChanged: (val) {},
                        decoration: new InputDecoration(
                            labelText: "Comment",
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(color: Colors.grey[200]),
                            )),
                      ),
                    ),
                  if (dropdownValue == "Completed")
                    SizedBox(
                      height: 30.0,
                    ),
                  Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4, top: 15, bottom: 10),
                      child: new SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 45,
                        child: new ElevatedButton(
                          onPressed: _submit,
                          child: new Text(
                            "Update Status",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    // deliveryName = deliveryToController.text.toString();
    // remarks = remarkController.text.toString();
    if (isValidate()) {
      try {
        var data = null;
        //var resBody = {};
        if (deliveryToController.text.toString() == null || deliveryToController.text.toString().isEmpty) {
          Fluttertoast.showToast(msg: "Enter Delivered to", toastLength: Toast.LENGTH_LONG);
        }
        /*else if (remarkController.text.toString() == null || remarkController.text.toString().isEmpty) {
            Fluttertoast.showToast(
                msg: "Enter Remarks", toastLength: Toast.LENGTH_LONG);
          }*/
        else {
          Map<String, String> resBody = new Map<String, String>();
          resBody['deliveryId'] = widget.deliveryId;
          resBody['remarks'] = remarkController.text.toString();
          resBody['payment_method'] = dropdownValue == "Completed" && (preChargeController.text != '0' || deliveryChargeController.text != '0') ? paymentTypeList[val] : "";
          resBody['del_charge'] = widget.delCharge != null ? widget.delCharge.toString() : "";
          resBody['payment_remark'] = dropdownValue == "Completed"
              ? paymentTypeList[val] == "Not paid"
                  ? commentController.text.toString().trim()
                  : ""
              : "";
          resBody['subs_id'] = widget.subsId != null ? widget.subsId : "";
          resBody['rx_invoice'] = widget.rxInvoice != null ? widget.rxInvoice.toString() : "";
          resBody['rx_charge'] = widget.rxCharge != null ? widget.rxCharge.toString() : "";
          resBody['deliveredTo'] = deliveryToController.text.toString();
          resBody["exemption"] = "${selectedExemptionId != null ? selectedExemptionId : 0}";
          resBody["paymentStatus"] = "${_paidSelected ? "paid" : "unPaid"}";
          resBody['rescheduleDate'] = isCheked
              ? selectedDateTimeStamp != null
                  ? selectedDateTimeStamp
                  : ""
              : "";
          resBody['parcel_box_id'] = parcelDropdownValue != null && parcelDropdownValue.id != null && parcelDropdownValue.id.toString().isNotEmpty ? parcelDropdownValue.id.toString() : "0";
          if (dropdownValue == 'Out For Delivery') {
            // resBody['deliveryStatus'] = '2';
            // ProgressDialog(context, isDismissible: false).show();
            // _presenter.doDeliveryUpdate(
            //     widget.deliveryId,
            //     remarkController.text.toString(),
            //     deliveryToController.text.toString(),
            //     2,
            //     resBody,
            //     token);
            _showSnackBar("Select Delivery Status");
          } else {
            if (dropdownValue == 'Requested') resBody['deliveryStatus'] = '1';
            if (dropdownValue == 'Received') resBody['deliveryStatus'] = '2';
            if (dropdownValue == 'Ready') resBody['deliveryStatus'] = '3';
            if (dropdownValue == 'Out For Delivery') resBody['deliveryStatus'] = '4';
            if (dropdownValue == 'Completed') resBody['deliveryStatus'] = '5';
            if (dropdownValue == 'Failed') resBody['deliveryStatus'] = '6';
            if (dropdownValue == 'PickedUp') resBody['deliveryStatus'] = '8';
            if (dropdownValue == 'Cancelled') resBody['deliveryStatus'] = '9';
            logger.i(resBody);
            logger.i(resBody["deliveryId"]);
            // ProgressDialog(context, isDismissible: false).show();
            await CustomLoading().showLoadingDialog(context, true);
            _presenter.doDeliveryUpdate(resBody["deliveryId"], resBody["remarks"], resBody["deliveredTo"], resBody["deliveryStatus"], resBody, token);
          }
          // else if (dropdownValue == 'Failed') {
          //   resBody['deliveryStatus'] = '4';
          //   ProgressDialog(context, isDismissible: false).show();
          //   _presenter.doDeliveryUpdate(
          //       widget.deliveryId,
          //       remarkController.text.toString(),
          //       deliveryToController.text.toString(),
          //       4,
          //       resBody,
          //       token);
          // } else if (dropdownValue == 'Returned') {
          //   resBody['deliveryStatus'] = '5';
          //   ProgressDialog(context, isDismissible: false).show();
          //   _presenter.doDeliveryUpdate(
          //       widget.deliveryId,
          //       remarkController.text.toString(),
          //       deliveryToController.text.toString(),
          //       5,
          //       resBody,
          //       token);
          // }
          //  Fluttertoast.showToast(
          //    msg: map.toString(), toastLength: Toast.LENGTH_LONG);
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        _showSnackBar(e.toString());
        // ProgressDialog(context).hide();
        // print(e);
        await CustomLoading().showLoadingDialog(context, false);
      }
    }
  }

  @override
  Future<void> onDeliveryUpdateError(String errorTxt) async {
    _showSnackBar(errorTxt);
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
  }

  @override
  Future<void> onDeliveryUpdateSuccess(Map<String, Object> user) async {
    // print(user);
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    var status = user['status'];
    var uName = user['message'];
    // print(status);
    if (status == true) {
      try {
        _asyncConfirmDialog("Status Successfully Updated");
        widget.function();
      } catch (e, stackTrace) {
        // print(e);
        SentryExemption.sentryExemption(e, stackTrace);
      }
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
    } else {
      showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/delivery_truck.png"),
            title: "Alert...",
            btnDone: "Ok",
            descriptions: uName,
          );
        },
      );
    }
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }

  void _asyncConfirmDialog(var mes) {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context1) {
        return AlertDialog(
          //title: Text(),
          content: new Text(mes),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.pop(context1);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool isValidate() {
    if ((widget.exitingNote != null && widget.exitingNote != "") && !isDeliveryNote) {
      Fluttertoast.showToast(msg: "Check delivery note");
      return false;
    } else if ((widget.deliveryNote != null && widget.deliveryNote != "" && widget.deliveryNote != "null") && !isDeliveryNote) {
      Fluttertoast.showToast(msg: "Check delivery note");
      return false;
    } else if (deliveryToController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Delivery to isn't empty");
      return false;
    } else if (!isFridgeNote && (widget.isStorageFridge == "t")) {
      Fluttertoast.showToast(msg: "Check Fridge");
      return false;
    } else if (!isControlledDrugs && (widget.isControlledDrugs == "t")) {
      Fluttertoast.showToast(msg: "Check Controlled Drugs");
      return false;
    }
    return true;
  }

  void openCalender() {
    DateTime date = DateTime.now();
    showDatePicker(
        context: context,
        initialDate: DateTime(date.year, date.month, date.day + 1),
        firstDate: DateTime(date.year, date.month, date.day + 1),
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
        selectedDate = formatter.format(pickedDate);
        selectedDateTimeStamp = pickedDate.millisecondsSinceEpoch.toString();
      });
    });
  }

  Future<void> getParcelBoxData(String driverId) async {
    parcelBoxList.clear();

    // if (!progressDialog.isShowing()) progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId");
    _apiCallFram.getDataRequestAPI(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId", token, context).then((response) async {
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

  showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }

  void exemptBottomSheet(context) {
    List<bool> _checkboxListTile1 = [];
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
                            style: TextStyle(fontFamily: "Montserrat", fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
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
                      itemCount: widget.exemptionList.length > 0 ? widget.exemptionList.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setStat(() {
                                  for (var element in widget.exemptionList) {
                                    element.isSelected = false;
                                  }
                                  widget.exemptionList[index].isSelected = !widget.exemptionList[index].isSelected;
                                  selectedExemptionId = widget.exemptionList[index].id;
                                  selectedExemption = widget.exemptionList[index].serialId;
                                  setState(() {});
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: widget.exemptionList[index].isSelected,
                                    visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                    onChanged: (values) {
                                      setStat(() {
                                        for (var element in widget.exemptionList) {
                                          element.isSelected = false;
                                        }
                                        widget.exemptionList[index].isSelected = !widget.exemptionList[index].isSelected;
                                        selectedExemptionId = widget.exemptionList[index].id;
                                        selectedExemption = widget.exemptionList[index].serialId;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                  Flexible(child: Text("${widget.exemptionList[index].serialId != null && widget.exemptionList[index].serialId.isNotEmpty ? widget.exemptionList[index].serialId + " - " : ''}" + "${widget.exemptionList[index].code != null && widget.exemptionList[index].code.isNotEmpty ? widget.exemptionList[index].code : ''}"))
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
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
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

  void calculateAmount() {
    var deliveryCharge = double.tryParse(deliveryChargeController.text.toString().trim());
    var rxInvoice = double.tryParse(preChargeController.text.toString().trim());
    var rxCharge = double.tryParse(widget.rxCharge.toString().trim());
    logger.i(deliveryCharge);
    logger.i(rxInvoice);
    logger.i(rxCharge);
    double multiRxCharge = (rxCharge != null ? rxCharge : 0) * (rxInvoice != null ? rxInvoice : 0);
    double totalCharge = 0.00;
    if (multiRxCharge != null && deliveryCharge != null) totalCharge = multiRxCharge + deliveryCharge;
    totalAmount = "${totalCharge.toStringAsFixed(2)}";

    // var deliveryCharge = double.tryParse(deliveryChargeController.text.toString().trim());
    // var preAmount = double.tryParse(preChargeController.text.toString().trim());
    // if(deliveryCharge != null && preAmount != null) {
    //   preAmount = (9.18 * preAmount);
    //   totalAmount = (deliveryCharge + preAmount).toStringAsFixed(2);
    // }else{
    //   if(preAmount == null && deliveryCharge != null)
    //     totalAmount = "${(deliveryCharge + 9.18).toStringAsFixed(2)}";
    //   else
    //     totalAmount = "0.00";
    // }
    setState(() {});
  }
}

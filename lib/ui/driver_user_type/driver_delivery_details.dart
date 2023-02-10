// @dart=2.9
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/order_model.dart';
import 'package:pharmdel_business/ui/driver_user_type/click_image.dart';
import 'package:pharmdel_business/util/calling_util.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:pharmdel_business/util/log_print.dart';
import 'package:pharmdel_business/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DB/MyDatabase.dart';
import '../../model/delivery_pojo_model.dart';
import '../../model/parcel_box_api_response.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../login_screen.dart';
import '../splash_screen.dart';

class DriverDeliveryDetails extends StatefulWidget {
  OrderModal orderModel;
  List<DeliveryPojoModal> outForDelivery;
  String routeId;
  dynamic orderId;
  dynamic rxInvoice;
  dynamic delCharge;
  int subsId;

  DriverDeliveryDetails({this.orderModel, this.outForDelivery, this.routeId, this.orderId, this.rxInvoice, this.delCharge, this.subsId});

  @override
  DriverDeliveryDetailsState createState() => DriverDeliveryDetailsState();
}

class DriverDeliveryDetailsState extends State<DriverDeliveryDetails> {
  ApiCallFram _apiCallFram = ApiCallFram();
  String accessToken = "", _selectedDeliveryStatus = "OutForDelivery", userId, driverType;
  int _selectedStatusCode = 2;
  bool isDeliveryNote = false, isCustomerNote = false, isFridgeNote = false, isControlledDrugs = false, isControlNote = false;
  TextEditingController remarkController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  List<String> statusItems = [];
  List orderId = [];
  List customerId = [];
  List<ReletedOrders> paitentList = [];

  bool isCustomerSame = false;
  bool isExpanded = false;

  var isCheked = false;

  String selectedDate;
  String selectedDateTimeStamp;
  final DateFormat formatter = DateFormat("dd-MM-yyyy");

  // ProgressDialog progressDialog;

  List<ParcelBoxData> parcelBoxList = [];

  ParcelBoxData parcelDropdownValue;

  List<String> failedRemarkList = ["Not at home", "No answer", "Can not find address", "Customer denied to take delivery", "Others"];
  int id = 0;
  int ids = 0;

  var _paidSelected = false;

  int selectedExemptionId;
  String selectedExemption;

  bool isUpdateMobile = false;

  List<String> paymentTypeList = ["Cash", "Card", "Not paid"];

  int val = 0;
  int orderVal = 0;

  TextEditingController preChargeController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String totalAmount = "0.00";

  int pharmacyId;

  int isPresCharge;
  int isDelCharge;
  dynamic charge = 0.0;
  dynamic delCharge = 0.0;
  dynamic delCharge1 = 0.0;

  @override
  void initState() {
    super.initState();

    logger.i('gggggggg1 ${widget.outForDelivery.length}');
    logger.i('${widget.delCharge}');
    // preChargeController.text = "1";
    var delCharge2 = 0.0;
    logger.i("log123 ${widget.orderModel.related_orders.length}");
    List<int> ids1 = [];
    if (widget.orderModel.related_orders != null && widget.orderModel.related_orders.length > 0)
      // widget.orderModel.related_orders.forEach((element)
      for (int i = 0; i < widget.orderModel.related_orders.length; i++) {
        logger.i("widget.orderModel.related_orders[i].userId ${widget.orderModel.related_orders[i].userId}");
        bool user23 = ids1.any((element) => element.toString() == widget.orderModel.related_orders[i].userId.toString());
        if (user23 == false) {
          ids1.add(widget.orderModel.related_orders[i].userId);

          if (widget.orderModel.related_orders[i].isSelected) {
            if (widget.orderModel.related_orders[i].rxCharge != null) charge = widget.orderModel.related_orders[i].rxCharge;
            if (widget.orderModel.related_orders[i].delCharge != null && widget.orderModel.related_orders[i].delCharge != 0 && widget.orderModel.related_orders[i].delCharge != "0") {
              // logger.i('asdf ${element.delCharge}');
              // delCharge = double.tryParse(element.delCharge.toString());
              // delCharge2 = delCharge2 + double.tryParse(element.delCharge.toString());
              // if(element.userId == widget.orderModel.related_orders[0].userId){
              //  delCharge1 = delCharge2 - double.tryParse(element.delCharge.toString());
              //   logger.i("delCharge1 ${delCharge1}");
              // }
              // logger.i("log123");
              // int index = widget.orderModel.related_orders.indexWhere((element1) => element1.userId != widget.orderModel.related_orders[0].userId);
              // if(index > 0){
              //   delCharge = double.tryParse(widget.orderModel.related_orders[i].delCharge.toString());
              delCharge = delCharge + double.tryParse(widget.orderModel.related_orders[i].delCharge.toString());
              // logger.i("delCharge $delCharge");
              // } else{
              //   delCharge = double.tryParse(widget.orderModel.related_orders[i].delCharge.toString());
              // }
            }
          }
        }
      }

    // int rxInvoiceInt = 1;
    // widget.orderModel.related_orders.where((elements) {
    //   if(elements.isSelected == true){
    //     rxInvoiceInt = elements.rxInvoice;
    //   }
    // });
    // elements.isSelected == true)
    //     .toList()
    //     .length;

    deliveryChargeController.text = '${delCharge == 0.0 ? widget.delCharge != null ? widget.delCharge : 0 : delCharge}'; //widget.orderModel.delCharge != null ? "${widget.orderModel.delCharge ?? "0"}" : '0';
    preChargeController.text = '${widget.rxInvoice != null ? widget.rxInvoice > 0.0 ? widget.rxInvoice : 0.0 : 0.0}'; //widget.orderModel.rxInvoice != null && widget.orderModel.rxInvoice > 0 ? "${widget.orderModel.rxInvoice ?? "1"}" : '1';
    // progressDialog = ProgressDialog(context, isDismissible: true);
    selectedDate = formatter.format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    selectedDateTimeStamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).millisecondsSinceEpoch.toString();
    logger.i(selectedDateTimeStamp);
    remarkController.text = "${widget.orderModel.deliveryRemarks ?? ""}";
    toController.text = "${widget.orderModel.deliveryTo ?? ""}";
    checkLastTime(context);
    calculateAmount();
    if (toController.text == "") {
      toController.text = "Patient";
    }
    _selectedDeliveryStatus = "${widget.orderModel.deliveryStatusDesc == "Ready" ? "PickedUp" : widget.orderModel.deliveryStatusDesc ?? "OutForDelivery"}";
    logger.i("deliveryChargeController.text ${deliveryChargeController.text}");
    if (widget.orderModel != null && widget.orderModel.deliveryStatusDesc != null && widget.orderModel.deliveryStatusDesc == "PickedUp") {
      _selectedDeliveryStatus = "Unpick";
      statusItems.add("Unpick");
      if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "") statusItems.add("Cancel");
    } else if (_selectedDeliveryStatus == "OutForDelivery" || _selectedDeliveryStatus == "Failed") {
      _selectedDeliveryStatus = "Completed";
      _selectedStatusCode = 5;
      statusItems.add("Completed");
      statusItems.add("Failed");
      // statusItems.add("Cancel");
    } else if (_selectedDeliveryStatus == "PickedUp") {
      _selectedDeliveryStatus = "PickedUp";
      _selectedStatusCode = 8;
      statusItems.add("PickedUp");
      // statusItems.add("OutForDelivery");
      // statusItems.add("Failed");
      if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "") statusItems.add("Cancel");
    } else {
      statusItems.add("PickedUp");
      //  statusItems.add("OutForDelivery");
      //  statusItems.add("Completed");
      // statusItems.add("Failed");
      if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "") statusItems.add("Cancel");
      _selectedDeliveryStatus = statusItems[0];
      // statusItems.add("ReadyForDelivery");
    }
    setState(() {
      _selectedDeliveryStatus;
      statusItems;
    });
    // logger.i("List : $statusItems");
    getStatusCode();

    init();

    if (widget.orderModel != null && widget.orderModel.related_orders != null && widget.orderModel.related_orders.isNotEmpty) {
      if (widget.orderModel.related_orders.length == 1) {
        orderId.add(widget.orderModel.related_orders[0].orderId);
        isCustomerSame = true;
      } else {
        widget.orderModel.related_orders.forEach((element) {
          if (element.isSelected) {
            orderId.add(element.orderId);
            logger.i("element.userId: ${element.userId}");
            if (element.userId == widget.orderModel.related_orders[0].userId) {
              isCustomerSame = true;
            } else {
              isCustomerSame = false;
            }
            int exitsCount = paitentList.indexWhere((element1) => element1.userId == element.userId);
            if (exitsCount < 0) {
              paitentList.add(element);
              print(paitentList);
            }
          }
        });
      }
    }
    // print(_selectedDeliveryStatus);
    // if (ProgressDialog(context).isShowing()) {
    //   ProgressDialog(context).hide();
    // }
  }

  @override
  Widget build(BuildContext context) {
    logger.i("test.....${widget.orderModel.isControlledDrugs}");
    var form = new Form(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          if (_selectedStatusCode == 5)
            Padding(
              padding: const EdgeInsets.all(4),
              child: new TextField(
                controller: toController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                autofocus: false,
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
          if (_selectedStatusCode == 5)
            SizedBox(
              height: 5.0,
            ),
          if (_selectedStatusCode == 5)
            Padding(
              padding: const EdgeInsets.all(4),
              child: new TextField(
                controller: remarkController,
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
                    )),
              ),
            ),
          if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
            if (_selectedDeliveryStatus == "Completed")
              if (widget.orderModel.customer.mobile == null || widget.orderModel.customer.mobile.isEmpty)
                if (isCustomerSame)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text("Update customer mobile number"),
                  ),
          if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
            if (_selectedDeliveryStatus == "Completed")
              if (widget.orderModel.customer.mobile == null || widget.orderModel.customer.mobile.isEmpty)
                if (isCustomerSame)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: new TextField(
                      controller: mobileController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      autofocus: false,
                      decoration: new InputDecoration(
                        labelText: "Mobile number",
                        counter: Offstage(),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              if (_selectedStatusCode == 5 && deliveryChargeController.text != null && deliveryChargeController.text.isNotEmpty && deliveryChargeController.text != '0' && deliveryChargeController.text != '0.0')
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
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
              if (_selectedStatusCode == 5)
                SizedBox(
                  width: 5.0,
                ),
              if (_selectedStatusCode == 5 && preChargeController.text != null && preChargeController.text.isNotEmpty && preChargeController.text != '0' && preChargeController.text != '0.0')
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
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
                        prefix: Text("${charge == 0.0 || charge == "0" ? widget.orderModel.rxCharge : charge} x "),
                        //Text("9.18 x "),
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
        ],
      ),
    );

    const gray = const Color(0xFFEEEFEE);
    double c_width = MediaQuery.of(context).size.width * 0.6;
    List ContaineColors = [Colors.green, Colors.red];

    bool _valueCheckBox = false;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: materialAppThemeColor,
            title: FittedBox(
                child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              //  ${widget.orderModel.orderId != null ? widget.orderModel.orderId : ""}
              child: widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == ""
                  ? Text(
                      "Order ID : ${widget.orderId != null ? widget.orderId : ""}${widget.orderModel.pmr_type != null && (widget.orderModel.pmr_type == "titan" || widget.orderModel.pmr_type == "nursing_box") && widget.orderModel.pr_id != null && widget.orderModel.pr_id.isNotEmpty ? ", P/N : ${widget.orderModel.pr_id}" : ""}",
                      style: TextStyle(color: appBarTextColor),
                    )
                  : Text(
                      "Order ID : ${widget.orderModel.nursing_home_id}",
                      style: TextStyle(color: appBarTextColor),
                    ),
            )),
            titleSpacing: 0,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Icon(
                Icons.arrow_back,
                color: appBarTextColor,
              ),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: widget.orderModel.related_orders.isNotEmpty && widget.orderModel.related_orders.length == 1
                      ? Container(
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
                                    if (widget.orderModel != null && widget.orderModel.parcelName != null && widget.orderModel.parcelName.toString().isNotEmpty && widget.orderModel.deliveryStatusDesc == WebConstant.Status_out_for_delivery)
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
                                                  "${widget.orderModel.parcelName.length > 8 ? widget.orderModel.parcelName.substring(0, 8) : widget.orderModel.parcelName ?? ""}",
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
                                      "${widget.orderModel.customer.fullName ?? ""}",
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
                                          "${widget.orderModel.customer.fullAddress ?? ""}",
                                          style: TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                        height: 0,
                                      ),
                                      if (widget.orderModel.customer.alt_address == "t")
                                        Image.asset(
                                          "assets/alt-add.png",
                                          height: 18,
                                          width: 18,
                                        ),
                                      SizedBox(
                                        width: 5,
                                        height: 0,
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
                                            if (widget.orderModel.customer.latitude != null) {
                                              MapsLauncher.launchQuery("${widget.orderModel.customer.fullAddress ?? widget.orderModel.customer.fullAddress ?? ""}");

                                              // MapsLauncher.launchCoordinates(
                                              //     widget
                                              //         .orderModel.customer.latitude,
                                              //     widget.orderModel.customer
                                              //         .longitude);
                                            } else if (widget.orderModel.customer.address != null) {
                                              MapsLauncher.launchQuery("${widget.orderModel.customer.fullAddress ?? widget.orderModel.customer.fullAddress ?? ""}");
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
                                if (widget.orderModel.customer.mobile != null &&
                                    widget.orderModel.customer.mobile.isNotEmpty &&
                                    widget.orderModel.customer.mobile !=
                                        ""
                                            "")
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Text("${widget.orderModel.customer.mobile ?? ""}", textAlign: TextAlign.left),
                                      ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      if (_selectedDeliveryStatus == "Completed" &&
                                          widget.orderModel.customer.mobile != null &&
                                          widget.orderModel.customer.mobile.isNotEmpty &&
                                          widget.orderModel.customer.mobile !=
                                              ""
                                                  "")
                                        InkWell(
                                          onTap: () {
                                            isUpdateMobile = true;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.edit,
                                          ),
                                        ),
                                      Spacer(),
                                      if (widget.orderModel.customer.mobile != null && widget.orderModel.customer.mobile.isNotEmpty)
                                        InkWell(
                                            onTap: () {
                                              if (widget.orderModel.customer.mobile != null && widget.orderModel.customer.mobile.isNotEmpty) {
                                                makePhoneCall(widget.orderModel.customer.mobile);
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
                                if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
                                  if (isUpdateMobile && _selectedDeliveryStatus == "Completed")
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: new TextField(
                                        controller: mobileController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        maxLength: 12,
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                        autofocus: false,
                                        decoration: new InputDecoration(
                                          labelText: "Update Mobile number",
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                                          border: new OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                            borderSide: BorderSide(color: Colors.grey[400]),
                                          ),
                                        ),
                                      ),
                                    ),
                                if (widget.orderModel.customer.mobile != null && widget.orderModel.customer.mobile.isNotEmpty)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (widget.orderModel.deliveryNote != null && widget.orderModel.deliveryNote != "")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      'New Delivery Note',
                                      style: TextStyle(fontSize: 16, color: CustomColors.yetToStartColor),
                                    ),
                                  ),
                                if (widget.orderModel.deliveryNote != null && widget.orderModel.deliveryNote != "")
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
                                          new TextSpan(text: "${widget.orderModel.deliveryNote ?? ""}", style: new TextStyle(fontSize: 14, color: Colors.blue[900])),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (widget.orderModel.exitingNote != null && widget.orderModel.exitingNote != "")
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (widget.orderModel.exitingNote != null && widget.orderModel.exitingNote != "")
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      'Existing Note',
                                      style: TextStyle(fontSize: 16, color: CustomColors.yetToStartColor),
                                    ),
                                  ),
                                if (widget.orderModel.exitingNote != null && widget.orderModel.exitingNote != "")
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
                                          new TextSpan(text: "${widget.orderModel.exitingNote ?? ""}", style: new TextStyle(fontSize: 14, color: Colors.blue[900])),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    isExpanded = !isExpanded;
                                    setState(() {});
                                  },
                                  child: Row(
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
                                      Icon(
                                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        color: CustomColors.yetToStartColor,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                if (isExpanded)
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: paitentList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          margin: EdgeInsets.only(
                                            bottom: paitentList.length - 1 == index ? 5.0 : 8.0,
                                          ),
                                          child: Stack(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    flex: 1,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: <Widget>[
                                                              Flexible(
                                                                child: Text(
                                                                  "${paitentList[index].fullName ?? ""}",
                                                                  maxLines: 2,
                                                                  style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w700),
                                                                ),
                                                              ),
                                                              if (paitentList[index].nursing_home_id == null || paitentList[index].nursing_home_id == 0)
                                                                if (paitentList[index].pmr_type != null && (paitentList[index].pmr_type == "titan" || paitentList[index].pmr_type == "nursing_box") && paitentList[index].pr_id != null && paitentList[index].pr_id.isNotEmpty)
                                                                  Text(
                                                                    '(P/N : ${paitentList[index].pr_id ?? ""}) ',
                                                                    style: TextStyle(color: CustomColors.pnColor),
                                                                  ),
                                                              if (paitentList[index].isCronCreated == "t") Image.asset("assets/automatic_icon.png", height: 14, width: 14),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Image.asset("assets/home_icon.png", height: 18, width: 18, color: CustomColors.yetToStartColor),
                                                              SizedBox(
                                                                width: 5,
                                                                height: 0,
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  "${paitentList[index].fullAddress ?? paitentList[index].fullAddress ?? ""}",
                                                                  style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w300),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 3,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                                height: 0,
                                                              ),
                                                              if (paitentList[index].alt_address == "t")
                                                                Image.asset(
                                                                  "assets/alt-add.png",
                                                                  height: 18,
                                                                  width: 18,
                                                                ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          if (isCustomerSame)
                                                            if (widget.orderModel.customer.mobile != null && widget.orderModel.customer.mobile.isNotEmpty)
                                                              Row(
                                                                children: [
                                                                  Text("${widget.orderModel.customer.mobile ?? ""}", textAlign: TextAlign.left),
                                                                  SizedBox(
                                                                    width: 15.0,
                                                                  ),
                                                                  if (_selectedDeliveryStatus == "Completed" && widget.orderModel.customer.mobile != null && widget.orderModel.customer.mobile.isNotEmpty)
                                                                    InkWell(
                                                                      onTap: () {
                                                                        isUpdateMobile = true;
                                                                        setState(() {});
                                                                      },
                                                                      child: Icon(
                                                                        Icons.edit,
                                                                      ),
                                                                    ),
                                                                  Spacer(),
                                                                  if (widget.orderModel.customer.mobile != null && widget.orderModel.customer.mobile.isNotEmpty)
                                                                    InkWell(
                                                                        onTap: () {
                                                                          if (widget.orderModel.customer.mobile != null && widget.orderModel.customer.mobile.isNotEmpty) {
                                                                            makePhoneCall(widget.orderModel.customer.mobile);
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
                                                          if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
                                                            if (isUpdateMobile && _selectedDeliveryStatus == "Completed")
                                                              Padding(
                                                                padding: const EdgeInsets.all(4),
                                                                child: new TextField(
                                                                  controller: mobileController,
                                                                  textInputAction: TextInputAction.next,
                                                                  keyboardType: TextInputType.number,
                                                                  maxLength: 12,
                                                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                                  autofocus: false,
                                                                  decoration: new InputDecoration(
                                                                    labelText: "Update Mobile number",
                                                                    fillColor: Colors.white,
                                                                    filled: true,
                                                                    contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                                                                    border: new OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(50.0),
                                                                      borderSide: BorderSide(color: Colors.grey[400]),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          paitentList[index].deliveryNotes != null && paitentList[index].deliveryNotes != ""
                                                              ? Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      'Delivery Note:   ',
                                                                      style: TextStyle(fontSize: 14, color: CustomColors.yetToStartColor),
                                                                    ),
                                                                    Flexible(child: Text(paitentList[index].deliveryNotes ?? "")),
                                                                  ],
                                                                )
                                                              : SizedBox(),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                paitentList[index].isControlledDrugs != null && paitentList[index].isControlledDrugs != false
                                                                    ? Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                          color: CustomColors.drugColor,
                                                                          // border: Border.all(color: Colors.blue)
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                                          child: Text(
                                                                            "C.D.",
                                                                            style: TextStyle(fontSize: 10, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                                if (paitentList[index].isControlledDrugs != null && paitentList[index].isControlledDrugs != false)
                                                                  SizedBox(
                                                                    width: 10.0,
                                                                  ),
                                                                paitentList[index].isStorageFridge != null && paitentList[index].isStorageFridge != false
                                                                    ? Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                          color: CustomColors.fridgeColor,
                                                                          // border: Border.all(color: Colors.blue)
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                                          child: Text(
                                                                            "Fridge",
                                                                            style: TextStyle(fontSize: 10, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                              ],
                            ),
                          ),
                        ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(4.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: _selectedDeliveryStatus == "Completed"
                //             ? Colors.green
                //             : _selectedDeliveryStatus == "Failed"
                //                 ? Colors.red
                //                 : Colors.transparent,
                //         border: Border.all(color: Colors.grey[700]),
                //         borderRadius: BorderRadius.circular(50.0)),
                //     child: DropdownButtonHideUnderline(
                //       child: ButtonTheme(
                //         alignedDropdown: true,
                //         padding: EdgeInsets.zero,
                //         child: DropdownButton<String>(
                //           isExpanded: true,
                //           value: _selectedDeliveryStatus,
                //           icon: Icon(Icons.arrow_drop_down),
                //           iconSize: 24,
                //           elevation: 16,
                //           style: TextStyle(color: Colors.black),
                //           underline: Container(
                //             height: 2,
                //             color: Colors.black,
                //           ),
                //           onChanged: (String newValue) {
                //             setState(() {
                //               _selectedDeliveryStatus = newValue;
                //               if (_selectedDeliveryStatus == "PickedUp")
                //                 getParcelBoxData(userId);
                //               getStatusCode();
                //               // if (_selectedDeliveryStatus != "PickedUp"){
                //               //   getStatusCode();
                //               // }
                //             });
                //           },
                //           items: statusItems
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value.isNotEmpty ? value : null,
                //               child: Container(
                //                 height: 45.0,
                //                 width: MediaQuery.of(context).size.width,
                //                 alignment: Alignment.centerLeft,
                //                 decoration: BoxDecoration(
                //                     color: value == "Completed"
                //                         ? Colors.green
                //                         : value == "Failed"
                //                             ? Colors.red
                //                             : Colors.transparent,
                //                     borderRadius: BorderRadius.circular(50.0)),
                //                 child: Padding(
                //                   padding: const EdgeInsets.only(left: 10.0),
                //                   child: Text(
                //                     value,
                //                     style: TextStyle(color: Colors.black),
                //                   ),
                //                 ),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // Text(_selectedDeliveryStatus),
                // Text(_selectedStatusCode.toString()),
                Container(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: statusItems.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IconButton(
                              //   onPressed: () {
                              //     // setState(() {
                              //     //   _selectedDeliveryStatus = statusItems[index];
                              //     //   if (_selectedDeliveryStatus == "PickedUp")
                              //     //   print(_selectedDeliveryStatus);
                              //     //     getParcelBoxData(userId);
                              //     //   getStatusCode();
                              //     //   // if (_selectedDeliveryStatus != "PickedUp"){
                              //     //   //   getStatusCode();
                              //     //   // }
                              //     // });
                              //   },
                              //   icon: Icon(Icons.circle),
                              // ),
                              Radio(
                                activeColor: _selectedDeliveryStatus == "Completed" || _selectedDeliveryStatus == "Unpick"
                                    ? Colors.green
                                    : _selectedDeliveryStatus == "Failed" || _selectedDeliveryStatus == "Cancel"
                                        ? Colors.red
                                        : Colors.purple,
                                value: index,
                                groupValue: ids,
                                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                onChanged: (int val) {
                                  setState(() {
                                    _selectedDeliveryStatus = statusItems[index].toString();
                                    if (_selectedDeliveryStatus == "PickedUp") getParcelBoxData(userId);
                                    getStatusCode();

                                    print("Current Status of Deliver is Changes to:::::::::: " + _selectedDeliveryStatus);
                                    print("Current Status code of  Deliver is Changes to:::::::::: " + _selectedStatusCode.toString());

                                    // if (_selectedDeliveryStatus != "PickedUp"){
                                    //   getStatusCode();
                                    // }

                                    _selectedDeliveryStatus == "Completed" || _selectedDeliveryStatus == "Unpick" || _selectedDeliveryStatus == "PickedUp" ? val = 0 : val = 1;
                                    ids = val;
                                    print(ids.toString() + ":::::::::");
                                  });
                                },
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: ContaineColors[index],

                                      // color: _selectedDeliveryStatus ==
                                      //     "Completed" ||
                                      //     _selectedDeliveryStatus ==
                                      //         "Unpick"
                                      //     ? Colors.green
                                      //     : _selectedDeliveryStatus ==
                                      //     "Failed" ||
                                      //     _selectedDeliveryStatus ==
                                      //         "Cancel"
                                      //     ? Colors.red
                                      //     : Colors.purple,

                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Text(
                                    statusItems[index],
                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                if (_selectedDeliveryStatus == "Failed1")
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
                if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
                  if (_selectedDeliveryStatus == "PickedUp" && parcelBoxList != null && parcelBoxList.isNotEmpty)
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
                if (_selectedDeliveryStatus == "Failed")
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: failedRemarkList.length,
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
                                logger.i(failedRemarkList[id]);
                              });
                            },
                          ),
                          Text(
                            failedRemarkList[index],
                          )
                        ],
                      );
                    },
                  ),
                if (failedRemarkList[id] == "Others" && _selectedDeliveryStatus == "Failed")
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: new TextField(
                      controller: otherController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: TextStyle(decoration: TextDecoration.none),
                      decoration: new InputDecoration(
                          labelText: "Other",
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(color: Colors.grey[200]),
                          )),
                    ),
                  ),
                Container(
                  child: Row(
                    children: <Widget>[
                      (widget.orderModel.deliveryNote == false || widget.orderModel.deliveryNote == "") && (widget.orderModel.exitingNote == null || widget.orderModel.exitingNote == "")
                          ? Container(
                              height: 1,
                              width: 1,
                        color: Colors.red,
                            )
                          : Flexible(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5, bottom: 10),
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
                                          "Read Delivery Note",
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      widget.orderModel.customer.customerNote == null || widget.orderModel.customer.customerNote == ""
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 2.0,
                                  right: 15.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      onChanged: (checked) {
                                        setState(() {
                                          isCustomerNote = checked;
                                        });
                                      },
                                      value: isCustomerNote,
                                      checkColor: Colors.white,
                                      activeColor: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Read Customer Note",
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    //dk fridge and cd
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.orderModel.isStorageFridge == null || widget.orderModel.isStorageFridge == false
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                ),
                                child: Container(
                                  height: CustomColors.chkButtonHeight,
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
                                      Flexible(
                                        child: Text(
                                          "${widget.orderModel.totalStorageFridge != null && widget.orderModel.totalStorageFridge != 0 ? widget.orderModel.totalStorageFridge : ""} Fridge",
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      widget.orderModel.isControlledDrugs == null || widget.orderModel.isControlledDrugs == false
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
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
                                          "${widget.orderModel.totalControlledDrugs != null && widget.orderModel.totalControlledDrugs != 0 ? widget.orderModel.totalControlledDrugs : ""} Controlled Drugs",
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                      widget.orderModel.customer.controlNote == null || widget.orderModel.customer.controlNote == false
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 2.0,
                                  right: 15.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      visualDensity: VisualDensity(horizontal: -4),
                                      onChanged: (checked) {
                                        setState(() {
                                          isControlNote = checked;
                                        });
                                      },
                                      value: isControlNote,
                                      checkColor: Colors.white,
                                      activeColor: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "CD",
                                        style: TextStyle(fontSize: 12, color: Colors.redAccent),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      // if(widget.orderModel.paymentStatus != null && widget.orderModel.paymentStatus.isNotEmpty && widget.orderModel.paymentStatus != "unPaid")
                      // Container(
                      //   height: 30,
                      //   padding: EdgeInsets.only(right: 5),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(50.0),
                      //     color: Colors.orange,
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Checkbox(
                      //         visualDensity: VisualDensity(horizontal: -4),
                      //         value: _paidSelected,
                      //         onChanged: (newValue) {
                      //           setState(() {
                      //             _paidSelected = newValue;
                      //           });
                      //         },
                      //       ),
                      //       new Text(
                      //         "${widget.orderModel.paymentStatus ?? ""}",
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
                  Row(
                    children: [
                      if (widget.orderModel.exemption != null && widget.orderModel.exemption.isNotEmpty)
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
                                if (selectedExemptionId != 2)
                                  new Text(
                                    "Exempt ${selectedExemption != null && selectedExemption.isNotEmpty ? ": " + selectedExemption : widget.orderModel.exemption != null && widget.orderModel.exemption.isNotEmpty ? ": " + widget.orderModel.exemption : ""}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                if (selectedExemptionId == 2)
                                  Text(
                                    "Exempt ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                if (_selectedDeliveryStatus == "Completed" && widget.orderModel.exemptions != null && widget.orderModel.exemptions.isNotEmpty)
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
                      if (widget.orderModel.bagSize != null && widget.orderModel.bagSize.isNotEmpty)
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
                                  "Bag Size : ${widget.orderModel.bagSize}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
                  if (_selectedDeliveryStatus == "Completed")
                    (deliveryChargeController.text == null || deliveryChargeController.text.isEmpty || deliveryChargeController.text == '0' || deliveryChargeController.text == '0.0') && (preChargeController.text == null || preChargeController.text.isEmpty || preChargeController.text == '0' || preChargeController.text == '0.0')
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
                if (widget.orderModel.nursing_home_id == null || widget.orderModel.nursing_home_id == 0 || widget.orderModel.nursing_home_id == "")
                  if (orderId.length > 1)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey[100], border: Border.all(color: Colors.grey[700]), borderRadius: BorderRadius.circular(50.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note : Multiple order completed of below id\'s ',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            new Row(
                              children: [
                                Text(
                                  'Order ID :  ',
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                                Expanded(
                                  child: Text(
                                    "${orderId.join(", ")}",
                                    style: TextStyle(fontSize: 12, color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 40, bottom: 10),
                    child: new SizedBox(
                      width: MediaQuery.of(context).size.width - 22,
                      height: 45,
                      child: new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          bool checkInternet = await ConnectionValidator().check();
                          logger.i(_selectedDeliveryStatus);
                          if (_selectedDeliveryStatus == 'PickedUp' || _selectedDeliveryStatus == 'Cancel') {
                            if (isValidate()) {
                              if (!checkInternet) {
                                Fluttertoast.showToast(msg: "Internet Not Connected");
                              } else {
                                _submit();
                              }
                            }
                          } else if (isValidate()) {
                            if (_selectedDeliveryStatus == 'Completed' || _selectedDeliveryStatus == 'Failed') {
                              // Navigator.pop(context);
                              logger.i(selectedDate);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ClickImage(
                                            delivery: widget.orderModel,
                                            isCdDelivery: isControlledDrugs,
                                            outForDelivery: widget.outForDelivery,
                                            notPaidReason: _selectedDeliveryStatus == "Completed"
                                                ? paymentTypeList[val] == "Not paid"
                                                    ? commentController.text.toString().trim()
                                                    : ""
                                                : "",
                                            addDelCharge: widget.delCharge != null ? widget.delCharge.toString() : "",
                                            subsId: widget.subsId,
                                            rxCharge: widget.orderModel.rxCharge != null ? widget.orderModel.rxCharge : "",
                                            rxInvoice: widget.rxInvoice != null ? widget.rxInvoice.toString() : "",
                                            paymentType: _selectedDeliveryStatus == "Completed" && ((preChargeController.text != null && preChargeController.text.isNotEmpty && preChargeController.text != '0' && preChargeController.text != '0.0') || (deliveryChargeController.text != null && deliveryChargeController.text.isNotEmpty && deliveryChargeController.text != '0' && deliveryChargeController.text != '0.0')) ? paymentTypeList[val] : "",
                                            amount: totalAmount,
                                            exemptionId: selectedExemptionId != null ? selectedExemptionId : 0,
                                            paymentStatus: _paidSelected ? "paid" : "unPaid",
                                            failedRemark: _selectedDeliveryStatus == "Failed"
                                                ? failedRemarkList[id] == "Others"
                                                    ? otherController.text.toString().trim()
                                                    : failedRemarkList[id]
                                                : "",
                                            mobileNo: _selectedDeliveryStatus == "Completed" ? "${mobileController.text.toString().trim().isNotEmpty ? mobileController.text.toString().trim() : ""}" : "",
                                            selectedStatusCode: _selectedStatusCode,
                                            rescheduleDate: isCheked && selectedDateTimeStamp != null && selectedDateTimeStamp != "" ? selectedDateTimeStamp : "",
                                            remarks: "${remarkController.text}",
                                            deliveredTo: "${toController.text}",
                                            orderid: orderId,
                                            routeId: widget.routeId != null && widget.routeId != "" ? widget.routeId : "",
                                          )));
                              //_showSnackBar("Status Successfully Updated");
                            } else {
                              _submit();
                            }
                          }
                        },
                        child: new Text(
                          "Update Status",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getParcelBoxData(String driverId) async {
    parcelBoxList.clear();

    // if (!progressDialog.isShowing())
    //   progressDialog.show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId");
    _apiCallFram.getDataRequestAPI(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId", accessToken, context).then((response) async {
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
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
          // await CustomLoading().showLoadingDialog(context, true);
        }
      } catch (_, stackTrace) {
        logger.i(_);
        SentryExemption.sentryExemption(_, stackTrace);
        // print(_);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  Future<void> getPharmacyInfo(int pharmacyId) async {
    parcelBoxList.clear();

    // if (!progressDialog.isShowing())
    //   progressDialog.show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.GET_PHARMACY_INFO + "?pharmacyId=$pharmacyId");
    _apiCallFram.getDataRequestAPI(WebConstant.GET_PHARMACY_INFO + "?pharmacyId=$pharmacyId", accessToken, context).then((response) async {
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
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
          // await CustomLoading().showLoadingDialog(context, true);
        }
      } catch (_, stackTrace) {
        logger.i(_);
        SentryExemption.sentryExemption(_, stackTrace);
        // print(_);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

  Future<void> _submit() async {
    // getStatusCode();
    Map<String, dynamic> prams = {
      "deliveryId": orderId,
      "exemption": selectedExemptionId != null ? selectedExemptionId : 0,
      "paymentStatus": _paidSelected ? "paid" : "unPaid",
      "remarks": "${remarkController.text}",
      "deliveredTo": "${toController.text}",
      "parcel_box_id": parcelDropdownValue != null && parcelDropdownValue.id != null ? parcelDropdownValue.id : 0,
      "deliveryStatus": _selectedStatusCode,
      "routeId": int.parse(widget.routeId),
      "pickupTypeId": widget.orderModel.pickupTypeId,
    };
    logger.i(prams);
    logger.i(WebConstant.DELIVERY_STATUS_UPDATE_URL);
    // await ProgressDialog(context, isDismissible: false).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    _apiCallFram.postDataAPI(WebConstant.DELIVERY_STATUS_UPDATE_URL, accessToken, prams, context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
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
      try {
        if (response != null) {
          logger.i(response.body);
          var data = json.decode(response.body);
          if (data["status"] == true) {
            try {
              // Navigator.of(context, rootNavigator: true)
              //     .pop(_selectedDeliveryStatus);
              Navigator.of(context).pop(true);
              logger.i(orderId);
              if (orderId != null && orderId.isNotEmpty)
                orderId.forEach((element) async {
                  await MyDatabase().deleteCancleDeliveryListById(int.tryParse(element.toString()));
                  await MyDatabase().deleteCancleCustomerDetailsById(int.tryParse(element.toString()));
                  await MyDatabase().deleteCancleAddressDeliveryById(int.tryParse(element.toString()));
                });
              //(context,_selectedDeliveryStatus);
            } catch (e, stackTrace) {
              SentryExemption.sentryExemption(e, stackTrace);
              String jsonUser = jsonEncode(e);
              Fluttertoast.showToast(msg: jsonUser);
              Fluttertoast.showToast(msg: "Oops!! Something went wrong.!!");
              Navigator.of(context).pop(true);
              // print(e);
            }
          } else {
            Fluttertoast.showToast(msg: "Oops!! Something went wrong.!");
          }
        } else {
          Fluttertoast.showToast(msg: "Data not found from server side.");
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        logger.i(e);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    }).catchError((onError, stackTrace) async {
      SentryExemption.sentryExemption(onError, stackTrace);
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      Navigator.of(context).pop(true);
    });
  }

  bool isValidate() {
    // if (widget.orderModel.deliveryId == null) {
    //   Fluttertoast.showToast(msg: "Something went wrong please try again");
    // } else
    if (_selectedDeliveryStatus.isEmpty) {
      Fluttertoast.showToast(msg: "Select a delivery status");
      return false;
    } else if (_selectedDeliveryStatus == "Failed") {
      if (otherController.text.toString().trim() == null || otherController.text.toString().trim().isEmpty) if (failedRemarkList[id] == "Others") {
        Fluttertoast.showToast(msg: "Type failed remark");
        return false;
      }
    } else if (toController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Delivery to isn't empty");
      return false;
    } else if (widget.orderModel.deliveryNote != false && widget.orderModel.deliveryNote != "" && !isDeliveryNote) {
      print("DINESH SINGH DELIVERY NOTE " + widget.orderModel.deliveryNote.toString());
      print("DINESH SINGH DELIVERY NOTE " + widget.orderModel.exitingNote.toString());
      Fluttertoast.showToast(msg: "Check delivery note");
      return false;
    } else if (widget.orderModel.exitingNote != null && widget.orderModel.exitingNote != "" && !isDeliveryNote) {
      print("DINESH SINGH existing NOTE " + widget.orderModel.exitingNote.toString());

      Fluttertoast.showToast(msg: "Check delivery note");
      return false;
    } else if (!isFridgeNote && (widget.orderModel.isStorageFridge != false)) {
      // print(!isFridgeNote && (widget.orderModel.customer.fridgeNote != false));
      Fluttertoast.showToast(msg: "Check Fridge");
      return false;
    } else if (!isControlledDrugs && (widget.orderModel.isControlledDrugs != false)) {
      Fluttertoast.showToast(msg: "Check Controlled Drugs");
      return false;
    } else if (!isCustomerNote && (widget.orderModel.customer.customerNote != null && widget.orderModel.customer.customerNote != "")) {
      // print(widget.orderModel.customer.customerNote != null);
      Fluttertoast.showToast(msg: "Check customer note");
      return false;
    }
    return true;
  }

  void getStatusCode() {
    switch (_selectedDeliveryStatus) {
      case "ReadyForDelivery":
        _selectedStatusCode = 1;
        break;
      case "OutForDelivery":
        _selectedStatusCode = 4;
        break;
      case "Completed":
        _selectedStatusCode = 5;
        break;
      case "Failed":
        _selectedStatusCode = 6;
        break;
      case "Returned":
        _selectedStatusCode = 9;
        break;
      case "Cancel":
        _selectedStatusCode = 9;
        break;
      case "Ready":
        _selectedStatusCode = 3;
        break;
      case "PickedUp":
        _selectedStatusCode = 8;
    }
  }

  Future<void> init() async {
    await SharedPreferences.getInstance().then((value) async {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      userId = value.getString(WebConstant.USER_ID);
      pharmacyId = value.getInt(WebConstant.PHARMACY_ID) ?? 0;
      driverType = value.getString(WebConstant.DRIVER_TYPE) ?? "";
      logger.i("userId : ${value.getString(WebConstant.USER_ID)}");
      if (_selectedDeliveryStatus == "PickedUp") getParcelBoxData(userId);
      // if(_selectedDeliveryStatus == "Completed")
      //   getPharmacyInfo(driverType == Constants.dadicatedDriver ? pharmacyId : widget.orderModel.pharmacyId);
    });
  }

  void exemptBottomSheet(context) {
    List<bool> _checkboxListTile1 = [];
    int index1;
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
                      itemCount: widget.orderModel.exemptions.length > 0 ? widget.orderModel.exemptions.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setStat(() {
                                  for (var element in widget.orderModel.exemptions) {
                                    element.isSelected = false;
                                  }
                                  widget.orderModel.exemptions[index].isSelected = !widget.orderModel.exemptions[index].isSelected;
                                  index1 = index;
                                  setState(() {});
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: widget.orderModel.exemptions[index].isSelected,
                                    visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                    onChanged: (values) {
                                      setStat(() {
                                        for (var element in widget.orderModel.exemptions) {
                                          element.isSelected = false;
                                        }
                                        widget.orderModel.exemptions[index].isSelected = !widget.orderModel.exemptions[index].isSelected;
                                        index1 = index;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                  Flexible(child: Text("${widget.orderModel.exemptions[index].serialId != null && widget.orderModel.exemptions[index].serialId.isNotEmpty ? widget.orderModel.exemptions[index].serialId + " - " : ''}" + "${widget.orderModel.exemptions[index].name != null && widget.orderModel.exemptions[index].name.isNotEmpty ? widget.orderModel.exemptions[index].name : ''}"))
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
                      selectedExemptionId = widget.orderModel.exemptions[index1].id;
                      selectedExemption = widget.orderModel.exemptions[index1].serialId;
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
    var rxCharge = double.tryParse(charge == 0.0 || charge == "0" ? widget.orderModel.rxCharge.toString().trim() : charge);
    double multiRxCharge = (rxCharge != null ? rxCharge : 0) * (rxInvoice != null ? rxInvoice : 0);
    double totalCharge = multiRxCharge + deliveryCharge;
    totalAmount = "${totalCharge.toStringAsFixed(2)}";

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

// @dart=2.9
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/ProcessScanPatientResponse.dart';
import 'package:pharmdel_business/model/pmr_model.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../util/custom_loading.dart';
import '../../util/permission_utils.dart';
import '../../util/sentryExeptionHendler.dart';
import '../driver_user_type/dashboard_driver.dart';
import '../login_screen.dart';
import 'bulk_scan.dart';
import 'delivery_schedule_manual.dart';

class PatainttList extends StatefulWidget {
  //final String routeS;
  bool isBulkScan;
  bool isRouteStart;
  String driverId;
  String driverType;
  String routeId;
  String bulkScanDate;
  String nursingHomeId;
  int parcelBoxId;
  String toteId;
  callGetOrderApi callApi;
  BulkScanMode callPickedApi;

  PatainttList({
    this.isBulkScan,
    this.routeId,
    this.driverId,
    this.nursingHomeId,
    this.parcelBoxId,
    this.driverType,
    this.callPickedApi,
    this.isRouteStart,
    this.callApi,
    this.toteId,
    this.bulkScanDate,
  });

  PatainttListState createState() => PatainttListState();
}

class PatainttListState extends State<PatainttList> {
  BuildContext _ctx;
  bool _isLoading = false;
  bool showList = false;
  bool noData = true;
  String userId, token;

  bool showReset = false;
  String selectedDate;

  var notdeliveryColor = const Color(0xFFE66363);
  var deliverColor = const Color(0xFF0071BC);
  var deliveredColor = const Color(0xFF4AC66E);
  var yetToStartColor = const Color(0xFFF8A340);

  // List<GroupModel> list = new List<GroupModel>();
  List<dynamic> allList = new List();
  List<dynamic> list = new List();
  var totalCount = 0;
  var completedCount = 0;
  var notDeliveredCount = 0;
  var yetToStartCount = 0;

  bool todaySelected = false;
  bool tomorrowSelected = false;
  bool otherDateSelected = false;

  bool smsPermission = false;

  double _size = 1.0;
  var searchController = new TextEditingController();
  bool isApiLoading = false;

  ApiCallFram _apiCallFram = ApiCallFram();

  String accessToken;

  // OrderInfo orderInfo;

  List<Dd> prescriptionList = List();
  List<PmrModel> pmrList = List();

  int endRouteId;
  int startRouteId;
  double startLat;
  double startLng;

  void grow() {
    setState(() {
      _size += 0.1;
    });
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    accessToken = prefs.getString(WebConstant.ACCESS_TOKEN);
    userId = prefs.getString('userId') ?? "";
    endRouteId = prefs.getInt(WebConstant.END_ROUTE_AT) ?? 0;
    startRouteId = prefs.getInt(WebConstant.START_ROUTE_FROM) ?? 0;
    logger.i("widget.isRouteStart ${widget.isRouteStart}");
    // getDeliveryList();
  }

  getLocationData() async {
    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
      logger.i("in location1");
      if (value) {
        logger.i("in location2");
        var position = await GeolocatorPlatform.instance.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
        logger.i("in location3");
        startLat = position.latitude;
        startLng = position.longitude;
        logger.i("in location $startLat");
        logger.i("in location $startLng");
      }
    });
  }

  methodInParent() => {};

  @override
  void initState() {
    super.initState();
    getLocationData();
    init();
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    // progressDialog = new ProgressDialog(context);
    // progressDialog.style(
    //     message: "Please wait...",
    //     borderRadius: 4.0,
    //     backgroundColor: Colors.white);
    if (isApiLoading) getDeliveryList(searchController.text.toString().trim());
    const PrimaryColor = const Color(0xFFffffff);
    const gray = const Color(0xFFEEEFEE);
    const titleColor = const Color(0xFF151026);
    const blue = const Color(0xFF2188e5);
    double c_width = MediaQuery.of(context).size.width * 0.5;
    return SafeArea(
      child: Scaffold(
          backgroundColor: gray,
          appBar: AppBar(
            backgroundColor: materialAppThemeColor,
            //toolbarHeight: 110, // Set this height
            // backgroundColor: Colors.blue[200],
            leading: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: appBarTextColor,
                    ),
                  ),
                )),
            // leading: new IconButton(
            //   icon: new Icon(
            //     Icons.arrow_back,
            //     color: Colors.blueGrey,
            //   ),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
            flexibleSpace: Container(
              margin: const EdgeInsets.only(left: 30),
              color: Colors.transparent,
              child: Column(children: <Widget>[
                Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: searchController,
                      onChanged: (cha) {
                        if (cha.isNotEmpty) {
                          getDeliveryList(cha.toString());
                          /* List<dynamic> lll = List();
                          for (int i = 0; i < allList.length; i++) {
                            if (allList[i]['customerName']
                                .toString()
                                .toLowerCase()
                                .trim()
                                .contains(
                                    cha.toString().toLowerCase().trim())) {
                              lll.add(allList[i]);
                            }
                          }
                          setState(() {
                            list = lll;
                          });*/
                        } else {
                          setState(() {
                            list = allList;
                          });
                        }
                      },
                      //autofocus: true,
                      decoration: InputDecoration(focusColor: Colors.white, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), filled: true, fillColor: Colors.transparent, border: InputBorder.none, hintStyle: new TextStyle(color: Colors.black38), hintText: "Search Patient...."),
                    )),
              ]),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    //height: MediaQuery.of(context).size.height/1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/bottom_bg.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                CustomScrollView(slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      noData
                          ? Container(
                              height: 200,
                              child: Center(
                                child: Text(
                                  'No Patient Available',
                                  style: TextStyle(color: Colors.black38, fontSize: 24),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                          padding: const EdgeInsets.all(4),
                          child: new Container(
                              child: new Center(
                            child: _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                          )))
                    ]),
                  ),
                  _getSlivers(list, context, c_width)
                ]),
              ],
            ),
          )),
    );
  }

  SliverList _getSlivers(List myList, BuildContext context, double c_width) {
    const blue = const Color(0xFF2188e5);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Visibility(
              visible: showList,
              child: new InkResponse(
                onTap: () => _onTileClicked(index),
                child: new Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 0, left: 3, right: 3),
                  child: new Card(
                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Column(
                              children: [
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Name : ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      Flexible(
                                        child: RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: list[index]['firstName'] != null ? list[index]['firstName'] + " " : "",
                                                style: TextStyle(fontSize: 14, color: Colors.black),
                                              ),
                                              new TextSpan(text: list[index]['middleName'] != null ? list[index]['middleName'] + " " : "", style: new TextStyle(fontSize: 14, color: Colors.black)),
                                              new TextSpan(text: list[index]['lastName'] != null ? list[index]['lastName'] : "", style: new TextStyle(fontSize: 14, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Expanded(
                                      //  child:
                                      Text(
                                        'Address :  ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      //   flex: 2,
                                      //),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: new Text(list[index]['address1'] != null ? list[index]['address1'] : "N/A", textAlign: TextAlign.left),
                                            ),
                                            if (list != null && list.isNotEmpty && list[index]['alt_address'] != null && list[index]['alt_address'] != "" && list[index]['alt_address'].toString() == "t")
                                              Image.asset(
                                                "assets/alt-add.png",
                                                height: 18,
                                                width: 18,
                                              ),
                                          ],
                                        ),
                                      ),
                                      // Expanded(
                                      //   // child: new Container(
                                      //   //width: c_width,
                                      //   child: new Column(
                                      //     children: <Widget>[
                                      //       new Text(
                                      //           list[index]['address1'] != null
                                      //
                                      //               ? list[index]['address1']
                                      //               : "N/A",
                                      //           textAlign: TextAlign.left),
                                      //     ],
                                      //     // ),
                                      //   ),
                                      //   flex: 0,
                                      // )
                                    ],
                                  ),
                                ),
                                // new Padding(
                                //   padding: const EdgeInsets.all(4),
                                //   child: new Row(
                                //     children: [
                                //       Expanded(child: new Text(
                                //         'Address : ',
                                //         style: TextStyle(
                                //             fontSize: 14, color: Colors.grey),
                                //
                                //       )
                                //       )
                                //       ,
                                //       new Expanded(
                                //         //width: c_width,
                                //         child: new Text(
                                //           list[index]['address1'] != null
                                //
                                //               ? list[index]['address1']
                                //                   : "N/A",
                                //           textAlign: TextAlign.left,
                                //           //overflow: TextOverflow.ellipsis,
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Date of Birth : ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        list[index]['dob'] != null ? list[index]['dob'] : "N/A",
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                // new Padding(
                                //   padding: const EdgeInsets.all(4),
                                //   child: new Row(
                                //     children: [
                                //       new Text(
                                //         'Shelf Name : ',
                                //         style: TextStyle(
                                //             fontSize: 14, color: Colors.grey),
                                //       ),
                                //       new Text(
                                //         list[index]['rackNo'] != null
                                //             ? list[index]['rackNo']
                                //             : "N/A",
                                //         style: TextStyle(
                                //             fontSize: 14, color: Colors.black),
                                //       ),
                                //     ],
                                //   ),
                                // )
                                /*new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Email : ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        list[index]['email'] != null
                                            ? list[index]['email']
                                            : "-",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Landline Number : ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        list[index]['landlineNumber'] != null
                                            ? list[index]['landlineNumber']
                                            : "-",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Tag : ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        "Collection",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),*/
                                /*new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        widget.routeS != null ? "Route: " + widget.routeS: "",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                     */ /* new Text(
                                        list[index]['customerName'] != null ? list[index]['customerName']: " ",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),*/ /*
                                    ],
                                  ),
                                ),*/
                              ],
                            ),
                            flex: 4,
                          ), //deliveryDate: 2020-03-05T00:00:00
                          /* new Expanded(
                            flex: 1,
                            child: list[index]['deliveryStatus'] != null ? Column(
                              children: <Widget>[
                                if (list[index]['deliveryStatus'].toString() ==
                                        "1" ||
                                    list[index]['deliveryStatus'].toString() ==
                                        "7")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: deliverColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus']
                                        .toString() ==
                                    "2")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: yetToStartColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus']
                                        .toString() ==
                                    "3")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: deliveredColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/delivery_done.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus']
                                            .toString() ==
                                        "4" ||
                                    list[index]['deliveryStatus'].toString() ==
                                        "5")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: notdeliveryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                */ /*else
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: notdeliveryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))*/ /*
                              ],
                            ):SizedBox(),
                          )*/
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
        childCount: myList.length,
      ),
    );
  }

  void _onTileClicked(int index) {
    // if (smsPermission != true) {
    //   requestStoragePermission();
    // } else {
    //Navigator.pop(context, false);
    if (list[index]['lastOrderId'] != null) {
      String name = "";
      if (list[index]['firstName'] != null) name = list[index]['firstName'].toString() + " ";
      if (list[index]['middleName'] != null) name = name + list[index]['middleName'].toString() + " ";
      if (list[index]['lastName'] != null) name = name + list[index]['lastName'].toString();
      postDataAndVerifyUser(list[index]['customerId']);
      // if (widget.type == "Shelf") {
      //   getOrderDetails(list[index]['lastOrderId']);
      // } else {
      //   //Comment by DMK removed assign self popu
      //
      //   // Navigator.push(
      //   //   context,
      //   //   MaterialPageRoute(
      //   //       builder: (context) => CollectionDetailScreen(
      //   //         customerId: list[index]['customerId'].toString(),
      //   //         lastOrderId: list[index]['lastOrderId'].toString(),
      //   //         name: name,
      //   //         address: list[index]['address1'] != null
      //   //             ? list[index]['address1'].toString()
      //   //             : "N/A",
      //   //         paymentExemption: list[index]['paymentExemption'] != null
      //   //             ? list[index]['paymentExemption'].toString()
      //   //             : "N/A",
      //   //         type: widget.type,
      //   //         function: reload,
      //   //         isControlledDrugs: list[index]['isControlledDrugs'],
      //   //         isStorageFridge: list[index]['isStorageFridge'],
      //   //       )),
      //   // ).then((value) => isApiLoading = true);
      //
      // }
    } else {
      _showSnackBar("Order id not found");
    }
    //}
  }

  Future<void> postDataAndVerifyUser(int resul) async {
    PmrModel model = PmrModel();
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    // model.xml.patientInformation.nhs = "";
    // print(accessToken);
    _apiCallFram.postFormDataAPI(WebConstant.REGISTER_CUSTOMER_WITH_ORDER + "?patientid=$resul", accessToken, "", context).then((response) async {
      // ProgressDialog(context,isDismissible: false).hide();
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
          if (data["isExist"] != 1) {
            if (data["error"] == false) {
              setState(() {
                //Navigator.of(context).pop(true);
                ProcessScanPatientResponse response1 = ProcessScanPatientResponse.fromJson(data);
                if (response1 != null && response1.data != null && response1.data.orderInfo != null) {
                  if (response1.data.orderInfo != null) {
                    // orderInfo = response1.data.orderInfo;
                    Xml xml = Xml();
                    model.xml = xml;
                    Pa pa = Pa();
                    model.xml.patientInformation = pa;
                    model.xml.customerId = response1.data.orderInfo.userId;
                    model.xml.patientInformation.nhs = "${response1.data.orderInfo.nhsNumber != null ? response1.data.orderInfo.nhsNumber : ""}";
                    model.xml.patientInformation.firstName = response1.data.orderInfo.firstName;
                    model.xml.patientInformation.lastName = response1.data.orderInfo.lastName;
                    model.xml.patientInformation.middleName = response1.data.orderInfo.middleName;
                    model.xml.patientInformation.dob = response1.data.orderInfo.dob;
                    model.xml.patientInformation.address = response1.data.orderInfo.address;
                    model.xml.patientInformation.nursing_home_id = response1.data.orderInfo.nursing_home_id;

                    pmrList.add(model);
                    // prescriptionList.addAll(model.xml.dd);
                    if (widget.isBulkScan) {
                      createOrder(response1.data.orderInfo);
                    } else
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryScheduleManual(
                                    orderInof: response1.data.orderInfo,
                                    callApi: widget.callPickedApi,
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
              _showSnackBar(data["message"]);
            }
          } else {
            // showDialog<void>(
            //   context: context,
            //
            //   barrierDismissible: false, // user must tap button!
            //   builder: (BuildContext context) {
            //     return WillPopScope(
            //       onWillPop: () async => false,
            //       child: AlertDialog(
            //         title: Text('Repeat Click'),
            //         content: SingleChildScrollView(
            //           child: ListBody(
            //             children: <Widget>[
            //               //Text('This is a demo alert dialog.'),
            //               Text(
            //                   'Duplicate Prescriptions, It is already scanned. Please scan another prescriptions.'),
            //             ],
            //           ),
            //         ),
            //         actions: <Widget>[
            //           InkWell(
            //             child: Container(
            //               padding: EdgeInsets.all(10),
            //               child: Text(
            //                 'Ok',
            //                 style: TextStyle(color: Colors.blue),
            //               ),
            //             ),
            //             onTap: () {
            //               Navigator.of(context).pop();
            //               Navigator.of(context).pop(false);
            //             },
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // );
          }

          // else if (data["status"] == false) {
          //   List<Map<String, dynamic>> customerList = data["customerList"];
          //   if (customerList == null) customerList = [];
          //   if (customerList.length > 0) {
          //     selectionOneCustomer(customerList);
          //   } else if (data["message"] == "User not found") {
          //     showDialog<void>(
          //       context: context,
          //
          //       barrierDismissible: false, // user must tap button!
          //       builder: (BuildContext context) {
          //         return WillPopScope(
          //           onWillPop: () async => false,
          //           child: AlertDialog(
          //             title: Text('Repeat Click'),
          //             content: SingleChildScrollView(
          //               child: ListBody(
          //                 children: <Widget>[
          //                   //Text('This is a demo alert dialog.'),
          //                   Text(
          //                       'User not registered, Continue to create a new user'),
          //                 ],
          //               ),
          //             ),
          //             actions: <Widget>[
          //               InkWell(
          //                 child: Container(
          //                   padding: EdgeInsets.all(10),
          //                   child: Text(
          //                     'CONTINUE',
          //                     style: TextStyle(color: Colors.blue),
          //                   ),
          //                 ),
          //                 onTap: () {
          //                   Navigator.of(context).pop();
          //                   setState(() {
          //                     model.xml.isAddNewCustomer = true;
          //                     postDataAndVerifyUser(model);
          //                   });
          //                 },
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   }
          // }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // print("Exception : $e");
        // Navigator.of(context).pop(true);
      }
    });
  }

  // Future<Map<String, Object>> getDetails(String lastOrderId) async {
  //
  //   ProgressDialog(context, isDismissible: false).show();
  //
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "Authorization": 'bearer $token'
  //   };
  //   Map<String, dynamic> map = {
  //     //"pharmacyId": int.parse(pharmacyId),
  //     "userId": int.parse(userId),
  //     "tokenId": token,
  //     //"branchId": int.parse(branchId),
  //     "message": "token register done"
  //   };
  //   final j = json.encode(map);
  //   final response = await http.get(
  //       WebConstant.ORDER_DETAILS_LIST_URL + lastOrderId,
  //       headers: headers);
  //   ProgressDialog(context).hide();
  //
  //   if (response.statusCode == 200) {
  //     Map<String, Object> data = json.decode(response.body);
  //     Map<String, Object> homelist = data['orderData'];
  //     print(json.decode(response.body));
  //   } else if (response.statusCode == 401) {
  //     /*final prefs = await SharedPreferences.getInstance();
  //     prefs.remove('token');
  //     prefs.remove('userId');
  //     prefs.remove('name');
  //     prefs.remove('email');
  //     prefs.remove('mobile');
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         PageRouteBuilder(pageBuilder: (BuildContext context,
  //             Animation animation, Animation secondaryAnimation) {
  //           return LoginScreen();
  //         }, transitionsBuilder: (BuildContext context,
  //             Animation<double> animation,
  //             Animation<double> secondaryAnimation,
  //             Widget child) {
  //           return new SlideTransition(
  //             position: new Tween<Offset>(
  //               begin: const Offset(1.0, 0.0),
  //               end: Offset.zero,
  //             ).animate(animation),
  //             child: child,
  //           );
  //         }),
  //             (Route route) => false);
  //     _showSnackBar('Session expired, Login again');*/
  //   } else {
  //     //_showSnackBar('Something went wrong');
  //   }
  // }

  void reload() {
    //getDeliveryList();
  }

  Future<void> createOrder(OrderInfo orderInof) async {
    // await ProgressDialog(context, isDismissible: true).show();
    await CustomLoading().showLoadingDialog(context, true);
    List<Map<String, dynamic>> medicineList1 = [];
    String gender = "M";
    if (orderInof.title.endsWith("Mrs") || orderInof.title.endsWith("Miss") || orderInof.title.endsWith("Ms")) {
      gender = "F";
    }

    String tittle = "";
    if (orderInof.title == "Mr") {
      tittle = "M";
    } else if (orderInof.title == "Miss") {
      tittle = "S";
    } else if (orderInof.title == "Mrs") {
      tittle = "F";
    } else if (orderInof.title == "Ms") {
      tittle = "Q";
    } else if (orderInof.title == "Captain") {
      tittle = "C";
    } else if (orderInof.title == "Dr") {
      tittle = "D";
    } else if (orderInof.title == "Prof") {
      tittle = "P";
    } else if (orderInof.title == "Rev") {
      tittle = "R";
    } else if (orderInof.title == "Mx") {
      tittle = "X";
    }
    String dob = orderInof.userId == 0 ? "${DateFormat('dd/MM/yyyy').format(DateTime.parse(orderInof.dob)) ?? ""}" : orderInof.dob;
    Map<String, dynamic> data = {
      "order_type": "manual",
      "pharmacyId": 0,
      "otherpharmacy": false,
      "pmr_type": "0",
      "endRouteId": widget.isRouteStart != null
          ? widget.isRouteStart
              ? "$endRouteId"
              : "0"
          : "0",
      "startRouteId": widget.isRouteStart != null
          ? widget.isRouteStart
              ? "$startRouteId"
              : "0"
          : "0",
      "nursing_home_id": widget.nursingHomeId,
      "tote_box_id": widget.toteId,
      "start_lat": widget.isRouteStart != null
          ? widget.isRouteStart
              ? "$startLat"
              : ""
          : "0",
      "start_lng": widget.isRouteStart != null
          ? widget.isRouteStart
              ? "$startLng"
              : ""
          : "0",
      "del_subs_id": 0,
      "exemption": 0,
      //_exemptSelected ? selectedExemptionId != null ? selectedExemptionId : 0 : 0,
      "paymentStatus": "",
      "bag_size": "",
      "patient_id": orderInof.userId,
      "pr_id": "",
      "lat": "",
      //na
      "lng": "",
      //na
      "parcel_box_id": widget.parcelBoxId != null ? "${widget.parcelBoxId}" : "0",
      "surgery_name": "",
      "surgery": "",
      "amount": "",
      "email_id": "",
      "mobile_no_2": "",
      "dob": "$dob",
      "nhs_number": orderInof.nhsNumber ?? "",
      "title": tittle ?? "",
      "first_name": orderInof.firstName ?? "",
      "middle_name": orderInof.middleName ?? "",
      "last_name": orderInof.lastName ?? "",
      "address_line_1": orderInof.address ?? "",
      "country_id": "",
      "post_code": orderInof.postCode ?? "",
      "gender": gender,
      "preferred_contact_type": "",
      "delivery_type": "Delivery",
      "driver_id": widget.driverId,
      "delivery_route": widget.routeId,
      "storage_type_cd": "f",
      "storage_type_fr": "f",
      "delivery_status": widget.isRouteStart
          ? "4"
          : widget.toteId == null || widget.toteId.isEmpty
              ? "8"
              : "2",
      "nursing_homes_id": 0,
      "shelf": "",
      "delivery_service": orderInof.default_service,
      "doctor_name": "",
      "doctor_address": "",
      "new_delivery_notes": "",
      "existing_delivery_notes": orderInof != null ? orderInof.default_delivery_note : "",
      "del_charge": "",
      "rx_charge": "",
      "subs_id": "",
      "rx_invoice": "",
      "branch_notes": "",
      "surgery_notes": "",
      "medicine_name": [],
      "prescription_images": [],
      "delivery_date": widget.bulkScanDate,
    };
    logger.i(data);
    logger.i(WebConstant.UUDATE_CUSTOMER_WITH_ORDER);
    _apiCallFram.postDataAPI(WebConstant.UUDATE_CUSTOMER_WITH_ORDER, accessToken, data, context).then((response) async {
      // print(response);
      // await ProgressDialog(context, isDismissible: true).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          print("${response.body}");
          Map<String, Object> data = json.decode(response.body);
          if (data["error"] != null && data["error"] == false) {
            Navigator.of(context).pop();
            if (widget.toteId == null || widget.toteId.isEmpty) {
              widget.callPickedApi.isSelected(true);
            } else
              widget.callApi.isCallApi(true);
          }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // ProgressDialog(context, isDismissible: true).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // print("Exception : $e");
      }
    });
  }

  Future<Map<String, Object>> getDeliveryList(String name) async {
    setState(() => _isLoading = true);
    isApiLoading = false;
    // print('bearer $token');
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
    String firstName = "";
    // String lastName = "";
    // if (name.contains(" ")) {
    //   int idx = name.indexOf(" ");
    //   List parts = [
    //     name.substring(0, idx).trim(),
    //     name.substring(idx + 1).trim()
    //   ];
    //   firstName = parts[0];
    //   lastName = parts[1];
    // } else {
    //   firstName = name;
    // }
    firstName = name;

    Map<String, dynamic> map = {
      //"pharmacyId": int.parse(pharmacyId),
      "userId": int.parse(userId),
      "tokenId": token,
      //"branchId": int.parse(branchId),
      "message": "token register done"
    };
    final j = json.encode(map);
    String url = "";
    url = WebConstant.PATAINET_LIST_URL + firstName;
    print(url);
    final response = await http.get(Uri.parse(url), headers: headers);
    if (mounted) setState(() => _isLoading = false);
    logger.i("aaa" + json.decode(response.body).toString());
    if (response.statusCode == 200) {
      // print(response.body);
      //  Map<String, Object> data = json.decode(json.encode(response.body));

      Map<String, Object> data = json.decode(response.body);
      // print(data);
      //json.decode(response.body);
      if (data.isNotEmpty) {
        List<dynamic> homelist = data['list'];
        if (homelist != null && homelist.isNotEmpty && homelist.length > 0) {
          if (mounted)
            setState(() {
              allList.clear();
              list.clear();
              noData = false;
              allList = homelist;
              list = homelist;
              showList = true;
            });
        } else {
          setState(() {
            showList = false;
            noData = true;
          });
          // _showSnackBar("No Data Found");
        }
      }
    } else if (response.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('userId');
      prefs.remove('name');
      prefs.remove('email');
      prefs.remove('mobile');
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
            return LoginScreen();
          }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }),
          (Route route) => false);
      _showSnackBar('Session expired, Login again');
    } else {
      _showSnackBar('Something went wrong');
    }
  }
}

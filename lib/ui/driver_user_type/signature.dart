// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmdel_business/DB/MyDatabase.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/all_address.dart';
import 'package:pharmdel_business/model/delivery_pojo_model.dart';
import 'package:pharmdel_business/util/flutter_signature_pad.dart';
import 'package:pharmdel_business/util/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../util/CustomDialogBox.dart';
import '../../util/connection_validater.dart';
import '../../util/constants.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../branch_admin_user_type/branch_admin_dashboard.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import 'dashboard_driver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(SignatureApp());
}

class SignatureApp extends StatefulWidget {
  final String name;
  final List deliveryId;
  List<DeliveryPojoModal> outForDelivery;
  final String routeID;
  String customerImage;
  String mobileNo;
  int selectedStatusCode;
  int exemptionId;
  bool isCdDelivery;
  String paymentStatus;
  String addDelCharge;
  int subsId;
  String paymentType;
  String rxInvoice;
  String rxCharge;
  String amount;
  String notPaidReason;
  final String customerRemark;
  final String failedRemark;
  final String remarks;
  final String deliveredTo;
  final String rescheduleDate;
  Function callback;
  List<AnswerModel> arrAns = List();
  Map<String, dynamic> resBody;

  SignatureApp({this.name, this.deliveryId, this.customerImage, this.customerRemark, this.selectedStatusCode, this.isCdDelivery, this.outForDelivery, this.arrAns, this.resBody, this.amount, this.routeID, this.remarks, this.notPaidReason, this.failedRemark, this.rxCharge, this.rxInvoice, this.subsId, this.addDelCharge, this.paymentType, this.mobileNo, this.deliveredTo, this.exemptionId, this.paymentStatus, this.rescheduleDate});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignatureApp> {
  ApiCallFram _apiCallFram = ApiCallFram();
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  var rating = 0;
  int tag = 0;

  final _sign = GlobalKey<SignatureState>();
  String userId, token, userType;

  //ProgressDialog progressDialog;
  //var channel;
  String accessToken;
  String routeId;

  OrderCompleteDataCompanion orderCompleteObj;

  Timer timer1;

  bool isDialogShowing = false;

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }

  void init() async {
    logger.i("widget.paymentType: ${widget.isCdDelivery}");
    if (timer1 != null) timer1.cancel();
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    routeId = prefs.getString(WebConstant.ROUTE_ID) ?? "";
    userType = prefs.getString(WebConstant.USER_TYPE) ?? "";
    setState(() {});
    // if (ProgressDialog(context).isShowing()) {
    //   ProgressDialog(context).hide();
    // }
    await CustomLoading().showLoadingDialog(context, false);
    // await CustomLoading().showLoadingDialog(context, true);
    checkLastTime(context);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // progressDialog = null;
  }

  void _handleRadioValueChange2(int value) {
    setState(() {
      tag = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFffffff);
    var ind = "";

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text('Delivery', style: TextStyle(color: Colors.black)),
        backgroundColor: PrimaryColor,
        leading: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.pop(context, false);
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            )),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 0, top: 20, right: 10, bottom: 0),
              child: Text(
                "Customer Signature",
                style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                    // debugPrint('${sign.points.length} points in the signature');
                  },
                  // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                  strokeWidth: strokeWidth,
                ),
              ),
              color: Colors.black12,
              /* decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blueGrey
                ),*/
            ),
          )),
          // _img.buffer.lengthInBytes == 0
          //     ? Container()
          //     : LimitedBox(
          //     maxHeight: 300.0,
          //     child: Image.memory(_img.buffer.asUint8List())),
          Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // MaterialButton(
                          //     color: Colors.white,
                          //     onPressed: () {
                          //       final sign = _sign.currentState;
                          //       sign.clear();
                          //       setState(() {
                          //         _img = ByteData(0);
                          //       });
                          //       debugPrint("cleared");
                          //     },
                          //     child: Text("Clear"))
                        ],
                      )),
                ],
              ),
            ],
          ),

          // Padding(
          //   padding: const EdgeInsets.only(
          //       left: 10, top: 10, right: 10, bottom: 10),
          //   child: MaterialButton(
          //       color: Colors.blue,
          //       textColor: Colors.white,
          //       onPressed: () async {
          //         final sign = _sign.currentState;
          //         // ignore: unrelated_type_equality_checks
          //
          //
          //         if (sign.points.length != 0) {
          //           // if (rating != 0) {
          //           //retrieve image data, do whatever you want with it (send to server, save locally...)
          //           final image = await sign.getData();
          //           var data = await image.toByteData(
          //               format: ui.ImageByteFormat.png);
          //           sign.clear();
          //           final encoded =
          //           base64.encode(data.buffer.asUint8List());
          //           setState(() {
          //             _img = data;
          //           });
          //
          //           try {
          //
          //             if (widget.resBody != null){
          //               completeCollectionOrder(encoded);
          //             }else{
          //               if (global.locationArray.length > 0){
          //                 LocationData data = global.locationArray.last;
          //                 Map<String,dynamic>prams = {
          //                   "deliveryId":"${widget.deliveryId}",
          //                   "customerRemarks":"${widget.customerRemark ?? ""}",
          //                   "baseSignature": "${encoded ?? ""}",
          //                   "DeliveryStatus" :3,
          //                   "questionAnswerModels" : widget.arrAns,
          //                   "latitude" : data.latitude != null ? data.latitude : 0.00,
          //                   "longitude" : data.longitude != null ? data.longitude : 0.00
          //                 };
          //                 updateSignature(encoded,prams);
          //               }else{
          //                 AlertDialog(
          //                   //title: Text("AlertDialog"),
          //                   content: Text("Do you want continue without location ?"),
          //                   actions: [
          //                     // cancelButton,
          //                     FlatButton(
          //                       child: Text("Continue"),
          //                       onPressed:  () {
          //                         Navigator.pop(context);
          //                       },
          //                     ),
          //                     FlatButton(
          //                       child: Text("Continue"),
          //                       onPressed:  () {
          //                         Map<String,dynamic>prams = {
          //                           "deliveryId":"${widget.deliveryId}",
          //                           "customerRemarks":"${widget.customerRemark ?? ""}",
          //                           "baseSignature": "${encoded ?? ""}",
          //                           "DeliveryStatus" :3,
          //                           "questionAnswerModels" : widget.arrAns,
          //                           "latitude" :  0.00,
          //                           "longitude" : 0.00
          //                         };
          //                         updateSignature(encoded,prams);
          //                       },
          //                     ),
          //
          //                   ],
          //                 );
          //                 Fluttertoast.showToast(msg: "Could not fetch your location Please check.");
          //               }
          //
          //
          //             }
          //
          //           } catch (e) {
          //             _showSnackBar(e.toString());
          //           }
          //           /* } else {
          //                   _showSnackBar('Give Rating');
          //                 }*/
          //         }else {
          //           _showSnackBar('Write Sign');
          //           final sign = _sign.currentState;
          //           sign.clear();
          //           setState(() {
          //             _img = ByteData(0);
          //           });
          //         }
          //       }
          //       ,
          //       child: Text("Submit")),
          // ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                child: MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () async {
                      bool checkInternet = await ConnectionValidator().check();
                      final sign = _sign.currentState;
                      // ignore: unrelated_type_equality_checks

                      if (sign.points.length != 0) {
                        // if (rating != 0) {
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        final image = await sign.getData();
                        var data = await image.toByteData(format: ui.ImageByteFormat.png);
                        sign.clear();
                        final encoded = base64.encode(data.buffer.asUint8List());
                        setState(() {
                          _img = data;
                        });

                        try {
                          if (widget.resBody != null) {
                            // logger.i("test1111");
                            completeCollectionOrder(encoded);
                          } else {
                            // logger.i("test22222");
                            //if (global.locationArray.length > 0){
                            // LocationData data = global.locationArray.last;
                            // Map<String, dynamic> prams = {
                            //   "remarks": "${widget.remarks}",
                            //   "deliveredTo": "${widget.deliveredTo}",
                            //   "deliveryId": widget.deliveryId,
                            //   "routeId": "${widget.routeID ?? ""}",
                            //   "customerRemarks" : "${widget.customerRemark ?? ""}",
                            //   "baseSignature": "${encoded ?? ""}",
                            //   "DeliveryStatus": widget.selectedStatusCode,
                            //   "questionAnswerModels": "", //widget.arrAns
                            //   "latitude": 0.00,
                            //   "longitude": 0.00
                            // };
                            // updateSignature(encoded, prams);
                            if (userId == null || userId.isEmpty) {
                              final prefs = await SharedPreferences.getInstance();
                              userId = prefs.getString('userId') ?? "";
                            }
                            if (userId != null && userId.isNotEmpty && userId != "0") {
                              orderCompleteObj = OrderCompleteDataCompanion.insert(
                                  remarks: "${widget.remarks ?? ""}",
                                  notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty ? widget.notPaidReason : "",
                                  addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                                  subsId: widget.subsId != null ? widget.subsId : 0,
                                  rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                                  rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                                  paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                                  exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                                  paymentStatus: "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                                  userId: int.tryParse(userId.toString()),
                                  baseImage: "${widget.customerImage ?? ""}",
                                  deliveredTo: "${widget.deliveredTo}",
                                  deliveryId: widget.deliveryId.join(","),
                                  routeId: "${widget.routeID ?? ""}",
                                  customerRemarks: "${widget.customerRemark ?? ""}",
                                  baseSignature: "${encoded ?? ""}",
                                  deliveryStatus: widget.selectedStatusCode != null ? widget.selectedStatusCode : 0,
                                  questionAnswerModels: "",
                                  reschudleDate: "${widget.rescheduleDate ?? ""}",
                                  param1: "${widget.mobileNo ?? ""}",
                                  param2: "${widget.failedRemark ?? ""}",
                                  param5: "",
                                  param6: "",
                                  param7: "",
                                  param4: "",
                                  param8: "",
                                  param3: "",
                                  param9: "",
                                  param10: "",
                                  date_Time: "${DateTime.now().millisecondsSinceEpoch}",
                                  latitude: 0.0,
                                  longitude: 0.0);
                              logger.i(orderCompleteObj);

                              String status = "Completed";
                              if (widget.selectedStatusCode == 5) {
                                status = "Completed";
                              } else if (widget.selectedStatusCode == 6) {
                                status = "Failed";
                              }
                              await MyDatabase().insertOrderCompleteData(orderCompleteObj);
                              await Future.forEach(widget.deliveryId, (element) async {
                                await MyDatabase().updateDeliveryStatus(int.tryParse(element.toString()), status, widget.selectedStatusCode);
                              });

                              if (!checkInternet) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => DashboardDriver(1),
                                    ),
                                    ModalRoute.withName('/signature'));
                              } else {
                                if (widget.outForDelivery != null) {
                                  if (widget.outForDelivery.length - 1 != 1)
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => DashboardDriver(1),
                                        ),
                                        ModalRoute.withName('/signature'));
                                  if (widget.outForDelivery.length - 1 == 1) {
                                    logger.i(widget.outForDelivery.length - 1);
                                    checkOfflineDeliveryAvailable();
                                  }
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => DashboardDriver(1),
                                      ),
                                      ModalRoute.withName('/signature'));
                                }
                              }
                            } else {
                              logOut();
                            }
                          }
                        } catch (e, stackTrace) {
                          SentryExemption.sentryExemption(e, stackTrace);
                          _showSnackBar(e.toString());
                        }
                        /* } else {
                                _showSnackBar('Give Rating');
                              }*/
                      } else {
                        _showSnackBar('Write Sign');
                        final sign = _sign.currentState;
                        sign.clear();
                        setState(() {
                          _img = ByteData(0);
                        });
                      }
                    },
                    child: Text("Save")),
              ),
              Spacer(),
              if (!widget.isCdDelivery)
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                  child: MaterialButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        bool checkInternet = await ConnectionValidator().check();
                        final sign = _sign.currentState;
                        // ignore: unrelated_type_equality_checks

                        // if (sign.points.length != 0) {
                        // if (rating != 0) {
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        // final image = await sign.getData();
                        // var data = await image.toByteData(
                        //     format: ui.ImageByteFormat.png);
                        // sign.clear();
                        // final encoded =
                        // base64.encode(data.buffer.asUint8List());
                        // setState(() {
                        //   _img = data;
                        // });

                        try {
                          if (widget.resBody != null) {
                            // logger.i("test1111");
                            completeCollectionOrder("");
                          } else {
                            // logger.i("test22222");
                            //if (global.locationArray.length > 0){
                            // LocationData data = global.locationArray.last;
                            // Map<String, dynamic> prams = {
                            //   "remarks": "${widget.remarks}",
                            //   "deliveredTo": "${widget.deliveredTo}",
                            //   "deliveryId": widget.deliveryId,
                            //   "routeId": "${widget.routeID ?? ""}",
                            //   "customerRemarks" : "${widget.customerRemark ?? ""}",
                            //   "baseSignature": "",
                            //   "DeliveryStatus": widget.selectedStatusCode,
                            //   "questionAnswerModels": "", //widget.arrAns
                            //   "latitude": 0.00,
                            //   "longitude": 0.00
                            // };
                            // updateSignature("", prams);

                            if (userId == null || userId.isEmpty) {
                              final prefs = await SharedPreferences.getInstance();
                              userId = prefs.getString('userId') ?? "";
                            }
                            if (userId != null && userId.isNotEmpty && userId != "0") {
                              orderCompleteObj = OrderCompleteDataCompanion.insert(
                                  remarks: "${widget.remarks ?? ""}",
                                  notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty ? widget.notPaidReason : "",
                                  addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                                  subsId: widget.subsId != null ? widget.subsId : 0,
                                  rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                                  rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                                  paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                                  exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                                  paymentStatus: "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                                  userId: int.tryParse(userId.toString()),
                                  baseImage: "${widget.customerImage ?? ""}",
                                  deliveredTo: "${widget.deliveredTo}",
                                  deliveryId: widget.deliveryId.join(","),
                                  routeId: "${widget.routeID ?? ""}",
                                  customerRemarks: "${widget.customerRemark ?? ""}",
                                  baseSignature: "",
                                  deliveryStatus: widget.selectedStatusCode,
                                  questionAnswerModels: "",
                                  reschudleDate: "${widget.rescheduleDate ?? ""}",
                                  param1: "${widget.mobileNo ?? ""}",
                                  param2: "${widget.failedRemark ?? ""}",
                                  param5: "",
                                  param6: "",
                                  param8: "",
                                  param7: "",
                                  param4: "",
                                  param3: "",
                                  param9: "",
                                  param10: "",
                                  date_Time: "${DateTime.now().millisecondsSinceEpoch}",
                                  latitude: 0.0,
                                  longitude: 0.0);

                              logger.i(orderCompleteObj);

                              String status = "Completed";
                              if (widget.selectedStatusCode == 5) {
                                status = "Completed";
                              } else if (widget.selectedStatusCode == 6) {
                                status = "Failed";
                              }

                              await MyDatabase().insertOrderCompleteData(orderCompleteObj);
                              await Future.forEach(widget.deliveryId, (element) async {
                                await MyDatabase().updateDeliveryStatus(int.tryParse(element.toString()), status, widget.selectedStatusCode);
                              });

                              if (!checkInternet)
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => DashboardDriver(1),
                                    ),
                                    ModalRoute.withName('/signature'));
                            } else {
                              logOut();
                            }
                          }
                        } catch (e, stackTrace) {
                          SentryExemption.sentryExemption(e, stackTrace);
                          logger.i(e);
                          _showSnackBar(e.toString());
                        }
                        /* } else {
                                _showSnackBar('Give Rating');
                              }*/
                        // } else {
                        //   _showSnackBar('Write Sign');
                        //   final sign = _sign.currentState;
                        //   sign.clear();
                        //   setState(() {
                        //     _img = ByteData(0);
                        //   });
                        // }
                        if (checkInternet) {
                          if (widget.outForDelivery != null) {
                            if (widget.outForDelivery.length - 1 != 1)
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => DashboardDriver(1),
                                  ),
                                  ModalRoute.withName('/signature'));
                            if (widget.outForDelivery.length - 1 == 1) checkOfflineDeliveryAvailable();
                          } else {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => DashboardDriver(1),
                                ),
                                ModalRoute.withName('/signature'));
                          }
                        }
                      },
                      child: Text("Skip")),
                ),
              if (widget.isCdDelivery) Text("CD sign mandatory"),
              Spacer(),
              MaterialButton(
                  color: Colors.white,
                  onPressed: () {
                    final sign = _sign.currentState;
                    sign.clear();
                    setState(() {
                      _img = ByteData(0);
                    });
                    // debugPrint("cleared");
                  },
                  child: Text("Clear")),
              SizedBox(
                width: 10.0,
              )
              //  Spacer(),
              // if (userType != 'Pharmacy' &&  userType != "Pharmacy Staff")
              //   Padding(
              //     padding: const EdgeInsets.only(
              //         left: 10, top: 10, right: 10, bottom: 10),
              //     child: MaterialButton(
              //         color: Colors.blue,
              //         textColor: Colors.white,
              //         onPressed: () async {
              //           final sign = _sign.currentState;
              //           // ignore: unrelated_type_equality_checks
              //
              //           if (sign.points.length != 0) {
              //             // if (rating != 0) {
              //             //retrieve image data, do whatever you want with it (send to server, save locally...)
              //             final image = await sign.getData();
              //             var data = await image.toByteData(
              //                 format: ui.ImageByteFormat.png);
              //             sign.clear();
              //             final encoded =
              //                 base64.encode(data.buffer.asUint8List());
              //             setState(() {
              //               _img = data;
              //             });
              //
              //             try {
              //               Map<String, dynamic> prams = {
              //                 "remarks": "${widget.remarks}",
              //                 "deliveredTo": "${widget.deliveredTo}",
              //                 "deliveryId": widget.deliveryId,
              //                 "customerRemarks":
              //                     "${widget.customerRemark ?? ""}",
              //                 "baseSignature": "${encoded ?? ""}",
              //                 "DeliveryStatus": 5,
              //                 "questionAnswerModels": widget.arrAns,
              //                 "routeId": widget.routeID,
              //               };
              //
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (BuildContext context) => DropPin(
              //                         prams,
              //                         widget.customerImage,
              //                         encoded,
              //                         widget.resBody),
              //                   ));
              //             } catch (e) {
              //               _showSnackBar(e.toString());
              //             }
              //             /* } else {
              //                   _showSnackBar('Give Rating');
              //                 }*/
              //           } else {
              //             _showSnackBar('Write Sign');
              //             final sign = _sign.currentState;
              //             sign.clear();
              //             setState(() {
              //               _img = ByteData(0);
              //             });
              //           }
              //         },
              //         child: Text("Drop Pin")),
              //   )
            ],
          )
        ],
      )),
    );
  }

  // Future<void> updateSignature(String encoded, Map<String, dynamic> prams) async {
  //   // print(prams);
  //
  //  await ProgressDialog(context, isDismissible: false).show();
  // logger.i(WebConstant.DELIVERY_SIGNATURE_UPLOAD_URL);
  // logger.i(prams);
  //   _apiCallFram
  //       .postFilesWithDataMaps(WebConstant.DELIVERY_SIGNATURE_UPLOAD_URL, token,
  //           prams, widget.customerImage, context)
  //       .then((response) async {
  //     ProgressDialog(context,isDismissible: false).hide();
  //     if(response != null && response.body != null && response.body == "Unauthenticated"){
  //       Fluttertoast.showToast(msg: "Authentication Failed. Login again");
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.remove('token');
  //       prefs.remove('userId');
  //       prefs.remove('name');
  //       prefs.remove('email');
  //       prefs.remove('mobile');
  //       prefs.remove('route_list');
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (BuildContext context) => LoginScreen(),
  //           ),
  //           ModalRoute.withName('/login_screen'));
  //       return;
  //     }
  //     try {
  //       if (response != null) {
  //         var data = json.decode(response.body);
  //         logger.i("response: ${response.body}");
  //         if (data["status"] == true || data["status"] == 'true') {
  //           isDelivery = true;
  //
  //           Fluttertoast.showToast(msg: "Successfully Uploaded");
  //
  //           Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (BuildContext context) => DashboardDriver(),
  //               ),
  //               ModalRoute.withName('/signature'));
  //         } else {
  //           ProgressDialog(context).hide();
  //           ToastUtils.showCustomToast(
  //               context, "${data["message"]}, Please try again !");
  //         }
  //       }
  //     } catch (e) {
  //       logger.i(e.toString());
  //       ProgressDialog(context).hide();
  //     }
  //     ProgressDialog(context).hide();
  //   }, onError: (error, stackTrace) {
  //     ProgressDialog(context).hide();
  //     ProgressDialog(context).hide();
  //     // logger.i("error : " + error.toString());
  //     ToastUtils.showCustomToast(context, "Please try again !");
  //     //   isDelivery = true;
  //     //
  //     //   Navigator.pushAndRemoveUntil(
  //     //       context,
  //     //       MaterialPageRoute(
  //     //         builder: (BuildContext context) => DashboardDriver(),
  //     //       ),
  //     //       ModalRoute.withName('/signature'));
  //     //
  //     //
  //   });
  // }

  Future<void> checkOfflineDeliveryAvailable() async {
    var completeAllList = await MyDatabase().getAllOrderCompleteData();
    if (completeAllList != null && completeAllList.isNotEmpty) {
      BuildContext dialogContext;
      isDialogShowing = true;
      await showDialog<ConfirmAction>(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            dialogContext = context;
            dialogDissmissTimer(dialogContext);
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: CustomDialogBox(
                // img: Image.asset("assets/delivery_truck.png"),
                icon: Icon(Icons.timer),
                title: "Alert...",
                descriptions: Constants.uploading_msg1,
              ),
            );
          });
    }
  }

  Future<void> dialogDissmissTimer(BuildContext dialogContext) async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      timer1 = timer;
      logger.i('Dashboard Background Service');
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      if (completeAllList == null || completeAllList.isEmpty) {
        timer1.cancel();
        if (isDialogShowing) Navigator.pop(dialogContext);
        if (widget.outForDelivery.length - 1 == 1) endRoute();
        isDialogShowing = false;
      }
    });
  }

  Future<void> endRoute() async {
    // await ProgressDialog(context, isDismissible: false).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    String url = "";
    if (userType == 'Pharmacy' || userType == "Pharmacy Staff") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardDriver(1),
          ),
          ModalRoute.withName('/signature'));
      return;
    } else {
      url = "${WebConstant.END_ROUTE_BY_DRIVER}?routeId=$routeId";

      _apiCallFram.getDataRequestAPI(url, token, context).then((response) async {
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
        try {
          if (response != null) {
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
            } else if (response.body.toString() == "true") {
              SharedPreferences.getInstance().then((value) {
                value.setBool(WebConstant.IS_ROUTE_START, false);
              });
              deliveryTime = null;
              if (stopWatchTimer != null) {
                logger.i("stopwatch disposed");
                stopWatchTimer.dispose();
                stopWatchTimer = null;
              }
              autoEndRoutePopUp();
            }
            /* try{
              global.streamController.add(7);
            }catch(e){
              print(e.toString());
            }

            if (Navigator.canPop(context)) {
              //Navigator.of(context).pop(true);
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
            global.channel.sink.close(*/ //);

          }
        } catch (e, stackTrace) {
          SentryExemption.sentryExemption(e, stackTrace);
          String jsonUser = jsonEncode(e);
          Fluttertoast.showToast(msg: jsonUser);
          // ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
          // await CustomLoading().showLoadingDialog(context, true);
        }
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
      }).catchError((onError) async {
        String jsonUser = jsonEncode(onError);
        Fluttertoast.showToast(msg: jsonUser);
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
      });
    }
  }

  void autoEndRoutePopUp() {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/delivery_truck.png"),
            title: "Alert...",
            btnDone: "Okay",
            onClicked: onClick,
            descriptions: "Your route has been ended",
          );
        });
  }

  Future<void> completeCollectionOrder(String encoded) async {
    widget.resBody["baseSignature"] = "${encoded ?? ""}";
    String url = "";
    if (userType == 'Pharmacy' || userType == "Pharmacy Staff") {
      url = WebConstant.PHARMACY_STATUS_UPDATE_URL;
    } else {
      url = WebConstant.DELIVERY_STATUS_UPDATE_URL;
    }
    logger.i(url);
    // await ProgressDialog(
    //   context,
    //   isDismissible: false,
    // ).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    //final j = json.encode(widget.resBody);
    // debugPrint(url);
    // print(widget.resBody);
    _apiCallFram.postDataAPI(url, token, widget.resBody, context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      try {
        if (response != null) {
          var data = json.decode(response.body);
          // logger.i("response: ${response.body}");
          if (data["status"] == true) {
            Fluttertoast.showToast(msg: "Successfully Uploaded");
            if (Navigator.canPop(context)) {
              // logger.i("tesstttt");
              //Navigator.of(context).pop(true);
              Navigator.pop(context, true);
            } else {
              // logger.i("tesstttt1");
              SystemNavigator.pop();
            }

            // global.channel.sink.close();

          } else {
            // logger.i("tesstttt");
            //ProgressDialog(context).hide();
            ToastUtils.showCustomToast(context, "${data["message"]}, Please try again !");
          }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
    });
  }

  Future<void> logOut() async {
    Fluttertoast.showToast(msg: "There was a problem with the system, please login again");
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
  }

  void onClick(bool value) {
    if (value)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardDriver(1),
          ),
          ModalRoute.withName('/signature'));
  }
}

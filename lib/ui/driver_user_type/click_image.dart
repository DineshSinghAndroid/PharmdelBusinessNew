// // @dart=2.9
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../main.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pharmdel_business/util/custom_camera_screen.dart';
// import 'package:pharmdel_business/util/log_print.dart';
// // import 'package:progress_dialog/progress_dialog.dart';
// import 'package:pharmdel_business/data/api_call_fram.dart';
// import 'package:pharmdel_business/data/web_constent.dart';
// import 'package:pharmdel_business/model/all_address.dart';
// import 'package:pharmdel_business/model/delivery_pojo_model.dart';
// import 'package:pharmdel_business/model/order_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../util/custom_loading.dart';
// import '../../util/sentryExeptionHendler.dart';
// import '../splash_screen.dart';
// import 'signature.dart';
//
// class ClickImage extends StatefulWidget{
//   OrderModal delivery;
//   int selectedStatusCode;
//   final String remarks;
//   final String deliveredTo;
//   List orderid;
//   List<DeliveryPojoModal> outForDelivery;
//   String routeId;
//   String rescheduleDate;
//   String failedRemark;
//   String paymentStatus;
//   int exemptionId;
//   String mobileNo;
//   String addDelCharge;
//   int subsId;
//   String paymentType;
//   String rxInvoice;
//   String rxCharge;
//   String amount;
//   bool isCdDelivery;
//   String notPaidReason;
//   ClickImage({this.delivery,this.outForDelivery, this.isCdDelivery, this.selectedStatusCode, this.deliveredTo,this.notPaidReason,this.subsId,this.rxInvoice,this.rxCharge, this.remarks,this.orderid,this.addDelCharge,this.routeId,this.rescheduleDate,this.mobileNo,this.failedRemark,this.paymentStatus,this.exemptionId,this.paymentType,this.amount});
//
//   StateClickImage createState() => StateClickImage();
// }
//
// class StateClickImage extends State<ClickImage>{
//   ApiCallFram _apiCallFram = ApiCallFram();
//   String accessToken = "";
//   File _image;
//   final picker = ImagePicker();
//   TextEditingController remarkController = TextEditingController();
//   bool isEmpty = false;
//
//   String base64Image;
//   @override
//   void initState() {
//     super.initState();
//     logger.i("widget.paymentType: ${widget.paymentType}");
//     SharedPreferences.getInstance().then((prefs){
//       accessToken = prefs.getString(WebConstant.ACCESS_TOKEN);
//     });
//     // if (ProgressDialog(context).isShowing()){
//     //   ProgressDialog(context).hide();
//     // }
//     CustomLoading().showLoadingDialog(context, false);
//     // await CustomLoading().showLoadingDialog(context, true);
//     checkLastTime(context);
//   }
//
//   void _showSnackBar(String text) {
//     Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const PrimaryColor = const Color(0xFFffffff);
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.5,
//         centerTitle: true,
//         title: const Text('Delivery', style: TextStyle(color: Colors.black)),
//         backgroundColor: PrimaryColor,
//         leading: new Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//                // Navigator.pop(context, false);
//               },
//               child: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.arrow_back,color: Colors.black,),
//               ),
//             )),
//       ),
//       body:  Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 Padding(
//                     padding: const EdgeInsets.only(
//                         left: 0, top: 20, right: 10, bottom: 0),
//                     child: Text(
//                       "Delivery Image",
//                       style: new TextStyle(
//                         fontSize: 17.0,
//                         color: Colors.black,
//                       ),
//                     )),
//               ],
//             ),
//
//             Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 10, top: 10, right: 10, bottom: 0),
//                   child: Container(
//                     height: 300,
//                     width: MediaQuery.of(context).size.width,
//                     child: Stack(
//                       children: <Widget>[
//                         _image != null?
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: Image.file(
//                             _image,
//                             fit: BoxFit.fill,
//                           ),
//                         ): Container(height: 0, width: 0,),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: SizedBox(
//                             height: 45,
//                             child: new InkWell(
//                               onTap: (){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen())).then((value) async {
//                                   if(value != null){
//                                     setState(() {
//                                       _image = File(value);
//                                     });
//                                     final imageData = await _image.readAsBytes();
//                                     base64Image = base64Encode(imageData);
//                                   }
//                                 });
//                               },
//                               child: Icon(Icons.camera_alt,color: Colors.blue,size: 40,),
//                             ),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     color: Colors.black12,
//                     /* decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.blueGrey
//                   ),*/
//                   ),
//                 )),
//
//             // Padding(
//             //   padding: const EdgeInsets.all(0),
//             //   child: new Card(
//             //       child: Padding(
//             //         padding: const EdgeInsets.only(left: 10, right: 10),
//             //         child: new TextField(
//             //           controller: remarkController,
//             //           textInputAction: TextInputAction.newline,
//             //           keyboardType: TextInputType.text,
//             //           autofocus: false,
//             //           // minLines: 1,
//             //           // maxLines: null,
//             //           decoration: new InputDecoration(
//             //             labelText: "Delivery Remark",
//             //             errorText: isEmpty ? "Can't empty" : null
//             //           ),
//             //         ),
//             //       )),
//             // ),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//
//
//                 Flexible(
//                   fit: FlexFit.tight,
//                   child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10, right: 10, top: 25, bottom: 10),
//                       child: new SizedBox(
//                         height: 45,
//                         child: new ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:_image != null ? Colors.blue : Colors.grey,
//                           ),
//                           onPressed: (){
//                             if(_image != null){
//                               onSigneture();
//                             }
//                             else{
//                               _showSnackBar('Please Capture Image');
//                             }
//                           },
//                           child: new Text("CONTINUE",style: TextStyle(color:  Colors.white),),
//                         ),
//                       )),
//                 ),
//                 Flexible(
//                   fit: FlexFit.tight,
//                   child: Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10, right: 10, top: 25, bottom: 10),
//                       child: new SizedBox(
//                         height: 45,
//                         child: new ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green
//                           ),
//                           onPressed: (){
//                             base64Image = "";
//                             logger.i(base64Image);
//                             setState(() {});
//                             onSigneture();
//                           },
//                           child: new Text("SKIP",style: TextStyle(color:  Colors.white)),
//                         ),
//                       )),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future imgFromCamera() async {
//
//     //setState(() {
//       try {
//         final pickedFile = await picker.getImage(imageQuality: 30,source: ImageSource.camera,maxHeight: 500,maxWidth: 500);
//         if (pickedFile != null) {
//           setState(() {
//             _image = File(pickedFile.path);
//           });
//           final imageData = await _image.readAsBytes();
//           base64Image = base64Encode(imageData);
//
//         } else {
//           // print('No image selected.');
//         }
//       }catch(e,stackTrace){
//         SentryExemption.sentryExemption(e, stackTrace);
//         //_showSnackBar("Status Successfully Updated");
//       }
//
//
//    // });
//
//   }
//
//   void onSigneture() {
//     print(widget.selectedStatusCode);
//     try {
//       if (widget.selectedStatusCode == 5 || widget.selectedStatusCode == 6) {
//         // getAllQuestion(); // Question Removed
//
//         //if(remarkController.text.isNotEmpty) {
//
//           Route route = MaterialPageRoute(
//               builder: (context) =>
//                   SignatureApp(
//                     remarks: widget.remarks,
//                     isCdDelivery: widget.isCdDelivery,
//                     outForDelivery: widget.outForDelivery,
//                     notPaidReason: widget.notPaidReason,
//                     exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
//                     paymentStatus: widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : "",
//                     deliveredTo: widget.deliveredTo,
//                     selectedStatusCode: widget.selectedStatusCode,
//                     mobileNo: widget.mobileNo ?? "",
//                     rxInvoice: widget.rxInvoice ?? "",
//                     rxCharge: widget.rxCharge ?? "",
//                     subsId: widget.subsId ?? 0,
//                     addDelCharge: widget.addDelCharge ?? "",
//                     // name: "${widget.delivery.customer.fullName ?? ""}",
//                     paymentType: widget.paymentType ?? "",
//                     amount: widget.amount ?? "",
//                     failedRemark: widget.failedRemark ?? "",
//                     name: "",
//                     deliveryId: widget.orderid,
//                     rescheduleDate: widget.rescheduleDate ?? "",
//                     customerImage: base64Image != null && base64Image != "" ? base64Image : "",
//                     customerRemark: widget.remarks,
//                     arrAns: [],
//                     routeID: widget.delivery != null ? widget.delivery.routeId.toString()  : widget.routeId ?? "",)
//           );
//           Navigator.of(context).pop();
//           Navigator.push(context, route);
//
//       } else {
//         //  _asyncConfirmDialog("Status Successfully Updated");
//       }
//
//       //widget.function();
//     } catch (e,stackTrace) {
//       SentryExemption.sentryExemption(e, stackTrace);
//       // print(e);
//     }
//   }
//
// }

// @dart=2.9
import 'dart:async';
import 'dart:convert';

// import 'package:location/location.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/delivery_pojo_model.dart';
import 'package:pharmdel_business/model/order_model.dart';
import 'package:pharmdel_business/util/custom_camera_screen.dart';
import 'package:pharmdel_business/util/custom_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DB/MyDatabase.dart';
import '../../main.dart';
import '../../util/CustomDialogBox.dart';
import '../../util/connection_validater.dart';
import '../../util/constants.dart';
import '../../util/flutter_signature_pad.dart';
import '../../util/sentryExeptionHendler.dart';
import '../branch_admin_user_type/branch_admin_dashboard.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import 'dashboard_driver.dart';
import 'signature.dart';

class ClickImage extends StatefulWidget {
  OrderModal delivery;
  int selectedStatusCode;
  final String remarks;
  final String deliveredTo;
  List orderid;
  List<DeliveryPojoModal> outForDelivery;
  String routeId;
  String rescheduleDate;
  String failedRemark;
  String paymentStatus;
  int exemptionId;
  String mobileNo;
  String addDelCharge;
  int subsId;
  String paymentType;
  String rxInvoice;
  String rxCharge;
  String amount;
  bool isCdDelivery;
  String notPaidReason;

  ClickImage(
      {this.delivery,
      this.outForDelivery,
      this.isCdDelivery,
      this.selectedStatusCode,
      this.deliveredTo,
      this.notPaidReason,
      this.subsId,
      this.rxInvoice,
      this.rxCharge,
      this.remarks,
      this.orderid,
      this.addDelCharge,
      this.routeId,
      this.rescheduleDate,
      this.mobileNo,
      this.failedRemark,
      this.paymentStatus,
      this.exemptionId,
      this.paymentType,
      this.amount});

  StateClickImage createState() => StateClickImage();
}

class StateClickImage extends State<ClickImage> {
  ApiCallFram _apiCallFram = ApiCallFram();
  String accessToken = "";
  var color = Colors.red;
  File _image;
  final picker = ImagePicker();
  TextEditingController remarkController = TextEditingController();
  bool isEmpty = false;
  String userId, userType, routeId;
  ByteData _img = ByteData(0);
  var strokeWidth = 5.0;
  var rating = 0;
  int tag = 0;
  Timer timer1;
  OrderCompleteDataCompanion orderCompleteObj;
  bool isDialogShowing = false;
  final _sign = GlobalKey<SignatureState>();
  String base64Image;
  double lat = 0.0;
  double lng = 0.0;

  Future getLocationByClick() async {
    LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) async {
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
      lat = position.latitude;
      lng = position.longitude;

      print(lat.toString() + lng.toString() + "Calling locaiton class");
    });
    // logger.i("USER CURRENT LOCATION IS IN EDIT PROFILE IS  " +lat.toString() + lng.toString());
  }

  @override
  void initState() {
    super.initState();

    logger.i("widget.paymentTypewidget.paymentType: ${widget.paymentType}");
    SharedPreferences.getInstance().then((prefs) {
      accessToken = prefs.getString(WebConstant.ACCESS_TOKEN);
      init();
    });
    CustomLoading().showLoadingDialog(context, false);
    checkLastTime(context);
  }

  void init() async {
    logger.i("widget.paymentType: ${widget.isCdDelivery}");
    if (timer1 != null) timer1.cancel();
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    routeId = prefs.getString(WebConstant.ROUTE_ID) ?? "";
    userType = prefs.getString(WebConstant.USER_TYPE) ?? "";
    setState(() {});
    await CustomLoading().showLoadingDialog(context, false);
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFffffff);
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Column(
                        children: [
                          Card(
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            child: Container(
                              height: widget.isCdDelivery || widget.selectedStatusCode == 5 ? 250 : 500,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
                                  _image != null
                                      ? Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: Image.file(
                                            _image,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: ButtonTheme(
                                        height: 45,
                                        child: new InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => CameraScreen()))
                                                .then((value) async {
                                              if (value != null) {
                                                setState(() {
                                                  _image = File(value);
                                                });
                                                final imageData = await _image.readAsBytes();
                                                base64Image = base64Encode(imageData);
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                      color: Colors.white,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                                        child: Text(
                                          "Image (Optional)",
                                          style: new TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.black,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              /* decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: Colors.blueGrey
                           ),*/
                            ),
                          ),
                          Visibility(
                            visible: widget.isCdDelivery || widget.selectedStatusCode == 5 ? true : false,
                            child: Card(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              child: Container(
                                height: 400,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.black12,
                                ),
                                child: Stack(
                                  children: [
                                    Signature(
                                      color: color,
                                      key: _sign,
                                      onSign: () {
                                        final sign = _sign.currentState;
                                        // debugPrint('${sign.points.length} points in the signature');
                                      },
                                      // backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                                      strokeWidth: strokeWidth,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                                          child: Text(
                                            "Customer Signature ",
                                            style: new TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.black,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.isCdDelivery)
                        MaterialButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () async {
                              bool checkInternet = await ConnectionValidator().check();
                              final sign = _sign.currentState;

                              //old code before removing sign functionality on faild delivery status
                              // ignore: unrelated_type_equality_checks

                              // if (sign.points.length != 0 ) {
                              //   final image = await sign.getData();
                              //   var data = await image.toByteData(
                              //       format: ui.ImageByteFormat.png);
                              //   sign.clear();
                              //   final encoded =
                              //   base64.encode(data.buffer.asUint8List());
                              //   setState(() {
                              //     _img = data;
                              //   }
                              //
                              //
                              //   );
                              //
                              //   try {
                              //     if (userId == null || userId.isEmpty) {
                              //       final prefs =
                              //       await SharedPreferences.getInstance();
                              //       userId = prefs.getString('userId') ?? "";
                              //     }
                              //     if (userId != null &&
                              //         userId.isNotEmpty &&
                              //         userId != "0") {
                              //
                              //       await getLocationByClick();
                              //
                              //       // logger.i("USER CURRENT LOCATION IS in OrderComplete Database is   " +lat.toString()+"  " + lng.toString());
                              //
                              //       orderCompleteObj = OrderCompleteDataCompanion.insert(
                              //           remarks: "${widget.remarks ?? ""}",
                              //           notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty ? widget.notPaidReason : "",
                              //           addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                              //           subsId: widget.subsId != null ? widget.subsId : 0,
                              //           rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                              //           rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                              //           paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                              //           exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                              //           paymentStatus: "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                              //           userId: int.tryParse(userId.toString()),
                              //           baseImage: base64Image != null && base64Image != "" ? base64Image : "",
                              //           deliveredTo: "${widget.deliveredTo}",
                              //           deliveryId: widget.orderid.join(","),
                              //           routeId: "${widget.routeId ?? ""}",
                              //           customerRemarks: "${widget.remarks ?? ""}",
                              //           baseSignature: "${encoded ?? ""}",
                              //           deliveryStatus:
                              //           widget.selectedStatusCode != null
                              //               ? widget.selectedStatusCode
                              //               : 0,
                              //           questionAnswerModels: "",
                              //           reschudleDate:
                              //           "${widget.rescheduleDate ?? ""}",
                              //           param1: "${widget.mobileNo ?? ""}",
                              //           param2: "${widget.failedRemark ?? ""}",
                              //           param5: "",
                              //           param6: "",
                              //           param7: "",
                              //           param4: "",
                              //           param8: "",
                              //           param3: "",
                              //           param9: "$lat",
                              //           param10: "$lng",
                              //           date_Time:
                              //           "${DateTime.now().millisecondsSinceEpoch}",
                              //           latitude: lat,
                              //           longitude: lng);
                              //       // logger.i(orderCompleteObj);
                              //       getLocationByClick();
                              //       logger.i("USER CURRENT LOCATION IS in OrderComplete Database is   " +lat.toString()+"  " + lng.toString());
                              //       String status = "Completed";
                              //       if (widget.selectedStatusCode == 5) {
                              //         status = "Completed";
                              //       } else if (widget.selectedStatusCode == 6) {
                              //         status = "Failed";
                              //       }
                              //       await MyDatabase()
                              //           .insertOrderCompleteData(orderCompleteObj);
                              //       await Future.forEach(widget.orderid,
                              //               (element) async {
                              //             await MyDatabase().updateDeliveryStatus(
                              //                 int.tryParse(element.toString ()),
                              //                 status,
                              //                 widget.selectedStatusCode);
                              //           });
                              //
                              //       if(!checkInternet) {
                              //         Navigator.pushAndRemoveUntil(
                              //             context,
                              //             MaterialPageRoute(
                              //               builder: (BuildContext context) =>
                              //                   DashboardDriver(1),
                              //             ),
                              //             ModalRoute.withName('/signature'));
                              //       }else {
                              //         if (widget.outForDelivery != null) {
                              //           if (widget.outForDelivery.length - 1 !=
                              //               1)
                              //             Navigator.pushAndRemoveUntil(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                   builder: (
                              //                       BuildContext context) =>
                              //                       DashboardDriver(1),
                              //                 ),
                              //                 ModalRoute.withName(
                              //                     '/signature'));
                              //           if (widget.outForDelivery.length - 1 ==
                              //               1) {
                              //             logger.i(
                              //                 widget.outForDelivery.length - 1);
                              //             checkOfflineDeliveryAvailable();
                              //           }
                              //         }else{
                              //           Navigator.pushAndRemoveUntil(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (BuildContext context) =>
                              //                     DashboardDriver(1),
                              //               ),
                              //               ModalRoute.withName('/signature'));
                              //         }
                              //       }
                              //     } else {
                              //       logOut();
                              //     }
                              //   } catch (e,stackTrace) {
                              //     SentryExemption.sentryExemption(e, stackTrace);
                              //     _showSnackBar(e.toString());
                              //   }
                              // } else {
                              //   _showSnackBar('Write Sign');
                              //   final sign = _sign.currentState;
                              //   sign.clear();
                              //   setState(() {
                              //     _img = ByteData(0);
                              //   });
                              // }

                              if (widget.selectedStatusCode == 5) {
                                if (sign.points.length != 0) {
                                  final image = await sign.getData();
                                  var data = await image.toByteData(format: ui.ImageByteFormat.png);
                                  sign.clear();
                                  final encoded = base64.encode(data.buffer.asUint8List());
                                  setState(() {
                                    _img = data;
                                  });
                                  try {
                                    if (userId == null || userId.isEmpty) {
                                      final prefs = await SharedPreferences.getInstance();
                                      userId = prefs.getString('userId') ?? "";
                                    }
                                    if (userId != null && userId.isNotEmpty && userId != "0") {
                                      await getLocationByClick();

                                      // logger.i("USER CURRENT LOCATION IS in OrderComplete Database is   " +lat.toString()+"  " + lng.toString());

                                      orderCompleteObj = OrderCompleteDataCompanion.insert(
                                          remarks: "${widget.remarks ?? ""}",
                                          notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty
                                              ? widget.notPaidReason
                                              : "",
                                          addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                                          subsId: widget.subsId != null ? widget.subsId : 0,
                                          rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                                          rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                                          paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                                          exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                                          paymentStatus:
                                              "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                                          userId: int.tryParse(userId.toString()),
                                          baseImage: base64Image != null && base64Image != "" ? base64Image : "",
                                          deliveredTo: "${widget.deliveredTo}",
                                          deliveryId: widget.orderid.join(","),
                                          routeId: "${widget.routeId ?? ""}",
                                          customerRemarks: "${widget.remarks ?? ""}",
                                          baseSignature: "${encoded ?? ""}",
                                          deliveryStatus:
                                              widget.selectedStatusCode != null ? widget.selectedStatusCode : 0,
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
                                          param9: "$lat",
                                          param10: "$lng",
                                          date_Time: "${DateTime.now().millisecondsSinceEpoch}",
                                          latitude: lat,
                                          longitude: lng);
                                      // logger.i(orderCompleteObj);
                                      getLocationByClick();
                                      print("USER CURRENT LOCATION IS in OrderComplete Database is   " +
                                          lat.toString() +
                                          "  " +
                                          lng.toString());
                                      String status = "Completed";
                                      if (widget.selectedStatusCode == 5) {
                                        status = "Completed";
                                      } else if (widget.selectedStatusCode == 6) {
                                        status = "Failed";
                                      }
                                      await MyDatabase().insertOrderCompleteData(orderCompleteObj);
                                      await Future.forEach(widget.orderid, (element) async {
                                        await MyDatabase().updateDeliveryStatus(
                                            int.tryParse(element.toString()), status, widget.selectedStatusCode);
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
                                  } catch (e, stackTrace) {
                                    SentryExemption.sentryExemption(e, stackTrace);
                                    _showSnackBar(e.toString());
                                  }
                                } else {
                                  _showSnackBar('Write Sign');
                                  final sign = _sign.currentState;
                                  sign.clear();
                                  setState(() {
                                    _img = ByteData(0);
                                  });
                                }
                              } else if (widget.selectedStatusCode == 6) {
                                // final image = await sign?.getData();
                                // var data = await image?.toByteData(
                                //     format: ui.ImageByteFormat.png);
                                // sign.clear();
                                //   final encoded = base64.encode(data?.buffer?.asUint8List());
                                // setState(() {
                                //   _img = data;
                                // });
                                try {
                                  if (userId == null || userId.isEmpty) {
                                    final prefs = await SharedPreferences.getInstance();
                                    userId = prefs.getString('userId') ?? "";
                                  }
                                  if (userId != null && userId.isNotEmpty && userId != "0") {
                                    await getLocationByClick();
                                    orderCompleteObj = OrderCompleteDataCompanion.insert(
                                        remarks: "${widget.remarks ?? ""}",
                                        notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty
                                            ? widget.notPaidReason
                                            : "",
                                        addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                                        subsId: widget.subsId != null ? widget.subsId : 0,
                                        rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                                        rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                                        paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                                        exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                                        paymentStatus:
                                            "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                                        userId: int.tryParse(userId.toString()),
                                        baseImage: base64Image != null && base64Image != "" ? base64Image : "",
                                        deliveredTo: "${widget.deliveredTo}",
                                        deliveryId: widget.orderid.join(","),
                                        routeId: "${widget.routeId ?? ""}",
                                        customerRemarks: "${widget.remarks ?? ""}",
                                        baseSignature: "${"" ?? ""}",
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
                                        param9: "$lat",
                                        param10: "$lng",
                                        date_Time: "${DateTime.now().millisecondsSinceEpoch}",
                                        latitude: lat,
                                        longitude: lng);
                                    // logger.i(orderCompleteObj);
                                    getLocationByClick();
                                    print("USER CURRENT LOCATION IS in OrderComplete Database is   " +
                                        lat.toString() +
                                        "  " +
                                        lng.toString());
                                    String status = "Completed";
                                    if (widget.selectedStatusCode == 5) {
                                      status = "Completed";
                                    } else if (widget.selectedStatusCode == 6) {
                                      status = "Failed";
                                    }
                                    await MyDatabase().insertOrderCompleteData(orderCompleteObj);
                                    await Future.forEach(widget.orderid, (element) async {
                                      await MyDatabase().updateDeliveryStatus(
                                          int.tryParse(element.toString()), status, widget.selectedStatusCode);
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
                                } catch (e, stackTrace) {
                                  SentryExemption.sentryExemption(e, stackTrace);
                                  _showSnackBar(e.toString());
                                }
                              }
                            },
                            child: Text("Save")),
                      if (!widget.isCdDelivery)
                        MaterialButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () async {
                              bool checkInternet = await ConnectionValidator().check();
                              final sign = _sign.currentState;

                              //old code before removing sign functionality on faild delivery status
                              // ignore: unrelated_type_equality_checks

                              // if (sign.points.length != 0 ) {
                              //   final image = await sign.getData();
                              //   var data = await image.toByteData(
                              //       format: ui.ImageByteFormat.png);
                              //   sign.clear();
                              //   final encoded =
                              //   base64.encode(data.buffer.asUint8List());
                              //   setState(() {
                              //     _img = data;
                              //   }
                              //
                              //
                              //   );
                              //
                              //   try {
                              //     if (userId == null || userId.isEmpty) {
                              //       final prefs =
                              //       await SharedPreferences.getInstance();
                              //       userId = prefs.getString('userId') ?? "";
                              //     }
                              //     if (userId != null &&
                              //         userId.isNotEmpty &&
                              //         userId != "0") {
                              //
                              //       await getLocationByClick();
                              //
                              //       // logger.i("USER CURRENT LOCATION IS in OrderComplete Database is   " +lat.toString()+"  " + lng.toString());
                              //
                              //       orderCompleteObj = OrderCompleteDataCompanion.insert(
                              //           remarks: "${widget.remarks ?? ""}",
                              //           notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty ? widget.notPaidReason : "",
                              //           addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                              //           subsId: widget.subsId != null ? widget.subsId : 0,
                              //           rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                              //           rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                              //           paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                              //           exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                              //           paymentStatus: "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                              //           userId: int.tryParse(userId.toString()),
                              //           baseImage: base64Image != null && base64Image != "" ? base64Image : "",
                              //           deliveredTo: "${widget.deliveredTo}",
                              //           deliveryId: widget.orderid.join(","),
                              //           routeId: "${widget.routeId ?? ""}",
                              //           customerRemarks: "${widget.remarks ?? ""}",
                              //           baseSignature: "${encoded ?? ""}",
                              //           deliveryStatus:
                              //           widget.selectedStatusCode != null
                              //               ? widget.selectedStatusCode
                              //               : 0,
                              //           questionAnswerModels: "",
                              //           reschudleDate:
                              //           "${widget.rescheduleDate ?? ""}",
                              //           param1: "${widget.mobileNo ?? ""}",
                              //           param2: "${widget.failedRemark ?? ""}",
                              //           param5: "",
                              //           param6: "",
                              //           param7: "",
                              //           param4: "",
                              //           param8: "",
                              //           param3: "",
                              //           param9: "$lat",
                              //           param10: "$lng",
                              //           date_Time:
                              //           "${DateTime.now().millisecondsSinceEpoch}",
                              //           latitude: lat,
                              //           longitude: lng);
                              //       // logger.i(orderCompleteObj);
                              //       getLocationByClick();
                              //       logger.i("USER CURRENT LOCATION IS in OrderComplete Database is   " +lat.toString()+"  " + lng.toString());
                              //       String status = "Completed";
                              //       if (widget.selectedStatusCode == 5) {
                              //         status = "Completed";
                              //       } else if (widget.selectedStatusCode == 6) {
                              //         status = "Failed";
                              //       }
                              //       await MyDatabase()
                              //           .insertOrderCompleteData(orderCompleteObj);
                              //       await Future.forEach(widget.orderid,
                              //               (element) async {
                              //             await MyDatabase().updateDeliveryStatus(
                              //                 int.tryParse(element.toString ()),
                              //                 status,
                              //                 widget.selectedStatusCode);
                              //           });
                              //
                              //       if(!checkInternet) {
                              //         Navigator.pushAndRemoveUntil(
                              //             context,
                              //             MaterialPageRoute(
                              //               builder: (BuildContext context) =>
                              //                   DashboardDriver(1),
                              //             ),
                              //             ModalRoute.withName('/signature'));
                              //       }else {
                              //         if (widget.outForDelivery != null) {
                              //           if (widget.outForDelivery.length - 1 !=
                              //               1)
                              //             Navigator.pushAndRemoveUntil(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                   builder: (
                              //                       BuildContext context) =>
                              //                       DashboardDriver(1),
                              //                 ),
                              //                 ModalRoute.withName(
                              //                     '/signature'));
                              //           if (widget.outForDelivery.length - 1 ==
                              //               1) {
                              //             logger.i(
                              //                 widget.outForDelivery.length - 1);
                              //             checkOfflineDeliveryAvailable();
                              //           }
                              //         }else{
                              //           Navigator.pushAndRemoveUntil(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (BuildContext context) =>
                              //                     DashboardDriver(1),
                              //               ),
                              //               ModalRoute.withName('/signature'));
                              //         }
                              //       }
                              //     } else {
                              //       logOut();
                              //     }
                              //   } catch (e,stackTrace) {
                              //     SentryExemption.sentryExemption(e, stackTrace);
                              //     _showSnackBar(e.toString());
                              //   }
                              // } else {
                              //   _showSnackBar('Write Sign');
                              //   final sign = _sign.currentState;
                              //   sign.clear();
                              //   setState(() {
                              //     _img = ByteData(0);
                              //   });
                              // }

                              if (widget.selectedStatusCode == 5) {
                                final image = await sign.getData();
                                var data = await image.toByteData(format: ui.ImageByteFormat.png);
                                sign.clear();
                                final encoded = base64.encode(data.buffer.asUint8List());
                                setState(() {
                                  _img = data;
                                });
                                try {
                                  if (userId == null || userId.isEmpty) {
                                    final prefs = await SharedPreferences.getInstance();
                                    userId = prefs.getString('userId') ?? "";
                                  }
                                  if (userId != null && userId.isNotEmpty && userId != "0") {
                                    await getLocationByClick();

                                    // logger.i("USER CURRENT LOCATION IS in OrderComplete Database is   " +lat.toString()+"  " + lng.toString());

                                    orderCompleteObj = OrderCompleteDataCompanion.insert(
                                        remarks: "${widget.remarks ?? ""}",
                                        notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty
                                            ? widget.notPaidReason
                                            : "",
                                        addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                                        subsId: widget.subsId != null ? widget.subsId : 0,
                                        rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                                        rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                                        paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                                        exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                                        paymentStatus:
                                            "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                                        userId: int.tryParse(userId.toString()),
                                        baseImage: base64Image != null && base64Image != "" ? base64Image : "",
                                        deliveredTo: "${widget.deliveredTo}",
                                        deliveryId: widget.orderid.join(","),
                                        routeId: "${widget.routeId ?? ""}",
                                        customerRemarks: "${widget.remarks ?? ""}",
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
                                        param9: "$lat",
                                        param10: "$lng",
                                        date_Time: "${DateTime.now().millisecondsSinceEpoch}",
                                        latitude: lat,
                                        longitude: lng);
                                    // logger.i(orderCompleteObj);
                                    getLocationByClick();
                                    print("USER CURRENT LOCATION IS in OrderComplete Database is   " +
                                        lat.toString() +
                                        "  " +
                                        lng.toString());
                                    String status = "Completed";
                                    if (widget.selectedStatusCode == 5) {
                                      status = "Completed";
                                    } else if (widget.selectedStatusCode == 6) {
                                      status = "Failed";
                                    }
                                    await MyDatabase().insertOrderCompleteData(orderCompleteObj);
                                    await Future.forEach(widget.orderid, (element) async {
                                      await MyDatabase().updateDeliveryStatus(
                                          int.tryParse(element.toString()), status, widget.selectedStatusCode);
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
                                } catch (e, stackTrace) {
                                  SentryExemption.sentryExemption(e, stackTrace);
                                  _showSnackBar(e.toString());
                                }
                              } else if (widget.selectedStatusCode == 6) {
                                // final image = await sign?.getData();
                                // var data = await image?.toByteData(
                                //     format: ui.ImageByteFormat.png);
                                // sign.clear();
                                //   final encoded = base64.encode(data?.buffer?.asUint8List());
                                // setState(() {
                                //   _img = data;
                                // });
                                try {
                                  if (userId == null || userId.isEmpty) {
                                    final prefs = await SharedPreferences.getInstance();
                                    userId = prefs.getString('userId') ?? "";
                                  }
                                  if (userId != null && userId.isNotEmpty && userId != "0") {
                                    await getLocationByClick();

                                    // logger.i("USER CURRENT LOCATION IS in OrderComplete Database is   " +lat.toString()+"  " + lng.toString());

                                    orderCompleteObj = OrderCompleteDataCompanion.insert(
                                        remarks: "${widget.remarks ?? ""}",
                                        notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty
                                            ? widget.notPaidReason
                                            : "",
                                        addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                                        subsId: widget.subsId != null ? widget.subsId : 0,
                                        rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                                        rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                                        paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                                        exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                                        paymentStatus:
                                            "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                                        userId: int.tryParse(userId.toString()),
                                        baseImage: base64Image != null && base64Image != "" ? base64Image : "",
                                        deliveredTo: "${widget.deliveredTo}",
                                        deliveryId: widget.orderid.join(","),
                                        routeId: "${widget.routeId ?? ""}",
                                        customerRemarks: "${widget.remarks ?? ""}",
                                        baseSignature: "${"" ?? ""}",
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
                                        param9: "$lat",
                                        param10: "$lng",
                                        date_Time: "${DateTime.now().millisecondsSinceEpoch}",
                                        latitude: lat,
                                        longitude: lng);
                                    // logger.i(orderCompleteObj);
                                    getLocationByClick();
                                    print("USER CURRENT LOCATION IS in OrderComplete Database is   " +
                                        lat.toString() +
                                        "  " +
                                        lng.toString());
                                    String status = "Completed";
                                    if (widget.selectedStatusCode == 5) {
                                      status = "Completed";
                                    } else if (widget.selectedStatusCode == 6) {
                                      status = "Failed";
                                    }
                                    await MyDatabase().insertOrderCompleteData(orderCompleteObj);
                                    await Future.forEach(widget.orderid, (element) async {
                                      await MyDatabase().updateDeliveryStatus(
                                          int.tryParse(element.toString()), status, widget.selectedStatusCode);
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
                                } catch (e, stackTrace) {
                                  SentryExemption.sentryExemption(e, stackTrace);
                                  _showSnackBar(e.toString());
                                }
                              }
                            },
                            child: Text("Save")),
                      if (!widget.isCdDelivery || widget.isCdDelivery && widget.selectedStatusCode != 5)
                        MaterialButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            onPressed: () async {
                              bool checkInternet = await ConnectionValidator().check();
                              final sign = _sign.currentState;

                              try {
                                if (userId == null || userId.isEmpty) {
                                  final prefs = await SharedPreferences.getInstance();
                                  userId = prefs.getString('userId') ?? "";
                                }
                                if (userId != null && userId.isNotEmpty && userId != "0") {
                                  orderCompleteObj = OrderCompleteDataCompanion.insert(
                                      remarks: "${widget.remarks ?? ""}",
                                      notPaidReason: widget.notPaidReason != null && widget.notPaidReason.isNotEmpty
                                          ? widget.notPaidReason
                                          : "",
                                      addDelCharge: widget.addDelCharge != null ? widget.addDelCharge : "",
                                      subsId: widget.subsId != null ? widget.subsId : 0,
                                      rxCharge: widget.rxCharge != null ? widget.rxCharge : "",
                                      rxInvoice: widget.rxInvoice != null ? widget.rxInvoice : "",
                                      paymentMethode: widget.paymentType != null ? widget.paymentType : "",
                                      exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                                      paymentStatus:
                                          "${widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : ""}",
                                      userId: int.tryParse(userId.toString()),
                                      baseImage: "",
                                      deliveredTo: "${widget.deliveredTo}",
                                      deliveryId: widget.orderid.join(","),
                                      routeId: "${widget.routeId ?? ""}",
                                      customerRemarks: "${widget.remarks ?? ""}",
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
                                  await Future.forEach(widget.orderid, (element) async {
                                    await MyDatabase().updateDeliveryStatus(
                                        int.tryParse(element.toString()), status, widget.selectedStatusCode);
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
                              } catch (e, stackTrace) {
                                SentryExemption.sentryExemption(e, stackTrace);
                                logger.i(e);
                                _showSnackBar(e.toString());
                              }
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
                      if (widget.isCdDelivery && widget.selectedStatusCode == 5) Text("Cd sign is mandatory"),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future imgFromCamera() async {
    //setState(() {
    try {
      final pickedFile =
          await picker.getImage(imageQuality: 30, source: ImageSource.camera, maxHeight: 500, maxWidth: 500);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        final imageData = await _image.readAsBytes();
        base64Image = base64Encode(imageData);
        print("Base 64 image data is :::::::>>>>>> $base64Image");
      } else {
        // print('No image selected.');
      }
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      //_showSnackBar("Status Successfully Updated");
    }

    // });
  }

  void onSigneture() {
    print(widget.selectedStatusCode);
    try {
      if (widget.selectedStatusCode == 5 || widget.selectedStatusCode == 6) {
        // getAllQuestion(); // Question Removed

        //if(remarkController.text.isNotEmpty) {

        Route route = MaterialPageRoute(
            builder: (context) => SignatureApp(
                  remarks: widget.remarks,
                  isCdDelivery: widget.isCdDelivery,
                  outForDelivery: widget.outForDelivery,
                  notPaidReason: widget.notPaidReason,
                  exemptionId: widget.exemptionId != null ? widget.exemptionId : 0,
                  paymentStatus:
                      widget.paymentStatus != null && widget.paymentStatus.isNotEmpty ? widget.paymentStatus : "",
                  deliveredTo: widget.deliveredTo,
                  selectedStatusCode: widget.selectedStatusCode,
                  mobileNo: widget.mobileNo ?? "",
                  rxInvoice: widget.rxInvoice ?? "",
                  rxCharge: widget.rxCharge ?? "",
                  subsId: widget.subsId ?? 0,
                  addDelCharge: widget.addDelCharge ?? "",
                  // name: "${widget.delivery.customer.fullName ?? ""}",
                  paymentType: widget.paymentType ?? "",
                  amount: widget.amount ?? "",
                  failedRemark: widget.failedRemark ?? "",
                  name: "",
                  deliveryId: widget.orderid,
                  rescheduleDate: widget.rescheduleDate ?? "",
                  customerImage: base64Image != null && base64Image != "" ? base64Image : "",
                  customerRemark: widget.remarks,
                  arrAns: [],
                  routeID: widget.delivery != null ? widget.delivery.routeId.toString() : widget.routeId ?? "",
                ));
        Navigator.of(context).pop();
        Navigator.push(context, route);
      } else {
        //  _asyncConfirmDialog("Status Successfully Updated");
      }

      //widget.function();
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      // print(e);
    }
  }

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

      _apiCallFram.getDataRequestAPI(url, accessToken, context).then((response) async {
        await CustomLoading().showLoadingDialog(context, false);
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
          await CustomLoading().showLoadingDialog(context, false);
        }
        await CustomLoading().showLoadingDialog(context, false);
      }).catchError((onError) async {
        String jsonUser = jsonEncode(onError);
        Fluttertoast.showToast(msg: jsonUser);
        await CustomLoading().showLoadingDialog(context, false);
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

import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/View/HowToOperate.dart/PdfScreen.dart';
import '../../../main.dart';
import '../../RouteController/RouteNames.dart';
import '../AdditionalWidget/ExpansionTileCard/expansionTileCardWidget.dart';
import '../Popup/PopupCustom.dart';
import '../StringDefine/StringDefine.dart';

// import 'package:progress_dialog/progress_dialog.dart';


class DrawerDriver extends StatefulWidget {
  static String tag = 'place_order-screen';

  String? versionCode = "";

  DrawerDriver({super.key, this.versionCode, CurrentRemainingTimeIS});

  @override
  State<StatefulWidget> createState() {    
    return DrawerDriverState();
  }
}

class DrawerDriverState extends State<DrawerDriver> {

  Future<File>? imageFile;
  double opacity = 0.0;
  bool status = false;
  var yetToStartColor = const Color(0xFFF8A340);

  // final lunchStoppingTime = CurrentRemainingTimeIS;

  bool isLoading = true;
  bool showPopUp = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String? username,
      password,
      token,
      userType,
      endMile,
      startMile,
      vehicleId = "";
  String? driverType = "";
  String? routeId, routeS;

  // ProgressDialog progressDialog;
  bool smsPermission = false;
  Timer? timer1;

  bool isDialogShowing = false;

  Map<String, Object>? profiledata;
  String? userId;
  String versionCode = "";

  String? fName,
      middleName,
      howToOperateUrl,
      lastName,
      contactNumber,
      nhsNumber,
      email,
      address1,
      address2,
      route,
      postCode,
      townName;
  String name = "";
  String virPop = "";
  int value = 0;

  // bool positive = false;
  bool loading = false;
  String? fullAddress;
  double lat = 0.0;
  double lng = 0.0;
  bool isTap = false;
  bool onBreak = false;
  bool showIncreaseTime = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.w('#DRIVER TYPE : $driverType');
    logger.w('#DRIVER TYPE : $virPop');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Drawer(
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.greyColor,
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 0))
                                      ],
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: Text(
                                      username != null
                                          ? username![0].toUpperCase()
                                          : '',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 30.0),
                                    ),
                                  )),
                            buildSizeBox(0.0, 20.0),
                              BuildText.buildText(
                                text:  name != null ? name : "",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            buildSizeBox(10.0, 0.0),
                            ],
                          ),
                        ],
                      ),

                      if (userType == 'Driver')
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          // color: Colors.amber.withOpacity(0.1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(kLunchMode),
                                  SizedBox(
                                    height: 20,
                                    // width: 40,
                                    child: Image.asset(
                                      strIMG_NewGIF,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 0,
                              ),                              
                              Row(
                                children: [
                                  const Text(
                                    kOff,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Tooltip(
                                    message: kStartLunch,
                                    enableFeedback: true,
                                    waitDuration: const Duration(microseconds: 1),
                                    child: SizedBox(
                                      width: 100,
                                      height: 70,
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Switch(
                                          dragStartBehavior:
                                              DragStartBehavior.down,
                                          onChanged: (bool value) {
                                           
                                          },
                                          value: onBreak,
                                          activeColor: Colors.orange,
                                          activeTrackColor: Colors.orange,
                                          inactiveThumbColor: Colors.grey,
                                          inactiveTrackColor: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    kON,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        buildSizeBox(10.0, 0.0),
                      ExpansionTileCard(
                        animateTrailing: true,
                        title: BuildText.buildText(text: kPersonalInfo,color: Colors.blue,textAlign: TextAlign.start),
                        leading: const Icon(
                          Icons.person,
                          size: 20,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ), // height: 200,

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.mobile_friendly_sharp,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                   buildSizeBox(0.0, 10.0),
                                    BuildText.buildText(text: kContactNumber)
                                  ],
                                ),
                                buildSizeBox(5.0, 0.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                      size: 12,
                                    ),
                                   buildSizeBox(0.0, 10.0),
                                    BuildText.buildText(text: kemail)
                                  ],
                                ),
                             buildSizeBox(5.0, 0.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_city_outlined,
                                      color: Colors.grey,
                                      size: 12,
                                    ),
                                 buildSizeBox(0.0, 10.0),
                                    BuildText.buildText(text: kaddress)
                                  ],
                                ),
                                buildSizeBox(10.0, 0.0),
                              ],
                            ),
                          ),
                        ],
                        onExpansionChanged: (value) {
                       
                        },
                      ),
                      buildSizeBox(5.0, 0.0),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.lock, size: 20),
                        title: BuildText.buildText(text: kChangePin)
                      ),

                      /// create patient widget
                      if (driverType != "Shared")
                        ListTile(
                          onTap: () {
                            Get.toNamed(createPatientScreenRoute);
                          },
                          leading: const Icon(Icons.local_hospital,size: 20),
                          title:BuildText.buildText(text: kCreatePatient)
                        ),

                        ListTile(
                          onTap: () {
                            Get.toNamed(pdfViewScreenRoute,
                            arguments: PdfViewScreen(
                              pdfUrl: "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
                            ));
                          },
                          leading: const Icon(Icons.question_mark,size: 20),
                          title:BuildText.buildText(text: kHowToOperate)
                        ),

                        ListTile(
                          onTap: () {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return const EnterMilesDialog();
                              },);
                          },
                          leading: const Icon(Icons.edit,size: 20),
                          title:BuildText.buildText(text: kEnterMiles)
                        ),

                        ListTile(
                          onTap: () {
                            Get.toNamed(updateAddressScreenRoute);
                          },
                          leading: const Icon(Icons.home,size: 20),
                          title:BuildText.buildText(text: kUpdateAddress)
                        ),
                 
                      ListTile(
                          onTap: () {},
                          leading: const Icon(Icons.logout,size: 20),
                          title:BuildText.buildText(text: klogout)
                        ),
                  
                      const Spacer(),
                      Text(kAppVersion + versionCode ?? ""),
                      buildSizeBox(20.0, 0.0),
                    ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }

//   Future<void> showStartMilesDialog() async {
//     bool checkStartMiles = false;
//     TextEditingController startMilesController = TextEditingController();
//     File _image;
//     String base64Image;
//     showDialog<ConfirmAction>(
//         context: context,
//         barrierDismissible: false, // user must tap button for close dialog!
//         builder: (BuildContext context1) {
//           return StatefulBuilder(builder: (context, setStat) {
//             return CustomDialogBox(
//               // img: Image.asset("assets/delivery_truck.png"),
//               descriptionWidget: Column(
//                 children: [
//                   Text(
//                     "Enter miles",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     "&",
//                     style: TextStyle(color: Colors.orangeAccent, fontSize: 17),
//                   ),
//                   Text(
//                     "take speedometer picture",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               button2: TextButton(
//                 onPressed: () async {
//                   if (startMilesController.text.toString().toString() == null ||
//                       startMilesController.text.toString().toString().isEmpty) {
//                     Fluttertoast.showToast(msg: "Enter Start Miles");
//                   } else if (_image == null) {
//                     Fluttertoast.showToast(msg: "Take Speedometer Picture");
//                   } else {
//                     Map<String, dynamic> prams = {
//                       "entry_type": "start",
//                       "start_miles": int.tryParse(
//                           startMilesController.text.toString().trim()),
//                       "end_miles": 0,
//                       "end_miles_image": "",
//                       "lat": "$lat",
//                       "lng": "$lng",
//                       "start_mile_image":
//                           base64Image != null && base64Image.isNotEmpty
//                               ? base64Image
//                               : "",
//                     };
//                     final prefs = await SharedPreferences.getInstance();
//                     prefs.setString(WebConstant.START_MILES,
//                         startMilesController.text.toString().trim());
//                     updateStartMiles(context, prams);
//                   }
//                 },
//                 child: Text("Okay",
//                     style: TextStyle(fontSize: 18.0, color: Colors.black)),
//               ),
//               button1: TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   "No",
//                   style: TextStyle(fontSize: 18.0, color: Colors.black),
//                 ),
//               ),
//               textField: TextField(
//                 controller: startMilesController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 style: TextStyle(color: Colors.blue),
//                 autofocus: false,
//                 onChanged: (value) {
//                   setStat(() {});
//                 },
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
//                 ],
//                 decoration: new InputDecoration(
//                   labelText: "Please enter start miles",
//                   fillColor: Colors.white,
//                   labelStyle: TextStyle(color: Colors.blue),
//                   filled: true,
//                   errorText: checkStartMiles ? "Enter Start Miles" : null,
//                   contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
//                   border: new OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                 ),
//               ),
//               cameraIcon: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CameraScreen()))
//                               .then((value) async {
//                             if (value != null) {
//                               setStat(() {
//                                 _image = File(value);
//                               });
//                               final imageData = await _image.readAsBytes();
//                               base64Image = base64Encode(imageData);
//                             }
//                           });
//                         },
//                         child: Container(
//                           height: 75.0,
//                           child: Image.asset("assets/speedometer.png"),
//                         ),
//                       ),
//                       if (_image != null)
//                         SizedBox(
//                           width: 10.0,
//                         ),
//                       if (_image != null)
//                         Container(
//                           width: 70.0,
//                           height: 70.0,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8.0),
//                             child: Image.file(
//                               _image,
//                               fit: BoxFit.cover,
//                               alignment: Alignment.topCenter,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
                 
//                   SizedBox(
//                     height: 5.0,
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }

//   void showSimpleDialog() {
//     showDialog<ConfirmAction>(
//         context: context,
//         barrierDismissible: false, // user must tap button for close dialog!
//         builder: (BuildContext context) {
//           return CustomDialogBox(
//             // img: Image.asset("assets/delivery_truck.png"),
//             title: "Alert...",
//             btnDone: "Okay",
//             descriptions: "You have entered start and end miles",
//           );
//         });
//   }

//   Future<void> showEndMilesDialog() async {
//     await SharedPreferences.getInstance().then((value) {
//       startMile = value.getString(WebConstant.START_MILES) ?? "";
//     });
//     bool checkStartMiles = false;
//     TextEditingController endMilesController = TextEditingController();
//     File _image;
//     String base64Image;
//     showDialog<ConfirmAction>(
//         context: context,
//         barrierDismissible: false, // user must tap button for close dialog!
//         builder: (BuildContext context1) {
//           return StatefulBuilder(builder: (context, setStat) {
//             return CustomDialogBox(
//               // img: Image.asset("assets/delivery_truck.png"),
//               // descriptions: "Enter miles and take speedometer picture\n ${startMile != null && startMile.isNotEmpty ? "Start Miles $startMile" : ""}",
//               descriptionWidget: Column(
//                 children: [
//                   Text(
//                     "Enter miles",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     "&",
//                     style: TextStyle(color: Colors.orangeAccent, fontSize: 17),
//                   ),
//                   Text(
//                     "take speedometer picture",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     "${startMile != null && startMile.isNotEmpty ? "Start Miles $startMile" : ""}",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               button2: TextButton(
//                 onPressed: () async {
//                   if (endMilesController.text.toString().toString() == null ||
//                       endMilesController.text.toString().toString().isEmpty) {
//                     Fluttertoast.showToast(msg: "Enter End Miles");
//                   } else if (_image == null) {
//                     Fluttertoast.showToast(msg: "Take Speedometer Picture");
//                   } else if (int.tryParse(
//                           endMilesController.text.toString().trim()) >
//                       int.tryParse(startMile != null && startMile.isNotEmpty
//                           ? startMile.toString()
//                           : "0")) {
//                     Map<String, dynamic> prams = {
//                       "entry_type": "end",
//                       "start_miles": 0,
//                       "end_miles": int.tryParse(
//                           endMilesController.text.toString().trim()),
//                       "lat": "$lat",
//                       "lng": "$lng",
//                       "start_mile_image": "",
//                       "end_miles_image":
//                           base64Image != null && base64Image.isNotEmpty
//                               ? base64Image
//                               : "",
//                     };
//                     final prefs = await SharedPreferences.getInstance();
//                     prefs.setString(WebConstant.END_MILES,
//                         endMilesController.text.toString().trim());
//                     updateStartMiles(context, prams);
//                   } else {
//                     checkStartMiles = true;
//                     setStat(() {});
//                   }
//                 },
//                 child: Text("Okay",
//                     style: TextStyle(fontSize: 18.0, color: Colors.black)),
//               ),
//               button1: TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   if (!isTap) checkOfflineDeliveryAvailable();
//                 },
//                 child: Text(
//                   "No",
//                   style: TextStyle(fontSize: 18.0, color: Colors.black),
//                 ),
//               ),
//               textField: TextField(
//                 controller: endMilesController,
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 style: TextStyle(color: Colors.blue),
//                 autofocus: false,
//                 onChanged: (value) {
//                   setStat(() {});
//                 },
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
//                 ],
//                 decoration: new InputDecoration(
//                   labelText: "Please enter end miles",
//                   fillColor: Colors.white,
//                   labelStyle: TextStyle(color: Colors.blue),
//                   filled: true,
//                   errorText: checkStartMiles
//                       ? "Enter end miles that greater then start miles"
//                       : null,
//                   contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
//                   border: new OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50.0),
//                     borderSide: BorderSide(color: Colors.blue),
//                   ),
//                 ),
//               ),
//               cameraIcon: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => CameraScreen()))
//                           .then((value) async {
//                         if (value != null) {
//                           setStat(() {
//                             _image = File(value);
//                           });
//                           final imageData = await _image.readAsBytes();
//                           base64Image = base64Encode(imageData);
//                         }
//                       });
//                     },
//                     child: Container(
//                       height: 75.0,
//                       child: Image.asset("assets/speedometer.png"),
//                     ),
//                   ),
//                   if (_image != null)
//                     SizedBox(
//                       width: 10.0,
//                     ),
//                   if (_image != null)
//                     Container(
//                       width: 70.0,
//                       height: 70.0,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.file(
//                           _image,
//                           fit: BoxFit.cover,
//                           alignment: Alignment.topCenter,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           });
//         });
//   }

//   Future<void> updateStartMiles(BuildContext context1, Map<String, dynamic> prams) async {
//     // print(prams['start_miles']);

//     // await ProgressDialog(context, isDismissible: false).show();
//     await CustomLoading().showLoadingDialog(context, true);
//     logger.i(WebConstant.UPDATE_MILES);
//     logger.i(prams);
//     _apiCallFram
//         .postDataAPI(WebConstant.UPDATE_MILES, token, prams, context)
//         .then((response) async {
//       // ProgressDialog(context,isDismissible: false).hide();
//       await CustomLoading().showLoadingDialog(context, false);
//       if (response != null &&
//           response.body != null &&
//           response.body == "Unauthenticated") {
//         Fluttertoast.showToast(msg: "Authentication Failed. Login again");
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
//           var data = json.decode(response.body);
//           logger.i("response: ${response.body}");
//           if (data["status"] == true || data["status"] == 'true') {
//             Navigator.pop(context1);
//             if (!isTap) checkOfflineDeliveryAvailable();
//           } else {
//             // ProgressDialog(context).hide();
//             await CustomLoading().showLoadingDialog(context, false);
//             ToastUtils.showCustomToast(
//                 context, "${data["message"]}, Please try again !");
//           }
//         }
//       } catch (e) {
//         logger.i(e.toString());
//         // ProgressDialog(context).hide();
//         await CustomLoading().showLoadingDialog(context, false);
//       }
//       // ProgressDialog(context).hide();
//       await CustomLoading().showLoadingDialog(context, false);
//     }, onError: (error, stackTrace) async {
//       // ProgressDialog(context).hide();
//       // ProgressDialog(context).hide();
//       await CustomLoading().showLoadingDialog(context, false);
//       // logger.i("error : " + error.toString());
//       ToastUtils.showCustomToast(context, "Please try again !");
//     });
//   }

//   // Future<Map<String, Object>> fetchData() async {
//   //   final JsonDecoder _decoder = new JsonDecoder();
//   //   Map<String, String> headers = {
//   //     'Accept': 'application/json',
//   //     "Content-type": "application/json",
//   //     "Authorization": 'Bearer $token'
//   //   };
//   //   print('userType:- ' + userType == 'Pharmacy' || userType == "Pharmacy Staff" ? WebConstant.GET_PROFILE_URL_PHARMACY : WebConstant.GET_PROFILE_URL);
//   //   final response =
//   //   await http.get(userType == 'Pharmacy' || userType == "Pharmacy Staff" ? Uri.parse(WebConstant.GET_PROFILE_URL_PHARMACY) : Uri.parse(WebConstant.GET_PROFILE_URL), headers: headers);
//   //   setState(() {
//   //     _isLoading = false;
//   //   });
//   //   logger.i("ccc" + json.decode(response.body).toString());
//   //   if (response.statusCode == 200) {
//   //     // If the server did return a 200 OK response,
//   //     // then parse the JSON.
//   //     Map<String, Object> data = json.decode(response.body);
//   //     try {
//   //       // if (data.containsKey("data")) {pharmacyId, branchId
//   //       if (data == null) {
//   //         _showSnackBar("No Data Found");
//   //       } else {
//   //         var status = data['status'];
//   //         if (status != null && status == true) {
//   //           Map<String, Object> user = data['driverProfile'];
//   //           setState((){
//   //             if (user['routeId'] != null) routeId = user['routeId'].toString();
//   //             if (user['route'] != null) routeS = user['route'].toString();
//   //           });
//   //         } else {
//   //           _showSnackBar("No Data Found");
//   //         }
//   //       }
//   //     } catch (e) {
//   //       _showSnackBar(e);
//   //     }
//   //   } else if (response.statusCode == 401) {
//   //     final prefs = await SharedPreferences.getInstance();
//   //     prefs.remove('token');
//   //     prefs.remove('userId');
//   //     prefs.remove('name');
//   //     prefs.remove('email');
//   //     prefs.remove('mobile');
//   //     Navigator.pushAndRemoveUntil(
//   //         context,
//   //         PageRouteBuilder(pageBuilder: (BuildContext context,
//   //             Animation animation, Animation secondaryAnimation) {
//   //           return LoginScreen();
//   //         }, transitionsBuilder: (BuildContext context,
//   //             Animation<double> animation,
//   //             Animation<double> secondaryAnimation,
//   //             Widget child) {
//   //           return new SlideTransition(
//   //             position: new Tween<Offset>(
//   //               begin: const Offset(1.0, 0.0),
//   //               end: Offset.zero,
//   //             ).animate(animation),
//   //             child: child,
//   //           );
//   //         }),
//   //             (Route route) => false);
//   //     _showSnackBar('Session expired, Login again');
//   //   } else {
//   //     _showSnackBar('Something went wrong');
//   //   }
//   // }
//   @override
//   void dispose() {
//     super.dispose();
//     if (timer1 != null) {
//       timer1.cancel();
//     }
//   }

//   Future<Map<String, Object>> fetchLogout() async {
//     bool checkInternet = await ConnectionValidator().check();
//     if (checkInternet) {
//       // ProgressDialog(context, isDismissible: false).show();
//       await CustomLoading().showLoadingDialog(context, true);
//       final JsonDecoder _decoder = new JsonDecoder();
//       Map<String, String> headers = {
//         'Accept': 'application/json',
//         "Content-type": "application/json",
//         "Authorization": 'Bearer $token'
//       };
//       // print(headers);
//       // print(userType == 'Pharmacy' || userType == "Pharmacy Staff" ? WebConstant
//       //     .GET_LOGOUT_URL_PHARMACY : WebConstant.GET_LOGOUT_URL);

//       final response = await http.get(
//           userType == 'Pharmacy' || userType == "Pharmacy Staff"
//               ? Uri.parse(WebConstant.GET_LOGOUT_URL_PHARMACY)
//               : Uri.parse(WebConstant.GET_LOGOUT_URL),
//           headers: headers);
//       // ProgressDialog(context).hide();
//       await CustomLoading().showLoadingDialog(context, false);
//       setState(() {
//         _isLoading = false;
//       });
//       // logger.i("ccc" + response.body.toString());
//       if (response.statusCode == 200) {
//         // If the server did return a 200 OK response,
//         // then parse the JSON.
//         try {
//           // if (data.containsKey("data")) {pharmacyId, branchId
//           if (response.body == null) {
//             _showSnackBar("No Data Found");
//           } else if (response.body == "Success") {
//             final prefs = await SharedPreferences.getInstance();
//             prefs.remove('token');
//             prefs.remove('userId');
//             prefs.remove('name');
//             prefs.remove('email');
//             prefs.remove('mobile');
//             prefs.setBool(WebConstant.IS_LOGIN, false);
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 PageRouteBuilder(pageBuilder: (BuildContext context,
//                     Animation animation, Animation secondaryAnimation) {
//                   return LoginScreen();
//                 }, transitionsBuilder: (BuildContext context,
//                     Animation<double> animation,
//                     Animation<double> secondaryAnimation,
//                     Widget child) {
//                   return new SlideTransition(
//                     position: new Tween<Offset>(
//                       begin: const Offset(1.0, 0.0),
//                       end: Offset.zero,
//                     ).animate(animation),
//                     child: child,
//                   );
//                 }),
//                 (Route route) => false);
//           } else {
//             if (response != null &&
//                 response.body != null &&
//                 response.body == "Unauthenticated") {
//               Fluttertoast.showToast(msg: "Authentication Failed. Login again");
//               final prefs = await SharedPreferences.getInstance();
//               prefs.remove('token');
//               prefs.remove('userId');
//               prefs.remove('name');
//               prefs.remove('email');
//               prefs.remove('mobile');
//               prefs.remove('route_list');
//               prefs.setBool(WebConstant.IS_LOGIN, false);
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => LoginScreen(),
//                   ),
//                   ModalRoute.withName('/login_screen'));
//             }
//           }
//         } catch (e, stackTrace) {
//           // print(e);
//           SentryExemption.sentryExemption(e, stackTrace);
//           _showSnackBar(e);
//         }
//       } else if (response.statusCode == 401) {
//         final prefs = await SharedPreferences.getInstance();
//         prefs.remove('token');
//         prefs.remove('userId');
//         prefs.remove('name');
//         prefs.remove('email');
//         prefs.remove('mobile');
//         prefs.setBool(WebConstant.IS_LOGIN, false);
//         Navigator.pushAndRemoveUntil(
//             context,
//             PageRouteBuilder(pageBuilder: (BuildContext context,
//                 Animation animation, Animation secondaryAnimation) {
//               return LoginScreen();
//             }, transitionsBuilder: (BuildContext context,
//                 Animation<double> animation,
//                 Animation<double> secondaryAnimation,
//                 Widget child) {
//               return new SlideTransition(
//                 position: new Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: child,
//               );
//             }),
//             (Route route) => false);
//         _showSnackBar('Session expired, Login again');
//       } else {
//         _showSnackBar('Something went wrong');
//       }
//     } else {
//       Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
//     }
//   }

//   Future<Map<String, Object>> updateBreakTime({String lat, String lng, int statusCodee}) async {
//     logger.i(":::::::::Status code from button click is " +
//         statusCodee.toString() +
//         ":::" +
//         lat.toString() +
//         lng.toString());
//     bool checkInternet = await ConnectionValidator().check();
//     if (checkInternet) {
//       // ProgressDialog(context, isDismissible: false).show();
//       await CustomLoading().showLoadingDialog(context, true);
//       final JsonDecoder _decoder = new JsonDecoder();
//       Map<String, String> headers = {
//         'Accept': 'application/json',
//         "Content-type": "application/json",
//         "Authorization": 'Bearer $token'
//       };
//       // print(headers);
//       // print(userType == 'Pharmacy' || userType == "Pharmacy Staff" ? WebConstant
//       //     .GET_LOGOUT_URL_PHARMACY : WebConstant.GET_LOGOUT_URL);
//       Map<String, dynamic> data = {
//         "lat": lat,
//         "is_start": statusCodee,
//         "lng": lng,
//       };

//       final response = await http.post(Uri.parse(WebConstant.UPDATE_BREAK_TIME),
//           body: jsonEncode(data), headers: headers);
//       // ProgressDialog(context).hide();
//       await CustomLoading().showLoadingDialog(context, false);
//       setState(() {
//         _isLoading = false;
//       });
//       logger.i(
//           "UPDATE BREAK TIME RESPONSE from prfiel screen is IS :::::::::::" +
//               response.body.toString());
//       logger.i(
//           "UPDATE BREAK TIME RESPONSE code from prfiel screen is IS :::::::::::" +
//               response.statusCode.toString());

//       if (response.statusCode == 200) {
//         // If the server did return a 200 OK response,
//         // then parse the JSON.
//         try {
//           // if (data.containsKey("data")) {pharmacyId, branchId
//           if (response.body == null) {
//             _showSnackBar("No Data Found");
//           } else if (response.body == "Success") {
//             logger.i(response.body.toString());
//           } else {
//             if (response != null &&
//                 response.body != null &&
//                 response.body == "Unauthenticated") {
//               Fluttertoast.showToast(msg: "Authentication Failed. Login again");
//               final prefs = await SharedPreferences.getInstance();
//               prefs.remove('token');
//               prefs.remove('userId');
//               prefs.remove('name');
//               prefs.remove('email');
//               prefs.remove('mobile');
//               prefs.remove('route_list');
//               prefs.setBool(WebConstant.IS_LOGIN, false);
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => LoginScreen(),
//                   ),
//                   ModalRoute.withName('/login_screen'));
//             }
//           }
//         } catch (e, stackTrace) {
//           // print(e);
//           logger.e(e);
//           SentryExemption.sentryExemption(e, stackTrace);
//           _showSnackBar(e);
//         }
//       } else if (response.statusCode == 401) {
//         final prefs = await SharedPreferences.getInstance();
//         prefs.remove('token');
//         prefs.remove('userId');
//         prefs.remove('name');
//         prefs.remove('email');
//         prefs.remove('mobile');
//         prefs.setBool(WebConstant.IS_LOGIN, false);
//         Navigator.pushAndRemoveUntil(
//             context,
//             PageRouteBuilder(pageBuilder: (BuildContext context,
//                 Animation animation, Animation secondaryAnimation) {
//               return LoginScreen();
//             }, transitionsBuilder: (BuildContext context,
//                 Animation<double> animation,
//                 Animation<double> secondaryAnimation,
//                 Widget child) {
//               return new SlideTransition(
//                 position: new Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: child,
//               );
//             }),
//             (Route route) => false);
//       } else {
//         _showSnackBar('Something went wrong');
//       }
//     } else {
//       Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
//     }
//   }

//   Future<Map<String, Object>> fetchData() async {
//     bool checkInternet = await ConnectionValidator().check();
//     if (checkInternet) {
//       // await ProgressDialog(context, isDismissible: false).show();
//       // await CustomLoading().showLoadingDialog(context, true);
//       Map<String, String> headers = {
//         'Accept': 'application/jsons',
//         "Content-type": "application/json",
//         "Authorization": 'Bearer $token'
//       };
//       // print(headers);
//       // print('userType:- ' + userType);
//       logger.i(
//           'userType:- ' + userType == 'Pharmacy' || userType == "Pharmacy Staff"
//               ? WebConstant.GET_PROFILE_URL_PHARMACY
//               : WebConstant.GET_PROFILE_URL);
//       final response = await http.get(
//           userType == 'Pharmacy' || userType == "Pharmacy Staff"
//               ? Uri.parse(WebConstant.GET_PROFILE_URL_PHARMACY)
//               : Uri.parse(WebConstant.GET_PROFILE_URL),
//           headers: headers);
//       // ProgressDialog(context).hide();
//       await CustomLoading().showLoadingDialog(context, false);
//       setState(() {
//         _isLoading = false;
//       });
//       logger.i("FETCH DATA API RESPONSE ==>" + response.body.toString());
//       if (response.statusCode == 200) {
//         // If the server did return a 200 OK response,
//         // then parse the JSON.

//         try {
//           // if (data.containsKey("data")) {pharmacyId, branchId

//           if (response != null &&
//               response.body != null &&
//               response.body == "Unauthenticated") {
//             Fluttertoast.showToast(msg: "Authentication Failed. Login again");
//             final prefs = await SharedPreferences.getInstance();
//             prefs.remove('token');
//             prefs.remove('userId');
//             prefs.remove('name');
//             prefs.remove('email');
//             prefs.remove('mobile');
//             prefs.remove('route_list');
//             Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => LoginScreen(),
//                 ),
//                 ModalRoute.withName('/login_screen'));
//           } else {
//             Map<String, Object> data = json.decode(response.body);
//             if (data == null) {
//               _showSnackBar("No Data Found");
//             } else if (data['status'] == "true") {
//               profiledata = data;
//               logger.i(profiledata);
//               var status = data['status'];
//               if (status != null && status == "true") {
//                 Map<String, Object> user = data['driverProfile'];
//                 // print(user);
//                 setState(() {
//                   if (user['firstName'] != null)
//                     fName = user['firstName'].toString();
//                   if (user['middleName'] != null)
//                     middleName = user['middleName'].toString();
//                   if (user['lastName'] != null)
//                     lastName = user['lastName'].toString();
//                   if (fName != null) {
//                     String first = fName != null ? fName : "";
//                     String mid =
//                         middleName != null ? " " + middleName + " " : ' ';
//                     String last = lastName != null ? lastName : "";
//                     name = first + mid + last;
//                   }
//                   // if (middleName != null) {
//                   //   setState(() {
//                   //     name = middleName;
//                   //   });
//                   // }
//                   // if (lastName != null) {
//                   //   setState(() {
//                   //     name =  lastName;
//                   //   });
//                   // }
//                   howToOperateUrl = data['user_manual'];
//                   if (user['mobileNumber'] != null)
//                     contactNumber = user['mobileNumber'].toString();
//                   if (user['emailId'] != null)
//                     email = user['emailId'].toString();

//                   if (user['address_line_1'] != null)
//                     address1 = user['address_line_1'].toString();
//                   if (user['address_line_2'] != null)
//                     address2 = user['address_line_2'].toString();
//                   if (user['town_name'] != null)
//                     townName = user['town_name'].toString();
//                   if (user['post_code'] != null)
//                     postCode = user['post_code'].toString();

//                   fullAddress =
//                       "${address1 != null && address1.isNotEmpty ? "$address1, " : ""}"
//                       "${address2 != null && address2.isNotEmpty ? "$address2, " : ""}"
//                       "${townName != null && townName.isNotEmpty ? "$townName, " : ""}"
//                       "${postCode != null && postCode.isNotEmpty ? "$postCode " : ""}";
//                   // if (user['routeId'] != null) routeId = user['routeId'].toString();
//                   // if (user['route'] != null) route = user['route'].toString();
//                 });
//               } else {
//                 _showSnackBar("No Data Found");
//               }
//             }
//           }
//         } catch (e, stackTrace) {
//           // print(e);
//           SentryExemption.sentryExemption(e, stackTrace);
//           _showSnackBar(e);
//         }
//       } else if (response.statusCode == 401) {
//         final prefs = await SharedPreferences.getInstance();
//         prefs.remove('token');
//         prefs.remove('userId');
//         prefs.remove('name');
//         prefs.remove('email');
//         prefs.remove('mobile');
//         Navigator.pushAndRemoveUntil(
//             context,
//             PageRouteBuilder(pageBuilder: (BuildContext context,
//                 Animation animation, Animation secondaryAnimation) {
//               return LoginScreen();
//             }, transitionsBuilder: (BuildContext context,
//                 Animation<double> animation,
//                 Animation<double> secondaryAnimation,
//                 Widget child) {
//               return new SlideTransition(
//                 position: new Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: child,
//               );
//             }),
//             (Route route) => false);
//         _showSnackBar('Session expired, Login again');
//       } else {
//         _showSnackBar('Something went wrong');
//       }
//     } else {
//       _showSnackBar(WebConstant.INTERNET_NOT_AVAILABE);
//     }
//   }

//   _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   void _asyncConfirmDialog() {
//     showDialog<ConfirmAction>(
//       context: context,
//       barrierDismissible: false, // user must tap button for close dialog!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(WebConstant.LOGOUT),
//           content: const Text(WebConstant.ARE_YOU_SURE_LOGOUT),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 'CANCEL',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 //  Navigator.pop(_ctx);
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 'YES',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 fetchLogout();
//               },
//             )
//           ],
//         );
//       },
//     );
//     // Navigator.pop(context, true);
//   }

//   @override
//   Future<void> onLoginError(String errorTxt) async {
//     _showSnackBar(errorTxt);
//     // ProgressDialog(context).hide();
//     await CustomLoading().showLoadingDialog(context, false);
//     //setState(() => _isLoading = false);
//   }

//   @override
//   void onLoginSuccess(Map<String, Object> user) async {
//     // ProgressDialog(context).hide();
//     await CustomLoading().showLoadingDialog(context, false);
//     // _showSnackBar(user.toString());
//     //setState(() => _isLoading = false);
//     /* var db = new DatabaseHelper();
//     var status = user['status'];
//     var uName = user['message'];*/
//   }

//   Future<void> checkOfflineDeliveryAvailable() async {
//     var completeAllList = await MyDatabase().getAllOrderCompleteData();
//     if (completeAllList != null && completeAllList.isNotEmpty) {
//       BuildContext dialogContext;
//       isDialogShowing = true;
//       await showDialog<ConfirmAction>(
//           context: context,
//           barrierDismissible: false, // user must tap button for close dialog!
//           builder: (BuildContext context) {
//             dialogContext = context;
//             dialogDissmissTimer(dialogContext);
//             return CustomDialogBox(
//               // img: Image.asset("assets/delivery_truck.png"),
//               title: "Alert...",
//               btnDone: "Okay",
//               btnNo: "",
//               onClicked: onClick,
//               descriptions: Constants.uploading_msg,
//             );
//           });
//     } else
//       _asyncConfirmDialog();
//   }

//   void onClick(bool value) {
//     isDialogShowing = false;
//     if (value) {
//       timer1.cancel();
//       // updateSignature();
//     }
//   }

//   void updateSignature() {
//     logger.i("PrintLog1");
//     String accessToken = "";
//     SharedPreferences.getInstance().then((value) async {
//       accessToken = await value.getString(WebConstant.ACCESS_TOKEN);
//     });
//     MyDatabase().getAllOrderCompleteData().then((value) async {
//       if (value != null && value.isNotEmpty) {
//         logger.i("PrintLog2 ${accessToken}");
//         await Future.forEach(value, (element) async {
//           logger.i("PrintLog3 ${element}");
//           ApiCallFram _apiCallFram = ApiCallFram();
//           Map<String, dynamic> prams = {
//             "remarks": element.remarks,
//             "deliveredTo": element.deliveredTo,
//             "deliveryId": element.deliveryId.toString().split(","),
//             "routeId": element.routeId,
//             "exemption": element.exemptionId,
//             "paymentStatus": element.paymentStatus,
//             "driverId": element.userId,
//             "mobileNo": element.param1,
//             "failed_remark": element.param2,
//             "customerRemarks": element.customerRemarks,
//             "baseSignature": element.baseSignature,
//             "DeliveryStatus": element.deliveryStatus,
//             "reschudleDate": element.reschudleDate,
//             "customerImage": element.baseImage,
//             "questionAnswerModels": "", //widget.arrAns
//             "latitude": 0.00,
//             "longitude": 0.00
//           };
//           logger.i(prams);
//           logger.i("PrintLog8");
//           await _apiCallFram
//               .postFormBackgroundDataAPI(
//                   WebConstant.DELIVERY_SIGNATURE_UPLOAD_URL, accessToken, prams)
//               .then((response) async {
//             try {
//               logger.i("PrintLog9");
//               if (response != null) {
//                 var data = json.decode(response.body);
//                 logger.i("response: ${response.body}");
//                 if (data["status"] == true || data["status"] == 'true') {
//                   logger.i("PrintLog2");
//                   // var list = await MyDatabase().getAllOrderCompleteData();

//                   await MyDatabase().delecteCompletedDeliveryById(element);

//                   // list = await  MyDatabase().getAllOrderCompleteData();
//                   // logger.i(list.length);
//                   if (value.last == element) {
//                     showDialogMessage1("All Delivery are updated");
//                   }
//                   logger.i("PrintLog5");
//                 } else {
//                   if (value.last == element) {
//                     showDialogMessage1("All Delivery are updated");
//                   }
//                   logger.i("PrintLog3");
//                 }
//               } else {
//                 if (value.last == element) {
//                   showDialogMessage("Something went wrong...");
//                 }
//                 logger.i("PrintLog7");
//               }
//             } catch (e, stackTrace) {
//               SentryExemption.sentryExemption(e, stackTrace);
//               logger.i("PrintLog6");
//               logger.i(e.toString());
//             }
//           }, onError: (error, stackTrace) {
//             logger.i("PrintLog15");
//           });
//         });
//       } else {
//         logger.i("PrintLog4");
//         showDialogMessage("Something went wrong...");
//       }
//     });
//   }

//   void showDialogMessage(String s) {
//     showDialog<ConfirmAction>(
//         context: context,
//         barrierDismissible: false, // user must tap button for close dialog!
//         builder: (BuildContext context) {
//           return CustomDialogBox(
//             // img: Image.asset("assets/delivery_truck.png"),
//             title: "Alert...",
//             btnDone: "Upload Now",
//             btnNo: "No",
//             onClicked: onClick,
//             descriptions: s,
//           );
//         });
//   }

//   void showDialogMessage1(String s) {
//     showDialog<ConfirmAction>(
//         context: context,
//         barrierDismissible: false, // user must tap button for close dialog!
//         builder: (BuildContext context) {
//           return CustomDialogBox(
//             // img: Image.asset("assets/delivery_truck.png"),
//             title: "Alert...",
//             btnDone: "Ok",
//             onClicked: (value) {},
//             descriptions: s,
//           );
//         });
//   }

//   Future<void> dialogDissmissTimer(BuildContext dialogContext) async {
//     Timer.periodic(const Duration(seconds: 2), (timer) async {
//       timer1 = timer;
//       logger.i('Dashboard Background Service');
//       var completeAllList = await MyDatabase().getAllOrderCompleteData();
//       if (completeAllList == null || completeAllList.isEmpty) {
//         timer1.cancel();
//         if (isDialogShowing) Navigator.pop(dialogContext);
//         isDialogShowing = false;
//       }
//     });
//   }

//   void noInternetPopUp(String msg) {
//     showDialog<ConfirmAction>(
//         context: context,
//         barrierDismissible: false, // user must tap button for close dialog!
//         builder: (BuildContext context) {
//           return CustomDialogBox(
//             img: Image.asset("assets/sad.png"),
//             title: "Alert...",
//             btnDone: "Okay",
//             btnNo: "",
//             descriptions: msg,
//           );
//         });
//   }
// }

// class DolDurmaClipper extends CustomClipper<Path> {
//   DolDurmaClipper({@required this.right, @required this.holeRadius});

//   final double right;
//   final double holeRadius;

//   @override
//   Path getClip(Size size) {
//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width - right - holeRadius, 0.0)
//       /* ..arcToPoint(
//         Offset(size.width - right, 0),
//         clockwise: false,
//         radius: Radius.circular(1),
//       )*/
//       ..lineTo(size.width, 0.0)
//       ..lineTo(size.width, size.height)
//       ..lineTo(size.width - right, size.height)
//       ..arcToPoint(
//         Offset(size.width - right - holeRadius, size.height),
//         clockwise: false,
//         radius: Radius.circular(1),
//       );

//     path.lineTo(0.0, size.height);

//     path.close();
//     return path;
//   }
}

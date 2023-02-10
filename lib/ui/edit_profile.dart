// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../util/custom_loading.dart';
import '../util/inputlayoututils.dart';
import '../util/sentryExeptionHendler.dart';
import 'login_screen.dart';

class UpdateAddress extends StatefulWidget {
  String address1, address2, townName, postCode;

  UpdateAddress({this.address1, this.address2, this.townName, this.postCode});

  @override
  _UpdateAddressState createState() => _UpdateAddressState();
}

Color iconColor = Colors.grey;
Color textColor = Colors.black;

class _UpdateAddressState extends State<UpdateAddress> {
  // LocationSettings locationSettings;

  //only use when you want current locaiton of user when he updates profile
  // getLocationByClick(){
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     locationSettings = AndroidSettings(
  //         accuracy: LocationAccuracy.high,
  //         distanceFilter: 100,
  //         forceLocationManager: true,
  //         intervalDuration: const Duration(seconds: 10),
  //         //(Optional) Set foreground notification config to keep the app alive
  //         //when going to the background
  //         foregroundNotificationConfig: const ForegroundNotificationConfig(
  //           notificationText:
  //           "Example app will continue to receive your location even when you aren't using it",
  //           notificationTitle: "Running in Background",
  //           enableWakeLock: true,
  //         )
  //     );
  //   } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
  //     locationSettings = AppleSettings(
  //       accuracy: LocationAccuracy.high,
  //       activityType: ActivityType.fitness,
  //       distanceFilter: 100,
  //       pauseLocationUpdatesAutomatically: true,
  //       // Only set to true if our app will be started up in the background.
  //       showBackgroundLocationIndicator: false,
  //     );
  //   } else {
  //     locationSettings = LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 100,
  //     );
  //   }
  //
  //   StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
  //           (Position position) async {
  //         print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
  //         lat = position.latitude;
  //         lng = position.longitude;
  //       });
  // }

  TextEditingController addressController = TextEditingController();
  TextEditingController addressController2 = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  FocusNode addressFocus = FocusNode();
  FocusNode addressFocus1 = FocusNode();
  FocusNode addressFocus2 = FocusNode();
  FocusNode postCodeFocus2 = FocusNode();
  FocusNode surgeryFocus = FocusNode();
  String username;
  String mobile;

  ApiCallFram _apiCallFram = ApiCallFram();

  String accessToken = "";

  @override
  void initState() {
    init();
    super.initState();
    // getLocationByClick();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Update Address",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey[400], blurRadius: 8, spreadRadius: 1, offset: Offset(0, 0))], color: Colors.orangeAccent, borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      username != null ? '${username[0].toUpperCase()}' : '',
                      style: TextStyle(color: Colors.white, fontSize: 27.0),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  username != null ? username : '',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.all(10.0),
                elevation: 3.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Update Address",
                          style: TextStyle(fontSize: 18.5, color: Colors.white),
                        ),
                      ),
                    ),
                    // ListTile(
                    //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    //   leading: Padding(
                    //       padding: const EdgeInsets.only(top: 0.0),
                    //       child: Icon(
                    //         Icons.person,
                    //         color: iconColor,
                    //       )),
                    //   // minVerticalPadding: 10.0,
                    //   title: Text(
                    //     username != null ? username : "",
                    //     style: TextStyle(fontSize: 15),
                    //   ),
                    // ),
                    // Divider(
                    //   height: 0,
                    //   thickness: 0,
                    //   endIndent: 10,
                    //   indent: 10,
                    // ),
                    // ListTile(
                    //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    //   leading: Padding(
                    //       padding: const EdgeInsets.only(top: 0.0),
                    //       child: Icon(
                    //         Icons.call,
                    //         color: iconColor,
                    //       )),
                    //   // minVerticalPadding: 10.0,
                    //   title: Text(
                    //     "N/A",
                    //     style: TextStyle(fontSize: 15),
                    //   ),
                    // ),
                    // Divider(
                    //   height: 0,
                    //   thickness: 0,
                    //   endIndent: 10,
                    //   indent: 10,
                    // ),
                    // ListTile(
                    //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    //   leading: Padding(
                    //     padding: const EdgeInsets.only(top: 0.0),
                    //     child: Text(
                    //       "Email",
                    //       style: TextStyle(
                    //           color: iconColor, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    //   // minVerticalPadding: 10.0,
                    //   title: Text(
                    //     "N/A",
                    //     style: TextStyle(fontSize: 15),
                    //   ),
                    // ),
                    // Divider(
                    //   height: 0,
                    //   thickness: 0,
                    //   endIndent: 10,
                    //   indent: 10,
                    // ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Address Line 1:*",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Column(
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 55,
                            child: InputLayoutWidiget(
                              enable: true,
                              focus: addressFocus,
                              maxLines: 1,
                              hintText: "Address Line 1",
                              textCapitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              textEditingController: addressController,
                              inputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0,
                      endIndent: 10,
                      indent: 10,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Address Line 2:",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Column(
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 55,
                            child: InputLayoutWidiget(
                              enable: true,
                              focus: addressFocus1,
                              maxLines: 1,
                              hintText: "Address Line 2",
                              textCapitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              textEditingController: addressController2,
                              inputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0,
                      endIndent: 10,
                      indent: 10,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Town Name:",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Column(
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 55,
                            child: InputLayoutWidiget(
                              enable: true,
                              focus: addressFocus2,
                              maxLines: 1,
                              hintText: "Town",
                              textCapitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              textEditingController: townController,
                              inputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0,
                      endIndent: 10,
                      indent: 10,
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Text(
                        "Post Code:*",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Column(
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 55,
                            child: InputLayoutWidiget(
                              enable: true,
                              focus: postCodeFocus2,
                              maxLines: 1,
                              hintText: "Post Code",
                              textCapitalization: TextCapitalization.words,
                              inputType: TextInputType.name,
                              textEditingController: postCodeController,
                              inputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 0,
                      endIndent: 10,
                      indent: 10,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 10.0),
                child: InkWell(
                  onTap: () {
                    if (addressController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Address Line 1");
                    } else if (postCodeController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter Postal Code");
                    } else {
                      // logger.i("USER CURRENT LOCATION IS IN EDIT PROFILE IS  " +lat.toString() + lng.toString());
                      updateAddressAPI();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10), boxShadow: [
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
                        "Update Address",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void init() async {
    await SharedPreferences.getInstance().then((value) {
      username = value.getString('name') ?? "";
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      setState(() {});
    });
    addressController.text = widget.address1 ?? "";
    addressController2.text = widget.address2 ?? "";
    townController.text = widget.townName ?? "";
    postCodeController.text = widget.postCode ?? "";
  }

  Future<void> updateAddressAPI() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }

    String url = "${WebConstant.GET_UPDATE_PROFILE_URL}?addressline1=${addressController.text}&addressline2=${addressController2.text}&town=${townController.text}&postcode=${postCodeController.text}";
    logger.i(accessToken);
    logger.i(url);
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    _apiCallFram.postFormDataAPI(url, accessToken, "", context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
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
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              ModalRoute.withName('/login_screen'));
          return;
        }
        if (response != null) {
          if (response != null && response.body != null) {
            Fluttertoast.showToast(msg: jsonDecode(response.body)["message"]);
            logger.i(response.body);
            if (!jsonDecode(response.body)["error"]) {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool(WebConstant.IS_ADDRESS_UPDATED, true);
              Navigator.pop(context);
            }
          } else {
            Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
          }
        } else {
          Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
      }
    }).catchError((onError, stackTrace) async {
      SentryExemption.sentryExemption(onError, stackTrace);
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      logger.i(onError);
    });
  }
}

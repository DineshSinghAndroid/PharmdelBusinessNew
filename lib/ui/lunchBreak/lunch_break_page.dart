import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/web_constent.dart';
import '../../main.dart';
import '../../util/connection_validater.dart';
import '../../util/custom_loading.dart';
import '../../util/permission_utils.dart';
import '../branch_admin_user_type/branch_admin_dashboard.dart';
import '../driver_user_type/dashboard_driver.dart';
import '../login_screen.dart';

class LunchBreakPage extends StatefulWidget {
  const LunchBreakPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LunchBreakPage> createState() => _LunchBreakPageState();
}

class _LunchBreakPageState extends State<LunchBreakPage> {
  Timer? countdownTimer;
  Duration myDuration = Duration(days: 1);

  String? token;

// final breakStartTime = CurrentRemainingTimeIS;

  @override
  void initState() {
    super.initState();


    getLocationData();
    init();
  }

  void init() async {
    await SharedPreferences.getInstance().then((value) async {
      token = value.getString('token') ?? "";
      logger.i("TOKEN $token");
      setState(() {
        _isLoading = true;
      });
      // logger.i(token);
    });
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
  }


// Step 4
// Step 5
// Step 6
// void setCountDown() {
//   final increaseby = 1;
//   setState(() {
//     final seconds = myDuration.inSeconds + increaseby;
//     if (seconds < 0) {
//       countdownTimer!.cancel();
//     } else {
//       myDuration = Duration(seconds: seconds);
//     }
//   });
// }
  double lat = 0.0;
  double lng = 0.0;
  int value = 0;

  bool _isLoading = true;

  getLocationData() async {
    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
      if (value == true) {
        var position = await GeolocatorPlatform.instance.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
        lat = position.latitude;
        lng = position.longitude;
        logger.i("Lat and long when lunch off by driver is :::::::::::::::::$lat ::: $lng");
      }
    });
  }

  Future updateBreakTime({required String lat, required String lng,
    required int statusCodee}) async {
    logger.i(":::::::::Status code from button click is " + statusCodee.toString() + ":::" + lat.toString() + ":::" +
        lng.toString());
    bool checkInternet = await ConnectionValidator().check();
    if (checkInternet) {
      // ProgressDialog(context, isDismissible: false).show();
      await CustomLoading().showLoadingDialog(context, true);
      final JsonDecoder _decoder = new JsonDecoder();
      Map<String, String> headers = {
        'Accept': 'application/json',
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };
      // logger.i(headers);
      // logger.i(userType == 'Pharmacy' || userType == "Pharmacy Staff" ? WebConstant
      //     .GET_LOGOUT_URL_PHARMACY : WebConstant.GET_LOGOUT_URL);
      Map<String, dynamic> data = {
        "lat": lat,
        "is_start": statusCodee,
        "lng": lng,
      };

      final response = await http.post(
          Uri.parse(WebConstant.UPDATE_BREAK_TIME), body: jsonEncode(data), headers: headers);
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      setState(() {
        _isLoading = false;
      });
      logger.i("UPDATE BREAK TIME RESPONSE from lunch break page  IS :::::::::::" + response.body.toString());
      logger.i("UPDATE BREAK TIME RESPONSE code IS :::::::::::" + response.statusCode.toString());

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        // if (data.containsKey("data")) {pharmacyId, branchId
        if (response.body == null) {
          _showSnackBar("No Data Found");
        } else if (response.body == "Success") {}
      } else if (response.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        prefs.remove('userId');
        prefs.remove('name');
        prefs.remove('email');
        prefs.remove('mobile');
        prefs.setBool(WebConstant.IS_LOGIN, false);
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
              return LoginScreen();
            },
                transitionsBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation, Widget child) {
                  return new SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                }),
                (Route route) => false);
      } else {
        _showSnackBar('Something went wrong');
      }
    } else {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inDays);
    // Step 7
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),

            Container(height: 200, width: double.infinity, child: Image.asset('assets/lunch.gif')),
            // Text(
            //   '$hours:$minutes:$seconds',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black,
            //       fontSize: 25),
            // ),
            SizedBox(
              height: 40,
            ),
            Text(
              'You are on Break',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.orange),
              child: MaterialButton(
                onPressed: () {
                  showDialog<ConfirmAction>(
                    context: context,
                    barrierDismissible: false, // user must tap button for close dialog!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('End Break'),
                        content: const Text('Are you sure to end break? '),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);

                              // logger.i(breakStartTime.toString());
                            },
                            child: Text("No"),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              bool? isUserOnbreak = prefs.getBool("UserOnBreak");
                              logger.i("Is user on break value from profile screen is coming $isUserOnbreak");

                              if (isUserOnbreak == true);
                              updateBreakTime(lng: lng.toString(), lat: lat.toString(), statusCodee: 0).then((value) {
                                prefs.setBool("UserOnBreak", false);

                                stopWatchTimer?.onStartTimer();

                                Future.delayed(
                                    Duration(seconds: 1),
                                        () =>
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DashboardDriver(0),
                                            ),
                                                (route) => false));

                                // );
                              });
                              ;
                            },
                            child: Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "End Break",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(),
            //   child: Column(
            //     children: [
            //       Container(
            //         height: 30,
            //         child: Text("Do you Know? "))
            //       ,
            //       Container(
            //         padding: EdgeInsets.symmetric(horizontal: 30),
            //         child: AnimatedTextKit(
            //           animatedTexts: [
            //             TypewriterAnimatedText(
            //               'We are oboarding 10+ new pharmacy everyday',
            //               speed: Duration(milliseconds: 150),
            //               textStyle: TextStyle(
            //                 fontSize: 016,
            //                 fontWeight: FontWeight.w400,
            //               ),
            //             ),
            //             TypewriterAnimatedText(
            //               'We are onboarding 60+ new drivers everyday',
            //               speed: Duration(milliseconds: 150),
            //               textStyle: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w400,
            //               ),
            //             ),
            //           ],
            //           isRepeatingAnimation: true,
            //           repeatForever: true,
            //           displayFullTextOnTap: true,
            //           stopPauseOnTap: false,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Spacer(),
            Text(
              "(Click 'End Break' button to get back to work)",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 12),
            ),

            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

void _showSnackBar(String text) {
  //  scaffoldKey.currentState
  //    .showSnackBar(new SnackBar(content: new Text(text)));
  Fluttertoast.showToast(msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

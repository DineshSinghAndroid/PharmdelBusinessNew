// @dart=2.9
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/lunchBreak/lunch_break_page.dart';
import 'package:pharmdel_business/ui/splash_screen.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'branch_admin_user_type/branch_admin_dashboard.dart';
import 'driver_user_type/dashboard_driver.dart';
import 'login_screen.dart';

class SecurePin extends StatefulWidget {
  bool isDialog = false;

  SecurePin(this.isDialog) : super();
  static const String ROUTE_ID = 'SecurePin';

  @override
  SecurePinState createState() => SecurePinState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SecurePinState extends State<SecurePin> {
  double ScreenHeight;
  TextEditingController controller1, controller2, controller3, controller4;

  //  controller5, controller6;
  List<String> _pin;
  FocusNode myFocusNode;
  String authKey;
  bool isAdLoaded = true;
  final key = UniqueKey();
  String deviceType = "";
  String deviceId;
  String deviceToken;
  String mobileNo = "";

  String userName = "";

  /// Biometric Authenticate Code

  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = false;
  List<BiometricType> availableBiometrics;
  bool authenticated = false;

  Future<void> checkBioMetricAvailable() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        try {
          availableBiometrics = await auth.getAvailableBiometrics();
        } catch (e) {
          logger.e("error enumerate biometrics $e");
        }

        logger.w("following biometrics are available");
        if (availableBiometrics.isNotEmpty) {
          availableBiometrics.forEach((ab) {
            logger.i("Avalible Biomatrics: $ab");
          });
        } else {
          logger.w("no biometrics are available");
        }
      }
    } catch (e) {
      logger.e("error biome trics $e");
    }

    logger.i("biometric is available: $canCheckBiometrics");
  }

  Future<void> loginViaFingerprint() async {
    try {
      print('i am called broooooooooo');
      authenticated = await auth.authenticate(
        localizedReason: 'Touch your finger on the sensor to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
          // androidAuthStrings:
          // AndroidAuthMessages(signInTitle: "Login to HomePage")
        ),
      );

      if (authenticated) {
        setLastTime();
        openHomeScreen(context);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        showDialog(
          context: context,
          builder: (_) => TouchAndFaceIdOverlay(),
        );
      }
      print('Exception : ${e.message} and code ${e.code}');
      Fluttertoast.showToast(msg: e.message);
    }
  }

  /// Biometric Authenticate Code

  @override
  void initState() {
    super.initState();
    _pin = List<String>(4);
    controller1 = TextEditingController(text: "");
    controller2 = TextEditingController(text: "");
    controller3 = TextEditingController(text: "");
    controller4 = TextEditingController(text: "");
    //   controller5 = TextEditingController(text: "");
    //   controller6 = TextEditingController(text: "");
    clearPin();
    myFocusNode = FocusNode();
    _loadauthentication();
    initPlatformState();
    checkBioMetricAvailable();
  }

  @override
  void dispose() {
    // print('test111');
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  _loadauthentication() async {}

  Future<void> initPlatformState() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.get(WebConstant.USER_NAME);
    setState(() {});
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
        deviceType = "a";
        deviceId = info.androidId;
        // print('device id............${deviceId.toString()}');
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
        deviceType = "i";
        deviceId = info.identifierForVendor;
        // print('device id............$deviceId');
        // print(await deviceInfoPlugin.iosInfo
        //   ..identifierForVendor);
      }
    } on PlatformException {
      // logger.e("Failed to get platform version.");
      Fluttertoast.showToast(msg: "Failed to get platform version.");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context1) {
            return new Stack(
                //alignment:new Alignment(x, y)
                children: <Widget>[
                  // Scaffold(
                  //     body: Container(
                  //         constraints: BoxConstraints(
                  //             minWidth: 100, minHeight: 50.0),
                  //         alignment: Alignment.topCenter,
                  //         child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: <Widget>[
                  //               Container(
                  //                   child: CustomPaint(
                  //                       painter: DrawCircle(
                  //                           _paint,
                  //                           .43 * screenWidth,
                  //                           Offset(-(.08 * screenWidth),
                  //                               .20 * screenWidth)))),
                  //               Container(
                  //                   child: CustomPaint(
                  //                       painter: DrawCircle(
                  //                           _paint2,
                  //                           .33 * screenWidth,
                  //                           Offset(.10 * screenWidth,
                  //                               .20 * screenWidth)))),
                  //             ]))),
                  new Positioned(
                      child: SingleChildScrollView(
                          child: Container(
                    padding: EdgeInsets.only(left: 0.05 * screenWidth, top: 0.01 * ScreenHeight, right: 0.05 * screenWidth, bottom: 0.01 * ScreenHeight),
                    child: Container(
                        padding: EdgeInsets.only(top: .16 * screenWidth),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(bottom: .01 * screenWidth, top: 10.0),
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 100,
                                )),
                            Container(
                                child: Text(
                              userName ?? "",
                              textAlign: TextAlign.center,
                              style: Bold20Style,
                            )),
//biomatric code
//                             Container(
//                                 padding: EdgeInsets.only(top: 10.0,bottom: 10),
//                                 child: Text(
//                                   "Tap to Login with Fingerprint",
//                                   textAlign: TextAlign.center,
//                                   style: Bold16Style,
//                                 )),

//                             InkWell(
//                               onTap: () async{
//                                 await loginViaFingerprint();
//                               },
//                               child: Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                     // color: Colors.black,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(color: Colors.black,width: 2)
//                                 ),
//                                 child: Center(
//                                   child: SvgPicture.asset('assets/fingure_id.svg',width: 50,height: 50,),
//                                 ),
//                               ),
//                             ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "Enter Secure Pin",
                                  textAlign: TextAlign.center,
                                  style: Bold16Style,
                                )),
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: screenWidth / 8,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: controller1,
                                        showCursor: false,
                                        readOnly: true,
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                        decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                      ),
                                    ),
                                    Container(
                                        width: screenWidth / 8,
                                        child: TextField(
                                          controller: controller2,
                                          showCursor: false,
                                          readOnly: true,
                                          enabled: false,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                          decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                        )),
                                    Container(
                                        width: screenWidth / 8,
                                        child: TextField(
                                          controller: controller3,
                                          showCursor: false,
                                          readOnly: true,
                                          enabled: false,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                          decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                        )),
                                    Container(
                                        width: screenWidth / 8,
                                        child: TextField(
                                          controller: controller4,
                                          showCursor: false,
                                          readOnly: true,
                                          enabled: false,
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                          decoration: InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                        )),
                                    // Container(
                                    //     width: screenWidth / 8,
                                    //     child: TextField(
                                    //       controller: controller5,
                                    //       showCursor: false,
                                    //       readOnly: true,
                                    //       enabled: false,
                                    //       textAlign: TextAlign.center,
                                    //       maxLength: 1,
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           color: Colors.black,
                                    //           fontSize: 20),
                                    //       decoration: InputDecoration(
                                    //           contentPadding: EdgeInsets
                                    //               .all(5.0),
                                    //           counterText: "",
                                    //           border: null),
                                    //     )),
                                    // Container(
                                    //     width: screenWidth / 8,
                                    //     child: TextField(
                                    //       controller: controller6,
                                    //       showCursor: false,
                                    //       readOnly: true,
                                    //       focusNode: null,
                                    //       enabled: false,
                                    //       textAlign: TextAlign.center,
                                    //       maxLength: 1,
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           color: Colors.black,
                                    //           fontSize: 20),
                                    //       decoration: InputDecoration(
                                    //           contentPadding: EdgeInsets
                                    //               .all(5.0),
                                    //           counterText: "",
                                    //           border: null),
                                    //     )),
                                  ],
                                )),
                            SizedBox(
                              height: 20.0,
                            ),
                            Column(children: <Widget>[
                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, mainAxisSize: MainAxisSize.max, children: <Widget>[
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '1');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("1", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: colorAccent,
                                                  width: 2,
                                                )),
                                          ))),
                                ),
                                SizedBox(
                                  width: 0.07 * screenWidth,
                                ),
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '2');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("2", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: colorAccent,
                                                  width: 2,
                                                )),
                                          ))),
                                ),
                                SizedBox(
                                  width: 0.07 * screenWidth,
                                ),
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '3');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("3", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: colorAccent,
                                                  width: 2,
                                                )),
                                          ))),
                                ),
                              ]),
                              SizedBox(
                                height: 0.02 * ScreenHeight,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: <Widget>[
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '4');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("4", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: colorAccent,
                                                  width: 2,
                                                )),
                                          ))),
                                ),
                                SizedBox(
                                  width: 0.07 * screenWidth,
                                ),
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '5');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("5", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: colorAccent,
                                                  width: 2,
                                                )),
                                          ))),
                                ),
                                SizedBox(
                                  width: 0.07 * screenWidth,
                                ),
                                new Flexible(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: new InkWell(
                                        onTap: () {
                                          setState(() {
                                            keyBoardClick(context1, '6');
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text("6", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: colorAccent,
                                                width: 2,
                                              )),
                                        )),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 0.02 * ScreenHeight,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: <Widget>[
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '7');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("7", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: colorAccent,
                                                  width: 2,
                                                )),
                                          ))),
                                ),
                                SizedBox(
                                  width: 0.07 * screenWidth,
                                ),
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '8');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("8", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: colorAccent,
                                                  width: 2,
                                                )),
                                          ))),
                                ),
                                SizedBox(
                                  width: 0.07 * screenWidth,
                                ),
                                new Flexible(
                                    child: Material(
                                        color: Colors.transparent,
                                        child: new InkWell(
                                            onTap: () {
                                              setState(() {
                                                keyBoardClick(context1, '9');
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text("9", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: colorAccent,
                                                    width: 2,
                                                  )),
                                            )))),
                              ]),
                              SizedBox(
                                height: 0.02 * ScreenHeight,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: <Widget>[
                                // new Flexible(
                                //   child: Material(
                                //       color: Colors.transparent,
                                //       child: new InkWell(
                                //           onTap: () {
                                //             openHomeScreen(context);
                                //           },
                                //           child: Container(
                                //             alignment: Alignment.center,
                                //             padding: const EdgeInsets
                                //                 .all(3.0),
                                //             child: Text(
                                //               "Home",
                                //               style: SemiBold16Style
                                //                   .copyWith(
                                //                   color: primaryTextColor),
                                //             ),
                                //             height: 40,
                                //             decoration: BoxDecoration(
                                //                 borderRadius: BorderRadius
                                //                     .all(
                                //                     Radius.circular(4)),
                                //                 shape: BoxShape
                                //                     .rectangle,
                                //                 border: Border.all(
                                //                   color: colorAccent,
                                //                   width: 2,
                                //                 )),
                                //           ))
                                //   ),
                                //     ),
                                // SizedBox(
                                //   width: 0.07 * screenWidth,
                                // ),
                                new Flexible(
                                    child: Material(
                                        color: Colors.transparent,
                                        child: new InkWell(
                                            onTap: () {
                                              setState(() {
                                                keyBoardClick(context1, '0');
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text("0", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: colorAccent,
                                                    width: 2,
                                                  )),
                                            )))),
                                SizedBox(
                                  width: 0.07 * screenWidth,
                                ),
                                new Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                        onTap: () {
                                          setState(() {
                                            clearPin();
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text("Del", style: SemiBold16Style.copyWith(color: primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: colorAccent,
                                                width: 2,
                                              )),
                                        ),
                                      )),
                                )
                              ]),
                            ]),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(
                                top: 0.02 * ScreenHeight,
                              ),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (widget.isDialog) {
                                          dialogShowing = false;
                                          Navigator.pop(context, true);
                                        }
                                        openSignInScreen(context, true);
                                      });
                                    },
                                    child: Text(
                                      "Forgot M-Pin?",
                                      textAlign: TextAlign.end,
                                      style: Regular16Style.copyWith(color: colorAccent),
                                    ),
                                  )),
                            ),
                            /* Container(
                        margin: EdgeInsets.only(
                          top: 0.02 * ScreenHeight,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: RaisedGradientButton(
                            child: Text(
                              'Login',
                              style: SemiBold16Style.copyWith(color: white_dim),
                            ),
                            height: 50,
                            color1: colorAccent,
                            color2: colorAccent,
                            onPressed: () {
                              openHomeScreen(context);
                            }),
                      ),*/
                            InkWell(
                              onTap: () async {
                                // setState(() {
                                if (widget.isDialog) {
                                  dialogShowing = false;
                                  Navigator.pop(context, true);
                                }
                                openSignInScreen(context, false);
                                //});
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 0.03 * ScreenHeight,
                                ),
                                child: Text(
                                  "Use different Account?",
                                  textAlign: TextAlign.center,
                                  style: Regular16Style.copyWith(color: colorAccent),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ))),
                ]);
          },
        ),
      ),
    );
  }

  static openHomeScreen(BuildContext context) async {
    // await Navigator.push(context, MaterialPageRoute(
    //   builder: (context) {
    //     return HomeScreen();
    //   },
    // ));
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    String userId = prefs.getString('userId') ?? "";
    String userType = prefs.getString(WebConstant.USER_TYPE);
    bool isUserOnbreak = prefs.getBool("UserOnBreak");
    logger.i("isUserOnbreak data on pin screen is ::::::::::::::::$isUserOnbreak");
    if (isUserOnbreak == true && userType == "Driver")
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
        LunchBreakPage();
        logger.i("Going to Lunch Break Screen");
      }), ModalRoute.withName('/login_screen'));
    else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => userType == "Driver" ? DashboardDriver(0) : BranchAdminDashboard(),
          ),
          ModalRoute.withName('/login_screen'));
    }
  }

  static openSignInScreen(BuildContext context, bool isFogot) async {
    // await Navigator.push(context, MaterialPageRoute(
    //   builder: (context) {
    //     return Signin();
    //   },
    // ));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
    prefs.setString('userId', "");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(
            pinSetup: isFogot,
          ),
        ),
        ModalRoute.withName('/login_screen'));
  }

  keyBoardClick(BuildContext context, String text) async {
    if (controller1 != null && controller1.text == "") {
      controller1 = TextEditingController(text: "•");
      _pin[0] = text;
    } else if (controller2 != null && controller2.text == "") {
      controller2 = TextEditingController(text: "•");
      _pin[1] = text;
    } else if (controller3 != null && controller3.text == "") {
      controller3 = TextEditingController(text: "•");
      _pin[2] = text;
      // } else if (controller4 != null && controller4.text == "") {
      //   controller4 = TextEditingController(text: "•");
      //   _pin[3] = text;
      // } else if (controller5 != null && controller5.text == "") {
      //   controller5 = TextEditingController(text: "•");
      //   _pin[4] = text;
    } else if (controller4 != null && controller4.text == "") {
      controller4 = TextEditingController(text: "•");
      _pin[3] = text;
      var enterdPin = new StringBuffer();
      for (var i = 0; i < _pin.length; i++) {
        enterdPin.write(_pin[i]);
      }

      // SignInApi(context);
      // if (enterdPin.toString() == '123456') {
      //   openHomeScreen(context);
      // } else {
      //   final snackBar = SnackBar(content: Text('Correct MPIN is : 123456',style: SemiBold18Style.copyWith(color: colorAccent),));
      //   Scaffold.of(context).showSnackBar(snackBar);
      // }
      final prefs = await SharedPreferences.getInstance();

      String strTempPin = prefs.get(WebConstant.kQuickPin);

      if (strTempPin == _pin.join()) {
        //SignInApi(context);
        if (widget.isDialog) {
          setLastTime();
          dialogShowing = false;
          Navigator.pop(context, true);
        } else {
          setLastTime();
          openHomeScreen(context);
        }
      } else {
        controller1.text = "";
        controller2.text = "";
        controller3.text = "";
        controller4.text = "";
        //   controller5.text = "";
        //   controller6.text = "";
        _pin[0] = "";
        _pin[1] = "";
        _pin[2] = "";
        _pin[3] = "";
        Fluttertoast.showToast(msg: 'Pin did not match');
      }
    } else {}
  }

  void clearPin() {
    // if (controller6 != null && controller6.text != "") {
    //   controller6 .text = "";
    //   _pin[5] = "";
    // } else if (controller5 != null && controller5.text != "") {
    //   controller5.text = "";
    //   _pin[4] = "";
    // } else
    if (controller4 != null && controller4.text != "") {
      controller4.text = "";
      _pin[3] = "";
    } else if (controller3 != null && controller3.text != "") {
      controller3.text = "";
      _pin[2] = "";
    } else if (controller2 != null && controller2.text != "") {
      controller2.text = "";
      _pin[1] = "";
    } else if (controller1 != null && controller1.text != "") {
      controller1.text = "";
      _pin[0] = "";
    } else {}
  }

  Future<bool> willPop() {
    SystemNavigator.pop();
  }
}

var _paint = Paint()
  ..color = colorAccent
  ..strokeWidth = 10.0
  ..style = PaintingStyle.fill;

var _paint2 = Paint()
  ..color = primaryColor
  ..strokeWidth = 10.0
  ..style = PaintingStyle.fill;

class DrawCircle extends CustomPainter {
  Paint _paint;
  double height;
  Offset offset;

  DrawCircle(Paint paint, double screenHeight, Offset offset) {
    this._paint = paint;
    this.height = screenHeight;
    this.offset = offset;
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    canvas.drawCircle(offset, height, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Widget _loader(BuildContext context, String url) => Center(
      child: CircularProgressIndicator(),
    );

Widget _error(BuildContext context, String url, dynamic error) {
  return Center(child: const Icon(Icons.error));
}

class TouchAndFaceIdOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TouchAndFaceIdOverlayState();
}

class TouchAndFaceIdOverlayState extends State<TouchAndFaceIdOverlay> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1700));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    //progressDialog = new ProgressDialog(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    /*progressDialog.style(
        message: "Please wait...",
        borderRadius: 4.0,
        backgroundColor: Colors.white);*/
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 330.0,
              decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  new Text(
                    "touch or Face Id is not activated on your device!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 0,
                  ),

                  // Row(
                  //   children: [
                  //     Column(
                  //       children: [
                  //         SvgPicture.asset("assets/face_id.svg"),
                  //         Text('Face Id')
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         Container(
                  //             width: 40,
                  //             child: SvgPicture.asset("assets/fingure_id.svg")),
                  //         Text('Face Id')
                  //       ],
                  //     )
                  //   ],
                  // ),

                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Padding(
                      //     padding: const EdgeInsets.only(
                      //         left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                      //     child: SizedBox(
                      //         height: 35.0,
                      //         width: 110.0,
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             backgroundColor: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(5.0)),
                      //           ),
                      //           child: Text(
                      //             'Activate',
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //                 color: Colors.grey,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 13.0),
                      //           ),
                      //           onPressed: () {
                      //             AppSettings.openLockAndPasswordSettings();
                      //           },
                      //         ))),
                      Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: SizedBox(
                              height: 35.0,
                              width: 110.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                ),
                                child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13.0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ))),
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: SizedBox(
                      //       height: 35.0,
                      //       width: 110.0,
                      //       child: ElevatedButton(
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.white,
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(5.0)),
                      //         ),
                      //         child: Text(
                      //           'Submit',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //               color: yetToStartColor,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 13.0),
                      //         ),
                      //         onPressed: () {
                      //           forgotpass();
                      //         },
                      //       )),
                      // ),
                    ],
                  )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

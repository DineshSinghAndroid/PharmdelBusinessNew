
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pharmdel/Controller/Helper/PrintLog/PrintLog.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/Helper/TextController/FontFamily/FontFamily.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import '../../../Controller/Helper/Colors/custom_color.dart';
import '../../../Controller/Helper/TextController/FontStyle/FontStyle.dart';
import '../../../Controller/Helper/TouchAndFaceOverlay/touchAndFaceOverlay.dart';
import '../../../Controller/WidgetController/Toast/ToastCustom.dart';
import '../../../main.dart';


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
  double? ScreenHeight;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  //  controller5, controller6;
  List<String>? _pin;
  FocusNode? myFocusNode;
  String? authKey;
  bool isAdLoaded = true;
  final key = UniqueKey();
  String? deviceType = "";
  String? deviceId;
  String? deviceToken;
  String mobileNo = "";

  String userName = "";
  bool dialogShowing = false;
  /// Biometric Authenticate Code

  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = false;
  List<BiometricType>? availableBiometrics;
  bool authenticated = false;


  @override
  void initState() {
    super.initState();
    // _pin = List<String>(4);
    controller1 = TextEditingController(text: "");
    controller2 = TextEditingController(text: "");
    controller3 = TextEditingController(text: "");
    controller4 = TextEditingController(text: "");
    //   controller5 = TextEditingController(text: "");
    //   controller6 = TextEditingController(text: "");
    // clearPin();
    myFocusNode = FocusNode();
    _loadauthentication();
    // initPlatformState();
    // checkBioMetricAvailable();
  }

  @override
  void dispose() {
    // print('test111');
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    myFocusNode?.dispose();
    super.dispose();
  }

  _loadauthentication() async {}

  @override
  Widget build(BuildContext context) {
    ScreenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Builder(
        builder: (BuildContext context1) {
          return Stack(
              //alignment:new Alignment(x, y)
              children: <Widget>[                 
                     Positioned(
                    child: SingleChildScrollView(
                        child: Container(
                  padding: EdgeInsets.only(left: 0.05 * screenWidth, top: 0.01 * ScreenHeight!, right: 0.05 * screenWidth, bottom: 0.01 * ScreenHeight!),
                  child: Container(
                      padding: EdgeInsets.only(top: .16 * screenWidth),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(bottom: .01 * screenWidth, top: 10.0),
                              child: Image.asset(
                                strimg_logo,
                                height: 100,
                              )),
                          BuildText.buildText(
                            text:  userName ?? "",
                            size: 20,
                            fontFamily: FontFamily.NexaBold                             
                          ),
                          buildSizeBox(20.0, 0.0),                         
                          Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: BuildText.buildText(
                                text:  kEnterSecurePin,                                  
                                size: 16,
                                fontFamily: FontFamily.NexaBold
                              )),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
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
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                      decoration: const InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                    ),
                                  ),
                                  SizedBox(
                                      width: screenWidth / 8,
                                      child: TextField(
                                        controller: controller2,
                                        showCursor: false,
                                        readOnly: true,
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                        decoration: const InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                      )),
                                  SizedBox(
                                      width: screenWidth / 8,
                                      child: TextField(
                                        controller: controller3,
                                        showCursor: false,
                                        readOnly: true,
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                        decoration: const InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                      )),
                                  SizedBox(
                                      width: screenWidth / 8,
                                      child: TextField(
                                        controller: controller4,
                                        showCursor: false,
                                        readOnly: true,
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                                        decoration: const InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
                                      )),                                    
                                ],
                              )),
                              buildSizeBox(20.0, 0.0),                         
                          Column(children: <Widget>[
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, mainAxisSize: MainAxisSize.max, children: <Widget>[
                                 Flexible(
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
                                          child: BuildText.buildText(
                                            text:  "1", 
                                            fontFamily: FontFamily.nexabold,
                                            size: 16 ,
                                            // style: SemiBold16Style.copyWith(color: primaryTextColor)
                                            ),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: AppColors.colorAccent,
                                                width: 2,
                                              )),
                                        ))),
                              ),
                             buildSizeBox(0.0, 0.07 * screenWidth,),
                                 Flexible(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            keyBoardClick(context1, '2');
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          child: BuildText.buildText(
                                           text:  "2",
                                           style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: AppColors.colorAccent,
                                                width: 2,
                                              )),
                                        ))),
                              ),
                             buildSizeBox(0.0, 0.07 * screenWidth,),
                               Flexible(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            keyBoardClick(context1, '3');
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          child: BuildText.buildText(
                                           text:  "3", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: AppColors.colorAccent,
                                                width: 2,
                                              )),
                                        ))),
                              ),
                            ]),
                            buildSizeBox(0.02 * ScreenHeight!, 0.0),
                            ///
                            Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: <Widget>[
                              Flexible(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            keyBoardClick(context1, '4');
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          child: BuildText.buildText(
                                           text:  "4", 
                                           style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: AppColors.colorAccent,
                                                width: 2,
                                              )),
                                        ))),
                              ),
                             buildSizeBox(0.0, 0.07 * screenWidth,),
                              Flexible(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            keyBoardClick(context1, '5');
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          child: BuildText.buildText(
                                           text:  "5", 
                                           style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: AppColors.colorAccent,
                                                width: 2,
                                              )),
                                        ))),
                              ),
                             buildSizeBox(0.0, 0.07 * screenWidth,),
                               Flexible(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          keyBoardClick(context1, '6');
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(3.0),
                                        child: BuildText.buildText(
                                         text:  "6", 
                                         style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: AppColors.colorAccent,
                                              width: 2,
                                            )),
                                      )),
                                ),
                              ),
                            ]),
                            buildSizeBox(0.02 * ScreenHeight!,0.0),                            
                            Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: <Widget>[
                              Flexible(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            keyBoardClick(context1, '7');
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          child: BuildText.buildText(
                                           text:  "7", 
                                           style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: AppColors.colorAccent,
                                                width: 2,
                                              )),
                                        ))),
                              ),
                              buildSizeBox(0.0, 0.07 * screenWidth,),
                               Flexible(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            keyBoardClick(context1, '8');
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          child: BuildText.buildText(
                                           text:  "8", 
                                           style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: AppColors.colorAccent,
                                                width: 2,
                                              )),
                                        ))),
                              ),
                             buildSizeBox(0.0, 0.07 * screenWidth,),
                             Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '9');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3.0),
                                            child: BuildText.buildText(
                                             text:  "9", 
                                             style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: AppColors.colorAccent,
                                                  width: 2,
                                                )),
                                          )))),
                            ]),
                           buildSizeBox(0.02 * ScreenHeight!, 0.0),
                            Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: <Widget>[                                
                               Flexible(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              keyBoardClick(context1, '0');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: BuildText.buildText(
                                             text:  "0", 
                                             style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: AppColors.colorAccent,
                                                  width: 2,
                                                )),
                                          )))),
                             buildSizeBox(0.0, 0.07 * screenWidth,),
                               Flexible(
                                child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          clearPin();
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: BuildText.buildText(
                                         text:  "Del", 
                                         style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: AppColors.colorAccent,
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
                              top: 0.02 * ScreenHeight!,
                            ),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(setupPinScreenRoute);
                                    setState(() {                                      
                                      // if (widget.isDialog) {
                                      //   dialogShowing = false;
                                      //   Navigator.pop(context, true);
                                      // }
                                      // openSignInScreen(context, true);
                                    });
                                  },
                                  child: Text(
                                    kForgotMPIN,
                                    textAlign: TextAlign.end,
                                    style: Regular16Style.copyWith(color: AppColors.colorAccent),
                                  ),
                                )),
                          ),                     
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
                                top: 0.03 * ScreenHeight!,
                              ),
                              child: Text(
                                kusediffAcc,
                                textAlign: TextAlign.center,
                                style: Regular16Style.copyWith(color: AppColors.colorAccent),
                              ),
                            ),
                          ),
                        ],
                      )),
                ))),
              ]);
        },
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
    String? userType = prefs.getString(kUSERTYPE);
    bool? isUserOnbreak = prefs.getBool("UserOnBreak");
    logger.i("isUserOnbreak data on pin screen is ::::::::::::::::$isUserOnbreak");
    if (isUserOnbreak == true && userType == "Driver"){
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>
      //     LunchBreakPage()),
      //      ModalRoute.withName('/login_screen'));
    }
    else {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => userType == "Driver" ? DashboardDriver(0) : BranchAdminDashboard(),
      //     ),
      //     ModalRoute.withName('/login_screen'));
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
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => LoginScreen(
    //         pinSetup: isFogot,
    //       ),
    //     ),
    //     ModalRoute.withName('/login_screen'));
  }

  keyBoardClick(BuildContext context, String text) async {
    if (controller1 != null && controller1.text == "") {
      controller1 = TextEditingController(text: "•");
      _pin![0] = text;
    } else if (controller2 != null && controller2.text == "") {
      controller2 = TextEditingController(text: "•");
      _pin![1] = text;
    } else if (controller3 != null && controller3.text == "") {
      controller3 = TextEditingController(text: "•");
      _pin![2] = text;
      // } else if (controller4 != null && controller4.text == "") {
      //   controller4 = TextEditingController(text: "•");
      //   _pin[3] = text;
      // } else if (controller5 != null && controller5.text == "") {
      //   controller5 = TextEditingController(text: "•");
      //   _pin[4] = text;
    } else if (controller4 != null && controller4.text == "") {
      controller4 = TextEditingController(text: "•");
      _pin![3] = text;
      var enterdPin = new StringBuffer();
      for (var i = 0; i < _pin!.length; i++) {
        enterdPin.write(_pin![i]);
      }

      // SignInApi(context);
      // if (enterdPin.toString() == '123456') {
      //   openHomeScreen(context);
      // } else {
      //   final snackBar = SnackBar(content: Text('Correct MPIN is : 123456',style: SemiBold18Style.copyWith(color: colorAccent),));
      //   Scaffold.of(context).showSnackBar(snackBar);
      // }
      final prefs = await SharedPreferences.getInstance();

      Object? strTempPin = prefs.get(kQuickPin);

      if (strTempPin == _pin!.join()) {
        //SignInApi(context);
        if (widget.isDialog) {
          // setLastTime();
          dialogShowing = false;
          Navigator.pop(context, true);
        } else {
          // setLastTime();
          // openHomeScreen(context);
        }
      } else {
        controller1.text = "";
        controller2.text = "";
        controller3.text = "";
        controller4.text = "";
        //   controller5.text = "";
        //   controller6.text = "";
        _pin![0] = "";
        _pin![1] = "";
        _pin![2] = "";
        _pin![3] = "";
        ToastCustom.showToast(msg: kPinDidNotMatch);
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
      _pin![3] = "";
    } else if (controller3 != null && controller3.text != "") {
      controller3.text = "";
      _pin![2] = "";
    } else if (controller2 != null && controller2.text != "") {
      controller2.text = "";
      _pin![1] = "";
    } else if (controller1 != null && controller1.text != "") {
      controller1.text = "";
      _pin![0] = "";
    } else {}
  }

  // Future<void> initPlatformState() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   userName = prefs.get(kUserName);
  //   setState(() {});
  //   DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   try {
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
  //       deviceType = "a";
  //       deviceId = info.androidId;
  //       // print('device id............${deviceId.toString()}');
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
  //       deviceType = "i";
  //       deviceId = info.identifierForVendor;
  //       // print('device id............$deviceId');
  //       // print(await deviceInfoPlugin.iosInfo
  //       //   ..identifierForVendor);
  //     }
  //   } on PlatformException {
  //     // logger.e("Failed to get platform version.");      
  //     ToastCustom.showToast(msg:  "Failed to get platform version.");
  //   }
  // }

  /// Login with Fingerprint
  Future<void> loginViaFingerprint() async {
    try {
      PrintLog.printLog('i am called broooooooooo');
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
        // setLastTime();
        openHomeScreen(context);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        showDialog(
          context: context,
          builder: (_) => const TouchAndFaceIdOverlay(),
        );
      }
      PrintLog.printLog('Exception : ${e.message} and code ${e.code}');      
      ToastCustom.showToast(msg:  e.message!);
    }
  }

  /// Biometric Authenticate Code
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
        if (availableBiometrics!.isNotEmpty) {
          availableBiometrics?.forEach((ab) {
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

  Future<bool>? willPop() {
    SystemNavigator.pop();
  }
}

// var _paint = Paint()
//   ..color = AppColors.colorAccent
//   ..strokeWidth = 10.0
//   ..style = PaintingStyle.fill;

// var _paint2 = Paint()
//   ..color =  AppColors.primaryColor
//   ..strokeWidth = 10.0
//   ..style = PaintingStyle.fill;



Widget _loader(BuildContext context, String url) => const Center(
      child: CircularProgressIndicator(),
    );

Widget _error(BuildContext context, String url, dynamic error) {
  return const Center(child: Icon(Icons.error));
}



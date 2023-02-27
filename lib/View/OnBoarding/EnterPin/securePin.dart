// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/Helper/TextController/FontFamily/FontFamily.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Controller/Helper/Colors/custom_color.dart';
import '../../../Controller/Helper/Shared Preferences/SharedPreferences.dart';
import '../../../Controller/Helper/TextController/FontStyle/FontStyle.dart';
import '../../../Controller/WidgetController/Toast/ToastCustom.dart';

class SecurePin extends StatefulWidget {
  bool isDialog = false;

  SecurePin({super.key});

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
    controller1 = TextEditingController(text: "");
    controller2 = TextEditingController(text: "");
    controller3 = TextEditingController(text: "");
    controller4 = TextEditingController(text: "");

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    myFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Builder(
        builder: (BuildContext context1) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildSizeBox(50.0, 0.0),
                Image.asset(
                  strimg_logo,
                  height: 100,
                ),
                BuildText.buildText(text: userName, size: 20, fontFamily: FontFamily.NexaBold),
                buildSizeBox(20.0, 0.0),
                BuildText.buildText(text: kEnterSecurePin, size: 16, fontFamily: FontFamily.NexaBold),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    pinBox(screenWidth, controller1),
                    pinBox(screenWidth, controller2),
                    pinBox(screenWidth, controller3),
                    pinBox(screenWidth, controller4),
                  ],
                ),
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
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: AppColors.colorAccent,
                                      width: 2,
                                    )),
                                child: BuildText.buildText(
                                  text: "1",
                                  fontFamily: FontFamily.nexabold,
                                  size: 16,
                                  // style: SemiBold16Style.copyWith(color: primaryTextColor)
                                ),
                              ))),
                    ),
                    buildSizeBox(
                      0.0,
                      0.07 * screenWidth,
                    ),
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
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: AppColors.colorAccent,
                                      width: 2,
                                    )),
                                child: BuildText.buildText(text: "2", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                              ))),
                    ),
                    buildSizeBox(
                      0.0,
                      0.07 * screenWidth,
                    ),
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
                                child: BuildText.buildText(text: "3", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
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
                                child: BuildText.buildText(text: "4", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
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
                    buildSizeBox(
                      0.0,
                      0.07 * screenWidth,
                    ),
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
                                child: BuildText.buildText(text: "5", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
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
                    buildSizeBox(
                      0.0,
                      0.07 * screenWidth,
                    ),
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
                              child: BuildText.buildText(text: "6", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
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
                  buildSizeBox(0.02 * ScreenHeight!, 0.0),
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
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: AppColors.colorAccent,
                                      width: 2,
                                    )),
                                child: BuildText.buildText(text: "7", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                              ))),
                    ),
                    buildSizeBox(
                      0.0,
                      0.07 * screenWidth,
                    ),
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
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: AppColors.colorAccent,
                                      width: 2,
                                    )),
                                child: BuildText.buildText(text: "8", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                              ))),
                    ),
                    buildSizeBox(
                      0.0,
                      0.07 * screenWidth,
                    ),
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
                                  child: BuildText.buildText(text: "9", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
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
                                  child: BuildText.buildText(text: "0", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: AppColors.colorAccent,
                                        width: 2,
                                      )),
                                )))),
                    buildSizeBox(
                      0.0,
                      0.07 * screenWidth,
                    ),
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
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: AppColors.colorAccent,
                                    width: 2,
                                  )),
                              child: BuildText.buildText(text: "Del", style: SemiBold16Style.copyWith(color: AppColors.primaryTextColor)),
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
                  onTap: () {
                    Navigator.pop(context, true);
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
            ),
          );
        },
      ),
    );
  }

  SizedBox pinBox(double screenWidth, controllers) {
    return SizedBox(
        width: screenWidth / 8,
        child: TextField(
          controller: controllers,
          showCursor: false,
          readOnly: true,
          enabled: false,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          decoration: const InputDecoration(contentPadding: EdgeInsets.all(5.0), counterText: "", border: null),
        ));
  }

  keyBoardClick(BuildContext context, String text) async {
    if (controller1.text == "") {
      controller1 = TextEditingController(text: "•");
      _pin![0] = text;
    } else if (controller2.text == "") {
      controller2 = TextEditingController(text: "•");
      _pin![1] = text;
    } else if (controller3.text == "") {
      controller3 = TextEditingController(text: "•");
      _pin![2] = text;
      // } else if (controller4 != null && controller4.text == "") {
      //   controller4 = TextEditingController(text: "•");
      //   _pin[3] = text;
      // } else if (controller5 != null && controller5.text == "") {
      //   controller5 = TextEditingController(text: "•");
      //   _pin[4] = text;
    } else if (controller4.text == "") {
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

      Object? strTempPin = prefs.get(AppSharedPreferences.userPin);

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
    if (controller4.text != "") {
      controller4.text = "";
      _pin![3] = "";
    } else if (controller3.text != "") {
      controller3.text = "";
      _pin![2] = "";
    } else if (controller2.text != "") {
      controller2.text = "";
      _pin![1] = "";
    } else if (controller1.text != "") {
      controller1.text = "";
      _pin![0] = "";
    } else {}
  }
}

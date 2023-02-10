// @dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/ui/secure_pin.dart';
import 'package:pharmdel_business/util/RaisedGradientButton.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/custom_loading.dart';
import 'branch_admin_user_type/branch_admin_dashboard.dart';
import 'driver_user_type/dashboard_driver.dart';

class SetupPin extends StatefulWidget {
  //SetupPin() : super();
  final bool isChangePassword;
  static const String ROUTE_ID = 'SetupPin';
  final bool isFromSetting;

  SetupPin({Key key, @required this.isChangePassword, this.isFromSetting}) : super(key: key);

  @override
  SetupPinState createState() => SetupPinState();
}

class SetupPinState extends State<SetupPin> {
  double ScreenHeight;
  TextEditingController txtOldPin = TextEditingController();
  TextEditingController txtEnterOtp = TextEditingController();
  TextEditingController txtConfirmOtp = TextEditingController();
  bool isOld = true, isNew = true, isConfirm = true;
  FocusNode myFocusNode;
  String authKey;
  var focusPin = FocusNode();
  var focusConfirmPin = FocusNode();
  ApiCallFram _apiCallFram = ApiCallFram();

  var respons;

  // bool isCorrectPin;
  @override
  void initState() {
    super.initState();
    _loadauthentication();
    myFocusNode = FocusNode();
    SharedPreferences.getInstance().then((value) {
      authKey = value.getString(WebConstant.ACCESS_TOKEN);
      // logger.i("route1");
    });
  }

  _loadauthentication() async {
    final prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    ScreenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var checkedValue = false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Stack(
            //alignment:new Alignment(x, y)
            children: <Widget>[
              // Scaffold(
              //
              //   body: Container(
              //       constraints: BoxConstraints(minWidth: 100, minHeight: 50.0),
              //       alignment: Alignment.topCenter,
              //       child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: <Widget>[
              //             Container(
              //                 child: CustomPaint(painter: DrawCircle(_paint, .43*screenWidth, Offset(-(.08*screenWidth),.20*screenWidth)))),
              //
              //             Container(
              //                 child: CustomPaint(painter: DrawCircle(_paint2, .33*screenWidth, Offset(.10*screenWidth,.20*screenWidth)))),
              //
              //           ]))),

              new Positioned(
                  child: SingleChildScrollView(
                      child: Container(
                padding: EdgeInsets.only(left: 0.05 * screenWidth, top: 0.01 * ScreenHeight, right: 0.05 * screenWidth, bottom: 0.01 * ScreenHeight),
                child: Container(
                    padding: EdgeInsets.only(top: .16 * screenWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(bottom: .22 * screenWidth, top: 10.0),
                            child: Image.asset(
                              'assets/logo.png',
                              height: 100,
                            )),
                        // Card(
                        //   shadowColor: colorAccent,
                        //   child: CircleAvatar(
                        //     radius: .14*screenWidth,
                        //     backgroundColor: colorAccent,
                        //     backgroundImage:
                        //     AssetImage('assets/logo.png'),
                        //   ),
                        //   shape: CircleBorder(),
                        //   elevation: 10.0,
                        //   // shape: CircleBorder(),
                        //   clipBehavior: Clip.antiAlias,
                        // )),
                        Container(
                            child: widget.isChangePassword
                                ? Text(
                                    "Change Quick Access Pin",
                                    textAlign: TextAlign.center,
                                    style: Bold20Style,
                                  )
                                : Text(
                                    "Setup Quick Access Pin",
                                    textAlign: TextAlign.center,
                                    style: Bold20Style,
                                  )),
                        SizedBox(
                          height: 20,
                        ),
                        // Visibility(
                        //   child: Row(
                        // children: [
                        Container(
                          child: widget.isChangePassword
                              ? SizedBox(
                                  height: 70.0,
                                  child: TextFormField(
                                    controller: txtOldPin,
                                    maxLength: 4,
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                    style: SemiBold16Style,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context).requestFocus(focusPin);
                                    },
                                    decoration: InputDecoration(
                                      // icon: Icon(CupertinoIcons.down_arrow),
                                      labelText: "Enter Old Pin",
                                      labelStyle: Light14Style.copyWith(color: hintTextColor),
                                      errorText: !isOld ? "Old pin can\'t be empty or less than four digits" : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      ),
                                      //contentPadding: EdgeInsets.all(10),
                                    ),
                                  ))
                              : SizedBox.shrink(),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          height: 70.0,
                          //width: 80.0,
                          child: TextFormField(
                            controller: txtEnterOtp,
                            focusNode: focusPin,
                            maxLength: 4,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            style: SemiBold16Style,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focusConfirmPin);
                            },
                            decoration: InputDecoration(
                              // icon: Icon(CupertinoIcons.down_arrow),
                              labelText: "Enter Secure Pin",
                              labelStyle: Light14Style.copyWith(color: hintTextColor),
                              errorText: !isNew ? "${txtEnterOtp.text != txtConfirmOtp.text && txtEnterOtp.text.length == 4 ? "Secure Pin doesn\'t match" : "Secure pin can\'t be empty or less than four digits"}" : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                              //contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          height: 70.0,
                          child: TextFormField(
                            controller: txtConfirmOtp,
                            focusNode: focusConfirmPin,
                            maxLength: 4,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            style: SemiBold16Style,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              // icon: Icon(CupertinoIcons.down_arrow),
                              labelText: "Confirm Secure Pin",
                              labelStyle: Light14Style.copyWith(color: hintTextColor),
                              errorText: !isConfirm ? "${txtEnterOtp.text != txtConfirmOtp.text && txtConfirmOtp.text.length == 4 ? "Secure Pin doesn\'t match" : "Confirm secure  pin can\'t be empty or less than four digits"}" : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                              //contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
                          width: MediaQuery.of(context).size.width,
                          child: RaisedGradientButton(
                              child: widget.isChangePassword
                                  ? Text(
                                      'Change Pin',
                                      style: SemiBold16Style.copyWith(color: white_dim),
                                    )
                                  : Text(
                                      'Done',
                                      style: SemiBold16Style.copyWith(color: white_dim),
                                    ),
                              height: 50,
                              color1: colorAccent,
                              color2: colorAccent,
                              onPressed: () async {
                                myFocusNode.requestFocus();
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isOld = true;
                                  isNew = true;
                                  isConfirm = true;
                                });
                                if (widget.isChangePassword && (txtOldPin.text == "" || txtOldPin.text.length < 4)) {
                                  setState(() {
                                    isOld = false;
                                  });
                                } else if (txtEnterOtp.text == "" || txtEnterOtp.text.length < 4) {
                                  setState(() {
                                    isNew = false;
                                  });
                                } else if (txtConfirmOtp.text == "" || txtConfirmOtp.text.length < 4) {
                                  setState(() {
                                    isConfirm = false;
                                  });
                                } else if (txtEnterOtp.text != txtConfirmOtp.text) {
                                  setState(() {
                                    isNew = false;
                                    isConfirm = false;
                                  });
                                } else {
                                  if (txtConfirmOtp.text.contains(".") || txtConfirmOtp.text.contains(",") || txtConfirmOtp.text.contains("-")) {
                                    Fluttertoast.showToast(msg: 'Please enter digit Pin');
                                  } else {
                                    final prefs = await SharedPreferences.getInstance();
                                    var strPin = prefs.get(WebConstant.kQuickPin);
                                    if (widget.isChangePassword) {
                                      if (strPin != txtOldPin.text) {
                                        Fluttertoast.showToast(msg: 'Old pin not correct');
                                      } else {
                                        setUpPin();
                                      }
                                    } else {
                                      if (txtEnterOtp.text != txtConfirmOtp.text) {
                                        Fluttertoast.showToast(msg: 'Secure pin does not match');
                                      } else {
                                        setUpPin();
                                      }
                                    }
                                  }
                                  //}

                                }
                              }),
                        ),
                        Visibility(
                          visible: !widget.isChangePassword,
                          child: InkWell(
                            onTap: () async {
                              //setState(() {

                              openSignInScreen(context);
                              //});
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 0),
                              child: Text(
                                "Cancel",
                                textAlign: TextAlign.center,
                                style: Regular16Style.copyWith(color: colorAccent),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ))),
            ]),
      ),
      // bottomNavigationBar: Container(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       AnimatedContainer(
      //         width: screenWidth,
      //         duration: Duration(seconds: 2),
      //         curve: Curves.easeIn,
      //         child: Material(
      //           child: InkWell(
      //             onTap: () {
      //               setState(() {
      //                 // sideLength == 100 ? sideLength = 200 : sideLength = 100;
      //                 dashboardScreen(context);
      //               });
      //             },
      //             child: new Padding(
      //               padding: new EdgeInsets.all(15.0),
      //               child: new Text(
      //                 "SKIP",
      //                 textAlign: TextAlign.center,
      //                 style: Bold20Style.copyWith(color: colorAccent),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  static openSecurePinScreen(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SecurePin(false);
      },
    ));
  }

  static openSignInScreen(BuildContext context) async {
    //  Navigator.push(context, MaterialPageRoute(
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
          builder: (BuildContext context) => LoginScreen(),
        ),
        ModalRoute.withName('/login_screen'));
  }

  dashboardScreen(BuildContext context) async {
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) {
    //     return HomeScreen();
    //   },
    // ));

    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    String userId = prefs.getString('userId') ?? "";
    String userType = prefs.getString(WebConstant.USER_TYPE);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => userType == "Driver" ? DashboardDriver(0) : BranchAdminDashboard(),
        ),
        ModalRoute.withName('/login_screen'));
  }

  void setUpPin() async {
    // Map<String, String> dictParam = {"quickPin" : txtConfirmOtp.text};

    // print( authKey);
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    String url = WebConstant.SETPIV_DRIVER + "?pin=" + txtConfirmOtp.text.trim();
    _apiCallFram.postFormDataAPI(url, authKey, "", context).then((responce) async {
      // ProgressDialog(context, isDismissible: false).hide();
      await CustomLoading().showLoadingDialog(context, false);
      if (responce != null && responce.body != null && responce.body == "Unauthenticated") {
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
      } else {
        respons = json.decode(responce.body);
        if (respons["error"] == false) {
          final prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey(WebConstant.kQuickPin)) {
            prefs.remove(WebConstant.kQuickPin);
          }
          prefs.setBool(WebConstant.IS_LOGIN, true);
          Fluttertoast.showToast(msg: "Pin set successfully");
          prefs.setString(WebConstant.kQuickPin, txtConfirmOtp.text);
          dashboardScreen(context);
        } else {
          // print(respons["message"]);
          Fluttertoast.showToast(msg: respons["message"]);
        }
        // EasyLoading.dismiss();
      }
    });
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

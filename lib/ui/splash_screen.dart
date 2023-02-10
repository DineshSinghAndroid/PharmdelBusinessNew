// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/presenter/login_screen_presenter.dart';
import 'package:pharmdel_business/ui/driver_user_type/dashboard_driver.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/ui/secure_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/AuthState.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'branch_admin_user_type/branch_admin_dashboard.dart';

const CameraAccessDenied = 'PERMISSION_NOT_GRANTED';

enum ConfirmActionSplash { CANCEL, ACCEPT }

bool dialogShowing = false;

/// method channel.
// const MethodChannel _channel = const MethodChannel('qr_scan');

/// Scanning Bar Code or QR Code return content
// Future<String> scan() async => await _channel.invokeMethod('scan');

/// Scanning Photo Bar Code or QR Code return content
// Future<String> scanPhoto() async => await _channel.invokeMethod('scan_photo');

// Scanning the image of the specified path
// Future<String> scanPath(String path) async {
//   assert(path != null && path.isNotEmpty);
//   Fluttertoast.showToast(
//       msg: "This is Center Short Toast",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIos: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
//   return await _channel.invokeMethod('scan_path', {"path": path});
// }
//
// // Parse to code string with uint8list
// Future<String> scanBytes(Uint8List uint8list) async {
//   assert(uint8list != null && uint8list.isNotEmpty);
//   return await _channel.invokeMethod('scan_bytes', {"bytes": uint8list});
// }
//
// /// Generating Bar Code Uint8List
// Future<Uint8List> generateBarCode(String code) async {
//   assert(code != null && code.isNotEmpty);
//   return await _channel.invokeMethod('generate_barcode', {"code": code});
// }

class SplashScreen extends StatefulWidget {
  static String tag = 'login-screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;
  Future<File> imageFile;
  double opacity = 0.0;
  String userId, token, userType;
  bool _isLoading = true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldMessengerState>();
  String _username, _password;

  LoginScreenPresenter _presenter;

  bool isLogin = false;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);

    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _submit() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        ModalRoute.withName('/login_screen'));
    /* final form = formKey.currentState;
    if (form.validate()) {
      progressDialog.show();
      // setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }*/
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  void init() async {
    // FirebaseCrashlytics.instance.crash();

    try {
      new Future.delayed(const Duration(seconds: 3), () {
        checkState();
      });
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      _asyncConfirmDialog(e.toString());
    }
  }

  void checkState() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    userType = prefs.getString(WebConstant.USER_TYPE);
    isLogin = prefs.getBool(WebConstant.IS_LOGIN) != null ? prefs.getBool(WebConstant.IS_LOGIN) : false;
    if (userId != null && userId.isNotEmpty && isLogin) {
      // global.streamController.close();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SecurePin(false),
          ),
          ModalRoute.withName('/login_screen'));
    } else {
      //        setState(() {
      //          opacity = 1.0;
      //        });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
          ModalRoute.withName('/login_screen'));
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    setState(() {
      opacity = 1.0;
    });
    // FirebaseCrashlytics.instance.crash();
    init();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black, statusBarBrightness: Brightness.light));*/
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // var db = new DatabaseHelper();
    //var list = db.getAll();
    // List<User> list = db.getAll() as List<User>;
    // Fluttertoast.showToast(msg: "w", toastLength: Toast.LENGTH_LONG);

    var logo = new Column(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: new SizedBox(
              height: 150,
              child: Image.asset('assets/logo.png'),
            ))
      ],
    );

    var loginForm = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        logo,
        new Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 40.0),
            child: new Text("",
                style: new TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                textScaleFactor: 2.0,
                textAlign: TextAlign.center)),
        new Form(
            key: formKey,
            child: new Column(children: <Widget>[
              //loginBtn,
              /* showImage(),
            RaisedButton(
              child: Text("Select Image from Gallery"),
              onPressed: () {
                pickImageFromGallery(ImageSource.gallery);
              },
            ),*/
            ])),
        // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
      ],
    );

    return new Scaffold(
        appBar: null,
        key: scaffoldKey,
        body: new Center(
          child: SafeArea(
              child: SingleChildScrollView(
                  child: new Center(
                      //height: double.infinity,
                      //color: Colors.white,
                      // child: new Center(
                      child: new Column(
            children: <Widget>[
              new AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 1000),
                  child: new Align(
                    alignment: Alignment.center,
                    child: loginForm,
                  )
                  //),,
                  ),
              _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
            ],
          )))),
          /* child: SingleChildScrollView(
            child: new Center(
                //height: double.infinity,
                //color: Colors.white,
                // child: new Center(
                child: new Align(
              alignment: Alignment.center,
              child: loginForm,
            )
                //),
                ),
          ),*/
        ));
  }

  void _asyncConfirmDialog(String message) {
    showDialog<ConfirmActionSplash>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(_ctx);
              },
            ),
          ],
        );
      },
    );
    // Navigator.pop(context, true);
  }

  @override
  Future<void> onLoginError(String errorTxt) async {
    _showSnackBar(errorTxt);
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    //setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(Map<String, Object> user) async {
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    // _showSnackBar(user.toString());
    //setState(() => _isLoading = false);
    // var db = new DatabaseHelper();
    var status = user['status'];
    var uName = user['name'];
    if (status == 'true') {
      // global.streamController.close();
      // Navigator.of(_ctx).pushNamed(HomePage.tag);
      // Navigator.push(_ctx, MaterialPageRoute(builder: (context) => HomePage()));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => user["userType"] == "Driver" ? DashboardDriver(0) : BranchAdminDashboard(),
          ),
          ModalRoute.withName('/login_screen'));
      /* var authStateProvider = new AuthStateProvider();
        authStateProvider.notify(AuthState.LOGGED_IN);*/
      // _showSnackBar("Login success");
    }
  }
}

Future<void> setLastTime() async {
  final prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  prefs.setInt(WebConstant.USER_LASTTIME, now.millisecondsSinceEpoch);
}

Future<void> checkLastTime(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  int time = prefs.getInt(WebConstant.USER_LASTTIME);

  DateTime dt = time != null ? DateTime.fromMillisecondsSinceEpoch(time) : DateTime.now();
  DateTime dateNow = DateTime.now();
  final difference = dateNow.difference(dt).inMinutes;
  if (difference < 30) {
    setLastTime();
  } else {
    if (!dialogShowing) {
      dialogShowing = true;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context1) {
            return WillPopScope(onWillPop: () async => false, child: SecurePin(true));
            //
            // return WillPopScope(
            //   onWillPop: () async => true,
            //   child: Scaffold(
            //     body: Container(
            //       height: 500,
            //       padding: EdgeInsets.only(left: 20,top: 45, right: 20,bottom: 20),
            //       margin: EdgeInsets.only(top: 45),
            //       decoration: BoxDecoration(
            //           shape: BoxShape.rectangle,
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(20),
            //           boxShadow: [
            //             BoxShadow(color: Colors.black,offset: Offset(0,10),
            //                 blurRadius: 10
            //             ),
            //           ]
            //       ),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         mainAxisSize: MainAxisSize.max,
            //         children: <Widget>[
            //           Text("Security PIN",style: TextStyle(fontSize: 20),),
            //           SizedBox(height: 15,),
            //           TextFormField(
            //             controller: controller1,
            //             maxLength: 4,
            //             obscureText: true,
            //             keyboardType: TextInputType.number,
            //             style: SemiBold16Style,
            //             textInputAction: TextInputAction.next,
            //             onFieldSubmitted: (v){
            //               // FocusScope.of(context).requestFocus(focusConfirmPin);
            //             },
            //             decoration: InputDecoration(
            //               // icon: Icon(CupertinoIcons.down_arrow),
            //               labelText: "Enter Secure Pin",
            //               labelStyle:
            //               Light14Style.copyWith(color: hintTextColor),
            //               // errorText: !isNew ? "${txtEnterOtp.text != txtConfirmOtp.text  && txtEnterOtp.text.length == 4 ? "Secure Pin doesn\'t match" : "Secure pin can\'t be empty or less than four digits"}" : null,
            //               border: OutlineInputBorder(
            //                 borderRadius:
            //                 BorderRadius.all(Radius.circular(30.0)),
            //               ),
            //               //contentPadding: EdgeInsets.all(10),
            //
            //             ),
            //           ),
            //           SizedBox(height: 22,),
            //           Align(
            //             alignment: Alignment.bottomRight,
            //             child: FlatButton(
            //                 onPressed: (){
            //
            //                 },
            //                 child: Text("Confirm",style: TextStyle(fontSize: 18),)),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // );
          });
    }
  }
}

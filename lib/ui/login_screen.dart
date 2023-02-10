// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:pharmdel_business/DB/MyDatabase.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/User.dart';
import 'package:pharmdel_business/presenter/login_screen_presenter.dart';
import 'package:pharmdel_business/ui/secure_pin.dart';
import 'package:pharmdel_business/ui/setup_pin.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:pharmdel_business/util/pdf_viwer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../data/AuthState.dart';
import '../model/vehicle_info_api_model.dart';
import '../util/CustomDialogBox.dart';
 import '../util/custom_camera_screen.dart';
import '../util/custom_loading.dart';
import '../util/permission_utils.dart';
import '../util/sentryExeptionHendler.dart';
import '../util/toast_utils.dart';
import 'branch_admin_user_type/branch_admin_dashboard.dart';

const CameraAccessDenied = 'PERMISSION_NOT_GRANTED';

/// method channel.
const MethodChannel _channel = const MethodChannel('qr_scan');

/// Scanning Bar Code or QR Code return content
Future<String> scan() async => await _channel.invokeMethod('scan');

/// Scanning Photo Bar Code or QR Code return content
Future<String> scanPhoto() async => await _channel.invokeMethod('scan_photo');

// Scanning the image of the specified path

// Parse to code string with uint8list
Future<String> scanBytes(Uint8List uint8list) async {
  assert(uint8list != null && uint8list.isNotEmpty);
  return await _channel.invokeMethod('scan_bytes', {"bytes": uint8list});
}

/// Generating Bar Code Uint8List
Future<Uint8List> generateBarCode(String code) async {
  assert(code != null && code.isNotEmpty);
  return await _channel.invokeMethod('generate_barcode', {"code": code});
}

TextEditingController _passwordController = TextEditingController(text: "");
bool _savePassword = true;
TextEditingController _emailController = TextEditingController(text: "");
final _storage = const FlutterSecureStorage();

Future<void> _readFromStorage() async {
  _emailController.text = await _storage.read(key: "KEY_USERNAME") ?? '';
  _passwordController.text = await _storage.read(key: "KEY_PASSWORD") ?? '';
}

class LoginScreen extends StatefulWidget {
  static String tag = 'login-screen';
  bool pinSetup = false;

  LoginScreen({this.pinSetup});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> implements LoginScreenContract, AuthStateListener {
  loc.PermissionStatus _permissionGranted;
  loc.Location location;
  BuildContext _ctx;
  Future<File> imageFile;
  double opacity = 0.0;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;

  LoginScreenPresenter _presenter;

  BuildContext context1;

  ApiCallFram _apiCallFram = ApiCallFram();

  double lat = 0.0;
  double lng = 0.0;

  // List<VehicleData> vehicleList = [];

  String accessToken = "";

  // VehicleData selectedVehicle = VehicleData();

  Future<void> updateStartMiles(BuildContext context1, Map<String, dynamic> user, Map<String, dynamic> prams) async {
    print(prams['start_miles']);
    print(prams['vehicle_id']);

    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.UPDATE_MILES);
    logger.i(prams);
    _apiCallFram.postDataAPI(WebConstant.UPDATE_MILES, user['token'], prams, context).then((response) async {
      // ProgressDialog(context,isDismissible: false).hide();
      await CustomLoading().showLoadingDialog(context, false);
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
      try {
        if (response != null) {
          var data = json.decode(response.body);
          logger.i("response: ${response.body}");
          if (data["status"] == true || data["status"] == 'true') {
            Navigator.pop(context1);
            final prefs = await SharedPreferences.getInstance();
            prefs.setString(WebConstant.START_MILES, prams['start_miles'].toString());
            //vehicle id dk
            prefs.setString(WebConstant.VEHICLE_ID, prams['vehicle_id'].toString());
            String dk = prefs.getString(WebConstant.VEHICLE_ID);
            print("VEHILCE ID GOING TO NEXT SCREEN IS " + dk);
            openScreen(user);
          } else {
            // ProgressDialog(context).hide();
            await CustomLoading().showLoadingDialog(context, false);
            ToastUtils.showCustomToast(context, "${data["message"]}, Please try again !");
          }
        }
      } catch (e) {
        logger.i(e.toString());
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
      }
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
    }, onError: (error, stackTrace) async {
      // ProgressDialog(context).hide();
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // logger.i("error : " + error.toString());
      ToastUtils.showCustomToast(context, "Please try again !");
      //   isDelivery = true;
      //
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //         builder: (BuildContext context) => DashboardDriver(),
      //       ),
      //       ModalRoute.withName('/signature'));
      //
      //
    });
  }

  redirecttoBrowser(String Url) async {
    var url = '$Url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //ProgressDialog progressDialog;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  String fcmToken = "";

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  void _submit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      // if(!showvalue){
      //   Fluttertoast.showToast(msg: "Accept our Terms & Conditions & Privacy Policy");
      //   return;
      // }
      bool checkInternet = await ConnectionValidator().check();
      // print(checkInternet);
      if (checkInternet) {
        // ProgressDialog(context1, isDismissible: true)
        //     .show()
        await CustomLoading().showLoadingDialog(context, true).then((value) async {
          form.save();
          try {
            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            if (Platform.isAndroid) {
              AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
              // print('Running on ${androidInfo.model}');
              _presenter.doLogin(_username, _password, androidInfo.model, fcmToken);
              // await getVehicleInfo();
            } else if (Platform.isIOS) {
              IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
              // print('Running on ${iosInfo.utsname.machine}');
              _presenter.doLogin(_username, _password, iosInfo.utsname.machine, fcmToken);
              // await getVehicleInfo();
            }
          } on PlatformException {
            // ProgressDialog(context1, isDismissible: false).hide();
            await CustomLoading().showLoadingDialog(context, false);
          }
        });
        // setState(() => _isLoading = true);
      } else {
        _showSnackBar("Something went wrong, Failed connection with server.");
      }
    }
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
    /* scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));*/
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  void init() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    // var db = new DatabaseHelper();
    // var isLoggedIn = await db.isLoggedIn();
    // new Future.delayed(const Duration(seconds: 2), () {
    //   if (isLoggedIn) {
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(
    //           builder: (BuildContext context) => BranchAdminDashboard(),
    //         ),
    //         ModalRoute.withName('/login_screen'));
    //   } else {
    //     setState(() {
    //       opacity = 1.0;
    //     });
    //   }
    // });
  }

  @override
  Future<void> initState() {
    super.initState();
    _readFromStorage();
    context1 = context;
    getLocationData();
    init();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  // }
  VehicleData selectedVehicle = VehicleData();
  List<VehicleData> vehicleList = [];

  getLocationData() async {
    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
      if (value) {
        var position = await GeolocatorPlatform.instance
            .getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
        lat = position.latitude;
        lng = position.longitude;
        logger.i("latitute and longitute is" + lat.toString() + lng.toString());
      }
    });
  }

  bool _passwodObscureEye = true;

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    /* progressDialog = new ProgressDialog(context);*/

    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black, statusBarBrightness: Brightness.light));*/
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    //var db = new DatabaseHelper();
    //var list = db.getAll();
    // List<User> list = db.getAll() as List<User>;
    // Fluttertoast.showToast(msg: "w", toastLength: Toast.LENGTH_LONG);

    /*progressDialog.style(
        message: "Please wait...",
        borderRadius: 4.0,
        backgroundColor: Colors.white);*/
    final focus = FocusNode();

    /// submit button
    var loginBtn = new SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: new ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).requestFocus(focus);
          if (_savePassword) {
            // Write values
            await _storage.write(key: "KEY_USERNAME", value: _emailController.text);
            await _storage.write(key: "KEY_PASSWORD", value: _passwordController.text);
          }
          location = loc.Location();
          _permissionGranted  = await location.hasPermission();
          print("Test::::::::::${_permissionGranted}");

          if (_permissionGranted != null) {
            if (_permissionGranted == loc.PermissionStatus.granted) {
              _submit();
            } else {
              showDialog(
                context: context,
                builder: (_) => PermissionDeniedOverlay(),
              );
            }
          }
        },
        child: new Text(
          "CONTINUE",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.yetToStartColor,
          foregroundColor: Colors.white.withOpacity(0.4),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(35.0),
          ),
        ),
      ),
    );

    /// forgot password widget
    var bottomButtons = new Column(
      children: <Widget>[
        new SizedBox(
          child: Container(
            margin: const EdgeInsets.only(top: 0.0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                // new TextButton(
                //   onPressed: () {
                //     // Navigator.of(context).pushNamed(SignupPage.tag);
                //     showDialog(
                //       context: context,
                //       builder: (_) => TouchAndFaceIdOverlay(),
                //     );
                //   },
                //   style: TextButton.styleFrom(
                //     padding: EdgeInsets.all(1),
                //   ),
                //   child: new Text(
                //     "Login using touch/Face Id",
                //     style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black,
                //         fontFamily: "Nexa"),
                //   ),
                // ),

                new TextButton(
                  onPressed: () {
                    logger.i("Cliced on forgot password button");
                    // Navigator.of(context).pushNamed(SignupPage.tag);
                    showDialog(
                      context: context,
                      builder: (_) => LogoutOverlay(),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(12),
                  ),
                  child: new Text(
                    "Forgot Password?",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: "Nexa"),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );

    /// login form widget

    var loginForm = new Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: new TextFormField(
                controller: _emailController,
                // autofillHints: [AutofillHints.email],
                onSaved: (val) => _username = val,
                validator: (val) {
                  return val.trim().isEmpty ? "Enter valid mail" : null;
                },
                //initialValue: "badger2020010101@gmail.com",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,

                decoration: new InputDecoration(
                    filled: true,
                    fillColor: greyDim,
                    hintText: "Email",
                    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    // fillColor: Colors.white,
                    focusedBorder: new OutlineInputBorder(
                        borderSide: BorderSide(color: greylight),
                        borderRadius: const BorderRadius.all(const Radius.circular(35.0))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greylight),
                        borderRadius: const BorderRadius.all(const Radius.circular(35.0))),
                    border: new OutlineInputBorder(
                        borderSide: BorderSide(color: greylight),
                        borderRadius: const BorderRadius.all(const Radius.circular(35.0)))),
                onFieldSubmitted: (v) {},
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: new TextFormField(
                controller: _passwordController,
                onSaved: (val) => _password = val,
                keyboardType: TextInputType.visiblePassword,
                autofocus: false,
                // focusNode: focus,
                obscureText: _passwodObscureEye,
                validator: (val) {
                  return val.trim().isEmpty ? "Enter password" : null;
                },
                //initialValue: "Pdm@12345",
                decoration: new InputDecoration(
                  // suffixIcon: IconButton(
                  //   icon: Icon(_passwodObscureEye == true
                  //       ? Icons.visibility_off
                  //       : Icons.visibility),
                  //   onPressed: () {
                  //     setState(() {
                  //       _passwodObscureEye = !_passwodObscureEye;
                  //     });
                  //   },
                  // ),
                  filled: true,
                  fillColor: greyDim,
                  hintText: "Password",
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: greylight),
                      borderRadius: const BorderRadius.all(const Radius.circular(35.0))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greylight),
                      borderRadius: const BorderRadius.all(const Radius.circular(35.0))),
                  border: new OutlineInputBorder(
                      borderSide: BorderSide(color: greylight),
                      borderRadius: const BorderRadius.all(const Radius.circular(35.0))),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Checkbox(
                    visualDensity: VisualDensity(vertical: -4.0),
                    activeColor: CustomColors.yetToStartColor,
                    value: _savePassword,
                    onChanged: (bool value) {
                      setState(() {
                        _savePassword = value;
                      });
                    },
                  ),
                  Text("Remember me")
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20.0, top: 10.02),
              child: loginBtn,
            ),
            bottomButtons,

            /* showImage(),
            RaisedButton(
              child: Text("Select Image from Gallery"),
              onPressed: () {
                pickImageFromGallery(ImageSource.gallery);
              },
            ),*/
          ]),
        ),
        // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
      ],
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewScreen()));
                    },
                    child: Text(
                      "How to guide",
                      style: TextStyle(
                        fontSize: 22.0,
                        shadows: [
                          Shadow(
                            color: Colors.red,
                            offset: Offset(0, -5),
                          )
                        ],
                        color: Colors.transparent,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                        decorationThickness: 1,
                      ),
                    ),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0, right: 0),
            padding: EdgeInsets.all(20),
            child: Text.rich(TextSpan(
                text: 'By continuing, you agree to our ',
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          redirecttoBrowser(WebConstant.TERMS_URL);
                        }),
                  TextSpan(text: ' and ', style: TextStyle(fontSize: 18, color: Colors.black), children: <TextSpan>[
                    TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(fontSize: 18, color: Colors.black, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            redirecttoBrowser(WebConstant.PRIVACY_URL);
                          })
                  ])
                ])),
          ),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Container(
                height: 120,
                width: 120,
                child: FittedBox(
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ),
              ),
              // ),

              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: "Nexa"),
                    ),
                    // new Center(
                    //   child: SafeArea(
                    //   //  child: SingleChildScrollView(
                    //       child: Column(
                    //
                    //         children: <Widget>[
                    //
                    //
                    //           // SizedBox(
                    //           //   height: 230,
                    //           //   width: 0,
                    //           // ),
                    //           new Center(
                    //             //height: double.infinity,
                    //             //color: Colors.white,
                    //              child: new Center(
                    //               //child: new Align(
                    //                // alignment: Alignment.center,
                    //                 child: loginForm,
                    //               //)
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     //),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 25,
                      ),
                      child: loginForm,
                      //)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> onLoginError(String errorTxt) async {
    // ProgressDialog(context1, isDismissible: true).hide();
    await CustomLoading().showLoadingDialog(context, false);
    _showSnackBar(errorTxt);

    //setState(() => _isLoading = false);
  }

//old seprate commented by dk on 6 feb 2023
//   Future<void> showStartMilesDialog(Map<String, Object> user) async {
//     logger.i("asdfs");
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
//               img: Image.asset("assets/delivery_truck.png"),
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
//                 onPressed: () {
//                   if (startMilesController.text.toString().toString() == null ||
//                       startMilesController.text.toString().toString().isEmpty) {
//                     Fluttertoast.showToast(msg: "Enter Start Miles");
//                   } else if (_image == null) {
//                     Fluttertoast.showToast(msg: "Take Speedometer Picture");
//                   } else {
//                     Map<String, dynamic> prams = {
//                       "entry_type": "start",
//                       "start_miles": int.tryParse(startMilesController.text.toString().trim()),
//                       "end_miles": 0,
//                       "end_miles_image": "",
//                       "lat": "$lat",
//                       "lng": "$lng",
//                       "vehicle_id": selectedVehicle.id.toString(),
//                       "start_mile_image": base64Image != null && base64Image.isNotEmpty ? base64Image : "",
//                     };
//                     updateStartMiles(context, user, prams);
//                   }
//                 },
//                 child: Text("Okay", style: TextStyle(fontSize: 18.0, color: Colors.black)),
//               ),
//               button1: TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   final prefs = await SharedPreferences.getInstance();
//                   await prefs.setInt('vehicleId', selectedVehicle.id);
//                   openScreen(user);
//                   setState(() {});
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
//                 inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
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
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()))
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
//                   // if(vehicleList != null && vehicleList.isNotEmpty)
//                   // Text("Choose Vehicle", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),),
//                   // // Row(
//                   // //   children: [
//                   // //     Checkbox(
//                   // //       value: checkIdCar,
//                   // //       visualDensity: VisualDensity(vertical: -4, horizontal: -4),
//                   // //       onChanged: (value){
//                   // //         checkIdBike = false;
//                   // //         checkIdCar = value;
//                   // //         setStat(() {});setState(() {});
//                   // //       },
//                   // //     ),
//                   // //     Text("Car", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
//                   // //   ],
//                   // // ),
//                   // // if(checkIdCar && vehicleList != null && vehicleList.isNotEmpty)
//                   // // Container(
//                   // //   height: 30.0,
//                   // //   child: ListView.builder(
//                   // //     itemCount: vehicleList.length,
//                   // //     shrinkWrap: true,
//                   // //     scrollDirection: Axis.horizontal,
//                   // //     itemBuilder: (context, index) {
//                   // //       return Padding(
//                   // //         padding: const EdgeInsets.only(left: 20.0),
//                   // //         child: Row(
//                   // //           children: [
//                   // //             Radio(
//                   // //               value: index,
//                   // //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   // //               groupValue: carId,
//                   // //               visualDensity: VisualDensity(vertical: -4, horizontal: -4),
//                   // //               onChanged: (value){
//                   // //                 setStat(() {
//                   // //                   carId = value;
//                   // //                 });
//                   // //                 setState(() {});
//                   // //               },
//                   // //             ),
//                   // //             Text(vehicleList[index].vehicleType ?? ""),
//                   // //           ],
//                   // //         ),
//                   // //       );
//                   // //     }),
//                   // // ),
//                   // // Row(
//                   // //   children: [
//                   // //     Checkbox(
//                   // //       value: checkIdBike,
//                   // //       visualDensity: VisualDensity(vertical: -4, horizontal: -4),
//                   // //       onChanged: (value){
//                   // //         checkIdCar = false;
//                   // //         carId = -1;
//                   // //         checkIdBike = value;
//                   // //         setState(() {});setStat(() {});
//                   // //       },
//                   // //     ),
//                   // //     Text("Bike", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
//                   // //   ],
//                   // // ),
//                   // // if(checkIdBike || carId >= 0)
//                   // // SizedBox(
//                   // //   height: 5.0,
//                   // // ),
//                   // // if(checkIdBike || carId >= 0)
//                   // // Row(
//                   // //   children: [
//                   // //     Text("Registration No.: ", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),),
//                   // //     Text("1235262", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
//                   // //   ],
//                   // // ),
//                   // if(vehicleList != null && vehicleList.isNotEmpty)
//                   // Padding(
//                   //   padding: const EdgeInsets.all(4.0),
//                   //   child: Container(
//                   //     decoration: BoxDecoration(
//                   //         border: Border.all(color: Colors.grey[700]),
//                   //         borderRadius: BorderRadius.circular(50.0)
//                   //     ),
//                   //     child: DropdownButtonHideUnderline(
//                   //       child: ButtonTheme(
//                   //         alignedDropdown: true,
//                   //         padding: EdgeInsets.zero,
//                   //         child: DropdownButton<VehicleData>(
//                   //           isExpanded: true,
//                   //           value: selectedVehicle,
//                   //           icon: Icon(Icons.arrow_drop_down),
//                   //           iconSize: 24,
//                   //           elevation: 16,
//                   //           style: TextStyle(color: Colors.black),
//                   //           underline: Container(
//                   //             height: 2,
//                   //             color: Colors.black,
//                   //           ),
//                   //           onChanged: (VehicleData newValue) {
//                   //             setStat(() {
//                   //               selectedVehicle = newValue;
//                   //             });
//                   //           },
//                   //           items: vehicleList
//                   //               .map<DropdownMenuItem<VehicleData>>(
//                   //                   (VehicleData value) {
//                   //                 return DropdownMenuItem<VehicleData>(
//                   //                   value: value != null ? value : null,
//                   //                   child: Container(
//                   //                     height: 45.0,
//                   //                     width: MediaQuery.of(context).size.width,
//                   //                     alignment: Alignment.centerLeft,
//                   //                     child: Padding(
//                   //                       padding: const EdgeInsets.only(left: 0.0),
//                   //                       child: Text(
//                   //                         "${value.name != null && value.name.isNotEmpty ? value.name : ""}  ${value.modal != null && value.modal.isNotEmpty ?" - " + value.modal : ""} ${value.regNo != null && value.regNo.isNotEmpty ? " - " + value.regNo : ""} ${value.color != null && value.color.isNotEmpty ? " - " + value.color : ""}".toUpperCase(),
//                   //                         style: TextStyle(color: Colors.black),
//                   //                       ),
//                   //                     ),
//                   //                   ),
//                   //                 );
//                   //               }).toList(),
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   SizedBox(
//                     height: 5.0,
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }

  // Future<void> getVehicleInfo() async {
  //   bool checkInternet = await ConnectionValidator().check();
  //   if (!checkInternet) {
  //     return;
  //   }
  //   vehicleList.clear();
  //   await CustomLoading().showLoadingDialog(context, true);
  //   await _apiCallFram
  //       .getDataRequestAPI(
  //       WebConstant.GET_VEHICLE_INFO, accessToken, context)
  //       .then((response) async {
  //     await CustomLoading().showLoadingDialog(context, false);
  //     // progressDialog.hide();
  //     logger.i(WebConstant.GET_VEHICLE_INFO);
  //     logger.i(accessToken);
  //     logger.i(response.body);
  //     // await CustomLoading().showLoadingDialog(context, true);
  //     await CustomLoading().showLoadingDialog(context, false);
  //     try {
  //       if (response != null &&
  //           response.body != null &&
  //           response.body == "Unauthenticated") {
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
  //         if(response != null){
  //           GetVehicleInfoApiResponse model = GetVehicleInfoApiResponse.fromJson(json.decode(response.body));
  //           if(model != null){
  //               if(model.vehicleData != null && model.vehicleData.isNotEmpty){
  //                 if(model.vehicleData.length > 1) {
  //                   selectedVehicle.id = 0;
  //                   selectedVehicle.name = "Please Select Vehicle";
  //                   selectedVehicle.color = "";
  //                   selectedVehicle.vehicleType = "";
  //                   selectedVehicle.modal = "";
  //                   selectedVehicle.regNo = "";
  //                   vehicleList.add(selectedVehicle);
  //                 }else{
  //                   selectedVehicle = model.vehicleData[0];
  //                 }
  //                   vehicleList.addAll(model.vehicleData);
  //                 setState(() {});
  //               }
  //           }
  //         }
  //       } catch (_,stackTrace) {
  //         // print(_);
  //         SentryExemption.sentryExemption(_, stackTrace);
  //         logger.i(_);
  //         Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
  //         // progressDialog.hide();
  //         await CustomLoading().showLoadingDialog(context, false);
  //         // await CustomLoading().showLoadingDialog(context, true);
  //       }
  //     } catch (_,stackTrace) {
  //       logger.i(_);
  //       SentryExemption.sentryExemption(_, stackTrace);
  //       // print(_);
  //       await CustomLoading().showLoadingDialog(context, false);
  //       Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
  //     }
  //   });
  // }

  @override
  void onLoginSuccess(Map<String, Object> user) async {
    // ProgressDialog(context1).hide();
    await CustomLoading().showLoadingDialog(context, false);
    // _showSnackBar(user.toString());
    //setState(() => _isLoading = false);
    // var db = new DatabaseHelper();
    logger.i("userData at login ====>>>>>>>>>>: $user");
    var status = user['status'];
    var uName = user['message'];
    try {
      if (status == true) {
        String userId = user['userId'].toString();
        String startMile = user['start_miles'] != null ? user['start_miles'].toString() : "";
        String endMile = user['end_miles'] != null ? user['end_miles'].toString() : "";
        bool showPopUp = user['show_wages'] != null
            ? user['show_wages'] == 1
                ? true
                : false
            : false;

        String token = user['token'].toString();
        String name = user['name'].toString();
        String email = user['email'].toString();
        String mobile = user['mobile'].toString();
        String userType = user["userType"].toString();
        String branchId = user["branchId"].toString();
        String pharmacyId = user["pharmacy_id"] != null ? user["pharmacy_id"].toString() : "";
        String driver_type = user["driver_type"].toString();
        bool isStartRoute = user["isStartRoute"];
        bool isAddressUpdated = user["isAddressUpdated"] != null ? user["isAddressUpdated"] : false;
        String routeId = user["routeId"].toString();
        accessToken = token;

        User u = new User(userId, token, name, email, mobile, userType);
        // await db.saveUser(u);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(WebConstant.ACCESS_TOKEN, token);
        prefs.setString(WebConstant.USER_ID, userId);
        prefs.setString(WebConstant.DRIVER_TYPE, driver_type);
        prefs.setString(WebConstant.USER_NAME, name);
        prefs.setString(WebConstant.USER_EMAIL, email);
        prefs.setString(WebConstant.USER_MOBILE, mobile);
        prefs.setString(WebConstant.USER_TYPE, userType);
        prefs.setString(WebConstant.BRANCH_ID, branchId);
        prefs.setBool(WebConstant.IS_ROUTE_START, isStartRoute);
        prefs.setBool(WebConstant.IS_ADDRESS_UPDATED, isAddressUpdated);
        prefs.setString(WebConstant.ROUTE_ID, routeId);
        prefs.setString(WebConstant.START_MILES, startMile);
        prefs.setString(WebConstant.END_MILES, endMile);
        prefs.setString(WebConstant.PHARMACY_ID_FOR_SOCKET, pharmacyId);
        prefs.setBool(WebConstant.SHOW_POPUP, showPopUp);
        prefs.setBool(WebConstant.IS_LOGIN, false);

        await MyDatabase().deleteToken();
        TokenCompanion tokenssss = TokenCompanion.insert(token: token);
        await MyDatabase().insertToken(tokenssss);
        var value = await MyDatabase().getAllOutForDeliverysOnly();

        if (value != null && value.isNotEmpty) {
          if (userId != value[0].userId) {
            logger.i("clearing Delivery Table.....");
            await clearDliveryTable();
          }
        }
//show vechile selection dialouge

        // await getVehicleInfo().then((value) {
        //   if (vehicleList != null && vehicleList.isNotEmpty)
        //     showVehiclePopup(user);
        //    else{
        //      openScreen(user);
        //   }
        // });
        if (user["show_wages"] == 1 && (user["start_miles"] == null || user["start_miles"] == "")) {
          await getVehicleInfo().then((value) {
            if (vehicleList != null && vehicleList.isNotEmpty)
              showVehiclePopup(user);
            else {
              openScreen(user);
            }
          });
        } else {
          logger.i("openScreen.....");
          openScreen(user);
        }

        // if(user["show_wages"] == 1 && (user["start_miles"] == null
        //     || user["start_miles"] == "")){
        //   // await getVehicleInfo().then((value) {
        //   logger.i("show vechile selection dialouge.....");
        //     showStartMilesDialog(user);
        //   // });
        // }else{
        //   logger.i("openScreen.....");
        //   openScreen(user);
        // }
        //
        // if(user["show_wages"] == 1 && (user["start_miles"] == null
        //     || user["start_miles"] == "")){
        //   // await getVehicleInfo().then((value) {
        //   logger.i("showVehiclePopup.....");
        //   showVehiclePopup(user);
        //   // });
        // }else{
        //   logger.i("openScreen.....");
        //   openScreen(user);
        // }

      } else {
        _showSnackBar(uName);
      }
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      _showSnackBar(e.toString());
    }
  }

  Future<void> openScreen(Map<String, Object> user) async {
    if (widget.pinSetup != null && widget.pinSetup ||
        user["pin"] == null ||
        user["pin"] == "" ||
        user["pin"].toString().length != 4) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SetupPin(
              isChangePassword: false,
              isFromSetting: false,
            ),
          ),
          ModalRoute.withName('/login_screen'));
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(WebConstant.kQuickPin)) {
        prefs.remove(WebConstant.kQuickPin);
      }
      prefs.setBool(WebConstant.IS_LOGIN, true);
      prefs.setString(WebConstant.kQuickPin, user["pin"]);

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => userType == "Driver"
      //           ? DashboardDriver()
      //           : BranchAdminDashboard(),
      //     ),
      //     ModalRoute.withName('/login_screen'));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SecurePin(false),
          ),
          ModalRoute.withName('/login_screen'));
    }
  }

  Future<void> showVehiclePopup(Map<String, Object> user) async {
    bool checkStartMiles = false;
    TextEditingController startMilesController = TextEditingController();
    File _image;
    String base64Image;
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return Center(
            child: StatefulBuilder(builder: (context, setStat) {
              return Container(
                height: 500,

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDialogBox(


                        button2: TextButton(

                          onPressed: () {
                            print("START MILES CONTROLLER DATA IS ::::::????>>>>>>>>>" +
                                startMilesController.text.toString());
                            if (startMilesController.text.toString().toString() == null ||
                                startMilesController.text.toString().toString().isEmpty ||
                                selectedVehicle == null ||
                                selectedVehicle.id == 0) {
                              Fluttertoast.showToast(msg: "Please Choose Vehicle or Enter Start Miles");
                            } else if (_image == null) {
                              Fluttertoast.showToast(msg: "Take Speedometer Picture");
                            } else {
                              Map<String, dynamic> prams = {
                                "entry_type": "start",
                                "start_miles": int.tryParse(startMilesController.text.toString().trim()),
                                "end_miles": 0,
                                "end_miles_image": "",
                                "lat": "$lat",
                                "lng": "$lng",
                                "vehicle_id": selectedVehicle.id.toString(),
                                "start_mile_image": base64Image != null && base64Image.isNotEmpty ? base64Image : "",
                              };
                              updateStartMiles(context, user, prams);
                            }
                          },
                          child: Text("Okay", style: TextStyle(fontSize: 18.0, color: Colors.black)),
                        ),
                        button1: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            openScreen(user);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ),
                        // img: Image.asset("assets/delivery_truck.png"),
                        // descriptions: "Choose Vehicle",
                        // button2: TextButton(
                        //   onPressed: () async {
                        //     if (selectedVehicle == null || selectedVehicle.id == 0) {
                        //       Fluttertoast.showToast(msg: "Please Select Vehicle");
                        //     } else {
                        //       //send it to pin screen
                        //
                        //
                        //
                        //
                        //       Navigator.pop(context);
                        //       // showStartMilesDialog(user);
                        //     }
                        //   },
                        //   child: Text("Okay", style: TextStyle(fontSize: 18.0, color: Colors.black)),
                        // ),


                        cameraIcon: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            if (vehicleList != null && vehicleList.isNotEmpty)
                              Text(
                                "Choose Vehicle",
                                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (vehicleList != null && vehicleList.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[700]),
                                      borderRadius: BorderRadius.circular(50.0)),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      padding: EdgeInsets.zero,
                                      child: DropdownButton<VehicleData>(
                                        isExpanded: true,
                                        value: selectedVehicle,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                        onChanged: (VehicleData newValue) {
                                          setStat(() {
                                            selectedVehicle = newValue;
                                          });
                                        },
                                        items: vehicleList.map<DropdownMenuItem<VehicleData>>((VehicleData value) {
                                          return DropdownMenuItem<VehicleData>(
                                            value: value != null ? value : null,
                                            child: Container(
                                              height: 45.0,
                                              color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
                                              width: MediaQuery.of(context).size.width,
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Text(
                                                  "${value.name != null && value.name.isNotEmpty ? value.name : ""}${value.modal != null && value.modal.isNotEmpty ? " - " + value.modal : ""}${value.regNo != null && value.regNo.isNotEmpty ? " - " + value.regNo : ""}${value.color != null && value.color.isNotEmpty ? " - " + value.color : ""}"
                                                      .toUpperCase(),
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 15.0,
                            ),

                            Text("Enter miles and upload picture"),
                            SizedBox(
                              height: 15.0,
                            ),
                              TextField(
                              controller: startMilesController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.blue),
                              autofocus: false,
                              onChanged: (value) {
                                setStat(() {});
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
                              ],
                              decoration: new InputDecoration(
                                labelText: "Please enter start miles",
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.blue),
                                filled: true,
                                errorText: checkStartMiles ? "Enter Start Miles" : null,
                                contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()))
                                        .then((value) async {
                                      if (value != null) {
                                        setStat(() {
                                          _image = File(value);
                                        });
                                        final imageData = await _image.readAsBytes();
                                        base64Image = base64Encode(imageData);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 75.0,
                                    child: Image.asset("assets/speedometer.png"),
                                  ),
                                ),
                                if (_image != null)
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                if (_image != null)
                                  Container(
                                    width: 70.0,
                                    height: 70.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // if(vehicleList != null && vehicleList.isNotEmpty)
                            // Text("Choose Vehicle", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),),
                            // // Row(
                            // //   children: [
                            // //     Checkbox(
                            // //       value: checkIdCar,
                            // //       visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            // //       onChanged: (value){
                            // //         checkIdBike = false;
                            // //         checkIdCar = value;
                            // //         setStat(() {});setState(() {});
                            // //       },
                            // //     ),
                            // //     Text("Car", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
                            // //   ],
                            // // ),
                            // // if(checkIdCar && vehicleList != null && vehicleList.isNotEmpty)
                            // // Container(
                            // //   height: 30.0,
                            // //   child: ListView.builder(
                            // //     itemCount: vehicleList.length,
                            // //     shrinkWrap: true,
                            // //     scrollDirection: Axis.horizontal,
                            // //     itemBuilder: (context, index) {
                            // //       return Padding(
                            // //         padding: const EdgeInsets.only(left: 20.0),
                            // //         child: Row(
                            // //           children: [
                            // //             Radio(
                            // //               value: index,
                            // //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // //               groupValue: carId,
                            // //               visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            // //               onChanged: (value){
                            // //                 setStat(() {
                            // //                   carId = value;
                            // //                 });
                            // //                 setState(() {});
                            // //               },
                            // //             ),
                            // //             Text(vehicleList[index].vehicleType ?? ""),
                            // //           ],
                            // //         ),
                            // //       );
                            // //     }),
                            // // ),
                            // // Row(
                            // //   children: [
                            // //     Checkbox(
                            // //       value: checkIdBike,
                            // //       visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            // //       onChanged: (value){
                            // //         checkIdCar = false;
                            // //         carId = -1;
                            // //         checkIdBike = value;
                            // //         setState(() {});setStat(() {});
                            // //       },
                            // //     ),
                            // //     Text("Bike", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
                            // //   ],
                            // // ),
                            // // if(checkIdBike || carId >= 0)
                            // // SizedBox(
                            // //   height: 5.0,
                            // // ),
                            // // if(checkIdBike || carId >= 0)
                            // // Row(
                            // //   children: [
                            // //     Text("Registration No.: ", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),),
                            // //     Text("1235262", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
                            // //   ],
                            // // ),
                            // if(vehicleList != null && vehicleList.isNotEmpty)
                            // Padding(
                            //   padding: const EdgeInsets.all(4.0),
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //         border: Border.all(color: Colors.grey[700]),
                            //         borderRadius: BorderRadius.circular(50.0)
                            //     ),
                            //     child: DropdownButtonHideUnderline(
                            //       child: ButtonTheme(
                            //         alignedDropdown: true,
                            //         padding: EdgeInsets.zero,
                            //         child: DropdownButton<VehicleData>(
                            //           isExpanded: true,
                            //           value: selectedVehicle,
                            //           icon: Icon(Icons.arrow_drop_down),
                            //           iconSize: 24,
                            //           elevation: 16,
                            //           style: TextStyle(color: Colors.black),
                            //           underline: Container(
                            //             height: 2,
                            //             color: Colors.black,
                            //           ),
                            //           onChanged: (VehicleData newValue) {
                            //             setStat(() {
                            //               selectedVehicle = newValue;
                            //             });
                            //           },
                            //           items: vehicleList
                            //               .map<DropdownMenuItem<VehicleData>>(
                            //                   (VehicleData value) {
                            //                 return DropdownMenuItem<VehicleData>(
                            //                   value: value != null ? value : null,
                            //                   child: Container(
                            //                     height: 45.0,
                            //                     width: MediaQuery.of(context).size.width,
                            //                     alignment: Alignment.centerLeft,
                            //                     child: Padding(
                            //                       padding: const EdgeInsets.only(left: 0.0),
                            //                       child: Text(
                            //                         "${value.name != null && value.name.isNotEmpty ? value.name : ""}  ${value.modal != null && value.modal.isNotEmpty ?" - " + value.modal : ""} ${value.regNo != null && value.regNo.isNotEmpty ? " - " + value.regNo : ""} ${value.color != null && value.color.isNotEmpty ? " - " + value.color : ""}".toUpperCase(),
                            //                         style: TextStyle(color: Colors.black),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 );
                            //               }).toList(),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(

                              height: 10.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                                child: Text("click Image"))
                            ,

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  Future<void> getVehicleInfo() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      return;
    }
    vehicleList.clear();
    await CustomLoading().showLoadingDialog(context, true);
    await _apiCallFram.getDataRequestAPI(WebConstant.GET_VEHICLE_INFO, accessToken, context).then((response) async {
      await CustomLoading().showLoadingDialog(context, false);
      // progressDialog.hide();
      logger.i(WebConstant.GET_VEHICLE_INFO);
      logger.i(accessToken);
      logger.i(response.body);
      // await CustomLoading().showLoadingDialog(context, true);
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
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
        try {
          if (response != null) {
            GetVehicleInfoApiResponse model = GetVehicleInfoApiResponse.fromJson(json.decode(response.body));
            if (model != null) {
              if (model.vehicleData != null && model.vehicleData.isNotEmpty) {
                if (model.vehicleData.length > 1) {
                  selectedVehicle.id = 0;
                  selectedVehicle.name = "Please Select Vehicle";
                  selectedVehicle.color = "";
                  selectedVehicle.vehicleType = "";
                  selectedVehicle.modal = "";
                  selectedVehicle.regNo = "";
                  vehicleList.add(selectedVehicle);
                } else {
                  selectedVehicle = model.vehicleData[0];
                }
                vehicleList.addAll(model.vehicleData);
                setState(() {});
              }
            }
          }
        } catch (_, stackTrace) {
          // print(_);
          SentryExemption.sentryExemption(_, stackTrace);
          logger.i(_);
          Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
          // progressDialog.hide();
          await CustomLoading().showLoadingDialog(context, false);
          // await CustomLoading().showLoadingDialog(context, true);
        }
      } catch (_, stackTrace) {
        logger.i(_);
        SentryExemption.sentryExemption(_, stackTrace);
        // print(_);
        await CustomLoading().showLoadingDialog(context, false);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }
}

Future<int> clearDliveryTable() async {
  await MyDatabase().delecteDeliveryList();
  await MyDatabase().delecteCustomerList();
  await MyDatabase().delecteAddressList();
  return Future.value(1);
}

class LogoutOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<LogoutOverlay> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  //ProgressDialog progressDialog;
  final focusfName = FocusNode();
  String _username;
  BuildContext _ctx;
  var yetToStartColor = const Color(0xFFF8A340);

  @override
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
    _ctx = context;
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
              decoration: ShapeDecoration(
                  color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  new Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  new Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 50,
                        child: new TextFormField(
                          onSaved: (val) => _username = val,
                          validator: (val) {
                            return val.trim().isEmpty ? "Enter Email" : null;
                          },
                          controller: _emailController,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focusfName);
                          },
                          ////initialValue: "rc2.cust20200101@gmail.com",
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          decoration: new InputDecoration(
                              labelText: "Email",
                              border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(const Radius.circular(5.0)))),
                        ),
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                            height: 35.0,
                            width: 110.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              ),
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: yetToStartColor, fontWeight: FontWeight.bold, fontSize: 13.0),
                              ),
                              onPressed: () {
                                forgotpass();
                              },
                            )),
                      ),
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

  Future<void> forgotpass() async {
    if (_emailController.text != null && _emailController.text != "") {
      // ProgressDialog(context, isDismissible: false).show();
      await CustomLoading().showLoadingDialog(context, true);
      forgotApi(_emailController.text);
    } else {
      _showSnackBar("Enter Email");
    }
  }

  Future<Map<String, Object>> forgotApi(String email) async {
    final JsonDecoder _decoder = new JsonDecoder();
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json',
    };
    String url = WebConstant.FORGOT_PASSWORD_URL + email;
    final response = await http.post(Uri.parse(url), headers: headers);
    // print(WebConstant.FORGOT_PASSWORD_URL + email);
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, Object> data = json.decode(response.body);
      //orderType  orderStatusDesc  "orderDate"  orderId
      try {
        // if (data.containsKey("data")) {
        if (data == null) {
          _showSnackBar("No Data Found");
        } else {
          // print(data.toString());
          var status = data['error'];
          var uName = data['message'];
          if (status == false) {
            Navigator.pop(context, false);
            _showItemDialog(uName);
          } else {
            _showSnackBar(uName);
          }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        _showSnackBar(e);
      }
    } else if (response.statusCode == 401) {
      _showSnackBar('Something went wrong');
    } else {
      // print(response.body);
      _showSnackBar('Something went wrong');
    }
  }

  void _showItemDialog(String message) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(""),
          content: Container(
            height: 140.0,
            decoration: ShapeDecoration(
                color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFC5FBC5),
                  child: Image.asset(
                    'assets/tick.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                SizedBox(height: 8),
                Text(message)
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(context, false);
                // Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class PermissionDeniedOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PermissionDeniedOverlayState();
}

class PermissionDeniedOverlayState extends State<PermissionDeniedOverlay> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  //ProgressDialog progressDialog;
  BuildContext _ctx;
  var yetToStartColor = const Color(0xFFF8A340);

  @override
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
    _ctx = context;
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
              height: 200.0,
              decoration: ShapeDecoration(
                shadows: [
                  BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
                ],
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 0,
                  ),
                  new Text(
                    "Please allow permission first before using the app!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                                  'Allow',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13.0),
                                ),
                                onPressed: () {
                                  AppSettings.openAppSettings();
                                },
                              ))),
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

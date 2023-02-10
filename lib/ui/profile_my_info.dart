// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/AuthState.dart';
import '../util/custom_loading.dart';
// import 'package:progress_dialog/progress_dialog.dart';

class ProfileBasicinfo extends StatefulWidget {
  static String tag = 'place_order-screen';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ProfileState();
  }
}

class ProfileState extends State<ProfileBasicinfo> {
  BuildContext _ctx;
  Future<File> imageFile;
  double opacity = 0.0;
  var yetToStartColor = const Color(0xFFF8A340);
  String userId, token, userType;
  bool _isLoading = true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, fName, middleName, lastName, contactNumber, nhsNumber, email, routeId, address1, address2, route;
  String name = "";

  Map<String, Object> profiledata;

  PlaceOrderState() {}

  void _showSnackBar(String text) {
    //  scaffoldKey.currentState
    //    .showSnackBar(new SnackBar(content: new Text(text)));
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  void init() async {
    setState(() => _isLoading = false);
    await SharedPreferences.getInstance().then((value) {
      _username = value.getString('name') ?? "";
      token = value.getString('token') ?? "";
      userId = value.getString('userId') ?? "";
      userType = value.getString(WebConstant.USER_TYPE) ?? "";
      setState(() {
        _isLoading = true;
      });
      // print(token);
      fetchData();
    });
  }

  reload() async {
    /*  Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAddress(
              data: profiledata,
              reload: reload,
            )));*/
    fetchData();
    _showSnackBar(WebConstant.SUCESSFULLY_UPDATED);
    _asyncConfirmDialog() {
      showDialog(
        context: _ctx,
        builder: (context) => new AlertDialog(
          //title: new Text('Are you sure?'),
          content: new Text(WebConstant.SUCESSFULLY_UPDATED),
          actions: <Widget>[
            new TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text(WebConstant.CLOSE),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // logger.i("test");
    init();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var banner = Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new Center(
          child: _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Container(
            width: MediaQuery.of(context).size.width,
            //replace this Container with your Card
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFEBDA),
                    const Color(0xFFFFEBDA),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            height: 200.0,
            child: Column(
              children: [
                Container(
                  width: 100,
                  margin: EdgeInsets.only(top: 30),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xfff58053),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            _username != null && _username.length > 0 ? '${_username[0].toUpperCase()}' : '',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )))
      ],
    );
    var basicinfo = Padding(
      padding: const EdgeInsets.only(top: 2, left: 10, right: 10),
      child: new Card(
          child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: new Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  new Text(
                    name != null ? name : "",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new Text(
                    email != null ? email : "",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new Text(
                    contactNumber != null ? contactNumber : "",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new Text(
                    route != null ? "Route : " + route : "",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );

    const PrimaryColor = const Color(0xFFffffff);
    const titleColor = const Color(0xFF151026);
    return new Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: const Text('MY DETAILS', style: TextStyle(color: Colors.black)),
          backgroundColor: PrimaryColor,
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigator.pop(context, false);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back),
                ),
              )),
        ),
        key: scaffoldKey,
        body: SafeArea(
          child: Column(children: [
            new Expanded(
                child: new ListView(
              children: <Widget>[banner, basicinfo],
            )),
          ]),
        ));
  }

  Future<Map<String, Object>> fetchData() async {
    bool checkInternet = await ConnectionValidator().check();
    if (checkInternet) {
      // await ProgressDialog(context, isDismissible: false).show();
      await CustomLoading().showLoadingDialog(context, true);
      Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
      // print(headers);
      // print('userType:- ' + userType);
      // print(
      //     'userType:- ' + userType == 'Pharmacy' || userType == "Pharmacy Staff"
      //         ? WebConstant.GET_PROFILE_URL_PHARMACY
      //         : WebConstant.GET_PROFILE_URL);
      final response = await http.get(userType == 'Pharmacy' || userType == "Pharmacy Staff" ? Uri.parse(WebConstant.GET_PROFILE_URL_PHARMACY) : Uri.parse(WebConstant.GET_PROFILE_URL), headers: headers);
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      setState(() {
        _isLoading = false;
      });
      // logger.i("ccc" + response.body.toString());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        try {
          // if (data.containsKey("data")) {pharmacyId, branchId

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
          } else {
            Map<String, Object> data = json.decode(response.body);
            if (data == null) {
              _showSnackBar("No Data Found");
            } else if (data['status'] == "true") {
              profiledata = data;
              var status = data['status'];
              if (status != null && status == "true") {
                Map<String, Object> user = data['driverProfile'];
                // print(user);
                setState(() {
                  if (user['firstName'] != null) fName = user['firstName'].toString();
                  if (user['middleName'] != null) middleName = user['middleName'].toString();
                  if (user['lastName'] != null) lastName = user['lastName'].toString();
                  if (fName != null) {
                    String first = fName != null ? fName : "";
                    String mid = middleName != null ? " " + middleName + " " : ' ';
                    String last = lastName != null ? lastName : "";
                    name = first + mid + last;
                  }
                  // if (middleName != null) {
                  //   setState(() {
                  //     name = middleName;
                  //   });
                  // }
                  // if (lastName != null) {
                  //   setState(() {
                  //     name =  lastName;
                  //   });
                  // }
                  if (user['mobileNumber'] != null) contactNumber = user['mobileNumber'].toString();
                  if (user['emailId'] != null) email = user['emailId'].toString();
                  // if (user['routeId'] != null) routeId = user['routeId'].toString();
                  // if (user['route'] != null) route = user['route'].toString();
                });
              } else {
                _showSnackBar("No Data Found");
              }
            }
          }
        } catch (e) {
          // print(e);
          _showSnackBar(e);
        }
      } else if (response.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('token');
        prefs.remove('userId');
        prefs.remove('name');
        prefs.remove('email');
        prefs.remove('mobile');
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
              return LoginScreen();
            }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            }),
            (Route route) => false);
        _showSnackBar('Session expired, Login again');
      } else {
        _showSnackBar('Something went wrong');
      }
    } else {
      _showSnackBar(WebConstant.INTERNET_NOT_AVAILABE);
    }
  }
}

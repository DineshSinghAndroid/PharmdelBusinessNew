// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/privacy_policy_screen.dart';
import 'package:pharmdel_business/ui/ProfilePage/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/connection_validater.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'login_screen.dart';
import 'notification.dart';

class DrawerScreen extends StatefulWidget {
  String userName, email, mobile, version;

  DrawerScreen(this.userName, this.email, this.mobile, this.version);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool _isLoading = true;

  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    //  setState(() => _isLoading = false);
    setState(() => _isLoading = false);
    await SharedPreferences.getInstance().then((value) {
      token = value.getString('token') ?? "";
      userType = value.getString(WebConstant.USER_TYPE) ?? "";
      setState(() {
        _isLoading = true;
      });
      // print(token);
    });
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userType = prefs.getString(WebConstant.USER_TYPE) ?? "";

    String s = prefs.getString('smsBackground') ?? "";
    // setState(() {
    if (s == 'true') {
      status = true;
    }
    setState(() {});
    //  });
    //   fetchData();
  }

  String token, userType;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 130,
                    color: Color(0xFFF8A340),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 65,
                                      width: 65,
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[400],
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                            offset: Offset(0, 0))
                                      ], color: Colors.white, borderRadius: BorderRadius.circular(50)),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: Center(
                                              child: Text(
                                            widget.userName != null ? widget.userName[0].toUpperCase() : "",
                                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                                          )))),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 2.0),
                                            child: Text(
                                              widget.userName ?? "",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 2.0),
                                            child: Text(
                                              widget.email ?? "",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 2.0),
                                            child: Text(
                                              widget.mobile ?? "",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Profiles",
                                style: TextStyle(color: Colors.black, fontSize: 17),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 17,
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Notification",
                                style: TextStyle(color: Colors.black, fontSize: 17),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PrivacyPolicy(title: "Privacy Policy", url: WebConstant.PRIVACY_URL)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Privacy Policy",
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PrivacyPolicy(title: "Terms & Conditions", url: WebConstant.TERMS_URL)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terms of use",
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          _asyncConfirmDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(fontSize: 17, color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Stack(
                    children: [
                      Align(alignment: Alignment.bottomRight, child: Image.asset("assets/drawer_image.png")),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("VERSION V.${widget.version} ",
                              style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _asyncConfirmDialog() {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(WebConstant.LOGOUT),
          content: const Text(WebConstant.ARE_YOU_SURE_LOGOUT),
          actions: <Widget>[
            TextButton(
              child: const Text(WebConstant.CANCEL),
              onPressed: () {
                Navigator.of(context).pop();
                //  Navigator.pop(_ctx);
              },
            ),
            TextButton(
              child: const Text(WebConstant.YES),
              onPressed: () async {
                Navigator.of(context).pop();
                fetchLogout();
              },
            )
          ],
        );
      },
    );
    // Navigator.pop(context, true);
  }

  Future<Map<String, Object>> fetchLogout() async {
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
      // print(headers);
      print(userType == 'Pharmacy' || userType == "Pharmacy Staff"
          ? WebConstant.GET_LOGOUT_URL_PHARMACY
          : WebConstant.GET_LOGOUT_URL);

      final response = await http.get(
          userType == 'Pharmacy' || userType == "Pharmacy Staff"
              ? Uri.parse(WebConstant.GET_LOGOUT_URL_PHARMACY)
              : Uri.parse(WebConstant.GET_LOGOUT_URL),
          headers: headers);
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
          if (response.body == null) {
            _showSnackBar("No Data Found");
          } else if (response.body == "Success") {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            prefs.remove('userId');
            prefs.remove('name');
            prefs.remove('email');
            prefs.remove('mobile');
            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                    pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                  return LoginScreen();
                }, transitionsBuilder: (BuildContext context, Animation<double> animation,
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
            }
          }
        } catch (e, stackTrace) {
          SentryExemption.sentryExemption(e, stackTrace);
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
            }, transitionsBuilder: (BuildContext context, Animation<double> animation,
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
        _showSnackBar('Session expired, Login again');
      } else {
        _showSnackBar('Something went wrong');
      }
    } else {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
    }
  }

  void _showSnackBar(String text) {
    //  scaffoldKey.currentState
    //    .showSnackBar(new SnackBar(content: new Text(text)));
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class MyWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, 40.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 40.0);

    //see my previous post to understand about Bezier Curve waves
    // https://www.hellohpc.com/flutter-how-to-make-bezier-curve-waves-using-custom-clippath/

    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        path.quadraticBezierTo(size.width - (size.width / 16) - (i * size.width / 8), 0.0,
            size.width - ((i + 1) * size.width / 8), size.height - 160);
      } else {
        path.quadraticBezierTo(size.width - (size.width / 16) - (i * size.width / 8), size.height - 120,
            size.width - ((i + 1) * size.width / 8), size.height - 160);
      }
    }

    path.lineTo(0.0, 40.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

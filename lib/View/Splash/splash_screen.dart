import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String userId = "";
  bool isLoading = true;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100),(){
      setState(() {
        opacity = 1.0;
      });
    });
    checkLogin();
  }

  Future<void> checkLogin() async {

    await SharedPreferences.getInstance().then((value) {
      // userId = value.getString(AppSharedPreferences.userId) ?? "";
        runSplash();
    });
  }


  runSplash() {
    // Navigator.pushReplacementNamed(context, dashboardScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        key: scaffoldKey,
        body: Center(
          child: SafeArea(
              child: SingleChildScrollView(
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          AnimatedOpacity(
                              opacity: opacity,
                              duration: const Duration(milliseconds: 1000),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                                            child: SizedBox(
                                              height: 150,
                                              child: Image.asset(kSplashLogo),
                                            ))
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 40.0),
                                        child: Text("",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            ),
                                            textScaleFactor: 2.0,
                                            textAlign: TextAlign.center)),
                                    Form(
                                        key: formKey,
                                        child: Column(children: <Widget>[
                                        ])),
                                  ],
                                ),
                              )
                          ),
                          isLoading ?  const CircularProgressIndicator() : const SizedBox(height: 8.0),
                        ],
                      )))),
        ));
  }
}
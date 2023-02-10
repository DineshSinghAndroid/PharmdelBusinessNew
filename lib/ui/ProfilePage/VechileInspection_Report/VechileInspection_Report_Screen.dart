import 'dart:convert';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmdel_business/ui/ProfilePage/profile.dart';
import 'package:pharmdel_business/ui/driver_user_type/dashboard_driver.dart';
import 'package:pharmdel_business/util/custom_camera_screen.dart';
import 'package:pharmdel_business/util/text_style.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api_call_fram.dart';
import '../../../data/web_constent.dart';
import '../../../main.dart';
import '../../../model/VirModel/GetInspectionModel.dart';
import '../../../util/AnimatedButton.dart';
import '../../../util/connection_validater.dart';
import '../../../util/custom_loading.dart';
import '../../../util/sentryExeptionHendler.dart';
import '../../login_screen.dart';
import 'click_images.dart';

class VechileInspectionReportScreen extends StatefulWidget {
  String vehicleId;

  VechileInspectionReportScreen(this.vehicleId);

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

TextEditingController remarkController = TextEditingController();

class _MyCustomWidgetState extends State<VechileInspectionReportScreen> {
  String accessToken = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      stateTextWithIcon = ButtonState.idle;
    });

    init();
  }

  ApiCallFram _apiCallFram = ApiCallFram();
  bool tyreDone = false;
  bool bodyDone = false;
  bool bootDone = false;
  bool insideDone = false;
  bool engineDone = false;

  Future<void> init() async {
    SharedPreferences.getInstance().then((value) async {
      accessToken = (await value.getString(WebConstant.ACCESS_TOKEN))!;
      setState(() {

      });
      print("This is access token on vehilce screen " +accessToken.toString());
    });

    final prefs = await SharedPreferences.getInstance();
    String vehicleIdFromApi = prefs.getString(WebConstant.VEHICLE_ID).toString();
    // Fluttertoast.showToast(msg: vehicleId);
    setState(() {
      stateTextWithIcon = ButtonState.idle;
      widget.vehicleId = vehicleIdFromApi;
    });
    print("this is widget.vehile id " +widget.vehicleId);

    fetchData();
  }

  @override
  Widget build(BuildContext c) {
    double _w = MediaQuery.of(context).size.width;
    List icons = [
      Icons.camera_rounded,
      Icons.car_rental_sharp,
      Icons.camera_enhance_rounded,
      Icons.motion_photos_auto,
      Icons.car_crash,
    ];
    List arrowIcons = [
      tyreDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
      bodyDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
      insideDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
      bootDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
      engineDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
    ];

    List texts = [
      "Tyre",
      "Body",
      "Inside",
      "Boot",
      "Engine",
    ];

    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.41234),
      appBar: AppBar(


        title: Text("Vehicle Inspection Report"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Pick a service",
                  style: TS.CTS(32.0, Colors.white, FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(_w / 30),
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemCount: texts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: Duration(milliseconds: 100),
                          child: SlideAnimation(
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            verticalOffset: -250,
                            child: ScaleAnimation(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ClickInspectionImagesScreen(
                                        screenName: texts[index],
                                        vehicleId: widget.vehicleId,
                                      );
                                    },
                                  );
                                  print("Vehicle id going to click image screen is " + widget.vehicleId.toString());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.only(bottom: _w / 20),
                                  height: _w / 6,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.4),
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        icons[index],
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        texts[index],
                                        style: TS.CTS(22.0, Colors.white, FontWeight.w500),
                                      ),
                                      Icon(arrowIcons[index],color: Colors.white,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                AnimatedBtn('Submit', onPressedIconWithText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPressedIconWithText() async {
    fetchData();
     if (bodyDone == true && engineDone == true && engineDone == true && insideDone == true && bootDone == true) {
      Fluttertoast.showToast(msg: "Data submitted Successful");
      print("Done submitting");
      setState(() {
        stateTextWithIcon = ButtonState.success;
      });
    } else {
      print("failed submitting");

      Fluttertoast.showToast(msg: "Please Complete all fields");
      setState(() {
        stateTextWithIcon = ButtonState.fail;
      });
    }
    setState(() {
      stateTextWithIcon = ButtonState.idle;
    });
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

  Future<void> fetchData() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      return;
    }
    await CustomLoading().showLoadingDialog(context, true);
    await _apiCallFram
        .getDataRequestAPI(
            WebConstant.GET_INSPECTION_DATA+'?vehicle_id=${widget.vehicleId}', accessToken, context)
        .then((response) async {

          print("this is widget.vehicle id " +widget.vehicleId);
       await CustomLoading().showLoadingDialog(context, false);
      // progressDialog.hide();
       logger.i(response.body);
      // await CustomLoading().showLoadingDialog(context, true);
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          Fluttertoast.showToast(msg: 'Login again')
          ;
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

        if (response != null) {
          GetInspectionDataModel model = GetInspectionDataModel.fromJson(json.decode(response.body));
          if (model != null) {
            if (model.data != null) {
               if (model.data!.tyre == 1) {
                setState(() {
                  tyreDone = true;
                });
              }
              if (model.data!.boot == 1) {
                setState(() {
                  bootDone = true;
                });
              }
              if (model.data!.body == 1) {
                setState(() {
                  bodyDone = true;
                });
              }
              if (model.data!.engine == 1) {
                setState(() {
                  engineDone = true;
                });
              }
              if (model.data!.inside == 1) {
                setState(() {
                  insideDone = true;
                });
              }
              setState(() {

              });
            } else {
              print(model.message.toString());
            }
           }
        }
      } catch (e) {
        print("error occurred");
      }
    });
  }

  // Future<void> fetchData() async {
  //   bool checkInternet = await ConnectionValidator().check();
  //   if (!checkInternet) {
  //     return;
  //   }
  //    Map<String, String> headers = {
  //     'Accept': 'application/json',
  //     "Content-type": "application/json",
  //     "Authorization": 'Bearer $token'
  //   };
  //   // String url = WebConstant.INSPECTION_SUBMIT + "?vehicle_id=${widget.vehicleId}";
  //   // final response = await http.get(Uri.parse(url), headers: headers);
  //   // WebConstant.DELIVERY_LIST_URL + "?routeId=$routeId&dateTime=${date}"
  //   final response = await http.get(
  //       Uri.parse('https://www.pharmdel.co.uk/api/Delivery/v22/getInspectionData?vehicle_id=${1}'),
  //       headers: headers);
  //   print(response.body);
  //   setState(() {
  //     // _isLoading = false;
  //   });
  //   if (response != null && response.body != null && response.body == "Unauthenticated") {
  //     Fluttertoast.showToast(msg: "Authentication Failed. Login again");
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.remove('token');
  //     prefs.remove('userId');
  //     prefs.remove('name');
  //     prefs.remove('email');
  //     prefs.remove('mobile');
  //     prefs.remove('route_list');
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (BuildContext context) => LoginScreen(),
  //         ),
  //         ModalRoute.withName('/login_screen'));
  //   } else if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     Map<String, Object> data1 = json.decode(response.body); //orderType  orderStatusDesc  "orderDate"  orderId
  //     try {
  //       // if (data.containsKey("data")) {pharmacyId, branchId
  //       if (data1 == null) {
  //         _showSnackBar("No Data Found");
  //         print(data1);
  //       }
  //       // logger.i("aaaa" + data.toString());
  //
  //       else {
  //         print(data1);
  //         String message = json.decode(response.body)["message"].toString();
  //         Map<String, dynamic> data = json.decode(response.body)["data"];
  //         String tyreDone = data[1].toString();
  //         print("Tyre done is " + tyreDone);
  //         print("DATA is ::::::::>>>>>>");
  //         print(data);
  //         // _showSnackBar(message);
  //         _showSnackBar(data[0]);
  //       }
  //     } catch (e, stackTrace) {
  //       SentryExemption.sentryExemption(e, stackTrace);
  //       _showSnackBar(e.toString());
  //     }
  //   } else if (response.statusCode == 401) {
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.remove('token');
  //     prefs.remove('userId');
  //     prefs.remove('name');
  //     prefs.remove('email');
  //     prefs.remove('mobile');
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
  //           return LoginScreen();
  //         }, transitionsBuilder:
  //             (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  //           return new SlideTransition(
  //             position: new Tween<Offset>(
  //               begin: const Offset(1.0, 0.0),
  //               end: Offset.zero,
  //             ).animate(animation),
  //             child: child,
  //           );
  //         }),
  //         (Route route) => false);
  //     _showSnackBar('Session expired, Login again');
  //   } else {
  //     _showSnackBar('Something went wrong');
  //   }
  //   return fetchData();
  // }
}

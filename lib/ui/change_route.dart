// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker_view/picker_view.dart';
import 'package:flutter_picker_view/picker_view_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/util/icon_suffixed_tf.dart';
import 'package:pharmdel_business/util/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/AuthState.dart';
// import 'package:progress_dialog/progress_dialog.dart';

import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';

class ChangeRoute extends StatefulWidget {
  static String tag = 'place_order-screen';
  final String routeId;
  final String route;
  final Function function;

  ChangeRoute({this.routeId, this.route, this.function});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChangeRouteState();
  }
}

class ChangeRouteState extends State<ChangeRoute> {
  BuildContext _ctx;
  Future<File> imageFile;
  double opacity = 0.0;
  var yetToStartColor = const Color(0xFFF8A340);
  String userId, token;
  bool _isLoading = true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, fName, middleName, lastName, contactNumber, nhsNumber, email, postalCode, address1, address2, townName;
  TextEditingController _typeTc = new TextEditingController();

  // ProgressDialog progressDialog;
  Map<String, Object> profiledata;
  List<String> optionlist = [];
  List<dynamic> roueList = [];
  int selectedPos = 0;

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
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('name') ?? "";
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    // progressDialog.style(
    //     message: "Please wait...",
    //     borderRadius: 4.0,
    //     backgroundColor: Colors.white);
    if (widget.route != null && widget.routeId != null) {
      setState(() {
        _typeTc.text = widget.route;
      });
    }
    fetchData();
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
    _showSnackBar("Successfully updated");
    _asyncConfirmDialog() {
      showDialog(
        context: _ctx,
        builder: (context) => new AlertDialog(
          //title: new Text('Are you sure?'),
          content: new Text("Successfully updated"),
          actions: <Widget>[
            new TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Close'),
            ),
          ],
        ),
      );
    }
    // Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    //progressDialog = new ProgressDialog(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final focus = FocusNode();

    var banner = Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new Center(
          child: _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Container(
            //replace this Container with your Card
            color: Colors.white,
            height: 200.0,
            child: Image.asset(
              'assets/profile_banner.png',
              fit: BoxFit.fill,
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
                            _username != null ? '${_username[0].toUpperCase()}' : '',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )))
      ],
    );

    const PrimaryColor = const Color(0xFFffffff);
    const titleColor = const Color(0xFF151026);
    return new Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: const Text('CHANGE ROUTE', style: TextStyle(color: Colors.black)),
          backgroundColor: PrimaryColor,
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  //Navigator.pop(context, false);
                  Navigator.of(context).pop();
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20),
                  child: Text("Select Route"),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: GestureDetector(
                        onTap: () {
                          if (optionlist != null && optionlist.length > 0) {
                            _showTypePicker(items: optionlist);
                          } else {
                            _showSnackBar("No Options");
                          }
                        },
                        child: AbsorbPointer(
                          child: IconSuffixedTF(
                            height: 40.0,
                            controller: _typeTc,
                            placeHolder: '',
                            isValidValue: true,
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Center(
                  child: Container(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (_typeTc.text != "") {
                          changeRoute();
                        } else {
                          _showSnackBar("Select Route");
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )),
          ]),
        ));
  }

  void _showTypePicker({List<String> items}) {
    PickerController pickerController = PickerController(count: 1, selectedItems: [0]);

    PickerViewPopup.showMode(PickerShowMode.BottomSheet,
        controller: pickerController,
        context: context,
        title: Text(
          "Route",
          style: kButtonTextStyle,
        ),
        cancel: Text(
          'cancel',
          style: kButtonTextStyle.copyWith(color: Colors.red),
        ),
        onCancel: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AlertDialogPicker.cancel')));
        },
        confirm: Text(
          'confirm',
          style: kButtonTextStyle.copyWith(color: Colors.black45),
        ),
        onConfirm: (controller) async {
          List<int> selectedItems = [];
          selectedItems.add(controller.selectedRowAt(section: 0));
          String selValue = items[controller.selectedRowAt(section: 0)];
          setState(() {
            selectedPos = controller.selectedRowAt(section: 0);
          });
          //_showSnackBar(controller.selectedRowAt(section: 0).toString());
          _typeTc.text = selValue;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AlertDialogPicker.selected:$selectedItems')));
        },
        onSelectRowChanged: (section, row) {
          String selValue = items[row];
        },
        builder: (context, popup) {
          return Container(
            height: 200,
            child: popup,
          );
        },
        itemExtent: 40,
        numberofRowsAtSection: (section) {
          return items.length;
        },
        itemBuilder: (section, row) {
          return Text(
            items[row],
            style: kTextFieldTextStyle,
          );
        });
  }

  Future<Map<String, Object>> changeRoute() async {
    //progressDialog.show();
    // ProgressDialog(context, isDismissible: false).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    try {
      Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
      Map<String, Object> resBody = new Map<String, Object>();
      resBody['driverId'] = int.parse(userId);
      resBody['routeId'] = roueList[selectedPos]['routeId'];
      resBody['route'] = roueList[selectedPos]['routeName'].toString();
      resBody['companyId'] = roueList[selectedPos]['companyId'];
      resBody['branchId'] = roueList[selectedPos]['branchId'];
      final j = json.encode(resBody);
      final response = await http.post(Uri.parse(WebConstant.UPDATE_ROUTE_URL), headers: headers, body: j);
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      // logger.i("hh"+json.decode(response.body).toString());
      if (response.statusCode == 200) {
        Map<String, Object> data = json.decode(response.body);
        try {
          var status = data['status'];
          var uName = data['message'];
          if (status == true) {
            _showSnackBar(uName);
            widget.function();
            //  Navigator.pop(context, false);
            Navigator.of(context).pop();
          } else {
            _showSnackBar(uName);
          }
        } catch (e, stackTrace) {
          SentryExemption.sentryExemption(e, stackTrace);
          // logger.i("hh" + e.toString());
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
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      // print(e.toString());
    }
  }

  Future<Map<String, Object>> fetchData() async {
    final JsonDecoder _decoder = new JsonDecoder();
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};

    final response = await http.get(Uri.parse(WebConstant.GET_ROUTE_URL), headers: headers);
    setState(() {
      _isLoading = false;
    });

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
    } else if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, Object> data = json.decode(response.body); //orderType  orderStatusDesc  "orderDate"  orderId
      try {
        // if (data.containsKey("data")) {pharmacyId, branchId
        if (data == null) {
          _showSnackBar("No Data Found");
        } else {
          profiledata = data;
          // logger.i("aaaa" + data.toString());
          var status = data['status'];
          if (status != null && status == true) {
            List<dynamic> list = data['routeList'];
            if (list != null && list.length > 0) {
              List<String> ll = List();
              for (int i = 0; i < list.length; i++) {
                ll.add(list[i]['routeName']);
              }
              setState(() {
                optionlist = ll;
                roueList = list;
              });
            }
          } else {
            _showSnackBar("No Data Found");
          }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
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
  }
}

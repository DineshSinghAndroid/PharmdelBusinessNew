// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/rest_ds.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/assign_to_shelf_model.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/assign_to_self.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/scan_prescription.dart';
import 'package:pharmdel_business/ui/collect_order.dart';
import 'package:pharmdel_business/ui/delivery_list.dart';
import 'package:pharmdel_business/ui/drawer_screen.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';

import '../../main.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../../util/text_style.dart';
import '../notification.dart';
import '../splash_screen.dart';
import 'bulk_scan.dart';
import 'driver_list.dart';

class BranchAdminDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BranchAdminDashboardState();
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

final scaffoldKey = new GlobalKey<ScaffoldState>();

class Logic {
  void doSomething() {
    final BottomNavigationBar navigationBar = scaffoldKey.currentWidget;
    navigationBar.onTap(1);
  }
}

class _BranchAdminDashboardState extends State<BranchAdminDashboard> with WidgetsBindingObserver {
  var blue = const Color(0xFF0071BC);
  String _homeScreenText = "Waiting for token...";
  String userId, authtoken;
  String isTokenSaved = "false";
  String usetType;

  @override
  void initState() {
    super.initState();
    init();
  }

  void _showItemDialog(String message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, message),
    ).then((bool shouldNavigate) {
      /* if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }*/
    });
  }

  Widget _buildDialog(BuildContext context, String item) {
    return AlertDialog(
      content: Text(item.toString()),
      actions: <Widget>[
        TextButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> init() async {
    // logger.i("onMessage: test");
    final prefs = await SharedPreferences.getInstance();
    authtoken = prefs.getString(WebConstant.ACCESS_TOKEN) ?? "";
    print(authtoken);
    userId = prefs.getString(WebConstant.USER_ID) ?? "";
    isTokenSaved = prefs.getString('isTokenSaved') ?? "";
    usetType = prefs.getString(WebConstant.USER_TYPE) ?? "";
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     logger.i("onMessage: test");
    //     // _showItemDialog(message);
    //     // checkSms(message);
    //   },
    //   //onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     logger.i("onLaunch: $message");
    //     //checkSms(message);
    //     // _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     logger.i("onResume: $message");
    //     //checkSms(message);
    //     // _navigateToItemDetail(message);
    //   },
    // );

    // String token = await FirebaseMessaging.instance.getToken();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (mounted) checkLastTime(context);
        break;
      case AppLifecycleState.inactive:
        // print("app in inactive");
        // setLastTime();
        break;
      case AppLifecycleState.paused:
        // print("app in paused");
        // setLastTime();
        break;
      case AppLifecycleState.detached:
        // print("app in detached");
        // setLastTime();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
          appBar: null,
          body: HomeWidget(Colors.white, Logic()),
        ),
        onWillPop: _onWillPop);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

Future<bool> _onBackPressed() async {
  // Your back press code here...
  _showSnackBar("onbackpress");
}

void _showSnackBar(String text) {
  Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
}

class HomeWidget extends StatefulWidget {
  final Color color;
  final Logic logic;

  HomeWidget(this.color, this.logic);

  HomePageState createState() => HomePageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class HomePageState extends State<HomeWidget> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  RestDatasource api = new RestDatasource();

  // ProgressDialog progressDialog;
  BuildContext _ctx;
  String userId, token, userName, email, mobile;
  String routeId, routeS;
  String userType;

  //AppUpdateInfo _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;

  // List<GroupModel> list = new List<GroupModel>();
  List<dynamic> list = new List();
  ApiCallFram _apiCallFram = ApiCallFram();

  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  String versionCode = "";

  bool isTitanEnable = false;

  dynamic notification_count = 0;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    userType = prefs.getString(WebConstant.USER_TYPE) ?? "";
    prefs.setString(WebConstant.ROUTE_ID, routeId ?? "");
    prefs.setString(WebConstant.ROUTE_NAME, routeS ?? "");
    await SharedPreferences.getInstance().then((value) {
      userName = value.getString('name') ?? "";
      email = value.getString('email') ?? "";
      mobile = value.getString('mobile') != null
          ? value.getString('mobile') != "null"
              ? value.getString('mobile')
              : ""
          : "";
    });

    bool checkInternet = await ConnectionValidator().check();
    checkMaintance();
    if (checkInternet) {
      fetchData();
    }
  }

  void checkMaintance() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => UnderMaintenance(
    //       )),
    // );
  }

  void versionCode1() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      print(version);
      print(buildNumber);
      if (Platform.isAndroid) {
        versionCode = version;
      } else {
        versionCode = WebConstant.iOS_APP_VERSION;
      }
    });
  }

  Future<Map<String, Object>> fetchData() async {
    // await ProgressDialog(context).show();
    await CustomLoading().showLoadingDialog(context, true);
    Map<String, String> headers = {"Content-type": "application/json", 'Accept': 'application/json', "Authorization": 'Bearer $token'};
    final response = await http.get(userType == 'Pharmacy' || userType == "Pharmacy Staff" ? Uri.parse(WebConstant.GET_PROFILE_URL_PHARMACY) : Uri.parse(WebConstant.GET_PROFILE_URL), headers: headers);
    logger.i(response.body);
    // await ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    updateApi(token);
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
      Map<String, Object> data = json.decode(response.body);
      // print(data);
      try {
        if (data != null) {
          var status = data['status'];
          if (status != null && status == "true") {
            Map<String, Object> user = data['driverProfile'];
            setState(() {
              if (user['scan_type'] != null && user['scan_type'] == 4) isTitanEnable = true;
              if (user['routeId'] != null) routeId = user['routeId'].toString();
              if (user['route'] != null) routeS = user['route'].toString();
            });
            await SharedPreferences.getInstance().then((value) {
              value.setInt(WebConstant.IS_PRES_CHARGE, user['is_pres_charge']);
              value.setInt(WebConstant.IS_DEL_CHARGE, user['is_del_charge']);
              logger.i(value.getInt(WebConstant.IS_PRES_CHARGE));
              logger.i(value.getInt(WebConstant.IS_DEL_CHARGE));
            });
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
      // _showSnackBar('Something went wrong');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
    versionCode1();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    /*if (state == AppLifecycleState.resumed) {
      setState(() {
        //_onItemTapped(0);
        final BottomNavigationBar navigationBar = globalKey.currentWidget;
        navigationBar.onTap(0);
      });
    }*/
  }

  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes != "-1") {
        FlutterBeep.beep();
        // List<String> barcodeArray = barcodeScanRes.split(",");
        //for(String str in barcodeArray){
        //if(str.contains("OrderId")){
        // if (isOutForDelivery){
        //   checkCustomerWithOrder(barcodeScanRes,customerId,orderId.toString());
        // }else{
        //   orderListType = 7;
        //   getOrderDetails(barcodeScanRes, true,false);
        // }

        //}
        //}

        getOrderDetails(barcodeScanRes);
      } else {
        // Fluttertoast.showToast(msg: "Format not correct!");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CollectList(
                    type: "Shelf",
                  )),
        );
      }

      // print("barcode : $barcodeScanRes");
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    try {
      final parser = Xml2Json();
      parser.parse(barcodeScanRes);
      var json = parser.toGData();
      // print(json);
    } catch (_, stackTrace) {
      SentryExemption.sentryExemption(_, stackTrace);
    }

    //BarCodeModel barCodeModel = barCodeModelFromJson(json.toString());
  }

  Future<void> getOrderDetails(String orderId) async {
    await CustomLoading().showLoadingDialog(context, true);
    String url = "${WebConstant.SCAN_ASSIGN_TO_SHELF_PARCEL}?OrderId=$orderId&isScan=true";
    _apiCallFram.getDataRequestAPI(url, token, context).then((response) async {
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          // List<AssignToShelf>assignToShelf ;
          AssignToShelf model = assignToShelfFromJson(response.body);
          // print(model);
          //assignToShelf.add(model);
          if (model.isCollection && model.isValidOrder) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => SecondRoute()),
            Navigator.push(context, MaterialPageRoute(builder: (context) => AssignToSelf(prescriptionList: model.medicineDetails, pmrList: model, orderId: orderId, isScan: true)));
          } else {
            _showSnackBar('Collection not available...');
            // showDialog(
            //   context: context,
            //   builder: (context) => new AlertDialog(
            //     title: Center(
            //         child: Text('Delivery Customer',
            //             style: TextStyle(
            //                 color: Colors.red, fontWeight: FontWeight.bold))),
            //     content: new Text(
            //         "Please change setting on the web to assign collection" +
            //             "!!!"),
            //     actions: <Widget>[
            //       new FlatButton(
            //         onPressed: () => Navigator.of(context).pop(true),
            //         child: new Text("Done"),
            //       ),
            //     ],
            //   ),
            // );

            //Fluttertoast.showToast(msg: model.message,toastLength: Toast.LENGTH_LONG);
          }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        _showSnackBar('Something went wrong');
        // print(_);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    // progressDialog = new ProgressDialog(context);
    // progressDialog.style(
    //     message: "Please wait...",
    //     borderRadius: 4.0,
    //     backgroundColor: Colors.white);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.blue));
    //  Fluttertoast.showToast(msg: "home2",toastLength: Toast.LENGTH_LONG);
    var logo = new Column(
      children: <Widget>[
        new SizedBox(
          child: Image.asset(
            'assets/delivery_icon.png',
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
        )
      ],
    );

    var logo2 = new Column(
      children: <Widget>[
        new SizedBox(
          child: Image.asset(
            'assets/courier.png',
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
        )
      ],
    );
    var logo3 = new Column(
      children: <Widget>[
        new SizedBox(
          child: Image.asset(
            'assets/location_icon.png',
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
        )
      ],
    );
    var logo4 = new Column(
      children: <Widget>[
        new SizedBox(
          child: Image.asset(
            'assets/stand.png',
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
        )
      ],
    );
    var logoScan = new Column(
      children: <Widget>[
        new SizedBox(
          child: Image.asset(
            'assets/qr_code.png',
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
        )
      ],
    );

    var deliveryItem = new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeliveryList(
                      true,
                    )),
          );
          //  Navigator.push(context,
          // MaterialPageRoute(builder: (context) => DeliveryList(true,)
          // Navigator.push(context,
          //  MaterialPageRoute(builder: (context) => PrescriptionBarScanner(prescriptionList: new List(),pmrList: new List(),isAssignSelf: false,)
          // /*userType == "Branch Admin" ? PrescriptionBarScanner(prescriptionList: new List(),pmrList: new List(),isAssignSelf: false,) : DeliveryList(true)*/));
        },
        child: new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: Colors.blueAccent, borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  logo,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Deliveries", style: TextStyle6White, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  SizedBox(
                    height: 20,
                  ),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var collectionItem = new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CollectList(
                        type: "Collection",
                      )));
        },
        child: new Container(
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: const Color(0xFFF8A340), borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logo2,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Collection", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var mapItem = new GestureDetector(
        onTap: () {
          /*if(userType == "Branch Admin"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DriverList()));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryMap(true)));
           //
          }*/

          Navigator.push(context, MaterialPageRoute(builder: (context) => DriverList()));
        },
        child: new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: const Color(0xFF4AC66E), borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  logo3,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Track Order", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  SizedBox(
                    height: 20,
                  ),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var assignShelfItem = new GestureDetector(
        onTap: () {
          // Navigator.push(context,
          // MaterialPageRoute(builder: (context) =>  PrescriptionBarScanner(prescriptionList: new List(),pmrList: new List(), isAssignSelf: true,)
          //   /*userType == "Branch Admin" ? PrescriptionBarScanner(prescriptionList: new List(),pmrList: new List(), isAssignSelf: true,) : CollectList(type: "Shelf",)*/));
          scanBarcodeNormal();
        },
        child: new Container(
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: const Color(0xFFE66363), borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  logo4,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Assign Shelf", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  SizedBox(
                    height: 20,
                  ),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var bulkScan = new GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BulkScanScreen()));
        },
        child: new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: BoxDecoration(color: Colors.blue, borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  logoScan,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Nursing Home Box Booking", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  SizedBox(
                    height: 20,
                  ),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var scanQr = new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scan_Prescription(
                        isAssignSelf: true,
                        pmrList: [],
                        isBulkScan: false,
                        prescriptionList: [],
                        type: "1",
                      )));
          // builder: (context) => QRViewExample(
          //             )));
        },
        child: new Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: Colors.orange, borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  logoScan,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Scan & Book", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  SizedBox(
                    height: 20,
                  ),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var scanQrTitan = new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scan_Prescription(
                        isAssignSelf: true,
                        pmrList: [],
                        isBulkScan: false,
                        prescriptionList: [],
                        type: "4",
                      )));
          // builder: (context) => QRViewExample(
          //             )));
        },
        child: new Container(
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: const Color(0xff4ba3bd), borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logoScan,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Titan Scan", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var scanQrProscript = new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scan_Prescription(
                        isAssignSelf: true,
                        pmrList: [],
                        isBulkScan: false,
                        prescriptionList: [],
                        type: "3",
                      )));
          // builder: (context) => QRViewExample(
          //             )));
        },
        child: new Container(
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: const Color(0xff4ba3bd), borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logoScan,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("Proscript Connect", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));
    var scanQrRxWeb = new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scan_Prescription(
                        isAssignSelf: true,
                        pmrList: [],
                        isBulkScan: false,
                        prescriptionList: [],
                        type: "2",
                      )));
          // builder: (context) => QRViewExample(
          //             )));
        },
        child: new Container(
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: new DecoratedBox(
              decoration: const BoxDecoration(color: const Color(0xff4ba3bd), borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logoScan,
                  new Padding(padding: const EdgeInsets.only(top: 10.0), child: new Text("RxWeb", style: TextStyle8Black, textScaleFactor: 2.0, textAlign: TextAlign.center)),
                  // _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                ],
              )),
        ));

    const PrimaryColor = const Color(0xFFffffff);
    const titleColor = const Color(0xFF151026);
    return Scaffold(
        drawer: DrawerScreen(userName, email, mobile, versionCode),
        appBar: AppBar(
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text('Home', style: Regular18Style),
          backgroundColor: PrimaryColor,
          flexibleSpace: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen())).then((value) => updateApi(token));
              },
              child: Container(
                padding: EdgeInsets.only(left: 0, right: 13, top: 30),
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.black,
                    ),
                    if (notification_count != null && notification_count > 0)
                      Positioned(
                        right: 5,
                        top: 2,
                        child: SizedBox(
                          height: 12,
                          width: 12,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              notification_count != null
                                  ? notification_count > 99
                                      ? "+99"
                                      : notification_count.toString()
                                  : "",
                              style: TextStyle6White,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // leading: Row(
          //   children: [
          //     new Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: GestureDetector(
          //           onTap: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Profile()));
          //           },
          //           child: CircleAvatar(
          //             backgroundColor: Colors.white,
          //             child: Image.asset('assets/profile_icon.png'),
          //           ),
          //         )),
          //   ],
          // ),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                //height: MediaQuery.of(context).size.height/1.5,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/bottom_bg.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SafeArea(
              child: Column(children: [
                deliveryItem,
                // collectionItem,
                mapItem,
                // assignShelfItem,
                scanQr,
                bulkScan,
                // new Center(
                //     child: new Container(
                //         child: GridView.count(
                //   shrinkWrap: true,
                //   padding: const EdgeInsets.all(20.0),
                //   crossAxisSpacing: 10.0,
                //   mainAxisSpacing: 10.0,
                //   crossAxisCount: 1,
                //   children: <Widget>[
                //     deliveryItem,
                //     // collectionItem,
                //     mapItem,
                //     // assignShelfItem,
                //     scanQr,
                //     // if (isTitanEnable) scanQrTitan,
                //     // scanQrProscript,
                //     // scanQrRxWeb
                //   ],
                // ))),
                new Text(''),
              ]),
            )
          ],
        ));
  }

  void checkUpdate(Map<String, dynamic> data) {
    int serverVersion = int.parse(data["data"]["app_version"].toString().trim());
    String updateMessage = data["data"]["message"].toString().trim();
    String force_update = data["data"]["force_update"].toString().trim();
    notification_count = data["data"]["notification_count"];
    print(data);
    setState(() {});
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      int appVersion = int.parse(packageInfo.buildNumber);
      try {
        if (Platform.isAndroid) {
          if (appVersion < serverVersion) {
            updateDialog(Platform.isAndroid, updateMessage, force_update);
          }
        } else {
          int appVersion = int.parse(WebConstant.iOS_APP_VERSION);
          logger.i(appVersion);
          int serverIOSVersion = int.parse(data["data"]["ios_app_version"].toString().trim());
          String ios_message = data["data"]["ios_message"].toString().trim();
          String ios_force_update = data["data"]["ios_force_update"].toString().trim();
          if (appVersion < serverIOSVersion) {
            updateDialog(Platform.isIOS, ios_message, ios_force_update);
          }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // Fluttertoast.showToast(msg: "responce:- $_");
        logger.i(_);
      }
    });
  }

  updateDialog(bool isAndroid, String updateMessage, String force_update) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        String title = "New Update Available";
        String message = updateMessage;
        String btnLabel = "Update Now";
        String btnLabelCancel = "Exit";
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: new CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  child: Text(btnLabel),
                  onPressed: () {
                    Navigator.pop(context1);
                    if (Platform.isIOS)
                      _launchURL(WebConstant.APP_STORE_URL);
                    else {
                      _launchURL(WebConstant.PLAY_STORE_URL);
                      SystemNavigator.pop();
                    }
                  }),
              if (force_update != "true")
                TextButton(
                  child: Text(btnLabelCancel),
                  onPressed: () {
                    Navigator.pop(context1);
                    // if (Platform.isAndroid) {
                    //   SystemNavigator.pop();
                    // } else {}
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Future<void> onHomeMenuError(String errorTxt) async {
    // TODO: implement onHomeMenuError
    await CustomLoading().showLoadingDialog(context, false);

    _showSnackBar(errorTxt);
    //_asyncConfirmDialog(_ctx);
  }

  @override
  Future<void> onHomeMenuSuccess(Map<String, dynamic> data) async {
    // TODO: implement onHomeMenuSuccess
    try {
      await CustomLoading().showLoadingDialog(context, true);

      List<dynamic> homelist = data['data'];
      if (homelist.length > 0) {
        setState(() {
          //List<GroupModel> l = data["data"].cast<GroupModel>();
          list = homelist;
        });
      } else {
        // _showSnackBar("No Data Found");
      }
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      // print(e);
    }
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
                Navigator.of(context).pop(_ctx);
              },
            ),
            TextButton(
              child: const Text(WebConstant.YES),
              onPressed: () async {
                /*var db = new DatabaseHelper();
                db.deleteUsers();*/
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                prefs.remove('userId');
                prefs.remove('name');
                prefs.remove('email');
                prefs.remove('mobile');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen(),
                    ),
                    ModalRoute.withName('/login_screen'));
              },
            )
          ],
        );
      },
    );
  }

  Future<Map<String, Object>> updateApi(String token) async {
    // print("test");
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
    final response = await http.get(Uri.parse(WebConstant.UPDATEAPP_URL), headers: headers);
    // print(response);
    final String res = response.body;
    final int statusCode = response.statusCode;
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
      Map<String, dynamic> data = json.decode(response.body);
      // print(data);
      if (data != null) {
        checkUpdate(data);
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
      //_showSnackBar('Something went wrong');
    }
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }
}

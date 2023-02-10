// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;


// import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:countdown_widget/countdown_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmdel_business/ui/ProfilePage/VechileInspection_Report/VechileInspection_Report_Screen.dart';
import '../../main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

// import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:pharmdel_business/DB/MyDatabase.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/delivery_pojo_model.dart';
import 'package:pharmdel_business/model/driver_dashboard_model.dart';
import 'package:pharmdel_business/model/order_model.dart';
import 'package:pharmdel_business/model/route_model.dart';
import 'package:pharmdel_business/model/vehicle_info_api_model.dart';
import 'package:pharmdel_business/stop_watch_timer.dart';
import 'package:pharmdel_business/ui/driver_user_type/suggetion_screen.dart';
import 'package:pharmdel_business/ui/lunchBreak/lunch_break_page.dart';
import 'package:pharmdel_business/ui/ProfilePage/profile.dart';
import 'package:pharmdel_business/util/CustomDialogBox.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:pharmdel_business/util/constants.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:pharmdel_business/util/log_print.dart';
import 'package:pharmdel_business/util/permission_utils.dart';
import 'package:pharmdel_business/util/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';

import '../../main.dart';
import '../../model/driver_model.dart';
import '../../model/parcel_box_api_response.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../branch_admin_user_type/scan_prescription.dart';
import '../edit_profile.dart';
import '../login_screen.dart';
import '../recive_notification_screen.dart';
import '../splash_screen.dart';
import 'StreamSocket.dart';
import 'driver_delivery_details.dart';
import 'route_maker.dart';

// IOWebSocketChannel channel;
StreamController<int> streamController = StreamController<int>.broadcast();

class DashboardDriver extends StatefulWidget {
  // final Stream<int>stream;
  int type;

  DashboardDriver(this.type);

  StateDashboardDriver createState() => StateDashboardDriver();
}

List<LocationData> locationArray = [];

class NumberList {
  String number;
  int index;

  NumberList({this.number, this.index});
}

class StateDashboardDriver extends State<DashboardDriver>
    with WidgetsBindingObserver
    implements PermissionCheckListner, BulkScanMode {
  ApiCallFram _apiCallFram = ApiCallFram();
  List<RouteList> routeList = List();

  List<RouteList> routeListAll = List();
  List<PharmacyList> pharmacyList = List();
  List<PharmacyList> nextPharmacyList = List();
  List<PharmacyList> endRoutePharmacyList = List();
  String accessToken;
  int _selectedRoutePosition = -1;
  int _selectedNursingPosition = -1;
  int _selectedTotePosition = -1;
  int totePosition = -1;
  int _selectedPharmacyPosition = -1;
  RouteList selectedRoute;
  PharmacyList selectedPharmacy;
  RouteList selectedRouteDropDown;
  RouteList selectedRouteRescheduleDropDown;
  PharmacyList selectedPharmacyDropDown;
  PharmacyList nextPharmacyListDropDown;
  PharmacyList endRoutePharmacyListDropDown;
  bool _isVisibleRouteList = false;
  bool _isVisiblePharmacyList = false;
  bool _isToteList = false;
  bool hideTote = false;
  int page,
      lastPageLength = 1;
  String selectedType = "total";
  PaginationViewType paginationViewType;
  GlobalKey<PaginationViewState> key;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  String driverId, routeId, pharmacyId;
  DriverDashBoardModal _dashBoardModal;
  List<DeliveryPojoModal> deliveryList = [];
  bool updateDialogShowing = false;
  String virCount = '0';

  List<DeliveryPojoModal> outdeliveryList = [];
  int receivedCount = 0;
  List<DriverModel> driverList = [];
  DriverModel selectedDriver;
  int checkboxIndex = 0;

  // ProgressDialog progressDialog;

  bool isLoadPagination = false,
      isRouteStart = false,
      isProgressAvailable = true;

  CountDownController countDownCtrl = CountDownController();
  Location location;

  bool _serviceEnabled,
      isRunBG = true,
      inProgressSocket = false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  int orderListType = 1;
  int outForDeliveryCount;

  DateTime lastLocationUpdated = DateTime.now();
  DateTime lastSocketLocationUpdated = DateTime.now();

  var yetToStartColor = const Color(0xFFF8A340);

  var notification_count = 0;

  bool routeOptimizeDialogShowing = false;

  bool isMessageShow = false;
  bool isAddressUpdated = false;

  Map<String, Object> prams;

  bool isNetworkError = false;

  String driverType = "";

  bool showEndRouteOptions = false;
  String pharmacyIdForSocket = "";

  List<delivery_list> deliveryListDB = [];
  List<customer_details> customerDetailsDB = [];
  List<customer_address> customerAddressDB = [];

  Stream<customer_details> customerDetailsElement;

  int isNextPharmacyAvailable;

  Timer timer1;

  bool isDialogShowing = false;

  bool selectAllDelivery = false;

  bool isShowRechedule = false;

  String selectedDate;
  String bulkScanDate;

  String selectedDateTimeStamp;
  final DateFormat formatter = DateFormat("dd-MM-yyyy");

  String recheduleOrderId = "";

  String versionCode = "";

  BuildContext dialogContext;

  List<Exemptions> exemptionList = [];

  List<TextEditingController> preChargeController = [];
  List<TextEditingController> deliveryChargeController = [];

  bool isLogin = false;
  StreamSocket locationStreamSocket = StreamSocket();
  IO.Socket locationSocket;

  double lat = 0.0;
  double lng = 0.0;

  int time = 5;

  bool isSwitched = false;

  Timer timerLocation;

  List<ParcelBoxData> parcelBoxList = [];
  bool isCallTimer = false;

  bool isProgress = false;

  Map<String, dynamic> library;

  bool showIncreaseTime = false;

  List<VehicleData> vehicleList = [];
  VehicleData selectedVehicle = VehicleData();

  bool isCheckCdOnComplete = false;
  bool isCheckFridgeOnComplete = false;
  bool isCheckDeliveryNote = false;

  void mySetState(int) {
    _dashBoardModal.orderCounts.pickedupOrders = 0;
    // _dashBoardModal.orderCounts.outForDeliveryOrders = 0;
    setState(() {
      SharedPreferences.getInstance().then((value) {
        isRouteStart = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      });
      //_dashBoardModal.orderCounts.pickedupOrders = 0;
      orderListType = int;
      if (int == 7) {
        SharedPreferences.getInstance().then((value) {
          value.setBool(WebConstant.IS_ROUTE_START, false);
          isRouteStart = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
          isAddressUpdated =
              value.getBool(WebConstant.IS_ADDRESS_UPDATED) ?? false;
        });
        selectWithTypeCount(WebConstant.Status_total);
      } else {
        // Comment for start route 11
        // selectWithTypeCount(WebConstant.Status_out_for_delivery);
      }
    });
  }

  // Future<void> getLocation() async {
  //    await CheckPermission.checkLocationPermissionOnly(context).then((value) async {
  //      if (value) {
  //          logger.i("isCallTimer");
  //            Timer.periodic(Duration(seconds: time), (timer) async {
  //              logger.i("log");
  //              geoLocator.GeolocatorPlatform.instance
  //                  .getCurrentPosition(locationSettings: geoLocator.LocationSettings(accuracy: geoLocator.LocationAccuracy.high)).then((value) async {
  //                lat = value.latitude;
  //                lng = value.longitude;
  //                timerLocation = timer;
  //                time = 5;
  //                if (locationSocket.connected) {
  //                  if(lastSocketLocationUpdated.isBefore(DateTime.now())) {
  //                    lastSocketLocationUpdated = DateTime(
  //                        DateTime
  //                            .now()
  //                            .year,
  //                        DateTime
  //                            .now()
  //                            .month,
  //                        DateTime
  //                            .now()
  //                            .day,
  //                        DateTime
  //                            .now()
  //                            .hour,
  //                        DateTime
  //                            .now()
  //                            .minute,
  //                        DateTime
  //                            .now()
  //                            .second + 5);
  //                    var prefs = await SharedPreferences.getInstance();
  //                    isLogin =
  //                    prefs.getBool(WebConstant.IS_LOGIN) != null ? prefs.getBool(
  //                        WebConstant.IS_LOGIN) : false;
  //                    logger.i("isLogin $isLogin");
  //                    if (isLogin) {
  //                      if (driverType == Constants.dadicatedDriver ||
  //                          driverType == Constants.sharedDriver) {
  //                        logger.i('connect1');
  //                        Map<String, dynamic> library = {
  //                          "driver_id": "$driverId",
  //                          "pharmacy_id": "$pharmacyIdForSocket",
  //                          "device_name": "android",
  //                          "route_id": routeId != null && routeId.isNotEmpty
  //                              ? "$routeId"
  //                              : "",
  //                          "latitude": "${lat}",
  //                          "longitude": "${lng}",
  //                        };
  //                        logger.i(jsonEncode(library));
  //                        // Fluttertoast.showToast(msg: "Update");
  //                        locationSocket.emit(
  //                            'sendLocationToServer', jsonEncode(library));
  //                        time = 5;
  //                      }
  //                    }
  //                  }
  //                } else {
  //                  time = 5;
  //                }
  //              });
  //
  //            });
  //          }
  //    });
  //  }

  Future<void> connectAndListen() async {
    logger.i("in connection");
    try {
      if (locationSocket.connected) {
        updateLocation();
      } else {
        locationSocket.onConnect((_) async {
          logger.i('connectDikshant');
          updateLocation();
        });
      }

      //When an event recieved from server, data is added to the stream
      locationSocket.on('sendLocationToClient', (data) {
        locationStreamSocket.addLocationResponse(data);
      });
      locationSocket.onDisconnect((_) {
        logger.i('connectdikshant33');
        logger.i('disconnect');
      });
      locationSocket.onConnectError((data) {
        logger.i('connectdikshant22');
        logger.i(data);
      });
      locationSocket.onConnect((data) {
        logger.i('connectdikshant11');
        // getLocation();
      });
      // socket.connect();
    } catch (ex, stackTrace) {
      SentryExemption.sentryExemption(ex, stackTrace);
      logger.i("ex $ex");
    }
  }

  @override
  Future<void> initState() {
    locationSocket = IO.io(WebConstant.SOCKET_URL,
        OptionBuilder().setTransports(['websocket']).build());
    bulkScanDate = formatter.format(DateTime.now());
    logger.i("bulkScanDate $bulkScanDate");
    versionCode1();
    autoEndRoute();
    WidgetsBinding.instance.addObserver(this);
    page = 0;
    // progressDialog = ProgressDialog(context, isDismissible: true);
    paginationViewType = PaginationViewType.listView;
    selectedDate = formatter.format(DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day + 1));
    selectedDateTimeStamp = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    key = GlobalKey<PaginationViewState>();
    getToken();
    super.initState();
    streamController.stream.asBroadcastStream().listen((index) {
      mySetState(index);
    });
    checkLocationPermission();
    checkLastTime(context);

    SharedPreferences.getInstance().then((value) async {
      // print(value);
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      pharmacyIdForSocket = value.getString(WebConstant.PHARMACY_ID_FOR_SOCKET);
      isLoadPagination = accessToken != null;
      driverId = value.getString(WebConstant.USER_ID);
      routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
      isRouteStart = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      driverType = value.getString(WebConstant.DRIVER_TYPE) ?? "";
      connectAndListen();

      bool checkInternet = await ConnectionValidator().check();
      if (checkInternet) {
        // updateLocation();
        try {
          getRoutes();
        } catch (_, stackTrace) {
          SentryExemption.sentryExemption(_, stackTrace);
          getRoutes();
        }
        // if (routeId != "0" && isRouteStart) {

        if (isRouteStart) {
          page = 0;
          lastPageLength = -1;
          selectedType = WebConstant.Status_out_for_delivery;
          orderListType = 4;
          selectWithTypeCount(WebConstant.Status_out_for_delivery);
        }
        // }
      } else if (isRouteStart) {
        isProgressAvailable = false;
        selectedType = WebConstant.Status_out_for_delivery;
        orderListType = 4;
        getDeliveryListFromDB();
      }
      if (!isRouteStart) {
        value.remove(WebConstant.DELIVERY_TIME);
        if (stopWatchTimer != null) {
          logger.i("stopwatch disposed");
          showIncreaseTime = false;
          stopWatchTimer.dispose();
          stopWatchTimer = null;
        }
      }
    });

    initNotification();
    initSocketFetch();
    // if(!isRouteStart){
    //   init();
    // }
  }

  @override
  void isSelected(bool isSelect) {
    logger.i("inSelect1");
    if (isSelect) {
      if (!isRouteStart) {
        logger.i("inSelect2");
        setState(() {
          page = 0;
          lastPageLength = -1;
          orderListType = 8;
          selectedType = WebConstant.Status_picked_up;
          selectWithTypeCount(WebConstant.Status_picked_up);
        });
      } else {
        setState(() {
          page = 0;
          lastPageLength = -1;
          selectedType = WebConstant.Status_out_for_delivery;
          orderListType = 4;
          selectWithTypeCount(WebConstant.Status_out_for_delivery);
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (isRouteStart) {
      isRouteStart = false;
      if (prams != null) prams = {};
    }
    if (timer1 != null) {
      timer1.cancel();
    }
    if (timerLocation != null) {
      timerLocation.cancel();
      isRunBG = false;
      logger.i("log");
    }
    // SharedPreferences.getInstance().then((value) {
    //   if(remainingTIme != null){
    //     value.setInt(WebConstant.DELIVERY_TIME, remainingTIme);
    //   }
    // });
    super.dispose();
    logger.i("-----Dispose-----");
  }

//get routes api dk
  Future<void> getRoutes() async {
    _selectedTotePosition = -1;
    final pref = await SharedPreferences.getInstance();
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }
    // CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.GET_ROUTE_URL + "?pharmacyId=${0}");
    _apiCallFram
        .getDataRequestAPI(
        WebConstant.GET_ROUTE_URL + "?pharmacyId=${0}", accessToken, context)
        .then((response) async {
      getParcelBoxData(driverId);
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
        if (response != null) {
          dev.log("GET ROUTES API RESPONS IS :::>>>>${response.body}");

          logger.i(response.body);
          RouteModel model = routeModelFromJson(response.body);
          // logger.i("routeList_" + model.routeList.length.toString());
          virCount =
              json.decode(response.body)["vehicle_inspection"].toString();
          String dk = json.decode(response.body)["vehicle_id"].toString();

          print("VIR STATUS IS ::::::::>>>>>>>>" + virCount);
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(WebConstant.VEHICLE_ID, dk);
          print(
              "Vehicle id coming from route list api is ;;;;:::::::>>>>" + dk);
          if (virCount == '1') {
            virUpdate();
          }
          setState(() {
            routeList = model.routeList;
            routeListAll = model.routeListAll;
            logger.i(routeListAll);
            pharmacyList = model.pharmacyList;
            nextPharmacyList.clear();
            endRoutePharmacyList.clear();
            nextPharmacyList.addAll(model.pharmacyList);
            endRoutePharmacyList.addAll(model.pharmacyList);
            if (model.pharmacyList.isNotEmpty) {
              nextPharmacyListDropDown = model.pharmacyList[0];
              endRoutePharmacyListDropDown = model.pharmacyList[0];
              if (driverType == Constants.dadicatedDriver)
                pref.setInt(
                    WebConstant.PHARMACY_ID, model.pharmacyList[0].pharmacyId);
            }
            PharmacyList selectPharmacy = PharmacyList();
            selectPharmacy.pharmacyName = "None";
            selectPharmacy.pharmacyId = 0;
            selectPharmacy.address = "";
            selectPharmacy.lat = 0.0;
            selectPharmacy.lng = 0.0;
            nextPharmacyList.add(selectPharmacy);
            PharmacyList selectPharmacy1 = PharmacyList();
            selectPharmacy1.pharmacyName = "Home Location";
            selectPharmacy1.pharmacyId = 0;
            selectPharmacy1.address = "";
            selectPharmacy1.lat = 0.0;
            selectPharmacy1.lng = 0.0;
            endRoutePharmacyList.add(selectPharmacy1);
            if (routeList != null && routeList.isNotEmpty &&
                routeList.length == 1) {
              routeId = routeList[0].routeId.toString();
              SharedPreferences.getInstance().then((value) {
                value.setString(WebConstant.ROUTE_ID, routeId);
              });
            }

            if (routeListAll != null && routeListAll.isNotEmpty &&
                routeListAll.length > 0) {
              selectedRouteRescheduleDropDown = routeListAll[0];
            }
            for (RouteList route in routeListAll) {
              if (routeId == "${route.routeId}") {
                setState(() {
                  selectedRoute = route;
                  selectedRouteRescheduleDropDown = route;
                });
              }
            }

            if (routeId != "0" && isRouteStart) {
              isProgressAvailable = false;
              selectedType = WebConstant.Status_out_for_delivery;
              orderListType = 4;
              getDeliveryListFromDB();
            } else {
              orderListType = 8;
              selectedType = WebConstant.Status_picked_up;
              selectWithTypeCount(WebConstant.Status_picked_up);
            }
            SharedPreferences.getInstance().then((value) {
              value.setString('route_list', response.body);
            });
          });
        }
      } catch (_Ex, stackTrace) {
        SentryExemption.sentryExemption(_Ex, stackTrace);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
      setState(() {
        // isProgressAvailable = false;
      });
    });
  }

  Future<Map<String, Object>> updateApi() async {
    // logger.i("test");
    var token = await MyDatabase().getToken();
    bool checkInternet = await ConnectionValidator().check();
    if (checkInternet) {
      logger.i("log4 ${token.first.token.toString()}");
      Map<String, String> headers = {
        'Accept': 'application/json',
        "Content-type": "application/json",
        "Authorization": 'Bearer ${token.first.token.toString()}'
      };
      logger.i(WebConstant.GetNotificationCount);
      final response = await http.get(
          Uri.parse(WebConstant.GetNotificationCount), headers: headers);
      // print(response);
      logger.i(response.body);
      if (response != null && response.body != null &&
          response.body == "Unauthenticated") {
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
          notification_count = data["list"];
          if (mounted) setState(() {});
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
            PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation animation,
                    Animation secondaryAnimation) {
                  return LoginScreen();
                },
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
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
        //_showSnackBar('Something went wrong');
      }
    }
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }

  Future<List<DeliveryPojoModal>> fetchDeliveryList(int index) async {
    List<DeliveryPojoModal> list = [];
    if (index == 0) {
      isShowRechedule = false;
      selectAllDelivery = false;
    }
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet && isRouteStart) {
      logger.i("test1 $selectedType");
      if (selectedType == WebConstant.Status_out_for_delivery) {
        isProgressAvailable = false;
        orderListType = 4;
        list = outdeliveryList;
      }
    } else {
      checkLastTime(context);

      if (index == 0) {
        deliveryList.clear();
        page = 0;
        lastPageLength = -1;
        if (routeId.isEmpty) {
          Fluttertoast.showToast(msg: 'Select Route');
          return list;
        }
      }
      if (lastPageLength >= 0 && lastPageLength < 10 && page > 0) return list;
      page++;
      if (page == 0) page++;
      String prams = "?"
          "routeId=$routeId"
          "&page=$page"
          "&PageSize=30"
          "&Status=$orderListType";
      String url = "${WebConstant.GET_DELIVERY_LIST}$prams";

      logger.i(url);
      logger.i(accessToken);
      await _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
          response) async {
        logger.i("GetDeliveryList url is ========>");
        logger.i(response.body);
        // if (ProgressDialog(context).isShowing()) ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
        try {
          if (response != null && response.body != null &&
              response.body == "Unauthenticated") {
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
          if (response != null) {
            dev.log("RESPONSE OF DELIVERY LIST API IS :::::" + response.body);
            if (!updateDialogShowing) checkUpdate(
                json.decode(response.body)["checkUpdateApp"]);

            // virCount = json.decode(response.body)["vehicle_inspection"].toString();
            //
            // print("VIR STATUS IS ::::::::>>>>>>>>" + virCount);

            // PrintLog.printLog(
            //     "Check status of Vehicle inspection : ${json.decode(response.body)["vehicle_inspection"]}");
            _dashBoardModal = driverDashBoardModalFromJson(response.body);
            if (_dashBoardModal != null &&
                _dashBoardModal.notification_count != null) {
              notification_count = _dashBoardModal.notification_count;
            }
            isRouteStart = _dashBoardModal.isStart;
            if (_dashBoardModal.exemptions != null &&
                _dashBoardModal.exemptions.isNotEmpty &&
                _dashBoardModal.exemptions.length > 0) {
              await clearExemptionList();
              await Future.forEach(
                  _dashBoardModal.exemptions, (Exemptions element) async {
                ExemptionsDataCompanion exemptionsDataCompanion;
                exemptionsDataCompanion = ExemptionsDataCompanion.insert(
                    exemptionId: element.id != null ? int.tryParse(
                        element.id.toString()) : 0,
                    serialId: element.serialId != null &&
                        element.serialId.isNotEmpty ? element.serialId : "",
                    name: element.name != null && element.name.isNotEmpty
                        ? element.name
                        : "");
                await MyDatabase().insertExemption(exemptionsDataCompanion);
              });
            }

            if (_dashBoardModal.deliveryList.isNotEmpty) {
              lastPageLength = _dashBoardModal.deliveryList.length;
              for (DeliveryPojoModal delivery in _dashBoardModal.deliveryList) {
                list.add(delivery);
              }
              setState(() {
                receivedCount = _dashBoardModal.orderCounts.totalOrders ?? 0;
                if (orderListType == 6 && index > 0 && selectAllDelivery) {
                  list.forEach((element) {
                    element.isSelected = true;
                    deliveryList.add(element);
                  });
                } else
                  deliveryList.addAll(list);
                deliveryList.forEach((element) {
                  if (element.isControlledDrugs != null &&
                      element.isControlledDrugs == "t")
                    element.isCD = true;
                  else
                    element.isCD = false;
                  if (element.isStorageFridge != null &&
                      element.isStorageFridge == "t")
                    element.isFridge = true;
                  else
                    element.isFridge = false;
                });
                // print(deliveryList);
              });
            } else {
              setState(() {
                receivedCount = _dashBoardModal.orderCounts.totalOrders ?? 0;
              });
            }
          }
        } catch (_Ex, stackTrace) {
          SentryExemption.sentryExemption(_Ex, stackTrace);
          logger.i("Exception:" + _Ex.toString());
          Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
        }
      }).catchError((onError) async {
        // if (ProgressDialog(context).isShowing()) ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
      });
      setState(() {
        isProgressAvailable = false;
      });
    }
    return list;
  }

  void checkUpdate(Map<String, dynamic> data) {
    logger.i(data);
    int serverVersion = int.parse(data["app_version"].toString().trim());

    String updateMessage = data["message"].toString().trim();
    String force_update = data["force_update"].toString().trim();

    setState(() {});

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      int appVersion = int.parse(packageInfo.buildNumber);
      String buildNumber = packageInfo.buildNumber;
      try {
        if (Platform.isAndroid) {
          //change it back to less then because it was removed by my to send build
          if (appVersion < serverVersion) {
            updateDialogShowing = true;
            updateDialog(Platform.isAndroid, updateMessage, force_update);
          }
        } else if (Platform.isIOS) {
          int appVersion = int.parse(WebConstant.iOS_APP_VERSION);
          logger.i(appVersion);
          int serverIOSVersion = int.parse(
              data["ios_app_version"].toString().trim());
          String ios_message = data["ios_message"].toString().trim();
          String ios_force_update = data["ios_force_update"].toString().trim();
          if (appVersion < serverIOSVersion) {
            updateDialogShowing = true;
            updateDialog(Platform.isIOS, ios_message, ios_force_update);
          }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
      }
    });
  }

  Future<void> virUpdate() async {
    await virCount;
    if (virCount == '1');
    virDialog();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(WebConstant.VIR_Value, virCount);
    print("VIR VALUE IN SHARED PREFS SEATED TO ::::>>>>>" +
        prefs.getString(WebConstant.VIR_Value).toString());
  }

  Future<void> updateDialog(bool isAndroid, String updateMessage,
      String force_update) async {
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

  Future<void> virDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context1) {
        String title = "Please Fill Vehicle Inspection Report";
        String message = "Vehicle Inspection Report is pending for your vehicle , please fill it now ";
        String btnLabel = "Fill Now";
        String btnLabelCancel = "Later";
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: new CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  child: Text(btnLabel),
                  onPressed: () {
                    // Navigator.pop(context1);
                    Navigator.push(
                        context1, MaterialPageRoute(builder: (context) =>
                        VechileInspectionReportScreen('')));
                  }),
              TextButton(
                  child: Text(btnLabelCancel),
                  onPressed: () {
                    Navigator.pop(context1);
                  }),
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

  void getParcelList(int index) async {
    checkLastTime(context);
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      return;
    }
    outdeliveryList.clear();
    if (routeId != "0" && isRouteStart) {
      // updateLocation();
      // updateLocation();
    }
    if (locationArray == null || locationArray.length <= 0) {
      return;
    }
    setState(() {
      isProgressAvailable = true;
    });
    String prams =
        "?driverId=$driverId&routeId=$routeId&latitude=${locationArray.last
        .latitude}&longitude=${locationArray.last.longitude}";
    String url = "${WebConstant.GET_SORTEDLIST_BY_DURATION}$prams";
    logger.i(url);
    await _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
        response) async {
      if (mounted) {
        setState(() {
          isProgressAvailable = false;
        });
      }

      try {
        logger.i(response.body);
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
        isNetworkError = false;
        if (response != null && response.body != null &&
            !response.body.startsWith("{\"error\":true")) {
          outdeliveryList.clear();
          selectedType = WebConstant.Status_out_for_delivery;
          _dashBoardModal = driverDashBoardModalFromJson(response.body);

          if (_dashBoardModal != null && _dashBoardModal.systemTime != null &&
              _dashBoardModal.systemTime.isNotEmpty) {
            await SharedPreferences.getInstance().then((value) {
              logger.i(" Driver TYPE :::: ${driverType}");

              if (driverType != "Shared") {
                /// #Himanshu 983 uncomment for working
                deliveryTime = int.tryParse(_dashBoardModal.systemTime);
                value.setInt(WebConstant.DELIVERY_TIME,
                    int.tryParse(_dashBoardModal.systemTime));

                /// #Himanshu 983 uncomment for working
              }
            });
          }
          // outdeliveryList.addAll(_dashBoardModal.deliveryList);
          if (_dashBoardModal.deliveryList != null &&
              _dashBoardModal.deliveryList.isNotEmpty &&
              _dashBoardModal.deliveryList.length > 0) {
            await clearDliveryTable();
            // if(!isRouteStart)
            // await Future.forEach(_dashBoardModal.deliveryList, (DeliveryPojoModal element) async {
            //   var delivery = await MyDatabase().getDeliveryDetilas(
            //       element.orderId);
            //   logger.i(delivery);
            //   if (delivery == null) {
            //     DeliveryListCompanion deliveryListObj;
            //     CustomerDetailsCompanion customerDetailsObj;
            //     CustomerAddressesCompanion customerAddressObj;
            //
            //     logger.i("testttt1");
            //     deliveryListObj = DeliveryListCompanion.insert(
            //       param1: "",
            //       param2: "",
            //       param3: "",
            //       param4: "",
            //       param5: "",
            //       param6: "",
            //       subsId: element.subsId != null ? element.subsId : 0,
            //       rxCharge: element.rxCharge != null ? element.rxCharge : '0',
            //       rxInvoice: element.rxInvoice != null ? element.rxInvoice : 0,
            //       delCharge: element.delCharge != null ? element.delCharge : '0',
            //       paymentStatus: element.paymentStatus != null && element.paymentStatus.isNotEmpty ? element.paymentStatus : "",
            //       pharmacyId: element.pharmacyId != null ? element.pharmacyId : 0,
            //       isDelCharge: element.isDelCharge != null ? element.isDelCharge : 0,
            //       isSubsCharge: element.isPresCharge != null ? element.isPresCharge : 0,
            //       bagSize: element.bagSize != null && element.bagSize.isNotEmpty ? element.bagSize : "",
            //       exemption: element.exemption != null && element.exemption.isNotEmpty ? element.exemption : "",
            //       sortBy: element.sortBy != null ? element.sortBy : "",
            //       parcelBoxName: "",
            //       userId: driverId != null && driverId != "" ? driverId : "",
            //       orderId: element.orderId != null ? element.orderId : 0,
            //       routeId: element.routeId != null && element.routeId != ""
            //           ? element.routeId.toString()
            //           : "",
            //       serviceName: element.serviceName != null &&
            //           element.serviceName != "" ? element.serviceName : "",
            //       deliveryNotes: element.deliveryNotes != null &&
            //           element.deliveryNotes != "" ? element.deliveryNotes : "",
            //       existingDeliveryNotes: element.existingDeliveryNotes !=
            //           null && element.existingDeliveryNotes != "" ? element
            //           .existingDeliveryNotes : "",
            //       isControlledDrugs: element.isControlledDrugs != null &&
            //           element.isControlledDrugs != "" ? element
            //           .isControlledDrugs : "",
            //       isStorageFridge: element.isStorageFridge != null &&
            //           element.isStorageFridge != ""
            //           ? element.isStorageFridge
            //           : "",
            //       isCronCreated: element.isCronCreated != null &&
            //           element.isCronCreated != "null" &&
            //           element.isCronCreated != ""
            //           ? element.isCronCreated
            //           : "",
            //       deliveryStatus: element.status != null &&
            //           element.status == "OutForDelivery" ? 4 : 0,
            //       pharmacyName: element.pharmacyName != null &&
            //           element.pharmacyName != "null" &&
            //           element.pharmacyName != "" ? element.pharmacyName : "",
            //       status: element.status != null &&
            //           element.status != "null" && element.status != ""
            //           ? element.status
            //           : "",
            //       pmr_type: element.pmr_type != null &&
            //           element.pmr_type != "null" && element.pmr_type != ""
            //           ? element.pmr_type
            //           : "",
            //       pr_id: element.pr_id != null && element.pr_id != "null" &&
            //           element.pr_id != "" ? element.pr_id : "",
            //     );
            //     logger.i("deliveryListObj: $deliveryListObj");
            //     await MyDatabase().insertDeliveries(deliveryListObj);
            //
            //     customerDetailsObj = CustomerDetailsCompanion.insert(
            //       param4: "",
            //         param3: "",
            //         param2: "",
            //         param1: "",
            //         mobile: "",
            //         customerId: element.customerDetials.customerId != null
            //             ? element.customerDetials.customerId
            //             : 0,
            //         surgeryName: element.parcelBoxName !=
            //             null &&
            //             element.parcelBoxName != "" ? element
            //             .parcelBoxName : "",
            //         service_name: element.customerDetials.service_name !=
            //             null && element.customerDetials.service_name != ""
            //             ? element.customerDetials.service_name
            //             : "",
            //         firstName: element.customerDetials.firstName != null &&
            //             element.customerDetials.firstName != "" ? element
            //             .customerDetials.firstName : "",
            //         middleName: element.customerDetials.middleName != null &&
            //             element.customerDetials.middleName != "" ? element
            //             .customerDetials.middleName : "",
            //         lastName: element.customerDetials.lastName != null &&
            //             element.customerDetials.lastName != "" ? element
            //             .customerDetials.lastName : "",
            //         title: element.customerDetials.title != null &&
            //             element.customerDetials.title != "" ? element
            //             .customerDetials.title : "",
            //         address: element.customerDetials.address != null &&
            //             element.customerDetials.address != "" ? element
            //             .customerDetials.address : "",
            //         order_id: element.orderId != null ? element.orderId : 0
            //     );
            //     logger.i("customerDetailsObj: $customerDetailsObj");
            //     await MyDatabase().insertCustomerDetails(customerDetailsObj);
            //
            //     customerAddressObj = CustomerAddressesCompanion.insert(
            //       matchAddress: "",
            //         param1: "",
            //         param2: "",
            //         param3: "",
            //         param4: "",
            //         address1: element.customerDetials.customerAddress
            //             .address1 != null &&
            //             element.customerDetials.customerAddress.address1 != ""
            //             ? element.customerDetials.customerAddress.address1
            //             : "",
            //         alt_address: element.customerDetials.customerAddress
            //             .alt_address != null &&
            //             element.customerDetials.customerAddress.alt_address !=
            //                 "" ? element.customerDetials.customerAddress
            //             .alt_address : "",
            //         address2: element.customerDetials.customerAddress
            //             .address2 != null &&
            //             element.customerDetials.customerAddress.address2 != ""
            //             ? element.customerDetials.customerAddress.address2
            //             : "",
            //         postCode: "${element.customerDetials.customerAddress
            //             .postCode != null &&
            //             element.customerDetials.customerAddress.postCode != ""
            //             ? element.customerDetials.customerAddress.postCode
            //             : ""}" + "${element.customerDetials.mobile != null &&
            //             element.customerDetials.mobile != "" ? "#"+element
            //             .customerDetials.mobile : ""}",
            //         latitude: element.customerDetials.customerAddress
            //             .latitude != null &&
            //             element.customerDetials.customerAddress.latitude != ""
            //             ? element.customerDetials.customerAddress.latitude
            //             : 0.0,
            //         longitude: element.customerDetials.customerAddress
            //             .longitude != null &&
            //             element.customerDetials.customerAddress.longitude !=
            //                 ""
            //             ? element.customerDetials.customerAddress.longitude
            //             : 0.0,
            //         duration: element.customerDetials.customerAddress
            //             .matchAddress != null &&
            //             element.customerDetials.customerAddress.matchAddress != ""
            //             ? element.customerDetials.customerAddress.matchAddress
            //             : "",
            //         order_id: element.orderId != null ? element.orderId : 0
            //     );
            //     logger.i("customerAddressObj: $customerAddressObj");
            //     var intType = await MyDatabase().insertCustomerAddress(
            //         customerAddressObj);
            //     logger.i(intType);
            //   }
            // });
            if (isRouteStart) {
              int index1 = -1;
              var completeAllList = await MyDatabase()
                  .getAllOrderCompleteData();
              await Future.forEach(_dashBoardModal.deliveryList, (
                  DeliveryPojoModal element) async {
                if (completeAllList != null && completeAllList.isNotEmpty) {
                  completeAllList.forEach((element2) {
                    var orderId = element2.deliveryId.split(",");
                    if (orderId != null && orderId.isNotEmpty) {
                      index1 = orderId.indexWhere((element3) =>
                      element3.toString() == element.orderId.toString());
                    }
                  });
                }
                var delivery = await MyDatabase().getDeliveryDetilas(
                    element.orderId);
                logger.i(delivery);
                if (delivery == null && index1 < 0) {
                  DeliveryListCompanion deliveryListObj;
                  CustomerDetailsCompanion customerDetailsObj;
                  CustomerAddressesCompanion customerAddressObj;

                  logger.i("testttt1");
                  deliveryListObj = DeliveryListCompanion.insert(
                    param1: "",
                    param2: "",
                    param3: "",
                    param4: "",
                    param5: "",
                    param6: "",
                    totalStorageFridge: element.totalStorageFridge != null
                        ? element.totalStorageFridge
                        : 0,
                    totalControlledDrugs: element.totalControlledDrugs != null
                        ? element.totalControlledDrugs
                        : 0,
                    nursing_home_id: element.nursing_home_id != null ? element
                        .nursing_home_id : 0,
                    subsId: element.subsId != null ? element.subsId : 0,
                    rxCharge: element.rxCharge != null ? element.rxCharge : '0',
                    rxInvoice: element.rxInvoice != null
                        ? element.rxInvoice
                        : 0,
                    delCharge: element.delCharge != null
                        ? element.delCharge
                        : '0',
                    paymentStatus:
                    element.paymentStatus != null &&
                        element.paymentStatus.isNotEmpty
                        ? element.paymentStatus
                        : "",
                    pharmacyId: element.pharmacyId != null
                        ? element.pharmacyId
                        : 0,
                    isDelCharge: element.isDelCharge != null ? element
                        .isDelCharge : 0,
                    isSubsCharge: element.isPresCharge != null ? element
                        .isPresCharge : 0,
                    bagSize: element.bagSize != null &&
                        element.bagSize.isNotEmpty ? element.bagSize : "",
                    exemption: element.exemption != null &&
                        element.exemption.isNotEmpty ? element.exemption : "",
                    sortBy: element.sortBy != null ? element.sortBy : "",
                    parcelBoxName: "",
                    userId: driverId != null && driverId != "" ? driverId : "",
                    orderId: element.orderId != null ? element.orderId : 0,
                    routeId: element.routeId != null && element.routeId != ""
                        ? element.routeId.toString()
                        : "",
                    serviceName: element.serviceName != null &&
                        element.serviceName != "" ? element.serviceName : "",
                    deliveryNotes:
                    element.deliveryNotes != null && element.deliveryNotes != ""
                        ? element.deliveryNotes
                        : "",
                    existingDeliveryNotes: element.existingDeliveryNotes !=
                        null && element.existingDeliveryNotes != ""
                        ? element.existingDeliveryNotes
                        : "",
                    isControlledDrugs: element.isControlledDrugs != null &&
                        element.isControlledDrugs != ""
                        ? element.isControlledDrugs
                        : "",
                    isStorageFridge:
                    element.isStorageFridge != null &&
                        element.isStorageFridge != ""
                        ? element.isStorageFridge
                        : "",
                    isCronCreated:
                    element.isCronCreated != null &&
                        element.isCronCreated != "null" &&
                        element.isCronCreated != ""
                        ? element.isCronCreated
                        : "",
                    deliveryStatus: element.status != null &&
                        element.status == "OutForDelivery" ? 4 : 0,
                    pharmacyName:
                    element.pharmacyName != null &&
                        element.pharmacyName != "null" &&
                        element.pharmacyName != ""
                        ? element.pharmacyName
                        : "",
                    status: element.status != null &&
                        element.status != "null" && element.status != ""
                        ? element.status
                        : "",
                    pmr_type: element.pmr_type != null &&
                        element.pmr_type != "null" && element.pmr_type != ""
                        ? element.pmr_type
                        : "",
                    pr_id: element.pr_id != null && element.pr_id != "null" &&
                        element.pr_id != "" ? element.pr_id : "",
                  );
                  logger.i("deliveryListObj: $deliveryListObj");
                  await MyDatabase().insertDeliveries(deliveryListObj);

                  customerDetailsObj = CustomerDetailsCompanion.insert(
                      param4: "",
                      param3: "",
                      param2: "",
                      param1: "",
                      mobile: "",
                      customerId: element.customerDetials.customerId != null
                          ? element.customerDetials.customerId
                          : 0,
                      surgeryName:
                      element.parcelBoxName != null &&
                          element.parcelBoxName != ""
                          ? element.parcelBoxName
                          : "",
                      service_name:
                      element.customerDetials.service_name != null &&
                          element.customerDetials.service_name != ""
                          ? element.customerDetials.service_name
                          : "",
                      firstName: element.customerDetials.firstName != null &&
                          element.customerDetials.firstName != ""
                          ? element.customerDetials.firstName
                          : "",
                      middleName: element.customerDetials.middleName != null &&
                          element.customerDetials.middleName != ""
                          ? element.customerDetials.middleName
                          : "",
                      lastName: element.customerDetials.lastName != null &&
                          element.customerDetials.lastName != ""
                          ? element.customerDetials.lastName
                          : "",
                      title: element.customerDetials.title != null &&
                          element.customerDetials.title != ""
                          ? element.customerDetials.title
                          : "",
                      address: element.customerDetials.address != null &&
                          element.customerDetials.address != ""
                          ? element.customerDetials.address
                          : "",
                      order_id: element.orderId != null ? element.orderId : 0);
                  logger.i("customerDetailsObj: $customerDetailsObj");
                  await MyDatabase().insertCustomerDetails(customerDetailsObj);

                  customerAddressObj = CustomerAddressesCompanion.insert(
                      matchAddress: "",
                      param1: "",
                      param2: "",
                      param3: "",
                      param4: "",
                      address1: element.customerDetials.customerAddress
                          .address1 != null &&
                          element.customerDetials.customerAddress.address1 != ""
                          ? element.customerDetials.customerAddress.address1
                          : "",
                      alt_address: element.customerDetials.customerAddress
                          .alt_address != null &&
                          element.customerDetials.customerAddress.alt_address !=
                              ""
                          ? element.customerDetials.customerAddress.alt_address
                          : "",
                      address2: element.customerDetials.customerAddress
                          .address2 != null &&
                          element.customerDetials.customerAddress.address2 != ""
                          ? element.customerDetials.customerAddress.address2
                          : "",
                      postCode: "${element.customerDetials.customerAddress
                          .postCode != null && element.customerDetials
                          .customerAddress.postCode != "" ? element
                          .customerDetials.customerAddress.postCode : ""}" +
                          "${element.customerDetials.mobile != null && element
                              .customerDetials.mobile != "" ? "#" +
                              element.customerDetials.mobile : ""}",
                      latitude:
                      element.customerDetials.customerAddress.latitude !=
                          null &&
                          element.customerDetials.customerAddress.latitude != ""
                          ? element.customerDetials.customerAddress.latitude
                          : 0.0,
                      longitude: element.customerDetials.customerAddress
                          .longitude != null &&
                          element.customerDetials.customerAddress.longitude !=
                              ""
                          ? element.customerDetials.customerAddress.longitude
                          : 0.0,
                      duration: element.customerDetials.customerAddress
                          .matchAddress != null &&
                          element.customerDetials.customerAddress
                              .matchAddress != ""
                          ? element.customerDetials.customerAddress.matchAddress
                          : "",
                      order_id: element.orderId != null ? element.orderId : 0);
                  logger.i("customerAddressObj: $customerAddressObj");
                  var intType = await MyDatabase().insertCustomerAddress(
                      customerAddressObj);
                  logger.i(intType);
                }
              });
            }
            logger.i("testttt2");
            getDeliveryListFromDB();
          }
          //_dashBoardModal.orderCounts.outForDeliveryOrders = outdeliveryList.length;
          isRouteStart = _dashBoardModal.isStart;
          //  list.addAll(_dashBoardModal.deliveryList);

          if (routeOptimizeDialogShowing) {
            Navigator.pop(dialogContext);
            routeOptimizeDialogShowing = false;
          }
        } else {
          // Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
          if (routeOptimizeDialogShowing) {
            Navigator.pop(dialogContext);
            routeOptimizeDialogShowing = false;
          }
          if (response.body.startsWith("{\"error\":true")) {
            Map<dynamic, dynamic> map = jsonDecode(response.body);
            if (map != null && map["message"] != null) {
              showAlertDialog(map["message"]);
            }
          }
        }
        setState(() {});
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        if (mounted) {
          isNetworkError = true;
          logger.i(isNetworkError);
          setState(() {});
          if (routeOptimizeDialogShowing) {
            Navigator.pop(dialogContext);
            routeOptimizeDialogShowing = false;
          }
        }
      }

//      if(mounted)
      setState(() {
        isProgressAvailable = false;
      });
    });
  }

  Future<void> scanBarcodeNormal(bool isOutForDelivery, int customerId,
      int orderId) async {
    checkLastTime(context);
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#7EC3E6", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes != "-1") {
        FlutterBeep.beep();
        // List<String> barcodeArray = barcodeScanRes.split(",");
        // for(String str in barcodeArray){
        // if(str.contains("OrderId")){
        if (isOutForDelivery /*&& orderId.toString() == barcodeScanRes*/) {
          // checkCustomerWithOrder(
          //     barcodeScanRes, customerId, orderId.toString());

          getOrderDetails(barcodeScanRes, true, true, orderId);
        } else if (!isOutForDelivery) {
          // logger.i("scan QR");
          orderListType = 1;
          getOrderDetails(barcodeScanRes, true, false, 0);
        } else {
          Fluttertoast.showToast(msg: "Format not correct!");
        }
      } else {
        Fluttertoast.showToast(msg: "Format not correct!");
      }
      // logger.i("barcode : $barcodeScanRes");
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    try {
      final parser = Xml2Json();

      parser.parse(barcodeScanRes);
      var json = parser.toGData();

      // print(json);
    } catch (_, stackTrace) {

      SentryExemption.sentryExemption(_, stackTrace);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Text("You Have Scanned Wrong Barcode"),
          actions: [MaterialButton(onPressed: (){
            Navigator.pop(context);
          },child: Text("Okay"),)],
        );
      },);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: driverType == Constants.dadicatedDriver
                ? true
                : driverType == Constants.sharedDriver && isRouteStart
                ? false
                : true,
            child: Padding(
              padding: EdgeInsets.only(
                  left: isRouteStart && deliveryTime != null &&
                      stopWatchTimer != null
                      ? MediaQuery
                      .of(context)
                      .size
                      .width * 24 / 100
                      : 0.0),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.orange,
                label: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    Text(
                      "Scan Rx",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                onPressed: () async {
                  var isInternetAval = await ConnectionValidator().check();
                  if (!isInternetAval) {
                    noInternetPopUp(Constants.internet_notavailable);
                    return;
                  }

                  if (driverType == Constants.sharedDriver) {
                    if (selectedPharmacy == null) {
                      showAlertDialog("Please Select Pharmacy!!");
                      return;
                    }
                  }
                  if (driverType == Constants.sharedDriver) {
                    await SharedPreferences.getInstance().then((value) {
                      value.setInt(
                          WebConstant.PHARMACY_ID, selectedPharmacy.pharmacyId);
                      logger.i(value.getInt(WebConstant.PHARMACY_ID));
                    });
                  }
                  if (selectedRoute != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Scan_Prescription(
                                  isAssignSelf: true,
                                  pmrList: [],
                                  prescriptionList: [],
                                  isBulkScan: isSwitched,
                                  driverId: driverId,
                                  routeId: routeId,
                                  parcelBoxId: _selectedTotePosition != null &&
                                      _selectedTotePosition != -1
                                      ? parcelBoxList[_selectedTotePosition]
                                      .id ?? 0
                                      : 0,
                                  type: "4",
                                  callPickedApi: this,
                                  bulkScanDate: bulkScanDate,
                                  pharmacyId: selectedPharmacy != null
                                      ? selectedPharmacy.pharmacyId
                                      : 0,
                                ))).then((value) {
                      // logger.i("asdfasdfasfasfasf");
                      fetchDeliveryList(0);
                    });
                  } else {
                    showAlertDialog("Please select Route first!!");
                  }
                },
              ),
            ),
          ),
          if (isRouteStart && deliveryTime != null && stopWatchTimer != null &&
              stopWatchTimer.rawTime != null)
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 7.0, bottom: 7.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: showIncreaseTime ? Colors.red : CustomColors
                      .timeLeftColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 3.0,
                        blurRadius: 5.0,
                        offset: Offset(0, 2))
                  ]),
              child: CountDownWidget(
                // duration: Duration(seconds: getQuizDetailsProvider?.getQuizDetailData?.quizTime != null ? getQuizDetailsProvider!.getQuizDetailData!.quizTime!:0),
                duration: Duration(seconds: deliveryTime),
                builder: (context, duration) {
                  deliveryTime = duration.inSeconds;
                  // logger.i("duration $deliveryTime");
                  SharedPreferences.getInstance().then((value) async {
                    await value.setInt(
                        WebConstant.DELIVERY_TIME, duration.inSeconds);
                  });
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Time Left",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      // Text("${duration.inHours.remainder(60).toString().padLeft(2,'0')}:${duration.inMinutes.remainder(60).toString().padLeft(2,'0')}:${duration.inSeconds.remainder(60).toString().padLeft(2,'0')}",style: TextStyle(color: Colors.white),),
                      StreamBuilder<int>(
                        stream: stopWatchTimer.rawTime,
                        initialData: 0,
                        builder: (context, snap) {
                          final value = snap.data;
                          final displayTime = StopWatchTimer.getDisplayTime(
                              value, milliSecond: false);

                          return Text(
                            showIncreaseTime ? "+ $displayTime" : displayTime,
                            style: TextStyle(fontFamily: 'Helvetica',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  );
                },
                onFinish: () {},
                onExpired: () {
                  // showBottomSheetTimesUp(context);
                },
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Profile(versionCode: versionCode),
      appBar: AppBar(
        backgroundColor: Colors.orange.withOpacity(0.8),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          Row(
            children: [
              Text("Bulk Scan"),
              Switch(
                onChanged: (bool value) {
                  isSwitched = value;
                  setState(() {});
                },
                value: isSwitched,
                activeColor: Colors.blue,
                activeTrackColor: Colors.blue,
                inactiveThumbColor: Colors.black,
                inactiveTrackColor: Colors.grey[400],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              getRoutes();
            },
            child: Container(
              padding: EdgeInsets.only(top: 5, left: 0, bottom: 5),
              margin: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.refresh,
                color: appBarTextColor,
              ),
            ),
          ),
          selectedType == WebConstant.Status_out_for_delivery && isRouteStart
              ? InkWell(
            onTap: () async {
              checkLastTime(context);
              bool checkInternet = await ConnectionValidator().check();
              if (!checkInternet) {
                noInternetPopUp(Constants.internet_notavailable);
              } else {
                if (_locationData != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RouteMaker(
                                deliveryList: outdeliveryList,
                                routeId: routeId,
                                driverId: driverId,
                              )));

                  // final DateTime now = DateTime.now();
                  // bool isToday = true;
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DisplayRoute(
                  //             int.parse(routeId),
                  //             int.parse(driverId),
                  //             now.toString(),
                  //             isToday)));
                } else {
                  getLocationData();
                }
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: 5, left: 0, bottom: 5),
              margin: EdgeInsets.only(right: 5),
              child: Image.asset(
                "assets/location_top.png",
                color: CustomColors.failedColor,
                height: 24,
                width: 24,
              ),
            ),
          )
              : Container(
            height: 0,
            width: 0,
          ),
          isRouteStart || receivedCount == 0
              ? Container(
            height: 0,
            width: 0,
          )
              : InkWell(
            onTap: () async {
              // logger.i("hiiiiiiii2");
              scanBarcodeNormal(false, 0, 0);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 0, right: 10),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 5, bottom: 5),
                    child: Image.asset(
                      "assets/qr_code.png",
                      color: appBarTextColor,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 5, right: 5, top: 1, bottom: 1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.deepOrangeAccent),
                    child: Text(
                      "$receivedCount",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          //profile icon removed and replace with hamburger menu
          // InkWell(
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder:
          //             (context) => Profile
          //               (versionCode: versionCode)));
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(left: 0, right: 5),
          //     child: Icon(
          //       Icons.account_circle,
          //       color: appBarTextColor,
          //       size: 30,
          //     ),
          //   ),
          // ),
          //notificaation icon
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReciveNotification()))
                  .then((value) {
                logger.i("log1");
                updateApi();
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 0, right: 10),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications,
                      size: 30,
                      color: appBarTextColor,
                    ),
                  ),
                  if (notification_count != null && notification_count > 0)
                    Positioned(
                      right: 1,
                      top: 12,
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Text(
                            notification_count != null
                                ? notification_count > 99
                                ? "+99"
                                : notification_count.toString()
                                : "",
                            style: TextStyle(fontSize: 9, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  //height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Image.asset(
                    "assets/bottom_bg.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              if (selectedType == WebConstant.Status_failed &&
                  deliveryList.length > 0 &&
                  driverType == Constants.dadicatedDriver)
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.18),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            selectAllDelivery = !selectAllDelivery;
                            deliveryList.forEach((element) {
                              element.isSelected = selectAllDelivery;
                            });

                            getCheckSelected();
                          },
                          child: Text(
                            selectAllDelivery ? "Unselect All" : "Select All",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        isShowRechedule
                            ? ElevatedButton(
                          onPressed: () async {
                            bool checkInternet = await ConnectionValidator()
                                .check();
                            if (!checkInternet) {
                              Fluttertoast.showToast(
                                  msg: WebConstant.INTERNET_NOT_AVAILABE);
                              return;
                            }
                            if (selectedRoute != null && selectedRoute
                                .routeId != null) {
                              // selectedRouteRescheduleDropDown = selectedRoute;
                              reschedulePopup();
                            } else {
                              Fluttertoast.showToast(msg: "Select Route First");
                              return;
                            }
                          },
                          child: Text(
                            "Reschedule Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : SizedBox(),
                      ],
                    )),

              isProgressAvailable
                  ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(),
                  ],
                ),
              )
                  : isLoadPagination &&
                  !isNetworkError &&
                  selectedType != WebConstant
                      .Status_out_for_delivery /*&& deliveryList.length>0*/
                  ? Padding(
                padding: EdgeInsets.only(
                    top: selectedType == WebConstant.Status_failed &&
                        driverType == Constants.dadicatedDriver
                        ? 30.0
                        : 0.0),
                child: Container(
                  margin: EdgeInsets.only(
                      top: selectedType !=
                          WebConstant.Status_out_for_delivery &&
                          deliveryList.length > 0
                          ? MediaQuery
                          .of(context)
                          .size
                          .height * 0.20
                          : MediaQuery
                          .of(context)
                          .size
                          .height * 0.18),
                  child: PaginationView<DeliveryPojoModal>(
                    key: key,
                    paginationViewType: paginationViewType,
                    itemBuilder: (BuildContext context,
                        DeliveryPojoModal delivery, int index) =>
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                    color: Colors.grey[300])
                              ]),
                          margin: EdgeInsets.only(
                            top: 5,
                            bottom: deliveryList.length - 1 == index &&
                                deliveryList.length > 3 ? 80.0 : 5.0,
                            left: 2.5,
                            right: 2.5,
                          ),
                          child: Stack(
                            children: [
                              Card(
                                color: delivery.isSelected
                                    ? Colors.blue[100]
                                    : Colors.white,
                                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    if ((delivery.status == "Failed")) {
                                      if (driverType ==
                                          Constants.dadicatedDriver) {
                                        delivery.isSelected =
                                        !delivery.isSelected;
                                        getCheckSelected();
                                      }
                                    } else
                                    if (delivery.status == "OutForDelivery") {
                                      orderListType = 4;
                                       selectedType != WebConstant.Status_total
                                          ? scanBarcodeNormal(
                                          true,
                                          delivery.customerDetials.customerId,
                                          delivery.nursing_home_id == null ||
                                              delivery.nursing_home_id == "" ||
                                              delivery.nursing_home_id == 0
                                              ? delivery.orderId
                                              : 0)
                                          : null;
                                      // : print(delivery.status);
                                      // : scanBarcodeForOrderCheck();
                                      // : getOrderDetails("${delivery.orderId}",false);
                                    } else if ((delivery.status == "Ready") ||
                                        (delivery.status ==
                                            "ReadyForDelivery") ||
                                        delivery.status == "PickedUp" ||
                                        (delivery.status == "Received") ||
                                        (delivery.status == "Requested")) {
                                      if (!isRouteStart)
                                        getOrderDetails(
                                            "${delivery.orderId}", false, false,
                                            0);
                                      else if (isRouteStart) {
                                        showAleartRouteStarted();
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    padding: EdgeInsets.only(left: 10.0,
                                        right: 10.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            /*Text("Name", style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14
                                        ),),
                                        SizedBox(width: 5, height: 0,),*/
                                            Row(
                                              children: [
                                                Text(
                                                  "${delivery.customerDetials
                                                      .title ?? ""} ${delivery
                                                      .customerDetials
                                                      .firstName ?? ""} "
                                                      "${delivery
                                                      .customerDetials
                                                      .middleName ?? ""} "
                                                      "${delivery
                                                      .customerDetials
                                                      .lastName ?? ""}",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w700),
                                                ),
                                                if (delivery.nursing_home_id ==
                                                    null ||
                                                    delivery.nursing_home_id ==
                                                        0)
                                                  if (delivery.pmr_type !=
                                                      null &&
                                                      (delivery.pmr_type ==
                                                          "titan" ||
                                                          delivery.pmr_type ==
                                                              "nursing_box") &&
                                                      delivery.pr_id != null &&
                                                      delivery.pr_id.isNotEmpty)
                                                    Text(
                                                      '(P/N : ${delivery
                                                          .pr_id ?? ""}) ',
                                                      style: TextStyle(
                                                          color: CustomColors
                                                              .pnColor),
                                                    ),
                                                if (delivery.isCronCreated ==
                                                    "t")
                                                  Image.asset(
                                                      "assets/automatic_icon.png",
                                                      height: 14, width: 14),
                                              ],
                                            ),
                                            if (delivery.status ==
                                                "OutForDelivery" ||
                                                delivery.status == "PickedUp" ||
                                                delivery.status == "Received")
                                              Row(
                                                children: [
                                                  if (delivery
                                                      .isStorageFridge !=
                                                      null &&
                                                      delivery
                                                          .isStorageFridge ==
                                                          "t")
                                                    Container(
                                                        height: 20,
                                                        padding: EdgeInsets
                                                            .only(
                                                            right: 5.0,
                                                            left: 5.0,
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(5.0),
                                                          color: Colors.blue,
                                                        ),
                                                        child: Center(
                                                            child: Image.asset(
                                                              "assets/fridge.png",
                                                              height: 20,
                                                              color: Colors
                                                                  .white,
                                                            ))),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  if (delivery
                                                      .isControlledDrugs !=
                                                      null &&
                                                      delivery
                                                          .isControlledDrugs ==
                                                          "t")
                                                    Container(
                                                      height: 20,
                                                      padding: EdgeInsets.only(
                                                          right: 3.0,
                                                          left: 3.0,
                                                          top: 2.0,
                                                          bottom: 2.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(5.0),
                                                        color: Colors.red,
                                                      ),
                                                      child: Center(
                                                        child: new Text(
                                                          'C.D.',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12.0),
                                                        ),
                                                      ),
                                                    ),
                                                  if (delivery
                                                      .nursing_home_id ==
                                                      null ||
                                                      delivery
                                                          .nursing_home_id == 0)
                                                    if (isSwitched)
                                                      PopupMenuButton(
                                                          padding: EdgeInsets
                                                              .zero,
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: Colors
                                                                .grey[400],
                                                          ),
                                                          itemBuilder: (_) =>
                                                          [
                                                            new PopupMenuItem(
                                                                enabled: true,
                                                                height: 30.0,
                                                                onTap: () {},
                                                                child: StatefulBuilder(
                                                                  builder: ((
                                                                      context,
                                                                      setStat) {
                                                                    return Row(
                                                                      mainAxisSize: MainAxisSize
                                                                          .min,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            delivery
                                                                                .isCD =
                                                                            !delivery
                                                                                .isCD;
                                                                            updateOrders(
                                                                                delivery
                                                                                    .orderId,
                                                                                delivery
                                                                                    .isCD,
                                                                                delivery
                                                                                    .isFridge);
                                                                            setStat(() {});
                                                                            setState(() {});
                                                                            Navigator
                                                                                .pop(
                                                                                context);
                                                                          },
                                                                          child: Container(
                                                                            color: Colors
                                                                                .red,
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize
                                                                                  .min,
                                                                              children: [
                                                                                Checkbox(
                                                                                  visualDensity:
                                                                                  VisualDensity(
                                                                                      horizontal: -4,
                                                                                      vertical: -4),
                                                                                  value: delivery
                                                                                      .isCD,
                                                                                  onChanged: (
                                                                                      newValue) {
                                                                                    setState(() {
                                                                                      delivery
                                                                                          .isCD =
                                                                                          newValue;
                                                                                    });
                                                                                    setStat(() {});
                                                                                    updateOrders(
                                                                                        delivery
                                                                                            .orderId,
                                                                                        delivery
                                                                                            .isCD,
                                                                                        delivery
                                                                                            .isFridge);
                                                                                    Navigator
                                                                                        .pop(
                                                                                        context);
                                                                                  },
                                                                                ),
                                                                                new Text(
                                                                                  'C. D.',
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .white),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 1,
                                                                          margin: EdgeInsets
                                                                              .only(
                                                                              left: 4.0,
                                                                              right: 4.0),
                                                                          height: 25,
                                                                          decoration: BoxDecoration(
                                                                              border: Border
                                                                                  .all(
                                                                                  color: Colors
                                                                                      .black)),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            delivery
                                                                                .isFridge =
                                                                            !delivery
                                                                                .isFridge;
                                                                            updateOrders(
                                                                                delivery
                                                                                    .orderId,
                                                                                delivery
                                                                                    .isCD,
                                                                                delivery
                                                                                    .isFridge);
                                                                            setStat(() {});
                                                                            setState(() {});
                                                                            Navigator
                                                                                .pop(
                                                                                context);
                                                                          },
                                                                          child: Container(
                                                                            color: Colors
                                                                                .blue,
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize
                                                                                  .min,
                                                                              children: [
                                                                                Checkbox(
                                                                                  visualDensity:
                                                                                  VisualDensity(
                                                                                      horizontal: -4,
                                                                                      vertical: -4),
                                                                                  value: delivery
                                                                                      .isFridge,
                                                                                  onChanged: (
                                                                                      newValue) {
                                                                                    setState(() {
                                                                                      delivery
                                                                                          .isFridge =
                                                                                          newValue;
                                                                                    });
                                                                                    setStat(() {});
                                                                                    updateOrders(
                                                                                        delivery
                                                                                            .orderId,
                                                                                        delivery
                                                                                            .isCD,
                                                                                        delivery
                                                                                            .isFridge);
                                                                                    Navigator
                                                                                        .pop(
                                                                                        context);
                                                                                  },
                                                                                ),
                                                                                Padding(
                                                                                  padding:
                                                                                  const EdgeInsets
                                                                                      .only(
                                                                                      right: 12.0),
                                                                                  child: Image
                                                                                      .asset(
                                                                                    "assets/fridge.png",
                                                                                    height: 21,
                                                                                    color: Colors
                                                                                        .white,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: 1,
                                                                          margin: EdgeInsets
                                                                              .only(
                                                                              left: 4.0,
                                                                              right: 4.0),
                                                                          height: 25,
                                                                          decoration: BoxDecoration(
                                                                              border: Border
                                                                                  .all(
                                                                                  color: Colors
                                                                                      .black)),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            cancelOrder(
                                                                                delivery
                                                                                    .orderId);
                                                                            Navigator
                                                                                .pop(
                                                                                context);
                                                                          },
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize
                                                                                .min,
                                                                            children: [
                                                                              Icon(
                                                                                Icons
                                                                                    .cancel_outlined,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5.0,
                                                                              ),
                                                                              Text(
                                                                                  "Cancel")
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  }),
                                                                )),
                                                            // new PopupMenuItem(
                                                            //     enabled: true,
                                                            //     height: 30.0,
                                                            //     onTap: (){},
                                                            //     child: StatefulBuilder(
                                                            //       builder: ((context, setStat) {
                                                            //         return InkWell(
                                                            //           onTap: (){
                                                            //             pmrList[index].isFridge = !pmrList[index].isFridge;
                                                            //             updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                            //             setStat((){});
                                                            //             setState(() {});
                                                            //             Navigator.pop(context);
                                                            //           },
                                                            //           child: Container(
                                                            //             color: Colors.blue,
                                                            //             child: Row(
                                                            //               mainAxisSize: MainAxisSize.min,
                                                            //               children: [
                                                            //                 Checkbox(
                                                            //                   visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                                            //                   value: pmrList[index].isFridge,
                                                            //                   onChanged: (newValue) {
                                                            //                     setState(() {
                                                            //                       pmrList[index].isFridge = newValue;
                                                            //                     });
                                                            //                     setStat((){});
                                                            //                     updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                            //                     Navigator.pop(context);
                                                            //                   },
                                                            //                 ),
                                                            //                 Padding(
                                                            //                   padding: const EdgeInsets.only(right: 12.0),
                                                            //                   child: Image.asset("assets/fridge.png", height: 21,color: Colors.white,),
                                                            //                 )
                                                            //               ],
                                                            //             ),
                                                            //           ),
                                                            //         );
                                                            //       }),
                                                            //     )
                                                            // ),
                                                            // new PopupMenuItem(
                                                            //     enabled: true,
                                                            //     height: 40.0,
                                                            //     onTap: (){},
                                                            //     child: StatefulBuilder(
                                                            //       builder: ((context, setStat) {
                                                            //         return InkWell(
                                                            //           onTap: (){
                                                            //             cancelOrder(pmrList[index].orderId);
                                                            //             Navigator.pop(context);
                                                            //           },
                                                            //           child: Row(
                                                            //             mainAxisSize: MainAxisSize.min,
                                                            //             children: [
                                                            //               Icon(
                                                            //                 Icons.cancel_outlined,
                                                            //               ),
                                                            //               SizedBox(
                                                            //                 width: 5.0,
                                                            //               ),
                                                            //               Text("Cancel")
                                                            //             ],
                                                            //           ),
                                                            //         );
                                                            //       }),
                                                            //     )
                                                            // ),
                                                          ]),
                                                ],
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                          height: 3,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            // Image.asset(
                                            //   "assets/home_icon.png",
                                            //   height: 18,
                                            //   width: 18,
                                            //   color: selectedType ==
                                            //       WebConstant
                                            //           .Status_out_for_delivery
                                            //       ? CustomColors
                                            //       .yetToStartColor
                                            //       : selectedType ==
                                            //       WebConstant
                                            //           .Status_delivered
                                            //       ? CustomColors
                                            //       .deliveredColor
                                            //       : (selectedType ==
                                            //       WebConstant
                                            //           .Status_failed
                                            //       ? CustomColors
                                            //       .failedColor
                                            //       : (selectedType ==
                                            //       WebConstant
                                            //           .Status_picked_up
                                            //       ? CustomColors
                                            //       .pickedUp
                                            //       : Colors
                                            //       .blueAccent)),
                                            // ),
                                            // SizedBox(
                                            //   width: 5,
                                            //   height: 0,
                                            // ),
                                            Expanded(
                                              child: Text(
                                                "${delivery.customerDetials
                                                    .customerAddress.address1 ??
                                                    delivery.customerDetials
                                                        .customerAddress
                                                        .address2 ??
                                                    ""} ${delivery
                                                    .customerDetials
                                                    .customerAddress.postCode ??
                                                    ""}",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .w300),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                              height: 0,
                                            ),
                                            if (delivery.customerDetials
                                                .customerAddress.alt_address ==
                                                "t")
                                              Image.asset(
                                                "assets/alt-add.png",
                                                height: 18,
                                                width: 18,
                                              ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //
                                            //   },
                                            //   child: new Text(
                                            //     "Deliver now",
                                            //     style: TextStyle(fontSize: 12, color: Colors.white),
                                            //   ),
                                            //   style: ElevatedButton.styleFrom(
                                            //     backgroundColor: CustomColors.yetToStartColor,
                                            //     foregroundColor: Colors.white.withOpacity(0.4),
                                            //     padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                            //     visualDensity: VisualDensity(vertical: -4),
                                            //     shape: new RoundedRectangleBorder(
                                            //       borderRadius: new BorderRadius.circular(5.0),
                                            //     ),
                                            //   ),
                                            // ),
                                            // if(delivery.status == "Failed")
                                            // SizedBox(
                                            //   width: 5,
                                            // ),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(
                                                  top: delivery.status ==
                                                      "Failed" ? 5.0 : 0.0),
                                              child: Text(
                                                "${delivery.status ?? ""}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: delivery.status ==
                                                      WebConstant
                                                          .Status_out_for_delivery
                                                      ? CustomColors
                                                      .yetToStartColor
                                                      : delivery.status ==
                                                      WebConstant
                                                          .Status_delivered
                                                      ? CustomColors
                                                      .deliveredColor
                                                      : (delivery.status ==
                                                      WebConstant.Status_failed
                                                      ? CustomColors.failedColor
                                                      : (delivery.status ==
                                                      WebConstant
                                                          .Status_picked_up
                                                      ? CustomColors.pickedUp
                                                      : Colors.blueAccent)),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                          height: 0,
                                        ),
                                        selectedType ==
                                            WebConstant.Status_out_for_delivery
                                            ? Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    if (Platform.isAndroid) {
                                                      if (_locationData ==
                                                          null) {
                                                        if (_permissionGranted ==
                                                            PermissionStatus
                                                                .granted) {
                                                          _locationData =
                                                          await location
                                                              .getLocation();
                                                        }
                                                      }
                                                      final AndroidIntent intent = new AndroidIntent(
                                                          action: 'action_view',
                                                          data: Uri.encodeFull(
                                                              "https://www.google.com/maps/dir/?api=1&origin=${_locationData
                                                                  .latitude},${_locationData
                                                                  .longitude}"
                                                                  "&destination=${delivery
                                                                  .customerDetials
                                                                  .address}"),
                                                          package: 'com.google.android.apps.maps');
                                                      intent.launch();
                                                    } else {
                                                      MapsLauncher.launchQuery(
                                                          "${delivery
                                                              .customerDetials
                                                              .customerAddress
                                                              .address1 ??
                                                              delivery
                                                                  .customerDetials
                                                                  .customerAddress
                                                                  .address2 ??
                                                              ""}");

                                                      MapsLauncher
                                                          .launchCoordinates(
                                                          double.parse(delivery
                                                              .customerDetials
                                                              .customerAddress
                                                              .latitude ??
                                                              "0.0"),
                                                          double.parse(delivery
                                                              .customerDetials
                                                              .customerAddress
                                                              .longitude ??
                                                              "0.0"));
                                                      // String url = "https://www.google.com/maps/dir/?api=1&origin=${_latLng[0]}&destination=${_latLng[0]}&travelmode=driving&dir_action=navigate";
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    margin: EdgeInsets.only(
                                                        left: 1,
                                                        right: 1,
                                                        top: 2,
                                                        bottom: 2),
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(5)),
                                                        color: Colors
                                                            .blueAccent,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              spreadRadius: 1,
                                                              blurRadius: 10,
                                                              offset: Offset(
                                                                  0, 4),
                                                              color: Colors
                                                                  .grey[300])
                                                        ]),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .center,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          "assets/send.png",
                                                          height: 14,
                                                          width: 14,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                          height: 0,
                                                        ),
                                                        Text(
                                                          "Route",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight
                                                                  .w500,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                          height: 0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 1),
                                                if (delivery.orderId > 0)
                                                  InkWell(
                                                    onTap: () async {
                                                      getOrderDetails(
                                                          delivery.orderId
                                                              .toString(),
                                                          false, true, 0);
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      margin: EdgeInsets.only(
                                                          left: 1,
                                                          right: 1,
                                                          top: 2,
                                                          bottom: 2),
                                                      padding: EdgeInsets.all(
                                                          10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius: 1,
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    0, 4),
                                                                color: Colors
                                                                    .grey[300])
                                                          ]),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            "Manual",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Image.asset(
                                            //       "assets/timer_icon.png",
                                            //       height: 18,
                                            //       width: 18,
                                            //     ),
                                            //     SizedBox(
                                            //       width: 5,
                                            //       height: 0,
                                            //     ),
                                            //     Text(
                                            //       "ETA",
                                            //       style: TextStyle(
                                            //           fontSize: 12,
                                            //           fontWeight:
                                            //               FontWeight
                                            //                   .w600,
                                            //           color: Colors
                                            //               .blueAccent),
                                            //     ),
                                            //     SizedBox(
                                            //       width: 5,
                                            //       height: 0,
                                            //     ),
                                            //     Text(
                                            //       "${delivery.customerDetials.customerAddress.duration ?? ""}",
                                            //       style: TextStyle(
                                            //         fontSize: 13,
                                            //         fontWeight:
                                            //             FontWeight
                                            //                 .w500,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // )
                                          ],
                                        )
                                            : Container(
                                          height: 0,
                                          width: 0,
                                        ),
                                        Row(
                                          children: [
                                            // if (delivery.customerDetials
                                            //     .surgeryName !=
                                            //     null &&
                                            //     delivery.customerDetials
                                            //         .surgeryName !=
                                            //         "")
                                            //   Container(
                                            //       decoration: BoxDecoration(
                                            //           borderRadius:
                                            //           BorderRadius.all(
                                            //               Radius.circular(
                                            //                   5)),
                                            //           color: Colors
                                            //               .blueAccent,
                                            //           boxShadow: [
                                            //             BoxShadow(
                                            //                 spreadRadius:
                                            //                 1,
                                            //                 blurRadius:
                                            //                 10,
                                            //                 offset:
                                            //                 Offset(
                                            //                     0,
                                            //                     4),
                                            //                 color: Colors
                                            //                     .grey[
                                            //                 300])
                                            //           ]),
                                            //       padding:
                                            //       EdgeInsets.only(
                                            //           left: 10,
                                            //           right: 10,
                                            //           bottom: 2),
                                            //       child: Text(
                                            //           delivery.customerDetials
                                            //               .surgeryName != null ?
                                            //           delivery.customerDetials.surgeryName.toString().length > 12  ?delivery.customerDetials.surgeryName.toString().substring(0,12) :delivery.customerDetials.surgeryName.toString()
                                            //              : "",
                                            //           maxLines: 2,
                                            //           style: TextStyle(
                                            //               color: Colors
                                            //                   .white))),
                                            // if (delivery.customerDetials
                                            //     .surgeryName !=
                                            //     null &&
                                            //     delivery.customerDetials
                                            //         .surgeryName !=
                                            //         "")
                                            //   SizedBox(
                                            //     width: 10,
                                            //   ),
                                            if (delivery.nursing_home_id ==
                                                null ||
                                                delivery.nursing_home_id == 0)
                                              if (delivery.customerDetials
                                                  .service_name != null &&
                                                  delivery.customerDetials
                                                      .service_name != "")
                                                Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(5)),
                                                        color: Colors.redAccent,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              spreadRadius: 1,
                                                              blurRadius: 10,
                                                              offset: Offset(
                                                                  0, 4),
                                                              color: Colors
                                                                  .grey[300])
                                                        ]),
                                                    padding:
                                                    EdgeInsets.only(left: 10,
                                                        right: 10,
                                                        bottom: 2,
                                                        top: 2),
                                                    child: Text(
                                                      delivery.customerDetials
                                                          .service_name != null
                                                          ? delivery
                                                          .customerDetials
                                                          .service_name
                                                          .toString()
                                                          .length >
                                                          12
                                                          ? delivery
                                                          .customerDetials
                                                          .service_name
                                                          .toString()
                                                          .substring(0, 12)
                                                          : delivery
                                                          .customerDetials
                                                          .service_name
                                                          .toString()
                                                          : "",
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    )),

                                            if (delivery.customerDetials
                                                .service_name != null &&
                                                delivery.customerDetials
                                                    .service_name != "")
                                              SizedBox(
                                                width: 10,
                                              ),
                                            if (delivery.pharmacyName != null &&
                                                delivery.pharmacyName != "" &&
                                                driverType ==
                                                    Constants.sharedDriver)
                                              Flexible(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(5)),
                                                        color: Colors.orange,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              spreadRadius: 1,
                                                              blurRadius: 10,
                                                              offset: Offset(
                                                                  0, 4),
                                                              color: Colors
                                                                  .grey[300])
                                                        ]),
                                                    padding:
                                                    EdgeInsets.only(left: 10,
                                                        right: 10,
                                                        bottom: 2,
                                                        top: 2),
                                                    child: Text(
                                                      delivery.pharmacyName !=
                                                          null
                                                          ? delivery
                                                          .pharmacyName
                                                          .toString()
                                                          .length > 16
                                                          ? delivery
                                                          .pharmacyName
                                                          .toString().substring(
                                                          0, 16)
                                                          : delivery
                                                          .pharmacyName
                                                          .toString()
                                                          : "",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    )),
                                              ),
                                            if (delivery.pharmacyName != null &&
                                                delivery.pharmacyName != "" &&
                                                driverType ==
                                                    Constants.sharedDriver)
                                              SizedBox(
                                                width: 10,
                                              ),
                                            if (selectedType ==
                                                WebConstant.Status_picked_up &&
                                                delivery.parcelBoxName !=
                                                    null &&
                                                delivery.parcelBoxName
                                                    .toString()
                                                    .isNotEmpty)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.red),
                                                        borderRadius: BorderRadius
                                                            .circular(5.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left: 3.0,
                                                          right: 3.0,
                                                          top: 2.0,
                                                          bottom: 2.0),
                                                      child: Text(
                                                        "${delivery
                                                            .parcelBoxName
                                                            .length > 8
                                                            ? delivery
                                                            .parcelBoxName
                                                            .substring(0, 8)
                                                            : delivery
                                                            .parcelBoxName ??
                                                            ""}",
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .pickedUp,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     if(selectedType == WebConstant.Status_delivered && delivery.isControlledDrugs != null && delivery.isControlledDrugs == "t")
                                        //       Container(
                                        //         decoration: BoxDecoration(
                                        //           borderRadius: BorderRadius
                                        //               .circular(
                                        //               5.0),
                                        //           color: CustomColors
                                        //               .drugColor,
                                        //           // border: Border.all(color: Colors.blue)
                                        //         ),
                                        //         child: Padding(
                                        //           padding: const EdgeInsets
                                        //               .only(
                                        //               left: 5.0,
                                        //               right: 5.0,
                                        //               top: 2.0,
                                        //               bottom: 2.0),
                                        //           child: Text(
                                        //             "${delivery.totalControlledDrugs != null && delivery.totalControlledDrugs != 0 ? delivery.totalControlledDrugs : ""} C.D.",
                                        //             style: TextStyle(
                                        //                 fontSize: 10,
                                        //                 color: Colors
                                        //                     .white),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     if(selectedType == WebConstant.Status_delivered && delivery.isControlledDrugs != null && delivery.isControlledDrugs == "t")
                                        //     SizedBox(
                                        //       width: 10.0,
                                        //     ),
                                        //     if(selectedType == WebConstant.Status_delivered && delivery.isStorageFridge != null && delivery.isStorageFridge == "t")
                                        //     Container(
                                        //       decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius
                                        //             .circular(
                                        //             5.0),
                                        //         color: CustomColors
                                        //             .fridgeColor,
                                        //         // border: Border.all(color: Colors.blue)
                                        //       ),
                                        //       child: Padding(
                                        //         padding: const EdgeInsets
                                        //             .only(
                                        //             left: 5.0,
                                        //             right: 5.0,
                                        //             top: 2.0,
                                        //             bottom: 2.0),
                                        //         child: Text(
                                        //           "${delivery.totalStorageFridge != null && delivery.totalStorageFridge != 0 ? delivery.totalStorageFridge : ""} Fridge",
                                        //           style: TextStyle(
                                        //               fontSize: 10,
                                        //               color: Colors
                                        //                   .white),
                                        //         ),
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        if (selectedType ==
                                            WebConstant.Status_failed &&
                                            delivery.rescheduleDate != null &&
                                            delivery.rescheduleDate != "")
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                Text(
                                                  "Booked : ",
                                                  style: TextStyle(
                                                    color: CustomColors
                                                        .failedColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  delivery.rescheduleDate,
                                                  style: TextStyle(
                                                    color: CustomColors
                                                        .failedColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (delivery.status == "Failed")
                                Positioned(
                                  right: 14.0,
                                  top: 5.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      getFailedOrderDetails(delivery);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 5.0,
                                          right: 5.0,
                                          top: 2.0,
                                          bottom: 2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.3),
                                              spreadRadius: 0.0,
                                              blurRadius: 3.0,
                                              offset: Offset(0, 3))
                                        ],
                                        borderRadius: BorderRadius.circular(
                                            5.0),
                                      ),
                                      child: new Text(
                                        "Deliver now",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    pageFetch: /*selectedType == WebConstant.Status_out_for_delivery ? getParcelList :*/ fetchDeliveryList,
                    pullToRefresh: true,
                    onError: (dynamic error) =>
                        Center(
                          child: Text(WebConstant.ERRORMESSAGE),
                        ),
                    onEmpty: Center(
                      child: selectedRoute != null ? Text('') : Text(
                          'Select Route First!!'),
                    ),
                    bottomLoader: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    initialLoader: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
                  : Container(
                height: 0,
                width: 0,
              ),

              isProgressAvailable
                  ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(),
                  ],
                ),
              )
                  : selectedType == WebConstant.Status_out_for_delivery &&
                  !isNetworkError
                  ? Container(
                margin: EdgeInsets.only(
                    top: driverType == Constants.sharedDriver &&
                        isSwitched &&
                        parcelBoxList != null &&
                        parcelBoxList.isNotEmpty
                        ? MediaQuery
                        .of(context)
                        .size
                        .height * 0.23
                        : MediaQuery
                        .of(context)
                        .size
                        .height * 0.20),
                child: ListView.builder(
                    itemCount: outdeliveryList.length,
                    itemBuilder: (context, index) {
                      DeliveryPojoModal delivery = outdeliveryList[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                  color: Colors.grey[300])
                            ]),
                        margin: EdgeInsets.only(top: 1, left: 2.5, right: 2.5),
                        child: Card(
                          margin: EdgeInsets.only(
                              left: 4.0, right: 4.0, bottom: 2.0, top: 2.0),
                          color: delivery.orderId > 0 ? Colors.white : Colors
                              .green[300],
                          child: InkWell(
                            onTap: () async {
                              if (delivery.orderId > 0) {
                                if (delivery.status == "OutForDelivery") {
                                  bool checkInternet = await ConnectionValidator()
                                      .check();
                                  if (!checkInternet) {
                                    noInternetPopUp("Please complete manually");
                                  } else {
                                    orderListType = 4;
                                    scanBarcodeNormal(
                                        true,
                                        delivery.customerDetials.customerId,
                                        delivery.nursing_home_id == null ||
                                            delivery.nursing_home_id == "" ||
                                            delivery.nursing_home_id == 0
                                            ? delivery.orderId
                                            : 0);

                                  }
                                  //scanBarcodeForOrderCheck();
                                  // getOrderDetails("${delivery.orderId}",false);
                                } else if (delivery.status == "Ready") {
                                  getOrderDetails(
                                      "${delivery.orderId}", false, false, 0);
                                }
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8.0,
                                        right: 8.0,
                                        top: 4.0,
                                        bottom: 2.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: <Widget>[
                                            /*Text("Name", style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14
                                        ),),
                                        SizedBox(width: 5, height: 0,),*/
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  child: FittedBox(
                                                      child: Text(
                                                        "${index + 1}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10),
                                                      )),
                                                  backgroundColor: Colors
                                                      .orange[400],
                                                  radius: 8.0,
                                                ),
                                                Text(
                                                  "${delivery.customerDetials
                                                      .title ?? ""} ${delivery
                                                      .customerDetials
                                                      .firstName ?? ""} "
                                                      "${delivery
                                                      .customerDetials
                                                      .middleName ?? ""} "
                                                      "${delivery
                                                      .customerDetials
                                                      .lastName ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w700),
                                                ),
                                                if (delivery.nursing_home_id ==
                                                    null ||
                                                    delivery.nursing_home_id ==
                                                        0)
                                                  if (delivery.pmr_type !=
                                                      null &&
                                                      (delivery.pmr_type ==
                                                          "titan" ||
                                                          delivery.pmr_type ==
                                                              "nursing_box") &&
                                                      delivery.pr_id != null &&
                                                      delivery.pr_id.isNotEmpty)
                                                    Text(
                                                      '(P/N : ${delivery
                                                          .pr_id ?? ""}) ',
                                                      style: TextStyle(
                                                          color: CustomColors
                                                              .pnColor),
                                                    ),
                                                if (delivery.isCronCreated ==
                                                    "t")
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        top: 0.0, right: 8.0),
                                                    child: Image.asset(
                                                        "assets/automatic_icon.png",
                                                        height: 14, width: 14),
                                                  ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .end,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    children: <Widget>[
                                                      delivery.status !=
                                                          WebConstant
                                                              .Status_out_for_delivery
                                                          ? Text(
                                                        "${delivery.status ==
                                                            "Completed"
                                                            ? "Delivered"
                                                            : delivery.status ==
                                                            "Ready"
                                                            ? "ReadyForPickup"
                                                            : delivery.status ??
                                                            ""}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .w400,
                                                          color: delivery
                                                              .status ==
                                                              WebConstant
                                                                  .Status_out_for_delivery
                                                              ? CustomColors
                                                              .yetToStartColor
                                                              : delivery
                                                              .status ==
                                                              WebConstant
                                                                  .Status_delivered
                                                              ? CustomColors
                                                              .deliveredColor
                                                              : (delivery
                                                              .status ==
                                                              WebConstant
                                                                  .Status_failed
                                                              ? CustomColors
                                                              .failedColor
                                                              : (delivery
                                                              .status ==
                                                              WebConstant
                                                                  .Status_picked_up
                                                              ? CustomColors
                                                              .pickedUp
                                                              : Colors
                                                              .blueAccent)),
                                                        ),
                                                      )
                                                          : Container(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (delivery.status ==
                                                "OutForDelivery" ||
                                                delivery.status == "PickedUp" ||
                                                delivery.status == "Received")
                                              Row(
                                                children: [
                                                  if (delivery
                                                      .isStorageFridge !=
                                                      null &&
                                                      delivery
                                                          .isStorageFridge ==
                                                          "t")
                                                    Container(
                                                        height: 20,
                                                        padding: EdgeInsets
                                                            .only(
                                                            right: 5.0,
                                                            left: 5.0,
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(5.0),
                                                          color: Colors.blue,
                                                        ),
                                                        child: Center(
                                                            child: Image.asset(
                                                              "assets/fridge.png",
                                                              height: 20,
                                                              color: Colors
                                                                  .white,
                                                            ))),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  if (delivery
                                                      .isControlledDrugs !=
                                                      null &&
                                                      delivery
                                                          .isControlledDrugs ==
                                                          "t")
                                                    Container(
                                                      height: 20,
                                                      padding: EdgeInsets.only(
                                                          right: 3.0,
                                                          left: 3.0,
                                                          top: 2.0,
                                                          bottom: 2.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(5.0),
                                                        color: Colors.red,
                                                      ),
                                                      child: Center(
                                                        child: new Text(
                                                          'C.D.',
                                                          style:
                                                          TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12.0),
                                                        ),
                                                      ),
                                                    ),
                                                  if (delivery.orderId > 0)
                                                    if (delivery
                                                        .nursing_home_id ==
                                                        null ||
                                                        delivery
                                                            .nursing_home_id ==
                                                            0)
                                                      if (isSwitched)
                                                        PopupMenuButton(
                                                            padding: EdgeInsets
                                                                .zero,
                                                            child: Icon(
                                                              Icons.more_vert,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                            itemBuilder: (_) =>
                                                            [
                                                              new PopupMenuItem(
                                                                  enabled: true,
                                                                  height: 30.0,
                                                                  onTap: () {},
                                                                  child: StatefulBuilder(
                                                                    builder: ((
                                                                        context,
                                                                        setStat) {
                                                                      return Row(
                                                                        mainAxisSize: MainAxisSize
                                                                            .min,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap: () {
                                                                              delivery
                                                                                  .isCD =
                                                                              !delivery
                                                                                  .isCD;
                                                                              updateOrders(
                                                                                  delivery
                                                                                      .orderId,
                                                                                  delivery
                                                                                      .isCD,
                                                                                  delivery
                                                                                      .isFridge);
                                                                              setStat(() {});
                                                                              setState(() {});
                                                                              Navigator
                                                                                  .pop(
                                                                                  context);
                                                                            },
                                                                            child: Container(
                                                                              color: Colors
                                                                                  .red,
                                                                              child: Row(
                                                                                mainAxisSize:
                                                                                MainAxisSize
                                                                                    .min,
                                                                                children: [
                                                                                  Checkbox(
                                                                                    visualDensity:
                                                                                    VisualDensity(
                                                                                        horizontal:
                                                                                        -4,
                                                                                        vertical: -4),
                                                                                    value: delivery
                                                                                        .isCD,
                                                                                    onChanged:
                                                                                        (
                                                                                        newValue) {
                                                                                      setState(() {
                                                                                        delivery
                                                                                            .isCD =
                                                                                            newValue;
                                                                                      });
                                                                                      setStat(() {});
                                                                                      updateOrders(
                                                                                          delivery
                                                                                              .orderId,
                                                                                          delivery
                                                                                              .isCD,
                                                                                          delivery
                                                                                              .isFridge);
                                                                                      Navigator
                                                                                          .pop(
                                                                                          context);
                                                                                    },
                                                                                  ),
                                                                                  new Text(
                                                                                    'C. D.',
                                                                                    style: TextStyle(
                                                                                        color:
                                                                                        Colors
                                                                                            .white),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width: 1,
                                                                            margin: EdgeInsets
                                                                                .only(
                                                                                left: 4.0,
                                                                                right: 4.0),
                                                                            height: 25,
                                                                            decoration: BoxDecoration(
                                                                                border: Border
                                                                                    .all(
                                                                                    color: Colors
                                                                                        .black)),
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              delivery
                                                                                  .isFridge =
                                                                              !delivery
                                                                                  .isFridge;
                                                                              updateOrders(
                                                                                  delivery
                                                                                      .orderId,
                                                                                  delivery
                                                                                      .isCD,
                                                                                  delivery
                                                                                      .isFridge);
                                                                              setStat(() {});
                                                                              setState(() {});
                                                                              Navigator
                                                                                  .pop(
                                                                                  context);
                                                                            },
                                                                            child: Container(
                                                                              color: Colors
                                                                                  .blue,
                                                                              child: Row(
                                                                                mainAxisSize:
                                                                                MainAxisSize
                                                                                    .min,
                                                                                children: [
                                                                                  Checkbox(
                                                                                    visualDensity:
                                                                                    VisualDensity(
                                                                                        horizontal:
                                                                                        -4,
                                                                                        vertical: -4),
                                                                                    value:
                                                                                    delivery
                                                                                        .isFridge,
                                                                                    onChanged:
                                                                                        (
                                                                                        newValue) {
                                                                                      setState(() {
                                                                                        delivery
                                                                                            .isFridge =
                                                                                            newValue;
                                                                                      });
                                                                                      setStat(() {});
                                                                                      updateOrders(
                                                                                          delivery
                                                                                              .orderId,
                                                                                          delivery
                                                                                              .isCD,
                                                                                          delivery
                                                                                              .isFridge);
                                                                                      Navigator
                                                                                          .pop(
                                                                                          context);
                                                                                    },
                                                                                  ),
                                                                                  Padding(
                                                                                    padding:
                                                                                    const EdgeInsets
                                                                                        .only(
                                                                                        right: 12.0),
                                                                                    child: Image
                                                                                        .asset(
                                                                                      "assets/fridge.png",
                                                                                      height: 21,
                                                                                      color: Colors
                                                                                          .white,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width: 1,
                                                                            margin: EdgeInsets
                                                                                .only(
                                                                                left: 4.0,
                                                                                right: 4.0),
                                                                            height: 25,
                                                                            decoration: BoxDecoration(
                                                                                border: Border
                                                                                    .all(
                                                                                    color: Colors
                                                                                        .black)),
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              cancelOrder(
                                                                                  delivery
                                                                                      .orderId);
                                                                              Navigator
                                                                                  .pop(
                                                                                  context);
                                                                            },
                                                                            child: Row(
                                                                              mainAxisSize:
                                                                              MainAxisSize
                                                                                  .min,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons
                                                                                      .cancel_outlined,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5.0,
                                                                                ),
                                                                                Text(
                                                                                    "Cancel")
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      );
                                                                    }),
                                                                  )),
                                                              // new PopupMenuItem(
                                                              //     enabled: true,
                                                              //     height: 30.0,
                                                              //     onTap: (){},
                                                              //     child: StatefulBuilder(
                                                              //       builder: ((context, setStat) {
                                                              //         return InkWell(
                                                              //           onTap: (){
                                                              //             pmrList[index].isFridge = !pmrList[index].isFridge;
                                                              //             updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                              //             setStat((){});
                                                              //             setState(() {});
                                                              //             Navigator.pop(context);
                                                              //           },
                                                              //           child: Container(
                                                              //             color: Colors.blue,
                                                              //             child: Row(
                                                              //               mainAxisSize: MainAxisSize.min,
                                                              //               children: [
                                                              //                 Checkbox(
                                                              //                   visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                                              //                   value: pmrList[index].isFridge,
                                                              //                   onChanged: (newValue) {
                                                              //                     setState(() {
                                                              //                       pmrList[index].isFridge = newValue;
                                                              //                     });
                                                              //                     setStat((){});
                                                              //                     updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                              //                     Navigator.pop(context);
                                                              //                   },
                                                              //                 ),
                                                              //                 Padding(
                                                              //                   padding: const EdgeInsets.only(right: 12.0),
                                                              //                   child: Image.asset("assets/fridge.png", height: 21,color: Colors.white,),
                                                              //                 )
                                                              //               ],
                                                              //             ),
                                                              //           ),
                                                              //         );
                                                              //       }),
                                                              //     )
                                                              // ),
                                                              // new PopupMenuItem(
                                                              //     enabled: true,
                                                              //     height: 40.0,
                                                              //     onTap: (){},
                                                              //     child: StatefulBuilder(
                                                              //       builder: ((context, setStat) {
                                                              //         return InkWell(
                                                              //           onTap: (){
                                                              //             cancelOrder(pmrList[index].orderId);
                                                              //             Navigator.pop(context);
                                                              //           },
                                                              //           child: Row(
                                                              //             mainAxisSize: MainAxisSize.min,
                                                              //             children: [
                                                              //               Icon(
                                                              //                 Icons.cancel_outlined,
                                                              //               ),
                                                              //               SizedBox(
                                                              //                 width: 5.0,
                                                              //               ),
                                                              //               Text("Cancel")
                                                              //             ],
                                                              //           ),
                                                              //         );
                                                              //       }),
                                                              //     )
                                                              // ),
                                                            ]),
                                                ],
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            if (delivery.bagSize != null &&
                                                delivery.bagSize.isNotEmpty)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(5)),
                                                    color: Colors.green,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          spreadRadius: 1,
                                                          blurRadius: 10,
                                                          offset: Offset(0, 4),
                                                          color: Colors
                                                              .grey[300])
                                                    ]),
                                                padding:
                                                EdgeInsets.only(left: 5,
                                                    right: 5,
                                                    top: 2,
                                                    bottom: 2),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .shopping_bag_outlined,
                                                      size: 18,
                                                    ),
                                                    Text(
                                                      ": ${delivery.bagSize}",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            if (delivery.nursing_home_id ==
                                                null ||
                                                delivery.nursing_home_id == 0)
                                              if (delivery.serviceName !=
                                                  null &&
                                                  delivery.serviceName != "")
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(right: 4.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                          color: Colors.red,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius: 1,
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    0, 4),
                                                                color: Colors
                                                                    .grey[300])
                                                          ]),
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 3,
                                                          top: 3),
                                                      child: Text(
                                                        delivery.serviceName
                                                            .length > 10
                                                            ? delivery
                                                            .serviceName
                                                            .toString()
                                                            .substring(0, 10)
                                                            : delivery
                                                            .serviceName ?? "",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                      )),
                                                ),
                                            if (delivery.pharmacyName != null &&
                                                delivery.pharmacyName != "" &&
                                                driverType ==
                                                    Constants.sharedDriver)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(5)),
                                                        color: Colors.orange,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              spreadRadius: 1,
                                                              blurRadius: 10,
                                                              offset: Offset(0,
                                                                  4),
                                                              color: Colors
                                                                  .grey[300])
                                                        ]),
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 3,
                                                        top: 3),
                                                    child: Text(
                                                      delivery.pharmacyName
                                                          .length > 14
                                                          ? delivery
                                                          .pharmacyName
                                                          .substring(0, 14)
                                                          : delivery
                                                          .pharmacyName ?? "",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    )),
                                              ),
                                            if (selectedType == WebConstant
                                                .Status_out_for_delivery &&
                                                delivery.parcelBoxName !=
                                                    null &&
                                                delivery.parcelBoxName
                                                    .toString()
                                                    .isNotEmpty)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.red),
                                                        borderRadius: BorderRadius
                                                            .circular(5.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left: 3.0,
                                                          right: 3.0,
                                                          top: 2.0,
                                                          bottom: 2.0),
                                                      child: Text(
                                                        "${delivery
                                                            .parcelBoxName
                                                            .length > 8
                                                            ? delivery
                                                            .parcelBoxName
                                                            .substring(0, 8)
                                                            : delivery
                                                            .parcelBoxName ??
                                                            ""}",
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .pickedUp,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                          height: 3,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            // Image.asset(
                                            //   "assets/home_icon.png",
                                            //   height: 18,
                                            //   width: 18,
                                            //   color: selectedType ==
                                            //       WebConstant
                                            //           .Status_out_for_delivery
                                            //       ? CustomColors
                                            //       .yetToStartColor
                                            //       : selectedType ==
                                            //       WebConstant
                                            //           .Status_delivered
                                            //       ? CustomColors
                                            //       .deliveredColor
                                            //       : (selectedType ==
                                            //       WebConstant
                                            //           .Status_failed
                                            //       ? CustomColors
                                            //       .failedColor
                                            //       : (selectedType ==
                                            //       WebConstant
                                            //           .Status_picked_up
                                            //       ? CustomColors
                                            //       .pickedUp
                                            //       : Colors
                                            //       .blueAccent)),
                                            // ),
                                            // SizedBox(
                                            //   width: 5,
                                            //   height: 0,
                                            // ),
                                            Flexible(
                                              child: Text(
                                                "${delivery.customerDetials
                                                    .customerAddress != null
                                                    ? delivery.customerDetials
                                                    .customerAddress.address1 ??
                                                    delivery.customerDetials
                                                        .customerAddress
                                                        .address2 ?? ""
                                                    : ""} ${delivery
                                                    .customerDetials
                                                    .customerAddress != null
                                                    ? delivery.customerDetials
                                                    .customerAddress.postCode
                                                    .split("#")[0] ?? ""
                                                    : ""}",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .w300),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                              height: 0,
                                            ),
                                            if (delivery.customerDetials
                                                .customerAddress != null &&
                                                delivery.customerDetials
                                                    .customerAddress
                                                    .alt_address == "t")
                                              Image.asset(
                                                "assets/alt-add.png",
                                                height: 18,
                                                width: 18,
                                              ),
                                          ],
                                        ),
                                        selectedType ==
                                            WebConstant.Status_out_for_delivery
                                            ? Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                bool checkInternet =
                                                await ConnectionValidator()
                                                    .check();
                                                if (!checkInternet) {
                                                  noInternetPopUp(Constants
                                                      .internet_notavailable);
                                                  return;
                                                }
                                                if (_locationData == null) {
                                                  if (_permissionGranted ==
                                                      PermissionStatus
                                                          .granted) {
                                                    _locationData =
                                                    await location
                                                        .getLocation();
                                                  }
                                                }

                                                if (Platform.isAndroid) {
                                                  final AndroidIntent intent = new AndroidIntent(
                                                      action: 'action_view',
                                                      data: Uri.encodeFull(
                                                          "https://www.google.com/maps/dir/?api=1&origin=${_locationData
                                                              .latitude},${_locationData
                                                              .longitude}"
                                                              "&destination=${delivery
                                                              .customerDetials
                                                              .address}"),
                                                      package: 'com.google.android.apps.maps');
                                                  intent.launch();
                                                } else {
                                                  MapsLauncher.launchQuery(
                                                      "${delivery
                                                          .customerDetials
                                                          .customerAddress
                                                          .address1 ?? delivery
                                                          .customerDetials
                                                          .customerAddress
                                                          .address2 ?? ""}");

                                                  MapsLauncher
                                                      .launchCoordinates(
                                                      double.parse(delivery
                                                          .customerDetials
                                                          .customerAddress
                                                          .latitude ??
                                                          "0.0"),
                                                      double.parse(delivery
                                                          .customerDetials
                                                          .customerAddress
                                                          .longitude ??
                                                          "0.0"));
                                                  // String url = "https://www.google.com/maps/dir/?api=1&origin=${_latLng[0]}&destination=${_latLng[0]}&travelmode=driving&dir_action=navigate";
                                                }
                                              },
                                              child: Container(
                                                width: 35,
                                                margin: EdgeInsets.only(
                                                    left: 1,
                                                    right: 1,
                                                    top: 2,
                                                    bottom: 2),
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          spreadRadius: 1,
                                                          blurRadius: 10,
                                                          offset: Offset(0, 4),
                                                          color: Colors
                                                              .grey[300])
                                                    ]),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      "assets/send.png",
                                                      height: 10,
                                                      width: 10,
                                                    ),
                                                    // SizedBox(
                                                    //   width:
                                                    //       5,
                                                    //   height:
                                                    //       0,
                                                    // ),
                                                    // Text(
                                                    //   "Route",
                                                    //   style: TextStyle(
                                                    //       fontSize: 12,
                                                    //       fontWeight: FontWeight.w500,
                                                    //       color: Colors.white),
                                                    // ),
                                                    // SizedBox(
                                                    //   width:
                                                    //       5,
                                                    //   height:
                                                    //       0,
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            if (delivery.orderId > 0)
                                              InkWell(
                                                onTap: () async {
                                                  logger.i(
                                                      "All details print :::::::::"
                                                          "\norderId:-> ${delivery
                                                          .orderId}"
                                                          "\ndeliveryStatus:-> ${delivery
                                                          .deliveryStatus}"
                                                          "\nrouteId:-> ${delivery
                                                          .routeId}"
                                                          "\nisControlledDrugs:-> ${delivery
                                                          .isControlledDrugs}"
                                                          "\npharmacyId:-> ${delivery
                                                          .pharmacyId}"
                                                          "\nisDelCharge:-> ${delivery
                                                          .isDelCharge}"
                                                          "\nisPresCharge:-> ${delivery
                                                          .isPresCharge}"
                                                          "\nsortBy:-> ${delivery
                                                          .sortBy}"
                                                          "\nisStorageFridge:-> ${delivery
                                                          .isStorageFridge}"
                                                          "\ndeliveryNotes:-> ${delivery
                                                          .deliveryNotes}"
                                                          "\nexistingDeliveryNotes:-> ${delivery
                                                          .existingDeliveryNotes}"
                                                          "\nrxCharge:-> ${delivery
                                                          .rxCharge}"
                                                          "\ndelCharge:-> ${delivery
                                                          .delCharge}"
                                                          "\nrxInvoice:-> ${delivery
                                                          .rxInvoice}"
                                                          "\nsubsId:-> ${delivery
                                                          .subsId}"
                                                          "\ntotalControlledDrugs:-> ${delivery
                                                          .totalControlledDrugs}"
                                                          "\ntotalStorageFridge:-> ${delivery
                                                          .totalStorageFridge}"
                                                          "\nnursing_home_id:-> ${delivery
                                                          .nursing_home_id}"
                                                          "\nisCD:-> ${delivery
                                                          .isCD}"
                                                          "\nisFridge:-> ${delivery
                                                          .isFridge}"
                                                          "\nstatus:-> ${delivery
                                                          .status}"
                                                          "\nrescheduleDate:-> ${delivery
                                                          .rescheduleDate}"
                                                          "\nexemption:-> ${delivery
                                                          .exemption}"
                                                          "\nparcelBoxName:-> ${delivery
                                                          .parcelBoxName}"
                                                          "\nserviceName:-> ${delivery
                                                          .serviceName}"
                                                          "\nisCronCreated:-> ${delivery
                                                          .isCronCreated}"
                                                          "\nbagSize:-> ${delivery
                                                          .bagSize}"
                                                          "\npaymentStatus:-> ${delivery
                                                          .paymentStatus}"
                                                          "\npmr_type:-> ${delivery
                                                          .pmr_type}"
                                                          "\npr_id:-> ${delivery
                                                          .pr_id}"
                                                          "\npharmacyName:-> ${delivery
                                                          .pharmacyName}"
                                                          "\nisSelected:-> ${delivery
                                                          .isSelected}"
                                                          "\ncustomerDetials:-> ${delivery
                                                          .customerDetials}");
                                                  getOrderDetailsDB(
                                                      delivery, false, true);
                                                  // getOrderDetails(
                                                  //     delivery
                                                  //         .orderId
                                                  //         .toString(),
                                                  //     false,
                                                  //     true);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 1,
                                                      right: 1,
                                                      top: 2,
                                                      bottom: 2),
                                                  padding: EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 15.0,
                                                      top: 4.0,
                                                      bottom: 4.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: 1,
                                                            blurRadius: 10,
                                                            offset: Offset(
                                                                0, 4),
                                                            color: Colors
                                                                .grey[300])
                                                      ]),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        "Manual",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            SizedBox(width: 5),
                                            if (index != 0 ||
                                                delivery.orderId == 0)
                                              InkWell(
                                                onTap: () async {
                                                  logger.i(delivery.sortBy);
                                                  bool checkInternet =
                                                  await ConnectionValidator()
                                                      .check();
                                                  if (!checkInternet) {
                                                    noInternetPopUp(Constants
                                                        .internet_notavailable);
                                                  } else {
                                                    checkOfflineDeliveryAvailable1(
                                                        delivery);
                                                    // if (delivery.orderId > 0) {
                                                    //   if(delivery.sortBy != null && delivery.sortBy.isNotEmpty && delivery.sortBy == "pharmacy")
                                                    //     showConfirmMakeNextDialog(delivery.orderId);
                                                    //   else
                                                    //   showAleartMakeNext(
                                                    //       delivery
                                                    //           .orderId);
                                                    // } else {
                                                    //   endRoutePopup();
                                                    // }
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 1,
                                                      right: 1,
                                                      top: 2,
                                                      bottom: 2),
                                                  padding: EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                      top: 4.0,
                                                      bottom: 4.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                      color: Colors.orange,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: 1,
                                                            blurRadius: 10,
                                                            offset: Offset(
                                                                0, 4),
                                                            color: Colors
                                                                .grey[300])
                                                      ]),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        delivery.orderId > 0
                                                            ? "Make Next"
                                                            : "Arrived",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            color: Colors
                                                                .white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                            : Container(
                                          height: 0,
                                          width: 0,
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
                    }),
              )
                  : isNetworkError
                  ? Container(
                padding: EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          logger.i("tesss");
                        },
                        child: IgnorePointer(
                            child: Text(
                              WebConstant.INTERNET_NOT_AVAILABENEW,
                              textAlign: TextAlign.center,
                            ))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          selectWithTypeCount(selectedType);
                        },
                        child: Text(
                          "Retry",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    )
                  ],
                ),
              )
                  : Container(
                height: 0,
                width: 0,
              ),

              //Status counter
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.only(
                        left: 2.5,
                        right: 2.5,
                        top: driverType == Constants.sharedDriver
                            ? isSwitched && parcelBoxList != null &&
                            parcelBoxList.isNotEmpty
                            ? 120
                            : 60
                            : 60,
                        bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: InkWell(
                            onTap: () async {
                              bool checkInternet = await ConnectionValidator()
                                  .check();
                              if (!checkInternet) {
                                noInternetPopUp(
                                    Constants.internet_notavailable);
                              } else {
                                orderListType = 1;
                                selectWithTypeCount(WebConstant.Status_total);
                                print(orderListType.toString() +
                                    "ORDER LIST TYPE IS THIS ");
                              }
                            },
                            child: topCounter(Colors.blueAccent, "Total",
                                "${_dashBoardModal != null ? _dashBoardModal
                                    .orderCounts.totalOrders ?? 0 : 0}"),
                          ),
                        ),
                        isRouteStart
                            ? Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: InkWell(
                            onTap: () {
                              orderListType = 4;
                              getDeliveryListFromDB();
                              selectedType =
                                  WebConstant.Status_out_for_delivery;
                              // selectWithTypeCount(
                              //     WebConstant.Status_out_for_delivery);
                            },
                            child: topCounter(
                                CustomColors.yetToStartColor,
                                // "Out for delivery",
                                "On the way",
                                "${outdeliveryList != null &&
                                    outdeliveryList.isNotEmpty
                                    ? isNextPharmacyAvailable >= 0
                                    ? outdeliveryList.length - 1
                                    : outdeliveryList.length
                                    : 0}"
                              // "${_dashBoardModal != null ? _dashBoardModal !=
                              //     null ? (_dashBoardModal.orderCounts == null
                              //     ? 0
                              //     : _dashBoardModal.orderCounts
                              //     .outForDeliveryOrders) : 0 ?? 0 : 0}"

                            ),
                          ),
                        )
                            : Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: InkWell(
                            onTap: () {
                              orderListType = 8;
                              selectWithTypeCount(WebConstant.Status_picked_up);
                            },
                            child: topCounter(
                                CustomColors.pickedUp, "Picked Up",
                                "${_dashBoardModal != null ? _dashBoardModal
                                    .orderCounts.pickedupOrders ?? 0 : 0}"),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: InkWell(
                            onTap: () async {
                              bool checkInternet = await ConnectionValidator()
                                  .check();
                              if (!checkInternet) {
                                noInternetPopUp(
                                    Constants.internet_notavailable);
                              } else {
                                orderListType = 5;
                                selectWithTypeCount(
                                    WebConstant.Status_delivered);
                              }
                            },
                            child: topCounter(
                                CustomColors.deliveredColor, "Delivered",
                                "${_dashBoardModal != null ? _dashBoardModal
                                    .orderCounts.deliveredOrders ?? 0 : 0}"),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: InkWell(
                            onTap: () async {
                              bool checkInternet = await ConnectionValidator()
                                  .check();
                              if (!checkInternet) {
                                noInternetPopUp(
                                    Constants.internet_notavailable);
                              } else {
                                orderListType = 6;
                                selectWithTypeCount(WebConstant.Status_failed);
                              }
                            },
                            child: topCounter(
                                CustomColors.failedColor, "Failed",
                                "${_dashBoardModal != null ? _dashBoardModal
                                    .orderCounts.faildOrders ?? 0 : 0}"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // Top Route Dropdown
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, right: 4.0, top: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isRouteStart) {
                                      Fluttertoast.showToast(
                                          msg: "You are already on a route, you can't change before completed.");
                                    } else {
                                      if (routeList.length > 0) {
                                        _isVisibleRouteList =
                                        !_isVisibleRouteList;
                                        _isVisiblePharmacyList = false;
                                        _isToteList = false;
                                        hideTote = true;
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "You don't have any route. Try again after and refresh now.");
                                        _isVisibleRouteList = false;
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 13.0,
                                      right: 10.0,
                                      top: 12,
                                      bottom: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                      //border: Border.all(color: Colors.grey[400]),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                            color: Colors.grey[300])
                                      ]),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Text(
                                          "${selectedRoute != null
                                              ? selectedRoute.routeName ??
                                              "Select Route"
                                              : "Select Route"}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.lightBlue),
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.lightBlue,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: driverType == Constants.sharedDriver
                                  ? true
                                  : false,
                              child: SizedBox(
                                width: 5.0,
                              ),
                            ),
                            Visibility(
                              visible: driverType == Constants.sharedDriver
                                  ? true
                                  : false,
                              child: Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (pharmacyList.length > 0) {
                                        _isVisiblePharmacyList =
                                        !_isVisiblePharmacyList;
                                        _isVisibleRouteList = false;
                                        _isToteList = false;
                                        hideTote = true;
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Pharmacy Not Available");
                                        _isVisiblePharmacyList = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 13.0,
                                        right: 10.0,
                                        top: 12,
                                        bottom: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            5.0),
                                        color: Colors.white,
                                        //border: Border.all(color: Colors.grey[400]),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                              color: Colors.grey[300])
                                        ]),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            "${selectedPharmacy != null
                                                ? selectedPharmacy
                                                .pharmacyName ??
                                                "Select Pharmacy"
                                                : "Select Pharmacy"}",
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.lightBlue),
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.lightBlue,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: driverType ==
                                  Constants.dadicatedDriver && isSwitched
                                  ? true
                                  : false,
                              child: SizedBox(
                                width: 5.0,
                              ),
                            ),
                            Visibility(
                              visible: isSwitched &&
                                  driverType == Constants.sharedDriver,
                              child: SizedBox(
                                width: 5.0,
                              ),
                            ),
                            Visibility(
                              visible: isSwitched &&
                                  driverType == Constants.dadicatedDriver,
                              child: Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (parcelBoxList.length > 0) {
                                        _isToteList = !_isToteList;
                                        _isVisibleRouteList = false;
                                        _isVisiblePharmacyList = false;
                                        hideTote = true;
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Parcel Location Not Available");
                                        _isToteList = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 13.0,
                                        right: 10.0,
                                        top: 12,
                                        bottom: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            5.0),
                                        color: Colors.white,
                                        //border: Border.all(color: Colors.grey[400]),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                              color: Colors.grey[300])
                                        ]),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text(
                                            "${_selectedTotePosition != null &&
                                                _selectedTotePosition != -1
                                                ? parcelBoxList[_selectedTotePosition]
                                                .name ?? "Parcel Location"
                                                : "Parcel Location"}",
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.lightBlue),
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.lightBlue,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // driverType == Constants.sharedDriver && !hideTote && nHomeList1 != null && nHomeList1.isNotEmpty ?
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Container(
                        //     height: 50,
                        //     child: Row(
                        //       children: [
                        //         Visibility(
                        //           visible: isSwitched,
                        //           child: Expanded(
                        //             flex: 1,
                        //             child: InkWell(
                        //               onTap: () {
                        //                 setState(() {
                        //                   if (nHomeList1.length > 0) {
                        //                     _isNursingHomeList =
                        //                     !_isNursingHomeList;
                        //                     _isVisibleRouteList = false;
                        //                     _isVisiblePharmacyList = false;
                        //                     _isToteList = false;
                        //                     hideTote = true;
                        //                   } else {
                        //                     Fluttertoast.showToast(
                        //                         msg: "Nursing Home Not Available");
                        //                     _isNursingHomeList = false;
                        //                   }
                        //                 });
                        //               },
                        //               child: Container(
                        //                 padding: const EdgeInsets.only(
                        //                     left: 13.0,
                        //                     right: 10.0,
                        //                     top: 12,
                        //                     bottom: 12),
                        //                 decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.circular(5.0),
                        //                     color: Colors.white,
                        //                     //border: Border.all(color: Colors.grey[400]),
                        //                     boxShadow: [
                        //                       BoxShadow(
                        //                           spreadRadius: 1,
                        //                           blurRadius: 10,
                        //                           offset: Offset(0, 4),
                        //                           color: Colors.grey[300])
                        //                     ]),
                        //                 child: Row(
                        //                   children: <Widget>[
                        //                     Flexible(
                        //                       flex: 1,
                        //                       fit: FlexFit.tight,
                        //                       child: Text(
                        //                         "${_selectedNursingPosition != null && _selectedNursingPosition != -1
                        //                             ? nHomeList1[_selectedNursingPosition].nursingHomeName ??
                        //                             "Select Nursing Home"
                        //                             : "Select Nursing Home"}",
                        //                         maxLines: 1,
                        //                         style: TextStyle(
                        //                             fontSize: 14,
                        //                             fontWeight: FontWeight.w400,
                        //                             color: Colors.lightBlue),
                        //                       ),
                        //                     ),
                        //                     Icon(
                        //                       Icons.keyboard_arrow_down,
                        //                       color: Colors.lightBlue,
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         Visibility(
                        //           visible: isSwitched,
                        //           child: SizedBox(
                        //             width: 5.0,
                        //           ),
                        //         ),
                        //         Visibility(
                        //           visible: !hideTote && isSwitched && toteList != null && toteList.isNotEmpty,
                        //           child: Expanded(
                        //             flex: 1,
                        //             child: InkWell(
                        //               onTap: () {
                        //                 setState(() {
                        //                   if (toteList.length > 0) {
                        //                     _isToteList =
                        //                     !_isToteList;
                        //                     _isVisibleRouteList = false;
                        //                     _isVisiblePharmacyList = false;
                        //                     _isNursingHomeList = false;
                        //                   } else {
                        //                     Fluttertoast.showToast(
                        //                         msg: "Tote Not Available");
                        //                     _isToteList = false;
                        //                   }
                        //                 });
                        //               },
                        //               child: Container(
                        //                 padding: const EdgeInsets.only(
                        //                     left: 13.0,
                        //                     right: 10.0,
                        //                     top: 12,
                        //                     bottom: 12),
                        //                 decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.circular(5.0),
                        //                     color: Colors.white,
                        //                     //border: Border.all(color: Colors.grey[400]),
                        //                     boxShadow: [
                        //                       BoxShadow(
                        //                           spreadRadius: 1,
                        //                           blurRadius: 10,
                        //                           offset: Offset(0, 4),
                        //                           color: Colors.grey[300])
                        //                     ]),
                        //                 child: Row(
                        //                   children: <Widget>[
                        //                     Flexible(
                        //                       flex: 1,
                        //                       fit: FlexFit.tight,
                        //                       child: Text(
                        //                         "${_selectedTotePosition != null && _selectedTotePosition != -1
                        //                             ? toteList[_selectedTotePosition].boxName ??
                        //                             "Select Tote"
                        //                             : "Select Tote"}",
                        //                         maxLines: 1,
                        //                         style: TextStyle(
                        //                             fontSize: 14,
                        //                             fontWeight: FontWeight.w400,
                        //                             color: Colors.lightBlue),
                        //                       ),
                        //                     ),
                        //                     Icon(
                        //                       Icons.keyboard_arrow_down,
                        //                       color: Colors.lightBlue,
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ) :
                        Visibility(
                          visible: !hideTote && isSwitched &&
                              driverType == Constants.sharedDriver,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (parcelBoxList.length > 0) {
                                    _isToteList = !_isToteList;
                                    _isVisibleRouteList = false;
                                    _isVisiblePharmacyList = false;
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Parcel Location Not Available");
                                    _isToteList = false;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 13.0,
                                    right: 10.0,
                                    top: 12,
                                    bottom: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                    //border: Border.all(color: Colors.grey[400]),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                          color: Colors.grey[300])
                                    ]),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        "${_selectedTotePosition != null &&
                                            _selectedTotePosition != -1
                                            ? parcelBoxList[_selectedTotePosition]
                                            .name ?? "Parcel Location"
                                            : "Parcel Location"}",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.lightBlue),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.lightBlue,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isVisiblePharmacyList,
                    child: Container(
                      margin: EdgeInsets.only(top: 0, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          //border: Border.all(color: Colors.grey[400]),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1, blurRadius: 10, offset: Offset(
                                0, 4), color: Colors.grey[300])
                          ]),
                      child: Column(
                        children: <Widget>[
                          ListView.separated(
                            itemCount: pharmacyList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              PharmacyList pharmacy = pharmacyList[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedPharmacyDropDown =
                                    pharmacyList[index];
                                    _selectedPharmacyPosition = index;
                                  });
                                },
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  padding: const EdgeInsets.only(left: 13.0,
                                      right: 10.0,
                                      top: 12,
                                      bottom: 12),
                                  color: pharmacy ==
                                      selectedPharmacyDropDown //route == selectedRoute//_selectedRoutePosition == index
                                      ? Colors.blue[50]
                                      : Colors.transparent,
                                  child: Text(
                                    "${pharmacy.pharmacyName ??
                                        "Select Pharmacy"}",
                                    style:
                                    TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.lightBlue),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context,
                                int index) {
                              return Divider(
                                height: 1,
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 12, bottom: 12),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPharmacyDropDown =
                                            selectedPharmacy;
                                        _isVisiblePharmacyList = false;
                                        hideTote = false;
                                      });
                                    },
                                    child: Text(
                                      "Cancel",
                                      style:
                                      TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.redAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      if (_selectedPharmacyPosition < 0) {
                                        Fluttertoast.showToast(
                                            msg: "Choose Pharmacy First");
                                        return;
                                      }
                                      setState(() {
                                        _isVisiblePharmacyList = false;
                                        selectedPharmacy =
                                        pharmacyList[_selectedPharmacyPosition];
                                        pharmacyId =
                                        "${selectedPharmacy.pharmacyId}";
                                        hideTote = false;
                                      });
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.greenAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isToteList,
                    child: Container(
                      margin: EdgeInsets.only(top: 0, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          //border: Border.all(color: Colors.grey[400]),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1, blurRadius: 10, offset: Offset(
                                0, 4), color: Colors.grey[300])
                          ]),
                      child: Column(
                        children: <Widget>[
                          ListView.separated(
                            itemCount: parcelBoxList != null &&
                                parcelBoxList.isNotEmpty
                                ? parcelBoxList.length
                                : 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ParcelBoxData nusingList = parcelBoxList[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    totePosition = index;
                                  });
                                },
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  padding: const EdgeInsets.only(left: 13.0,
                                      right: 10.0,
                                      top: 12,
                                      bottom: 12),
                                  color: totePosition ==
                                      index //route == selectedRoute//_selectedRoutePosition == index
                                      ? Colors.blue[50]
                                      : Colors.transparent,
                                  child: Text(
                                    "${nusingList.name ?? "Parcel Location"}",
                                    style:
                                    TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.lightBlue),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context,
                                int index) {
                              return Divider(
                                height: 1,
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 12, bottom: 12),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isToteList = false;
                                        hideTote = false;
                                      });
                                    },
                                    child: Text(
                                      "Cancel",
                                      style:
                                      TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.redAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      if (totePosition < 0) {
                                        Fluttertoast.showToast(
                                            msg: "Choose Nursing Home");
                                        return;
                                      }
                                      setState(() {
                                        _isToteList = false;
                                        _selectedTotePosition = totePosition;
                                        logger.i(_selectedTotePosition);
                                        hideTote = false;
                                      });
                                    },
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.greenAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isVisibleRouteList,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                            //border: Border.all(color: Colors.grey[400]),
                            boxShadow: [
                              BoxShadow(spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                  color: Colors.grey[300])
                            ]),
                        child: Column(
                          children: <Widget>[
                            ListView.separated(
                              itemCount: routeList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                RouteList route = routeList[index];
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedRouteDropDown = routeList[index];
                                      _selectedRoutePosition = index;
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    padding: const EdgeInsets.only(left: 13.0,
                                        right: 10.0,
                                        top: 12,
                                        bottom: 12),
                                    color: route ==
                                        selectedRouteDropDown //route == selectedRoute//_selectedRoutePosition == index
                                        ? Colors.blue[50]
                                        : Colors.transparent,
                                    child: Text(
                                      "${route.routeName ?? "Select Pharmacy"}",
                                      style:
                                      TextStyle(fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.lightBlue),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context,
                                  int index) {
                                return Divider(
                                  height: 1,
                                );
                              },
                            ),
                            Divider(
                              height: 1,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 12, bottom: 12),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedRouteDropDown = selectedRoute;
                                          _isVisibleRouteList = false;
                                          hideTote = false;
                                        });
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.redAccent),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: () {
                                        if (_selectedRoutePosition < 0) {
                                          Fluttertoast.showToast(
                                              msg: "Choose Route First");
                                          return;
                                        }
                                        setState(() {
                                          selectedType =
                                              WebConstant.Status_total;
                                          _isVisibleRouteList = false;
                                          hideTote = false;
                                          selectedRoute =
                                          routeList[_selectedRoutePosition];

                                          routeId = "${selectedRoute.routeId}";
                                          SharedPreferences.getInstance().then((
                                              value) {
                                            value.setString(
                                                WebConstant.ROUTE_ID, routeId);
                                          });
                                          setState(() {
                                            isProgressAvailable = true;
                                          });
                                          orderListType = 1;
                                          fetchDeliveryList(0);
                                        });
                                      },
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.greenAccent),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedType.toLowerCase() !=
          WebConstant.Status_total.toLowerCase()
          ? selectedType.toLowerCase() ==
          WebConstant.Status_picked_up.toLowerCase() &&
          deliveryList.length > 0 &&
          !isRouteStart
          ? ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: () async {
          await getVehicleInfo().then((value) {
            // if (vehicleList != null && vehicleList.isNotEmpty && selectedVehicle.id == 0)
            //   showVehiclePopup();
            if (locationArray != null) {
              print("Staring routeitssss ");
              confirmationPopupForStartRoute();
            } else {
              print("Unable to start routeitssss ");

              getLocationData();
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "START ROUTE",
                style: TextStyle(fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 5,
                height: 0,
              ),
              //SvgPicture.asset("assets/fast_forward.svg", height: 18, width: 18, color: Colors.white,)
            ],
          ),
        ),
      )
          : (isRouteStart &&
          selectedType == WebConstant.Status_out_for_delivery &&
          !isProgressAvailable)
          ? Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (outdeliveryList.length > 0)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    bool checkInternet = await ConnectionValidator().check();
                    if (!checkInternet) {
                      noInternetPopUp(Constants.internet_notavailable);
                    } else
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => SuggestionScreen()))
                          .then((value) {
                        if (isRouteStart) {
                          orderListType = 4;
                          selectWithTypeCount(
                              WebConstant.Status_out_for_delivery);
                        }
                      });
                    // Navigator.push(
                    //   context, MaterialPageRoute(builder: (context) => SuggestionScreen())
                    // );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Bulk Drop".toUpperCase(),
                          style:
                          TextStyle(fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 5,
                          height: 0,
                        ),
                        //SvgPicture.asset("assets/fast_forward.svg", height: 18, width: 18, color: Colors.white,)
                      ],
                    ),
                  ),
                ),
              ),
            if (outdeliveryList.length > 0)
              SizedBox(
                width: 20,
              ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                onPressed: () async {
                  bool checkInternet = await ConnectionValidator().check();
                  if (!checkInternet) {
                    noInternetPopUp(Constants.internet_notavailable);
                  } else {
                    checkOfflineDeliveryAvailable(false);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "END ROUTE",
                        style: TextStyle(fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 5,
                        height: 0,
                      ),
                      //SvgPicture.asset("assets/fast_forward.svg", height: 18, width: 18, color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : (isRouteStart &&
          selectedType == WebConstant.Status_out_for_delivery &&
          outdeliveryList.length > 0 &&
          !isProgressAvailable)
          ?

      // Comment buk drop button
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SuggestionScreen()))
              .then((value) {
            if (isRouteStart) {
              orderListType = 4;
              selectWithTypeCount(WebConstant.Status_out_for_delivery);
            }
          });
          // Navigator.push(
          //   context, MaterialPageRoute(builder: (context) => SuggestionScreen())
          // );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Bulk Drop",
                style: TextStyle(fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 5,
                height: 0,
              ),
              //SvgPicture.asset("assets/fast_forward.svg", height: 18, width: 18, color: Colors.white,)
            ],
          ),
        ),
      )
          : Container(
        height: 0,
        width: 0,
      )
          : Container(
        height: 0,
        width: 0,
      ),
    );
  }

  Future<void> checkOfflineDeliveryAvailable(bool) async {
    var completeAllList = await MyDatabase().getAllOrderCompleteData();
    if (completeAllList != null && completeAllList.isNotEmpty) {
      BuildContext dialogContext;
      isDialogShowing = true;
      await showDialog<ConfirmAction>(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            dialogContext = context;
            dialogDissmissTimer(dialogContext);
            return WillPopScope(
              onWillPop: () => Future.value(bool ? false : true),
              child: CustomDialogBox(
                // img: Image.asset("assets/delivery_truck.png"),
                icon: Icon(Icons.timer),
                title: "Alert...",
                btnDone: bool ? null : "Okay",
                btnNo: bool ? null : "",
                onClicked: onClick,
                descriptions: bool ? Constants.uploading_msg1 : Constants
                    .uploading_msg,
              ),
            );
          });
    } else {
      if (outdeliveryList.length > 0 && !bool)
        endRoutePopup();
      else
        endRoute(false);
    }
  }

  void onClick(bool value) {
    isDialogShowing = false;
    if (value) {
      timer1.cancel();
      // updateSignature();
    }
  }

  void onClick1(bool value) {
    if (value) {}
  }

  getLocationData() async {
    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
      if (value) {
        if (location == null) location = Location();
        _locationData = await location.getLocation();
        if (_locationData != null) locationArray.add(_locationData);
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            return;
          } else {
            // print("granted");
          }
        }
        if (_permissionGranted == PermissionStatus.granted) {
          _locationData = await location.getLocation();
          location.changeSettings(
              distanceFilter: 10, accuracy: LocationAccuracy.high);
          location.enableBackgroundMode(enable: true);
          location.onLocationChanged.listen((LocationData currentLocation) {
            // Fluttertoast.showToast(msg: "Update1");
            // print("location change 2222");
            // Fluttertoast.showToast(msg: "Location Update1");
            locationArray.add(currentLocation);
            if (locationArray.length > 5) locationArray.removeAt(0);
          });
        }
      }
    });
  }

  // updateLocation() async {
  //
  //   bool checkInternet = await ConnectionValidator().check();
  //   if (!checkInternet) {
  //     // Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
  //     return;
  //   }
  //   // Timer.periodic(Duration(seconds: 10), (timer) async {
  //   print("In Location method111");
  //   // if(isLogin) {
  //     CheckPermission.checkLocationPermissionOnly(context).then((value) async {
  //       if (value) {
  //         if (location == null) location = Location();
  //         _serviceEnabled = await location.serviceEnabled();
  //         if (!_serviceEnabled) {
  //           _serviceEnabled = await location.requestService();
  //           if (!_serviceEnabled) {
  //             return;
  //           }
  //         }
  //         _permissionGranted = await location.hasPermission();
  //
  //         if (location == null) location = Location();
  //         location.changeSettings(distanceFilter: 10, accuracy: LocationAccuracy.high);
  //
  //         location.onLocationChanged.listen((LocationData currentLocation) {
  //           // Fluttertoast.showToast(msg: "Location Update2");
  //           if (locationArray.length > 0) {
  //             int tempDriverId = int.parse(driverId);
  //             int tempRouteId = int.parse(routeId);
  //             prams = {
  //               "driverId": "$tempDriverId",
  //               "routeId": "$tempRouteId",
  //             };
  //             // if(!isCallTimer) {
  //             //   logger.i("isCallTimer");
  //             //   Timer.periodic(Duration(seconds: time), (timer) async {
  //             //     logger.i("Latitude1: ${currentLocation.latitude}");
  //             //     logger.i("Latitude1: ${currentLocation.longitude}");
  //             //     timerLocation = timer;
  //             //     time = 5;
  //             //     if (locationSocket.connected) {
  //             //       var prefs = await SharedPreferences.getInstance();
  //             //       isLogin =
  //             //       prefs.getBool(WebConstant.IS_LOGIN) != null ? prefs.getBool(
  //             //           WebConstant.IS_LOGIN) : false;
  //             //       logger.i("isLogin $isLogin");
  //             //       if (isLogin) {
  //             //         if (driverType == Constants.dadicatedDriver ||
  //             //             driverType == Constants.sharedDriver) {
  //             //           logger.i('connect1');
  //             //           Map<String, dynamic> library = {
  //             //             "driver_id": "$driverId",
  //             //             "pharmacy_id": "$pharmacyIdForSocket",
  //             //             "device_name": "android",
  //             //             "route_id": routeId != null && routeId.isNotEmpty
  //             //                 ? "$routeId"
  //             //                 : "",
  //             //             "latitude": "${currentLocation.latitude}",
  //             //             "longitude": "${currentLocation.longitude}",
  //             //           };
  //             //           updateLocation();
  //             //           logger.i(jsonEncode(library));
  //             //           // Fluttertoast.showToast(msg: "Update");
  //             //           locationSocket.emit(
  //             //               'sendLocationToServer', jsonEncode(library));
  //             //           time = 5;
  //             //         }
  //             //       }
  //             //     } else {
  //             //       time = 5;
  //             //     }
  //             //   });
  //             //   isCallTimer = true;
  //             // }
  //             if (isRunBG) {
  //               if (!inProgressSocket) {
  //                 inProgressSocket = false;
  //                 prams["latitude"] = "${currentLocation.latitude}";
  //                 prams["longitude"] = "${currentLocation.longitude}";
  //                 // print(lastLocationUpdated.isBefore(DateTime.now()));
  //                 if (lastLocationUpdated.isBefore(DateTime.now())) {
  //                   logger.i("testttttt123");
  //                   lastLocationUpdated = DateTime(
  //                       DateTime
  //                           .now()
  //                           .year,
  //                       DateTime
  //                           .now()
  //                           .month,
  //                       DateTime
  //                           .now()
  //                           .day,
  //                       DateTime
  //                           .now()
  //                           .hour,
  //                       DateTime
  //                           .now()
  //                           .minute,
  //                       DateTime
  //                           .now()
  //                           .second + 30);
  //                   if (routeId != "0" && isRouteStart)
  //                   saveSocketData(prams);
  //                 }
  //               }
  //             } else {
  //               if (lastLocationUpdated.isBefore(DateTime.now())) {
  //                 lastLocationUpdated = DateTime(
  //                     DateTime
  //                         .now()
  //                         .year,
  //                     DateTime
  //                         .now()
  //                         .month,
  //                     DateTime
  //                         .now()
  //                         .day,
  //                     DateTime
  //                         .now()
  //                         .hour,
  //                     DateTime
  //                         .now()
  //                         .minute,
  //                     DateTime
  //                         .now()
  //                         .second + 30);
  //                 // print(lastLocationUpdated);
  //                 prams["latitude"] = "${currentLocation.latitude}";
  //                 prams["longitude"] = "${currentLocation.longitude}";
  //                 // print("test $prams");
  //                 logger.i("testttttt1234");
  //                 if (routeId != "0" && isRouteStart)
  //                 saveSocketData(prams);
  //               }
  //               //channel.sink.add("$prams");
  //             }
  //           }
  //           locationArray.add(currentLocation);
  //           if (locationArray.length > 5) locationArray.removeAt(0);
  //         });
  //       }
  //     });
  //   // }
  //   // });
  //   //channel = IOWebSocketChannel.connect(Uri.parse("ws://beta1.repeatclick.com/api/ws"));
  // }
  updateLocation() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      // Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }
    // Timer.periodic(Duration(seconds: 5), (timer) async {
    // print("In Location method111");
    // logger.i("isLogin $isLogin");
    // if(isLogin) {
    // timerLocation = timer;
    if (mounted)
      CheckPermission.checkLocationPermissionOnly(context).then((value) async {
        if (value) {
          logger.i("log");
          if (location == null) location = Location();
          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              return;
            }
          }
          _permissionGranted = await location.hasPermission();

          if (location == null) location = Location();
          location.changeSettings(
              distanceFilter: 20, accuracy: LocationAccuracy.high);

          location.onLocationChanged.listen((
              LocationData currentLocation) async {
            // Fluttertoast.showToast(msg: "Location Update2");
            // logger.i("isLogin $isLogin");
            await SharedPreferences.getInstance().then((prefs) {
              isLogin =
              prefs.getBool(WebConstant.IS_LOGIN) != null ? prefs.getBool(
                  WebConstant.IS_LOGIN) : false;
            });
            if (isLogin) {
              if (locationArray.length > 0) {
                // if(!isCallTimer) {
                //   logger.i("isCallTimer");
                //   Timer.periodic(Duration(seconds: time), (timer) async {
                //     logger.i("Latitude1: ${currentLocation.latitude}");
                //     logger.i("Latitude1: ${currentLocation.longitude}");
                //     timerLocation = timer;
                //     time = 5;
                //     if (locationSocket.connected) {
                //       var prefs = await SharedPreferences.getInstance();
                //       isLogin =
                //       prefs.getBool(WebConstant.IS_LOGIN) != null ? prefs.getBool(
                //           WebConstant.IS_LOGIN) : false;
                //       logger.i("isLogin $isLogin");
                //       if (isLogin) {
                //         if (driverType == Constants.dadicatedDriver ||
                //             driverType == Constants.sharedDriver) {
                //           logger.i('connect1');
                //           Map<String, dynamic> library = {
                //             "driver_id": "$driverId",
                //             "pharmacy_id": "$pharmacyIdForSocket",
                //             "device_name": "android",
                //             "route_id": routeId != null && routeId.isNotEmpty
                //                 ? "$routeId"
                //                 : "",
                //             "latitude": "${currentLocation.latitude}",
                //             "longitude": "${currentLocation.longitude}",
                //           };
                //           updateLocation();
                //           logger.i(jsonEncode(library));
                //           // Fluttertoast.showToast(msg: "Update");
                //           locationSocket.emit(
                //               'sendLocationToServer', jsonEncode(library));
                //           time = 5;
                //         }
                //       }
                //     } else {
                //       time = 5;
                //     }
                //   });
                //   isCallTimer = true;
                // }
                // if (isRunBG) {
                // if (!inProgressSocket) {
                //   inProgressSocket = false;
                //   prams["latitude"] = "${currentLocation.latitude}";
                //   prams["longitude"] = "${currentLocation.longitude}";
                // print(lastLocationUpdated.isBefore(DateTime.now()));
                if (lastLocationUpdated.isBefore(DateTime.now())) {
                  lastLocationUpdated = DateTime(DateTime
                      .now()
                      .year, DateTime
                      .now()
                      .month, DateTime
                      .now()
                      .day,
                      DateTime
                          .now()
                          .hour, DateTime
                          .now()
                          .minute, DateTime
                          .now()
                          .second + 30);
                  if (locationSocket.connected) {
                    // if (isLogin) {
                    if (driverType == Constants.dadicatedDriver ||
                        driverType == Constants.sharedDriver) {
                      // logger.i('connect1');
                      library = {
                        "driver_id": "$driverId",
                        "pharmacy_id": "$pharmacyIdForSocket",
                        "device_name": "android",
                        "route_id": routeId != null && routeId.isNotEmpty
                            ? "$routeId"
                            : "",
                        "latitude": "${currentLocation.latitude}",
                        "longitude": "${currentLocation.longitude}",
                      };
                      // updateLocation();
                      logger.i(jsonEncode(library));
                      // Fluttertoast.showToast(msg: "Update");
                      locationSocket.emit(
                          'sendLocationToServer', jsonEncode(library));
                      time = 5;
                    }
                  }
                }
                // }
                // }
                // }
              }
              locationArray.add(currentLocation);
              if (locationArray.length > 5) locationArray.removeAt(0);
            }
          });
        }
      });
    // print("In Location method222");

    // }else{
    //   if(timerLocation != null){
    //     logger.i("isLogin1 $isLogin");
    //     timerLocation.cancel();
    //   }
    // }
    // });
    //channel = IOWebSocketChannel.connect(Uri.parse("ws://beta1.repeatclick.com/api/ws"));
  }

  _toRadians(double degree) {
    return degree * pi / 180;
  }

  getDistance(startLatitude, startLongitude, endLatitude, endLongitude) {
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a =
        pow(sin(dLat / 2), 2) +
            pow(sin(dLon / 2), 2) * cos(_toRadians(startLatitude)) *
                cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));

    // print("Distance between two points ${earthRadius * c}");
    return earthRadius * c; //distance in meters
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) {
      // if (routeId != "0" && isRouteStart) {
      //   isRunBG = false;
      logger.i("log10");
      updateLocation();
      // autoEndRoute();
      // }
    } else if (AppLifecycleState.paused == state) {
      // if (routeId != "0" && isRouteStart) {
      // channel.sink.close();
      // Timer.periodic(Duration(seconds: 2), (timer) {
      // logger.i("log50");
      // isRunBG = true;
      updateLocation();
      // });
      // }
    }

    switch (state) {
      case AppLifecycleState.resumed:
        checkLastTime(context);
        updateApi();
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
    // print("........................didChangeAppLifecycleState.............................$state..................");
  }

  Future<void> getOrderDetailsDB(DeliveryPojoModal delivery, bool isScan,
      bool isComplete) async {
    OrderModal orderModel = OrderModal();

    orderModel.related_orders = [];
    logger.i("reletedOrder: ${delivery.orderId}");
    MyDatabase().getDeliveryMatchedList(
        delivery.customerDetials.customerAddress.duration).then((value) async {
      if (value != null && value.isNotEmpty) {
        logger.i(value);
        await Future.forEach(value, (element) async {
          logger.i("element: $element");
          var deliveryDetails = await MyDatabase().getDeliveryDetilas(
              int.tryParse(element.order_id.toString()));
          logger.i(deliveryDetails);
          if (deliveryDetails.deliveryStatus == 4) {
            ReletedOrders reletedOrders = ReletedOrders();
            logger.i(element);

            var customerDetials = await MyDatabase().getCustomerDetilas(
                int.tryParse(element.order_id.toString()));
            var customerAddress = await MyDatabase().getCustomerAddress(
                int.tryParse(element.order_id.toString()));
            reletedOrders.orderId = deliveryDetails.orderId;
            reletedOrders.parcelName = customerDetials.surgeryName;
            reletedOrders.subsId = deliveryDetails.subsId;
            reletedOrders.rxCharge = deliveryDetails.rxCharge;
            reletedOrders.rxInvoice = deliveryDetails.rxInvoice;
            reletedOrders.delCharge = deliveryDetails.delCharge;
            reletedOrders.bagSize = deliveryDetails.bagSize;
            reletedOrders.isDelCharge = deliveryDetails.isDelCharge;
            reletedOrders.isPresCharge = deliveryDetails.isSubsCharge;
            reletedOrders.exemption = deliveryDetails.exemption;
            reletedOrders.pharmacyId = deliveryDetails.pharmacyId;
            reletedOrders.paymentStatus = deliveryDetails.paymentStatus;
            reletedOrders.pharmacyName = deliveryDetails.pharmacyName;
            reletedOrders.totalControlledDrugs =
                deliveryDetails.totalControlledDrugs;
            reletedOrders.totalStorageFridge =
                deliveryDetails.totalStorageFridge;
            reletedOrders.nursing_home_id = deliveryDetails.nursing_home_id;
            reletedOrders.userId = customerDetials.customerId;
            reletedOrders.mobileNo = customerDetials.mobile;
            reletedOrders.fullName = (customerDetials.title != null
                ? customerDetials.title + " "
                : "") +
                (customerDetials.firstName != null ? "${customerDetials
                    .firstName} " : "") +
                (customerDetials.middleName != null
                    ? customerDetials.middleName
                    : "") +
                (customerDetials.lastName != null ? " ${customerDetials
                    .lastName}" : "");
            reletedOrders.fullAddress = customerDetials.address;
            reletedOrders.isStorageFridge =
            deliveryDetails.isStorageFridge == "t"
                ? true
                : false; // need to add
            reletedOrders.deliveryNotes =
                deliveryDetails.deliveryNotes; // need to add
            reletedOrders.isSelected = false;
            reletedOrders.isCronCreated = deliveryDetails.isCronCreated;
            reletedOrders.alt_address = customerAddress.alt_address;
            reletedOrders.existing_delivery_notes =
                deliveryDetails.existingDeliveryNotes; // need to add
            reletedOrders.isControlledDrugs =
            deliveryDetails.isControlledDrugs == "t"
                ? true
                : false; // need to add
            reletedOrders.pmr_type = deliveryDetails.pmr_type;
            reletedOrders.pr_id = deliveryDetails.pr_id;
            orderModel.related_orders.add(reletedOrders);
          }
        });
        await MyDatabase().getExemptionsList().then((value) async {
          orderModel.exemptions = [];
          if (value != null && value.isNotEmpty) {
            await Future.forEach(value, (element) {
              ExemptionsList exemptions = ExemptionsList();
              exemptions.id = element.exemptionId;
              exemptions.serialId = element.serialId;
              exemptions.name = element.name;

              orderModel.exemptions.add(exemptions);
            });
            logger.i("Exemption : ${orderModel.exemptions.length}");
          }
        });
        orderModel.orderId = delivery.orderId;
        orderModel.pharmacyId = delivery.pharmacyId;
        orderModel.isDelCharge = delivery.isDelCharge;
        orderModel.rxCharge = delivery.rxCharge;
        orderModel.rxInvoice = delivery.rxInvoice;
        orderModel.delCharge = delivery.delCharge;
        orderModel.subsId = delivery.subsId;
        orderModel.totalControlledDrugs = delivery.totalControlledDrugs;
        orderModel.totalStorageFridge = delivery.totalStorageFridge;
        orderModel.nursing_home_id = delivery.nursing_home_id;
        orderModel.isPresCharge = delivery.isPresCharge;
        orderModel.related_order_count = orderModel.related_orders.length;
        orderModel.deliveryRemarks = ""; // no need to add
        orderModel.deliveryTo = ""; // no need to add
        orderModel.deliveryStatusDesc = delivery.status;
        orderModel.parcelName = delivery.parcelBoxName;
        orderModel.exemption = delivery.exemption;
        orderModel.paymentStatus = delivery.paymentStatus;
        orderModel.bagSize = delivery.bagSize;
        orderModel.routeId = delivery.routeId;
        orderModel.pr_id = delivery.pr_id;
        orderModel.customerId = delivery.customerDetials.customerId;
        orderModel.isControlledDrugs =
        delivery.isControlledDrugs == "t" ? true : false;
        orderModel.isStorageFridge =
        delivery.isStorageFridge == "t" ? true : false;
        orderModel.deliveryNote = delivery.deliveryNotes;
        orderModel.exitingNote = delivery.existingDeliveryNotes;
        orderModel.customer = Customer();
        orderModel.customer.alt_address =
            delivery.customerDetials.customerAddress.alt_address;
        orderModel.customer.mobile =
        delivery.customerDetials.customerAddress.postCode.contains("#") &&
            delivery.customerDetials.customerAddress.postCode
                .split("#")
                .length > 0
            ? delivery.customerDetials.customerAddress.postCode.split("#")[1]
            : "";
        orderModel.customer.fullAddress = delivery.customerDetials.address;
        orderModel.customer.fullName =
            (delivery.customerDetials.title != null ? delivery.customerDetials
                .title + " " : "") +
                (delivery.customerDetials.firstName != null ? delivery
                    .customerDetials.firstName + " " : "") +
                (delivery.customerDetials.middleName != null ? delivery
                    .customerDetials.middleName : "") +
                (delivery.customerDetials.lastName != null ? " " +
                    delivery.customerDetials.lastName : "");

        logger.i('ManuelDetailPage ${orderModel.delCharge}');
        showAleartOrderPoup(orderModel);
      }
    });
  }

  Future<void> getFailedOrderDetails(DeliveryPojoModal delivery) async {
    OrderModal orderModel = OrderModal();

    orderModel.related_orders = [];
    logger.i("reletedOrder: ${delivery.orderId}");
    ReletedOrders reletedOrders = ReletedOrders();

    reletedOrders.orderId = delivery.orderId;
    reletedOrders.parcelName = delivery.customerDetials.surgeryName;
    reletedOrders.subsId = delivery.subsId;
    reletedOrders.rxCharge = delivery.rxCharge;
    reletedOrders.rxInvoice = delivery.rxInvoice;
    reletedOrders.delCharge = delivery.delCharge;
    reletedOrders.bagSize = delivery.bagSize;
    reletedOrders.isDelCharge = delivery.isDelCharge;
    // reletedOrders.isPresCharge = delivery.isSubsCharge;
    reletedOrders.exemption = delivery.exemption;
    reletedOrders.pharmacyId = delivery.pharmacyId;
    reletedOrders.paymentStatus = delivery.paymentStatus;
    reletedOrders.pharmacyName = delivery.pharmacyName;
    reletedOrders.totalControlledDrugs = delivery.totalControlledDrugs;
    reletedOrders.totalStorageFridge = delivery.totalStorageFridge;
    reletedOrders.nursing_home_id = delivery.nursing_home_id;
    reletedOrders.userId = delivery.customerDetials.customerId;
    reletedOrders.mobileNo = delivery.customerDetials.mobile;
    reletedOrders.fullName =
        (delivery.customerDetials.title != null ? delivery.customerDetials
            .title + " " : "") +
            (delivery.customerDetials.firstName != null ? "${delivery
                .customerDetials.firstName} " : "") +
            (delivery.customerDetials.middleName != null ? delivery
                .customerDetials.middleName : "") +
            (delivery.customerDetials.lastName != null ? " ${delivery
                .customerDetials.lastName}" : "");
    reletedOrders.fullAddress = delivery.customerDetials.address;
    reletedOrders.isStorageFridge =
    delivery.isStorageFridge == "t" ? true : false; // need to add
    reletedOrders.deliveryNotes = delivery.deliveryNotes; // need to add
    reletedOrders.isSelected = false;
    reletedOrders.isCronCreated = delivery.isCronCreated;
    reletedOrders.alt_address =
        delivery.customerDetials.customerAddress.alt_address;
    reletedOrders.existing_delivery_notes =
        delivery.existingDeliveryNotes; // need to add
    reletedOrders.isControlledDrugs =
    delivery.isControlledDrugs == "t" ? true : false; // need to add
    reletedOrders.pmr_type = delivery.pmr_type;
    reletedOrders.pr_id = delivery.pr_id;
    orderModel.related_orders.add(reletedOrders);
    await MyDatabase().getExemptionsList().then((value) async {
      orderModel.exemptions = [];
      if (value != null && value.isNotEmpty) {
        await Future.forEach(value, (element) {
          ExemptionsList exemptions = ExemptionsList();
          exemptions.id = element.exemptionId;
          exemptions.serialId = element.serialId;
          exemptions.name = element.name;

          orderModel.exemptions.add(exemptions);
        });
        logger.i("Exemption : ${orderModel.exemptions.length}");
      }
    });
    orderModel.orderId = delivery.orderId;
    orderModel.pharmacyId = delivery.pharmacyId;
    orderModel.isDelCharge = delivery.isDelCharge;
    orderModel.rxCharge = delivery.rxCharge;
    orderModel.rxInvoice = delivery.rxInvoice;
    orderModel.delCharge = delivery.delCharge;
    orderModel.subsId = delivery.subsId;
    orderModel.totalControlledDrugs = delivery.totalControlledDrugs;
    orderModel.totalStorageFridge = delivery.totalStorageFridge;
    orderModel.nursing_home_id = delivery.nursing_home_id;
    orderModel.isPresCharge = delivery.isPresCharge;
    orderModel.related_order_count = orderModel.related_orders.length;
    orderModel.deliveryRemarks = ""; // no need to add
    orderModel.deliveryTo = ""; // no need to add
    orderModel.deliveryStatusDesc = delivery.status;
    orderModel.parcelName = delivery.parcelBoxName;
    orderModel.exemption = delivery.exemption;
    orderModel.paymentStatus = delivery.paymentStatus;
    orderModel.bagSize = delivery.bagSize;
    orderModel.routeId = delivery.routeId;
    orderModel.pr_id = delivery.pr_id;
    orderModel.customerId = delivery.customerDetials.customerId;
    orderModel.isControlledDrugs =
    delivery.isControlledDrugs == "t" ? true : false;
    orderModel.isStorageFridge = delivery.isStorageFridge == "t" ? true : false;
    orderModel.deliveryNote = delivery.deliveryNotes;
    orderModel.exitingNote = delivery.existingDeliveryNotes;
    orderModel.customer = Customer();
    orderModel.customer.alt_address =
        delivery.customerDetials.customerAddress.alt_address;
    orderModel.customer.mobile =
    delivery.customerDetials.customerAddress.postCode.contains("#") &&
        delivery.customerDetials.customerAddress.postCode
            .split("#")
            .length > 0
        ? delivery.customerDetials.customerAddress.postCode.split("#")[1]
        : "";
    orderModel.customer.fullAddress = delivery.customerDetials.address;
    orderModel.customer.fullName =
        (delivery.customerDetials.title != null ? delivery.customerDetials
            .title + " " : "") +
            (delivery.customerDetials.firstName != null ? delivery
                .customerDetials.firstName + " " : "") +
            (delivery.customerDetials.middleName != null ? delivery
                .customerDetials.middleName : "") +
            (delivery.customerDetials.lastName != null ? " " +
                delivery.customerDetials.lastName : "");

    logger.i('ManuelDetailPage ${orderModel.delCharge}');
    showAleartOrderPoup(orderModel);
  }

  Future<void> getOrderDetails(String orderId, bool isScan, bool isComplete,
      int orderIdMain) async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }

    if (!isProgressAvailable) {
      setState(() {
        isProgressAvailable = true;
      });
    }

    String url =
        "${WebConstant
        .SCAN_ORDER_BY_DRIVER}?OrderId=$orderId&driverId=$driverId&isScan=$isScan&routeId=$routeId&isComplete=$isComplete&orderIdMain=$orderIdMain";
    logger.i(url);
    logger.i("accessToken $accessToken");
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
        response) async {
      if (response != null && response.body != null &&
          response.body == "Unauthenticated") {
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
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null) {
          logger.i(response.body);
          OrderModal modal = orderModalFromJson(response.body);
          if ((modal.message == "") ||
              isComplete ||
              modal.deliveryStatusDesc == "Received" ||
              modal.deliveryStatusDesc == "Ready" ||
              modal.deliveryStatusDesc == "Requested" ||
              modal.deliveryStatusDesc == "PickedUp") {
            // modal.orderId = int.parse(orderId);
            if (modal.deliveryStatusDesc == "Completed") {
              Fluttertoast.showToast(msg: "This order already completed.");
            } else {
              await MyDatabase().getExemptionsList().then((value) async {
                modal.exemptions = [];
                if (value != null && value.isNotEmpty) {
                  await Future.forEach(value, (element) {
                    ExemptionsList exemptions = ExemptionsList();
                    exemptions.id = element.exemptionId;
                    exemptions.serialId = element.serialId;
                    exemptions.name = element.name;

                    modal.exemptions.add(exemptions);
                  });
                }
              });
              logger.i('ScanDetailPage ${modal.delCharge}');
              showAleartOrderPoup(modal);
            }
          } else if (modal.message != null) {
            Fluttertoast.showToast(msg: modal.message ?? "");
          } else {
            selectedType = "total";
          }
          // print("isExistDeliveryNote:${modal.isExistDeliveryNote}");
        }
      } catch (_, stackTrace) {
        // print(response);
        // print(response.body);
        SentryExemption.sentryExemption(e, stackTrace);
        Map<String, dynamic> body = jsonDecode(response.body) as Map<
            String,
            dynamic>;
        if (body["error"] == true) {
          Fluttertoast.showToast(msg: body["message"] ?? "");
        }
        // print(_);
        setState(() {
          isProgressAvailable = false;
        });
      }
    });
  }

  void showAlertDialog(String message) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return CustomDialogBox(
            title: "Alert...",
            btnDone: "Ok",
            descriptions: message,
          );
        });
  }

  void showConfirmMakeNextDialog(int orderId) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return WillPopScope(
            onWillPop: () async => false,
            child: CustomDialogBox(
              img: Image.asset("assets/delivery_truck.png"),
              title: "Alert...",
              onClicked: (value) {
                if (value) {
                  showAleartMakeNext(orderId);
                }
              },
              btnDone: "Yes",
              btnNo: "No",
              descriptions: "Pharmacy already make this route, do you want to re-route it.",
            ),
          );
        });
  }

  void showCompleteRescheduleDialog(String message) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return WillPopScope(
            onWillPop: () async => false,
            child: CustomDialogBox(
              img: Image.asset("assets/delivery_truck.png"),
              title: "Alert...",
              onClicked: onClickDialog,
              btnDone: "Ok",
              descriptions: message,
            ),
          );
        });
  }

  Future<void> confirmationPopupForStartRoute() async {
    if (nextPharmacyListDropDown == null) {
      getRoutes();
      return;
    }
    if (nextPharmacyListDropDown.pharmacyId == 0)
      showEndRouteOptions = true;
    else
      showEndRouteOptions = false;
    await SharedPreferences.getInstance().then((value) {
      value.setBool(WebConstant.IS_ROUTE_START, false);
      isAddressUpdated = value.getBool(WebConstant.IS_ADDRESS_UPDATED) ?? false;
    });
    var startLocationId = driverType == Constants.dadicatedDriver ? 1 : 2;
    var startGroupId = driverType == Constants.dadicatedDriver ? 1 : 2;
    var endId = 1;
    var endType = 1;
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, sateState1) {
            return Dialog(
              insetPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.padding),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: Constants.bottom),
                    // margin: EdgeInsets.only(top: Constants.avatarRadius),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Constants.padding),
                        boxShadow: [
                          BoxShadow(color: Colors.black,
                              offset: Offset(0, 10),
                              blurRadius: 10),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 15),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Constants.padding),
                                  topRight: Radius.circular(Constants.padding)),
                            ),
                            child: Center(
                                child: Text(
                                  "Are you sure, you want to start route?",
                                  style: TextStyle(fontSize: 16.0),
                                ))),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: Constants.padding,
                            right: Constants.padding,
                          ),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5.0),
                          //     border: Border.all(
                          //         width: 0.4, color: !isMessageShow ? Colors.blue : Colors.red)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Start Route from:",
                                style: TextStyle(fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(top: 5),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(5.0),
                              //       color: Colors.grey[100],
                              //       border: Border.all(
                              //           width: 0.4, color: Colors.grey[300])),
                              //   child: RadioListTile(
                              //     visualDensity: VisualDensity(
                              //         horizontal: -4, vertical: -4),
                              //     contentPadding: EdgeInsets.zero,
                              //     title: Text("Pharmacy"),
                              //     groupValue: 0,
                              //     value: 0,
                              //     activeColor: Colors.blue,
                              //     onChanged: (val) {},
                              //   ),
                              // ),
                              Column(
                                children: [
                                  if (driverType == Constants.dadicatedDriver)
                                    NumberList(
                                      index: 1,
                                      number: "Pharmacy",
                                    ),
                                  NumberList(
                                    index: 2,
                                    number: "Current Location",
                                  ),
                                ]
                                    .map((data) =>
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              5.0),
                                          color:
                                          startLocationId == data.index ? Colors
                                              .blue[300] : Colors.grey[100],
                                          border: Border.all(width: 0.4,
                                              color: Colors.grey[300])),
                                      child: RadioListTile(
                                        visualDensity: VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        contentPadding: EdgeInsets.zero,
                                        title: Text("${data.number}"),
                                        groupValue: startGroupId,
                                        value: data.index,
                                        activeColor: Colors.white,
                                        onChanged: (val) {
                                          sateState1(() {
                                            startLocationId = data.index;
                                            startGroupId = data.index;
                                          });
                                        },
                                      ),
                                    ))
                                    .toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  driverType == Constants.dadicatedDriver
                                      ? "End route at:"
                                      : "Next Pharmacy",
                                  style: TextStyle(fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              if (driverType == Constants.dadicatedDriver)
                                Column(
                                  children: [
                                    NumberList(
                                      index: 1,
                                      number: "Pharmacy",
                                    ),
                                    NumberList(
                                      index: 2,
                                      number: "Home Location",
                                    ),
                                  ]
                                      .map((data) =>
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                5.0),
                                            color: endId == data.index ? Colors
                                                .blue[300] : Colors.grey[100],
                                            border: Border.all(width: 0.4,
                                                color: Colors.grey[300])),
                                        child: RadioListTile(
                                          visualDensity: VisualDensity(
                                              horizontal: -4, vertical: -4),
                                          contentPadding: EdgeInsets.zero,
                                          title: Text("${data.number}"),
                                          groupValue: endType,
                                          value: data.index,
                                          activeColor: Colors.white,
                                          onChanged: (val) {
                                            sateState1(() {
                                              endId = data.index;
                                              endType = data.index;
                                            });
                                          },
                                        ),
                                      ))
                                      .toList(),
                                ),
                              if (!isAddressUpdated &&
                                  driverType == Constants.dadicatedDriver)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 0.0),
                                  child: Text(
                                    "No address in profile ",
                                    style: TextStyle(
                                        fontSize: 10.0, color: Colors.red),
                                  ),
                                ),
                              if (driverType == Constants.sharedDriver)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[700]),
                                        borderRadius: BorderRadius.circular(
                                            50.0)),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<PharmacyList>(
                                            isExpanded: true,
                                            value: nextPharmacyListDropDown,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: TextStyle(
                                                color: Colors.black),
                                            underline: Container(
                                              height: 2,
                                              color: Colors.black,
                                            ),
                                            onChanged: (PharmacyList newValue) {
                                              sateState1(() {
                                                nextPharmacyListDropDown =
                                                    newValue;
                                                if (newValue.pharmacyId == 0) {
                                                  showEndRouteOptions = true;
                                                } else {
                                                  showEndRouteOptions = false;
                                                }
                                              });
                                            },
                                            items: nextPharmacyList
                                                .map<DropdownMenuItem<
                                                PharmacyList>>((
                                                PharmacyList value) {
                                              return DropdownMenuItem<
                                                  PharmacyList>(
                                                value: value != null
                                                    ? value
                                                    : null,
                                                child: Text(
                                                  value.pharmacyName,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  ),
                                ),
                              if (driverType == Constants.sharedDriver &&
                                  showEndRouteOptions)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0.0, top: 10.0),
                                  child: Text(
                                    "End route at:",
                                    style: TextStyle(fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              if (driverType == Constants.sharedDriver &&
                                  showEndRouteOptions)
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[700]),
                                        borderRadius: BorderRadius.circular(
                                            50.0)),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<PharmacyList>(
                                            isExpanded: true,
                                            value: endRoutePharmacyListDropDown,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: TextStyle(
                                                color: Colors.black),
                                            underline: Container(
                                              height: 2,
                                              color: Colors.black,
                                            ),
                                            onChanged: (PharmacyList newValue) {
                                              sateState1(() {
                                                endRoutePharmacyListDropDown =
                                                    newValue;
                                              });
                                            },
                                            items: endRoutePharmacyList
                                                .map<DropdownMenuItem<
                                                PharmacyList>>((
                                                PharmacyList value) {
                                              return DropdownMenuItem<
                                                  PharmacyList>(
                                                value: value != null
                                                    ? value
                                                    : null,
                                                child: Text(
                                                  value.pharmacyName,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  ),
                                )
                            ],
                          ),
                        ),
                        isMessageShow
                            ? Padding(
                          padding: EdgeInsets.only(
                            left: Constants.padding,
                            right: Constants.padding,
                          ),
                          child: Text(
                            "Select at least one end route option",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Constants.padding,
                            right: Constants.padding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: 35.0,
                                  width: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5.0)),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style:
                                      TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      endId = 0;
                                      isMessageShow = false;
                                      Navigator.of(context).pop(true);
                                      setState(() {});
                                    },
                                  )),
                              SizedBox(
                                  height: 35.0,
                                  width: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5.0)),
                                    ),
                                    child: Text(
                                      isAddressUpdated || endId == 1
                                          ? (nextPharmacyListDropDown
                                          .pharmacyId > 0)
                                          ? 'Continue'
                                          : isAddressUpdated
                                          ? "Continue"
                                          : endRoutePharmacyListDropDown
                                          .pharmacyId > 0
                                          ? "Continue"
                                          : "Update Address"
                                          : "Update Address",
                                      textAlign: TextAlign.center,
                                      style:
                                      TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      if (driverType ==
                                          Constants.dadicatedDriver) {
                                        if (endId > 0) {
                                          Navigator.of(context).pop(true);
                                          if (isAddressUpdated || endId == 1) {
                                            startRoute(
                                                startGroupId, endType, 0);
                                            SharedPreferences.getInstance()
                                                .then((value) {
                                              value.setInt(
                                                  WebConstant.END_ROUTE_AT,
                                                  endType);
                                              value.setInt(
                                                  WebConstant.START_ROUTE_FROM,
                                                  startGroupId);
                                            });
                                            endId = 0;
                                            isMessageShow = false;
                                          } else {
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateAddress()));
                                          }
                                        } else {
                                          isMessageShow = true;
                                          setState(() {});
                                        }
                                      } else {
                                        Navigator.of(context).pop(true);
                                        if (nextPharmacyListDropDown
                                            .pharmacyId > 0) {
                                          endType = 3;
                                          startRoute(startGroupId, endType,
                                              nextPharmacyListDropDown
                                                  .pharmacyId); //
                                        } else {
                                          if (isAddressUpdated ||
                                              endRoutePharmacyListDropDown
                                                  .pharmacyId > 0) {
                                            if (endRoutePharmacyListDropDown
                                                .pharmacyId > 0) {
                                              endType = 4;
                                            } else {
                                              endType = 2;
                                            }
                                            startRoute(startGroupId, endType,
                                                endRoutePharmacyListDropDown
                                                    .pharmacyId);
                                          } else {
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateAddress()));
                                          }
                                        }
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   left: Constants.padding,
                  //   right: Constants.padding,
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.white,
                  //     radius: Constants.avatarRadius,
                  //     child: ClipRRect(
                  //         child: Image.asset('assets/location_icon.png')
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> reschedulePopup() async {
    recheduleOrderId = "";
    deliveryList.forEach((element) {
      if (element.isSelected)
        recheduleOrderId = recheduleOrderId.isNotEmpty
            ? recheduleOrderId + ",${element.orderId}"
            : recheduleOrderId + "${element.orderId}";
    });

    var testtg = await getDriverList(null, selectedRouteRescheduleDropDown);
    logger.i(testtg);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (dialogContext, sateState1) {
            return Dialog(
              insetPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.padding),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: Constants.bottom),
                    // margin: EdgeInsets.only(top: Constants.avatarRadius),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Constants.padding),
                        boxShadow: [
                          BoxShadow(color: Colors.black,
                              offset: Offset(0, 10),
                              blurRadius: 10),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 15),
                            width: MediaQuery
                                .of(dialogContext)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Constants.padding),
                                  topRight: Radius.circular(Constants.padding)),
                            ),
                            child: Center(
                                child: Text(
                                  "Reschedule Delivery",
                                  style: TextStyle(fontSize: 16.0),
                                ))),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: Constants.padding,
                            right: Constants.padding,
                          ),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5.0),
                          //     border: Border.all(
                          //         width: 0.4, color: !isMessageShow ? Colors.blue : Colors.red)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Would you like to reschedule ${recheduleOrderId
                                      .split(",")
                                      .length} deliveries for $selectedDate. Are you okay to proceed ?",
                                  style: TextStyle(fontSize: 14.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Select Reschedule Date",
                                  style: TextStyle(fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    openCalender(sateState1);
                                  },
                                  child: Container(
                                    width: MediaQuery
                                        .of(dialogContext)
                                        .size
                                        .width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[700]),
                                        borderRadius: BorderRadius.circular(
                                            50.0)),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 25.0,
                                            top: 10,
                                            bottom: 10),
                                        child: Text(
                                          selectedDate,
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Select Route",
                                  style: TextStyle(fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey[700]),
                                      borderRadius: BorderRadius.circular(
                                          50.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<RouteList>(
                                          isExpanded: true,
                                          value: selectedRouteRescheduleDropDown,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.black,
                                          ),
                                          onChanged: (RouteList newValue) {
                                            sateState1(() {
                                              logger.i("Testing");
                                              selectedRouteRescheduleDropDown =
                                                  newValue;
                                              getDriverList(sateState1,
                                                  selectedRouteRescheduleDropDown);
                                            });
                                          },
                                          items: routeListAll.map<
                                              DropdownMenuItem<RouteList>>((
                                              RouteList value) {
                                            return DropdownMenuItem<RouteList>(
                                              value: value != null
                                                  ? value
                                                  : null,
                                              child: Text(
                                                value.routeName,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Select Driver",
                                  style: TextStyle(fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey[700]),
                                      borderRadius: BorderRadius.circular(
                                          50.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<DriverModel>(
                                          isExpanded: true,
                                          value: selectedDriver,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.black,
                                          ),
                                          onChanged: (DriverModel newValue) {
                                            sateState1(() {
                                              selectedDriver = newValue;
                                            });
                                          },
                                          items: driverList.map<
                                              DropdownMenuItem<DriverModel>>((
                                              DriverModel value) {
                                            return DropdownMenuItem<
                                                DriverModel>(
                                              value: value != null
                                                  ? value
                                                  : null,
                                              child: Text(
                                                value.firstName,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Constants.padding,
                            right: Constants.padding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: 35.0,
                                  width: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5.0)),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style:
                                      TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      isMessageShow = false;
                                      Navigator.of(dialogContext).pop(true);
                                      setState(() {});
                                    },
                                  )),
                              SizedBox(
                                  height: 35.0,
                                  width: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5.0)),
                                    ),
                                    child: Text(
                                      "Reschedule Now",
                                      textAlign: TextAlign.center,
                                      style:
                                      TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      //onclickofsubmit
                                      if (selectedDriver == null) {
                                        Fluttertoast.showToast(
                                            msg: "Select Driver");
                                      } else
                                      if (selectedRouteRescheduleDropDown ==
                                          null) {
                                        Fluttertoast.showToast(
                                            msg: "Select Route");
                                      }
                                      if (selectedDriver != null &&
                                          selectedRouteRescheduleDropDown !=
                                              null) {
                                        bulkRescheduleApi(dialogContext);
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   left: Constants.padding,
                  //   right: Constants.padding,
                  //   child: CircleAvatar(
                  //     backgroundColor: Colors.white,
                  //     radius: Constants.avatarRadius,
                  //     child: ClipRRect(
                  //         child: Image.asset('assets/location_icon.png')
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> startRoute(int startRouteId, int endRouteId,
      int pharmacyID) async {
    // endRouteId == 1 end route at pharmacy, endRouteId = 2 end route at home
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }

    if (routeId != "0" && isRouteStart) {
      // updateLocation();
    }

    if (locationArray == null || locationArray.length <= 0) {
      return;
    }

    if (!routeOptimizeDialogShowing && mounted) {
      showLoadingDialog();
      routeOptimizeDialogShowing = true;
    }

    setState(() {
      isProgressAvailable = true;
    });

    logger.i(startRouteId);
    logger.i(endRouteId);
    String url =
        "${WebConstant
        .START_ROUTE_BY_DRIVER}?routeId=$routeId&startRouteId=$startRouteId&endRouteId=$endRouteId&latitude=${locationArray
        .last.latitude}&longitude=${locationArray.last
        .longitude}&pharmacyID=$pharmacyID&vehicle_id=${selectedVehicle.id ??
        0}";
    logger.i(url);
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
        response) async {
      if (routeOptimizeDialogShowing) {
        Navigator.pop(dialogContext);
        routeOptimizeDialogShowing = false;
      }
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
        if (response != null) {
          logger.i(response.body.toString());
          if (response.body.toString() == "OutForDelivery") {
            // Fluttertoast.showToast(msg: response.body.toString());
            // updateLocation();
            SharedPreferences.getInstance().then((value) {
              value.setBool(WebConstant.IS_ROUTE_START, true);
              setState(() {
                isRouteStart = true;
                page = 0;
                lastPageLength = -1;
                selectedType = WebConstant.Status_out_for_delivery;
                orderListType = 4;
                selectWithTypeCount(WebConstant.Status_out_for_delivery);
                // fetchDeliveryList(0);
              });
            });
          }
          if (response.body.startsWith("{\"error\":true")) {
            Map<dynamic, dynamic> map = jsonDecode(response.body);
            if (map != null && map["message"] != null) {
              showAlertDialog(map["message"]);
            }
          } else {
            Fluttertoast.showToast(msg: response.body.toString());
          }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        Fluttertoast.showToast(msg: _.toString());
      }
    }).catchError((onError, stackTrace) {
      SentryExemption.sentryExemption(onError, stackTrace);
      setState(() {
        isProgressAvailable = false;
      });
    });
  }

  Future<void> showVehiclePopup() async {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return StatefulBuilder(builder: (context, setStat) {
            return CustomDialogBox(
              img: Image.asset("assets/delivery_truck.png"),
              // descriptions: "Choose Vehicle",
              button2: TextButton(
                onPressed: () {
                  confirmationPopupForStartRoute();
                  if (selectedVehicle == null || selectedVehicle.id == 0) {
                    Fluttertoast.showToast(msg: "Please Select Vehicle");
                  } else {
                    Navigator.pop(context);
                    if (locationArray != null) {
                      confirmationPopupForStartRoute();
                    } else {
                      getLocationData();
                    }
                  }
                },
                child: Text("Okay",
                    style: TextStyle(fontSize: 18.0, color: Colors.black)),
              ),
              button1: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (locationArray != null) {
                    confirmationPopupForStartRoute();
                  } else {
                    getLocationData();
                  }
                },
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
              cameraIcon: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vehicleList != null && vehicleList.isNotEmpty)
                    Text(
                      "Choose Vehicle",
                      style: TextStyle(color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
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
                              items: vehicleList.map<
                                  DropdownMenuItem<VehicleData>>((
                                  VehicleData value) {
                                return DropdownMenuItem<VehicleData>(
                                  value: value != null ? value : null,
                                  child: Container(
                                    height: 45.0,
                                    color: Colors.primaries[Random().nextInt(
                                        Colors.primaries.length)].shade100,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        "${value.name != null &&
                                            value.name.isNotEmpty
                                            ? value.name
                                            : ""}${value.modal != null &&
                                            value.modal.isNotEmpty ? " - " +
                                            value.modal : ""}${value.regNo !=
                                            null && value.regNo.isNotEmpty
                                            ? " - " + value.regNo
                                            : ""}${value.color != null &&
                                            value.color.isNotEmpty ? " - " +
                                            value.color : ""}"
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
                    height: 5.0,
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<void> getVehicleInfo() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      return;
    }
    vehicleList.clear();
    await CustomLoading().showLoadingDialog(context, true);
    await _apiCallFram.getDataRequestAPI(
        WebConstant.GET_VEHICLE_INFO, accessToken, context).then((
        response) async {
      await CustomLoading().showLoadingDialog(context, false);
      // progressDialog.hide();
      logger.i(WebConstant.GET_VEHICLE_INFO);
      logger.i(accessToken);
      logger.i(response.body);
      // await CustomLoading().showLoadingDialog(context, true);
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
            GetVehicleInfoApiResponse model = GetVehicleInfoApiResponse
                .fromJson(json.decode(response.body));
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

  Future<void> endRoute(isAutoEndRoute) async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }
    setState(() {
      isProgressAvailable = true;
    });
    isProgress = true;
    String url = "${WebConstant.END_ROUTE_BY_DRIVER}?routeId=$routeId";
    logger.i(url);
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
        response) async {
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
        if (response != null) {
          logger.i(response.body);
          if (response.body.toString() == "true") {
            // if (_locationData != null) {
            var deliveryListData = await MyDatabase()
                .getAllOutForDeliverysOnly();
            deliveryTime = null;
            SharedPreferences.getInstance().then((value) {
              if (deliveryListData == null || deliveryListData.isEmpty) {
                value.remove(WebConstant.DELIVERY_TIME);
                if (stopWatchTimer != null) {
                  logger.i("stopwatch disposed");
                  showIncreaseTime = false;
                  stopWatchTimer.dispose();
                  stopWatchTimer = null;
                }
              }
              if (isAutoEndRoute) autoEndRoutePopUp();
              isProgress = false;
              value.setBool(WebConstant.IS_ROUTE_START, false);
              bool value1 = value.getBool(WebConstant.IS_ROUTE_START);
              // print(value1);
              setState(() {
                isRouteStart = false;
                page = 0;
                lastPageLength = -1;
                selectedType = WebConstant.Status_picked_up;
                if (!isProgressAvailable) {
                  setState(() {
                    isProgressAvailable = true;
                  });
                }
                fetchDeliveryList(0);
              });
            });
            // channel.sink.close();
            // } else {
            //   getLocationData();
            // }
          } else {
            isProgress = false;
            Fluttertoast.showToast(
                msg: "Complete all orders of out for delivery");
          }
        }
      } catch (_, stackTrace) {
        isProgress = false;
        SentryExemption.sentryExemption(_, stackTrace);
      }
    }).catchError((onError, stackTrace) {
      SentryExemption.sentryExemption(onError, stackTrace);
      setState(() {
        isProgressAvailable = false;
      });
    });
  }

  Future<void> makeNextApi(int orderId, int optimizeStatus) async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }

    if (routeId != "0" && isRouteStart) {
      // updateLocation();
    }

    if (locationArray == null || locationArray.length <= 0) {
      return;
    }

    if (optimizeStatus == 1) {
      if (!routeOptimizeDialogShowing && mounted) {
        showLoadingDialog();
        routeOptimizeDialogShowing = true;
      }
    }

    setState(() {
      isProgressAvailable = true;
    });

    http: //staging.pharmdel.com/api/Delivery/v11/MakeNextOrderSort?orderid=3110&routeId=23&optimizeStatus=2&latitude=26.8753354&longitude=75.7648351

    String url =
        "${WebConstant
        .MAKE_NEXT_BY_DRIVER}?orderid=$orderId&routeId=$routeId&optimizeStatus=$optimizeStatus&latitude=${locationArray
        .last.latitude}&longitude=${locationArray.last.longitude}";
    logger.i(url);
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
        response) async {
      if (routeOptimizeDialogShowing) {
        Navigator.pop(dialogContext);
        routeOptimizeDialogShowing = false;
      }
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
        if (response != null) {
          logger.i(response.body);
          final Map parsed = json.decode(response.body);
          logger.i(parsed["message"]);
          if (optimizeStatus == 1) {
            if (parsed["isOptimize"] == false) {
              showAleartReoptimise(parsed["message"]);
              getDeliveryListFromDB();
            } else {
              Fluttertoast.showToast(msg: parsed["message"]);
              orderListType = 4;
              selectWithTypeCount(WebConstant.Status_out_for_delivery);
            }
          } else {
            Fluttertoast.showToast(msg: parsed["message"]);
            orderListType = 4;
            selectWithTypeCount(WebConstant.Status_out_for_delivery);
            // getDeliveryListFromDB();
          }

          logger.i(response.body.toString());

          // if (response.body.toString() == "OutForDelivery") {
          //   updateLocation();
          //   SharedPreferences.getInstance().then((value) {
          //     value.setBool(WebConstant.IS_ROUTE_START, true);
          //     setState(() {
          //       isRouteStart = true;
          //       page = 0;
          //       lastPageLength = -1;
          //       selectedType = WebConstant.Status_out_for_delivery;
          //       orderListType = 4;
          //       selectWithTypeCount(WebConstant.Status_out_for_delivery);
          //       // fetchDeliveryList(0);
          //     });
          //   });
          // }
        } else
          getDeliveryListFromDB();
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        setState(() {
          isProgressAvailable = false;
        });
        getDeliveryListFromDB();
      }
    }).catchError((onError) {
      setState(() {
        isProgressAvailable = false;
      });
      getDeliveryListFromDB();
    });
  }

  Future<void> checkCustomerWithOrder(String orderId, int customerId,
      String submitOrderId) async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }
    setState(() {
      isProgressAvailable = true;
    });
    String url = "${WebConstant
        .SCAN_ORDER_BY_DRIVER_TO_COMPLETE}?orderId=$orderId&customerId=$customerId&isScan=true";
    logger.i(url);
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
        response) async {
      logger.i(response.body);
      if (response != null && response.body != null &&
          response.body == "Unauthenticated") {
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
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null) {
          if (response.body.toString() == "Success") {
            getOrderDetails(orderId, true, true, 0);
          } else {
            Fluttertoast.showToast(msg: response.body.toString());
          }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
      }
    }).catchError((onError) {
      setState(() {
        isProgressAvailable = false;
      });
    });
  }

  Widget topCounter(Color bgColor,
      String label,
      String counter,) {
    return Container(
      margin: EdgeInsets.only(left: 1, right: 1, top: 8.0, bottom: 5),
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: bgColor,
          boxShadow: [
            BoxShadow(spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 4),
                color: Colors.grey[300])
          ]),
      child: Column(
        children: <Widget>[
          Text(
            "$label",
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w300, color: Colors.white),
          ),
          Text(
            "${counter ?? 0}",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void selectWithTypeCount(String status) async {
    isDelivery = false;
    if (routeId.isEmpty) {
      ToastUtils.showCustomToast(context, "Select route and try again!");
    } else {
      setState(() {
        page = 0;
        lastPageLength = -1;
        selectedType = status;

        if (!isProgressAvailable) {
          setState(() {
            isProgressAvailable = true;
          });
        }

        if (status == WebConstant.Status_out_for_delivery) {
          selectedType = WebConstant.Status_out_for_delivery;
          getParcelList(0);
        } else {
          fetchDeliveryList(0);
        }
      });
    }
  }

  Future<bool> showLoadingDialog() async {
    logger.i("testest121212121");
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false,
        // user must tap button for close dialog!
        builder: (BuildContext context) {
          dialogContext = context;
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              insetPadding: EdgeInsets.all(20),
              backgroundColor: Colors.transparent,
              child: Container(
                height: 260,
                padding: EdgeInsets.only(
                    left: 10, top: 25, right: 10, bottom: 20),
                margin: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black,
                          offset: Offset(0, 2),
                          blurRadius: 10),
                    ]),
                child: Column(
                  children: [
                    new Image(
                      image: new AssetImage("assets/route_loading.gif"),
                      width: 150,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Optimizing Route",
                      style: TextStyle(fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    return Future.value(true);
  }

  void saveSocketData(Map<String, dynamic> prams1) {
    logger.i("testttttt12111 $driverId");
    logger.i(prams);
    // logger.i(WebConstant.SAVE_DATA_WITH_SOCKET);
    // Fluttertoast.showToast(msg: "Update1 - $driverId");
    _apiCallFram.postDataAPI(
        WebConstant.SAVE_DATA_WITH_SOCKET, accessToken, prams, null).then((
        response) {
      inProgressSocket = false;
      try {
        // Fluttertoast.showToast(msg: "Update");
        // if (response != null) {
        //   // print("${response.body}");
        //    Map<String, Object> data = json.decode(response.body);
        //   Fluttertoast.showToast(msg: data["message"]);
        // }
      } catch (e, stackTrace) {
        // print("Exception : $e");
        SentryExemption.sentryExemption(e, stackTrace);
      }
    }, onError: (error, stackTrace) {
      inProgressSocket = false;
    });
  }

  void initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        logger.i("log3");
        updateApi();
      }
    });

    // print("onMessage: test");
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: test");
    //     // _showItemDialog(message);
    //     // checkSms(message);
    //   },
    //   //onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: ");
    //     //checkSms(message);
    //     // _navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: ");
    //     //checkSms(message);
    //     // _navigateToItemDetail(message);
    //   },
    // );
    //
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(
    //         sound: true, badge: true, alert: true, provisional: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    // _firebaseMessaging.getToken().then((String token) {
    //   print("fcm token $token");
    //   assert(token != null);
    // });
  }

  void checkLocationPermission() {
    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
      if (value != null && value) {
        if (location == null) location = Location();
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }
        _locationData = await location.getLocation();
        _permissionGranted = await location.hasPermission();
        getLocationData();
        if (routeId != "0" && isRouteStart) {
          // updateLocation();
        }
      }
    });
  }

  @override
  void permissionCheck(bool value) {
    // TODO: implement permissionCheck
    if (value != null && value) {
      if (routeId != "0" && isRouteStart) {
        // updateLocation();
      }
    } else {
      CheckPermission.checkLocationPermissionOnly(context).then((value) {
        if (!value) {
          if (Platform.isAndroid) {
            Fluttertoast.showToast(
                msg: "Location permission required. You not access without location permission",
                toastLength: Toast.LENGTH_LONG);
            SystemNavigator.pop();
          } else {}
        }
      });
    }
  }

  void showAleartMakeNext(int orderId) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return CustomDialogBox(
            closeIcon: Positioned(
              top: 55.0,
              right: 10.0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context1);
                },
                child: Icon(Icons.clear),
              ),
            ),
            img: Image.asset("assets/delivery_truck.png"),
            title: "Reoptimise remaining stops",
            btnDone: "Skip",
            btnNo: "Reoptimise stops",
            descriptions: "We recommend reoptimising the remaining stops to make sure you're still on the best route.",
            onClicked: (value) {
              logger.i(value);
              if (value == true) {
                makeNextApi(orderId, 2);
              } else {
                makeNextApi(orderId, 1);
              }
              // makeNextApi(orderId, optimizeStatus);
            },
          );
        });
  }

  void showAleartRouteStarted() {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/delivery_truck.png"),
            title: "Alert...",
            btnDone: "Ok",
            descriptions: "Driver is already out for delivery. You can not change status.",
          );
        });
  }

  void showAleartReoptimise(String msg) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/delivery_truck.png"),
            title: "Alert...",
            btnDone: "Ok",
            descriptions: msg,
          );
        });
  }

  Future<void> showAleartOrderPoup(OrderModal deliveryDetails) async {
    try {
      if (deliveryDetails != null &&
          deliveryDetails.related_orders != null &&
          deliveryDetails.related_orders.isNotEmpty &&
          deliveryDetails.related_orders.length > 1) {
        if (deliveryDetails.related_order_count > 0) {
          showDialog<ConfirmAction>(
              context: context,
              barrierDismissible: false,
              // user must tap button for close dialog!
              builder: (BuildContext context1) {
                return CustomDialogBox(
                  img: Image.asset("assets/delivery_truck.png"),
                  title: "Multiple Delivery...",
                  btnDone: "Yes",
                  btnNo: "No",
                  descriptions:
                  "${deliveryDetails
                      .related_order_count} more delivery for this address. Would you like to deliver?",
                  onClicked: (value) {
                    showOrderList(deliveryDetails, value);
                  },
                );
              });
        } else
          showOrderList(deliveryDetails, true);
      } else {
        if (deliveryDetails.deliveryStatusDesc == "PickedUp") {
          await MyDatabase().getExemptionsList().then((value) async {
            deliveryDetails.exemptions = [];
            if (value != null && value.isNotEmpty) {
              await Future.forEach(value, (element) {
                ExemptionsList exemptions = ExemptionsList();
                exemptions.id = element.exemptionId;
                exemptions.serialId = element.serialId;
                exemptions.name = element.name;

                deliveryDetails.exemptions.add(exemptions);
              });
            }
          });

          deliveryDetails.related_orders.clear();
          ReletedOrders reletedOrders = ReletedOrders();
          reletedOrders.orderId = deliveryDetails.orderId;
          reletedOrders.pharmacyId = deliveryDetails.pharmacyId;
          reletedOrders.rxCharge = deliveryDetails.rxCharge;
          reletedOrders.rxInvoice = deliveryDetails.rxInvoice;
          reletedOrders.delCharge = deliveryDetails.delCharge;
          reletedOrders.subsId = deliveryDetails.subsId;
          reletedOrders.isDelCharge = deliveryDetails.isDelCharge;
          reletedOrders.isPresCharge = deliveryDetails.isPresCharge;
          reletedOrders.exemption = deliveryDetails.exemption;
          reletedOrders.paymentStatus = deliveryDetails.paymentStatus;
          reletedOrders.bagSize = deliveryDetails.bagSize;
          reletedOrders.parcelName = deliveryDetails.customer.surgeryName;
          reletedOrders.pharmacyName = "";
          reletedOrders.userId = deliveryDetails.customerId;
          reletedOrders.fullName = (deliveryDetails.title != null
              ? deliveryDetails.title + " "
              : "") +
              (deliveryDetails.firstName != null ? "${deliveryDetails
                  .firstName} " : "") +
              (deliveryDetails.middleName != null
                  ? deliveryDetails.middleName
                  : "") +
              (deliveryDetails.lastName != null
                  ? " ${deliveryDetails.lastName}"
                  : "");
          reletedOrders.fullAddress = deliveryDetails.address.alt_address;
          reletedOrders.isStorageFridge = deliveryDetails.isStorageFridge;
          reletedOrders.deliveryNotes = ""; // need to add
          reletedOrders.isSelected = false;
          reletedOrders.isCronCreated = "f";
          reletedOrders.alt_address = deliveryDetails.address.alt_address;
          reletedOrders.existing_delivery_notes =
              deliveryDetails.exitingNote; // need to add
          reletedOrders.isControlledDrugs = deliveryDetails.isControlledDrugs;
          reletedOrders.pmr_type = deliveryDetails.pmr_type;
          reletedOrders.pr_id = deliveryDetails.pr_id;
          deliveryDetails.related_orders.add(reletedOrders);
        }
        if (deliveryDetails != null &&
            deliveryDetails.related_orders != null &&
            deliveryDetails.related_orders.isNotEmpty &&
            deliveryDetails.related_orders.length == 1) logger.i('Delivery222');
        redirectToDetailsPage(
            deliveryDetails, deliveryDetails.related_orders[0].orderId,
            deliveryDetails.related_orders[0].rxInvoice,
            deliveryDetails.delCharge, deliveryDetails.subsId);
      }
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      logger.i(e);
    }
  }

  void endRoutePopup() {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/delivery_truck.png"),
            title: "Alert...",
            btnDone: "End Route",
            btnNo: "No",
            onClicked: onClieck,
            descriptions: "Are you sure,you want to end Route?",
          );
        });
  }

  void autoEndRoutePopUp() {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/delivery_truck.png"),
            title: "Alert...",
            btnDone: "Okay",
            descriptions: "Your route has been ended",
          );
        });
  }

  void reArrangingRoutePopup() {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => Future.value(true),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              insetPadding: EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black,
                          offset: Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image(
                      image: new AssetImage("assets/processing.gif"),
                    ),
                    Text(
                      "Processing...",
                      style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.red),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Pharmacy optimizing the route, please wait it might take some time",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 45,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 60 / 100,
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(0, 3))
                            ],
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Center(child: Text(
                            WebConstant.Check_Again, style: TextStyle(
                            color: Colors.white))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void noInternetPopUp(String msg) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset("assets/sad.png"),
            title: "Alert...",
            btnDone: "Okay",
            btnNo: "",
            descriptions: msg,
          );
        });
  }

  void onClieck(bool value) {
    if (value) endRoute(false);
  }

  void showOrderList(OrderModal modal, bool otherDelivery) {
    print("otherDelivery......$otherDelivery");
    List<ReletedOrders> modelList = [];
    preChargeController = [];
    deliveryChargeController = [];
    if (!otherDelivery) {
      modal.related_orders.forEach((element) {
        if (modal.customerId == element.userId) {
          modelList.add(element);
        }
      });
    } else {
      modelList = modal.related_orders;
    }
    modal.related_orders = modelList;
    logger.i(modelList.length);
    if (modelList.length == 1) {
      logger.i("Test1");
      logger.i('Delivery333');
      redirectToDetailsPage(
          modal, modal.orderId, modal.rxInvoice, modal.delCharge, modal.subsId);
      logger.i("Test2");
    } else {
      try {
        for (int i = 0; i < modelList.length; i++) {
          logger.i(' modeList length: ${modelList.length}');
          logger.i(' modeList index: $i');
          logger.i(
              ' perCharge controller index: ${preChargeController.length}');
          preChargeController.add(TextEditingController());
          deliveryChargeController.add(TextEditingController());

          double rxCharge = double.tryParse(modelList[i].rxCharge ?? "0");
          logger.i('RXCharge: ${rxCharge}');
          logger.i('RXCharge: ${modelList[i].rxInvoice}');

          logger.i('RXInvoics number ${modelList[i].rxInvoice}');

          double calculatedValue =
              rxCharge *
                  (modelList[i].rxInvoice != null && modelList[i].rxInvoice > 0
                      ? modelList[i].rxInvoice
                      : 0.0);
          logger.i(calculatedValue);

          deliveryChargeController[i].text = modelList[i].delCharge;
          preChargeController[i].text =
          '${calculatedValue.toStringAsFixed(2) ?? ''}'; //"9.18";

          double totalAmount = double.parse(modelList[i].delCharge ?? "0") +
              calculatedValue;
          //   modelList[i].totalAmount = totalAmount.toString();

        }
        bool allSelected = false;
        logger.i("THIS IS MODAL " + modal.deliveryNote);
        showDialog(
            context: context,
            barrierDismissible: false, // user must tap button for close dialog!
            builder: (context) {
              isCheckCdOnComplete = false;
              return SafeArea(
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Scaffold(
                          body: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 5,
                                  padding: EdgeInsets.all(10.00),
                                  color: materialAppThemeColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        "Orders List",
                                        style: TextStyle(color: appBarTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(
                                            Icons.clear_rounded,
                                            color: appBarTextColor,
                                          ))
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: allSelected,
                                        onChanged: (value) {
                                          allSelected = value;
                                          for (int i = 0; i <
                                              modelList.length; i++) {
                                            checkboxIndex = 0;
                                            modelList[i].isSelected = value;
                                          }
                                          setState(() {});
                                        }),
                                    Flexible(
                                      child: Text(
                                        "Select All",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  color: Colors.white,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height - 250,
                                  child: ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(),
                                      itemCount: modelList.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          margin: EdgeInsets.only(
                                            bottom: modelList.length - 1 ==
                                                index ? 70.0 : 8.0,
                                          ),
                                          child: Stack(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .start,
                                                            children: <Widget>[
                                                              /*Text("Name", style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14
                                                      ),),
                                                      SizedBox(width: 5, height: 0,),*/
                                                              SizedBox(
                                                                height: 24,
                                                                width: 24,
                                                                child: Checkbox(
                                                                    value: modelList[index]
                                                                        .isSelected,
                                                                    onChanged: (
                                                                        value) {
                                                                      logger.i(
                                                                          value);
                                                                      modelList[index]
                                                                          .isSelected =
                                                                          value;

                                                                      checkboxIndex =
                                                                          index;

                                                                      allSelected =
                                                                      true;
                                                                      for (int i = 0; i <
                                                                          modelList
                                                                              .length; i++) {
                                                                        if (modelList[i]
                                                                            .isSelected ==
                                                                            false) {
                                                                          allSelected =
                                                                          false;
                                                                        }
                                                                        setState(() {});
                                                                      }
                                                                    }),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  "${modelList[index]
                                                                      .fullName ??
                                                                      ""}",
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight
                                                                          .w700),
                                                                ),
                                                              ),
                                                              if (modelList[index]
                                                                  .nursing_home_id ==
                                                                  null ||
                                                                  modelList[index]
                                                                      .nursing_home_id ==
                                                                      0)
                                                                if (modelList[index]
                                                                    .pmr_type !=
                                                                    null &&
                                                                    (modelList[index]
                                                                        .pmr_type ==
                                                                        "titan" ||
                                                                        modelList[index]
                                                                            .pmr_type ==
                                                                            "nursing_box") &&
                                                                    modelList[index]
                                                                        .pr_id !=
                                                                        null &&
                                                                    modelList[index]
                                                                        .pr_id
                                                                        .isNotEmpty)
                                                                  Text(
                                                                    '(P/N : ${modelList[index]
                                                                        .pr_id ??
                                                                        ""}) ',
                                                                    style: TextStyle(
                                                                        color: CustomColors
                                                                            .pnColor),
                                                                  ),
                                                              if (modelList[index]
                                                                  .isCronCreated ==
                                                                  "t")
                                                                Image.asset(
                                                                    "assets/automatic_icon.png",
                                                                    height: 14,
                                                                    width: 14),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Image.asset(
                                                                  "assets/home_icon.png",
                                                                  height: 18,
                                                                  width: 18,
                                                                  color: CustomColors
                                                                      .yetToStartColor),
                                                              SizedBox(
                                                                width: 5,
                                                                height: 0,
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  "${modelList[index]
                                                                      .fullAddress ??
                                                                      modelList[index]
                                                                          .fullAddress ??
                                                                      ""}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight
                                                                          .w300),
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                                height: 0,
                                                              ),
                                                              // if (modelList[index].c.customerAddress.alt_address ==
                                                              //     "t")
                                                              //   Image.asset(
                                                              //     "assets/alt-add.png",
                                                              //     height: 18,
                                                              //     width: 18,
                                                              //   ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          modelList[index]
                                                              .deliveryNotes !=
                                                              null &&
                                                              modelList[index]
                                                                  .deliveryNotes !=
                                                                  ""
                                                              ? Row(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                'Delivery Note:   ',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: CustomColors
                                                                        .yetToStartColor),
                                                              ),
                                                              Flexible(
                                                                  child: Text(
                                                                      modelList[index]
                                                                          .deliveryNotes ??
                                                                          "")),
                                                            ],
                                                          )
                                                              : SizedBox(),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                modelList[index]
                                                                    .isControlledDrugs !=
                                                                    null &&
                                                                    modelList[index]
                                                                        .isControlledDrugs !=
                                                                        false
                                                                    ? Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        5.0),
                                                                    color: CustomColors
                                                                        .drugColor,
                                                                    // border: Border.all(color: Colors.blue)
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 5.0,
                                                                        right: 5.0,
                                                                        top: 2.0,
                                                                        bottom: 2.0),
                                                                    child: Text(
                                                                      "C.D.",
                                                                      style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: Colors
                                                                              .white),
                                                                    ),
                                                                  ),
                                                                )
                                                                    : Container(),
                                                                if (modelList[index]
                                                                    .isControlledDrugs !=
                                                                    null &&
                                                                    modelList[index]
                                                                        .isControlledDrugs !=
                                                                        false)
                                                                  SizedBox(
                                                                    width: 10.0,
                                                                  ),
                                                                modelList[index]
                                                                    .isStorageFridge !=
                                                                    null &&
                                                                    modelList[index]
                                                                        .isStorageFridge !=
                                                                        false
                                                                    ? Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        5.0),
                                                                    color: CustomColors
                                                                        .fridgeColor,
                                                                    // border: Border.all(color: Colors.blue)
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 5.0,
                                                                        right: 5.0,
                                                                        top: 2.0,
                                                                        bottom: 2.0),
                                                                    child: Text(
                                                                      "Fridge",
                                                                      style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: Colors
                                                                              .white),
                                                                    ),
                                                                  ),
                                                                )
                                                                    : Container(),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                if (modelList[index]
                                                                    .pharmacyName !=
                                                                    null &&
                                                                    modelList[index]
                                                                        .pharmacyName !=
                                                                        "" &&
                                                                    driverType ==
                                                                        Constants
                                                                            .sharedDriver)
                                                                  Flexible(
                                                                    flex: 5,
                                                                    child: Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
                                                                                    5)),
                                                                            color: Colors
                                                                                .orange,
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                  spreadRadius: 1,
                                                                                  blurRadius: 10,
                                                                                  offset: Offset(
                                                                                      0,
                                                                                      4),
                                                                                  color: Colors
                                                                                      .grey[300])
                                                                            ]),
                                                                        padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                            left: 10,
                                                                            right: 10,
                                                                            bottom: 2),
                                                                        child: Text(
                                                                          modelList[index]
                                                                              .pharmacyName ??
                                                                              "",
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white),
                                                                        )),
                                                                  ),
                                                                if (modelList !=
                                                                    null &&
                                                                    modelList
                                                                        .isNotEmpty &&
                                                                    modelList[index]
                                                                        .parcelName !=
                                                                        null &&
                                                                    modelList[index]
                                                                        .parcelName !=
                                                                        "")
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 10.0,
                                                                        bottom: 5.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              border: Border
                                                                                  .all(
                                                                                  color: Colors
                                                                                      .red),
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  5.0)),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets
                                                                                .only(
                                                                                left: 3.0,
                                                                                right: 3.0,
                                                                                top: 2.0,
                                                                                bottom: 2.0),
                                                                            child: Text(
                                                                              "${modelList[index]
                                                                                  .parcelName}",
                                                                              style: TextStyle(
                                                                                color: CustomColors
                                                                                    .pickedUp,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Row(
                                                            children: [
                                                              if (deliveryChargeController[index]
                                                                  .text !=
                                                                  null &&
                                                                  deliveryChargeController[index]
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  deliveryChargeController[index]
                                                                      .text !=
                                                                      '0.0' &&
                                                                  deliveryChargeController[index]
                                                                      .text !=
                                                                      '0')
                                                                Flexible(
                                                                  flex: 1,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 4.0,
                                                                        right: 4.0,
                                                                        bottom: 4.0),
                                                                    child: Container(
                                                                      height: 40,
                                                                      child: new TextField(
                                                                        controller: deliveryChargeController[index],
                                                                        textInputAction: TextInputAction
                                                                            .next,
                                                                        readOnly: true,
                                                                        keyboardType: TextInputType
                                                                            .number,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .blue),
                                                                        autofocus: false,
                                                                        inputFormatters: <
                                                                            TextInputFormatter>[
                                                                          FilteringTextInputFormatter
                                                                              .allow(
                                                                              RegExp(
                                                                                  r'(^\d*\.?\d{0,2})'))
                                                                        ],
                                                                        onChanged: (
                                                                            val) {
                                                                          modelList[index]
                                                                              .totalAmount =
                                                                              calculateAmount(
                                                                                  setState,
                                                                                  index);
                                                                        },
                                                                        decoration: new InputDecoration(
                                                                          labelText: "Delivery Charge",
                                                                          fillColor: Colors
                                                                              .white,
                                                                          labelStyle:
                                                                          TextStyle(
                                                                              color: Colors
                                                                                  .blue,
                                                                              fontSize: 14),
                                                                          filled: true,
                                                                          contentPadding:
                                                                          EdgeInsets
                                                                              .only(
                                                                              left: 15.0,
                                                                              right: 15.0),
                                                                          border: new OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                50.0),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .blue),
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                50.0),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .blue),
                                                                          ),
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                50.0),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .blue),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if (preChargeController[index]
                                                                  .text !=
                                                                  null &&
                                                                  preChargeController[index]
                                                                      .text
                                                                      .isNotEmpty &&
                                                                  preChargeController[index]
                                                                      .text !=
                                                                      '0.00')
                                                                Flexible(
                                                                  flex: 1,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left: 4.0,
                                                                        right: 4.0,
                                                                        bottom: 4.0),
                                                                    child: Container(
                                                                      height: 40,
                                                                      child: new TextField(
                                                                        controller: preChargeController[index],
                                                                        readOnly: true,
                                                                        textInputAction: TextInputAction
                                                                            .next,
                                                                        keyboardType: TextInputType
                                                                            .number,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .green,
                                                                            fontSize: 14),
                                                                        autofocus: false,
                                                                        inputFormatters: <
                                                                            TextInputFormatter>[
                                                                          FilteringTextInputFormatter
                                                                              .allow(
                                                                              RegExp(
                                                                                  r'(^\d*\.?\d{0,2})'))
                                                                        ],
                                                                        onChanged: (
                                                                            v) {
                                                                          modelList[index]
                                                                              .totalAmount =
                                                                              calculateAmount(
                                                                                setState,
                                                                                index,
                                                                              );
                                                                        },
                                                                        decoration: new InputDecoration(
                                                                          labelText: "Rx Charge",
                                                                          labelStyle: TextStyle(
                                                                              color: Colors
                                                                                  .green),
                                                                          fillColor: Colors
                                                                              .white,
                                                                          filled: true,
                                                                          contentPadding:
                                                                          EdgeInsets
                                                                              .only(
                                                                              left: 15.0,
                                                                              right: 15.0),
                                                                          border: new OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                50.0),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .green),
                                                                          ),
                                                                          focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                50.0),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .green),
                                                                          ),
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                50.0),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .green),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              SizedBox(
                                                                width: 10.0,
                                                              ),
                                                              // Column(
                                                              //   crossAxisAlignment: CrossAxisAlignment.start,
                                                              //   children: [
                                                              //     Text("Amount",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500),),
                                                              //     Text("£ ${modelList[index].totalAmount}",style: TextStyle(fontSize: 15.0,),)
                                                              //   ],
                                                              // ),
                                                            ],
                                                          ),
                                                          // SizedBox(
                                                          //   height: 5.0,
                                                          // ),
                                                          //
                                                          // Row(
                                                          //   children: [
                                                          //     if(modelList[index].paymentStatus != null && modelList[index].paymentStatus.isNotEmpty && modelList[index].paymentStatus != "unPaid")
                                                          //       Container(
                                                          //         height: 30,
                                                          //         padding: EdgeInsets.only(right: 10, left: 10),
                                                          //         decoration: BoxDecoration(
                                                          //           borderRadius: BorderRadius.circular(50.0),
                                                          //           color: Colors.orange,
                                                          //         ),
                                                          //         child: Row(
                                                          //           children: [
                                                          //             new Text(
                                                          //               "${modelList[index].paymentStatus ?? ""}",
                                                          //               style: TextStyle(color: Colors.white),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     SizedBox(
                                                          //       width: 5.0,
                                                          //     ),
                                                          //       Row(
                                                          //         children: [
                                                          //           if(modelList[index].exemption != null && modelList[index].exemption.isNotEmpty)
                                                          //           Container(
                                                          //             height: 30,
                                                          //             padding: EdgeInsets.only(right: 10, left: 10),
                                                          //             decoration: BoxDecoration(
                                                          //               borderRadius: BorderRadius.circular(50.0),
                                                          //               color: Colors.green,
                                                          //             ),
                                                          //             child: Row(
                                                          //               children: [
                                                          //                 new Text(
                                                          //                   "Exempt: ${modelList[index].exemption ?? ""}",
                                                          //                   style: TextStyle(color: Colors.white),
                                                          //                 ),
                                                          //               ],
                                                          //             ),
                                                          //           ),
                                                          //           SizedBox(
                                                          //             width: 5.0,
                                                          //           ),
                                                          //           if(modelList[index].bagSize != null && modelList[index].bagSize.isNotEmpty)
                                                          //             Align(
                                                          //               alignment: Alignment.centerLeft,
                                                          //               child: Container(
                                                          //                 height: 30,
                                                          //                 width: 100,
                                                          //                 padding: EdgeInsets.only(right: 5,left: 5),
                                                          //                 decoration: BoxDecoration(
                                                          //                   borderRadius: BorderRadius.circular(50.0),
                                                          //                   color: Colors.green,
                                                          //                 ),
                                                          //                 child: Row(
                                                          //                   children: [
                                                          //                     new Text(
                                                          //                       "Bag Size : ${modelList[index].bagSize}",
                                                          //                       style: TextStyle(color: Colors.white),
                                                          //                     ),
                                                          //                   ],
                                                          //                 ),
                                                          //               ),
                                                          //             ),
                                                          //         ],
                                                          //       ),
                                                          //   ],
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                5.0)),
                                        elevation: 2.0),
                                    onPressed: () {
                                      dynamic totalSelectedRxCharge = 0;
                                      dynamic deliveryCharge = 0;
                                      int subsId = 0;
                                      modelList.forEach((element) {
                                        if (element.isSelected == true) {
                                          deliveryCharge =
                                              element.delCharge ?? 0;
                                          logger.i(
                                              'Print RXCharge Value: ${element
                                                  .rxInvoice}');
                                          totalSelectedRxCharge = int.tryParse(
                                              totalSelectedRxCharge
                                                  .toString() ?? "0") +
                                              int.tryParse(
                                                  element.rxInvoice != null
                                                      ? element.rxInvoice
                                                      .toString()
                                                      : "0");
                                          subsId = element.subsId;
                                          // if(element.isControlledDrugs){
                                          //   checkIsCd = true;
                                          // }else{
                                          //
                                          // }

                                        }
                                      });

                                      logger.i(
                                          'Print Total RXCharge Value: ${totalSelectedRxCharge}');

                                      int count =
                                          modelList
                                              .where((elements) =>
                                          elements.isSelected == true)
                                              .toList()
                                              .length;
                                      if (count > 0) {
                                        isCheckCdOnComplete = modelList.any(
                                                (element) =>
                                            element.isControlledDrugs == true &&
                                                element.isSelected == true);
                                        isCheckFridgeOnComplete = modelList.any(
                                                (element) =>
                                            element.isStorageFridge == true &&
                                                element.isSelected == true);
                                        isCheckDeliveryNote = modelList
                                            .any((element) =>
                                        element.deliveryNotes != '' &&
                                            element.isSelected == true);

//puran sir new conditions
                                        if (isCheckCdOnComplete) {
                                          modal.isControlledDrugs = true;
                                        } else {
                                          modal.isControlledDrugs = false;
                                        }
                                        if (isCheckFridgeOnComplete) {
                                          modal.isStorageFridge = true;
                                        } else {
                                          modal.isStorageFridge = false;
                                        }
                                        if (isCheckDeliveryNote) {
                                          modal.deliveryNote = true;
                                        } else {
                                          modal.deliveryNote = false;
                                        }
                                        logger.w(
                                            "Is check delivery note is :: $isCheckDeliveryNote :: and delivery note is :: ${modal
                                                .deliveryNote.toString()}");
                                        Navigator.of(context).pop();
                                        logger.i('Delivery111');
                                        redirectToDetailsPage(
                                            modal,
                                            modelList[checkboxIndex].orderId,
                                            totalSelectedRxCharge,
                                            deliveryCharge,
                                            subsId); //modelList[checkboxIndex].rxInvoice);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Select minimum 1 order");
                                      }
                                    },
                                    child: new Text(
                                      "Complete",
                                      style: TextStyle(fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              );
            });
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
      }
    }
  }

  void redirectToDetailsPage(OrderModal modal, orderId, rxInvoice,
      deliveryCharge, subsId) {
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DriverDeliveryDetails(
                      orderModel: modal,
                      outForDelivery: outdeliveryList,
                      routeId: routeId,
                      orderId: orderId,
                      rxInvoice: rxInvoice,
                      delCharge: deliveryCharge,
                      subsId: subsId))).then((value) {
        if (value == true) {
          //if (isScan){
          if (isRouteStart) {
            orderListType = 4;
            // Comment for start route 11
            // selectWithTypeCount(WebConstant.Status_out_for_delivery);
            getDeliveryListFromDB();
          } else
            setState(() {
              page = 0;
              lastPageLength = -1;
              orderListType = 8;
              selectedType = WebConstant.Status_picked_up;
              selectWithTypeCount(WebConstant.Status_picked_up);
            });
          //}
        } else if (isRouteStart) {
          orderListType = 4;
          // Comment for start route 11
          // selectWithTypeCount(WebConstant.Status_out_for_delivery);
          getDeliveryListFromDB();
        } else {
          setState(() {
            page = 0;
            lastPageLength = -1;
            selectedType = WebConstant.Status_total;
            selectWithTypeCount(WebConstant.Status_total);
          });
        }
      });
    } catch (_, stackTrace) {
      SentryExemption.sentryExemption(_, stackTrace);
      logger.i(_);
    }
  }

  Future<List<DeliveryPojoModal>> getDeliveryListFromDB() {
    outdeliveryList.clear();
    getToken();

    MyDatabase().getAllOutForDeliverysOnly().then((value) async {
      if (value != null && value.isNotEmpty) {
        if (driverId != value[0].userId) {
          await clearDliveryTable();
          orderListType = 4;
          // Comment for start route 11
          selectWithTypeCount(WebConstant.Status_out_for_delivery);
        } else {
          await Future.forEach(value, (element) async {
            logger.i("status: ${element.deliveryStatus}");
            DeliveryPojoModal delivery = DeliveryPojoModal();
            logger.i(element.orderId);
            delivery.orderId = element.orderId;
            delivery.rxCharge = element.rxCharge;
            delivery.totalStorageFridge = element.totalStorageFridge;
            delivery.totalControlledDrugs = element.totalControlledDrugs;
            delivery.nursing_home_id = element.nursing_home_id;
            delivery.rxInvoice = element.rxInvoice;
            delivery.subsId = element.subsId;
            delivery.delCharge = element.delCharge;
            delivery.isPresCharge = element.isSubsCharge;
            delivery.isDelCharge = element.isDelCharge;
            delivery.orderId = element.orderId;
            delivery.sortBy = element.sortBy;
            delivery.pharmacyId = element.pharmacyId;
            delivery.bagSize = element.bagSize;
            delivery.paymentStatus = element.paymentStatus;
            delivery.exemption = element.exemption;
            delivery.routeId = int.tryParse(element.routeId.toString());
            delivery.serviceName = element.serviceName;
            delivery.isStorageFridge = element.isStorageFridge;
            delivery.isControlledDrugs = element.isControlledDrugs;
            delivery.deliveryNotes = element.deliveryNotes;
            delivery.existingDeliveryNotes = element.existingDeliveryNotes;
            delivery.isCronCreated = element.isCronCreated;
            delivery.deliveryStatus =
                int.tryParse(element.deliveryStatus.toString());
            delivery.pharmacyName = element.pharmacyName;
            delivery.status = element.status;
            delivery.pmr_type = element.pmr_type;
            delivery.pr_id = element.pr_id;
            if (delivery.isControlledDrugs != null &&
                delivery.isControlledDrugs == "t")
              delivery.isCD = true;
            else
              delivery.isCD = false;
            if (delivery.isStorageFridge != null &&
                delivery.isStorageFridge == "t")
              delivery.isFridge = true;
            else
              delivery.isFridge = false;
            CustomerDetials customerDetials = CustomerDetials();

            var element1 = await MyDatabase().getCustomerDetilas(
                element.orderId);
            if (element1 != null) {
              delivery.customerDetials = customerDetials;
              delivery.customerDetials.firstName = element1.firstName;
              delivery.customerDetials.service_name = element1.service_name;
              delivery.parcelBoxName = element1.surgeryName;
              delivery.customerDetials.address = element1.address;
              delivery.customerDetials.title = element1.title;
              delivery.customerDetials.lastName = element1.lastName;
              delivery.customerDetials.middleName = element1.middleName;
              delivery.customerDetials.customerId = element1.customerId;
            }
            CustomerAddress customerAddress = CustomerAddress();
            var value = await MyDatabase().getCustomerAddress(element.orderId);
            if (value != null) {
              delivery.customerDetials.customerAddress = customerAddress;
              delivery.customerDetials.customerAddress.duration =
                  value.duration;
              delivery.customerDetials.customerAddress.longitude =
                  value.longitude;
              delivery.customerDetials.customerAddress.latitude =
                  value.latitude;
              delivery.customerDetials.customerAddress.postCode =
                  value.postCode;
              delivery.customerDetials.customerAddress.address2 =
                  value.address2;
              delivery.customerDetials.customerAddress.address1 =
                  value.address1;
              delivery.customerDetials.customerAddress.alt_address =
                  value.alt_address;
            }
            outdeliveryList.add(delivery);
          });
          isNextPharmacyAvailable =
              outdeliveryList.indexWhere((element) => element.orderId == 0);
          setState(() {});
          logger.i("Delivery List Total = ${outdeliveryList.length}");
        }
      } else {
        orderListType = 4;
        // Comment for start route 11
        selectWithTypeCount(WebConstant.Status_out_for_delivery);
        logger.i("No delivery are available");
      }
      await SharedPreferences.getInstance().then((value) {
        logger.i("deliveryTime $deliveryTime");
        if (deliveryTime == null)
          deliveryTime = value.getInt(WebConstant.DELIVERY_TIME);
        if (stopWatchTimer == null) {
          stopWatchTimer = StopWatchTimer(
            mode: StopWatchMode.countDown,
            onEnded: () {
              setState(() {});
            },
            presetMillisecond: StopWatchTimer?.getMilliSecFromSecond(
                deliveryTime), // millisecond => minute.
          );
          stopWatchTimer.secondTime.listen((value) {
            SharedPreferences.getInstance().then((value1) {
              value1.setInt(WebConstant.DELIVERY_TIME, value);
            });
            if (value <= 0) {
              showIncreaseTime = true;
              stopWatchTimer = StopWatchTimer(
                mode: StopWatchMode.countUp,
                presetMillisecond: StopWatchTimer.getMilliSecFromSecond(
                    0), // millisecond => minute.
              );
              stopWatchTimer.onStartTimer();
            }
          });
          stopWatchTimer.onStartTimer();
        }
      });
    });
    return Future.value(outdeliveryList);
  }

  Future<int> clearDliveryTable() async {
    await MyDatabase().delecteDeliveryList();
    await MyDatabase().delecteCustomerList();
    await MyDatabase().delecteAddressList();
    return Future.value(1);
  }

  Future<void> dialogDissmissTimer(BuildContext dialogContext) async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      timer1 = timer;
      logger.i('Dashboard Background Service');
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      if (completeAllList == null || completeAllList.isEmpty) {
        timer1.cancel();
        if (isDialogShowing) Navigator.pop(dialogContext);
        if (outdeliveryList.length == 1) {
          if (outdeliveryList[0].orderId == 0) endRoute(true);
        }

        isDialogShowing = false;
      }
    });
  }

  void getCheckSelected() {
    var data = deliveryList.where((element) => element.isSelected);
    if (data != null && data.isNotEmpty)
      isShowRechedule = data.first.isSelected;
    else
      isShowRechedule = false;

    setState(() {});
  }

  void openCalender(StateSetter sateState1) {
    DateTime date = DateTime.now();

    showDatePicker(
        context: context,
        initialDate: DateTime(date.year, date.month, date.day),
        firstDate: DateTime(date.year, date.month, date.day),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: Colors.orangeAccent),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        }).then((pickedDate) {
      if (pickedDate == null) return;
      sateState1(() {
        selectedDate = formatter.format(pickedDate);
        selectedDateTimeStamp = pickedDate.millisecondsSinceEpoch.toString();
      });
    });
  }

  void onClickReschduleDialog(bool value) {
    if (value) {
      // bulkRescheduleApi();
    }
  }

  Future<void> bulkRescheduleApi(BuildContext dialogContext) async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }
    // if(!ProgressDialog(context).isShowing())
    //   ProgressDialog(context).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);

    logger.i(WebConstant.GET_ROUTE_URL + "?pharmacyId=${0}");
    _apiCallFram
        .getDataRequestAPI(
        WebConstant.BULK_RESCHEDULE +
            "?orderId=$recheduleOrderId&rescheduleDate=$selectedDate&driverId=${selectedDriver
                .driverId}&routeId=${selectedRouteRescheduleDropDown.routeId}",
        accessToken,
        context)
        .then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
          // ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
          // await CustomLoading().showLoadingDialog(context, true);
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
        if (response != null) {
          Map<dynamic, dynamic> data = jsonDecode(response.body);
          if (data != null && data["error"] == false) {
            logger.i(response.body);
            selectedDate =
                formatter.format(DateTime(DateTime
                    .now()
                    .year, DateTime
                    .now()
                    .month, DateTime
                    .now()
                    .day + 1));
            Navigator.pop(dialogContext);
            showCompleteRescheduleDialog(data["message"].toString() ?? "");
          } else {
            if (data["message"] != null && data["message"] != "")
              Fluttertoast.showToast(msg: data["message"].toString());
          }

          // print("routeList_" + model.routeList.length.toString());

        }
      } catch (_Ex, stackTrace) {
        logger.i(_Ex);
        SentryExemption.sentryExemption(_Ex, stackTrace);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
      setState(() {
        // isProgressAvailable = false;
      });
    });
  }

  void versionCode1() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      logger.i(version);
      logger.i(buildNumber);
      if (Platform.isAndroid) {
        versionCode = version;
      } else {
        versionCode = WebConstant.iOS_APP_VERSION;
      }
    });
  }

  void onClickDialog(bool value) {
    orderListType = 6;
    selectWithTypeCount(WebConstant.Status_failed);
    if (value) {
      selectAllDelivery = false;
      isShowRechedule = false;
      deliveryList.forEach((element) {
        if (element.isSelected == true) element.isSelected = false;
      });
      setState(() {});
    }
  }

  Future<bool> getDriverList(StateSetter sateState1,
      RouteList selectedRouteRescheduleDropDown) async {
    logger.i("testttt");
    // if (!progressDialog.isShowing()) progressDialog.show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    logger.i("testttt1");
    String parms = "?routeId=${selectedRouteRescheduleDropDown.routeId ?? ""}";
    await _apiCallFram
        .getDataRequestAPI(
        "${WebConstant.GetPHARMACYDriverListByRoute}$parms", accessToken,
        context)
        .then((response) async {
      // print(response);
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      driverList.clear();
      // ProgressDialog(context, isDismissible: false).show();
      DriverModel driverModel = new DriverModel();
      driverModel.driverId = 0;
      driverModel.firstName = "Select Driver";
      driverList.add(driverModel);
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
          showToast("Authentication Failed. Login again");
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
          return true;
        }
        if (response != null) {
          logger.i(response.body);
          driverList.clear();
          driverList.addAll(driverModelFromJson(response.body));
          if (driverList.isNotEmpty && driverList.length > 0) {
            selectedDriver = driverList[0];
          }
          if (sateState1 != null) {
            sateState1(() {});
          }
          return true;
        } else {
          return false;
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        showToast(WebConstant.ERRORMESSAGE);
        return Future.value(true);
      }
    });
  }

  void showToast(String s) {
    Fluttertoast.showToast(msg: s.toString());
  }

  Future<void> initSocketFetch() async {
    // getParcelList
    await streamSocket.repoenSocketOutForDelivery();
    streamSocket.getResponseOutForDeliveyr.asBroadcastStream().listen((
        event) async {
      var value = await SharedPreferences.getInstance();
      String driverId = value.getString(WebConstant.USER_ID);
      String routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
      bool isRouteStart = value.getBool(WebConstant.IS_ROUTE_START) ?? false;
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      var token = await MyDatabase().getToken();
      if (event != null) {
        Map valueMap = json.decode(event);
        //removed by me dk because keep showing in run
        // logger.i(valueMap);
        if (valueMap["driver_id"] == driverId &&
            valueMap["device_name"] == "admin") {
          if (valueMap["state"] == "reorder_check" && isRouteStart) {
            if (!valueMap["sorting_started"] && completeAllList.isEmpty) {
              // Future.delayed(Duration(seconds: 4), (){
              getParcelList(0);
              // });
            }
          }
        }
      }
    });
    // streamSocket.getResponseOutForDeliveyr.listen((event) async {
    //
    // });
  }

  Future<int> clearExemptionList() async {
    await MyDatabase().deleteExemptionList();
    return Future.value(1);
  }

  Future<void> getToken() async {
    var token = await MyDatabase().getToken();
    if (token == null || token.isEmpty) {
      TokenCompanion tokenssss = TokenCompanion.insert(token: accessToken);
      await MyDatabase().deleteToken();
      await MyDatabase().insertToken(tokenssss);
    }
  }

  Future<void> checkOfflineDeliveryAvailable1(
      DeliveryPojoModal delivery) async {
    var completeAllList = await MyDatabase().getAllOrderCompleteData();
    if (completeAllList != null && completeAllList.isNotEmpty) {
      BuildContext dialogContext;
      isDialogShowing = true;
      await showDialog<ConfirmAction>(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            dialogContext = context;
            dialogDissmissTimer(dialogContext);
            return CustomDialogBox(
              img: Image.asset("assets/delivery_truck.png"),
              title: "Alert...",
              btnDone: "Okay",
              btnNo: "",
              onClicked: onClick,
              descriptions: Constants.uploading_msg,
            );
          });
    } else {
      if (delivery.orderId > 0) {
        if (delivery.sortBy != null && delivery.sortBy.isNotEmpty &&
            delivery.sortBy == "pharmacy")
          showConfirmMakeNextDialog(delivery.orderId);
        else
          showAleartMakeNext(delivery.orderId);
      } else {
        endRoutePopup();
      }
    }
  }

  String calculateAmount(StateSetter setState, int index) {
    String totalAmount = "0.00";
    var deliveryCharge = double.tryParse(
        deliveryChargeController[index].text.toString().trim());
    var preAmount = double.tryParse(
        preChargeController[index].text.toString().trim());
    if (deliveryCharge != null && preAmount != null) {
      totalAmount = (deliveryCharge + preAmount).toStringAsFixed(2);
    } else {
      if (preAmount == null && deliveryCharge != null)
        totalAmount = "${deliveryCharge.toStringAsFixed(2)}";
      else
        totalAmount = "0.00";
    }
    setState(() {});
    return totalAmount;
  }

  Future<void> autoEndRoute() {
    // logger.i("end route");
    Timer.periodic(Duration(seconds: 1), (timer) async {
      var checkInternet = await ConnectionValidator().check();
      if (checkInternet) if (isRouteStart) {
        if (!isProgress) {
          // logger.i("end route1");
          if (outdeliveryList.length == 1) {
            if (outdeliveryList[0].orderId == 0) {
              logger.i("end route2");
              if (!isDialogShowing) checkOfflineDeliveryAvailable(true);
            }
          }
        }
      }
    });
  }

  Future<void> getParcelBoxData(String driverId) async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      return;
    }
    parcelBoxList.clear();

    logger.i(WebConstant.GET_PARCEL_BOX + "?driverId=$driverId");
    _apiCallFram
        .getDataRequestAPI(
        WebConstant.GET_PARCEL_BOX + "?driverId=$driverId", accessToken,
        context)
        .then((response) async {
      // CustomLoading().showLoadingDialog(context, false);
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
          showToast("Authentication Failed. Login again");
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
            logger.i(response.body);
            GetParcelBoxApiResponse model = parcelBoxFromJson(response.body);
            setState(() {
              ParcelBoxData data = ParcelBoxData();
              data.id = 0;
              data.name = "Parcel Location";
              parcelBoxList.add(data);
              parcelBoxList.addAll(model.data);
            });

            // if (routeList.length > 0) {
            //   getDriversByRoute(routeList[_selectedRoutePosition]);
            // }
          }
        } catch (_, stackTrace) {
          // print(_);
          SentryExemption.sentryExemption(_, stackTrace);
          logger.i(_);
          showToast(WebConstant.ERRORMESSAGE);
          // progressDialog.hide();
          await CustomLoading().showLoadingDialog(context, false);
          // await CustomLoading().showLoadingDialog(context, true);
        }
      } catch (_, stackTrace) {
        logger.i(_);
        SentryExemption.sentryExemption(_, stackTrace);
        // print(_);
        showToast(WebConstant.ERRORMESSAGE);
      }
    });
  }

  void init() {
    setState(() {
      page = 0;
      lastPageLength = -1;
      orderListType = 8;
      selectedType = WebConstant.Status_picked_up;
      selectWithTypeCount(WebConstant.Status_picked_up);
    });
  }

  void updateOrders(orderId, isCd, isFridge) {
    setState(() {
      isProgressAvailable = true;
    });
    String url = WebConstant.UPDATE_NURSING_ORDER;
    logger.i(url);
    logger.i(accessToken);
    Map<String, dynamic> parms = {
      "orderId": orderId,
      "storage_type_cd": isCd ? "t" : "f",
      "storage_type_fr": isFridge ? "t" : "f",
    };
    _apiCallFram.postDataAPI(url, accessToken, parms, context).then((
        response) async {
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
        if (response.body != null) {
          // logger.i("aaa" + json.decode(response.body).toString());
          if (isRouteStart)
            getParcelList(0);
          else
            fetchDeliveryList(0);
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        setState(() {
          isProgressAvailable = false;
        });
        logger.i(_);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }

  void cancelOrder(orderId) {
    setState(() {
      isProgressAvailable = true;
    });
    String url = WebConstant.DELETE_NURSING_ORDER + "?OrderId=$orderId";
    logger.i(url);
    logger.i(accessToken);
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((
        response) async {
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null && response.body != null &&
            response.body == "Unauthenticated") {
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
        if (response != null) {
          logger.i(response.body.toString());
          if (isRouteStart)
            getParcelList(0);
          else
            fetchDeliveryList(0);
        }
      } catch (_, stackTrace) {
        setState(() {
          isProgressAvailable = false;
        });
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }
}

abstract class BulkScanMode {
  void isSelected(bool isSelect);
}

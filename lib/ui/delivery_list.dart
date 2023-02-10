// @dart=2.9
import 'dart:convert';
import 'dart:io';

// import 'package:android_intent/android_intent.dart';
// import 'package:android_intent/android_intent.dart';
import 'package:android_intent_plus/android_intent.dart';

// import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/driver_model.dart';
import 'package:pharmdel_business/model/exemptionList.dart';
import 'package:pharmdel_business/model/route_model.dart';
import 'package:pharmdel_business/presenter/delivery_list_presenter.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/ui/ProfilePage/profile.dart';
import 'package:pharmdel_business/ui/search_order.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../main.dart';
import '../util/CustomDialogBox.dart';
import '../util/connection_validater.dart';
import '../util/constants.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'branch_admin_user_type/DetailScreen.dart';

class DeliveryList extends StatefulWidget {
  final bool showBackarrow;

  DeliveryList(this.showBackarrow);

  DeliveryListState createState() => DeliveryListState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class DeliveryListState extends State<DeliveryList> implements DeliveryListCotract {
  BuildContext _ctx;
  bool _isLoading = false;
  bool showList = false;
  bool noData = false;
  String userId, token, routeS, userType;
  final ScrollController _scrollController = ScrollController();
  DeliveryListPresenter _presenter;
  bool showReset = false;
  String selectedDate;
  String selectedDateTimeStamp;
  final DateFormat formatter = DateFormat("yyyy-MM-dd");

  // ProgressDialog progressDialog;
  var notdeliveryColor = const Color(0xFFE66363);
  var deliverColor = const Color(0xFF0071BC);
  var deliveredColor = const Color(0xFF4AC66E);
  var yetToStartColor = const Color(0xFFF8A340);

  // List<GroupModel> list = new List<GroupModel>();
  List<dynamic> allList = new List();
  List<dynamic> arrOutForDeliveryList = new List();
  List<dynamic> list = new List();
  bool screenVisible = true;
  var totalCount = 0;
  var completedCount = 0;
  var notDeliveredCount = 0;
  var yetToStartCount = 0;

  // RefreshController _refreshController =
  // RefreshController(initialRefresh: false);
  bool todaySelected = false;
  bool tomorrowSelected = false;
  bool otherDateSelected = false;

  bool smsPermission = false;

  ApiCallFram _apiCallFram = ApiCallFram();
  List<RouteList> routeList = List();
  List<DriverModel> driverList = List();
  List<DriverModel> driverListRechedule = List();
  double _size = 1.0;
  int _selectedRoutePosition = 0;
  int _selectedDriverPosition = 0;
  int routeId;
  dynamic driverID;

  String selectedDateComman = "";

  bool isRouteStart = false;

  bool selectAllDelivery = false;

  // ProgressDialog progressDialog;
  bool selectedType = false;

  bool isShowRechedule = false;

  RouteList selectedRoute;

  RouteList selectedRouteRescheduleDropDown;

  String recheduleOrderId = "";
  final DateFormat formatter1 = DateFormat("yyyy-MM-dd");

  DriverModel selectedDriver;

  List<Exemptions> exemptionList = [];

  void grow() {
    setState(() {
      _size += 0.1;
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
    _presenter.doDeliveryList(userId, token);
  }

  void _onLoading() async {
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    // _refreshController.loadComplete();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    userType = prefs.getString(WebConstant.USER_TYPE) ?? "";
    // progressDialog.show();
    _presenter = new DeliveryListPresenter(this);
    //if (userId != null) _presenter.doDeliveryList(userId, token);

    // fetchData();
    getRoutes();
  }

  methodInParent() => {
        // if (userId != null) _presenter.doDeliveryList(userId, token)
        getDeliveryList()
        // Fluttertoast.showToast(msg: "Method called in parent", gravity: ToastGravity.CENTER)
      };

  @override
  void initState() {
    super.initState();
    init();
    // logger.i("testpring");
    selectedDate = formatter1.format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    selectedDateComman = formatter.format(now);
    // progressDialog = ProgressDialog(context, isDismissible: true);
    // fetchData();
    //  _getUsers();
    // progressDialog.show();
  }

  Future<void> getRoutes() async {
    routeList.clear();
    RouteList route = RouteList();
    route.routeName = "Select Route";
    routeList.add(route);
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    _apiCallFram
        .getDataRequestAPI(
            userType == 'Pharmacy' || userType == "Pharmacy Staff"
                ? WebConstant.GET_ROUTE_URL_PHARMACY
                : WebConstant.GET_ROUTE_URL,
            token,
            context)
        .then((response) async {
      // await ProgressDialog(context, isDismissible: false).hide();
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
          logger.i("1");
          logger.i(response.body);
          RouteModel model = routeModelFromJson(response.body);
          logger.i("2");
          setState(() {
            routeList.addAll(model.routeList);
            if (routeList.length == 2) {
              _selectedRoutePosition = 1;
              routeId = routeList[_selectedRoutePosition].routeId;
              getDriversByRoute(routeList[_selectedRoutePosition]);
            }
          });
          // getDeliveryList();
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
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
                Navigator.pop(_ctx);
              },
            ),
            TextButton(
              child: const Text(WebConstant.YES),
              onPressed: () async {
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
              },
            )
          ],
        );
      },
    );
    // Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFffffff);
    const gray = const Color(0xFFEEEFEE);
    const titleColor = const Color(0xFF151026);
    const blue = const Color(0xFF2188e5);
    //progressDialog = new ProgressDialog(context);
    // ProgressDialog(context).style(
    //     message: "Please wait...",
    //     borderRadius: 4.0,
    //     backgroundColor: Colors.white);
    double c_width = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
        backgroundColor: gray,
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: const Text(WebConstant.DELIVERY_LIST, style: TextStyle(color: Colors.black)),
          backgroundColor: PrimaryColor,
          leading: widget.showBackarrow
              ? new Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ))
              : SizedBox(
                  height: 2,
                ),
          actions: [
            new Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    if (allList != null && allList.length > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliverySearchList(
                                  function: methodInParent,
                                  routeS: routeS,
                                  routeID: routeId.toString(),
                                  selectedDateComman: selectedDateComman,
                                  driverId: driverList[_selectedDriverPosition].driverId.toString(),
                                )),
                      );
                    } else {
                      if (_selectedRoutePosition > 0)
                        _showSnackBar("No Record Available");
                      else
                        _showSnackBar("Select Route");
                    }
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )),
            new Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    getDeliveryList();
                  },
                  child: Icon(Icons.refresh, color: Colors.black),
                )),
            new Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                  },
                  child: Icon(Icons.person_outline, color: Colors.black),
                )),
          ],
        ),
        body: SafeArea(
            child: Stack(
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
            VisibilityDetector(
              key: Key('delivery-list'),
              child: CustomScrollView(slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      child: Center(
                        child: new Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 2 - 20,
                                  margin: EdgeInsets.only(left: 5, top: 10, bottom: 0),
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedRoutePosition,
                                      items: [
                                        for (RouteList route in routeList)
                                          DropdownMenuItem(
                                            child: Text("${route.routeName}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(color: Colors.black87)),
                                            value: routeList.indexOf(route),
                                          ),
                                      ],
                                      onChanged: (int value) {
                                        //setState(() {
                                        _selectedRoutePosition = value;
                                        if (_selectedRoutePosition > 0) {
                                          setState(() {
                                            yetToStartCount = 0;
                                            notDeliveredCount = 0;
                                            completedCount = 0;
                                            allList.clear();
                                            totalCount = 0;
                                            showList = false;
                                            noData = true;

                                            routeId = routeList[value].routeId;
                                            _selectedDriverPosition = 0;
                                            getDriversByRoute(routeList[value]);
                                          });
                                          //getRouteForMap(routeList[_selectedRoutePosition]);
                                        } else {
                                          driverList.clear();
                                          yetToStartCount = 0;
                                          notDeliveredCount = 0;
                                          completedCount = 0;
                                          allList.clear();
                                          totalCount = 0;
                                          showList = false;
                                          noData = true;
                                          setState(() {});
                                        }
                                        // getDriversByRoute(routeList[_selectedRoutePosition]);
                                        //});
                                      },
                                    ),
                                  )),
                              if (driverList.isNotEmpty)
                                Container(
                                    width: MediaQuery.of(context).size.width / 2 - 20,
                                    margin: EdgeInsets.only(top: 10, bottom: 0, right: 5),
                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _selectedDriverPosition,
                                        items: [
                                          if (driverList != null && driverList.isNotEmpty)
                                            for (DriverModel route in driverList)
                                              DropdownMenuItem(
                                                child: Text("${route.firstName}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: Colors.black87)),
                                                value: driverList.indexOf(route),
                                              ),
                                        ],
                                        onChanged: (int value) {
                                          //setState(() {
                                          _selectedDriverPosition = value;
                                          if (_selectedDriverPosition > 0) {
                                            setState(() {
                                              driverID = driverList[value].driverId;
                                              getDeliveryList();
                                            });
                                            //getRouteForMap(routeList[_selectedRoutePosition]);
                                          } else {
                                            yetToStartCount = 0;
                                            notDeliveredCount = 0;
                                            completedCount = 0;
                                            allList.clear();
                                            totalCount = 0;
                                            showList = false;
                                            noData = true;
                                            setState(() {});
                                          }

                                          // getDriversByRoute(routeList[_selectedRoutePosition]);
                                          //});
                                        },
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: new Container(
                          margin: EdgeInsets.symmetric(vertical: 1.0),
                          height: 45.0,
                          child: new ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              /*     Padding(
                                padding: const EdgeInsets.all(1),
                                child: new FlatButton(
                                  onPressed: () {
                                    // Navigator.of(context).pushNamed(SignupPage.tag);
                                  },
                                  child: new Text("Deliver date: "),
                                  //padding: EdgeInsets.all(12),
                                ),
                              ),*/

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: new SizedBox(
                                        //minWidth: 40,
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: todaySelected ? Colors.deepOrange : blue,
                                          ),
                                          onPressed: () {
                                            selectedType = false;
                                            if (_selectedRoutePosition != 0) {
                                              todaySelected = true;
                                              tomorrowSelected = false;
                                              otherDateSelected = false;
                                              getDeliveryList();
                                            } else {
                                              _showSnackBar('Select Route First!');
                                            }
                                          },
                                          child: new Text(
                                            "Today",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: new SizedBox(
                                        // minWidth: 40,
                                        height: 30,
                                        child: new ElevatedButton(
                                          // onPressed: _tomorrowFilter,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: tomorrowSelected ? Colors.deepOrange : blue,
                                          ),
                                          onPressed: () {
                                            selectedType = false;
                                            if (_selectedRoutePosition != 0) {
                                              todaySelected = false;
                                              tomorrowSelected = true;
                                              otherDateSelected = false;
                                              getDeliveryList();
                                            } else {
                                              _showSnackBar('Select Route First!');
                                            }
                                          },
                                          child: new Text(
                                            "Tomorrow",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    flex: 4,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: new SizedBox(
                                        // minWidth: 40,
                                        height: 30,
                                        child: new ElevatedButton.icon(
                                          onPressed: _selectedRoutePosition != 0
                                              ? () {
                                                  // print(
                                                  //     "selectedDate $selectedDate");
                                                  logger.i("testttt$selectedDate");
                                                  var formatter = new DateFormat('yyyy-MM-dd');
                                                  showDatePicker(
                                                          context: context,
                                                          initialDate: (selectedDate == '' || selectedDate == null)
                                                              ? DateTime.now()
                                                              : DateFormat("yyyy-MM-dd").parse(selectedDate),
                                                          //which date will display when user open the picker
                                                          firstDate: DateTime(2020),
                                                          //what will be the previous supported year in picker
                                                          lastDate: DateTime(2050),
                                                          builder: (BuildContext context, Widget child) {
                                                            return Theme(
                                                              data: ThemeData.light().copyWith(
                                                                primaryColor: yetToStartColor,
                                                                accentColor: yetToStartColor,
                                                                colorScheme:
                                                                    ColorScheme.light(primary: yetToStartColor),
                                                                buttonTheme:
                                                                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
                                                              ),
                                                              child: child,
                                                            );
                                                          }) //what will be the up to supported date in picker
                                                      .then((pickedDate) {
                                                    //then usually do the future job
                                                    if (pickedDate == null) {
                                                      //if user tap cancel then this function will stop
                                                      return;
                                                    }
                                                    setState(() {
                                                      selectedDate = formatter.format(pickedDate);
                                                    });

                                                    if (_selectedRoutePosition != 0) {
                                                      todaySelected = false;
                                                      tomorrowSelected = false;
                                                      otherDateSelected = true;
                                                      getDeliveryList();
                                                    } else {
                                                      _showSnackBar('Select Route First!');
                                                    }
                                                  });
                                                }
                                              : () {
                                                  _showSnackBar('Select Route First!');
                                                },
                                          icon: new Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Image.asset(
                                              'assets/calendar.png',
                                              fit: BoxFit.fill,
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          label: new Text(
                                            "Select",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: otherDateSelected ? Colors.deepOrange : blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    flex: 4,
                                  ),
                                  Expanded(
                                      child: showReset
                                          ? Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Card(
                                                color: blue,
                                                child: InkWell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                                                    child: Icon(
                                                      Icons.refresh,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    methodInParent();
                                                    //_reload();
                                                  },
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      flex: 2)
                                ],
                              )
                            ],
                          )),
                    ),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                        padding: const EdgeInsets.all(4),
                        child: new Container(
                            child: new Center(
                          child: _isLoading ? new CircularProgressIndicator() : SizedBox(height: 8.0),
                        )))
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: new Container(
                          margin: EdgeInsets.symmetric(vertical: 1.0),
                          height: 50.0,
                          child: new ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  Expanded(
                                    child: InkWell(
                                      onTap: _totalFilter,
                                      child: Container(
                                          //color: deliverColor,
                                          margin: const EdgeInsets.all(3.0),
                                          padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 6.0, bottom: 6.0),
                                          decoration: BoxDecoration(
                                            color: deliverColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              new Text(
                                                'Total',
                                                style: TextStyle(fontSize: 11, color: Colors.white),
                                              ),
                                              new Text(
                                                totalCount.toString(),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: _YetToStartFilter,
                                      child: Container(
                                          //color: deliverColor,
                                          margin: const EdgeInsets.all(3.0),
                                          padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 6.0, bottom: 6.0),
                                          decoration: BoxDecoration(
                                            color: isRouteStart ? yetToStartColor : CustomColors.pickedUp,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              new Text(
                                                isRouteStart ? 'Out for delivery' : "Picked Up",
                                                style: TextStyle(fontSize: 11, color: Colors.white),
                                              ),
                                              new Text(
                                                yetToStartCount.toString(),
                                                style: TextStyle(fontSize: 11, color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: _deleiveredFilter,
                                      child: Container(
                                          //color: deliverColor,
                                          margin: const EdgeInsets.all(3.0),
                                          padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 6.0, bottom: 6.0),
                                          decoration: BoxDecoration(
                                            color: deliveredColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              new Text(
                                                'Delivered',
                                                style: TextStyle(fontSize: 11, color: Colors.white),
                                              ),
                                              new Text(
                                                completedCount.toString(),
                                                style: TextStyle(fontSize: 11, color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                      child: InkWell(
                                        onTap: _failedFilter,
                                        child: Container(
                                            //color: deliverColor,
                                            margin: const EdgeInsets.all(3.0),
                                            padding:
                                                const EdgeInsets.only(left: 3.0, right: 3.0, top: 6.0, bottom: 6.0),
                                            decoration: BoxDecoration(
                                              color: notdeliveryColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                new Text(
                                                  'Failed',
                                                  style: TextStyle(fontSize: 11, color: Colors.white),
                                                ),
                                                new Text(
                                                  notDeliveredCount.toString(),
                                                  style: TextStyle(fontSize: 11, color: Colors.white),
                                                ),
                                              ],
                                            )),
                                      ),
                                      flex: 1)
                                ],
                              )
                            ],
                          )),
                    ),
                    if (selectedType && list.length > 0)
                      Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  selectAllDelivery = !selectAllDelivery;
                                  list.forEach((element) {
                                    element["isSelected"] = selectAllDelivery;
                                  });

                                  setState(() {});
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
                                        logger.i(_selectedDriverPosition);
                                        selectedRoute = routeList[_selectedRoutePosition];
                                        bool checkInternet = await ConnectionValidator().check();
                                        if (!checkInternet) {
                                          Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
                                          return;
                                        }
                                        if (selectedRoute != null && selectedRoute.routeId != null) {
                                          selectedRouteRescheduleDropDown = selectedRoute;
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
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    noData
                        ? Container(
                            height: 200,
                            child: Center(
                              child: Text(
                                'No Order Available',
                                style: TextStyle(color: Colors.black38),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ]),
                ),
                _getSlivers(list, context, c_width)
              ]),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction == 0 && this.mounted) {
                  setState(() {
                    screenVisible = false;
                  });
                } else {
                  // setState(() {
                  screenVisible = true;
                  // });
                }
              },
            ),
          ],
        )));
  }

  Future<void> reschedulePopup() async {
    logger.i(_selectedDriverPosition);
    recheduleOrderId = "";
    list.forEach((element) {
      if (element["isSelected"])
        recheduleOrderId = recheduleOrderId.isNotEmpty
            ? recheduleOrderId + ",${element["orderId"]}"
            : recheduleOrderId + "${element["orderId"]}";
    });

    var testtg = await getDriverList(null, selectedRouteRescheduleDropDown);
    logger.i(testtg);

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
                          BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                            width: MediaQuery.of(context).size.width,
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
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Would you like to reschedule ${recheduleOrderId.split(",").length} deliveries for $selectedDate. Are you okay to proceed ?",
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Select Reschedule Date",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    openCalender(sateState1);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey[700]),
                                        borderRadius: BorderRadius.circular(50.0)),
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 10, bottom: 10),
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
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Select Route",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[700]),
                                      borderRadius: BorderRadius.circular(50.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                                              selectedRouteRescheduleDropDown = newValue;
                                              getDriverList(sateState1, selectedRouteRescheduleDropDown);
                                            });
                                          },
                                          items: routeList.map<DropdownMenuItem<RouteList>>((RouteList value) {
                                            return DropdownMenuItem<RouteList>(
                                              value: value != null ? value : null,
                                              child: Text(
                                                value.routeName,
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                                child: Text(
                                  "Select Driver",
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[700]),
                                      borderRadius: BorderRadius.circular(50.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                                          items: driverListRechedule
                                              .map<DropdownMenuItem<DriverModel>>((DriverModel value) {
                                            return DropdownMenuItem<DriverModel>(
                                              value: value != null ? value : null,
                                              child: Text(
                                                value.firstName,
                                                style: TextStyle(color: Colors.black),
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
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
                                    ),
                                    onPressed: () {
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
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                    child: Text(
                                      "Reschedule Now",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
                                    ),
                                    onPressed: () {
                                      //onclickofsubmit
                                      logger.i(_selectedDriverPosition);
                                      if (selectedDriver == null) {
                                        Fluttertoast.showToast(msg: "Select Driver");
                                      } else if (selectedRouteRescheduleDropDown == null) {
                                        Fluttertoast.showToast(msg: "Select Route");
                                      }
                                      if (selectedDriver != null && selectedRouteRescheduleDropDown != null) {
                                        bulkRescheduleApi();
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

  Future<void> bulkRescheduleApi() async {
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }
    // if(!ProgressDialog(context).isShowing())
    //   ProgressDialog(context).show();
    await CustomLoading().showLoadingDialog(context, true);
    logger.i(WebConstant.GET_ROUTE_URL + "?pharmacyId=${0}");
    _apiCallFram
        .getDataRequestAPI(
            WebConstant.BULK_RESCHEDULE_Pharmacy +
                "?orderId=$recheduleOrderId&rescheduleDate=$selectedDate&driverId=${selectedDriver.driverId}&routeId=${selectedRouteRescheduleDropDown.routeId}",
            token,
            context)
        .then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          // ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
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
            Navigator.pop(context);
            showCompleteRescheduleDialog(data["message"].toString() ?? "");
          } else {
            if (data["message"] != null && data["message"] != "")
              Fluttertoast.showToast(msg: data["message"].toString());
          }

          // logger.i("routeList_" + model.routeList.length.toString());

        }
      } catch (_Ex, stackTrace) {
        SentryExemption.sentryExemption(_Ex, stackTrace);
        logger.i(_Ex);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
      setState(() {
        // isProgressAvailable = false;
      });
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

  void onClickDialog(bool value) {
    if (value) {
      selectAllDelivery = false;
      isShowRechedule = false;
      list.forEach((element) {
        element["isSelected"] = selectAllDelivery;
      });
      getDeliveryList();
      setState(() {});
    }
  }

  void openCalender(StateSetter sateState1) {
    DateTime date = DateTime.now();

    showDatePicker(
        context: context,
        initialDate: DateTime(date.year, date.month, date.day + 1),
        firstDate: DateTime(date.year, date.month, date.day + 1),
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

  Future<bool> getDriverList(StateSetter sateState1, RouteList selectedRouteRescheduleDropDown) async {
    logger.i("testttt");
    // if (!progressDialog.isShowing()) progressDialog.show();
    await CustomLoading().showLoadingDialog(context, true);
    logger.i("testttt1");
    String parms = "?routeId=${selectedRouteRescheduleDropDown.routeId ?? ""}";
    await _apiCallFram
        .getDataRequestAPI("${WebConstant.GetPHARMACYDriverListByRoute}$parms", token, context)
        .then((response) async {
      // print(response);
      // progressDialog.hide();
      await CustomLoading().showLoadingDialog(context, false);
      driverListRechedule.clear();
      // ProgressDialog(context, isDismissible: false).show();
      // DriverModel driverModel = new DriverModel();
      // driverModel.driverId = 0;
      // driverModel.firstName = "Select Driver";
      // driverListRechedule.add(driverModel);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
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
          driverListRechedule.addAll(driverModelFromJson(response.body));
          if (driverListRechedule.isNotEmpty && driverListRechedule.length > 0) {
            selectedDriver = driverListRechedule[0];
          }
          if (sateState1 != null) {
            sateState1(() {});
          }
          return true;
        } else {
          return false;
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        showToast(WebConstant.ERRORMESSAGE);
        return Future.value(true);
      }
    });
  }

  void showToast(String s) {
    Fluttertoast.showToast(msg: s.toString());
  }

  SliverList _getSlivers(List myList, BuildContext context, double c_width) {
    const blue = const Color(0xFF2188e5);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Visibility(
              visible: showList,
              child: new InkResponse(
                  onTap: () => _onTileClicked(index),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), boxShadow: [
                          BoxShadow(spreadRadius: 1, blurRadius: 10, offset: Offset(0, 4), color: Colors.grey[300])
                        ]),
                        margin: EdgeInsets.only(top: 1, bottom: 1, left: 2.5, right: 2.5),
                        child: Card(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Text(
                                                      "${list[index]['customerName'] ?? ""}",
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  if (list[index]['pmr_type'] != null &&
                                                      (list[index]['pmr_type'] == "titan" ||
                                                          list[index]['pmr_type'] == "nursing_box") &&
                                                      list[index]['pr_id'] != null &&
                                                      list[index]['pr_id'].isNotEmpty)
                                                    Text(
                                                      '(P/N : ${list[index]['pr_id'] ?? ""}) ',
                                                      style: TextStyle(color: CustomColors.pnColor),
                                                    ),
                                                  if (list[index]['isCronCreated'] == "t")
                                                    Image.asset("assets/automatic_icon.png", height: 14, width: 14),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 5,
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  // Image.asset(
                                                  //   "assets/home_icon.png",
                                                  //   height: 18,
                                                  //   width: 18,
                                                  //   color: list[index][
                                                  //   'deliveryStatusDesc'] ==
                                                  //       WebConstant
                                                  //           .Status_out_for_delivery
                                                  //       ? CustomColors.yetToStartColor
                                                  //       : list[index][
                                                  //   'deliveryStatusDesc'] ==
                                                  //       WebConstant
                                                  //           .Status_delivered
                                                  //       ? CustomColors
                                                  //       .deliveredColor
                                                  //       : (list[index][
                                                  //   'deliveryStatusDesc'] ==
                                                  //       WebConstant
                                                  //           .Status_failed
                                                  //       ? CustomColors
                                                  //       .failedColor
                                                  //       : (list[index][
                                                  //   'deliveryStatusDesc'] ==
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
                                                      "${list[index]['address'] ?? ""}",
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w300),
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  if (list != null &&
                                                      list.isNotEmpty &&
                                                      list[index]["alt_address"] != null &&
                                                      list[index]["alt_address"] != "" &&
                                                      list[index]["alt_address"] == "t")
                                                    Image.asset(
                                                      "assets/alt-add.png",
                                                      height: 18,
                                                      width: 18,
                                                    )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 5,
                                                height: 5,
                                              ),
                                              list[index]['deliveryStatusDesc'] == WebConstant.Status_out_for_delivery
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                if (Platform.isAndroid) {
                                                                  if (list[index]['driver_latitude'] != null &&
                                                                      list[index]['driver_longitude'] != null &&
                                                                      list[index]['latitude'] != null &&
                                                                      list[index]['longitude'] != null) {
                                                                    final AndroidIntent intent = new AndroidIntent(
                                                                        action: 'action_view',
                                                                        data: Uri.encodeFull(
                                                                            "https://www.google.com/maps/dir/?api=1&origin=${list[index]['driver_latitude']},${list[index]['driver_longitude']}"
                                                                            "&destination=${list[index]['latitude']},${list[index]['longitude']}"),
                                                                        package: 'com.google.android.apps.maps');
                                                                    intent.launch();
                                                                  } else {
                                                                    _showSnackBar("Address not valid");
                                                                  }
                                                                } else {
                                                                  if (list[index]['address'] != null) {
                                                                    MapsLauncher.launchQuery(
                                                                        "${list[index]['address']}");
                                                                  } else {
                                                                    _showSnackBar("Address not valid");
                                                                  }
                                                                  // MapsLauncher.launchCoordinates(double.parse(delivery
                                                                  //     .customerDetials
                                                                  //     .customerAddress
                                                                  //     .latitude ?? "0.0"),double.parse(delivery
                                                                  //     .customerDetials
                                                                  //     .customerAddress
                                                                  //     .longitude ?? "0.0")
                                                                  //
                                                                  // );
                                                                  // String url = "https://www.google.com/maps/dir/?api=1&origin=${_latLng[0]}&destination=${_latLng[0]}&travelmode=driving&dir_action=navigate";
                                                                }
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    left: 1, right: 1, top: 2, bottom: 2),
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                    color: Colors.blueAccent,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          spreadRadius: 1,
                                                                          blurRadius: 10,
                                                                          offset: Offset(0, 4),
                                                                          color: Colors.grey[300])
                                                                    ]),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.white),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                      height: 0,
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
                                                        //               FontWeight.w600,
                                                        //           color: Colors
                                                        //               .blueAccent),
                                                        //     ),
                                                        //     SizedBox(
                                                        //       width: 5,
                                                        //       height: 0,
                                                        //     ),
                                                        //     Text(
                                                        //       "${list[index]['eta'] ?? "0.0"}",
                                                        //       style: TextStyle(
                                                        //         fontSize: 13,
                                                        //         fontWeight:
                                                        //             FontWeight.w500,
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  // if (list[index]['surgeryName'] !=
                                                  //     null &&
                                                  //     list[index]['surgeryName'] != "")
                                                  //   Flexible(
                                                  //     flex: 5,
                                                  //     child: Container(
                                                  //         decoration: BoxDecoration(
                                                  //             borderRadius:
                                                  //             BorderRadius.all(
                                                  //                 Radius.circular(
                                                  //                     5)),
                                                  //             color: Colors.blueAccent,
                                                  //             boxShadow: [
                                                  //               BoxShadow(
                                                  //                   spreadRadius: 1,
                                                  //                   blurRadius: 10,
                                                  //                   offset:
                                                  //                   Offset(0, 4),
                                                  //                   color: Colors
                                                  //                       .grey[300])
                                                  //             ]),
                                                  //         padding: EdgeInsets.only(
                                                  //             left: 10,
                                                  //             right: 10,
                                                  //             bottom: 2),
                                                  //         child: Text(
                                                  //             list[index]
                                                  //             ['surgeryName'] ??
                                                  //                 "",
                                                  //             maxLines: 2,
                                                  //             style: TextStyle(
                                                  //                 color:
                                                  //                 Colors.white))),
                                                  //   ),
                                                  // if (list[index]['surgeryName'] !=
                                                  //     null &&
                                                  //     list[index]['surgeryName'] != "")
                                                  //   SizedBox(
                                                  //     width: 10,
                                                  //   ),
                                                  if (list[index]['serviceName'] != null &&
                                                      list[index]['serviceName'] != "")
                                                    Flexible(
                                                      flex: 5,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                                              color: Colors.redAccent,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    spreadRadius: 1,
                                                                    blurRadius: 10,
                                                                    offset: Offset(0, 4),
                                                                    color: Colors.grey[300])
                                                              ]),
                                                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 2),
                                                          child: Text(
                                                            list[index]['serviceName'] ?? "",
                                                            maxLines: 2,
                                                            style: TextStyle(color: Colors.white),
                                                          )),
                                                    ),
                                                  if (list[index]['serviceName'] != null &&
                                                      list[index]['serviceName'] != "")
                                                    SizedBox(
                                                      width: 8.0,
                                                    ),
                                                  if (list[index]['parcel_box_name'] != null &&
                                                      list[index]['parcel_box_name'] != "")
                                                    if (list[index]['deliveryStatusDesc'] == "PickedUp" ||
                                                        list[index]['deliveryStatusDesc'] ==
                                                            WebConstant.Status_out_for_delivery)
                                                      Flexible(
                                                        flex: 5,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.red),
                                                              borderRadius: BorderRadius.circular(5.0)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(
                                                                left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                                            child: Text(
                                                              "${list[index]['parcel_box_name'].length > 8 ? list[index]['parcel_box_name'].substring(0, 8) : list[index]['parcel_box_name'] ?? ""}",
                                                              style: TextStyle(
                                                                color: CustomColors.pickedUp,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            list[index]['deliveryStatusDesc'] != WebConstant.Status_out_for_delivery
                                                ? Text(
                                                    list[index]['deliveryStatusDesc'] ?? "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: list[index]['deliveryStatusDesc'] ==
                                                              WebConstant.Status_out_for_delivery
                                                          ? CustomColors.yetToStartColor
                                                          : list[index]['deliveryStatusDesc'] ==
                                                                  WebConstant.Status_delivered
                                                              ? CustomColors.deliveredColor
                                                              : (list[index]['deliveryStatusDesc'] ==
                                                                      WebConstant.Status_failed
                                                                  ? CustomColors.failedColor
                                                                  : (list[index]['deliveryStatusDesc'] ==
                                                                          WebConstant.Status_picked_up
                                                                      ? CustomColors.pickedUp
                                                                      : Colors.blueAccent)),
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
                                  if (list[index]['deliveryStatusDesc'] == WebConstant.Status_failed)
                                    Positioned(
                                      right: 5,
                                      top: 3,
                                      child: SizedBox(
                                        height: 24.0,
                                        width: 24.0,
                                        child: Checkbox(
                                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                                            value:
                                                list[index]['isSelected'] != null ? list[index]['isSelected'] : false,
                                            onChanged: (value) {
                                              list[index]['isSelected'] = value;
                                              getCheckSelected();
                                              setState(() {});
                                            }),
                                      ),
                                    ),
                                ],
                              ),
                              if (list[index]['deliveryStatusDesc'] == WebConstant.Status_failed &&
                                  list[index]['reschedule_date'] != null &&
                                  list[index]['reschedule_date'] != "")
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Booked : ",
                                        style: TextStyle(
                                          color: CustomColors.failedColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "${list[index]['reschedule_date']}",
                                        style: TextStyle(
                                          color: CustomColors.failedColor,
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
                    ],
                  )));
        },
        childCount: myList.length,
      ),
    );
  }

  void _todayFilter() {
    setState(() {
      showReset = true;
      otherDateSelected = false;
      todaySelected = true;
      tomorrowSelected = false;
    });
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //Fluttertoast.showToast(msg: formattedDate, toastLength: Toast.LENGTH_LONG);
    // list.clear();
    totalCount = 0;
    yetToStartCount = 0;
    notDeliveredCount = 0;
    completedCount = 0;
    List<dynamic> listdd = new List();
    // for (var i = 0; i < allList.length; i++) {
    //   // if (allList[i]['deliveryStatus'].toString() == "1" ||
    //   //     allList[i]['deliveryStatus'].toString() == "7") {
    //   if (allList[i]['deliveryDate']
    //       .toString()
    //       .startsWith(formatter.format(now))) {
    //     listdd.add(allList[i]);
    //   }
    // //  }
    // }

    for (var i = 0; i < allList.length; i++) {
      // print(allList[i]['deliveryStatus'].toString());

      listdd.add(allList[i]);
    }

    if (listdd.length > 0) {
      setState(() {
        noData = false;
        showList = true;
        list = listdd;
        // logger.i("yrtrdtfdt");
        for (var i = 0; i < list.length; i++) {
          // totalCount++;
          if (list[i]['deliveryStatus'].toString() == "1" ||
              list[i]['deliveryStatus'].toString() == "2" ||
              list[i]['deliveryStatus'].toString() == "3") {
            totalCount++;
          } else if (!isRouteStart && list[i]['deliveryStatus'].toString() == "8") {
            yetToStartCount++;
          } else if (isRouteStart && list[i]['deliveryStatus'].toString() == "4") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "5") {
            completedCount++;
          } else if (list[i]['deliveryStatus'].toString() == "9") {
            notDeliveredCount++;
          } else if (list[i]['deliveryStatus'].toString() == "6") {
            notDeliveredCount++;
          }
        }
      });
    } else {
      list = allList;
      setState(() {
        yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = 0;
        showList = false;
        noData = true;
      });
      _showSnackBar("No data found on Today");
    }

    listdd.clear();
    for (var i = 0; i < allList.length; i++) {
      if (allList[i]['deliveryStatus'].toString() == "1" || allList[i]['deliveryStatus'].toString() == "7") {
        //  totalCount++;
        if (todaySelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(now))) {
            listdd.add(allList[i]);
          }
        }
      }
    }

    if (listdd.length > 0) {
      setState(() {
        showList = true;
        noData = false;
        list = listdd;
      });
    }
  }

  void _YetToStartFilter() {
    selectedType = false;
    final now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    String formattedDate = formatter.format(tomorrow);
    // Fluttertoast.showToast(msg: formattedDate, toastLength: Toast.LENGTH_LONG);
    // list.clear();
    List<dynamic> listdd = new List();
    logger.i(arrOutForDeliveryList.length);
    logger.i(allList.length);
    if (isRouteStart) {
      for (var i = 0; i < arrOutForDeliveryList.length; i++) {
        if (isRouteStart && arrOutForDeliveryList[i]['deliveryStatus'].toString() == "4") {
          if (todaySelected) {
            if (arrOutForDeliveryList[i]['deliveryDate'].toString().startsWith(formatter.format(now))) {
              listdd.add(arrOutForDeliveryList[i]);
            }
          } else if (tomorrowSelected) {
            if (arrOutForDeliveryList[i]['deliveryDate'].toString().startsWith(formatter.format(tomorrow))) {
              listdd.add(arrOutForDeliveryList[i]);
            }
          } else if (otherDateSelected) {
            if (arrOutForDeliveryList[i]['deliveryDate'].toString().startsWith(selectedDate)) {
              listdd.add(arrOutForDeliveryList[i]);
            }
          } else {
            listdd.add(arrOutForDeliveryList[i]);
          }
        }
      }
    } else {
      for (var i = 0; i < allList.length; i++) {
        if (isRouteStart && allList[i]['deliveryStatus'].toString() == "4") {
          if (todaySelected) {
            if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(now))) {
              listdd.add(allList[i]);
            }
          } else if (tomorrowSelected) {
            if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(tomorrow))) {
              listdd.add(allList[i]);
            }
          } else if (otherDateSelected) {
            if (allList[i]['deliveryDate'].toString().startsWith(selectedDate)) {
              listdd.add(allList[i]);
            }
          } else {
            listdd.add(allList[i]);
          }
        } else {
          if (!isRouteStart && allList[i]['deliveryStatus'].toString() == "8") {
            if (todaySelected) {
              if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(now))) {
                listdd.add(allList[i]);
              }
            } else if (tomorrowSelected) {
              if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(tomorrow))) {
                listdd.add(allList[i]);
              }
            } else if (otherDateSelected) {
              if (allList[i]['deliveryDate'].toString().startsWith(selectedDate)) {
                listdd.add(allList[i]);
              }
            } else {
              listdd.add(allList[i]);
            }
          }
        }
      }
    }

    if (listdd.length > 0) {
      setState(() {
        showList = true;
        noData = false;
        list = listdd;
        /*yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = list.length;
        for (var i = 0; i < list.length; i++) {
          if (list[i]['deliveryStatus'].toString() == "1") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "2") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "3") {
            completedCount++;
          } else if (list[i]['deliveryStatus'].toString() == "4") {
            notDeliveredCount++;
          } else if (list[i]['deliveryStatus'].toString() == "5") {
            notDeliveredCount++;
          }
        }*/
      });
    } else {
      // list = allList;
      setState(() {
        /* yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = 0;*/
        showList = false;
        noData = true;
      });
      //_showSnackBar("No data found on This date");
    }
  }

  void _deleiveredFilter() {
    selectedType = false;
    final now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    String formattedDate = formatter.format(tomorrow);
    // Fluttertoast.showToast(msg: formattedDate, toastLength: Toast.LENGTH_LONG);
    // list.clear();
    List<dynamic> listdd = new List();
    for (var i = 0; i < allList.length; i++) {
      if (allList[i]['deliveryStatus'].toString() == "5") {
        if (todaySelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(now))) {
            listdd.add(allList[i]);
          }
        } else if (tomorrowSelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(tomorrow))) {
            listdd.add(allList[i]);
          }
        } else if (otherDateSelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(selectedDate)) {
            listdd.add(allList[i]);
          }
        } else {
          listdd.add(allList[i]);
        }
      }
    }
    if (listdd.length > 0) {
      setState(() {
        showList = true;
        noData = false;
        list = listdd;
        /*yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = list.length;
        for (var i = 0; i < list.length; i++) {
          if (list[i]['deliveryStatus'].toString() == "1") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "2") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "3") {
            completedCount++;
          } else if (list[i]['deliveryStatus'].toString() == "4") {
            notDeliveredCount++;
          } else if (list[i]['deliveryStatus'].toString() == "5") {
            notDeliveredCount++;
          }
        }*/
      });
    } else {
      //list = allList;
      setState(() {
        /* yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = 0;*/
        showList = false;
        noData = true;
      });
      //_showSnackBar("No data found on This date");
    }
  }

  void _failedFilter() {
    selectedType = true;
    selectAllDelivery = false;
    isShowRechedule = false;
    final now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    String formattedDate = formatter.format(tomorrow);
    // Fluttertoast.showToast(msg: formattedDate, toastLength: Toast.LENGTH_LONG);
    // list.clear();
    List<dynamic> listdd = new List();
    for (var i = 0; i < allList.length; i++) {
      if (allList[i]['deliveryStatus'].toString() == "9" || allList[i]['deliveryStatus'].toString() == "6") {
        allList[i]["isSelected"] = false;
        if (todaySelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(now))) {
            listdd.add(allList[i]);
          }
        } else if (tomorrowSelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(tomorrow))) {
            listdd.add(allList[i]);
          }
        } else if (otherDateSelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(selectedDate)) {
            listdd.add(allList[i]);
          }
        } else {
          listdd.add(allList[i]);
        }
      }
    }
    if (listdd.length > 0) {
      setState(() {
        showList = true;
        noData = false;
        list = listdd;
        /*yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = list.length;
        for (var i = 0; i < list.length; i++) {
          if (list[i]['deliveryStatus'].toString() == "1") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "2") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "3") {
            completedCount++;
          } else if (list[i]['deliveryStatus'].toString() == "4") {
            notDeliveredCount++;
          } else if (list[i]['deliveryStatus'].toString() == "5") {
            notDeliveredCount++;
          }
        }*/
      });
    } else {
      list = allList;
      setState(() {
        /*yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = 0;*/
        showList = false;
        noData = true;
      });
      //_showSnackBar("No data found on This date");
    }
  }

  void _totalFilter() {
    selectedType = false;
    final now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    String formattedDate = formatter.format(tomorrow);
    // Fluttertoast.showToast(msg: formattedDate, toastLength: Toast.LENGTH_LONG);
    // list.clear();
    List<dynamic> listdd = new List();
    for (var i = 0; i < allList.length; i++) {
      if (allList[i]['deliveryStatus'].toString() == "1" ||
          allList[i]['deliveryStatus'].toString() == "2" ||
          allList[i]['deliveryStatus'].toString() == "3") {
        if (todaySelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(now))) {
            listdd.add(allList[i]);
          }
        } else if (tomorrowSelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(formatter.format(tomorrow))) {
            listdd.add(allList[i]);
          }
        } else if (otherDateSelected) {
          if (allList[i]['deliveryDate'].toString().startsWith(selectedDate)) {
            listdd.add(allList[i]);
          }
        } else {
          listdd.add(allList[i]);
        }
      }
    }
    if (listdd.length > 0) {
      setState(() {
        showList = true;
        noData = false;
        list = listdd;
        /*yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = list.length;
        for (var i = 0; i < list.length; i++) {
          if (list[i]['deliveryStatus'].toString() == "1") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "2") {
            yetToStartCount++;
          } else if (list[i]['deliveryStatus'].toString() == "3") {
            completedCount++;
          } else if (list[i]['deliveryStatus'].toString() == "4") {
            notDeliveredCount++;
          } else if (list[i]['deliveryStatus'].toString() == "5") {
            notDeliveredCount++;
          }
        }*/
      });
    } else {
      //list = allList;
      setState(() {
        /*yetToStartCount = 0;
        notDeliveredCount = 0;
        completedCount = 0;
        totalCount = 0;*/
        showList = false;
        noData = true;
      });
      //_showSnackBar("No data found on This date");
    }
  }

  void _showSnackBar(String text) {
    if (screenVisible == true) {
      Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
    }
  }

  void _onTileClicked(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailScreen(
              name: list[index]['customerName'].toString(),
              id: list[index]['orderId'].toString(),
              subsId: list[index]['subs_id'] != null ? list[index]['subs_id'].toString() : "",
              delCharge: list[index]['del_charge'] != null && list[index]['del_charge'] != ""
                  ? list[index]['del_charge'].toString()
                  : "",
              rxCharge: list[index]['rx_charge'] != null ? double.tryParse(list[index]['rx_charge'].toString()) : 0,
              rxInvoice: list[index]['rx_invoice'] != null && list[index]['rx_invoice'] != ""
                  ? int.tryParse(list[index]['rx_invoice'].toString())
                  : 0,
              exemption: list[index]['exemption'],
              bagSize: list[index]['bagSize'],
              paymentStatus: list[index]['paymentStatus'],
              address: list[index]['address'].toString(),
              exemptionList: exemptionList != null && exemptionList.isNotEmpty ? exemptionList : [],
              driverId: driverList[_selectedDriverPosition].driverId.toString(),
              deliveryNote:
                  list[index]['deliveryNote'].toString() == null ? "null" : list[index]['deliveryNote'].toString(),
              parcelBoxName: list[index]['parcel_box_name'].toString(),
              deliveryStatus: list[index]['deliveryStatus'].toString(),
              deliveryDate: list[index]['deliveryDate'].toString(),
              deliveryId: list[index]['deliveryId'].toString(),
              mobile: list[index]['customerMobileNumber'],
              deliveryStatusDesc: list[index]['deliveryStatusDesc'],
              exitingNote: list[index]['exitingNote'] != null
                  ? list[index]['exitingNote'] != "null"
                      ? list[index]['exitingNote']
                      : ""
                  : "",
              recentDeliveryNote: list[index]['recentDeliveryNote'] != null ? list[index]['recentDeliveryNote'] : "",
              delivered_to: list[index]['delivered_to'] != null ? list[index]['delivered_to'] : "",
              isControlledDrugs: list[index]['isControlledDrugs'] != null ? list[index]['isControlledDrugs'] : "",
              isStorageFridge: list[index]['isStorageFridge'] != null ? list[index]['isStorageFridge'] : "",
              route: list[index]['route_name'] != null ? list[index]['route_name'] : "",
              pNo: list[index]['pr_id'] != null ? list[index]['pr_id'] : "",
              pmr_type: list[index]['pmr_type'] != null ? list[index]['pmr_type'] : "",
              function: methodInParent)),
    );
  }

  @override
  Future<void> onDeliveryListError(String errorTxt) async {
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    // progressDialog.hide();
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  Future<Map<String, Object>> getDeliveryList() async {
    //setState(() => _isLoading = true);
    // print(todaySelected);
    // print(tomorrowSelected);
    // print(otherDateSelected);
    String date = "";
    if (todaySelected) {
      date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else if (tomorrowSelected) {
      final now = DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      final tomorrow = DateTime(now.year, now.month, (now.day + 1));
      date = formatter.format(tomorrow);
      // print(date);
    } else if (otherDateSelected) {
      date = selectedDate;
    } else {
      todaySelected = true;
      date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    selectedDateComman = date;
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    Map<String, String> headers = {
      'Accept': 'application/json',
      "Content-type": "application/json",
      "Authorization": 'Bearer $token'
    };
    String url = WebConstant.DELIVERY_LIST_URL + "?routeId=$routeId&dateTime=${date}" + "&driverId=$driverID";
    // logger.i("${url}");
    logger.i(url);
    final response = await http.get(Uri.parse(url), headers: headers);
    // logger.i("request : ${response.request} ${response.statusCode}");
    if (response.statusCode == 200) {
      // await ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // print(response);
      Map<String, Object> data = json.decode(response.body);
      logger.i("Response: $data");
      List<dynamic> homelist = data['list'] != null ? data['list'] : [];
      ExemptionList1 exemptions = exemptionList1FromJson(response.body);
      List<dynamic> outForDeliveryList = data['sorted_list'] != null ? data['sorted_list'] : [];
      logger.i("outForDeliveryList: $outForDeliveryList");

      isRouteStart = data['isRouteStarted'] != null ? data['isRouteStarted'] : false;
      if (homelist != null && homelist.length > 0) {
        setState(() {
          // _isLoading = false;
          yetToStartCount = 0;
          notDeliveredCount = 0;
          completedCount = 0;
          allList = homelist;
          arrOutForDeliveryList = outForDeliveryList;
          totalCount = 0;
          showList = true;
          noData = false;
          if (exemptions != null && exemptions.exemptions.length > 0) {
            exemptionList.addAll(exemptions.exemptions);
          }
          for (var i = 0; i < allList.length; i++) {
            if (allList[i]['deliveryStatus'].toString() == "1" ||
                allList[i]['deliveryStatus'].toString() == "2" ||
                allList[i]['deliveryStatus'].toString() == "3") {
              totalCount++;
            } else if (isRouteStart && allList[i]['deliveryStatus'].toString() == "4") {
              yetToStartCount++;
            } else if (!isRouteStart && allList[i]['deliveryStatus'].toString() == "8") {
              yetToStartCount++;
            } else if (allList[i]['deliveryStatus'].toString() == "5") {
              completedCount++;
            } else if (allList[i]['deliveryStatus'].toString() == "9") {
              notDeliveredCount++;
            } else if (allList[i]['deliveryStatus'].toString() == "6") {
              notDeliveredCount++;
            }
          }
          _totalFilter();
          if (tomorrowSelected == true) {
            //_tomorrowFilter();
          } else if (otherDateSelected == true) {
            // _datePicker();
          } else {
            //_todayFilter();
          }
          //List<GroupModel> l = data["data"].cast<GroupModel>();
        });
      } else {
        setState(() {
          yetToStartCount = 0;
          notDeliveredCount = 0;
          completedCount = 0;
          allList = homelist;
          totalCount = 0;
          showList = false;
          noData = true;
        });
        _showSnackBar("No Data Found");
      }
    } else if (response.statusCode == 401) {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
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
          }, transitionsBuilder:
              (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
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
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      //_showSnackBar('Something went wrong');
    }
  }

  @override
  Future<void> onDeliveryListSuccess(Map<String, Object> data) async {
    // await ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    //progressDialog.hide();
    //setState(() => _isLoading = false);
    //_showSnackBar(data.toString());
    try {
      // if (data.containsKey("data")) {
      if (data == null) {
        _showSnackBar("No Data Found");
      } else {
        if (data.toString().contains('401')) {
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
          _showSnackBar('Session expired, Login again');
        } else {
          // print(data.toString());

          ///{orderId: 20, deliveryId: 3, customerName: Ramesh Thiru,
          // address: 123 Main Street,2nd Extension,Coimbatore,England,641041, deliveryNote: To home,
          // deliveryStatus: 0, deliveryDate: 2020-03-05T00:00:00}
          List<dynamic> homelist = data['list'];
          // Iterable a = json.decode(userType);
          // List<GroupModel> homelist = a.map((model) => GroupModel.fromJson(model)).toList();
          if (homelist.length > 0) {
            setState(() {
              yetToStartCount = 0;
              notDeliveredCount = 0;
              completedCount = 0;
              allList = homelist;
              totalCount = 0;
              showList = true;
              noData = false;
              // logger.i("testtttttttttttttt");
              for (var i = 0; i < allList.length; i++) {
                //  totalCount++;
                // if (allList[i]['deliveryStatus'].toString() == "1" ||
                //     allList[i]['deliveryStatus'].toString() == "7") {
                //   totalCount++;
                // } else if (allList[i]['deliveryStatus'].toString() == "2") {
                //   yetToStartCount++;
                // } else if (allList[i]['deliveryStatus'].toString() == "3") {
                //   completedCount++;
                // } else if (allList[i]['deliveryStatus'].toString() == "4") {
                //   notDeliveredCount++;
                // } else if (allList[i]['deliveryStatus'].toString() == "5") {
                //   notDeliveredCount++;
                // } else if (allList[i]['deliveryStatus'].toString() == "6") {
                //   notDeliveredCount++;
                // }
                if (list[i]['deliveryStatus'].toString() == "1" ||
                    list[i]['deliveryStatus'].toString() == "2" ||
                    list[i]['deliveryStatus'].toString() == "3") {
                  totalCount++;
                } else if (list[i]['deliveryStatus'].toString() == "4") {
                  yetToStartCount++;
                } else if (list[i]['deliveryStatus'].toString() == "5") {
                  completedCount++;
                } else if (list[i]['deliveryStatus'].toString() == "9") {
                  notDeliveredCount++;
                } else if (list[i]['deliveryStatus'].toString() == "6") {
                  notDeliveredCount++;
                }
              }
              _todayFilter();
              //List<GroupModel> l = data["data"].cast<GroupModel>();
            });
          } else {
            _showSnackBar("No Data Found");
          }
        }
      }
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      _showSnackBar(e);
    }
  }

  Future<void> getDriversByRoute(RouteList route) async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    driverList.clear();
    // ProgressDialog(context, isDismissible: false).show();
    DriverModel driverModel = new DriverModel();
    driverModel.driverId = 0;
    driverModel.firstName = "Select Driver";
    driverList.add(driverModel);
    String parms = "?routeId=${route.routeId ?? ""}";
    String url = "${WebConstant.GetPHARMACYDriverListByRoute}$parms";
    logger.i(url);
    _apiCallFram.getDataRequestAPI(url, token, context).then((response) async {
      // await ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
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
        if (response != null) {
          logger.i(response.body);
          setState(() {
            driverList.addAll(driverModelFromJson(response.body));
            if (driverList.length == 2) {
              _selectedDriverPosition = 1;
              driverID = driverList[_selectedDriverPosition].driverId;
              getDeliveryList();
            }
          });
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }

  void getCheckSelected() {
    var data = list.where((element) => element["isSelected"]);
    if (data != null && data.isNotEmpty)
      isShowRechedule = data.first["isSelected"];
    else
      isShowRechedule = false;

    setState(() {});
  }
}

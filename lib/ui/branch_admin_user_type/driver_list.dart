// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/driver_model.dart';
import 'package:pharmdel_business/model/route_for_pharmacy.dart';
import 'package:pharmdel_business/model/route_model.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/display_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../login_screen.dart';
import '../splash_screen.dart';

class DriverList extends StatefulWidget {
  StateDriverList createState() => StateDriverList();
}

class StateDriverList extends State<DriverList> {
  ApiCallFram _apiCallFram = ApiCallFram();
  List<RouteList> routeList = List();
  List<DriverModel> driverList = List();
  List<RouteForPharmacy> pharmacyRouteList = List();
  String accessToken, userType;
  int _selectedRoutePosition = 0;
  int _selectedDriverPosition = 0;
  String selectedDate = "";
  String showDatedDate = "";
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();

    selectedDate = formatter.format(now);
    showDatedDate = formatterShow.format(now);
    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      userType = value.getString(WebConstant.USER_TYPE) ?? "";
      getRoutes();
    });
    checkLastTime(context);
  }

  Future<void> getRoutes() async {
    routeList.clear();

    RouteList route = RouteList();
    route.routeName = "Select Route";
    routeList.add(route);
    // ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    String url = userType == 'Pharmacy' || userType == "Pharmacy Staff" ? WebConstant.GET_ROUTE_URL_PHARMACY : WebConstant.GET_ROUTE_URL;
    logger.i(url);
    logger.i(accessToken);
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((response) async {
      // ProgressDialog(context).hide();
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
          RouteModel model = routeModelFromJson(response.body);
          setState(() {
            routeList.addAll(model.routeList);
          });
          // if(routeList.length > 0){
          //   getRouteForMap(routeList[_selectedRoutePosition]);
          //   //getDriversByRoute(routeList[_selectedRoutePosition]);
          // }
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        logger.i(_);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            //height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/bottom_bg.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/top_bg.png",
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.5,
            backgroundColor: Colors.transparent,
            //automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.blueGrey,
              ),
            ),
            title: const Text('Route', style: TextStyle(color: Colors.blueGrey)),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  /*Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Choose Route",style: TextStyle(color: Colors.blueGrey,fontSize: 14),),
                  ),*/
                  /*Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Please select route", style: TextStyle(color: Colors.black87)),
                  ),*/
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        //border: Border.all(color: Colors.grey[400]),
                        /*boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                                color: Colors.grey[300]
                            )
                          ]*/
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedRoutePosition,
                          items: [
                            for (RouteList route in routeList)
                              DropdownMenuItem(
                                child: Text("${route.routeName}", style: TextStyle(color: Colors.black87)),
                                value: routeList.indexOf(route),
                              ),
                          ],
                          onChanged: (int value) {
                            //setState(() {
                            _selectedRoutePosition = value;
                            if (_selectedRoutePosition > 0) {
                              getDriversByRoute(routeList[_selectedRoutePosition]);
                            }

                            // getDriversByRoute(routeList[_selectedRoutePosition]);
                            //});
                          },
                        ),
                      )),
                  if (driverList.isNotEmpty)
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          //border: Border.all(color: Colors.grey[400]),
                          /*boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                                color: Colors.grey[300]
                            )
                          ]*/
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedDriverPosition,
                            items: [
                              for (DriverModel route in driverList)
                                DropdownMenuItem(
                                  child: Text("${route.firstName}", style: TextStyle(color: Colors.black87)),
                                  value: driverList.indexOf(route),
                                ),
                            ],
                            onChanged: (int value) {
                              //setState(() {
                              _selectedDriverPosition = value;
                              if (_selectedDriverPosition > 0) {
                                getRouteForMap(routeList[_selectedRoutePosition], driverList[_selectedDriverPosition]);
                              }

                              // getDriversByRoute(routeList[_selectedRoutePosition]);
                              //});
                            },
                          ),
                        )),
                  // Date picker commented by ram kumawat
                  InkWell(
                    onTap: () async {
                      final DateTime picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
                      setState(() {
                        selectedDate = formatter.format(picked);
                        showDatedDate = formatterShow.format(picked);

                        if (_selectedDriverPosition > 0 && _selectedRoutePosition > 0) {
                          getRouteForMap(routeList[_selectedRoutePosition], driverList[_selectedDriverPosition]);
                        }
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 10.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white,
                          //border: Border.all(color: Colors.grey[400]),
                          boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: Offset(0, 4), color: Colors.grey[300])]),
                      child: Row(
                        children: [Text(showDatedDate), Spacer(), Icon(Icons.calendar_today_sharp)],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
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
    _apiCallFram.getDataRequestAPI("${WebConstant.GetPHARMACYDriverListByRoute}$parms", accessToken, context).then((response) async {
      // ProgressDialog(context).hide();
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
          setState(() {
            driverList.addAll(driverModelFromJson(response.body));
          });
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }

  Future<void> getRouteForMap(RouteList route, DriverModel driverList1) async {
    pharmacyRouteList.clear();
    // ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    String parms = "${WebConstant.GET_ROUTE_FOR_PHARMACY}?routeId=${route.routeId ?? ""}&date=${selectedDate}&driverID=${driverList1.driverId}";
    // print(parms);
    _apiCallFram.getDataRequestAPI("$parms", accessToken, context).then((response) async {
      // ProgressDialog(context).hide();
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
          setState(() {
            pharmacyRouteList = routeForPharmacyFromJson(response.body);
            // print(pharmacyRouteList);
            // List<RouteForPharmacy> tempPharmacyRouteList = new List(25);
            // if (pharmacyRouteList.length > 25){
            //   // for (int i=0; i<25; i++){
            //   //
            //   // }
            //   pharmacyRouteList.take(25);
            //   // tempPharmacyRouteList.addAll(pharmacyRouteList);
            //    print(tempPharmacyRouteList.length);
            //
            //    for (var data in pharmacyRouteList){
            //      tempPharmacyRouteList.length > 25 ? break : tempPharmacyRouteList.add(data);
            //    }
            //
            // }
            if (pharmacyRouteList.length != null && pharmacyRouteList.length > 0) {
              // print(routeList[_selectedRoutePosition].routeId);
              // List<RouteForPharmacy> pharmacyRouteList1 =[];
              /*for(int i=0; i < pharmacyRouteList.length; i++){
                if(i<30)
                  pharmacyRouteList1.add(pharmacyRouteList[i]);
              }*/
              //Navigator.push(context, MaterialPageRoute(builder: (context) => BranchParcelAndMapParentScreen(pharmacyRouteList,routeList[_selectedRoutePosition].routeId)));
              final DateTime now = DateTime.now();
              bool isToday = selectedDate == formatter.format(now) ? true : false;
              Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayRoute(routeList[_selectedRoutePosition].routeId, driverList[_selectedDriverPosition].driverId, selectedDate, isToday))).then((value) {
                _selectedRoutePosition = 0;
                _selectedDriverPosition = 0;
                driverList.clear();
                setState(() {});
              });
            } else {
              Fluttertoast.showToast(msg: "No data found");
            }
          });
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // print(_);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
  }
}

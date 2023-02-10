// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel_business/model/nursing_home_model.dart';
import 'package:pharmdel_business/model/nursing_home_orders_model.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/bulk_scan_order_detail.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/scan_prescription.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api_call_fram.dart';
import '../../data/web_constent.dart';
import '../../model/driver_model.dart';
import '../../model/pmr_model.dart';
import '../../model/route_model.dart';
import '../../model/tote_model.dart';
import '../../provider/fetchDataProvider.dart';
import '../../util/colors.dart';
import '../../util/connection_validater.dart';
import '../../util/custom_loading.dart';
import '../../util/log_print.dart';
import '../../util/sentryExeptionHendler.dart';
import '../login_screen.dart';
import 'delivery_schedule.dart';

class BulkScanScreen extends StatefulWidget {
  const BulkScanScreen({Key key}) : super(key: key);

  @override
  State<BulkScanScreen> createState() => _BulkScanScreenState();
}

class _BulkScanScreenState extends State<BulkScanScreen> implements callGetOrderApi {
  List<RouteList> routeList = [];
  String accessToken, userType;
  int _selectedRoutePosition = 0;
  List<DriverModel> driverList = [];
  List<nursingHome> nursingHomeList = [];
  List<toteData> toteList = [];
  int _selectedDriverPosition = 0;
  int _selectedNursingPosition = 0;
  int _selectedTotePosition = 0;
  String selectedDate = "";
  String showDatedDate = "";
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');
  ApiCallFram _apiCallFram = ApiCallFram();
  // List<bool> cdvalue = [];
  List<NursingOrdersData> pmrList = [];
  // List<bool> fridgevalue = [];

  @override
  void initState() {
    final DateTime now = DateTime.now();

    selectedDate = formatter.format(now);
    showDatedDate = formatterShow.format(now);
    init();
    super.initState();
  }
  @override
  void isCallApi(bool callApi){
    if(callApi){
      getNursingOrders();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          backgroundColor: materialAppThemeColor,
          title: Text("Bulk Scan",style: TextStyle(color: appBarTextColor),),
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: Icon(Icons.arrow_back,color: appBarTextColor,),
              ))),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: DropdownButton(
                                value: _selectedRoutePosition,
                                items: [
                                  for (RouteList route in routeList)
                                    DropdownMenuItem(
                                      child: Text("${route.routeName}",
                                          style: TextStyle(color: Colors.black87)),
                                      value: routeList.indexOf(route),
                                    ),
                                ],
                                onChanged: (int value) {
                                  //setState(() {
                                  _selectedRoutePosition = value;
                                  if (_selectedRoutePosition > 0) {
                                    _selectedDriverPosition = 0;
                                    getDriversByRoute(
                                        routeList[_selectedRoutePosition]);
                                  }
                                },
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    if (driverList.isNotEmpty)
                      Flexible(
                        flex: 1,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            // padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,

                            ),
                            child:  DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _selectedDriverPosition,
                                items: [
                                  for (DriverModel route in driverList)
                                    DropdownMenuItem(
                                      child: Text("${route.firstName}",
                                          style: TextStyle(color: Colors.black87)),
                                      value: driverList.indexOf(route),
                                    ),
                                ],
                                onChanged: (int value) {
                                  setState(() {
                                    _selectedDriverPosition = value;
                                  });
                                },
                              ),
                            )),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          final DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day),
                              lastDate: DateTime(2101));
                          if(picked != null)
                            setState(() {
                              selectedDate = formatter.format(picked);
                              showDatedDate = formatterShow.format(picked);
                              if(_selectedTotePosition != 0 && _selectedNursingPosition != 0)
                                getNursingOrders();
                            });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          padding: const EdgeInsets.only(left: 10.0, top : 10,bottom:10,right: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Text(showDatedDate),
                              Spacer(),
                              Icon(Icons.calendar_today_sharp)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,

                          ),
                          child:  DropdownButtonHideUnderline(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: DropdownButton(
                                value: _selectedNursingPosition,
                                items: [
                                  for (nursingHome route in nursingHomeList)
                                    DropdownMenuItem(
                                      child: Text("${route.nursingHomeName}",
                                          style: TextStyle(color: Colors.black87)),
                                      value: nursingHomeList.indexOf(route),
                                    ),
                                ],
                                onChanged: (int value) {
                                  setState(() {
                                    _selectedNursingPosition = value;
                                  });
                                  if(_selectedNursingPosition != 0) {
                                    _selectedTotePosition = 0;
                                    getTote();
                                  }
                                },
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                if(toteList != null && toteList.isNotEmpty)
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,

                      ),
                      child:  DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedTotePosition,
                          items: [
                            for (toteData tote in toteList)
                              DropdownMenuItem(
                                child: Text("${tote.boxName}",
                                    style: TextStyle(color: Colors.black87)),
                                value: toteList.indexOf(tote),
                              ),
                          ],
                          onChanged: (int value) {
                            setState(() {
                              _selectedTotePosition = value;
                              getNursingOrders();
                            });
                          },
                        ),
                      )),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 170.0),
              child: ListView.builder(
                itemCount: pmrList != null && pmrList.isNotEmpty ? pmrList.length > 0 ? pmrList.length : 0 : 0,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: pmrList.length - 1 == index ? 40.0 : 0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                                color: Colors.grey[300])
                          ]),
                      child: Card(
                        color:  Colors.white,
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: Container(

                                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                          child: FittedBox(
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                    color:
                                                    Colors.black,
                                                    fontSize: 10),
                                              )),
                                          backgroundColor:
                                          Colors.orange[400],
                                          radius: 8.0,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${pmrList[index].customerName ?? ""}",
                                            style: TextStyle(
                                                color: Colors
                                                    .black87,
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight
                                                    .w700),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            if(pmrList[index].isStorageFridge != null && pmrList[index].isStorageFridge == "t")
                                              Container(
                                                  height: 25,
                                                  padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10.0),
                                                    color: Colors
                                                        .blue,
                                                  ),
                                                  child: Center(child: Image.asset("assets/fridge.png", height: 21,color: Colors.white,))
                                              ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            if(pmrList[index].isControlledDrugs != null && pmrList[index].isControlledDrugs == "t")
                                              Container(
                                                height: 25,
                                                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      10.0),
                                                  color: Colors
                                                      .red,
                                                ),
                                                child: Center(
                                                  child: new Text(
                                                    'C.D.',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        PopupMenuButton(
                                            padding: EdgeInsets.zero,
                                            child: Icon(Icons.more_vert,color: Colors.grey[400],),
                                            itemBuilder: (_) => [
                                              new PopupMenuItem(
                                                  enabled: true,
                                                  height: 30.0,
                                                  onTap: (){},
                                                  child: StatefulBuilder(
                                                    builder: ((context, setStat) {
                                                      return Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: (){
                                                              pmrList[index].isCD = !pmrList[index].isCD;
                                                              updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                              setStat((){});
                                                              setState(() {});
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              color: Colors.red,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Checkbox(
                                                                    visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                                                    value: pmrList[index].isCD,
                                                                    onChanged: (newValue) {
                                                                      setState(() {
                                                                        pmrList[index].isCD = newValue;
                                                                      });
                                                                      setStat((){});
                                                                      updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                  new Text(
                                                                    'C. D.',
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 1,
                                                            margin: EdgeInsets.only(left: 4.0, right: 4.0),
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.black)
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: (){
                                                              pmrList[index].isFridge = !pmrList[index].isFridge;
                                                              updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                              setStat((){});
                                                              setState(() {});
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              color: Colors.blue,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Checkbox(
                                                                    visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                                                    value: pmrList[index].isFridge,
                                                                    onChanged: (newValue) {
                                                                      setState(() {
                                                                        pmrList[index].isFridge = newValue;
                                                                      });
                                                                      setStat((){});
                                                                      updateOrders(pmrList[index].orderId, pmrList[index].isCD, pmrList[index].isFridge);
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 12.0),
                                                                    child: Image.asset("assets/fridge.png", height: 21,color: Colors.white,),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 1,
                                                            margin: EdgeInsets.only(left: 4.0, right: 4.0),
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.black)
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: (){
                                                              cancelOrder(pmrList[index].orderId);
                                                              Navigator.pop(context);
                                                            },
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  Icons.cancel_outlined,
                                                                ),
                                                                SizedBox(
                                                                  width: 5.0,
                                                                ),
                                                                Text("Cancel")
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }),
                                                  )
                                              ),
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
                                            ]
                                        ),
                                      ],
                                    ),
                                    if(index == 0)
                                      SizedBox(
                                        height: 5,
                                      ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            "${pmrList[index].address ?? ""}",
                                            style: TextStyle(
                                                color: Colors
                                                    .black87,
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight
                                                    .w300),
                                            overflow: TextOverflow
                                                .ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
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
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: "btn1",
              backgroundColor: Colors.orange,
              label: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    Text("Scan Rx", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              onPressed: () async {
                var isInternetAval = await ConnectionValidator().check();
                if(!isInternetAval){
                  return;
                }
                if(_selectedRoutePosition == 0){
                  Fluttertoast.showToast(msg: "Please select route");
                } else if(_selectedDriverPosition == 0){
                  Fluttertoast.showToast(msg: "Please select driver");
                } else if(_selectedNursingPosition == 0){
                  Fluttertoast.showToast(msg: "Please select nursing home");
                } else if(_selectedTotePosition == 0){
                  Fluttertoast.showToast(msg: "Please select tote");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Scan_Prescription(
                                isAssignSelf: true,
                                pmrList: [],
                                isBulkScan: true,
                                callApi: this,
                                bulkScanDate: selectedDate,
                                routeId: routeList[_selectedRoutePosition].routeId.toString(),
                                driverId: driverList[_selectedDriverPosition].driverId.toString(),
                                toteId: toteList[_selectedTotePosition].id.toString(),
                                nursingHomeId: nursingHomeList[_selectedNursingPosition].id.toString(),
                                prescriptionList: [],
                                type: "5",
                              )));
                }
              },
            ),
            FloatingActionButton.extended(
              heroTag: "btn2",
              backgroundColor: Colors.blue,
              label: Column(
                children: [

                  Text("Close Tote", style: TextStyle(color: Colors.white),)
                ],
              ),
              onPressed: () async {
                var isInternetAval = await ConnectionValidator().check();
                if(!isInternetAval){
                  return;
                }
                if(pmrList != null && pmrList.isNotEmpty){
                  Navigator.of(context).pop();
                }else{
                  Fluttertoast.showToast(msg: "Punch some deliveries");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> updateOrders(orderId, isCd, isFridge) async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    String url =  WebConstant.UPDATE_NURSING_ORDER;
    PrintLog.printLog(url);
    PrintLog.printLog(accessToken);
    Map<String, dynamic> parms = {
      "orderId":orderId,
      "storage_type_cd": isCd ? "t" : "f",
      "storage_type_fr": isFridge ? "t" : "f",
    };
    _apiCallFram
        .postDataAPI(
        url,
        accessToken,
        parms,
        context)
        .then((response) async {
      // await ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null &&
            response.body != null &&
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
          // PrintLog.printLog("aaa" + json.decode(response.body).toString());
          getNursingOrders();
        }
      } catch (_,stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // await ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        PrintLog.printLog(_);
        Fluttertoast.showToast(msg: "Oops!! Something went wrong.");
      }
    });
  }
  Future<void> cancelOrder(orderId) async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    String url =  WebConstant.DELETE_NURSING_ORDER+"?OrderId=$orderId";
    PrintLog.printLog(url);
    PrintLog.printLog(accessToken);
    _apiCallFram
        .getDataRequestAPI(
        url,
        accessToken,
        context)
        .then((response) async {
      // await ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null &&
            response.body != null &&
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
          PrintLog.printLog(response.body.toString());
          getNursingOrders();
        }
      } catch (_,stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // await ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        PrintLog.printLog(_);
        Fluttertoast.showToast(msg: "Oops!! Something went wrong.");
      }
    });
  }
  Future<void> getNursingOrders() async {
    pmrList.clear();
    setState(() {});
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    String url =  WebConstant.DELIVERY_LIST_URL+"?routeId=${routeList[_selectedRoutePosition].routeId}&dateTime=$selectedDate" + "&driverId=${driverList[_selectedDriverPosition].driverId}&nursing_home_id=${nursingHomeList[_selectedNursingPosition].id}&tote_box_id=${toteList[_selectedTotePosition].id}";
    PrintLog.printLog(url);
    PrintLog.printLog(accessToken);
    _apiCallFram
        .getDataRequestAPI(
        url,
        accessToken,
        context)
        .then((response) async {
      // await ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null &&
            response.body != null &&
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
          PrintLog.printLog("aaa" + json.decode(response.body).toString());
          GetNursingHomeOrders data = GetNursingHomeOrders.fromJson(json.decode(response.body));
          if(data != null && data.list != null && data.list.isNotEmpty){
            PrintLog.printLog(data.list.length);
            // data.list.forEach((element) {
            //   if(element.deliveryStatus != 6){
            pmrList.addAll(data.list);
            //   }
            // });
            pmrList.forEach((element) {
              if(element.isControlledDrugs != null && element.isControlledDrugs =="t")
                element.isCD = true;
              else
                element.isCD = false;
              if(element.isStorageFridge != null && element.isStorageFridge =="t")
                element.isFridge = true;
              else
                element.isFridge = false;
            });
            setState(() {});
          }
        }
      } catch (_,stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // await ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        PrintLog.printLog(_);
        Fluttertoast.showToast(msg: "Oops!! Something went wrong.");
      }
    });
  }
  Future<void> getRoutes() async {
    routeList.clear();
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    RouteList route = RouteList();
    route.routeName = "Select Route";
    routeList.add(route);
    String url = userType == 'Pharmacy' || userType == "Pharmacy Staff"
        ? WebConstant.GET_ROUTE_URL_PHARMACY
        : WebConstant.GET_ROUTE_URL;
    PrintLog.printLog(url);
    PrintLog.printLog(accessToken);
    _apiCallFram
        .getDataRequestAPI(
        url,
        accessToken,
        context)
        .then((response) async {
      getNursingHome();

      try {
        if (response != null &&
            response.body != null &&
            response.body == "Unauthenticated") {
          Fluttertoast.showToast(msg: "Authentication Failed. Login again");
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          prefs.remove('userId');
          prefs.remove('name');
          prefs.remove('email');
          prefs.remove('mobile');
          prefs.remove('route_list');
          // await ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              ModalRoute.withName('/login_screen'));
          return;
        }
        if (response != null) {
          PrintLog.printLog(response.body);
          RouteModel model = routeModelFromJson(response.body);
          setState(() {
            routeList.addAll(model.routeList);
          });
        }
      } catch (_,stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // await ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        PrintLog.printLog(_);
        Fluttertoast.showToast(msg: "Oops!! Something went wrong.");
      }
    });
  }

  Future<void> getTote() async {
    toteList.clear();
    if(_selectedTotePosition == 0){
      pmrList.clear();
      setState(() {});
    }
    // ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    toteData tote = toteData();
    tote.id = 0;
    tote.boxName = "Select Tote";
    tote.boxNo = 0;
    toteList.add(tote);
    String url = "${WebConstant.GET_TOTE + "${nursingHomeList[_selectedNursingPosition].id ?? 0}"}";
    PrintLog.printLog(url);
    PrintLog.printLog(accessToken);
    _apiCallFram
        .getDataRequestAPI(
        url,
        accessToken,
        context)
        .then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null &&
            response.body != null &&
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
          PrintLog.printLog(response.body);
          toteModel model = toteModel.fromJson(json.decode(response.body));
          if(model.error != true) {
            setState(() {
              toteList.addAll(model.data);
            });
          }
        }
      } catch (_,stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        PrintLog.printLog(_);
        Fluttertoast.showToast(msg: "Oops!! Something went wrong.");
      }
    });
  }


  void getNursingHome() {
    nursingHomeList.clear();
    nursingHome route = nursingHome();
    route.nursingHomeName = "Select Nursing Home";
    route.id = 0;
    nursingHomeList.add(route);
    String url = WebConstant.GET_NURSING_HOME;
    PrintLog.printLog(url);
    PrintLog.printLog(accessToken);
    _apiCallFram
        .getDataRequestAPI(
        url,
        accessToken,
        context)
        .then((response) async {
      // await ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null &&
            response.body != null &&
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
          PrintLog.printLog(response.body);
          nursingHomeModel model = nursingHomeModel.fromJson(json.decode(response.body));
          if(model.error != true) {
            setState(() {
              nursingHomeList.addAll(model.data);
            });
          }
        }
      } catch (_,stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // await ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        PrintLog.printLog(_);
        Fluttertoast.showToast(msg: "Oops!! Something went wrong.");
      }
    });
  }

  Future<void> getDriversByRoute(RouteList route) async {
    await CustomLoading().showLoadingDialog(context, true);
    driverList.clear();
    // ProgressDialog(context, isDismissible: false).show();
    DriverModel driverModel = new DriverModel();
    driverModel.driverId = 0;
    driverModel.firstName = "Select Driver";
    driverList.add(driverModel);
    String parms = "?routeId=${route.routeId ?? ""}";
    _apiCallFram
        .getDataRequestAPI("${WebConstant.GetPHARMACYDriverListByRoute}$parms",
        accessToken, context)
        .then((response) async {
      // await ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null &&
            response.body != null &&
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
          setState(() {
            driverList.addAll(driverModelFromJson(response.body));
          });
        }
      } catch (_,stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // await ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        Fluttertoast.showToast(msg: "Oops!! Something went wrong.");
      }
    });
  }

  void init() async{
    await SharedPreferences.getInstance().then((value) async {
      accessToken = await value.getString(WebConstant.ACCESS_TOKEN);
      userType = await value.getString(WebConstant.USER_TYPE) ?? "";
      getRoutes();
    });
  }
}

abstract class callGetOrderApi{
  void isCallApi(bool callApi);
}
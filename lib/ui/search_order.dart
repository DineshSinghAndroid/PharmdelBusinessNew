// @dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../model/exemptionList.dart';
import '../util/custom_color.dart';
import 'branch_admin_user_type/DetailScreen.dart';

class DeliverySearchList extends StatefulWidget {
  final Function function;
  final String routeS;
  final String routeID;
  final String selectedDateComman;
  final String driverId;

  DeliverySearchList({this.function, this.routeS, this.routeID, this.selectedDateComman, this.driverId});

  DeliverySearchListState createState() => DeliverySearchListState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class DeliverySearchListState extends State<DeliverySearchList> {
  BuildContext _ctx;
  bool _isLoading = true;
  bool showList = false;
  bool noData = false;
  String userId, token;
  bool showReset = false;
  String selectedDate;

  //ProgressDialog progressDialog;
  var notdeliveryColor = const Color(0xFFE66363);
  var deliverColor = const Color(0xFF0071BC);
  var deliveredColor = const Color(0xFF4AC66E);
  var yetToStartColor = const Color(0xFFF8A340);

  // List<GroupModel> list = new List<GroupModel>();
  List<dynamic> allList = new List();
  List<dynamic> list = new List();
  var totalCount = 0;
  var completedCount = 0;
  var notDeliveredCount = 0;
  var yetToStartCount = 0;

  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);
  bool todaySelected = false;
  bool tomorrowSelected = false;
  bool otherDateSelected = false;

  bool smsPermission = false;

  double _size = 1.0;
  var searchController = new TextEditingController();

  String filtterText = "";

  List<Exemptions> exemptionList = [];

  void grow() {
    setState(() {
      _size += 0.1;
    });
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    getDeliveryList();
  }

  methodInParent() => {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    /* progressDialog = new ProgressDialog(context);
    progressDialog.style(
        message: "Please wait...",
        borderRadius: 4.0,
        backgroundColor: Colors.white);*/
    const PrimaryColor = const Color(0xFFffffff);
    const gray = const Color(0xFFEEEFEE);
    const titleColor = const Color(0xFF151026);
    const blue = const Color(0xFF2188e5);
    double c_width = MediaQuery.of(context).size.width * 0.5;
    return SafeArea(
      child: Scaffold(
          backgroundColor: gray,
          appBar: AppBar(
            //toolbarHeight: 110, // Set this height
            backgroundColor: Colors.white,
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: Container(
              margin: const EdgeInsets.only(left: 30),
              color: Colors.white,
              child: Column(children: <Widget>[
                Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: searchController,
                      onChanged: (cha) {
                        filtterText = cha;
                        addFillter();
                      },
                      autofocus: true,
                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), filled: true, fillColor: Colors.white, border: InputBorder.none, hintStyle: new TextStyle(color: Colors.black38), hintText: "Search..."),
                    )),
              ]),
            ),
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
                CustomScrollView(slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      noData
                          ? Container(
                              height: 200,
                              child: Center(
                                child: Text(
                                  'No Order Available',
                                  style: TextStyle(color: Colors.black38, fontSize: 28),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ]),
                  ),
                  if (!noData)
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
                  _getSlivers(list, context, c_width)
                ]),
              ],
            ),
          )),
    );
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
                child: new Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 0, left: 3, right: 3),
                  child: new Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Column(
                              children: [
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Text(
                                        'Name ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      Flexible(
                                        child: new Text(
                                          list[index]['customerName'] ?? "",
                                          style: TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                      ),
                                      if (list[index]['pmr_type'] != null && (list[index]['pmr_type'] == "titan" || list[index]['pmr_type'] == "nursing_box") && list[index]['pr_id'] != null && list[index]['pr_id'].isNotEmpty)
                                        Text(
                                          '(P/N : ${list[index]['pr_id'] ?? ""}) ',
                                          style: TextStyle(color: CustomColors.pnColor),
                                        ),
                                      if (list[index]['isCronCreated'] == "t") Image.asset("assets/automatic_icon.png", height: 14, width: 14),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      new Text(
                                        'Address ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      /* Text(
                                  list[index]['address'],
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                ),*/
                                      new Container(
                                        width: c_width,
                                        child: new Text(
                                          list[index]['address'],
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                      if (list != null && list.isNotEmpty && list[index]["alt_address"] != null && list[index]["alt_address"] != "" && list[index]["alt_address"] == "t")
                                        Image.asset(
                                          "assets/alt-add.png",
                                          height: 18,
                                          width: 18,
                                        )
                                    ],
                                  ),
                                ),
                                // new Padding(
                                //   padding: const EdgeInsets.all(4),
                                //   child: new Row(
                                //     children: [
                                //       new Text(
                                //         widget.routeS != null
                                //             ? "Route: " + widget.routeS
                                //             : "",
                                //         style: TextStyle(
                                //             fontSize: 14, color: Colors.grey),
                                //       ),
                                //       // new Text(
                                //       //   list[index]['customerName'],
                                //       //   style: TextStyle(
                                //       //       fontSize: 14, color: Colors.black),
                                //       // ),
                                //     ],
                                //   ),
                                // ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // if (list[index]['surgeryName'] != null &&
                                    //     list[index]['surgeryName'] != "")
                                    //   Flexible(
                                    //     flex: 5,
                                    //     child: Container(
                                    //         decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(
                                    //                 Radius.circular(5)),
                                    //             color: Colors.blueAccent,
                                    //             boxShadow: [
                                    //               BoxShadow(
                                    //                   spreadRadius: 1,
                                    //                   blurRadius: 10,
                                    //                   offset: Offset(0, 4),
                                    //                   color: Colors.grey[300])
                                    //             ]),
                                    //         padding: EdgeInsets.only(
                                    //             left: 10, right: 10, bottom: 2),
                                    //         child: Text(
                                    //             list[index]['surgeryName'] ??
                                    //                 "",
                                    //             maxLines: 2,
                                    //             style: TextStyle(
                                    //                 color: Colors.white))),
                                    //   ),
                                    // if (list[index]['surgeryName'] != null &&
                                    //     list[index]['surgeryName'] != "")
                                    //   SizedBox(
                                    //     width: 10,
                                    //   ),
                                    if (list[index]['serviceName'] != null && list[index]['serviceName'] != "")
                                      Flexible(
                                        flex: 5,
                                        child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.redAccent, boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: Offset(0, 4), color: Colors.grey[300])]),
                                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 2),
                                            child: Text(
                                              list[index]['serviceName'] ?? "",
                                              maxLines: 2,
                                              style: TextStyle(color: Colors.white),
                                            )),
                                      ),
                                    if (list[index]['serviceName'] != null && list[index]['serviceName'] != "")
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                    if (list[index]['parcel_box_name'] != null && list[index]['parcel_box_name'] != "" && list[index]['deliveryStatusDesc'] == "PickedUp" || list[index]['deliveryStatusDesc'] == WebConstant.Status_out_for_delivery)
                                      Flexible(
                                        flex: 5,
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
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
                            flex: 4,
                          ), //deliveryDate: 2020-03-05T00:00:00
                          new Expanded(
                            flex: 1,
                            child: new Column(
                              children: <Widget>[
                                if (list[index]['deliveryStatus'].toString() == "1" || list[index]['deliveryStatus'].toString() == "2" || list[index]['deliveryStatus'].toString() == "3")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: deliverColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus'].toString() == "4")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: yetToStartColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus'].toString() == "5")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: deliveredColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(color: Colors.white),
                                          child: Image.asset(
                                            'assets/delivery_done.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus'].toString() == "6" || list[index]['deliveryStatus'].toString() == "9")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: notdeliveryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                /*else
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: notdeliveryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))*/
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
        childCount: myList.length,
      ),
    );
  }

  void _onTileClicked(int index) {
    /* if (smsPermission != true) {
      requestStoragePermission();
    } else {*/
    //Navigator.pop(context, false);
    logger.i("status1: ${list[index]['deliveryStatusDesc'].toString()}");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailScreen(
              name: list[index]['customerName'].toString(),
              id: list[index]['orderId'].toString(),
              bagSize: list[index]['bagSize'],
              subsId: list[index]['subs_id'] != null ? list[index]['subs_id'].toString() : "",
              delCharge: list[index]['del_charge'] != null && list[index]['del_charge'] != "" ? list[index]['del_charge'].toString() : "",
              rxCharge: list[index]['rx_charge'] != null ? double.tryParse(list[index]['rx_charge'].toString()) : 0,
              rxInvoice: list[index]['rx_invoice'] != null && list[index]['rx_invoice'] != "" ? int.tryParse(list[index]['rx_invoice'].toString()) : 0,
              exemption: list[index]['exemption'],
              paymentStatus: list[index]['paymentStatus'],
              driverId: widget.driverId,
              exemptionList: exemptionList != null && exemptionList.isNotEmpty ? exemptionList : [],
              address: list[index]['address'].toString(),
              parcelBoxName: list[index]['parcel_box_name'].toString(),
              deliveryNote: list[index]['deliveryNote'] ?? "",
              deliveryStatus: list[index]['deliveryStatus'].toString(),
              deliveryDate: list[index]['deliveryDate'].toString(),
              deliveryId: list[index]['deliveryId'].toString(),
              mobile: list[index]['customerMobileNumber'] ?? "",
              deliveryStatusDesc: list[index]['deliveryStatusDesc'] ?? "",
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
              function: reload)),
    );
    //}
  }

  void reload() {
    widget.function();
    getDeliveryList();
  }

  Future<Map<String, Object>> getDeliveryList() async {
    setState(() => _isLoading = true);
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};

    String url = WebConstant.DELIVERY_LIST_URL + "?routeId=${widget.routeID}&dateTime=${widget.selectedDateComman}";
    // logger.i("tesss " + url);
    // logger.i("tesss " + token);
    logger.i(url);
    final response = await http.get(Uri.parse(url), headers: headers);
    setState(() => _isLoading = false);
    if (response.statusCode == 200) {
      Map<String, Object> data = json.decode(response.body);
      logger.i(response.body);
      List<dynamic> homelist = data['list'];
      ExemptionList1 exemptions = exemptionList1FromJson(response.body);
      // print(homelist);
      if (homelist.length > 0) {
        // setState(() {
        if (exemptions != null && exemptions.exemptions.length > 0) {
          exemptionList.addAll(exemptions.exemptions);
        }
        allList = homelist;
        list = homelist;
        showList = true;
        // });
        addFillter();
      } else {
        setState(() {
          showList = false;
        });
        _showSnackBar("No Data Found");
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

  void addFillter() {
    if (filtterText.isNotEmpty) {
      List<dynamic> lll = List();
      for (int i = 0; i < allList.length; i++) {
        if (allList[i]['customerName'].toString().toLowerCase().trim().contains(filtterText.toString().toLowerCase().trim())) {
          lll.add(allList[i]);
        }
      }
      setState(() {
        list = lll;
        list.length > 0 ? noData = false : noData = true;
      });
    } else {
      setState(() {
        list = allList;
        list.length > 0 ? noData = false : noData = true;
      });
    }
  }
}

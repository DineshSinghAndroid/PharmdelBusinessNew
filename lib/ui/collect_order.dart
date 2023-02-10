// @dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/assign_to_shelf_model.dart';
import 'package:pharmdel_business/presenter/delivery_list_presenter.dart';
import 'package:pharmdel_business/presenter/delivery_update_presenter.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/calling_util.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'branch_admin_user_type/RxDetailWidget.dart';
import 'branch_admin_user_type/assign_to_self.dart';
import 'driver_user_type/signature.dart';

class CollectList extends StatefulWidget {
  //final String routeS;
  final String type;

  CollectList({this.type});

  CollectListState createState() => CollectListState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class CollectListState extends State<CollectList> {
  BuildContext _ctx;
  bool _isLoading = false;
  bool showList = false;
  bool noData = true;
  String userId, token;
  final ScrollController _scrollController = ScrollController();
  DeliveryListPresenter _presenter;
  bool showReset = false;
  String selectedDate;

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
  bool isApiLoading = false;

  ApiCallFram _apiCallFram = ApiCallFram();

  void grow() {
    setState(() {
      _size += 0.1;
    });
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    // getDeliveryList();
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
    // progressDialog = new ProgressDialog(context);
    // progressDialog.style(
    //     message: "Please wait...",
    //     borderRadius: 4.0,
    //     backgroundColor: Colors.white);
    if (isApiLoading) getDeliveryList(searchController.text.toString().trim());
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
            // backgroundColor: Colors.blue[200],
            leading: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back),
                  ),
                )),
            // leading: new IconButton(
            //   icon: new Icon(
            //     Icons.arrow_back,
            //     color: Colors.blueGrey,
            //   ),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
            flexibleSpace: Container(
              margin: const EdgeInsets.only(left: 30),
              color: Colors.transparent,
              child: Column(children: <Widget>[
                Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: searchController,
                      cursorColor: Colors.white,
                      onChanged: (cha) {
                        if (cha.isNotEmpty) {
                          getDeliveryList(cha.toString());
                          /* List<dynamic> lll = List();
                          for (int i = 0; i < allList.length; i++) {
                            if (allList[i]['customerName']
                                .toString()
                                .toLowerCase()
                                .trim()
                                .contains(
                                    cha.toString().toLowerCase().trim())) {
                              lll.add(allList[i]);
                            }
                          }
                          setState(() {
                            list = lll;
                          });*/
                        } else {
                          setState(() {
                            list = allList;
                          });
                        }
                      },
                      //autofocus: true,
                      decoration: InputDecoration(focusColor: Colors.white, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), filled: true, fillColor: Colors.transparent, border: InputBorder.none, hintStyle: new TextStyle(color: Colors.black38), hintText: "Search..."),
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
                                  style: TextStyle(color: Colors.black38, fontSize: 24),
                                ),
                              ),
                            )
                          : SizedBox(),
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
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      // Expanded(
                                      //   child:
                                      Text(
                                        'Order ID :  ',
                                        style: TextStyle(fontSize: 17, color: Colors.grey),
                                      ),
                                      //   flex: 2,
                                      // ),
                                      //Expanded(
                                      //child:
                                      Text(
                                        list[index]['lastOrderId'] != null ? list[index]['lastOrderId'].toString() : "-",
                                        style: TextStyle(fontSize: 17, color: blue),
                                      ),
                                      // flex: 5,
                                      //)
                                      Spacer(),
                                      if (list[index]['isCronCreated'] != null && list[index]['isCronCreated'] == "t") Image.asset("assets/automatic_icon.png", height: 14, width: 14),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Name : ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      Flexible(
                                        child: RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: list[index]['firstName'] != null ? list[index]['firstName'] + " " : "",
                                                style: TextStyle(fontSize: 14, color: Colors.black),
                                              ),
                                              new TextSpan(text: list[index]['middleName'] != null ? list[index]['middleName'] + " " : "", style: new TextStyle(fontSize: 14, color: Colors.black)),
                                              new TextSpan(text: list[index]['lastName'] != null ? list[index]['lastName'] : "", style: new TextStyle(fontSize: 14, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Expanded(
                                      //  child:
                                      Text(
                                        'Address :  ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      //   flex: 2,
                                      //),
                                      Expanded(
                                        child: new Text(list[index]['address1'] != null ? list[index]['address1'] : "N/A", textAlign: TextAlign.left),
                                      ),
                                      // Expanded(
                                      //   // child: new Container(
                                      //   //width: c_width,
                                      //   child: new Column(
                                      //     children: <Widget>[
                                      //       new Text(
                                      //           list[index]['address1'] != null
                                      //
                                      //               ? list[index]['address1']
                                      //               : "N/A",
                                      //           textAlign: TextAlign.left),
                                      //     ],
                                      //     // ),
                                      //   ),
                                      //   flex: 0,
                                      // )
                                    ],
                                  ),
                                ),
                                // new Padding(
                                //   padding: const EdgeInsets.all(4),
                                //   child: new Row(
                                //     children: [
                                //       Expanded(child: new Text(
                                //         'Address : ',
                                //         style: TextStyle(
                                //             fontSize: 14, color: Colors.grey),
                                //
                                //       )
                                //       )
                                //       ,
                                //       new Expanded(
                                //         //width: c_width,
                                //         child: new Text(
                                //           list[index]['address1'] != null
                                //
                                //               ? list[index]['address1']
                                //                   : "N/A",
                                //           textAlign: TextAlign.left,
                                //           //overflow: TextOverflow.ellipsis,
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Contact Number : ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        list[index]['contactNumber'] != null ? list[index]['contactNumber'] : "N/A",
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Shelf Name : ',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      Flexible(
                                        child: new Text(
                                          list[index]['rackNo'] != null ? list[index]['rackNo'] : "N/A",
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                /*new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Email : ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        list[index]['email'] != null
                                            ? list[index]['email']
                                            : "-",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Landline Number : ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        list[index]['landlineNumber'] != null
                                            ? list[index]['landlineNumber']
                                            : "-",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        'Tag : ',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      new Text(
                                        "Collection",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),*/
                                /*new Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: new Row(
                                    children: [
                                      new Text(
                                        widget.routeS != null ? "Route: " + widget.routeS: "",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                     */ /* new Text(
                                        list[index]['customerName'] != null ? list[index]['customerName']: " ",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),*/ /*
                                    ],
                                  ),
                                ),*/
                              ],
                            ),
                            flex: 4,
                          ), //deliveryDate: 2020-03-05T00:00:00
                          /* new Expanded(
                            flex: 1,
                            child: list[index]['deliveryStatus'] != null ? Column(
                              children: <Widget>[
                                if (list[index]['deliveryStatus'].toString() ==
                                        "1" ||
                                    list[index]['deliveryStatus'].toString() ==
                                        "7")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: deliverColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus']
                                        .toString() ==
                                    "2")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: yetToStartColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/not_delivery.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus']
                                        .toString() ==
                                    "3")
                                  new Container(
                                      //color: notdeliveryColor,
                                      margin: const EdgeInsets.all(3.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: deliveredColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: new IconTheme(
                                          data: new IconThemeData(
                                              color: Colors.white),
                                          child: Image.asset(
                                            'assets/delivery_done.png',
                                            width: 50,
                                            height: 50,
                                          )))
                                else if (list[index]['deliveryStatus']
                                            .toString() ==
                                        "4" ||
                                    list[index]['deliveryStatus'].toString() ==
                                        "5")
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
                                          )))
                                */ /*else
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
                                          )))*/ /*
                              ],
                            ):SizedBox(),
                          )*/
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
    // if (smsPermission != true) {
    //   requestStoragePermission();
    // } else {
    //Navigator.pop(context, false);
    if (list[index]['lastOrderId'] != null) {
      String name = "";
      if (list[index]['firstName'] != null) name = list[index]['firstName'].toString() + " ";
      if (list[index]['middleName'] != null) name = name + list[index]['middleName'].toString() + " ";
      if (list[index]['lastName'] != null) name = name + list[index]['lastName'].toString();

      if (widget.type == "Shelf") {
        getOrderDetails(list[index]['lastOrderId']);
      } else {
        //Comment by DMK removed assign self popu

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CollectionDetailScreen(
                    customerId: list[index]['customerId'].toString(),
                    lastOrderId: list[index]['lastOrderId'].toString(),
                    name: name,
                    address: list[index]['address1'] != null ? list[index]['address1'].toString() : "N/A",
                    paymentExemption: list[index]['paymentExemption'] != null ? list[index]['paymentExemption'].toString() : "N/A",
                    type: widget.type,
                    function: reload,
                    isControlledDrugs: list[index]['isControlledDrugs'],
                    isStorageFridge: list[index]['isStorageFridge'],
                  )),
        ).then((value) => isApiLoading = true);

        // if (list[index]['rackNo'] != null &&
        //     list[index]['rackNo'].toString().isNotEmpty) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => CollectionDetailScreen(
        //               customerId: list[index]['customerId'].toString(),
        //               lastOrderId: list[index]['lastOrderId'].toString(),
        //               name: name,
        //               address: list[index]['address1'] != null
        //                   ? list[index]['address1'].toString()
        //                   : "N/A",
        //               paymentExemption: list[index]['paymentExemption'] != null
        //                   ? list[index]['paymentExemption'].toString()
        //                   : "N/A",
        //               type: widget.type,
        //               function: reload,
        //               isControlledDrugs: list[index]['isControlledDrugs'],
        //               isStorageFridge: list[index]['isStorageFridge'],
        //             )),
        //   ).then((value) => isApiLoading = true);
        // } else {
        //   AlertDialog alert = AlertDialog(
        //     //title: Text("AlertDialog"),
        //     content: Text("Please Assign Shelf First then complete...."),
        //     actions: [
        //       // cancelButton,
        //       FlatButton(
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Text(
        //               "Cancel",
        //               style: TextStyle(color: Colors.black),
        //             ),
        //           ),
        //           onPressed: () {
        //             Navigator.pop(context);
        //           }),
        //
        //       FlatButton(
        //           child: Container(
        //               decoration: BoxDecoration(
        //                   border: Border.all(color: Colors.green),
        //                   shape: BoxShape.rectangle,
        //                   borderRadius:
        //                       BorderRadius.all(Radius.circular(5.00))),
        //               child: Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: Text(
        //                   "Assign Shelf",
        //                   style: TextStyle(color: Colors.green),
        //                 ),
        //               )),
        //           onPressed: () {
        //             Navigator.pop(context);
        //             getOrderDetails(list[index]['lastOrderId']);
        //           }),
        //     ],
        //   );
        //
        //   // show the dialog
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return WillPopScope(onWillPop: () async => false, child: alert);
        //     },
        //   );
        // }
      }
    } else {
      _showSnackBar("Order id not found");
    }
    //}
  }

  Future<void> getOrderDetails(dynamic orderId) async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    String url = "${WebConstant.SCAN_ASSIGN_TO_SHELF_PARCEL}?OrderId=$orderId&isScan=false";
    _apiCallFram.getDataRequestAPI(url, token, context).then((response) async {
      // ProgressDialog(context).hide();
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AssignToSelf(
                          prescriptionList: model.medicineDetails,
                          pmrList: model,
                          orderId: orderId,
                          isScan: false,
                        )));
          } else {
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: Center(child: Text('Delivery Customer', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                content: new Text("Please change setting on the web to assign collection" + "!!!"),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text("Done"),
                  ),
                ],
              ),
            );

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

  // Future<Map<String, Object>> getDetails(String lastOrderId) async {
  //
  //   ProgressDialog(context, isDismissible: false).show();
  //
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "Authorization": 'bearer $token'
  //   };
  //   Map<String, dynamic> map = {
  //     //"pharmacyId": int.parse(pharmacyId),
  //     "userId": int.parse(userId),
  //     "tokenId": token,
  //     //"branchId": int.parse(branchId),
  //     "message": "token register done"
  //   };
  //   final j = json.encode(map);
  //   final response = await http.get(
  //       WebConstant.ORDER_DETAILS_LIST_URL + lastOrderId,
  //       headers: headers);
  //   ProgressDialog(context).hide();
  //
  //   if (response.statusCode == 200) {
  //     Map<String, Object> data = json.decode(response.body);
  //     Map<String, Object> homelist = data['orderData'];
  //     print(json.decode(response.body));
  //   } else if (response.statusCode == 401) {
  //     /*final prefs = await SharedPreferences.getInstance();
  //     prefs.remove('token');
  //     prefs.remove('userId');
  //     prefs.remove('name');
  //     prefs.remove('email');
  //     prefs.remove('mobile');
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         PageRouteBuilder(pageBuilder: (BuildContext context,
  //             Animation animation, Animation secondaryAnimation) {
  //           return LoginScreen();
  //         }, transitionsBuilder: (BuildContext context,
  //             Animation<double> animation,
  //             Animation<double> secondaryAnimation,
  //             Widget child) {
  //           return new SlideTransition(
  //             position: new Tween<Offset>(
  //               begin: const Offset(1.0, 0.0),
  //               end: Offset.zero,
  //             ).animate(animation),
  //             child: child,
  //           );
  //         }),
  //             (Route route) => false);
  //     _showSnackBar('Session expired, Login again');*/
  //   } else {
  //     //_showSnackBar('Something went wrong');
  //   }
  // }

  void reload() {
    //getDeliveryList();
  }

  Future<Map<String, Object>> getDeliveryList(String name) async {
    setState(() => _isLoading = true);
    isApiLoading = false;
    // print('bearer $token');
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
    String firstName = "";
    // String lastName = "";
    // if (name.contains(" ")) {
    //   int idx = name.indexOf(" ");
    //   List parts = [
    //     name.substring(0, idx).trim(),
    //     name.substring(idx + 1).trim()
    //   ];
    //   firstName = parts[0];
    //   lastName = parts[1];
    // } else {
    //   firstName = name;
    // }
    firstName = name;

    Map<String, dynamic> map = {
      //"pharmacyId": int.parse(pharmacyId),
      "userId": int.parse(userId),
      "tokenId": token,
      //"branchId": int.parse(branchId),
      "message": "token register done"
    };
    final j = json.encode(map);
    String url = "";
    if (widget.type == "Schedule") {
      url = WebConstant.PATAINET_LIST_URL + firstName;
    } else
      url = WebConstant.COLLECTION_LIST_URL + firstName + "&type=" + widget.type;
    // print(url);
    final response = await http.get(Uri.parse(url), headers: headers);
    setState(() => _isLoading = false);
    // logger.i("aaa" + json.decode(response.body).toString());
    if (response.statusCode == 200) {
      // print(response.body);
      //  Map<String, Object> data = json.decode(json.encode(response.body));

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
      } else {
        Map<String, Object> data = json.decode(response.body);
        // print(data);
        //json.decode(response.body);
        if (data.isNotEmpty) {
          List<dynamic> homelist = data['list'];
          if (homelist != null && homelist.isNotEmpty && homelist.length > 0) {
            setState(() {
              allList.clear();
              list.clear();
              noData = false;
              allList = homelist;
              list = homelist;
              showList = true;
            });
          } else {
            setState(() {
              showList = false;
              noData = true;
            });
            // _showSnackBar("No Data Found");
          }
        }
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

class CollectionDetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.

  final String name;
  final String customerId;
  final String lastOrderId;
  final String address;
  final String paymentExemption;
  final Function function;
  final String type;
  final bool isStorageFridge;
  final bool isControlledDrugs;

  CollectionDetailScreen({this.customerId, this.lastOrderId, this.name, this.address, this.paymentExemption, this.type, this.function, this.isStorageFridge, this.isControlledDrugs});

  @override
  CollectionDetailScreenState createState() => CollectionDetailScreenState();
}

class CollectionDetailScreenState extends State<CollectionDetailScreen> implements DeliveryUpdateCotract {
  String dropdownValue = 'Completed';
  String deliveryName, remarks;
  var yetToStartColor = const Color(0xFFF8A340);
  var blue = const Color(0xFF2188e5);
  DeliveryUpdatePresenter _presenter;
  String userId, token;

  // ProgressDialog progressDialog;
  final shelfNoController = TextEditingController();
  final deliveryToController = TextEditingController();
  final remarkController = TextEditingController();
  bool isReadNote = false;
  String deliveryStatus, deliveryId, mobile, deliveryNote, recentDeliveryNote, rackNo, email;
  String isStorageFridge, isControlledDrugs, pickupTypeId;
  ApiCallFram _apiCallFram = ApiCallFram();

  String deliveryRemarks1 = "";

  bool isControlledDrugs1 = false;

  bool isFridgeNote1 = false;

  List<MedicineDetail> medicineDetails;

  //String accessToken = "";
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    deliveryToController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  void init() async {
    _presenter = new DeliveryUpdatePresenter(this);
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";

    getDetails();
  }

  Future<Map<String, Object>> getDetails() async {
    // ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);

    // progressDialog.show();
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
    Map<String, dynamic> map = {
      //"pharmacyId": int.parse(pharmacyId),
      "userId": int.parse(userId),
      "tokenId": token,
      //"branchId": int.parse(branchId),
      "message": "token register done"
    };
    // print(map);
    final j = json.encode(map);
    final response = await http.get(Uri.parse(WebConstant.PHARMACY_LIST_URL + widget.lastOrderId), headers: headers);
    //progressDialog.hide();
    if (response.statusCode != 200) {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
    } else {
      // print(WebConstant.PHARMACY_LIST_URL + widget.lastOrderId);
      // logger.i("eee" + json.decode(response.body).toString());
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
      } else if (response.statusCode == 200) {
        Map<String, Object> data = json.decode(response.body);
        if (data['status'] == true) {
          // ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
          Map<String, dynamic> homelist = data['orderData'];
          String srackNo, smobile, sdeliveryStatus, sdeliveryId, srecentDeliveryNote, sisStorageFridge, sisControlledDrugs, pTId, dNote, deliveryRemarks, demail;
          if (homelist.containsKey('rackNo') && homelist['rackNo'] != null) srackNo = homelist['rackNo'].toString();
          if (homelist.containsKey('contactNumber') && homelist['contactNumber'] != null) smobile = homelist['contactNumber'].toString();
          if (homelist.containsKey('deliveryStatus') && homelist['deliveryStatus'] != null) sdeliveryStatus = homelist['deliveryStatus'].toString();
          if (homelist.containsKey('deliveryId') && homelist['deliveryId'] != null) sdeliveryId = homelist['deliveryId'].toString();
          if (homelist.containsKey('recentDeliveryNote') && homelist['recentDeliveryNote'] != null) srecentDeliveryNote = homelist['recentDeliveryNote'].toString();
          if (homelist.containsKey('isStorageFridge') && homelist['isStorageFridge'] != null) sisStorageFridge = homelist['isStorageFridge'].toString();
          if (homelist.containsKey('isControlledDrugs') && homelist['isControlledDrugs'] != null) sisControlledDrugs = homelist['isControlledDrugs'].toString();
          if (homelist.containsKey('pickupTypeId') && homelist['pickupTypeId'] != null) pTId = homelist['pickupTypeId'].toString();
          if (homelist.containsKey('deliveryNote') && homelist['deliveryNote'] != null) dNote = homelist['deliveryNote'].toString();
          if (homelist.containsKey('email') && homelist['email'] != null) demail = homelist['email'].toString();
          if (homelist.containsKey('deliveryRemarks') && homelist['deliveryRemarks'] != null) deliveryRemarks = homelist['deliveryRemarks'].toString();

          if (homelist.containsKey('medicineDetails') && homelist['medicineDetails'] != null) {
            medicineDetails = List<MedicineDetail>.from(homelist['medicineDetails'].map((x) => MedicineDetail.fromJson(x)));
          }

          setState(() {
            if (smobile != null) mobile = smobile;
            if (srecentDeliveryNote != null) recentDeliveryNote = srecentDeliveryNote;
            if (srackNo != null) rackNo = srackNo;
            if (rackNo != null) {
              shelfNoController.text = rackNo;
            }
            if (pTId != null) {
              pickupTypeId = pTId;
            }
            if (dNote != null) {
              deliveryNote = dNote;
            }
            if (deliveryRemarks != null) {
              deliveryRemarks1 = deliveryRemarks;
            }
            if (demail != null) {
              email = demail;
            }
            if (sdeliveryStatus != null) deliveryStatus = sdeliveryStatus;
            if (sdeliveryId != null) deliveryId = sdeliveryId;
            if (sisStorageFridge != null) isStorageFridge = sisStorageFridge;
            if (sisControlledDrugs != null) isControlledDrugs = sisControlledDrugs;
            if (deliveryStatus != null) {
              // comment dmk 30-9-2021 for shwoing only completed
              // if (deliveryStatus == '1') {
              //   dropdownValue = 'Ready For Delivery';
              // }/*else if (deliveryStatus == '2') {
              //   dropdownValue = 'Out for Delivery';
              // }*/ else if (deliveryStatus == '3') {
              //   dropdownValue = 'Completed';
              // } else if (deliveryStatus == '4') {
              //   dropdownValue = 'Failed';
              // } else if (deliveryStatus == '5') {
              //   dropdownValue = 'Completed';//'Returned';
              // }
            }
          });
          // ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
        } else {
          // ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
          _showSnackBar(data['message']);
        }
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
      } else if (response.statusCode == 401) {
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        /*final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('userId');
      prefs.remove('name');
      prefs.remove('email');
      prefs.remove('mobile');
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context,
              Animation animation, Animation secondaryAnimation) {
            return LoginScreen();
          }, transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }),
              (Route route) => false);
      _showSnackBar('Session expired, Login again');*/
      } else {
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        //_showSnackBar('Something went wrong');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    deliveryToController.text = widget.name;
    init();
  }

  @override
  Widget build(BuildContext context) {
    var form = new Form(
      child: new Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: new Card(
                color: Colors.green[100],
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: new TextField(
                    controller: deliveryToController,
                    // onSaved: (val) => deliveryName = val,
                    /*validator: (val) {
                    return val.trim().isEmpty ? "Delivery to" : null;
                  },
                  initialValue: widget.name,*/
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    autofocus: false,

                    style: TextStyle(decoration: TextDecoration.none),
                    decoration: new InputDecoration(
                      labelText: "Collected by",
                      /* border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5.0)))*/
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: new Card(
                color: Colors.yellow[100],
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: new TextField(
                    controller: remarkController,
                    /* onSaved: (val) => remarks = val,
                  validator: (val) {
                    return val.trim().isEmpty ? "Delivery remark" : null;
                  },*/
                    //initialValue: widget.name,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                      labelText: "Collection remark",
                      /*border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5.0)))*/
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
    //map = json.decode(todo);
    // {orderId: 20, deliveryId: 3, customerName: Ramesh Thiru,
    // address: 123 Main Street,2nd Extension,Coimbatore,England,641041, deliveryNote: To home,
    // deliveryStatus: 0, deliveryDate: 2020-03-05T00:00:00}
    // Use the Todo to create the UI.
    const gray = const Color(0xFFEEEFEE);
    double c_width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      backgroundColor: gray,
      appBar: AppBar(
          title: Text(widget.type == "Shelf" ? "Assign Shelf" : "Collection"),
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back),
                ),
              ))),
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
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: Column(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.all(8),
                                //   child: new Row(
                                //     children: [
                                //       Expanded(
                                //         child: Text(
                                //           'Order ID :  ',
                                //           style: TextStyle(
                                //               fontSize: 17, color: Colors.grey),
                                //         ),
                                //         flex: 2,
                                //       ),
                                //       Expanded(
                                //         child: Text(
                                //           widget.lastOrderId,
                                //           style:
                                //               TextStyle(fontSize: 17, color: blue),
                                //         ),
                                //         flex: 3,
                                //       )
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: new Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Name   ',
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.name != null ? widget.name : "",
                                          style: TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                        flex: 3,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: new Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Email   ',
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          email != null ? email : "N/A",
                                          style: TextStyle(fontSize: 14, color: Colors.black),
                                        ),
                                        flex: 3,
                                      )
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8),
                                //   child: new Row(
                                //     children: [
                                //       Expanded(
                                //         child: Text(
                                //           'Address   ',
                                //           style: TextStyle(
                                //               fontSize: 14, color: Colors.grey),
                                //         ),
                                //         flex: 2,
                                //       ),
                                //       Expanded(
                                //         // child: new Container(
                                //         //width: c_width,
                                //         child: new Column(
                                //           children: <Widget>[
                                //             new Text(
                                //                 widget.address != null
                                //                     ? widget.address
                                //                     : "",
                                //                 textAlign: TextAlign.left),
                                //           ],
                                //           // ),
                                //         ),
                                //         flex: 3,
                                //       )
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: InkWell(
                                    onTap: () {
                                      if (mobile != null && mobile.isNotEmpty) {
                                        makePhoneCall(mobile);
                                      } else {
                                        Fluttertoast.showToast(msg: "Phone number not available");
                                      }
                                    },
                                    child: new Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Phone No.',
                                            style: TextStyle(fontSize: 14, color: Colors.grey),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(child: Text(mobile != null ? mobile : "-", textAlign: TextAlign.left), flex: 3)
                                      ],
                                    ),
                                  ),
                                ),
                                /*Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: new Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                              'Route   ',
                                              style: TextStyle(
                                                  fontSize: 14, color: Colors.grey),
                                            ),
                                            flex: 2),
                                        Expanded(
                                            child: Text(
                                                widget.route != null
                                                    ? widget.route
                                                    : "-",
                                                textAlign: TextAlign.left),
                                            flex: 3)
                                      ],
                                    ),
                                  ),*/
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: new Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Collection Note   ',
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: deliveryNote != null && deliveryNote != "" ? deliveryNote : "",
                                                style: TextStyle(fontSize: 14, color: yetToStartColor),
                                              ),
                                              TextSpan(text: recentDeliveryNote != null ? " " + recentDeliveryNote : " ", style: new TextStyle(fontSize: 14, color: Colors.red)),
                                            ],
                                          ),
                                        )
                                        /*Text(widget.deliveryNote,
                                          style: TextStyle(
                                            fontSize: 14,
                                              color: Colors.black
                                          ),
                                          textAlign: TextAlign.justify)*/
                                        ,
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: new Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Exits Delivery Note   ',
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: new TextSpan(
                                            style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: deliveryRemarks1 != null && deliveryRemarks1 != "" ? deliveryRemarks1 : "",
                                                style: TextStyle(fontSize: 14, color: yetToStartColor),
                                              ),
                                            ],
                                          ),
                                        )
                                        /*Text(widget.deliveryNote,
                                          style: TextStyle(
                                            fontSize: 14,
                                              color: Colors.black
                                          ),
                                          textAlign: TextAlign.justify)*/
                                        ,
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: new Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Payment Exemption',
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(child: Text(widget.paymentExemption != null ? widget.paymentExemption : "N/A", textAlign: TextAlign.left, style: TextStyle(fontSize: 14, color: Colors.red)), flex: 3)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            flex: 4,
                          ),
                          // new Expanded(
                          //   child: Center(
                          //     child: Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         isStorageFridge != null &&
                          //                 isStorageFridge == "true"
                          //             ? Container(
                          //                 //color: notdeliveryColor,
                          //                 margin: const EdgeInsets.all(3.0),
                          //                 padding: const EdgeInsets.all(3.0),
                          //                 child: new IconTheme(
                          //                     data: new IconThemeData(
                          //                         color: Colors.white),
                          //                     child: Image.asset(
                          //                       'assets/fridge.png',
                          //                       width: 35,
                          //                       height: 35,
                          //                     )))
                          //             : SizedBox(),
                          //         // isControlledDrugs != null &&
                          //         //         isControlledDrugs == "true"
                          //         //     ? Container(
                          //         //         //color: notdeliveryColor,
                          //         //         margin: const EdgeInsets.all(3.0),
                          //         //         padding: const EdgeInsets.all(3.0),
                          //         //         child: new IconTheme(
                          //         //             data: new IconThemeData(
                          //         //                 color: Colors.white),
                          //         //             child: Image.asset(
                          //         //               'assets/record.png',
                          //         //               width: 35,
                          //         //               height: 35,
                          //         //             )))
                          //         //     : SizedBox(),
                          //       ],
                          //     ),
                          //   ),
                          //   flex: 1,
                          // )
                        ],
                      ),
                    ),
                  ),

                  // widget.type != 'Shelf'
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(4),
                  //         child: new Row(
                  //           children: [
                  //             Text(
                  //               'Status ',
                  //               style: TextStyle(fontSize: 16, color: Colors.black),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : SizedBox(),

                  // widget.type != 'Shelf'
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(8),
                  //         child: new Row(
                  //           children: [
                  //             Text(
                  //               'Collected by ',
                  //               style: TextStyle(fontSize: 16, color: Colors.black),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: new Card(
                        color: Colors.blue[100],
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: shelfNoController,
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            style: TextStyle(decoration: TextDecoration.none),
                            decoration: new InputDecoration(
                              labelText: "Shelf Name",
                            ),
                          ),
                        )),
                  ),
                  widget.type != 'Shelf'
                      ? new Card(
                          color: Colors.deepOrange[100],
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: new Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.black,
                                        ),
                                        onChanged: null,
                                        //   (String newValue) {
                                        // setState(() {
                                        //   dropdownValue = newValue;
                                        // });
                                        // },
                                        items: <String>[
                                          // 'Ready For Delivery',
                                          'Completed',
                                          // 'Failed'
                                          //'Returned'
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ))
                              ],
                            ),
                          ))
                      : SizedBox(),
                  widget.type != 'Shelf' ? form : SizedBox(),

                  Row(
                    children: [
                      (deliveryNote != null && deliveryNote != "" || recentDeliveryNote != null && recentDeliveryNote != "")
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 2.0, top: 5, right: 15.0, bottom: 10),
                                child: Container(
                                  height: CustomColors.chkButtonHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: CustomColors.collectionNoteColor,
                                    // border: Border.all(color: Colors.blue)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Checkbox(
                                        onChanged: (checked) {
                                          setState(() {
                                            isReadNote = checked;
                                          });
                                        },
                                        value: isReadNote,
                                        checkColor: Colors.white,
                                        activeColor: Colors.black87,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "Read Collection Note  ",
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      if (medicineDetails != null && medicineDetails.isNotEmpty) Spacer(),
                      if (medicineDetails != null && medicineDetails.isNotEmpty)
                        InkWell(
                          onTap: () {
                            showMedicianDetails(context, medicineDetails);
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 0, bottom: 5, top: 10, right: 4),
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white, border: Border.all(color: Colors.grey[400])),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Rx Details",
                                    style: TextStyle(color: Colors.blueGrey, fontSize: 14, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              )),
                        ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 0,
                  // ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        isStorageFridge == null || isStorageFridge == "false"
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 2.0,
                                    right: 15.0,
                                  ),
                                  child: Container(
                                    height: CustomColors.chkButtonHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: CustomColors.fridgeColor,
                                      // border: Border.all(color: Colors.blue)
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          onChanged: (checked) {
                                            setState(() {
                                              isFridgeNote1 = checked;
                                            });
                                          },
                                          value: isFridgeNote1,
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "Fridge",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        isControlledDrugs == null || isControlledDrugs == "false"
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 2.0,
                                    right: 5.0,
                                  ),
                                  child: Container(
                                    height: CustomColors.chkButtonHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: CustomColors.drugColor,
                                      // border: Border.all(color: Colors.blue)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          onChanged: (checked) {
                                            setState(() {
                                              isControlledDrugs1 = checked;
                                            });
                                          },
                                          value: isControlledDrugs1,
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "Controlled Drugs",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 5),
                            child: new SizedBox(
                              //minWidth: MediaQuery.of(context) ,
                              height: 45,
                              child: new ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: scanBarcodeNormal,
                                child: new Text(
                                  "Scan Bar",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )),
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4, top: 5, bottom: 2),
                              child: new SizedBox(
                                //minWidth: 230,
                                height: 45,
                                child: new ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: new Text(
                                    "Update Status",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    // deliveryName = deliveryToController.text.toString();
    // remarks = remarkController.text.toString();

    //if (isReadNote == true) {
    try {
      var data = null;
      //var resBody = {};
      // print(deliveryId);
      if (deliveryId == null) {
        Fluttertoast.showToast(msg: "Delivery ID not found", toastLength: Toast.LENGTH_LONG);
      } else if (widget.type == 'Shelf' && shelfNoController.text == '') {
        Fluttertoast.showToast(msg: "Enter shelf no", toastLength: Toast.LENGTH_LONG);
      } else if (widget.type != 'Shelf' && dropdownValue == 'Select Status') {
        Fluttertoast.showToast(msg: "Select Delivery Status", toastLength: Toast.LENGTH_LONG);
      }
      /*else if (remarkController.text == ''){
          Fluttertoast.showToast(
              msg: "Please Add Customer Remark", toastLength: Toast.LENGTH_LONG);
        }*/
      else if (((deliveryNote != null && deliveryNote.isNotEmpty) || (recentDeliveryNote != null && recentDeliveryNote.isNotEmpty)) && (!isReadNote)) {
        _showSnackBar("Check collection note");
      } else {
        if (deliveryToController.text.toString() == null || deliveryToController.text.toString().isEmpty) {
          Fluttertoast.showToast(msg: "Enter Delivered to", toastLength: Toast.LENGTH_LONG);
        }
        /*else if (remarkController.text.toString() == null || remarkController.text.toString().isEmpty) {
            Fluttertoast.showToast(
                msg: "Enter Remarks", toastLength: Toast.LENGTH_LONG);
          }*/
        else {
          Map<String, dynamic> resBody = new Map<String, dynamic>();
          resBody['deliveryId'] = int.parse(widget.lastOrderId);
          resBody['remarks'] = remarkController.text.toString();
          resBody['deliveredTo'] = deliveryToController.text.toString();
          if (shelfNoController.text != "") resBody['rackNo'] = shelfNoController.text;
          if (dropdownValue == 'Ready For Delivery') {
            resBody['deliveryStatus'] = 1;
          }
          /*else if (dropdownValue == 'Out for Delivery') {
              resBody['deliveryStatus'] = 2;
            }*/
          else if (dropdownValue == 'Completed') {
            resBody['deliveryStatus'] = 5;
          } else if (dropdownValue == 'Failed') {
            resBody['deliveryStatus'] = 6;
          } else if (dropdownValue == 'Returned') {
            resBody['deliveryStatus'] = 9;
          }
          resBody['pickupTypeId'] = 11;
          // if (pickupTypeId == null || pickupTypeId == "2") {
          //   _alertDialog(resBody);
          // } else {
          if (dropdownValue == 'Ready For Delivery') {
            Fluttertoast.showToast(msg: 'Please update status', toastLength: Toast.LENGTH_LONG);
          } else if (dropdownValue == "Completed") {
            if (!isFridgeNote1 && isStorageFridge != "false") {
              Fluttertoast.showToast(msg: "Check Fridge");
              return;
            } else if (!isControlledDrugs1 && (isControlledDrugs != "false")) {
              Fluttertoast.showToast(msg: "Check Controlled Drugs");
              return;
            }

            Route route = MaterialPageRoute(
                builder: (context) => SignatureApp(
                      resBody: resBody,
                    ));
            Navigator.pushReplacement(context, route);
          } else {
            collectOrder(resBody);
          }

          // }
          //  Fluttertoast.showToast(
          //    msg: map.toString(), toastLength: Toast.LENGTH_LONG);
        }
      }
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
      _showSnackBar(e.toString());
    }
    //}
    // else {
    //   _showSnackBar("Check collection note");
    // }
  }

  void _alertDialog(Map<String, dynamic> resBody) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
                //margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(15.0),
                height: 210.0,
                decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      child: new Text(
                        "Alert",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.type == 'Shelf' ? "You are changing the order to shelf" : "You are changing the order to collection",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                              child: SizedBox(
                                  height: 35.0,
                                  width: 110.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                    child: Text(
                                      'Proceed',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                      collectOrder(resBody);
                                    },
                                  ))),
                          flex: 1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                                height: 35.0,
                                width: 110.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  ),
                                  child: Text(
                                    'Go Back',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context, false);
                                  },
                                )),
                          ),
                          flex: 1,
                        )
                      ],
                    )),
                  ],
                )),
          );
        });
    // Navigator.pop(context, true);
  }

  // ignore: missing_return
  Future<Map<String, Object>> collectOrder(Map<String, dynamic> map) async {
    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().showLoadingDialog(context, true);
    Map<String, String> headers = {'Accept': 'application/json', "Content-type": "application/json", "Authorization": 'Bearer $token'};
    /*  Map<String, dynamic> map = {
      //"pharmacyId": int.parse(pharmacyId),
      "userId": int.parse(userId),
      "tokenId": token,
      //"branchId": int.parse(branchId),
      "message": "token register done"
    };*/
    final j = json.encode(map);
    //logger.i("aa" + j.toString());
    // print(WebConstant.PHARMACY_STATUS_UPDATE_URL);
    // print(j);
    // final response = await http.post(WebConstant.PHARMACY_STATUS_UPDATE_URL,
    //     body: j, headers: headers);
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    // logger.i("aa" + json.decode(response.body).toString());

    _apiCallFram.postDataAPI(WebConstant.DELIVERY_STATUS_UPDATE_URL, token, map, context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          Map<String, Object> data = json.decode(response.body);
          var status = data['status'];
          var uName = data['message'];
          if (status == true) {
            // if (widget.mobile != null) _sendSms(widget.mobile);
            //_incrementCounter();
            try {
              // if (dropdownValue == 'Completed') {
              //   Route route = MaterialPageRoute(
              //       builder: (context) => SignatureApp(
              //             name: widget.name.toString(),
              //             deliveryId: deliveryId.toString(),
              //           ));
              //   Navigator.pushReplacement(context, route);
              //   _showSnackBar("Status Successfully Updated");
              // } else {
              //   _showSnackBar("Status Successfully Updated");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              //_asyncConfirmDialog("Status Successfully Updated");
              // }
              /*   Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignatureApp(
                          name: widget.name.toString(),
                          deliveryId: widget.deliveryId.toString(),
                        )),
              );*/
              widget.function();
            } catch (e, stackTrace) {
              SentryExemption.sentryExemption(e, stackTrace);
              // print(e);
            }
            // progressDialog.hide();
          } else {
            _showSnackBar(uName);
          }
        } else {
          Fluttertoast.showToast(msg: "Data not found from server side.");
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    }).catchError((onError, stackTrace) async {
      SentryExemption.sentryExemption(onError, stackTrace);
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      Navigator.of(context).pop(true);
    });
  }

  @override
  Future<void> onDeliveryUpdateError(String errorTxt) async {
    _showSnackBar(errorTxt);
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    // await CustomLoading().showLoadingDialog(context, true);
  }

  @override
  Future<void> onDeliveryUpdateSuccess(Map<String, Object> user) async {
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    // await CustomLoading().showLoadingDialog(context, true);
    var status = user['status'];
    var uName = user['message'];
    if (status == true) {
      // if (widget.mobile != null) _sendSms(widget.mobile);
      //_incrementCounter();
      try {
        if (widget.type != 'Shelf' && dropdownValue == 'Completed') {
          List orderid = [];
          orderid.add(deliveryId.toString());
          Route route = MaterialPageRoute(
              builder: (context) => SignatureApp(
                    name: widget.name.toString(),
                    deliveryId: orderid,
                  ));
          Navigator.pushReplacement(context, route);
          _showSnackBar("Status Successfully Updated");
        } else {
          _showSnackBar("Status Successfully Updated");
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          //_asyncConfirmDialog("Status Successfully Updated");
        }
        /*   Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignatureApp(
                          name: widget.name.toString(),
                          deliveryId: widget.deliveryId.toString(),
                        )),
              );*/
        widget.function();
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // print(e);
      }
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
    } else {
      _showSnackBar(uName);
    }
  }

  void _showSnackBar(String text) {
    Fluttertoast.showToast(msg: text, toastLength: Toast.LENGTH_LONG);
  }

  void _asyncConfirmDialog(var mes) {
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(),
          content: new Text(mes),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.BARCODE);
      // print(barcodeScanRes);
      postDataAndVerifyUser(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // try{
    //   final parser = Xml2Json();
    //   parser.parse(barcodeScanRes);
    //   var json = parser.toGData();
    //   print(json);
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayBarCodeFormat(scannedData: json.toString())));
    // }catch(_){
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayBarCodeFormat(scannedData: barcodeScanRes)));
    // }

    //BarCodeModel barCodeModel = barCodeModelFromJson(json.toString());
  }

  Future<void> postDataAndVerifyUser(String decryptOrderId) async {
    // ProgressDialog(context, isDismissible: false).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    String url = "${WebConstant.CHECK_COLLECTION_ORDER_URL}?orderId=${widget.lastOrderId}&decryptOrderId=$decryptOrderId";
    _apiCallFram.getDataRequestAPI(url, token, context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      try {
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
        if (response != null) {
          // ProgressDialog(context).hide();
          await CustomLoading().showLoadingDialog(context, false);
          // await CustomLoading().showLoadingDialog(context, true);
          // logger.i("${response.body}");
          //Map<String, Object> data = json.decode(response.body);
          if (response.body == "true") {
            Fluttertoast.showToast(msg: "Order matched");
            setState(() {
              deliveryStatus = "3";
              dropdownValue = "Completed";
            });
          } else {
            Fluttertoast.showToast(msg: "Order not matched");
          }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // logger.i("Exception : $e");
      }
    });
  }

  void showMedicianDetails(
    BuildContext context,
    List<MedicineDetail> medicineDetails,
  ) {
    if (medicineDetails.length > 0) {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                          child: Text(
                            "Rx Details",
                            style: TextStyle(fontFamily: "Montserrat", fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: medicineDetails.length,
                        itemBuilder: (context, i) {
                          return RxDetailWidget(medicineDetails[i]);
                        }),
                  )
                ],
              );
            },
          );
        },
      );
    }
  }
}

class DisplayBarCodeFormat extends StatefulWidget {
  String scannedData;

  DisplayBarCodeFormat({this.scannedData});

  StateDisplayBarCodeFormat createState() => StateDisplayBarCodeFormat();
}

class StateDisplayBarCodeFormat extends State<DisplayBarCodeFormat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Text(
          "${widget.scannedData}",
          style: TextStyle(fontSize: 16, letterSpacing: 2),
        ),
      ),
    );
  }
}

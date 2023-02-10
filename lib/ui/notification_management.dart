// @dart=2.9

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/Notification.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/notifications_model.dart';
import 'package:pharmdel_business/ui/splash_screen.dart';
import 'package:pharmdel_business/util/RetryClickListner.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'NoDataFound.dart';
import 'create_notification.dart';
import 'login_screen.dart';

class NotificationManagement extends StatefulWidget {
  @override
  _NotificationManagementScreen createState() => _NotificationManagementScreen();
}

class _NotificationManagementScreen extends State<NotificationManagement> implements RetryClickListner, NotificationSelectedListner {
  bool noRecordFound = false;
  List<Notifications> dataList = [];

  ApiCallFram _apiCallFram = ApiCallFram();

  String accessToken = "";

  var userType;
  int index = 0;
  ScrollController scrollController = ScrollController();

  bool getNextPage = false;
  int pageNo = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_pagination);
    checkLastTime(context);
    SharedPreferences.getInstance().then((value) async {
      // print(value);
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      userType = value.getString(WebConstant.USER_TYPE) ?? "";

      bool checkInternet = await ConnectionValidator().check();
      if (checkInternet) {
        CallAPINotification(false, pageNo);
      } else {
        noRecordFound = true;
        getNextPage = true;
        setState(() {});
        Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      }
    });
  }

  void _pagination() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      // logger.i("End of Page");
      if (getNextPage) {
        pageNo++;
        CallAPINotification(false, pageNo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNotification())).then((value) {
            Future.delayed(Duration(milliseconds: 500), () {
              pageNo = 1;
              CallAPINotification(false, pageNo);
            });
          });
        },
      ),
      // appBar: AppBar(
      //   title: Text("Notifications", style: TextStyle(color: Colors.black),),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   // automaticallyImplyLeading: true,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       size: 25.0,
      //       color: Colors.black,
      //     ),
      //     onPressed: (){
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: RefreshIndicator(
          // color: CustomColors.darkPinkColor,
          onRefresh: () {
            pageNo = 1;
            return CallAPINotification(true, pageNo);
          },
          child: dataList.length < 1 && dataList.isEmpty
              ? NoDataFound(this)
              : Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                  child: ListView.builder(
                      controller: scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataList.length > 0 && dataList.isNotEmpty ? dataList.length : 0,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => NotificationInfo(dataList[i]),
                            );
                          },
                          child: Card(
                            color: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100,
                            // color: CustomColors.lightPinkColor,
                            margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8, left: 3, right: 8, bottom: 8),
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            //color: Colors.grey,
                                            // margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "${i + 1}",
                                                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10.0),
                                          ),
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        dataList[i].name ?? "",
                                                        style: TextStyle(
                                                          fontFamily: "Montserrat",
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      dataList[i].dateAdded ?? "",
                                                      style: TextStyle(fontFamily: "Montserrat", fontSize: 10),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  dataList[i].user ?? "",
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                        ;
                      }),
                )),
    );
  }

  Future<void> CallAPINotification(bool isRefresh, int pageNo) async {
    if (!isRefresh) await CustomLoading().showLoadingDialog(context, true);
    // await ProgressDialog(context,isDismissible: false).show();
    // String url = userType == 'Pharmacy' || userType == "Pharmacy Staff"
    //     ? WebConstant.GET_NOTIFICATION_PHARMACY
    //     : WebConstant.GET_NOTIFICATION_DRIVER;
    await _apiCallFram.getDataRequestAPI(WebConstant.NOTIFICATIONS + "?page=$pageNo", accessToken, context).then((response) async {
      // if (ProgressDialog(context).isShowing()) ProgressDialog(context).hide();
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
          if (response.body != null) {
            try {
              if (response.body != "Unauthenticated") {
                var resposdata = NotificationsResponse.fromJson(json.decode(response.body));
                if (resposdata.notifications.isNotEmpty) {
                  noRecordFound = false;
                  getNextPage = true;
                  setState(() {
                    if (pageNo == 1) dataList.clear();
                    dataList.addAll(resposdata.notifications);
                  });
                } else {
                  noRecordFound = true;
                  getNextPage = false;
                  setState(() {});
                }
              } else {
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
            } catch (e, stackTrace) {
              SentryExemption.sentryExemption(e, stackTrace);
              if (mounted) {
                noRecordFound = true;
                setState(() {});
                Fluttertoast.showToast(msg: "Something went wrong");
              }
            }
          } else {
            noRecordFound = true;
            setState(() {});
          }
        }
      } catch (_Ex, stackTrace) {
        SentryExemption.sentryExemption(_Ex, stackTrace);
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // logger.i("Exception:" + _Ex.toString());
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    }).catchError((onError, stackTrace) async {
      SentryExemption.sentryExemption(onError, stackTrace);
      // if (ProgressDialog(context).isShowing()) ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
    });
  }

  @override
  void onClickListner() {
    CallAPINotification(false, pageNo);
  }

  @override
  void isSelected(int type, NotificationList data) {
    // TODO: implement isSelected
    // 1 = Deleted
    // deleteNotification(context, data.id, data.is_admin);
  }
}

abstract class NotificationSelectedListner {
  void isSelected(int type, NotificationList data);
}

class NotificationInfo extends StatefulWidget {
  Notifications dataList;

  @override
  State<StatefulWidget> createState() => NotificationInfoState();

  NotificationInfo(this.dataList);
}

class NotificationInfoState extends State<NotificationInfo> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  TextEditingController emailController = TextEditingController();

  //ProgressDialog progressDialog;
  final focusfName = FocusNode();
  var yetToStartColor = const Color(0xFFF8A340);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(10.0),
              decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Text(
                            "Notification Info",
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 10.0),
                    Container(
                      child: Column(
                        children: [
                          new Padding(
                            padding: const EdgeInsets.all(4),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  'Notification Name - ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Container(
                                    child: new Text(widget.dataList.name ?? ""),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(4),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  'Type - ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 110,
                                ),
                                Flexible(
                                  child: Container(
                                    child: new Text(widget.dataList.type ?? ""),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(4),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  'User - ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 110,
                                ),
                                Flexible(
                                  child: Container(
                                    child: new Text(widget.dataList.user ?? ""),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(4),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  'Message - ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 80,
                                ),
                                Flexible(
                                  child: Container(
                                    child: new Text(widget.dataList.message ?? ""),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(4),
                            child: new Row(
                              children: [
                                new Text(
                                  'Date - ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 110,
                                ),
                                Flexible(
                                  child: Container(
                                    child: new Text(widget.dataList.dateAdded ?? ""),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

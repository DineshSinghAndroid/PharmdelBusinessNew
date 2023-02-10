//@dart 2.9
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/Notification.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/splash_screen.dart';
import 'package:pharmdel_business/util/RetryClickListner.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'NoDataFound.dart';
import 'login_screen.dart';

class ReciveNotification extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<ReciveNotification> implements RetryClickListner, NotificationSelectedListner {
  bool noRecordFound = false;
  List<NotificationList> dataList = [];

  ApiCallFram _apiCallFram = ApiCallFram();

  String accessToken = "";

  var userType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLastTime(context);
    SharedPreferences.getInstance().then((value) async {
      // print(value);
      accessToken = value.getString(WebConstant.ACCESS_TOKEN) ?? "";
      userType = value.getString(WebConstant.USER_TYPE) ?? "";

      bool checkInternet = await ConnectionValidator().check();
      if (checkInternet) {
        CallAPINotification(false);
      } else {
        noRecordFound = true;
        setState(() {});
        Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notification",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        // backgroundColor: CustomColors.darkPinkColor,
        // automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
          // color: CustomColors.darkPinkColor,
          onRefresh: () {
            return CallAPINotification(true);
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: noRecordFound
                ? NoDataFound(this)
                : Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (context, i) {
                          DateFormat sdf = new DateFormat("dd-MM-yyyy HH:mm");
                          DateTime date = sdf.parse(dataList[i].created);
                          var now = DateTime.now();
                          var days = now.difference(date).inDays;
                          var hours = now.difference(date).inHours;
                          var mintus = now.difference(date).inMinutes;
                          String time = days > 0 ? days.toString() + "day" : (hours > 0 ? hours.toString() + "hr" : mintus.toString() + "min");
                          return Card(
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
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              // color: CustomColors.darkPinkColor,
                                              // image: backgroundImage != null
                                              //     ? new DecorationImage(image: backgroundImage, fit: BoxFit.cover)
                                              //     : null,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.notifications,
                                              size: 30,
                                              color: Colors.orange[300],
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
                                                Text(
                                                  dataList[i].name ?? "",
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  dataList[i].message ?? "",
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: MediaQuery.of(context).size.width * .15,
                                          // ),
                                          // Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              // InkWell(
                                              //   child: Icon(
                                              //     Icons.delete,
                                              //     color: CustomColors.darkPinkColor,
                                              //   ),
                                              //   onTap: (){
                                              //     selectedListner.isSelected(1,  dataList);
                                              //   },
                                              // ),
                                              Text(
                                                time,
                                                style: TextStyle(fontFamily: "Montserrat", fontSize: 10),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
          )),
    );
  }

  Future<List<NotificationBean>> CallAPINotification(bool isRefresh) async {
    List<NotificationBean> list = [];
    if (!isRefresh) await CustomLoading().showLoadingDialog(context, true);
    // await ProgressDialog(context,isDismissible: false).show();
    String url = userType == 'Pharmacy' || userType == "Pharmacy Staff" ? WebConstant.GET_NOTIFICATION_PHARMACY : WebConstant.GET_NOTIFICATION_DRIVER;
    logger.i(url);
    await _apiCallFram.getDataRequestAPI("${url}", accessToken, context).then((response) async {
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
                var resposdata = NotificationBean.fromJson(json.decode(response.body));
                if (resposdata.list.isNotEmpty) {
                  noRecordFound = false;
                  setState(() {
                    dataList = resposdata.list;
                  });
                } else {
                  noRecordFound = true;
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
            } catch (_, stackTrace) {
              SentryExemption.sentryExemption(_, stackTrace);
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
    }).catchError((onError) async {
      // if (ProgressDialog(context).isShowing()) ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
    });
    return list;
  }

  @override
  void onClickListner() {
    CallAPINotification(false);
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

// @dart=2.9

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmdel_business/util/log_print.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/Notification.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/notification_management.dart';
import 'package:pharmdel_business/ui/splash_screen.dart';
import 'package:pharmdel_business/util/RetryClickListner.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';
import 'NoDataFound.dart';
import 'login_screen.dart';
import 'notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> implements RetryClickListner, NotificationSelectedListner {
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
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Received",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Sent",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            RefreshIndicator(
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
                                return NotificationWidget(dataList[i], this);
                              }),
                        ),
                )),
            NotificationManagement(),
          ],
        ),
      ),
    );
  }

  Future<void> CallAPINotification(bool isRefresh) async {
    List<NotificationBean> list = [];
    if (!isRefresh) await CustomLoading().showLoadingDialog(context, true);
    // await ProgressDialog(context,isDismissible: false).show();
    String url = userType == 'Pharmacy' || userType == "Pharmacy Staff" ? WebConstant.GET_NOTIFICATION_PHARMACY : WebConstant.GET_NOTIFICATION_DRIVER;
    logger.i(url);
    logger.i(accessToken);
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
    }).catchError((onError, stackTrace) async {
      SentryExemption.sentryExemption(onError, stackTrace);
      // if (ProgressDialog(context).isShowing()) ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
    });
    return list;
  }

  Future<void> deleteNotification(BuildContext context, int id, int is_admin) async {
    // userData = await AppSharedPreferences.instance.getUserDetails();
    // EasyLoading.show();
    // String strUrl = WebApiConstaint.URL_DELETE_NOTIFCATION +
    //     "?id=" +
    //     id.toString() +
    //     "&is_admin=$is_admin";
    // provider
    //     .requestGetForApi(
    //         context, strUrl, userData.sessionKey, userData.authorization)
    //     .then((responce) {
    //   print(strUrl);
    //   EasyLoading.dismiss();
    //
    //   if (responce != null) {
    //     try {
    //       if (responce.data["error"] == false) {
    //         CallAPINotification();
    //       } else {
    //         Fluttertoast.showToast(msg: responce.data["message"]);
    //         print(responce.data["message"]);
    //         if (responce.data["authenticate"] == false) {
    //           AppSharedPreferences.instance.setLogin(false);
    //           Navigator.pushAndRemoveUntil(
    //               context,
    //               MaterialPageRoute(builder: (context) => LoginScreen()),
    //               ModalRoute.withName("/Home"));
    //         }
    //       }
    //     } catch (_EX) {
    //       ToastUtils.showCustomToast(
    //           context, ErrorMessage.ERROR_DATA_NOT_PROPER_FORM);
    //     }
    //   }
    // });
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

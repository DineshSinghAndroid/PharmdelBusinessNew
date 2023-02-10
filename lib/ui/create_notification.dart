// @dart=2.9
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/model/pharmacy_staff_model.dart';
import 'package:pharmdel_business/util/RaisedGradientButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../data/api_call_fram.dart';
import '../data/web_constent.dart';
import '../util/connection_validater.dart';
import '../util/custom_loading.dart';
import '../util/sentryExeptionHendler.dart';

class CreateNotification extends StatefulWidget {
  const CreateNotification({Key key}) : super(key: key);

  @override
  _CreateNotificationState createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  TextEditingController notificationNameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  ApiCallFram _apiCallFram = ApiCallFram();

  FocusNode focusNotificationName = FocusNode();
  FocusNode focusMessage = FocusNode();

  String accessToken = "";

  bool noRecordFound = false;

  List<StaffList> staffList;

  StaffList staffValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) async {
      // print(value);
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);

      bool checkInternet = await ConnectionValidator().check();
      if (checkInternet) {
        CallAPIPharmacyStaff(false);
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
          "Create Notification",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notification Name:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: new TextFormField(
                  validator: (val) {
                    return val.trim().isEmpty ? "Enter Notification Name" : null;
                  },
                  controller: notificationNameController,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focusNotificationName);
                  },
                  ////initialValue: "rc2.cust20200101@gmail.com",
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: new InputDecoration(hintText: "Name", border: new OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(5.0)))),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                  child: Text(
                "Pharmacy Staff:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              )),
              SizedBox(
                height: 10.0,
              ),
              FormField<String>(builder: (FormFieldState<String> state) {
                return Column(
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45.0,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                        child: DropdownButton<StaffList>(
                          value: staffValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 2,
                          style: TextStyle(color: Colors.black),
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (StaffList newValue) {
                            setState(() {
                              staffValue = newValue;
                              state.didChange(newValue.name);
                            });
                          },
                          items: staffList != null && staffList.isNotEmpty
                              ? staffList.map((StaffList value) {
                                  return DropdownMenuItem<StaffList>(
                                    value: value,
                                    child: Text(
                                      value.name,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList()
                              : null,
                          hint: Text(
                            "Select Pharmacy Staff",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    )
                  ],
                );
              }),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Message:",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15.0,
              ),
              new TextFormField(
                validator: (val) {
                  return val.trim().isEmpty ? "Enter Message" : null;
                },
                controller: messageController,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusMessage);
                },
                ////initialValue: "rc2.cust20200101@gmail.com",
                maxLength: 500,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                maxLines: null,
                minLines: 4,
                decoration: new InputDecoration(hintText: "Message", border: new OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(5.0)))),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 12.0, right: 12.0),
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 0),
          width: MediaQuery.of(context).size.width,
          child: RaisedGradientButton(
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              height: 50,
              color1: Colors.blue,
              color2: Colors.blue,
              onPressed: () {
                if (notificationNameController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Notification Name");
                } else if (staffValue == null) {
                  Fluttertoast.showToast(msg: "Select Pharmacy Staff");
                } else if (messageController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Message");
                } else {
                  saveNotificataionApi(false);
                }
              }),
        ),
      ),
    );
  }

  Future<void> CallAPIPharmacyStaff(bool isRefresh) async {
    List<PharmacyStaffResponse> list = [];
    if (!isRefresh) await CustomLoading().showLoadingDialog(context, true);
    // await ProgressDialog(context,isDismissible: false).show();
    // String url = userType == 'Pharmacy' || userType == "Pharmacy Staff"
    //     ? WebConstant.GET_NOTIFICATION_PHARMACY
    //     : WebConstant.GET_NOTIFICATION_DRIVER;
    await _apiCallFram.getDataRequestAPI(WebConstant.CREATE_NOTIFICATION, accessToken, context).then((response) async {
      // if (ProgressDialog(context).isShowing()) ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          if (response.body != null) {
            logger.i(response.body);
            try {
              if (response.body != "Unauthenticated") {
                var resposdata = PharmacyStaffResponse.fromJson(json.decode(response.body));
                if (resposdata.data != null && resposdata.data.staffList.isNotEmpty) {
                  noRecordFound = false;
                  setState(() {
                    staffList = resposdata.data.staffList;
                  });
                } else {
                  noRecordFound = true;
                  setState(() {});
                }
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

  void saveNotificataionApi(bool isRefresh) async {
    if (!isRefresh) await CustomLoading().showLoadingDialog(context, true);
    // await ProgressDialog(context,isDismissible: false).show();
    Map<String, dynamic> data = {
      "name": notificationNameController.text.toString().trim() ?? "",
      "user_list": staffValue.userId != null ? staffValue.userId : 0,
      "message": messageController.text.toString().trim() ?? "",
      "role": staffValue.role ?? "",
    };
    // print(data);
    _apiCallFram.postDataAPI(WebConstant.SAVE_NOTIFICATION, accessToken, data, context).then((response) async {
      // ProgressDialog(context, isDismissible: true).hide();
      await CustomLoading().showLoadingDialog(context, false);
      if (response != null) {
        Map<String, Object> data = json.decode(response.body);
        if (data["status"] == true) {
          Navigator.pop(context);
          notificationNameController.clear();
          messageController.clear();
          Fluttertoast.showToast(msg: data["message"]);
        } else {
          Fluttertoast.showToast(msg: data["message"]);
        }
      }
    });
  }
}

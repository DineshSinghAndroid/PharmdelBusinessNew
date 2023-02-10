// @dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/MedicineReaponse.dart';
import 'package:pharmdel_business/model/route_model.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../login_screen.dart';
import '../splash_screen.dart';

class MedicineList extends StatefulWidget {
  _MedicineList createState() => _MedicineList();
}

class _MedicineList extends State<MedicineList> {
  ApiCallFram _apiCallFram = ApiCallFram();
  List<RouteList> routeList = List();
  String accessToken, userType;

  TextEditingController searchMedicineController = TextEditingController();
  FocusNode focus = FocusNode();

  // GetMedicineProvider postMdl1;
  ScrollController _controller;
  int pageNo = 1;
  bool isLoading = false;

  List<MedicineDataList> selectedMedicineName = [];
  List<MedicineDataList> medicineList = [];
  ApiCallFram apiProvider = ApiCallFram();

  @override
  void initState() {
    super.initState();
    // logger.i("driver dashboard");
    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      userType = value.getString(WebConstant.USER_TYPE) ?? "";
    });
    // postMdl1 = Provider.of<GetMedicineProvider>(context, listen: false);
    checkLastTime(context);
    _controller = ScrollController()
      ..addListener(() async {
        if (_controller.position.maxScrollExtent == _controller.offset) {
          pageNo++;
          // logger.i("PAGE NUMBER $pageNo");
          getMedicineList(context, searchMedicineController.text.trim(), pageNo, accessToken);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    // medicineList = Provider.of<GetMedicineProvider>(context, listen: false).medicineList;
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
        // Container(
        //   height: MediaQuery.of(context).size.height / 2.5,
        //   width: MediaQuery.of(context).size.width,
        //   child: Image.asset(
        //     "assets/top_bg.png",
        //     fit: BoxFit.fill,
        //   ),
        // ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.5,
            backgroundColor: materialAppThemeColor,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Icon(
                Icons.arrow_back,
                color: appBarTextColor,
              ),
            ),
            title: TextFormField(
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              autofocus: false,
              enabled: true,
              style: TextStyle(color: Colors.black),
              maxLength: 50,
              maxLines: 1,
              cursorColor: appBarTextColor,
              controller: searchMedicineController,
              decoration: new InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appBarTextColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appBarTextColor),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: appBarTextColor),
                ),
                suffixIcon: InkWell(
                    onTap: () async {
                      if (searchMedicineController.text.length > 2) {
                        pageNo = 1;
                        getMedicineList(context, searchMedicineController.text.trim(), pageNo, accessToken);
                      } else {
                        medicineList.clear();
                      }
                    },
                    child: Icon(
                      Icons.search,
                      color: appBarTextColor,
                    )),
                counter: Offstage(),
                hintStyle: TextStyle(color: appBarTextColor),
                suffixStyle: TextStyle(color: appBarTextColor),
                prefixStyle: TextStyle(color: appBarTextColor),
                hintText: "Search Medicine",
              ),
              onFieldSubmitted: (v) {
                FocusScope.of(context).requestFocus(focus);
              },
              onChanged: (value) async {
                if (searchMedicineController.text.length > 2) {
                  pageNo = 1;
                  getMedicineList(context, searchMedicineController.text.trim(), pageNo, accessToken);
                } else {
                  medicineList.clear();
                }
              },
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: medicineList.length > 0 && searchMedicineController.text.length > 0 ? medicineList.length : 0,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
                                padding: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${medicineList[index].name} ' + (medicineList[index].vtmName != null ? '(${medicineList[index].vtmName})' : '')),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Divider(
                                                height: 2.0,
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Pack Size : ',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  Text('${medicineList[index].packSize}'),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (medicineList[index].drugInfo != null && medicineList[index].drugInfo > 0)
                                                    Container(
                                                        padding: EdgeInsets.only(right: 10, left: 10),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                          color: Colors.red,
                                                        ),
                                                        child: Text(
                                                          'CD',
                                                          style: TextStyle(color: Colors.white),
                                                        )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            bool checkValid = false;
                                            MedicineDataList data = medicineList[index];
                                            data.days = "";
                                            data.quntity = "";
                                            Navigator.of(context).pop(data);
                                            // postMdl1.selectedMedicineName
                                            //     .forEach((element) {
                                            //   if (data.name == element.name) {
                                            //     checkValid = true;
                                            //   }
                                            // });
                                            // if (!checkValid) {
                                            //   postMdl1.getMedicineName(index);
                                            //   Navigator.pop(context);
                                            //   searchMedicineController.clear();
                                            // } else
                                            //   Fluttertoast.showToast(
                                            //       msg:
                                            //       "Medicine is already Selected");
                                            // postMdl1.medicineName[index].medicineName
                                            //     .add(data);
                                          },
                                          child: Container(
                                            width: 70,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF37879f),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Select",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          if (isLoading) CircularProgressIndicator(),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
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

  Future<List<MedicineDataList>> getMedicineList(context, String searchKey, dynamic pageNo, String accessToken) async {
    setState(() {
      isLoading = true;
    });

    String url = WebConstant.GET_MEDICINELIST_PHARMACY + "?searchname=" + searchKey + "&page=$pageNo";

    apiProvider.getDataRequestAPI(url, accessToken, context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      if (pageNo == 1) {
        medicineList.clear();
        // await ProgressDialog(context, isDismissible: false).show();
      }
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
          MedicineReaponse model = MedicineReaponse.fromJson(json.decode(response.body));
          if (model != null && model.dataMain != null && model.dataMain.data != null && model.dataMain.data.isNotEmpty) {
            medicineList.addAll(model.dataMain.data);
            isLoading = false;
          }
          setState(() {});
        }
      } catch (_, stackTrace) {
        // print(_);
        SentryExemption.sentryExemption(_, stackTrace);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
    return medicineList;
  }
}

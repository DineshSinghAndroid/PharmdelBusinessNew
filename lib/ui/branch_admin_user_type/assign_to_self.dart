// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/assign_to_shelf_model.dart';
import 'package:pharmdel_business/model/route_model.dart';
import 'package:pharmdel_business/model/self_model.dart';
import 'package:pharmdel_business/ui/branch_admin_user_type/branch_admin_dashboard.dart';
import 'package:pharmdel_business/util/custom_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';

import '../../data/api_call_fram.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../../util/text_style.dart';
import '../../util/toast_utils.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import 'RxDetailWidget.dart';

class AssignToSelf extends StatefulWidget {
  List<MedicineDetail> prescriptionList = List();
  AssignToShelf pmrList;
  dynamic orderId;
  bool isScan;

  AssignToSelf({this.prescriptionList, this.pmrList, this.orderId, this.isScan});

  StateAssignToSelf createState() => StateAssignToSelf();
}

class StateAssignToSelf extends State<AssignToSelf> {
  ApiCallFram _apiCallFram = ApiCallFram();

  String accessToken = "";
  String scannedData, selectedRoute;
  DateTime selectedDate;
  List<RouteList> routeList = List();

  bool isShowDoctorDetails = false;
  bool isMedician = false;

  ScrollController _controller;
  bool isScrollDown = false, isFridgeNote = false, isControlledDrugs = false;
  List<ShelfModel> _shelfList = [];
  ShelfModel selectedShelf;
  String branchId;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      branchId = value.getString(WebConstant.BRANCH_ID);
      getAllSelf();
    });
    //scanBarcodeNormal();
    _controller = ScrollController()
      ..addListener(() {
        setState(() {
          isScrollDown = _controller.position.userScrollDirection == ScrollDirection.forward;
        });
      });
    checkLastTime(context);
    // print(widget.pmrList.isControlledDrugs);
  }

  int _selectedShelfPosition = 0;

  @override
  // void dispose(){
  //
  // }
  getAllSelf() {
    _shelfList.clear();
    ShelfModel shelf = ShelfModel();
    shelf.name = "Select Shelf";
    _shelfList.add(shelf);
    // ProgressDialog(context, isDismissible: false).show();
    CustomLoading().showLoadingDialog(context, true);
    // print(branchId);
    int branch_id;
    if (branchId == null || branchId == "" || branchId == "null") {
      String branchStrId = '0';
      branch_id = int.parse(branchStrId);
    }

    //  int branch_id = int.parse(branchId);
    _apiCallFram.getDataRequestAPI("${WebConstant.GET_ALL_SHELF_BY_BRANCH_ADMIN}?branchId=$branch_id", accessToken, context).then((response) async {
      CustomLoading().showLoadingDialog(context, false);
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
          _shelfList.addAll(shelfModelFromJson(response.body));
          if (_shelfList.length > 0) selectedShelf = _shelfList[0];
          setState(() {});
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        ToastUtils.showCustomToast(context, WebConstant.ERRORMESSAGE);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text('Assign Self', style: TextStyleblueGrey14),
          actions: <Widget>[],
        ),
        body: Stack(
          children: <Widget>[
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
            SingleChildScrollView(
                controller: _controller,
                child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 0, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "PATIENT INFO",
                          style: TextStyleblueGrey14,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("${widget.pmrList != null ? "${widget.pmrList.patientInfoModel.salutation ?? ""}"
                            "${widget.pmrList.patientInfoModel.salutation == null || widget.pmrList.patientInfoModel.salutation.isEmpty ? "" : " "} "
                            "${widget.pmrList.patientInfoModel.firstName ?? ""} "
                            "${widget.pmrList.patientInfoModel.middleName ?? ""} "
                            "${widget.pmrList.patientInfoModel.lastName ?? ""}" : ""}"),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("DOB: ${widget.pmrList.patientInfoModel.dob}"),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("NHS: ${widget.pmrList != null ? "${widget.pmrList.patientInfoModel.nhsNumber ?? ""}" : ""}"),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Address: ${widget.pmrList != null ? "${widget.pmrList.patientInfoModel.address ?? ""}" : ""}"),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Post Code: ${widget.pmrList != null ? "${widget.pmrList.patientInfoModel.postCode ?? ""} " : ""}"),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),

                      //Doctor Details------------------------------------------------------------------------------
                      InkWell(
                        onTap: () {
                          setState(() {
                            isShowDoctorDetails = !isShowDoctorDetails;
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 0, bottom: 5, top: 30),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Text(
                                    "DOCTOR DETAILS",
                                    style: TextStyleblueGrey14,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.blueGrey,
                                )
                              ],
                            )),
                      ),
                      isShowDoctorDetails
                          ? Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("${widget.pmrList != null ? "${widget.pmrList.doctorInfoModel.doctorName ?? ""}" : ""}"),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Surgery: ${widget.pmrList != null ? "${widget.pmrList.doctorInfoModel.companyName ?? ""}" : ""}"),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Address: ${widget.pmrList != null ? "${widget.pmrList.doctorInfoModel.address ?? ""}" : ""}"),
                                ),
                              ],
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),

                      Divider(
                        color: Colors.grey,
                      ),
                      if (widget.pmrList.medicineDetails != null && widget.pmrList.medicineDetails.isNotEmpty)
                        InkWell(
                          onTap: () {
                            showMedicianDetails(context, widget.pmrList.medicineDetails);
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 0, bottom: 5, top: 10),
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // color: Colors.blueGrey,
                                    border: Border.all(color: Colors.grey[400])),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Rx DETAILS",
                                    style: TextStyleblueGrey14,
                                  ),
                                ),
                              )),
                        ),
                      _shelfList.length > 0
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(bottom: 0, top: 10),
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // color: Colors.blueGrey,
                                  border: Border.all(color: Colors.grey[400])),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _selectedShelfPosition,
                                        items: [
                                          for (ShelfModel model in _shelfList)
                                            DropdownMenuItem(
                                              child: Text("${model.name ?? ""}", overflow: TextOverflow.ellipsis, style: TextStyleblueGrey14),
                                              value: _shelfList.indexOf(model),
                                            ),
                                        ],
                                        onChanged: (int value) {
                                          setState(() {
                                            _selectedShelfPosition = value;
                                            selectedShelf = _shelfList[value];
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 100,
                                      margin: EdgeInsets.only(left: 0),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.push(context, MaterialPageRoute(builder:  (context) => SimpleScanner())).then((value){
                                          //   if(value != null)
                                          //   Fluttertoast.showToast(msg: "$value");
                                          // });
                                          scanBarcodeNormal();
                                        },
                                        child: Image.asset(
                                          "assets/scanner_icon.png",
                                          height: 30,
                                          width: 30,
                                          color: Colors.green,
                                        ),
                                      ))
                                ],
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      if (_shelfList.length == 0)
                        Container(
                          margin: EdgeInsets.only(left: 0, bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${_shelfList.length == 0 ? "Self not available!" : ""}",
                            style: TextStyleblueGrey14,
                          ),
                        ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.pmrList.isStorageFridge == null || widget.pmrList.isStorageFridge == false
                                ? Container(
                                    height: 0,
                                    width: 0,
                                  )
                                : Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0, right: 15.0, top: 20),
                                      child: Container(
                                        height: CustomColors.chkButtonHeight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: CustomColors.fridgeColor,
                                          // border: Border.all(color: Colors.blue)
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              onChanged: (checked) {
                                                setState(() {
                                                  isFridgeNote = checked;
                                                });
                                              },
                                              value: isFridgeNote,
                                              checkColor: Colors.white,
                                              activeColor: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Fridge",
                                                style: TextStylewhite14,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            widget.pmrList.isControlledDrugs == null || widget.pmrList.isControlledDrugs == false
                                ? Container(
                                    height: 0,
                                    width: 0,
                                  )
                                : Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0, right: 5.0, top: 20),
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
                                                  isControlledDrugs = checked;
                                                });
                                              },
                                              value: isControlledDrugs,
                                              checkColor: Colors.white,
                                              activeColor: Colors.blue,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Controlled Drugs",
                                                style: TextStylewhite14,
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
                      Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                /*if(widget.pmrList == null || widget.prescriptionList.length == 0){
                                Fluttertoast.showToast(msg: "You don't have any prescription, Add and try again.");
                              }else*/
                                if (selectedShelf == null || selectedShelf.name == "Select Shelf") {
                                  Fluttertoast.showToast(msg: "Select shelf and try again.");
                                } else {
                                  /*for(Dd prescription in widget.prescriptionList){
                                  if(prescription.drugsType == null){
                                    Fluttertoast.showToast(msg: "Choose drugs type and try again.");
                                    return;
                                  }
                                }*/

                                  // AssignToShelf model = widget.pmrList;
                                  // model.medicineDetails = widget.prescriptionList;
                                  // model.rackNo = "${selectedShelf.shelfId}";
                                  // model.pickupType = "Collection";
                                  // print(model);
                                  if (!isFridgeNote && (widget.pmrList.isStorageFridge != false)) {
                                    Fluttertoast.showToast(msg: "Check Fridge");
                                    return false;
                                  } else if (!isControlledDrugs && (widget.pmrList.isControlledDrugs != false)) {
                                    Fluttertoast.showToast(msg: "Check Controlled Drugs");
                                    return false;
                                  }
                                  postDataAndVerifyUser("${selectedShelf.name}", widget.orderId);
                                }
                              },
                              child: Container(
                                  height: 45,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Text(
                                    "SUBMIT",
                                    style: TextStylewhite14,
                                  )))),
                    ],
                  ),
                )),
          ],
        ),
        /*floatingActionButton:  AnimatedOpacity(
          opacity:  isScrollDown ? 0 : 1 ,
          duration: Duration(milliseconds: 500),
          child:FloatingActionButton(
            //backgroundColor: CustomColors.yetToStartColor,
            clipBehavior: Clip.hardEdge,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  PrescriptionBarScanner(prescriptionList: widget.prescriptionList,pmrList: widget.pmrList, isAssignSelf: true,)));
            },
            child: Icon(Icons.add),
          ),
        ),*/
      ),
    );
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
                            style: TextStyle20White,
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text("Warning"),
            content: new Text("Are you sure you want to cancel all prescriptions!"),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text("No"),
              ),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text("Yes"),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);

      if (barcodeScanRes != "-1") {
        // print("qur - " + barcodeScanRes);
        FlutterBeep.beep();
        for (var i = 0; i < _shelfList.length; i++) {
          String temBarCode = barcodeScanRes;
          if (_shelfList[i].name == temBarCode) {
            // print("hello");
            setState(() {
              selectedShelf = _shelfList[i];
              _selectedShelfPosition = i;
            });
            break;
          }
        }

        // for (var data in _shelfList){
        //
        //   if (data.name == barcodeScanRes){
        //
        //   }
        // }

        //}
        //}
      } else {
        Fluttertoast.showToast(msg: "Format not correct!");
      }

      // print("barcode : $barcodeScanRes");
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    try {
      final parser = Xml2Json();
      parser.parse(barcodeScanRes);
      var json = parser.toGData();
      // print(json);
    } catch (_, stackTrace) {
      SentryExemption.sentryExemption(_, stackTrace);
    }

    //BarCodeModel barCodeModel = barCodeModelFromJson(json.toString());
  }

  // void loadPrescription(String resultData) {
  //   bool isAddPrescription = true;
  //   try{
  //     final parser = Xml2Json();
  //     parser.parse(resultData);
  //     var json = parser.toGData();
  //     print(json.toString());
  //     AssignToShelf model = assignToShelfFromJson(json);
  //     print("..${model.medicineDetails.length}.................................................");
  //     for(AssignToShelf pmrModel in widget.pmrList){
  //       if(pmrModel.sc.id == model.sc.id){
  //         Fluttertoast.showToast(msg: "This prescription already added!");
  //         isAddPrescription = false;
  //         break;
  //       }
  //     }
  //     setState(() {
  //       if(isAddPrescription){
  //         widget.pmrList.add(model);
  //         widget.prescriptionList.addAll(model.medicineDetails);
  //       }
  //     });
  //
  //   }catch(_){
  //     print(".Exception.................................................");
  //   }
  // }

  Future<void> postDataAndVerifyUser(String rackNo, orderId) async {
    // await ProgressDialog(context, isDismissible: false).show();
    CustomLoading().showLoadingDialog(context, true);
    String url = "${WebConstant.ADD_ASSIGN_TO_SHELF_PARCEL}?orderId=$orderId&rackNo=$rackNo&isScan=${widget.isScan}";
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((response) {
      // ProgressDialog(context).hide();
      CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null) {
          // print("${response.body}");
          //Map<String, Object> data = json.decode(response.body);
          if (response.body == "Assigned") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BranchAdminDashboard()));
            //Navigator.of(context).pop(true);

          }

          Fluttertoast.showToast(msg: "Shelf assigned successfully");
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // print("Exception : $e");
      }
    });
  }
}

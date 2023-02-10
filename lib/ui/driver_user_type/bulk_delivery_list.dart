// @dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/order_model.dart';
import 'package:pharmdel_business/util/CustomDialogBox.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:pharmdel_business/util/connection_validater.dart';
import 'package:pharmdel_business/util/custom_color.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../collect_order.dart';
import '../login_screen.dart';
import '../splash_screen.dart';
import 'click_image.dart';

class BulkDeliveryList extends StatefulWidget {
  @override
  State<BulkDeliveryList> createState() => _BulkDeliveryListState();
}

class _BulkDeliveryListState extends State<BulkDeliveryList> {
  ApiCallFram _apiCallFram = ApiCallFram();

  bool isProgressAvailable = false;

  String accessToken = "";

  String routeId = "", driverId = "";

  List<ReletedOrders> modelList = [];
  var yetToStartColor = const Color(0xFFF8A340);

  // ProgressDialog progressDialog;

  TextEditingController remarkController = TextEditingController();
  TextEditingController toController = TextEditingController();

  bool isFridgeNote = false, isControlledDrugs = false, isControlNote = false;

  bool isDeliveryNote = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
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
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.5,
            backgroundColor: materialAppThemeColor,
            //automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Icon(
                Icons.arrow_back,
                color: appBarTextColor,
              ),
            ),
            title: const Text('Bulk Drop', style: TextStyle(color: appBarTextColor)),

            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: Text(
                    "${modelList.length}",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              modelList.length > 0
                  ? Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 60),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 0,
                        child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),

                            itemCount: modelList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(
                                  bottom: modelList.length - 1 == index ? 70.0 : 8.0,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: InkWell(
                                        onTap: () {
                                          // logger.i("onTap${modelList.length}");
                                          modelList.removeAt(index);
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.red[400], borderRadius: BorderRadius.circular(50.0)),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    /*Text("Name", style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14
                                          ),),
                                          SizedBox(width: 5, height: 0,),*/
                                                    Flexible(
                                                      child: Text(
                                                        "${modelList[index].fullName}",
                                                        maxLines: 2,
                                                        style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w700),
                                                      ),
                                                    ),
                                                    if (modelList[index].pmr_type != null && (modelList[index].pmr_type == "titan" || modelList[index].pmr_type == "nursing_box") && modelList[index].pr_id != null && modelList[index].pr_id.isNotEmpty)
                                                      Text(
                                                        '(P/N : ${modelList[index].pr_id ?? ""}) ',
                                                        style: TextStyle(color: CustomColors.pnColor),
                                                      ),
                                                    // if (modelList[index]. ==
                                                    //     "t")
                                                    //  Image.asset(
                                                    //      "assets/automatic_icon.png",
                                                    //      height: 14,
                                                    //      width: 14),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Image.asset("assets/home_icon.png", height: 18, width: 18, color: CustomColors.yetToStartColor),
                                                    SizedBox(
                                                      width: 5,
                                                      height: 0,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        "${modelList[index].fullAddress ?? modelList[index].fullAddress ?? ""}",
                                                        style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w300),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                    if (modelList.isNotEmpty && modelList != null && modelList[index].alt_address != null && modelList[index].alt_address != "" && modelList[index].alt_address == "t")
                                                      Image.asset(
                                                        "assets/alt-add.png",
                                                        height: 18,
                                                        width: 18,
                                                      )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                modelList[index].deliveryNotes != null && modelList[index].deliveryNotes != ""
                                                    ? Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Delivery Note:   ',
                                                            style: TextStyle(fontSize: 14, color: CustomColors.yetToStartColor),
                                                          ),
                                                          Flexible(child: Text(modelList[index].deliveryNotes ?? "")),
                                                        ],
                                                      )
                                                    : SizedBox(),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false
                                                          ? Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                                color: CustomColors.drugColor,
                                                                // border: Border.all(color: Colors.blue)
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                                child: Text(
                                                                  "C.D.",
                                                                  style: TextStyle(fontSize: 10, color: Colors.white),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      if (modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false)
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                      modelList[index].isStorageFridge != null && modelList[index].isStorageFridge != false
                                                          ? Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                                color: CustomColors.fridgeColor,
                                                                // border: Border.all(color: Colors.blue)
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                                child: Text(
                                                                  "Fridge",
                                                                  style: TextStyle(fontSize: 10, color: Colors.white),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                                if (modelList != null && modelList.isNotEmpty && modelList[index].parcelBoxName != null && modelList[index].parcelBoxName != "")
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0.0, bottom: 5.0, top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                                                            child: Text(
                                                              "${modelList[index].parcelBoxName}",
                                                              style: TextStyle(
                                                                color: CustomColors.pickedUp,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please scan order now...",
                        style: TextStyle(color: Colors.grey[600], fontSize: 20),
                      )),
              if (modelList.length > 0)
                Positioned(
                  left: 13,
                  bottom: 5,
                  right: 13,
                  child: SizedBox(
                    height: 40,
                    width: 110,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 2.0,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        _modalBottomSheetMenu();
                      },
                      child: new Text(
                        "Complete",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )
            ],
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  scanBarcodeNormal();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        builder: (builder) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: AnimatedPadding(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: new Container(
                  color: Colors.transparent,
                  //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: new Container(
                      decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(20.0), topRight: const Radius.circular(20.0))),
                      child: Form(
                        child: new Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(15),
                              decoration: new BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black)),
                                color: materialAppThemeColor,
                              ),
                              child: Text(
                                "Delivery",
                                style: TextStyle(color: appBarTextColor, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: new Card(
                                  color: Colors.deepOrange[100],
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: new TextField(
                                      controller: toController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      style: TextStyle(decoration: TextDecoration.none),
                                      decoration: new InputDecoration(
                                        labelText: "Delivery to",
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: new Card(
                                  color: Colors.green[100],
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child: new TextField(
                                      controller: remarkController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: new InputDecoration(
                                        labelText: "Delivery remark",
                                        /*border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(5.0)))*/
                                      ),
                                    ),
                                  )),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0, right: 15.0, top: 5, bottom: 10),
                                      child: Container(
                                        height: CustomColors.chkButtonHeight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          // border: Border.all(color: Colors.blue)
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                              onChanged: (checked) {
                                                setState(() {
                                                  isDeliveryNote = checked;
                                                });
                                              },
                                              value: isDeliveryNote,
                                              checkColor: Colors.white,
                                              activeColor: Colors.orange,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Please read all Controlled Drug (C.D.), Fridge and Delivery Note  ",
                                                style: TextStyle(fontSize: 12, color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                        elevation: 2.0,
                                        backgroundColor: Colors.grey,
                                      ),
                                      onPressed: () {
                                        redirectNextScreen();
                                      },
                                      child: new Text(
                                        "Skip",
                                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                        elevation: 2.0,
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        redirectNextScreen();
                                      },
                                      child: new Text(
                                        "Continue",
                                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            );
          });
        });
  }

  Future<void> scanBarcodeNormal() async {
    checkLastTime(context);
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes != "-1") {
        FlutterBeep.beep();
        getOrderDetails(barcodeScanRes, true, true);
      } else {
        Fluttertoast.showToast(msg: "Format not correct!");
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  Future<void> getOrderDetails(String orderId, bool isScan, bool isComplete) async {
    // progressDialog?.show();
    await CustomLoading().showLoadingDialog(context, true);
    bool checkInternet = await ConnectionValidator().check();
    if (!checkInternet) {
      Fluttertoast.showToast(msg: WebConstant.INTERNET_NOT_AVAILABE);
      return;
    }

    if (!isProgressAvailable) {
      setState(() {
        isProgressAvailable = true;
      });
    }
    String url = "${WebConstant.SCAN_ORDER_BY_DRIVER}?OrderId=$orderId&driverId=$driverId&isScan=$isScan&routeId=$routeId&isComplete=$isComplete&orderIdMain=0";
    logger.i(url);
    logger.i(accessToken);
    _apiCallFram.getDataRequestAPI(url, accessToken, context).then((response) async {
      // progressDialog?.hide();
      await CustomLoading().showLoadingDialog(context, false);
      logger.i(response.body);
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
      setState(() {
        isProgressAvailable = false;
      });
      try {
        if (response != null) {
          OrderModal modal = orderModalFromJson(response.body);
          if ((modal.message == "") || isComplete || modal.deliveryStatusDesc == "Received" || modal.deliveryStatusDesc == "Ready" || modal.deliveryStatusDesc == "Requested") {
            // modal.orderId = int.parse(orderId);
            if (modal.deliveryStatusDesc == "Completed") {
              Fluttertoast.showToast(msg: "This order already completed.");
            } else if (modal.deliveryStatusDesc.toString().toLowerCase() == "outfordelivery") {
              if (modal.related_orders != null && modal.related_orders.isNotEmpty && modal.related_orders.length > 1) {
                List<ReletedOrders> relateOrder = [];
                modal.related_orders.forEach((element1) {
                  int indelx = modelList.indexWhere((element) => element.orderId == element1.orderId);
                  if (indelx < 0) {
                    relateOrder.add(element1);
                  }
                });
                if (relateOrder.length > 0) {
                  modal.related_orders = relateOrder;
                  showAleartOrderPoup(modal);
                } else
                  Fluttertoast.showToast(msg: "This order already exits.");
              } else {
                if (modelList.length > 0) {
                  int isAlreadyExits = modelList.indexWhere((element) => element.orderId == modal.orderId);
                  if (isAlreadyExits < 0) {
                    logger.i(modelList.last.fullAddress);
                    logger.i(modal.address.address1);
                    if (modelList.last.fullAddress != null && modal.address != null && modelList.last.fullAddress == modal.address.address1)
                      modelList.add(modal.related_orders[0]);
                    else
                      showConfirmationDialog(modal);
                  } else
                    Fluttertoast.showToast(msg: "This order already exits.");
                } else {
                  if (modal.related_orders != null && modal.related_orders.isNotEmpty) modelList.add(modal.related_orders[0]);
                }
              }
            } else {
              Fluttertoast.showToast(msg: "This order not for out for delivery.");
            }
          } else if (modal.message != null) {
            Fluttertoast.showToast(msg: modal.message ?? "");
          } else {}
        }
      } catch (_, stackTrace) {
        SentryExemption.sentryExemption(_, stackTrace);
        // progressDialog.hide();
        await CustomLoading().showLoadingDialog(context, false);
        Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body["error"] == true) {
          Fluttertoast.showToast(msg: body["message"] ?? "");
        }
        setState(() {
          isProgressAvailable = false;
        });
      }
    });
  }

  void showAleartOrderPoup(OrderModal modal) {
    try {
      if (modal != null && modal.related_orders != null && modal.related_orders.isNotEmpty && modal.related_orders.length > 0) {
        if (modal.related_order_count > 0) {
          showDialog<ConfirmAction>(
              context: context,
              barrierDismissible: false,
              // user must tap button for close dialog!
              builder: (BuildContext context1) {
                return CustomDialogBox(
                  img: Image.asset("assets/delivery_truck.png"),
                  title: "Multiple Delivery...",
                  btnDone: "Yes",
                  btnNo: "No",
                  descriptions: "${modal.related_order_count} more delivery for this address. Would you like to deliver?",
                  onClicked: (value) {
                    showOrderList(modal, value);
                  },
                );
              });
        } else
          showOrderList(modal, true);
      }
    } catch (_, stackTrace) {
      SentryExemption.sentryExemption(_, stackTrace);
      logger.i(_);
    }
  }

  void showOrderList(OrderModal modal, bool otherDelivery) {
    List<ReletedOrders> modelList = [];

    if (!otherDelivery) {
      modal.related_orders.forEach((element) {
        if (modal.customerId == element.userId) {
          modelList.add(element);
        }
      });
    } else {
      modelList = modal.related_orders;
    }
    if (modelList.length == 0) {
    } else {
      bool allSelected = false;
      showDialog(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (context) {
            return SafeArea(
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  return Scaffold(
                    body: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 0,
                          padding: EdgeInsets.all(10.00),
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Orders List",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.clear_rounded,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: allSelected,
                                onChanged: (value) {
                                  allSelected = value;
                                  for (int i = 0; i < modelList.length; i++) {
                                    modelList[i].isSelected = value;
                                  }
                                  setState(() {});
                                }),
                            Flexible(
                              child: Text(
                                "Select All",
                                style: TextStyle(fontSize: 12, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height - 250,
                          child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: modelList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.only(
                                    bottom: modelList.length - 1 == index ? 70.0 : 8.0,
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      /*Text("Name", style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14
                                                      ),),
                                                      SizedBox(width: 5, height: 0,),*/
                                                      SizedBox(
                                                        height: 24,
                                                        width: 24,
                                                        child: Checkbox(
                                                            value: modelList[index].isSelected,
                                                            onChanged: (value) {
                                                              modelList[index].isSelected = value;
                                                              allSelected = true;
                                                              for (int i = 0; i < modelList.length; i++) {
                                                                if (modelList[i].isSelected == false) {
                                                                  allSelected = false;
                                                                }
                                                              }
                                                              setState(() {});
                                                            }),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "${modelList[index].fullName ?? ""}",
                                                          maxLines: 2,
                                                          style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                      if (modelList[index].pmr_type != null && (modelList[index].pmr_type == "titan" || modelList[index].pmr_type == "nursing_box") && modelList[index].pr_id != null && modelList[index].pr_id.isNotEmpty)
                                                        Text(
                                                          '(P/N : ${modelList[index].pr_id ?? ""}) ',
                                                          style: TextStyle(color: CustomColors.pnColor),
                                                        ),
                                                      if (modelList[index].isCronCreated == "t") Image.asset("assets/automatic_icon.png", height: 14, width: 14),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Image.asset("assets/home_icon.png", height: 18, width: 18, color: CustomColors.yetToStartColor),
                                                      SizedBox(
                                                        width: 5,
                                                        height: 0,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          "${modelList[index].fullAddress ?? modelList[index].fullAddress ?? ""}",
                                                          style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w300),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  modelList[index].deliveryNotes != null && modelList[index].deliveryNotes != ""
                                                      ? Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Delivery Note:   ',
                                                              style: TextStyle(fontSize: 14, color: CustomColors.yetToStartColor),
                                                            ),
                                                            Flexible(child: Text(modelList[index].deliveryNotes ?? "")),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  modelList[index].existing_delivery_notes != null && modelList[index].existing_delivery_notes != ""
                                                      ? Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Existing Note:   ',
                                                              style: TextStyle(fontSize: 14, color: CustomColors.yetToStartColor),
                                                            ),
                                                            Flexible(child: Text(modelList[index].existing_delivery_notes ?? "")),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                  color: CustomColors.drugColor,
                                                                  // border: Border.all(color: Colors.blue)
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                                  child: Text(
                                                                    "C.D.",
                                                                    style: TextStyle(fontSize: 10, color: Colors.white),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        if (modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false)
                                                          SizedBox(
                                                            width: 10.0,
                                                          ),
                                                        modelList[index].isStorageFridge != null && modelList[index].isStorageFridge != false
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                  color: CustomColors.fridgeColor,
                                                                  // border: Border.all(color: Colors.blue)
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                                                                  child: Text(
                                                                    "Fridge",
                                                                    style: TextStyle(fontSize: 10, color: Colors.white),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              elevation: 2.0,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              int count = modelList.where((elements) => elements.isSelected == true).toList().length;
                              if (count > 0) {
                                Navigator.of(context).pop();
                                addMultiOrders(modelList);
                              } else {
                                Fluttertoast.showToast(msg: "Select minimum 1 order");
                              }
                            },
                            child: new Text(
                              "Complete",
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            );
          });
    }
  }

  void init() {
    if (toController.text == "") {
      toController.text = "Patient";
    }
    // progressDialog = ProgressDialog(context, isDismissible: true);
    SharedPreferences.getInstance().then((value) async {
      // print(value);
      accessToken = value.getString(WebConstant.ACCESS_TOKEN);
      routeId = value.getString(WebConstant.ROUTE_ID) ?? "";
      driverId = value.getString(WebConstant.USER_ID) ?? "";
    });
    scanBarcodeNormal();
  }

  void redirectNextScreen() {
    if (!isDeliveryNote) {
      Fluttertoast.showToast(msg: "Check C.D., Fridge and Delivery note");
      return;
    }
    if (modelList.isEmpty) {
      return;
    }
    List orderId = [];

    modelList.forEach((element) {
      orderId.add(element.orderId.toString());
    });
    int index = modelList.indexWhere((element) => element.isControlledDrugs == true);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClickImage(
                  delivery: null,
                  routeId: routeId,
                  isCdDelivery: index != null && index >= 0 ? modelList[index].isControlledDrugs : false,
                  selectedStatusCode: 5,
                  remarks: "${remarkController.text}",
                  deliveredTo: "${toController.text}",
                  orderid: orderId,
                )));
  }

  void showConfirmationDialog(OrderModal modal) {
    BuildContext dialogContext;
    Widget cancelButton = SizedBox(
        height: 35.0,
        width: 110.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 2.0,
            backgroundColor: Colors.white,
          ),
          child: Text(
            'Cancel',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13.0),
          ),
          onPressed: () {
            Navigator.of(dialogContext).pop(true);
          },
        ));
    Widget continueButton = SizedBox(
        height: 35.0,
        width: 110.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 2.0,
            backgroundColor: Colors.white,
          ),
          child: Text(
            'Add Now',
            textAlign: TextAlign.center,
            style: TextStyle(color: yetToStartColor, fontWeight: FontWeight.bold, fontSize: 13.0),
          ),
          onPressed: () {
            if (modal.related_orders != null && modal.related_orders.isNotEmpty) {
              Navigator.of(dialogContext).pop(true);
              modelList.add(modal.related_orders[0]);
              setState(() {});
            }
          },
        ));
    // set up the AlertDialog
    var alert = StatefulBuilder(
      builder: (context, setState) {
        dialogContext = context;
        return AlertDialog(
          title: Icon(
            Icons.warning_rounded,
            color: Colors.red,
            size: 40,
          ),
          content: Text("Address is different  !!!\nWould you still like to deliver?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cancelButton,
                continueButton,
              ],
            ),
          ],
        );
      },
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addMultiOrders(List<ReletedOrders> modelList1) {
    modelList1.forEach((modal) {
      if (modal.isSelected) if (modelList.length > 0) {
        int isAlreadyExits = modelList.indexWhere((element) => element.orderId == modal.orderId);
        if (isAlreadyExits < 0 && modal.isSelected) {
          modelList.add(modal);
        }
      } else
        modelList.add(modal);
    });
    setState(() {});
  }
}

import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Controller/WidgetController/CustomDrawer/drawerDriver.dart';
import '../../../Controller/WidgetController/Default Widget/DefaultWidget.dart';
import '../../../Controller/WidgetController/Popup/PopupCustom.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/WidgetController/Toast/ToastCustom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
  bool isVisiblePharmacyList = false;
  bool isVisibleRouteList = false;
  bool isToteList = false;
  bool isRouteStart = false;
  bool hideTote = false;
  String driverType = "";

  List<String> routeList = ['north', 'south'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          title: BuildText.buildText(text: kBulkScan, size: 15),
          centerTitle: true,
          backgroundColor: AppColors.colorAccent.withOpacity(0.7),
          // automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: AppColors.blackColor),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 0),
              child: Row(
                children: [
                  Switch(
                    onChanged: (bool value) {
                      isSwitched = value;
                      setState(() {});
                    },
                    value: isSwitched,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blue,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.grey[400],
                  ),
                  InkWell(onTap: () {}, child: const Icon(Icons.refresh)),
                  buildSizeBox(0.0, 5.0),
                  InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.qr_code,
                        size: 30,
                      )),
                  buildSizeBox(0.0, 5.0),
                  InkWell(
                      onTap: () {
                        Get.toNamed(notificationScreenRoute);
                      },
                      child: const Icon(
                        Icons.notifications,
                        size: 30,
                      )),
                ],
              ),
            )
          ],
        ),
        drawer: DrawerDriver(),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              backgroundColor: Colors.orange,
              label: Column(
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  BuildText.buildText(
                      text: kScanRx, color: AppColors.whiteColor)
                ],
              ),
              onPressed: () {
                barcodeScanning();
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(strIMG_HomeBg)),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isRouteStart) {
                        ToastCustom.showToast(
                            msg:
                                "You are already on a route, you can't change before completed.");
                      } else {
                        if (routeList.isNotEmpty) {
                          isVisibleRouteList = !isVisibleRouteList;
                          isVisiblePharmacyList = false;
                          isToteList = false;
                          hideTote = true;
                        } else {
                          ToastCustom.showToast(
                              msg:
                                  "You don't have any route. Try again after and refresh now.");
                          isVisibleRouteList = false;
                        }
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 13.0, right: 10.0, top: 12, bottom: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                                //border: Border.all(color: Colors.grey[400]),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                      color: Colors.grey.shade300)
                                ]),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: BuildText.buildText(
                                    text: kSelectRoute,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.lightBlue),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.lightBlue,
                                ),
                              ],
                            ),
                          ),
                        ),
                        buildSizeBox(0.0, 5.0),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {                         
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  //border: Border.all(color: Colors.grey[400]),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300)
                                  ]),
                              child: Row(
                                children: const <Widget>[
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      kSelectPhar,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.lightBlue),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.lightBlue,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      left: 2.5, right: 2.5, top: 0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.blueColor,
                              label: kTotal,
                              counter: '0',
                              onTap: () {})),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.greyColor,
                              label: kPickedUp,
                              counter: '0',
                              onTap: () {})),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.greenColor.withOpacity(0.7),
                              label: kDelivered,
                              counter: '0',
                              onTap: () {})),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.redColor.withOpacity(0.8),
                              label: kFailed,
                              counter: '0',
                              onTap: () {})),
                    ],
                  ),
                ),
                Visibility(
                  visible: isVisiblePharmacyList,
                  child: Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              color: Colors.grey.shade300)
                        ]),
                    child: Column(
                      children: [
                        ListView.separated(
                          itemCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // PharmacyList pharmacy = pharmacyList[index];
                            return InkWell(
                              onTap: () {
                                // setState(() {
                                //   selectedPharmacyDropDown =
                                //   pharmacyList[index];
                                //   _selectedPharmacyPosition = index;
                                // });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 13.0,
                                    right: 10.0,
                                    top: 12,
                                    bottom: 12),
                                color:
                                    // pharmacy == selectedPharmacyDropDown //route == selectedRoute//_selectedRoutePosition == index ?
                                    Colors.blue[50],
                                // : Colors.transparent,
                                child: const Text(
                                  "Select Pharmacy",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.lightBlue),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 1,
                            );
                          },
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 12, bottom: 12),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // selectedPharmacyDropDown =
                                      //     selectedPharmacy;
                                      // _isVisiblePharmacyList = false;
                                      // hideTote = false;
                                    });
                                  },
                                  child: BuildText.buildText(
                                    text: "Cancel",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.redAccent),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: InkWell(
                                  onTap: () {
                                    // if (_selectedPharmacyPosition < 0) {
                                    //   Fluttertoast.showToast(
                                    //       msg: "Choose Pharmacy First");
                                    //   return;
                                    // }
                                    // setState(() {
                                    //   _isVisiblePharmacyList = false;
                                    //   selectedPharmacy =
                                    //   pharmacyList[_selectedPharmacyPosition];
                                    //   pharmacyId =
                                    //   "${selectedPharmacy.pharmacyId}";
                                    //   hideTote = false;
                                    // });
                                  },
                                  child: BuildText.buildText(
                                    text: "Confirm",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.greenAccent),
                                    textAlign: TextAlign.center,
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
                Visibility(
                  visible: isToteList,
                  child: Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        //border: Border.all(color: Colors.grey[400]),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              color: Colors.grey.shade300)
                        ]),
                    child: Column(
                      children: <Widget>[
                        ListView.separated(
                          itemCount: 2,
                          // parcelBoxList != null &&
                          //     parcelBoxList.isNotEmpty
                          //     ? parcelBoxList.length
                          //     : 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // ParcelBoxData nusingList = parcelBoxList[index];
                            return InkWell(
                              onTap: () {
                                // setState(() {
                                //   totePosition = index;
                                // });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 13.0,
                                    right: 10.0,
                                    top: 12,
                                    bottom: 12),
                                color:
                                    // totePosition ==
                                    //     index //route == selectedRoute//_selectedRoutePosition == index ?
                                    Colors.blue[50],
                                // : Colors.transparent,
                                child: BuildText.buildText(
                                  text: 'Parcel Location',
                                  // "${nusingList.name ?? "Parcel Location"}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.lightBlue),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(height: 1);
                          },
                        ),
                        const Divider(height: 1),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 12, bottom: 12),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: InkWell(
                                  onTap: () {
                                    // setState(() {
                                    //   _isToteList = false;
                                    //   hideTote = false;
                                    // });
                                  },
                                  child: BuildText.buildText(
                                    text: kCancel,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.redColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: InkWell(
                                  onTap: () {
                                    // if (totePosition < 0) {
                                    //   Fluttertoast.showToast(
                                    //       msg: "Choose Nursing Home");
                                    //   return;
                                    // }
                                    // setState(() {
                                    //   _isToteList = false;
                                    //   _selectedTotePosition = totePosition;
                                    //   logger.i(_selectedTotePosition);
                                    //   hideTote = false;
                                    // });
                                  },
                                  child: BuildText.buildText(
                                    text: kConfirm,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.greenColor),
                                    textAlign: TextAlign.center,
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
                Visibility(
                  visible: isVisibleRouteList,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 0, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                                color: Colors.grey.shade300)
                          ]),
                      child: Column(
                        children: <Widget>[
                          ListView.separated(
                            itemCount: 2,
                            // routeList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // RouteList route = routeList[index];
                              return InkWell(
                                onTap: () {
                                  // setState(() {
                                  //   selectedRouteDropDown = routeList[index];
                                  //   _selectedRoutePosition = index;
                                  // });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: 13.0,
                                      right: 10.0,
                                      top: 12,
                                      bottom: 12),
                                  color:
                                      // route ==
                                      // selectedRouteDropDown //route == selectedRoute//_selectedRoutePosition == index
                                      // ?
                                      Colors.blue[50],
                                  // : Colors.transparent,
                                  child: BuildText.buildText(
                                    text: kSelectPhar,
                                    // "${route.routeName ?? "Select Pharmacy"}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.lightBlue),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                height: 1,
                              );
                            },
                          ),
                          const Divider(
                            height: 1,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 12, bottom: 12),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      // setState(() {
                                      //   selectedRouteDropDown = selectedRoute;
                                      //   _isVisibleRouteList = false;
                                      //   hideTote = false;
                                      // });
                                    },
                                    child: BuildText.buildText(
                                      text: kCancel,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.redColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: InkWell(
                                    onTap: () {
                                      // if (_selectedRoutePosition < 0) {
                                      //   Fluttertoast.showToast(
                                      //       msg: "Choose Route First");
                                      //   return;
                                      // }
                                      // setState(() {
                                      //   selectedType =
                                      //       WebConstant.Status_total;
                                      //   _isVisibleRouteList = false;
                                      //   hideTote = false;
                                      //   selectedRoute =
                                      //   routeList[_selectedRoutePosition];

                                      //   routeId = "${selectedRoute.routeId}";
                                      //   SharedPreferences.getInstance().then((
                                      //       value) {
                                      //     value.setString(
                                      //         WebConstant.ROUTE_ID, routeId);
                                      //   });
                                      //   setState(() {
                                      //     isProgressAvailable = true;
                                      //   });
                                      //   orderListType = 1;
                                      //   fetchDeliveryList(0);
                                      // });
                                    },
                                    child: BuildText.buildText(
                                      text: kConfirm,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.greenAccent),
                                      textAlign: TextAlign.center,
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
                )
              ],
            ),
          ],
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return const ConfirmationRouteStartDialog();
              },
            );
          },
          child: Container(
            color: AppColors.blueColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildText.buildText(
                    text: kStartRoute,
                    color: AppColors.whiteColor,
                    size: 16,
                    weight: FontWeight.w700),
              ],
            ),
          ),
        ));
  }

  Future barcodeScanning() async {
    var result = await BarcodeScanner.scan(); //options: ScanOptions()
    PrintLog.printLog("Type:${result.type}");
    PrintLog.printLog("RawContent:${result.rawContent}");
    if (result.rawContent.toString().length > 10) {
      PrintLog.printLog("Product code is :${result.rawContent}");
    } else {
      ToastCustom.showToast(msg: 'Not found');
    }
  }
}

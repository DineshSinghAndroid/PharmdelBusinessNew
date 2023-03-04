import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/View/MapScreen/map_screen.dart';
import '../../../Controller/ProjectController/DriverDashboardController.dart/driverDashboardController.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Default Functions/defaultFunctions.dart';
import '../../../Controller/WidgetController/AdditionalWidget/DeliveryCardCustom/deliveryCardCustom.dart';
import '../../../Controller/WidgetController/ErrorHandling/ErrorDataScreen.dart';
import '../../../Controller/WidgetController/ErrorHandling/NetworkErrorScreen.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

DriverDashboardController drDashCtrl = Get.put(DriverDashboardController());

bool isSwitched = false;
bool isVisiblePharmacyList = false;
bool isVisibleRouteList = false;
bool isToteList = false;
bool isRouteStart = false;
bool hideTote = false;
bool isLoadPagination = false;
bool isProgressAvailable = false;
bool isPickedUp = false;
String driverType = "";
int? page, lastPageLength, orderListType = 1;
String selectedType = "total";

List<String> routeList = ['north', 'south'];

 @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    drDashCtrl.isNetworkError = false;
    drDashCtrl.isEmpty = false;
    if (await ConnectionValidator().check()) {
      await drDashCtrl.driverDashboardApi(context: context,routeID: "1");
      await drDashCtrl.driverRoutesApi(context: context);
    } else {
      drDashCtrl.isNetworkError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardController>(
      init: drDashCtrl,
      builder: (controller) {
        return LoadScreen(
            isLoading: controller.isLoading,
            widget: controller.isError ?
            ErrorScreen(
              onTap: () {
                init();
              },
            )
                : controller.isNetworkError ?
            NoInternetConnectionScreen(
              onTap: () {
                init();
              },
            )
                : controller.isEmpty ?
            EmptyDataScreen(
              onTap: () {
                Navigator.pop(context);
              }, isShowBtn: true, string: kEmptyData,
            ) :
            WillPopScope(
              onWillPop: () async => false,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                    backgroundColor: AppColors.whiteColor,
                    appBar: AppBar(
                      title: BuildText.buildText(text: kBulkScan, size: 15),
                      centerTitle: true,
                      backgroundColor: AppColors.colorOrange,
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
                              InkWell(
                                  onTap: () {
                                    init();
                                  },
                                  child: const Icon(Icons.refresh)),
                              buildSizeBox(0.0, 10.0),
                              InkWell(
                                  onTap: () {
                                    Get.toNamed(mapScreenRoute,
                                    arguments: MapScreen(
                                      driverId: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId), 
                                      routeId: controller.orderDetailData?.routeId ?? ""));
                                  },
                                  child: Image.asset(strIMG_location,height: 25,color: AppColors.redColor,)),
                              buildSizeBox(0.0, 10.0),
                              InkWell(
                                  onTap: () {
                                    Get.toNamed(notificationScreenRoute);
                                  },
                                  child: Stack(
                                    children: [
                                      const Center(
                                        child: Icon(
                                          Icons.notifications,
                                          size: 30,
                                        ),
                                      ),
                                      Positioned(
                                        right: 1,
                                        top: 12,
                                        child: SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircleAvatar(
                                            backgroundColor: AppColors.redColor,                                            
                                            child: BuildText.buildText(
                                              text: controller.driverDashboardData?.notificationCount ?? "",
                                              //controller.notificationCountData?.list ?? "",
                                              // notification_count != null
                                              //     ? notification_count > 99
                                              //     ? "+99"
                                              //     : notification_count.toString()
                                              //     : "",
                                              size: 9,
                                              color: AppColors.whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    drawer: const DrawerDriver(),
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
                            Get.toNamed(searchPatientScreenRoute);
                            // Get.toNamed(scanPrescriptionScreenRoute);                            
                            DefaultFuntions.barcodeScanning();
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
                                    ToastCustom.showToast(msg: kChangeRouteMsg);
                                  } else {
                                    if (routeList.isNotEmpty) {
                                      isVisibleRouteList = !isVisibleRouteList;
                                      isVisiblePharmacyList = false;
                                      isToteList = false;
                                      hideTote = true;
                                    } else {
                                      ToastCustom.showToast(msg: kDontHaveroute);
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
                                        padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
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
                                                size: 14,
                                                color: AppColors.blueColorLight,
                                                weight: FontWeight.w400,
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
                                    isSwitched == true ?
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (isRouteStart) {
                                              ToastCustom.showToast(msg: kChangeRouteMsg);
                                            } else {
                                              if (routeList.isNotEmpty) {
                                                isVisiblePharmacyList = !isVisiblePharmacyList;
                                                isVisibleRouteList = false;
                                                isToteList = false;
                                                hideTote = true;
                                              } else {
                                                ToastCustom.showToast(msg: kDontHaveroute);
                                                isVisiblePharmacyList = false;
                                              }
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 13.0, right: 10.0, top: 12, bottom: 12),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              color: AppColors.whiteColor,
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
                                                  text: kSelectPhar,
                                                  size: 14,
                                                  color: AppColors.blueColorLight,
                                                  weight: FontWeight.w400,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.lightBlue,
                                              )
                                            ],
                                          ) 
                                        ),
                                      ),
                                    ) : const SizedBox.shrink()
                                  ],
                                ),
                              ),
                            ),

                            ///Top counter widgets
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(left: 2.5, right: 2.5, top: 0, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DefaultWidget.topCounter(
                                          bgColor: AppColors.blueColor,
                                          label: kTotal,
                                          counter: controller.driverDashboardData?.orderCounts?.totalOrders ?? "",
                                          onTap: () {
                                            setState(() {
                                              isPickedUp = false;
                                            });
                                            orderListType = 1;
                                          })),
                                      isRouteStart == false ?    
                                      Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DefaultWidget.topCounter(
                                          bgColor: AppColors.yetToStartColor,
                                          label: kOnTheWay,
                                          counter: controller.driverDashboardData?.orderCounts?.totalOrders ?? "",
                                          onTap: () {
                                            setState(() {
                                              isPickedUp = false;
                                            });
                                          })) :
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DefaultWidget.topCounter(
                                          bgColor: AppColors.greyColor,
                                          label: kPickedUp,
                                          counter: controller.driverDashboardData?.orderCounts?.pickedupOrders ?? "",
                                          onTap: () {
                                            setState(() {
                                              isPickedUp = true;
                                            });
                                          })),
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DefaultWidget.topCounter(
                                          bgColor: AppColors.greenColor.withOpacity(0.7),
                                          label: kDelivered,
                                          counter: controller.driverDashboardData?.orderCounts?.deliveredOrders ?? "",
                                          onTap: () {
                                            setState(() {
                                              isPickedUp = false;
                                            });
                                          })),
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DefaultWidget.topCounter(
                                          bgColor: AppColors.redColor.withOpacity(0.8),
                                          label: kFailed,
                                          counter: controller.driverDashboardData?.orderCounts?.faildOrders ?? "",
                                          onTap: () {
                                            setState(() {
                                              isPickedUp = false;
                                            });
                                          })),
                                ],
                              ),
                            ),

                            DeliveryCardCustom(
                              name: 'Tester',
                              address: kAddressPara,
                              status: kPickedUp,
                              onTap: (){
                                Get.toNamed(updateStatusScreenRoute);
                              },
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
                                      itemCount: controller.routesData?.pharmacyList?.length ?? 0,
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
                                            padding: const EdgeInsets.only(left: 13.0,right: 10.0,top: 12,bottom: 12),
                                            color:
                                            // pharmacy == selectedPharmacyDropDown //route == selectedRoute//_selectedRoutePosition == index ?
                                            Colors.blue[50],
                                            // : Colors.transparent,
                                            child: BuildText.buildText(
                                              text: controller.routesData?.pharmacyList?[index].pharmacyName ?? "",
                                              size: 14,
                                              color: AppColors.blueColorLight,
                                              weight: FontWeight.w400,
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
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12, bottom: 12),
                                      child: Row(
                                        children: [
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
                                                  text: kCancel,
                                                  size: 14,
                                                  weight: FontWeight.w800,
                                                  color: AppColors.redColor,
                                                  textAlign: TextAlign.center
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
                                                  text: kConfirm,
                                                  size: 14,
                                                  color: AppColors.greenAccentColor,
                                                  weight: FontWeight.w800,
                                                  textAlign: TextAlign.center
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

                            ///Parcel Location
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
                                  children: [
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
                                            padding: const EdgeInsets.only(left: 13.0,right: 10.0,top: 12,bottom: 12),
                                            color:
                                            // totePosition ==
                                            //     index //route == selectedRoute//_selectedRoutePosition == index ?
                                            AppColors.blueColor,
                                            // : Colors.transparent,
                                            child: BuildText.buildText(
                                              text: kParcelLocation,
                                              size: 14,
                                              color: AppColors.blueColorLight,
                                              weight: FontWeight.w400,
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
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12, bottom: 12),
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
                                                size: 14,
                                                color: AppColors.redColor,
                                                weight: FontWeight.w800,
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
                                                size: 14,
                                                color: AppColors.greenColor,
                                                weight: FontWeight.w800,
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

                        //Select Route
                        Positioned(
                          top: 60,
                          child: Visibility(
                                visible: isVisibleRouteList,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: Container(
                                    height: 350,
                                    margin: const EdgeInsets.only(top: 0, bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: AppColors.whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                              color: Colors.grey.shade300)
                                        ]),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 300,
                                          width: Get.width,
                                          child: ListView.separated(
                                            itemCount: controller.routesData?.routeList?.length ?? 0,
                                            // routeList.length,
                                            shrinkWrap: true,
                                            physics: const AlwaysScrollableScrollPhysics(),
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
                                                  padding: const EdgeInsets.only(left: 13.0,right: 10.0,top: 12,bottom: 12),
                                                  color:
                                                  // route ==
                                                  // selectedRouteDropDown //route == selectedRoute//_selectedRoutePosition == index
                                                  // ?
                                                  Colors.blue[50],
                                                  // : Colors.transparent,
                                                  child: BuildText.buildText(
                                                    text: controller.routesData?.routeList?[index].routeName ?? "",
                                                    // "${route.routeName ?? "Select Pharmacy"}",
                                                    size: 14,
                                                    color: AppColors.blueColorLight,
                                                    weight: FontWeight.w400,
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (BuildContext context, int index) {
                                              return const Divider(height: 1);
                                            },
                                          ),
                                        ),
                                        const Divider(height: 1),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 12, bottom: 12),
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
                                                      size: 14,
                                                      color: AppColors.redColor,
                                                      weight: FontWeight.w800,
                                                      textAlign: TextAlign.center
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
                                                      size: 14,
                                                      color: AppColors.greenAccentColor,
                                                      weight: FontWeight.w800,
                                                      textAlign: TextAlign.center
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
                              ),
                        )
                      ],
                    ),
                    bottomNavigationBar: 
                    isPickedUp == true ?
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {                            
                            return   const ConfirmationRouteStartDialog();
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
                    ) : const SizedBox.shrink()
                    ),)
            );
      },
    );
  }

  // Future<void> selectWithTypeCount(String status) async {
  //   isDelivery = false;
  //   if (routeId.isEmpty) {
  //     ToastCustom.showToast(msg: "Select route and try again!");
  //   } else {
  //     setState(() {
  //       page = 0;
  //       lastPageLength = -1;
  //       selectedType = status;

  //       if (!isProgressAvailable!) {
  //         setState(() {
  //           isProgressAvailable = true;
  //         });
  //       }

  //       if (status == kStatusOutForDelivery) {
  //         selectedType = kStatusOutForDelivery;
  //         getParcelList(0);
  //       } else {
  //         fetchDeliveryList(0);
  //       }
  //     });
  //   }
  // }
}



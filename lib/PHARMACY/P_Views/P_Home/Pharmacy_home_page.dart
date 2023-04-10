import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/View/ScanPrescription/scan_prescription.dart';
import '../../../Controller/PharmacyControllers/P_DashboardScreenController/P_dashboardScreenCotroller.dart';
import '../../../Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/PharmacyHomeCardWidget/p_homecard_widgte.dart';
import '../P_Drawer/pharmacy_drawer_screen.dart';
import '../P_ScanPrescription/p_scan_prescription_screen.dart';

class PharmacyHomeScreen extends StatefulWidget {
  const PharmacyHomeScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyHomeScreen> createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends State<PharmacyHomeScreen> {
  String? userId, token, userName, email, mobile;
  String? versionCode;
  PDashboardScreenController controller = Get.put(PDashboardScreenController());
  PharmacyNotificationController NtfCtrl = Get.put(PharmacyNotificationController());

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    NtfCtrl.createNotificationApi(context: context);
    controller.callGetRoutesApi(context: context);
    // controller.callGetDriverListApi(context: context);    
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PDashboardScreenController>(
        init: controller,
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(                   
              drawer: PharmacyDrawerScreen(versionCode: versionCode),            
              appBar: AppBar(
                elevation: 1,
                iconTheme: IconThemeData(color: AppColors.blackColor),
                centerTitle: true,
                title: BuildText.buildText(text: kHome, style: Regular18Style),
                backgroundColor: AppColors.whiteColor,
                flexibleSpace: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(                  
                    onTap: (){
                      Get.toNamed(pharmacyNotificationScreenRoute);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 0, right: 0, top: 30),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.notifications,
                              size: 30,
                              color: AppColors.blackColor,
                            ),
                          ),
                          // if (notification_count != null && notification_count > 0)
                          // Positioned(
                          //   left: 15,
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     height: 18,
                          //     width: 18,
                          //     decoration: BoxDecoration(color: AppColors.redColor, shape: BoxShape.circle),
                          //     child: BuildText.buildText(
                          //       text: '99+',
                          //       size: 10,
                          //       color: AppColors.whiteColor,
                          //       weight: FontWeight.bold
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(strIMG_HomeBg)),
                    SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      PharmacyHomeCardWidget(
                        title: kDeliveries,
                        image: strIMG_DelTruck2,
                        backgroundColor: AppColors.blueColor,
                        onTap: (){
                          Get.toNamed(pharmacyDeliveryListScreenRoute);
                        },
                      ),
                      PharmacyHomeCardWidget(
                        title: kTrackOrder,
                        image: strIMG_Location,
                        backgroundColor: AppColors.greenAccentColor,
                        onTap: () {
                          Get.toNamed(pharmacyTrackOrderScreen);
                        },
                      ),
                      PharmacyHomeCardWidget(
                        title: kScanAndBook,
                        image: strIMG_QrCode,
                        backgroundColor: AppColors.colorOrange,
                        onTap: () async {
<<<<<<< HEAD
                          Get.toNamed(p_scanPrescriptionScreenRoute,
                          arguments: P_ScanPrescriptionScreen(
=======
                          Get.toNamed(scanPrescriptionScreenRoute,
                          arguments: ScanPrescriptionScreen(                            
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
                            isAssignSelf: true,
                            isBulkScan: false,                            
                            type: "1",                            
                            pmrList: [],
                            prescriptionList: [],
                          ));
                        },
                      ),
                      PharmacyHomeCardWidget(
                        title: kNursHomeBoxBook,
                        image: strIMG_QrCode,
                        backgroundColor: AppColors.blueColorLight,
                        onTap: () {
                          Get.toNamed(nursingHomeScreenRoute);
                        },
                      ),
                    ],
                  ),
                )),
                  ],
                )
              ),
            ),
          );
        });
  }
}

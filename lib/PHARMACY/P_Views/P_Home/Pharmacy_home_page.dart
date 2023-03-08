import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/AdditionalWidget/Default%20Functions/defaultFunctions.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/PharmacyControllers/P_DashboardScreenController/P_dashboardScreenCotroller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/PharmacyHomeCardWidget/p_homecard_widgte.dart';
import '../P_Drawer/pharmacy_drawer_screen.dart';

class PharmacyHomeScreen extends StatefulWidget {
  const PharmacyHomeScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyHomeScreen> createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends State<PharmacyHomeScreen> {
  String? userId, token, userName, email, mobile;
  String? versionCode;
  PDashboardScreenController controller = Get.put(PDashboardScreenController());
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    controller.callGetRoutesApi(context: context);
    controller.callGetDriverListApi(context: context);
  }
  @override
  Widget build(
      BuildContext context) {
    return GetBuilder<PDashboardScreenController>(
      init: controller,
      builder: (controller) {
      return Scaffold(
        drawer: PharmacyDrawerScreen(versionCode: versionCode),
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          elevation: 0.5,
          iconTheme: IconThemeData(color: AppColors.blackColor),
          centerTitle: true,
          title: BuildText.buildText(text: kHome, style: Regular18Style),
          backgroundColor: AppColors.whiteColor,
          flexibleSpace: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())).then((value) => updateApi(token));
              },
              child: Container(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 30),
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(pharmacyNotificationScreenRoute);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.notifications,
                          size: 30,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    // if (notification_count != null && notification_count > 0)
                    Positioned(
                      left: 15,
                      child: Container(
                        alignment: Alignment.center,
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                            color: AppColors.redColor,
                            shape: BoxShape.circle
                        ),
                        child: BuildText.buildText(
                          text: '0',
                          size: 12,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    PharmacyHomeCardWidget(
                      title: kDeliveries,
                      image: strIMG_DelTruck2,
                      backgroundColor: AppColors.blueColor,
                      onTap: (){
                        print('Tap');
                        Get.toNamed(pharmacyDeliveryListScreenRoute);
                      },
                    ),

                    PharmacyHomeCardWidget(
                      title: kTrackOrder,
                      image: strIMG_Location,
                      backgroundColor: AppColors.greenAccentColor,
                      onTap: (){
                        Get.toNamed(pharmacyTrackOrderScreen);
                      },
                    ),

                    PharmacyHomeCardWidget(
                      title: kScanAndBook,
                      image: strIMG_QrCode,
                      backgroundColor: AppColors.colorOrange,
                      onTap: ()async{
                        Get.toNamed(searchPatientScreenRoute);
                        DefaultFuntions.barcodeScanning();
                      },
                    ),

<<<<<<< HEAD:lib/PHARMACY/P_Views/P_Home/Pharmacy_home_page.dart
              PharmacyHomeCardWidget(
                title: kNursHomeBoxBook,
                image: strIMG_QrCode,
                backgroundColor: AppColors.blueColorLight,
                onTap: (){
                  Get.toNamed(nursingHomeScreenRoute);
                },
              ),
            ],
          ),
        )),
      ),
    );
=======
                    PharmacyHomeCardWidget(
                      title: kNursHomeBoxBook,
                      image: strIMG_QrCode,
                      backgroundColor: AppColors.blueColorLight,
                      onTap: (){},
                    ),
                  ],
                ),
              )),
        ),
      );
    },);
>>>>>>> 47016b27616b89a66ac6ff70e9d664bb25bcc2ef:lib/PHARMACY/P_Views/P_Home/Pharmacy_home_age.dart
  }
}

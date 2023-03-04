import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
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

  dynamic notification_count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PharmacyDrawerScreen(versionCode: versionCode),
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0.5,
        iconTheme: IconThemeData(color: AppColors.blackColor),
        centerTitle: true,
        title: BuildText.buildText(text: 'Home', style: Regular18Style),
        backgroundColor: AppColors.whiteColor,
        flexibleSpace: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())).then((value) => updateApi(token));
            },
            child: Container(
              padding: const EdgeInsets.only(left: 0, right: 13, top: 30),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(pharmacyNotificationScreenRoute);
                    },
                    child: Icon(
                      Icons.notifications,
                      size: 30,
                      color: AppColors.blackColor,
                    ),
                  ),
                  if (notification_count != null && notification_count > 0)
                    Positioned(
                      right: 5,
                      top: 2,
                      child: SizedBox(
                        height: 12,
                        width: 12,
                        child: CircleAvatar(
                          backgroundColor: AppColors.redColor,
                          child: BuildText.buildText(
                            text: notification_count != null
                                ? notification_count > 99
                                    ? "+99"
                                    : notification_count.toString()
                                : "",
                            style: TextStyle6White,
                          ),
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
              ),

              PharmacyHomeCardWidget(
                title: kTrackOrder,
                image: strIMG_Location,
                backgroundColor: AppColors.greenAccentColor,
              ),

              PharmacyHomeCardWidget(
                title: kScanAndBook,
                image: strIMG_QrCode,
                backgroundColor: AppColors.colorOrange,
              ),

              PharmacyHomeCardWidget(
                title: kNursHomeBoxBook,
                image: strIMG_QrCode,
                backgroundColor: AppColors.blueColorLight,
              ),
            ],
          ),
        )),
      ),
    );
  }
}

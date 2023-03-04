import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/View/OnBoarding/Login/login_screen.dart';

import '../../../Controller/PharmacyControllers/P_RouteListController/P_get_route_list_controller.dart';
import '../P_Drawer/pharmacy_drawer_screen.dart';

class PharmacyHomeScreen extends StatefulWidget {
  const PharmacyHomeScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyHomeScreen> createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends State<PharmacyHomeScreen> {
  String ? userId, token, userName, email, mobile ;
  double ? versionCode;

  dynamic notification_count = 0;
  List indexColors = [AppColors.bluearrowcolor, AppColors.greenAccentColor, AppColors.colorOrange, AppColors.blueColorLight];
  List indexNamed = ["Deliveries", "Track Order", "Scan & Book", "Nursing Home Box Booking"];
  List indexIcons = [
    "assets/images/delivery_icon.png",
    "assets/images/location_icon.png",
    "assets/images/qr_code.png",
    "assets/images/qr_code.png",
  ];


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      drawer: PharmacyDrawerScreen(userName: userName ??'',email: email,versionCode: versionCode,mobile: mobile,),
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Home', style: Regular18Style),
        backgroundColor: Colors.white,
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
                    child: const Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.black,
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
                          backgroundColor: Colors.red,
                          child: Text(
                            notification_count != null
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
          child: Container(
            height: Get.height,
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Get.toNamed(trackOrderScreen);
                   },
                  child: Container(
                    height: Get.height / 6,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    color: indexColors[index],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          indexIcons[index],
                          height: 30,
                          width: 40,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BuildText.buildText(text: indexNamed[index], style: TS.CTS(22.00, AppColors.whiteColor, FontWeight.w600))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../../Controller/PharmacyControllers/p_ProfileController/p_profile_controller.dart';

class PharmacyDrawerScreen extends StatefulWidget {
  String? versionCode;

  PharmacyDrawerScreen({
    super.key,
    required this.versionCode,
  });

  @override
  State<PharmacyDrawerScreen> createState() => _PharmacyDrawerScreenState();
}

class _PharmacyDrawerScreenState extends State<PharmacyDrawerScreen> {

PharmacyProfileController phrProfCtrl = Get.put(PharmacyProfileController());

@override
void initState() {    
    init();
    super.initState();
  }

  Future<void> init() async {
    phrProfCtrl.isNetworkError = false;
    phrProfCtrl.isEmpty = false;
    if (await ConnectionValidator().check()) {
      await phrProfCtrl.pharmacyProfileApi(context: context);
    } else {
      phrProfCtrl.isNetworkError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyProfileController>(
      init: phrProfCtrl,
      builder: (controller) {
        return SafeArea(
      child: Container(
        color: AppColors.whiteColor,
        height: Get.height,
        width: Get.width * 0.8,
        child: Column(
          children: [
            Container(
              height: 130,
              color: AppColors.colorOrange,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child:  Icon(
                            Icons.close,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                    boxShadow: [BoxShadow(color: AppColors.greyColor, blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 0))],
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(50)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Center(
                                        child: BuildText.buildText(
                                      text: controller.driverProfileData?.firstName?[0].toString().toUpperCase() ?? "",
                                      size: 20,
                                      weight: FontWeight.w400,                                      
                                    )))),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BuildText.buildText(
                                      text:controller.driverProfileData?.firstName ?? "",
                                      color: AppColors.whiteColor,
                                      size: 18,
                                      weight: FontWeight.bold,                                        
                                    ),
                                    BuildText.buildText(
                                      text:controller.driverProfileData?.emailId ?? "",
                                      color: AppColors.whiteColor,                                        
                                    ),
                                    BuildText.buildText(
                                      text: controller.driverProfileData?.mobileNumber ?? "",
                                      color: AppColors.whiteColor                                        
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ExpansionTileCard(
                    animateTrailing: true,
                    title:  BuildText.buildText(text: kPersonalInfo),
                    leading: const Icon(
                      Icons.person,
                      size: 20,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ), // height: 200,

                        child: Column(
                          children: [
                            Row(
                              children: [
                                 Icon(
                                  Icons.mobile_friendly_sharp,
                                  color: AppColors.blackColor,
                                  size: 12,
                                ),
                                buildSizeBox(0.0, 10.0),
                                BuildText.buildText(
                                  text: controller.driverProfileData?.mobileNumber ?? "",
                                )
                              ],
                            ),
                            buildSizeBox(5.0, 0.0),
                            Row(
                              children: [
                                 Icon(
                                  Icons.email,
                                  color: AppColors.greyColor,
                                  size: 12,
                                ),
                                buildSizeBox(0.0, 10.0),
                                BuildText.buildText(
                                  text: controller.driverProfileData?.emailId ?? "",
                                )
                              ],
                            ),
                            buildSizeBox(5.0, 0.0),
                            Row(
                              children: [
                                 Icon(
                                  Icons.location_city_outlined,
                                  color: AppColors.greyColor,
                                  size: 12,
                                ),
                                buildSizeBox(0.0, 10.0),
                                BuildText.buildText(
                                  text: controller.driverProfileData?.pharmacyName ?? "",
                                )
                              ],
                            ),
                            buildSizeBox(10.0, 0.0)
                          ],
                        ),
                      ),
                    ],
                    onExpansionChanged: (value) {
                      // if (value) {
                      //   Future.delayed(const Duration(milliseconds: 500),
                      //           () {
                      //         for (var i = 0; i < cardKeyList.length; i++) {
                      //           if (cardKeyList == i) {
                      //             cardKeyList[i].currentState?.collapse();
                      //           }
                      //         }
                      //       });
                      // }
                    },
                  ),
                  DrawerListTiles(text: kChangePin, ontap: () {}),
                  const Divider(),
                  DrawerListTiles(text: kCreatePatient, ontap: () {}),
                  const Divider(),
                  DrawerListTiles(text: kMyNotifiaction, ontap: () {
                    Get.toNamed(pharmacyNotificationScreenRoute);
                  }),
                  const Divider(),
                  DrawerListTiles(text: kPrivacyPolicy, ontap: () {}),
                  const Divider(),
                  DrawerListTiles(text: kTermsOfService, ontap: () {}),
                  const Divider(),
                  // DrawerListTiles(text: 'Logout', ontap:validateAndLogout(context)),
                ],
              ),
            ),
            const Spacer(), 
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BuildText.buildText(
                  text: "VERSION V.${widget.versionCode} ",
                  color: AppColors.blackColor,
                  size: 12,
                  weight: FontWeight.w400,),
                  ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget DrawerListTiles({required String text,required VoidCallback ontap,}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BuildText.buildText(
              text: text,
              size: 17,
              color: AppColors.blackColor,              
            ),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }


}

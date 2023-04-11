import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/AdditionalWidget/Default%20Functions/defaultFunctions.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/View/CreatePatientScreen.dart/createPatientScreen.dart';
import '../../../Controller/Helper/LogoutController/logout_controller.dart';
import '../../../Controller/PharmacyControllers/p_ProfileController/p_profile_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/PharmacyDrawerTile/pharmacyDrawerTile.dart';
import '../../../View/OnBoarding/SetupPin/setupPin.dart';

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
                                      color: AppColors.colorOrange                                    
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
                        ),
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
                  ),
                  PharmacyDrawerTile(text: kChangePin, ontap: () {
                    Get.toNamed(setupPinScreenRoute,arguments: SetupPinScreen(isChangePin: true,));
                  }),
                  const Divider(),
                  PharmacyDrawerTile(text: kCreatePatient, ontap: () {
                    Get.toNamed(driverCreatePatientScreenRoute,arguments: DriverCreatePatientScreen(isScanPrescription: false));
                  }),
                  const Divider(),
                  PharmacyDrawerTile(text: kMyNotifiaction, ontap: () {
                    Get.toNamed(pharmacyNotificationScreenRoute);
                  }),
                  const Divider(),
                  PharmacyDrawerTile(text: kPrivacyPolicy, ontap: () {
                     DefaultFuntions.redirectToBrowser(WebApiConstant.PRIVACY_URL);
                  }),
                  const Divider(),
                  PharmacyDrawerTile(text: kTermsOfService, ontap: () {
                    DefaultFuntions.redirectToBrowser(WebApiConstant.TERMS_URL);
                  }),
                  const Divider(),
                  PharmacyDrawerTile(text: klogout, ontap:()async{
                    await LogoutController().validateAndLogout(context:context,userType: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType) ?? "");
                  }),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BuildText.buildText(
                  text: "VERSION V.${widget.versionCode}",
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
  }}



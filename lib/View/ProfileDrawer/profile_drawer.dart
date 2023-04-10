import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/popup.dart';
import 'package:pharmdel/View/CreatePatientScreen.dart/createPatientScreen.dart';
import 'package:pharmdel/View/HowToOperate.dart/PdfScreen.dart';
import 'package:pharmdel/View/UpdateAddressScreen.dart/updateAddressScreen.dart';
import '../../Controller/Helper/ConnectionValidator/internet_check_return.dart';
import '../../Controller/Helper/LogoutController/logout_controller.dart';
import '../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../OnBoarding/SetupPin/setupPin.dart';


class DrawerDriver extends StatelessWidget {

  DriverProfileController drProfCtrl = Get.put(DriverProfileController());


  @override
  Widget build(BuildContext context) {

    return GetBuilder<DriverProfileController>(
      init: drProfCtrl,
      builder: (controller) {
        return Drawer(
      child: LoadScreen(
        widget: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(children: [

                        /// Driver Name
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                           buildSizeBox(15.0, 0.0),

                            Row(
                              children: [
                                Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.greyColor,
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 0)
                                          )
                                        ],
                                        color: Colors.orangeAccent,
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Center(
                                      child: BuildText.buildText(
                                          text: controller.driverProfileData?.data?.firstName != null && controller.driverProfileData!.data!.firstName!.isNotEmpty ?
                                          controller.driverProfileData!.data!.firstName![0].toString().toUpperCase()
                                              : "",
                                        color: AppColors.whiteColor,
                                        size: 30
                                      ),
                                    )),
                              buildSizeBox(0.0, 20.0),
                                Expanded(
                                  child: BuildText.buildText(
                                    text:  controller.driverProfileData?.data?.firstName ?? "",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black)
                                  ),
                                ),
                              buildSizeBox(10.0, 0.0),
                              ],
                            ),
                          ],
                        ),

                        /// Lunch Mode

                          Visibility(
                            visible: driverType.toLowerCase() == kDedicatedDriver.toLowerCase() || driverType.toLowerCase() == kSharedDriver.toLowerCase(),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(kLunchMode),
                                      SizedBox(
                                        height: 20,
                                        child: Image.asset(strImgNewGif),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      BuildText.buildText(
                                        text: kOff,
                                        size: 16,
                                        color: AppColors.blackColor,
                                        weight: FontWeight.w600,
                                      ),
                                      Tooltip(
                                        message: kStartLunch,
                                        enableFeedback: true,
                                        waitDuration: const Duration(microseconds: 100),
                                        child: SizedBox(
                                          width: 90,
                                          height: 70,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Switch(
                                              onChanged: (bool value)=>controller.onTapBreak(value: value),
                                              value: controller.onBreak,
                                              activeColor: AppColors.colorOrange,
                                              activeTrackColor: AppColors.colorOrange,
                                              inactiveThumbColor: AppColors.greyColor,
                                              inactiveTrackColor: AppColors.greyColor
                                            ),
                                          ),
                                        ),
                                      ),
                                      BuildText.buildText(
                                        text:  kON,
                                        size: 16,
                                        color: AppColors.blackColor,
                                        weight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          buildSizeBox(10.0, 0.0),

                        /// Personal Info
                        ExpansionTileCard(
                          animateTrailing: true,
                          title: BuildText.buildText(text: kPersonalInfo,color:AppColors.colorAccent,textAlign: TextAlign.start),
                          leading: Icon(
                            Icons.person,
                            size: 20,color: AppColors.colorAccent,
                          ),
                          children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, ),
                              child: Column(
                                children: [
                                  WidgetCustom.drawerPersonalInfoWidget(
                                    title: controller.driverProfileData?.data?.mobileNumber,
                                    icon: Icons.mobile_friendly_sharp,
                                  ),
                                  WidgetCustom.drawerPersonalInfoWidget(
                                    title: controller.driverProfileData?.data?.emailId,
                                    icon: Icons.email,
                                  ),

                                  WidgetCustom.drawerPersonalInfoWidget(
                                    title: controller.driverProfileData?.data?.addressLine1,
                                    icon: Icons.location_city_outlined,
                                  ),

                                  buildSizeBox(10.0, 0.0),
                                ],
                              ),
                            ),
                          ],
                          onExpansionChanged: (value) {

                          },
                        ),
                        buildSizeBox(5.0, 0.0),

                        /// Change Pin
                        WidgetCustom.drawerBtn(
                            onTap: (){
                              Get.back();
                              Get.toNamed(setupPinScreenRoute,arguments: SetupPinScreen(isChangePin: true,));
                            },
                            title: kChangePin,
                            icon: Icons.lock
                        ),


                        /// create patient widget
                        if (driverType.toLowerCase() != kSharedDriver.toLowerCase())
                          WidgetCustom.drawerBtn(
                              onTap: (){
                                Get.back();
                                Get.toNamed(driverCreatePatientScreenRoute,arguments: DriverCreatePatientScreen(isScanPrescription: false));
                              },
                              title: kCreatePatient,
                              icon: Icons.local_hospital
                          ),

                        /// How to operate
                        WidgetCustom.drawerBtn(
                            onTap: (){
                              Get.back();
                              Get.toNamed(pdfViewScreenRoute,
                                  arguments: PdfViewScreen(
                                    pdfUrl: controller.driverProfileData?.userManual ?? "",
                                  ));
                            },
                            title: kHowToOperate,
                            icon: Icons.question_mark
                        ),

                        /// Enter Miles
                        Visibility(
                          visible: controller.showWages.toLowerCase() == "1",
                          child: WidgetCustom.drawerBtn(
                            onTap: ()=> controller.onTapEnterMiles(),
                              title: kEnterMiles,
                              icon: Icons.edit
                          ),
                        ),

                        /// Update Address
                        WidgetCustom.drawerBtn(
                            onTap: (){
                              Get.back();
                              Get.toNamed(updateAddressScreenRoute,
                                arguments: UpdateAddressScreen(
                                    address1: controller.driverProfileData?.data?.addressLine1 ?? "",
                                    address2: controller.driverProfileData?.data?.addressLine2 ?? "",
                                    postCode: controller.driverProfileData?.data?.postCode ?? "",
                                    townName: controller.driverProfileData?.data?.townName ?? ""
                                ),);                          },
                            title: kUpdateAddress,
                            icon: Icons.home
                        ),

                        /// Logout
                        WidgetCustom.drawerBtn(
                            onTap: () async {

                              if(await InternetCheck.checkStatus() == false){

                                PrintLog.printLog("No Internet........");
                                PopupCustom.showNoInternetPopUpWhenOffline(
                                    context: Get.overlayContext!,
                                    onValue: (value){

                                    }
                                );
                              }else{
                                await LogoutController().validateAndLogout(context:context,userType: AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType) ?? "");
                              }

                            },
                            title: klogout,
                            icon: Icons.logout
                        ),

                        const Spacer(),
                        BuildText.buildText(
                          text: kAppVersion + controller.versionCode ?? ""),
                        buildSizeBox(20.0, 0.0),
                      ]),
                    ),
                  ),
                ],
              ),
            )),
        isLoading: controller.isLoading,
      ),
    );
      },
    );
  }


 }

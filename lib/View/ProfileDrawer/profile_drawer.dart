import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/View/HowToOperate.dart/PdfScreen.dart';
import 'package:pharmdel/View/UpdateAddressScreen.dart/updateAddressScreen.dart';
import '../../Controller/Helper/LogoutController/logout_controller.dart';
import '../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../OnBoarding/SetupPin/setupPin.dart';


class DrawerDriver extends StatefulWidget {

   const DrawerDriver({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DrawerDriverState();
}

class DrawerDriverState extends State<DrawerDriver> {

  DriverProfileController drProfCtrl = Get.put(DriverProfileController());


   @override
  void initState() {
     init();
    super.initState();
  }

  Future<void> init()async{
    if(drProfCtrl.isLoadApi == false || drProfCtrl.driverProfileData?.userManual == null){
      await drProfCtrl.driverProfileApi(context: context);
    }
  }


  @override
  Widget build(BuildContext context) {

    return GetBuilder<DriverProfileController>(
      init: drProfCtrl,
      builder: (controller) {
        return Drawer(
      child: Scaffold(
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

                      // if (userType == 'Driver')
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          // color: Colors.amber.withOpacity(0.1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(kLunchMode),
                                  SizedBox(
                                    height: 20,
                                    // width: 40,
                                    child: Image.asset(
                                      strIMG_NewGIF,
                                    ),
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
                                          onChanged: (bool value) {                                            
                                            controller.onTapBreak(value: value);
                                            Future.delayed(
                                              const Duration(seconds: 1),
                                              () => Get.toNamed(lunchBreakScreenRoute),
                                            );
                                          },
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
                        buildSizeBox(10.0, 0.0),

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
                            Get.toNamed(setupPinScreenRoute,arguments: SetupPinScreen(isChangePin: true,));
                          },
                          title: kChangePin,
                          icon: Icons.lock
                      ),


                      /// create patient widget
                      if (controller.driverType.toString().toLowerCase() != "shared")
                        WidgetCustom.drawerBtn(
                            onTap: (){
                              Get.toNamed(createPatientScreenRoute);
                            },
                            title: kCreatePatient,
                            icon: Icons.local_hospital
                        ),

                      /// How to operate
                      WidgetCustom.drawerBtn(
                          onTap: (){
                            Get.toNamed(pdfViewScreenRoute,
                                arguments: PdfViewScreen(
                                  pdfUrl: controller.driverProfileData?.userManual ?? "",
                                ));
                          },
                          title: kHowToOperate,
                          icon: Icons.question_mark
                      ),

                      /// Enter Miles
                      WidgetCustom.drawerBtn(
                          onTap: (){
                            return controller.showStartMilesDialog(context);
                          },
                          title: kEnterMiles,
                          icon: Icons.edit
                      ),

                      /// Update Address
                      WidgetCustom.drawerBtn(
                          onTap: (){
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
                            await LogoutController().validateAndLogout(context);
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
    );
      },
    );
  }


 }

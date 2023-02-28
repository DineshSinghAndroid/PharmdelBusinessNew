import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/ProjectController/DriverProfile/driverProfileController.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/View/HowToOperate.dart/PdfScreen.dart';
import '../../../Model/Enum/enum.dart';
import '../../../main.dart';
import '../../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../Helper/LogoutController/logout_controller.dart';
import '../../Helper/Shared Preferences/SharedPreferences.dart';
import '../../RouteController/RouteNames.dart';
import '../AdditionalWidget/ExpansionTileCard/expansionTileCardWidget.dart';
import '../Popup/CustomDialogBox.dart';
import '../Popup/PopupCustom.dart';
import '../StringDefine/StringDefine.dart';


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

  Future<void> init() async {
    drProfCtrl.isNetworkError = false;
    drProfCtrl.isEmpty = false;
    if (await ConnectionValidator().check()) {
      await drProfCtrl.driverProfileApi(context: context);
    } else {
      drProfCtrl.isNetworkError = true;
      setState(() {});
    }
  }

  Future<File>? imageFile;
  double opacity = 0.0;
  bool status = false;
  var yetToStartColor = const Color(0xFFF8A340);

  // final lunchStoppingTime = CurrentRemainingTimeIS;

  bool isLoading = true;
  bool showPopUp = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String? username,
      password,
      token,
      userType,
      endMile,
      startMile,
      vehicleId = "";
  String? driverType = "";
  String? routeId, routeS;

  // ProgressDialog progressDialog;
  bool smsPermission = false;
  Timer? timer1;

  bool isDialogShowing = false;

  Map<String, Object>? profiledata;
  String? userId;
  String versionCode = "";

  String? fName,
      middleName,
      howToOperateUrl,
      lastName,
      contactNumber,
      nhsNumber,
      email,
      address1,
      address2,
      route,
      postCode,
      townName;
  String name = "";
  String virPop = "";
  int value = 0;

  // bool positive = false;
  bool loading = false;
  String? fullAddress;
  double lat = 0.0;
  double lng = 0.0;
  bool isTap = false;
  bool onBreak = false;
  bool showIncreaseTime = false;


  @override
  Widget build(BuildContext context) {
    // logger.w('#DRIVER TYPE : $driverType');
    // logger.w('#DRIVER TYPE : $virPop');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return GetBuilder<DriverProfileController>(
      init: drProfCtrl,
      builder: (controller) {
        return Drawer(
      child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
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
                          const SizedBox(
                            height: 15,
                          ),
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
                                            offset: const Offset(0, 0))
                                      ],
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: BuildText.buildText(
                                       text: username != null
                                          ? username![0].toUpperCase()
                                          : '',
                                      color: AppColors.whiteColor,
                                      size: 30
                                    ),
                                  )),
                            buildSizeBox(0.0, 20.0),
                              BuildText.buildText(
                                text:  controller.driverProfileData?.data?.firstName ?? "",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
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
                                            setState(() {
                                              onBreak = value;
                                            });
                                            Future.delayed(
                                              const Duration(seconds: 1),
                                              () => Get.toNamed(lunchBreakScreenRoute),
                                            );
                                          },
                                          value: onBreak,
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
                        title: BuildText.buildText(text: kPersonalInfo,color: Colors.blue,textAlign: TextAlign.start),
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
                                    const Icon(
                                      Icons.mobile_friendly_sharp,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                   buildSizeBox(0.0, 10.0),
                                    BuildText.buildText(text: kContactNumber,color: AppColors.blackColor)
                                  ],
                                ),
                                buildSizeBox(5.0, 0.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                      size: 12,
                                    ),
                                   buildSizeBox(0.0, 10.0),
                                    BuildText.buildText(text: controller.driverProfileData?.data?.emailId.toString() ?? "")
                                  ],
                                ),
                             buildSizeBox(5.0, 0.0),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_city_outlined,
                                      color: Colors.grey,
                                      size: 12,
                                    ),
                                 buildSizeBox(0.0, 10.0),
                                    BuildText.buildText(text: kaddress)
                                  ],
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
                      ListTile(
                        onTap: () {Get.toNamed(setupPinScreenRoute,arguments: 'true');},
                        leading: const Icon(Icons.lock, size: 20),
                        title: BuildText.buildText(text: kChangePin)
                      ),

                      /// create patient widget
                      if (driverType != "Shared")
                        ListTile(
                          onTap: () {
                            Get.toNamed(createPatientScreenRoute);
                          },
                          leading: const Icon(Icons.local_hospital,size: 20),
                          title:BuildText.buildText(text: kCreatePatient)
                        ),

                        ListTile(
                          onTap: () {
                            Get.toNamed(pdfViewScreenRoute,
                            arguments: PdfViewScreen(
                              pdfUrl: controller.driverProfileData?.userManual ?? "",
                            ));
                          },
                          leading: const Icon(Icons.question_mark,size: 20),
                          title:BuildText.buildText(text: kHowToOperate)
                        ),

                        ListTile(
                          onTap: (){
                            return controller.showStartMilesDialog(context);
                          },
                          leading: const Icon(Icons.edit,size: 20),
                          title:BuildText.buildText(text: kEnterMiles)
                        ),

                        ListTile(
                          onTap: () {
                            Get.toNamed(updateAddressScreenRoute);
                          },
                          leading: const Icon(Icons.home,size: 20),
                          title:BuildText.buildText(text: kUpdateAddress)
                        ),
                 
                      ListTile(
                          onTap: (){
                            return validateAndLogout(context);
                          },
                          leading: const Icon(Icons.logout,size: 20),
                          title:BuildText.buildText(text: klogout)
                        ),
                  
                      const Spacer(),
                      Text(kAppVersion + versionCode ?? ""),
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

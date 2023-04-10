import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ApiController/important_keys.dart';
import '../../Controller/ProjectController/CreatePatiientController/create_patient_controller.dart';
import '../../Controller/WidgetController/AppBar/app_bar.dart';
import '../../Controller/WidgetController/Button/ButtonCustom.dart';
import '../../Controller/WidgetController/TextField/CustomTextField.dart';



class DriverCreatePatientScreen extends StatefulWidget {
  bool isScanPrescription;
  DriverCreatePatientScreen({super.key,required this.isScanPrescription});

  @override
  State<DriverCreatePatientScreen> createState() => _DriverCreatePatientScreenState();
}

class _DriverCreatePatientScreenState extends State<DriverCreatePatientScreen> {

  final CreatePatientController ctrl = Get.put(CreatePatientController());

  @override
  void initState() {
    ctrl.googlePlace = FlutterGooglePlacesSdk(ImportantKey.kGooglePlacesSdkKey);
    ctrl.pharmacyID = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.pharmacyID);

    super.initState();
  }
  @override
  void dispose() {
    Get.delete<CreatePatientController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CreatePatientController>(
      init: ctrl,
      builder: (controller) {
        return LoadScreen(
          widget: Scaffold(
            appBar: AppBarCustom.appBarStyle2(title: kCreatePatient,centerTitle: false,size: 22,elevation: 1),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [

                    /// Select Title or Gender
                    SizedBox(
                      height: 50,width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          /// Title
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  '$kSelectTitle*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),isExpanded: true,
                                items: controller.selectTitle
                                    .map((item) => DropdownMenuItem<SurNameTitle>(
                                  value: item,
                                  child: Text(
                                    item.showTitle,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                )).toList(),
                                value: controller.selectedTitleValue,
                                onChanged: (value) {
                                  setState(() {
                                    controller.selectedTitleValue = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: AppColors.greyColor)
                                    )
                                ),
                                menuItemStyleData: const MenuItemStyleData(),
                              ),
                            ),
                          ),
                          buildSizeBox(0.0, controller.spaceBetween),

                          /// Gender
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  '$kSelectGender*',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),isExpanded: true,
                                items: controller.selectGender
                                    .map((item) => DropdownMenuItem<SurNameTitle>(
                                  value: item,
                                  child: Text(
                                    item.showTitle,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                    .toList(),
                                value: controller.selectedGenderValue,
                                onChanged: (value) {
                                  setState(() {
                                    controller.selectedGenderValue = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: AppColors.greyColor)
                                    )
                                ),
                                menuItemStyleData: const MenuItemStyleData(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    buildSizeBox(15.0, 00.00),

                    /// First Name* or Middle Name
                    SizedBox(
                      // height: 50,width: Get.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// First Name*
                          Expanded(
                            child: TextFieldCustomForMPin(
                              controller: controller.nameCtrl,
                              keyboardType: TextInputType.name,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: "$kFirstName*",
                              errorText: controller.isFirstName
                                  ? kFirstName: null,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
                              ],

                              onChanged:(value){
                                if(value == " "){
                                  controller.nameCtrl.clear();
                                }
                              },
                            ),
                          ),

                          buildSizeBox(0.0, controller.spaceBetween),

                          /// Middle Name
                          Expanded(
                            child: TextFieldCustomForMPin(
                              controller: controller.middleNameCtrl,
                              keyboardType: TextInputType.name,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: kMiddleName,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
                              ],

                              onChanged:(value){
                                if(value == " "){
                                  controller.middleNameCtrl.clear();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    buildSizeBox(15.0, 00.00),

                    /// Last Name* or Mobile Number
                    SizedBox(
                      // height: 50,width: Get.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Last Name*
                          Expanded(
                            child: TextFieldCustomForMPin(
                              controller: controller.lastNameCtrl,
                              keyboardType: TextInputType.name,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: "$kLastName*",
                              errorText: controller.isLastName
                                  ? kLastName: null,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
                              ],

                              onChanged:(value){
                                if(value == " "){
                                  controller.lastNameCtrl.clear();
                                }
                              },
                            ),
                          ),

                          buildSizeBox(0.0, controller.spaceBetween),

                          /// Mobile number
                          Expanded(
                            child: TextFieldCustomForMPin(
                              controller: controller.mobileCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: kMobileNumberOptional,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],

                              onChanged:(value){
                                if(value == " "){
                                  controller.mobileCtrl.clear();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    buildSizeBox(15.0, 00.00),
                    /// Email or NHS Number
                    SizedBox(
                      // height: 50,width: Get.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Email
                          Expanded(
                            child: TextFieldCustomForMPin(
                              controller: controller.emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: kEmailOptional,
                              onChanged:(value){
                                if(value == " "){
                                  controller.emailCtrl.clear();
                                }
                              },
                            ),
                          ),

                          buildSizeBox(0.0, controller.spaceBetween),

                          /// NHS number
                          Expanded(
                            child: TextFieldCustomForMPin(
                              controller: controller.nhsNoCtrl,
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: kNHSNumber,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],

                              onChanged:(value){
                                if(value == " "){
                                  controller.nhsNoCtrl.clear();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Start Typing*
                    Visibility(
                      visible: controller.isHideStartTypingCTRL == false,
                      child: Stack(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(top: 15.0),
                            // height: 50,width: Get.width,
                            child: TextFieldCustomForMPin(
                              controller: controller.startTypingCtrl,
                              keyboardType: TextInputType.name,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: "$kStartTypingAddress*",
                              errorText: controller.isStartTyping
                                  ? kEnterYourAddress: null,
                              onChanged:(value)=> controller.onChangedStartTyping(value: value),
                            ),
                          ),

                          /// Suggestion list
                          Visibility(
                            visible:controller.startTypingCtrl.text.toString().trim().isNotEmpty,
                            child: Container(
                              margin: const EdgeInsets.only(top: 50),
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(0.2),
                                  boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12.withOpacity(0.2),
                                          spreadRadius: 3.0, blurRadius: 5.0,
                                          offset: const Offset(0, 5)
                                      )
                                  ]
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: controller.prediction.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: ()=> controller.onTapSuggestionListItem(index: index),
                                    title: BuildText.buildText(text: "${controller.prediction[index].primaryText ?? ""} ${controller.prediction[index].secondaryText ?? ""}")
                                    // Text(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Address section
                    Visibility(
                      visible: controller.isHideStartTypingCTRL,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          buildSizeBox(15.0, 00.00),
                          /// Address Line 1
                          SizedBox(
                            height: 50,width: Get.width,
                            child: TextFieldCustomForMPin(
                              controller: controller.addressLine1Ctrl,
                              keyboardType: TextInputType.name,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: kAddress1Line,
                              errorText: controller.isAddressLine1
                                  ? kAddress1Line: null,
                              onChanged:(value){
                                if(value == " "){
                                  controller.addressLine1Ctrl.clear();
                                }
                              },
                            ),
                          ),

                          buildSizeBox(15.0, 00.00),
                          /// Address Line 2
                          SizedBox(
                            height: 50,width: Get.width,
                            child: TextFieldCustomForMPin(
                              controller: controller.addressLine2Ctrl,
                              keyboardType: TextInputType.name,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: kAddress2Line,
                              errorText: controller.isAddressLine2
                                  ? kAddress2Line: null,
                              onChanged:(value){
                                if(value == " "){
                                  controller.addressLine2Ctrl.clear();
                                }
                              },
                            ),
                          ),

                          buildSizeBox(15.0, 00.00),
                          /// Town Name*
                          SizedBox(
                            height: 50,width: Get.width,
                            child: TextFieldCustomForMPin(
                              controller: controller.townCtrl,
                              keyboardType: TextInputType.name,
                              maxLength: 100,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: "$kTownName*",
                              errorText: controller.isTownName
                                  ? kTownName: null,
                              onChanged:(value){
                                if(value == " "){
                                  controller.townCtrl.clear();
                                }
                              },
                            ),
                          ),

                          buildSizeBox(15.0, 00.00),
                          /// Post Code*
                          SizedBox(
                            height: 50,width: Get.width,
                            child: TextFieldCustomForMPin(
                              controller: controller.postCodeCtrl,
                              keyboardType: TextInputType.name,
                              maxLength: 10,
                              radiusField: 30.0,
                              isCheckOut: true,
                              isHideCounterText: true,
                              hintText: "$kPostCode*",
                              errorText: controller.isPostCode
                                  ? kPostCode: null,
                              onChanged:(value){
                                if(value == " "){
                                  controller.postCodeCtrl.clear();
                                }
                              },
                            ),
                          ),

                        ],
                      ),
                    ),

                    buildSizeBox(50.0, 00.00),
                    /// Save And Create Btn
                    ButtonCustom(
                      onPress: () => controller.onTapSaveAndCreate(context: context,isScanPrescription: widget.isScanPrescription),
                      text: kSaveAndCreate,
                      buttonWidth: Get.width,
                      buttonHeight: 50,
                      backgroundColor: AppColors.colorAccent,
                    ),

                  ],
                ),
              ),
            ),
          ),
          isLoading: controller.isLoading,
        );
      },
    );
  }
}


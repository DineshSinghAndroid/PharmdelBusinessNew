import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/UpdateProfileController/updateProfileController.dart';

class UpdateAddressScreen extends StatefulWidget {
  String? address1, address2, townName, postCode,driverName,userType;
   UpdateAddressScreen({super.key, required this.userType,required this.driverName,required this.address1, required this.address2, required this.postCode, required this.townName});

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {

  UpdateProfileController updPrfCtrl = Get.put(UpdateProfileController());


@override 
void initState() {  
    super.initState();
    init();
  }


  Future<void> init()async{
    updPrfCtrl.initData(address1: widget.address1 ?? "",address2: widget.address2 ?? "",postCode: widget.postCode ?? "",townName: widget.townName ?? "",name: widget.driverName ?? "");
  }


  @override
  void dispose() {
  Get.delete<UpdateProfileController>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: updPrfCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
          child: LoadScreen(
            widget: Scaffold(
                appBar: AppBarCustom.appBarStyle2(
                  title: kUpdateAddress,
                  centerTitle: true,
                  size: 18
                ),

                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 0))
                                    ],
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: BuildText.buildText(
                                    text: controller.userName.toUpperCase(),
                                    style: TextStyle(
                                        color: AppColors.whiteColor, fontSize: 27.0),
                                  ),
                                )),
                          ],
                        ),
                        buildSizeBox(5.0, 0.0),
                        BuildText.buildText(
                          text: widget.driverName?.toUpperCase() ?? "",
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        buildSizeBox(controller.textFieldSpace, 0.0),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          elevation: 3.0,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: BuildText.buildText(text: kUpdateAddress,color: AppColors.whiteColor,size: 18),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    /// Address 1
                                    TextFieldCustomForMPin(
                                      controller: controller.addressController,
                                      keyboardType: TextInputType.name,
                                      maxLength: 100,
                                      radiusField: 5.0,
                                      isCheckOut: true,
                                      isHideCounterText: true,
                                      hintText: kAddressLine1,
                                      errorText: controller.isAddress1
                                          ? kAddressLine1: null,
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
                                      // ],

                                      onChanged:(value){
                                        if(value == " "){
                                          controller.addressController.clear();
                                        }
                                      },
                                    ),
                                    buildSizeBox(controller.textFieldSpace, 0.0),
                                    const Divider(height: 0,thickness: 0,endIndent: 10,indent: 10),

                                    /// Address 2
                                    TextFieldCustomForMPin(
                                      controller: controller.addressController2,
                                      keyboardType: TextInputType.name,
                                      maxLength: 100,
                                      radiusField: 5.0,
                                      isCheckOut: true,
                                      isHideCounterText: true,
                                      hintText: kAddressLine2,
                                      errorText: controller.isAddress2
                                          ? kAddressLine2: null,
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
                                      // ],

                                      onChanged:(value){
                                        if(value == " "){
                                          controller.addressController2.clear();
                                        }
                                      },
                                    ),
                                    buildSizeBox(controller.textFieldSpace, 0.0),
                                    const Divider(height: 0,thickness: 0,endIndent: 10,indent: 10),

                                    /// Town
                                    TextFieldCustomForMPin(
                                      controller: controller.townController,
                                      keyboardType: TextInputType.name,
                                      maxLength: 100,
                                      radiusField: 5.0,
                                      isCheckOut: true,
                                      isHideCounterText: true,
                                      hintText: kTownName,
                                      errorText: controller.isTown
                                          ? kTownName: null,
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
                                      // ],

                                      onChanged:(value){
                                        if(value == " "){
                                          controller.townController.clear();
                                        }
                                      },
                                    ),
                                    buildSizeBox(controller.textFieldSpace, 0.0),
                                    const Divider(height: 0,thickness: 0,endIndent: 10,indent: 10),


                                    /// Postcode
                                    TextFieldCustomForMPin(
                                      controller: controller.postCodeController,
                                      keyboardType: TextInputType.name,
                                      maxLength: 14,
                                      radiusField: 5.0,
                                      isCheckOut: true,
                                      isHideCounterText: true,
                                      hintText: kPostalCode,
                                      errorText: controller.isPostCode
                                          ? kPostalCode: null,
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z -]'))
                                      // ],

                                      onChanged:(value){
                                        if(value == " "){
                                          controller.postCodeController.clear();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),



                            ],
                          ),
                        ),
                        buildSizeBox(controller.textFieldSpace, 0.0),
                        ButtonCustom(
                          onPress: ()=> controller.onTapUpdateAddress(context: context),
                          text: kUpdateAddress,
                          buttonWidth: Get.width,
                          buttonHeight: 50,
                          backgroundColor: AppColors.blueColor,
                          borderRadius: BorderRadius.circular(10),
                          )
                      ],
                    ),
                  ),
                ),
            ),
            isLoading: controller.isLoading,
          ),
        ),
        );
      },
    );
  }

}

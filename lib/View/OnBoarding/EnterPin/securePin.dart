
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/Helper/TextController/FontFamily/FontFamily.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import 'package:pharmdel/Controller/WidgetController/Popup/popup.dart';
import '../../../Controller/Helper/Colors/custom_color.dart';
import '../../../Controller/Helper/Permission/PermissionHandler.dart';
import '../../../Controller/Helper/TextController/FontStyle/FontStyle.dart';
import '../../../Controller/ProjectController/SecurePinController/secure_pin_controller/secure_pin_controller.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/WidgetController/TextField/CustomTextField.dart';
import '../../../main.dart';

class SecurePin extends StatefulWidget {
  const SecurePin({Key? key,}) : super(key: key);

  @override
  SecurePinState createState() => SecurePinState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SecurePinState extends State<SecurePin> {


  final SecurePinController _controller = Get.put(SecurePinController());

  @override
  void initState() {
    super.initState();
    _controller.clearCTRL();
    _controller.pin1focusNode.requestFocus();
    _controller.checkLocation(context:context);
  }



  @override
  void dispose() {
    Get.delete<SecurePinController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecurePinController>(
      init: _controller,
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  buildSizeBox(getHeightRatio(value: 10), 0.0),

                  /// Logo
                  Image.asset(strimg_logo, height: getHeightRatio(value: 15)),
                  buildSizeBox(getHeightRatio(value: 1), 0.0),

                  /// User Name
                  BuildText.buildText(text: controller.userName ?? "", size: 18, fontFamily: FontFamily.NexaHeavy),
                  buildSizeBox(getHeightRatio(value: 5), 0.0),

                  /// Enter Secure Pin
                  BuildText.buildText(text: kEnterSecurePin, size: 16, fontFamily: FontFamily.NexaBold),
                  buildSizeBox(getHeightRatio(value: 3), 0.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SecurePinTextField.pinBox(

                          screenWidth: Get.width,
                          controllers: controller.controller1,
                          focus: controller.pin1focusNode,
                          onChanged: (value) {
                            controller.nextField(value, controller.pin2focusNode);
                          }),
                      SecurePinTextField.pinBox(
                          screenWidth: Get.width,
                          controllers: controller.controller2,
                          focus: controller.pin2focusNode,
                          onChanged: (value) {
                            controller.nextField(value, controller.pin3focusNode, controller.pin1focusNode);
                          }),
                      SecurePinTextField.pinBox(
                          screenWidth: Get.width,
                          controllers: controller.controller3,
                          focus: controller.pin3focusNode,
                          onChanged: (value) {
                            controller.nextField(value, controller.pin4focusNode, controller.pin2focusNode);
                          }),
                      SecurePinTextField.pinBox(
                          screenWidth: Get.width,
                          controllers: controller.controller4,
                          focus: controller.pin4focusNode,
                          onChanged: (value) {
                            controller.nextField(value, controller.pin4focusNode, controller.pin3focusNode);
                          }),
                    ],
                  ),
                  buildSizeBox(getHeightRatio(value: 4), 0.0),

                  GridView.builder(
                    itemCount: controller.numbers.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2 / 1,
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 15
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius:  BorderRadius.circular(5),
                            border: Border.all(color: AppColors.deepOrangeColor,width:2)
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            controller.assignValueInField(value: (index + 1).toString());
                          },
                          child: BuildText.buildText(text: controller.numbers[index].toString(),fontFamily: FontFamily.nexabold,size: 18)
                        ),
                      );
                    },
                  ),
                  buildSizeBox(15.0, 0.0),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                           width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(5),
                              border: Border.all(color: AppColors.deepOrangeColor,width:2)
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              controller.assignValueInField(value: '0');
                            },
                            child:BuildText.buildText(text: "0",fontFamily: FontFamily.nexabold,size: 18)
                          ),
                        ),
                      ),
                      buildSizeBox(0.0, 20.0),
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(5),
                              border: Border.all(color: AppColors.deepOrangeColor,width:2)
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              controller.clearPin();
                            },
                              child:BuildText.buildText(text: "Del",fontFamily: FontFamily.nexabold,size: 18)
                          ),
                        ),
                      )
                    ],
                  ),

                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only( top:10,),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () async {
                            if (isTimeCheckDialogBox) {
                              isTimeCheckDialogBox = false;
                              Navigator.pop(context, true);
                            }
                            await AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.forgotMPin, variableValue: "forgot");
                            Get.offAllNamed(loginScreenRoute);
                          },
                          child:BuildText.buildText(
                            text: kForgotMPIN,
                            fontFamily: FontFamily.NexaRegular,
                            size: 16,
                            color: AppColors.colorAccent,
                          ),
                        )
                    ),
                  ),
                  buildSizeBox(15.0, 0.0),

                  InkWell(
                    onTap: ()=> controller.onTapUseDifferentAccount(context: context),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: Get.height*0.02,
                      ),
                      child: BuildText.buildText(
                        text: kUseDifferentAccount,
                        fontFamily: FontFamily.NexaRegular,
                        size: 16,
                        color: AppColors.colorAccent,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

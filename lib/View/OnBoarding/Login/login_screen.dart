import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/Helper/TextController/FontStyle/FontStyle.dart';
import 'package:pharmdel/Controller/WidgetController/Button/ButtonCustom.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/TextField/CustomTextField.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/ProjectController/LoginController/login_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Default Functions/defaultFunctions.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  LoginController loginCtrl = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: loginCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LoadScreen(
            widget: Scaffold(
              bottomNavigationBar:
              /// Terms or Privacy policy
              Padding(
                padding: const EdgeInsets.only(bottom: 30,left: 15,right: 15),
                child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        text: kByContOur,
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: kTermsOfService,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  DefaultFuntions.redirectToBrowser(WebApiConstant.TERMS_URL);
                                }),
                          TextSpan(text: ' and ', style: const TextStyle(fontSize: 15, color: Colors.black), children: <TextSpan>[
                            TextSpan(
                                text: kPrivacyPolicy,
                                style: const TextStyle(fontSize: 17, color: Colors.black, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    DefaultFuntions.redirectToBrowser(WebApiConstant.PRIVACY_URL);
                                  }
                            )
                          ])
                        ])),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        buildSizeBox(Get.height / 15, 0.0),
                        Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: FittedBox(
                              child: Image.asset(strimg_logo),
                            ),
                          ),
                        ),

                        buildSizeBox(Get.height / 20, 0.0),
                        BuildText.buildText(text: kLogin,size: 32,weight: FontWeight.w600,),
                        buildSizeBox(Get.height / 16, 0.0),

                        /// Email
                        TextFieldCustom(
                          controller: controller.emailCT,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 50,
                          isCheckOut: false,
                          hintText: kEmail,
                          errorText: controller.isEmail
                              ? kEnterEmail
                              : null,
                          onChanged:(value){
                            if(value == " "){
                              controller.emailCT.clear();
                            }
                          },
                        ),
                        buildSizeBox(Get.height / 50, 0.0),

                        /// Password
                        TextFieldCustom(
                          controller: controller.passCT,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 50,
                          isCheckOut: false,
                          // obscureText: controller.eyeHide,
                          obscureText: true,
                          hintText: kPassword,
                          // suffixIcon: InkWell(
                          //     onTap: controller.onTapEye,
                          //     child: Icon(controller.eyeHide == false ? Icons.remove_red_eye_outlined:Icons.visibility_off_outlined,color: AppColors.greyColor,)
                          // ),
                          errorText: controller.isPassword
                              ? kEnterPassword
                              : null,
                          onChanged:(value){
                            if(value == " "){
                              controller.passCT.clear();
                            }
                          },
                        ),

                        buildSizeBox(Get.height / 70, 0.0),
                        Row(
                          children: [
                            Checkbox(
                              visualDensity: const VisualDensity(vertical: -4.0),
                              activeColor: AppColors.colorAccent,
                              value: controller.savePassword,
                              onChanged: (bool? value) {
                                controller.onChangedCheckBoxValue(value: value ?? false);
                              },
                            ),
                            BuildText.buildText(text: kRememberMe,)
                          ],
                        ),

                        buildSizeBox(20.0, 0.0),
                        ButtonCustom(
                          onPress: () => controller.onTapLogin(context: context),
                          // onPress: () => controller.autoFillUser(),
                          text: kContinue,
                          buttonWidth: Get.width,
                          buttonHeight: 50,
                          backgroundColor: AppColors.colorAccent,
                        ),

                        buildSizeBox(15.0, 0.0),
                        TextButton(
                            onPressed:() => controller.showForgotPassword(context: context,ctrl: controller),
                            child: BuildText.buildText(text: kForgotPassword, size: 16, weight: FontWeight.bold)
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLoading: controller.isLoading,
          ),
        );
      },
    );
  }


}

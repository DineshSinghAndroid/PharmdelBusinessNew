import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../../ProjectController/LoginController/login_controller.dart';
import '../Button/button.dart';
import '../Loader/LoadScreen/LoadScreen.dart';
import '../StringDefine/StringDefine.dart';
import '../TextField/CustomTextField.dart';

class PopupCustom{
  PopupCustom._privateConstructor();
  static final PopupCustom instance = PopupCustom._privateConstructor();


  static forgotPasswordPopUP({ required Function(dynamic) onValue,required BuildContext context,required LoginController ctrl}){
    return showDialog(
      context: context,
      builder: (_) {
        return ForgotPassword(ctrl: ctrl);
      },).then(onValue);
  }

  static emailSentPopUP({ required Function(dynamic) onValue,required BuildContext context,required String msg}){
    return showDialog(
      context: context,
      builder: (_) {
        return EmailSent(msg: msg);
      },).then(onValue);
  }


}


class ForgotPassword extends StatelessWidget {
  LoginController ctrl;
  ForgotPassword({Key? key,required this.ctrl,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: ctrl,
        builder: (controller) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LoadScreen(
              widget: Scaffold(
                backgroundColor: AppColors.blackColor.withOpacity(0.3),
                body: DelayedDisplay(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 30),
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            /// title
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,bottom: 40),
                                  child: BuildText.buildText(
                                      text: kForgotPassword,
                                      size: 22,
                                      textAlign: TextAlign.center
                                  ),
                                ),


                                /// Enter Email
                                TextFieldCustom(
                                  controller: controller.forgotEmailCT,
                                  keyboardType: TextInputType.emailAddress,
                                  maxLength: 50,
                                  radiusField: 5,
                                  isCheckOut: false,
                                  hintText: kEmail,
                                  errorText: controller.isForgotEmail
                                      ? kEnterEmail
                                      : null,
                                  onChanged:(value){
                                    if(value == " "){
                                      controller.forgotEmailCT.clear();
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BtnCustom.btnSmall(
                                        title: kCancel,
                                        onPressed: ()=> Get.back(),
                                      ),
                                      BtnCustom.btnSmall(
                                        title: kSubmit,
                                        titleColor: AppColors.yetToStartColor,
                                        onPressed: ()=> controller.onTapForgotPasswordSubmit(context: context),
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              isLoading: controller.isLoading,
            ),
          );
        }
    );

  }
}

class EmailSent extends StatelessWidget {
  String msg;
  EmailSent({Key? key,required this.msg,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor.withOpacity(0.3),
      body: DelayedDisplay(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 30),
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  /// title
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildSizeBox(20.0, 0.0),
                      Image.asset(strImgRightClick,height:50,color: AppColors.greenColor),
                      Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 40),
                        child: BuildText.buildText(
                            text: msg,
                            size: 18,
                            textAlign: TextAlign.center
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: BtnCustom.btnSmall(
                          title: kOkay,
                          titleColor: AppColors.yetToStartColor,
                          onPressed: ()=> Get.back(),
                        ),
                      )

                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/ProjectController/SetupPinController/setupPinController.dart';
import 'package:pharmdel/Controller/WidgetController/Button/ButtonCustom.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/WidgetController/TextField/CustomTextField.dart';
import '../../../Controller/WidgetController/AppBar/app_bar.dart';


class SetupPinScreen extends StatelessWidget {
  SetupPinScreen({Key? key,this.isChangePin, }) : super(key: key);
  bool? isChangePin;

  SetupMPinController setupMPinCtrl = Get.put(SetupMPinController());

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SetupMPinController>(
      init: setupMPinCtrl,
      builder: (controller) {
        return LoadScreen(
          widget: Scaffold(
            backgroundColor: AppColors.whiteColor,
            extendBodyBehindAppBar: true,
            appBar: AppBarCustom.appBarStyle1(
                onTap: ()=> controller.onTapCancel(),
            ),

            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Container(
                  height: Get.height,
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        /// Logo
                        Image.asset(strimg_logo, height: getHeightRatio(value: 15)),
                        buildSizeBox(getHeightRatio(value: 1), 0.0),

                        Container(child: isChangePin == true ?
                        BuildText.buildText(text: kChangeQuickAccessPin) :
                        BuildText.buildText(text: kSetupQuickAccessPin, size: 18)),
                        buildSizeBox(getHeightRatio(value: 5), 0.0),


                        /// Old MPin
                        Visibility(
                          visible: isChangePin == true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              TextFieldCustomForMPin(
                                controller: controller.oldMPinCTRL,
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                // obscuringCharacter: 'X',
                                isCheckOut: true,
                                hintText: kEnterOldMPin,
                                obscureText: controller.eyeHideOld,
                                errorText: controller.isOldMPin
                                    ? kEnterOldMPin
                                    : controller.isValidOldMPin
                                    ? kEnterValidOldMPin
                                    : null,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                suffixIcon: InkWell(
                                    onTap: controller.onTapEyeOld,
                                    child: Icon(controller.eyeHideOld == false ? Icons.remove_red_eye_outlined:Icons.visibility_off_outlined,color: AppColors.greyColor,)
                                ),
                                onChanged: (value){
                                  controller.changeLoadingValue(false);
                                },
                              ),

                              buildSizeBoxRatio(height: 2, width: 0),
                            ],
                          ),
                        ),

                        /// New MPin
                        TextFieldCustomForMPin(
                          controller: controller.newMPinCTRL,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          // obscuringCharacter: 'X',
                          isCheckOut: true,
                          hintText: isChangePin  == true ? kEnterNewMPin:kEnterMPin,
                          obscureText: controller.eyeHideNew,
                          errorText: controller.isNewMPin
                              ? isChangePin == true  ? kEnterNewMPin:kEnterMPin
                              : controller.isValidNewMPin
                              ? isChangePin == true  ? kEnterValidNewMPin:kEnterValidMPin
                              : null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          suffixIcon: InkWell(
                              onTap: controller.onTapEyeNew,
                              child: Icon(controller.eyeHideNew == false ? Icons.remove_red_eye_outlined:Icons.visibility_off_outlined,color: AppColors.greyColor,)
                          ),
                          onChanged: (value){
                            controller.changeLoadingValue(false);
                          },
                        ),
                        buildSizeBoxRatio(height: 2, width: 0),

                        /// Confirm MPin
                        TextFieldCustomForMPin(
                          controller: controller.confirmMPinCTRL,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          // obscuringCharacter: 'X',
                          isCheckOut: true,
                          hintText: kEnterConfirmMPin,
                          obscureText: controller.eyeHideConfirm,
                          errorText: controller.isConfirmMPin
                              ? kEnterConfirmMPin
                              : controller.isValidConfirmMPin
                              ? kEnterValidConfirmMPin
                              : controller.isCorrectConfirmMPinNotMatched ?
                          kConfirmPinNotMatch:null,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          suffixIcon: InkWell(
                              onTap: controller.onTapEyeConfirm,
                              child: Icon(controller.eyeHideConfirm == false ? Icons.remove_red_eye_outlined:Icons.visibility_off_outlined,color:AppColors.greyColor,)
                          ),
                          onChanged: (value){
                            controller.changeLoadingValue(false);
                          },
                        ),
                        buildSizeBoxRatio(height: 4, width: 0),


                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 10,
                          margin: EdgeInsets.zero,
                          child: ButtonCustom(
                              buttonHeight: 50,
                              buttonWidth: MediaQuery.of(context).size.width,
                              text: isChangePin == true ? kChangePin: kDone,
                              backgroundColor: AppColors.colorAccent,
                              onPress: (){
                                controller.onTapSubmit(context: context,isChangeMPin: isChangePin ?? false);
                              },
                          ),
                        ),

                        Visibility(
                          visible: isChangePin == false,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 10,
                                margin: EdgeInsets.zero,
                                child: ButtonCustom(
                                  buttonHeight: 50,
                                  buttonWidth: MediaQuery.of(context).size.width,
                                  text: kCancel,textColor: AppColors.colorAccent,
                                  backgroundColor: AppColors.whiteColor,
                                  onPress: () => controller.onTapCancel(),
                                ),
                              ),
                          ),
                        ),

                      ],
                    ),
                  ),
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

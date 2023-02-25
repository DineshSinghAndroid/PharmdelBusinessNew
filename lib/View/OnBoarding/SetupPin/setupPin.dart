// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/ColorController/CustomColors.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/ProjectController/SetupPinController/setupPinController.dart';
import 'package:pharmdel/Controller/WidgetController/Button/ButtonCustom.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/Controller/WidgetController/TextField/CustomTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Controller/Helper/FormFieldValidator/formFieldValidator.dart';
import '../../../Controller/Helper/StringDefine/StringDefine.dart';
import '../../../Controller/WidgetController/Loader/LoadingScreen.dart';
import '../../../Controller/WidgetController/Toast/ToastCustom.dart';
import '../Login/login_screen.dart';


class SetupPinScreen extends StatefulWidget {
  final bool isChangePassword;  
  const SetupPinScreen({Key? key, required this.isChangePassword,}) : super(key: key);

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {

  SetupMPinController setupMpinCtrl = Get.put(SetupMPinController());



  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.only(left: 0.05 * screenWidth, top: 0.01 * screenHeight, right: 0.05 * screenWidth, bottom: 0.01 * screenHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(bottom: .22 * screenWidth, top: 10.0),
                  child: Image.asset(
                    kSplashLogo,
                    height: 100,
                  )),
              Container(
                  child: widget.isChangePassword
                      ? BuildText.buildText(text: "Change Quick Access Pin")
                      : BuildText.buildText(text: "Setup Quick Access Pin",size: 18)),
              const SizedBox(
                height: 40,
              ),
              // Visibility(
              //   child: Row(
              // children: [
              Container(
                child: widget.isChangePassword
                    ? SizedBox(
                    height:55.0,
                    child: CustomTextField(
                      readOnly: false,
                      controller: setupMpinCtrl.txtOldPin,
                      maxLength: 4,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputAction: TextInputAction.next,
                      // onFieldSubmitted: (v) {
                      //   FocusScope.of(context).requestFocus(setupMpinCtrl.focusPin);
                      // },
                    ))
                    : const SizedBox.shrink(),
              ),

              CustomTextField(
                maxLines: 1,
                readOnly: false,
                controller: setupMpinCtrl.txtEnterOtp,
                focus: setupMpinCtrl.focusPin,
                errorText: !setupMpinCtrl.isNew ? setupMpinCtrl.txtEnterOtp.text != setupMpinCtrl.txtConfirmOtp.text && setupMpinCtrl.txtEnterOtp.text.length == 4 ? "Secure Pin doesn\'t match" : "Secure pin can\'t be empty or less than four digits" : null,
                maxLength: 4,
                hintText: 'Enter Secure Pin',
                obscureText: true,
                inputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: MultiValidator([
                  RequiredValidator(errorText: kEnterMobileNo),
                  MinLengthValidator(10, errorText: kEnterDigPin),
                  // PatternValidator(// r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_])[A-Za-z\d@$!%*?&_]{8,16}$",//     errorText: 'Password is not valid')
                ]),
                // onFieldSubmitted: (v) {
                //   FocusScope.of(context).requestFocus(setupMpinCtrl.focusConfirmPin);
                // },
              ),
              buildSizeBox(15.0, 0.0),
              CustomTextField(
                maxLines: 1,
                readOnly: false,
                controller: setupMpinCtrl.txtConfirmOtp,
                focus:   setupMpinCtrl.focusConfirmPin,
                errorText: !setupMpinCtrl.isConfirm ? setupMpinCtrl.txtEnterOtp.text != setupMpinCtrl.txtConfirmOtp.text && setupMpinCtrl.txtConfirmOtp.text.length == 4 ? "Secure Pin doesn\'t match" : "Confirm secure  pin can\'t be empty or less than four digits" : null,
                maxLength: 4,
                hintText: 'Confirm Secure Pin',
                obscureText: true,
                keyboardType: TextInputType.number,
                inputAction: TextInputAction.done,
                validator: MultiValidator([
                  RequiredValidator(errorText: kEnterMobileNo),
                  MinLengthValidator(10, errorText: kEnterValidPin),
                  // PatternValidator(// r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_])[A-Za-z\d@$!%*?&_]{8,16}$",//     errorText: 'Password is not valid')
                ]),
              ),
              buildSizeBox(40.0, 0.0),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                margin: EdgeInsets.zero,
                child: ButtonCustom(
                    buttonHeight: 50,
                    buttonWidth: MediaQuery.of(context).size.width,
                    text: kDone,
                    backgroundColor: AppColors.colorAccent,
                    onPress: setupMpinCtrl.validatePin
                ),
              ),

              Visibility(
                // visible: widget.isChangePassword,
                child: InkWell(
                  onTap: () async {
                    // openSignInScreen(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 0),
                    child: BuildText.buildText(
                        text:  kCancel,
                        color: AppColors.colorAccent
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



   
}

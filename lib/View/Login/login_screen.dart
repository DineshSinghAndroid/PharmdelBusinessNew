import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/Dimensions/Dimensions.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/TextField/CustomTextField.dart';

import '../../Controller/Helper/StringDefine/StringDefine.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey _formKey = GlobalKey();

  bool isEmail = false;
  bool isPassword = false;
  bool isValidEmail = false;
  RxBool isCheck =  false.obs;

   TextEditingController nameCT = TextEditingController();
  TextEditingController emailCT = TextEditingController();
  TextEditingController mobCT = TextEditingController();

  @override
  void dispose() {
    nameCT.dispose();
    emailCT.dispose();
    mobCT.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildSizeBox(Get.height / 10, 0.0),
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        child: FittedBox(
                          child: Image.asset(
                            "assets/logo/logo.png",
                          ),
                        ),
                      ),
                    ),
                    buildSizeBox(Get.height / 10, 0.0),
                    BuildText.buildText(
                      text: kLogin,
                      size: 32,
                      weight: FontWeight.w600,
                    ),
                    buildSizeBox(Get.height / 10, 0.0),
                    CustomTextField(
                      isError: isEmail,
                      autofillHints: [AutofillHints.name],
                      readOnly: false,
                      controller: nameCT,
                      errorText: isEmail ? kEmail : "",
                      hintText: kEmail,
                      inputType: TextInputType.text,
                      validator: (value) {},
                    ),
                    buildSizeBox(Get.height / 50, 0.0),
                    CustomTextField(
                      isError: isPassword,
                      autofillHints: [AutofillHints.name],
                      readOnly: false,
                      controller: nameCT,
                      errorText: isPassword ? kPassword : "",
                      hintText: kPassword,
                      inputType: TextInputType.text,
                      validator: (value) {},
                    ),
                    buildSizeBox(Get.height / 70, 0.0),
                    Row(
                      children: [

                        // Checkbox(
                        //   visualDensity: VisualDensity(vertical: -4.0),
                        //   activeColor: AppColors.bluearrowcolor,
                        //   value:
                        //   onChanged: (  value) {
                        //     isCheck = value!;
                        //
                        //   },
                        // ),
                        Text(kRememberMe)

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

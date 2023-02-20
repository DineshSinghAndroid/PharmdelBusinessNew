import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/Button/ButtonCustom.dart';
import 'package:pharmdel/Controller/WidgetController/TextField/CustomTextField.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/StringDefine/StringDefine.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../EnterPin/securePin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _formKey = GlobalKey();

  bool isEmail = false;
  bool isPassword = false;
  bool isValidEmail = false;
  RxBool isCheck =  false.obs;
  bool savePassword = true;

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
                          child: Image.asset(
                            strimg_logo,
                          ),
                        ),
                      ),
                    ),
                    buildSizeBox(Get.height /20, 0.0),
                    BuildText.buildText(
                      text: kLogin,
                      size: 32,
                      weight: FontWeight.w600,
                    ),
                    buildSizeBox(Get.height / 16, 0.0),
                    CustomTextField(
                      isError: isEmail,
                      autofillHints: const [AutofillHints.name],
                      readOnly: false,
                      controller: nameCT,
                      errorText: isEmail ? kEmail : "",
                      hintText: kEmail,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return null;
                      },
                    ),
                    // buildSizeBox(Get.height / 50, 0.0),
                    CustomTextField(
                      isError: isPassword,
                      autofillHints: const [AutofillHints.name],
                      readOnly: false,
                      controller: nameCT,
                      errorText: isPassword ? kPassword : "",
                      hintText: kPassword,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return null;
                      },
                    ),
                    buildSizeBox(Get.height / 70, 0.0),
                    Row(
                      children: [

                        Checkbox(
                    visualDensity: const VisualDensity(vertical: -4.0),
                    activeColor: AppColors.colorAccent,
                    value: savePassword,                    
                    onChanged: (bool? value) {
                      setState(() { 
                        savePassword = value!;
                      });
                    },
                  ),
                      BuildText.buildText(text: kRememberMe,)

                      ],
                    ),
                    buildSizeBox(20.0, 0.0),
                  ButtonCustom(
                    onPress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SecurePin(true),));
                    }, 
                    text: kContinue, 
                    buttonWidth: MediaQuery.of(context).size.width, 
                    buttonHeight: 50,
                    backgroundColor: AppColors.colorAccent,),
                    buildSizeBox(15.0, 0.0),
                    BuildText.buildText(
                      text: kForgotPassword,
                      size: 16,
                      weight: FontWeight.bold
                      ),
                      buildSizeBox(Get.height / 15, 0.0),
                      const Text(
                      kHowToGuide,
                      style: TextStyle(
                        fontSize: 22.0,
                        shadows: [
                          Shadow(
                            color: Colors.red,
                            offset: Offset(0, -5),
                          )
                        ],
                        color: Colors.transparent,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                        decorationThickness: 1,
                      ),
                    ),
                    buildSizeBox(20.0, 0.0),
                   Text.rich(TextSpan(
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
                          redirectToBrowser(WebApiConstant.TERMS_URL);
                        }  
                     ),                     
                   TextSpan(text: ' and ', style: const TextStyle(fontSize: 15, color: Colors.black), children: <TextSpan>[
                    TextSpan(
                        text: kPrivacyPolicy,
                        style: const TextStyle(fontSize: 17, color: Colors.black, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          redirectToBrowser(WebApiConstant.PRIVACY_URL);
                        })
                  ])
                ])),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onTapLogin(){

  }

 Future<void> redirectToBrowser(String url) async {
    var link = url;
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      throw 'Could not launch $link';
    }
  }

}

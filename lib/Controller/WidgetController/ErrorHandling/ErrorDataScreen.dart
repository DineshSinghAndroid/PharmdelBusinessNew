

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Helper/ColorController/CustomColors.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../Button/ButtonCustom.dart';
import '../StringDefine/StringDefine.dart';

class ErrorScreen extends StatefulWidget {
  ErrorScreen({Key? key,required this.onTap,this.isShowBackBtn}) : super(key: key);
  final OnTapRefresh? onTap;
  bool? isShowBackBtn;
  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(strSvgEmptyData),
                    buildSizeBox(30.0, 0.0),
                    BuildText.buildText(text: kError),
                    buildSizeBox(20.0, 0.0),
                    buildSizeBox(80.0, 0.0),
                    ButtonCustom(
                        onPress: widget.onTap!,
                        buttonWidth: Get.width,
                        buttonHeight: 54,
                        text: kRetry

                    ),
                  ],
                ),

                widget.isShowBackBtn == true ?
                InkWell(
                  onTap: (){
                    print("tear");
                    Get.back();
                    },
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.arrow_back_ios,color: CustomColors.blackColor,size: 40,),
                  ),
                ):const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
typedef OnTapRefresh = void Function();

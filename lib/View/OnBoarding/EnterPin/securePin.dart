
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/Helper/TextController/FontFamily/FontFamily.dart';
import 'package:pharmdel/Controller/RouteController/RouteNames.dart';
import '../../../Controller/Helper/Colors/custom_color.dart';
import '../../../Controller/Helper/TextController/FontStyle/FontStyle.dart';
import '../../../Controller/ProjectController/SecurePinController/secure_pin_controller/secure_pin_controller.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/WidgetController/TextField/CustomTextField.dart';

class SecurePin extends StatefulWidget {
  bool isDialog = false;

  SecurePin({super.key});

  @override
  SecurePinState createState() => SecurePinState();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SecurePinState extends State<SecurePin> {
  double? ScreenHeight;

  FocusNode? myFocusNode;

  final SecurePinController _controller = Get.put(SecurePinController());

  @override
  void initState() {
    super.initState();
    _controller.clearCTRL();
    _controller.pin1focusNode.requestFocus();
  }

  List numbers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
  ];

  @override
  void dispose() {
    myFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<SecurePinController>(
      init: _controller,
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                buildSizeBox(50.0, 0.0),
                Image.asset(strimg_logo, height: 100),
                buildSizeBox(20.0, 0.0),
                BuildText.buildText(text: kEnterSecurePin, size: 16, fontFamily: FontFamily.NexaBold),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SecurePinTextField.pinBox(

                        screenWidth: screenWidth,
                        controllers: controller.controller1,
                        focus: controller.pin1focusNode,
                        onChanged: (value) {
                          controller.nextField(value, controller.pin2focusNode);
                        }),
                    SecurePinTextField.pinBox(
                        screenWidth: screenWidth,
                        controllers: controller.controller2,
                        focus: controller.pin2focusNode,
                        onChanged: (value) {
                          controller.nextField(value, controller.pin3focusNode, controller.pin1focusNode);
                        }),
                    SecurePinTextField.pinBox(
                        screenWidth: screenWidth,
                        controllers: controller.controller3,
                        focus: controller.pin3focusNode,
                        onChanged: (value) {
                          controller.nextField(value, controller.pin4focusNode, controller.pin2focusNode);
                        }),
                    SecurePinTextField.pinBox(
                        screenWidth: screenWidth,
                        controllers: controller.controller4,
                        focus: controller.pin4focusNode,
                        onChanged: (value) {
                          controller.nextField(value, controller.pin4focusNode, controller.pin3focusNode);
                        }),
                  ],
                ),
                GridView.builder(
                  itemCount: numbers.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 2 / 1, crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), border: Border.all(color: Colors.orange)),
                      child: MaterialButton(
                        onPressed: () {
                          controller.assignValueInField(value: (index + 1).toString());
                        },
                        child: Text(numbers[index].toString()),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                         width: screenWidth / 3,
                        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), border: Border.all(color: Colors.orange)),
                        child: MaterialButton(
                          onPressed: () {
                            controller.assignValueInField(value: '0');
                          },
                          child: Text("0"),
                        ),
                      ),
                    ),
                    buildSizeBox(0.0, screenWidth / 20),
                    Container(
                      width: screenWidth / 2,
                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), border: Border.all(color: Colors.orange)),
                      child: MaterialButton(
                        onPressed: () {
                          _controller.clearPin();
                        },
                        child: Text("Del"),
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(
                    top: 0.02 * ScreenHeight!,
                  ),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          _controller.clearPin();
                          Get.toNamed(setupPinScreenRoute);
                        },
                        child: Text(
                          kForgotMPIN,
                          textAlign: TextAlign.end,
                          style: Regular16Style.copyWith(color: AppColors.colorAccent),
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 0.03 * ScreenHeight!,
                    ),
                    child: Text(
                      kusediffAcc,
                      textAlign: TextAlign.center,
                      style: Regular16Style.copyWith(color: AppColors.colorAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

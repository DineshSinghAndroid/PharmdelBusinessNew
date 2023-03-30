import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../Controller/ProjectController/CreatePatiientController/create_patient_controller.dart';
import '../../Controller/WidgetController/Button/ButtonCustom.dart';
import '../../Controller/WidgetController/TextField/CustomTextField.dart';

class CreatePatientScreen extends StatefulWidget {
  const CreatePatientScreen({super.key});

  @override
  State<CreatePatientScreen> createState() => _CreatePatientScreenState();
}

class _CreatePatientScreenState extends State<CreatePatientScreen> {
  final GlobalKey _formKey = GlobalKey();
  final CreatePatientController _controller = Get.put(CreatePatientController());


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: _controller,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.materialAppThemeColor,
              title: BuildText.buildText(text: kCreatePatient, size: 18),
              elevation: 1.0,
              leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.blackColor,
                    ),
                  ))),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  child: Column(

                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: FittedBox(
                                child: DropdownButton2(
                                  hint: Text(
                                    'Select Title*',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: _controller.selectTitle
                                      .map((item) => DropdownMenuItem<SurNameTitle>(
                                            value: item,
                                            child: Text(
                                              item.showTitle,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: _controller.selectedTitleValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _controller.selectedTitleValue = value;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black))),
                                  menuItemStyleData: const MenuItemStyleData(),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonHideUnderline(
                              child: FittedBox(
                                child: DropdownButton2(
                                  hint: Text(
                                    'Select Gender*',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: _controller.selectGender
                                      .map((item) => DropdownMenuItem<SurNameTitle>(
                                            value: item,
                                            child: Text(
                                              item.showTitle,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: _controller.selectedGenderValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _controller.selectedGenderValue = value;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(

                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                                      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.black))),
                                  menuItemStyleData: const MenuItemStyleData(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildSizeBox(15.0, 00.00),
                      Row(
                        children: [
                          Flexible(
                            child: CustomTextField(
                              readOnly: false,
                              hintText: "First Name*",
                              controller: _controller.nameCtrl,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          buildSizeBox(0.0, 10.0),
                          Flexible(
                              child: CustomTextField(
                            readOnly: false,
                            hintText: "Middle Name",
                            controller: _controller.middleNameCtrl,
                            keyboardType: TextInputType.text,
                          )),
                        ],
                      ),
                      buildSizeBox(15.0, 00.00),
                      Row(
                        children: [
                          Flexible(
                            child: CustomTextField(

                              readOnly: false,
                              hintText: "Last Name*",
                              controller: _controller.lastNameCtrl,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          buildSizeBox(0.0, 10.0),
                          Flexible(
                              child: CustomTextField(
                            readOnly: false,
                            hintText: "Mobile Number",
                            controller: _controller.mobileCtrl,
                            keyboardType: TextInputType.text,
                          )),
                        ],
                      ),
                      buildSizeBox(15.0, 00.00),
                      Row(
                        children: [
                          Flexible(
                            child: CustomTextField(
                              readOnly: false,
                              hintText: "Email (Optional)",
                              controller: _controller.emailCtrl,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          buildSizeBox(0.0, 10.0),
                          Flexible(
                              child: CustomTextField(
                            readOnly: false,
                            hintText: "NHS number(Optional)",
                            controller: _controller.nhsNoCtrl,
                            keyboardType: TextInputType.text,
                          )),
                        ],
                      ),
                      buildSizeBox(15.0, 00.00),
                      Flexible(
                          child: CustomTextField(
                        readOnly: false,
                        hintText: "Address line 1",
                        labelText: "Address line 1",
                        controller: _controller.addressLine1Ctrl,
                        keyboardType: TextInputType.text,
                      )),
                      buildSizeBox(15.0, 00.00),
                      Flexible(
                          child: CustomTextField(
                        readOnly: false,
                        hintText: "Address line 2",
                        labelText: "Address line 2",
                        controller: _controller.addressLine2Ctrl,
                        keyboardType: TextInputType.text,
                      )),
                      buildSizeBox(15.0, 00.00),
                      Flexible(
                          child: CustomTextField(
                        readOnly: false,
                        hintText: "Town Name*",
                        labelText: "Town Name*",
                        controller: _controller.townCtrl,
                        keyboardType: TextInputType.text,
                      )),
                      buildSizeBox(15.0, 00.00),
                      Flexible(
                          child: CustomTextField(
                        readOnly: false,
                        hintText: "Post Code*",
                        labelText: "Post Code*",
                        controller: _controller.postCodeCtrl,
                        keyboardType: TextInputType.text,
                      )),
                      buildSizeBox(75.0, 00.00),
                      ButtonCustom(onPress:() {
                        _controller.btnPress(context);
                      }, text: kSaveAndCreate,
                    buttonWidth: Get.width / 1.4, buttonHeight: 60.0)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

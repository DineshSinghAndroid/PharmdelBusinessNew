import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../Controller/Helper/TextController/FontStyle/FontStyle.dart';
import '../../Controller/ProjectController/CreatePatiientController/create_patient_controller.dart';
import '../../Controller/WidgetController/Button/ButtonCustom.dart';
import '../../Controller/WidgetController/TextField/CustomTextField.dart';
import '../../main.dart';

class CreatePatientScreen extends StatefulWidget {
  const CreatePatientScreen({super.key});

  @override
  State<CreatePatientScreen> createState() => _CreatePatientScreenState();
}

class _CreatePatientScreenState extends State<CreatePatientScreen> {


  final GlobalKey _formKey = GlobalKey();
  final CreatePatientController _controller = Get.put(CreatePatientController());

String titleValue='dfasdf';
List<String> genderCat = [
  'Male',
  'Female'
];
List<String> items = [
  "Mr",
  "Miss",
  "Mrs",
  "Ms",
  "Captain",
  "Dr",
  "Prof",
  "Rev",
  "Mx",
];
 
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: _controller,
      builder: (controller) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.materialAppThemeColor,
            title: BuildText.buildText(
                text:  kCreatePatient,
                size: 18
            ),
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
          child: Form(
            key: _formKey,

            child: Container(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      \..CustomTextField(readOnly: false),
                      Container(
                          height: 20,
                          width: 20,
                          child: CustomTextField(readOnly: false))
                      ,
                    ],
                  )
                  ,

                ],
              ),
            ),
          ),
        ),
      );
    },);
  }
}
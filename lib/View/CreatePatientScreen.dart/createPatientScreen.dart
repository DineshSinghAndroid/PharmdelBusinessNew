import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../Controller/Helper/TextController/FontStyle/FontStyle.dart';
import '../../Controller/WidgetController/Button/ButtonCustom.dart';
import '../../Controller/WidgetController/TextField/CustomTextField.dart';
import '../../main.dart';

class CreatePatientScreen extends StatefulWidget {
  const CreatePatientScreen({super.key});

  @override
  State<CreatePatientScreen> createState() => _CreatePatientScreenState();
}

class _CreatePatientScreenState extends State<CreatePatientScreen> {

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController middleNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nhsNoCtrl = TextEditingController();
  TextEditingController searchAddressCtrl = TextEditingController(); 

String? titleValue;
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
                  logger.i("8::::::::::::::::========>");
                  Navigator.pop(context, false);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor,                  
                ),
              ))),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                              height: 50,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.0, color: Colors.grey.shade500),
                                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: titleValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: const SizedBox(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      titleValue = newValue;
                                    });
                                  },
                                  items: items.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: BuildText.buildText(
                                        text:  value,
                                      ),
                                    );
                                  }).toList(),
                                  hint: BuildText.buildText(
                                    text:  kSelectTitle,
                                  ),
                                ),
                              )),
                        ),
                        buildSizeBox(0.0, 5.0),
                        Flexible(
                          flex: 1,
                          child: Container(
                              height: 50,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.0, color: Colors.grey.shade500),
                                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: titleValue,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: const SizedBox(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      titleValue = newValue;
                                    });
                                  },
                                  items: genderCat.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: BuildText.buildText(
                                        text: value,                                      
                                      ),
                                    );
                                  }).toList(),
                                  hint: BuildText.buildText(
                                    text:  kSelectGender,                                 
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    buildSizeBox(10.0, 0.0),
                    Row(
                      children: [
                         Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: CustomTextField(
                            labelText: kFirstName,
                            readOnly: false,
                            controller: nameCtrl,
                            keyboardType: TextInputType.name,                            
                            inputAction: TextInputAction.next,
                            // onChanged: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },                            
                          ),
                        ),
                      ),
                         buildSizeBox(0.0, 5.0),
                         Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: CustomTextField(
                            labelText: kMiddleName,
                            readOnly: false,
                            controller: middleNameCtrl,
                            keyboardType: TextInputType.name,                            
                            inputAction: TextInputAction.next,
                            // onChanged: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },
                          ),
                        ),
                      ),
                      ],
                    ),
                    buildSizeBox(10.0, 0.0),
                    Row(
                      children: [
                         Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: CustomTextField(
                            labelText: kLastName,
                            readOnly: false,
                            controller: lastNameCtrl,
                            keyboardType: TextInputType.name,                            
                            inputAction: TextInputAction.next,
                            // onChanged: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },                         
                          ),
                        ),
                      ),
                         buildSizeBox(0.0, 5.0),
                         Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: CustomTextField(
                            labelText: kMobileNumber,
                            readOnly: false,
                            controller: mobileCtrl,
                            keyboardType: TextInputType.name,                            
                            inputAction: TextInputAction.next,
                            // onChanged: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },                         
                          ),
                        ),
                      ),
                      ],
                    ),                  
                    buildSizeBox(10.0, 0.0),
                    Row(
                      children: [
                         Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: CustomTextField(  
                            labelText: kEmailOptional,
                            readOnly: false,                          
                            controller: emailCtrl,
                            keyboardType: TextInputType.name,                            
                            inputAction: TextInputAction.next,
                            // onChanged: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },                           
                          ),
                        ),
                      ),
                         buildSizeBox(0.0, 5.0),
                         Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: CustomTextField(
                            labelText: kNHSNumber,
                            readOnly: false,
                            controller: nhsNoCtrl,
                            keyboardType: TextInputType.name,                            
                            inputAction: TextInputAction.next,
                            // onChanged: (v){
                            //   FocusScope.of(context).requestFocus(focusPin);
                            // },                            
                          ),
                        ),
                      ),
                      ],
                    ),
                    buildSizeBox(10.0, 0.0),
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: CustomTextField(
                            controller: searchAddressCtrl,
                            keyboardType: TextInputType.name,
                            inputAction: TextInputAction.next,
                            readOnly: false,
                            onChanged: (value) {
                              // FocusScope.of(context).requestFocus(focusPin);
                            },
                            labelText: kSearchAddress,
                          )                          
                        ),
                      ),
                      buildSizeBox(40.0, 0.0),
                      ButtonCustom(
                        onPress: (){},
                        text: kSaveAndCreate,
                        buttonHeight: 50,
                        buttonWidth: Get.width,
                        backgroundColor: AppColors.colorAccent,
                        textSize: 16,
                      )
                 ],
                ),
              ),
    );
  }
}
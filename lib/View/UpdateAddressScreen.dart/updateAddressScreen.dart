import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../Controller/ProjectController/UpdateProfileController/updateProfileController.dart';

class UpdateAddressScreen extends StatefulWidget {
  String? address1, address2, townName, postCode;
   UpdateAddressScreen({super.key, required this.address1, required this.address2, required this.postCode, required this.townName});

  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {

  UpdateProfileController updPrfCtrl = Get.put(UpdateProfileController());

  TextEditingController addressController = TextEditingController();
  TextEditingController addressController2 = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();

  FocusNode addressFocus = FocusNode();
  FocusNode addressFocus1 = FocusNode();
  FocusNode townFocus = FocusNode();
  FocusNode postCodeFocus2 = FocusNode();
  FocusNode surgeryFocus = FocusNode();

  String accessToken = "";
  String? username;
  String? mobile;

@override 
void initState() {  
    super.initState();
    init();
  }

void init() async {
  addressController.text = widget.address1!.toString().trim();
  addressController2.text = widget.address2!;
  townController.text = widget.townName!;
  postCodeController.text = widget.postCode!;
}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: updPrfCtrl,
      builder: (controller) {
        return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: BuildText.buildText(
            text: kUpdateAddress,
            size: 18
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 0))
                            ],
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: BuildText.buildText(
                            text: 'M',
                            style: TextStyle(
                                color: AppColors.whiteColor, fontSize: 27.0),
                          ),
                        )),
                  ],
                ),
                buildSizeBox(5.0, 0.0),
                BuildText.buildText(
                  text: 'Driver',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                buildSizeBox(5.0, 0.0),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),                    
                  elevation: 3.0,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: BuildText.buildText(text: kUpdateAddress),
                        ),
                      ),
                      customListTile(
                        textController: addressController,
                        focusNode: addressFocus,
                        title: kAddressLine1,
                        hintText: kAddressLine1
                      ),
                      buildSizeBox(5.0, 0.0),
                      const Divider(height: 0,thickness: 0,endIndent: 10,indent: 10),
                      customListTile(
                        textController: addressController2,
                        focusNode: addressFocus1,
                        title: kAddressLine2,
                        hintText: kAddressLine2
                      ),
                      buildSizeBox(5.0, 0.0),
                      const Divider(height: 0,thickness: 0,endIndent: 10,indent: 10),
                      customListTile(
                        textController: townController,
                        focusNode: townFocus,
                        title: kTownName,
                        hintText: kTown
                      ),
                      buildSizeBox(5.0, 0.0),
                      const Divider(height: 0,thickness: 0,endIndent: 10,indent: 10),
                      customListTile(
                        textController: postCodeController,
                        focusNode: postCodeFocus2,
                        title: kPostalCode,
                        hintText: 'L84TL'
                      ),
                      buildSizeBox(5.0, 0.0),                     
                    ],
                  ),
                ),
                buildSizeBox(5.0, 0.0),
                ButtonCustom(
                  onPress: ()async{      
                    updPrfCtrl.updateProfileApi(
                      context: context, 
                      addressLine1: addressController.text.toString().trim(), 
                      addressLine2: addressController2.text.toString().trim(), 
                      town: townController.text.toString().trim(), 
                      postCode: postCodeController.text.toString().trim());              
                  }, 
                  text: kUpdateAddress, 
                  buttonWidth: Get.width, 
                  buttonHeight: 50,
                  backgroundColor: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(10),
                  )
              ],
            ),
          ),
        ),
      ),
    );
      },
    );
  }

  Widget customListTile({required String title, required String hintText, required TextEditingController textController,required FocusNode focusNode}) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: BuildText.buildText(text: title, size: 15),
      subtitle: Column(
        children: [
          buildSizeBox(5.0, 0.0),
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: textController,
              focusNode: focusNode,                            
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: hintText,
                  labelStyle:
                      TextStyle(color: AppColors.greyColor, fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColors.greyColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: AppColors.greyColor))),
            ),           
          ),
        ],
      ),
    );
  }
}

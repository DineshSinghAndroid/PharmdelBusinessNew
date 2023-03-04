import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

class CreateNotificationScreen extends StatefulWidget {
  const CreateNotificationScreen({super.key});

  @override
  State<CreateNotificationScreen> createState() => _CreateNotificationScreenState();
}

class _CreateNotificationScreenState extends State<CreateNotificationScreen> {

TextEditingController notificationNameController = TextEditingController();

FocusNode focusNotificationName = FocusNode();

List<String> items = ['Item 1, Item 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.blackColor),
        actionsIconTheme: IconThemeData(color: AppColors.blackColor),
        title: BuildText.buildText(
          text: kCreateNotification,
          size: 18
        ),        
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildText.buildText(
              text: kNotificationName,
              size: 18,
              weight: FontWeight.w500
            ),
            buildSizeBox(10.0, 0.0),
            CustomTextField(
              hintText: 'Name',
              readOnly: false,
                validator: (val) {
                  
                },
                controller: notificationNameController,
                onChanged: (v) {
                  FocusScope.of(context).requestFocus(focusNotificationName);
                },
                ////initialValue: "rc2.cust20200101@gmail.com",
                inputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,                                    
              ),
              buildSizeBox(20.0, 0.0),
              BuildText.buildText(
                text: kPharmacyStaff,
                size: 18,
                weight: FontWeight.w500                
              ),
              buildSizeBox(10.0, 0.0),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15,right: 10),
                height: 50,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.greyColor)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BuildText.buildText(text: kSelectPharStaff,color: AppColors.greyColor),
                    const Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
              buildSizeBox(20.0, 0.0),
              BuildText.buildText(
                text: kMessage,
                size: 18,
                weight: FontWeight.w500                
              ),
              buildSizeBox(10.0, 0.0),
              CustomTextField(readOnly: false)
          ],
        ),
      ),
    );
  }
}
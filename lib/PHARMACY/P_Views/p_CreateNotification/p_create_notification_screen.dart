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
TextEditingController notificationMessageController = TextEditingController();

FocusNode focusNotificationName = FocusNode();

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
            TextFormField(
                  decoration: InputDecoration(
                    hintText: kName,
                    hintStyle: TextStyle(color: AppColors.greyColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.greyColor)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.greyColor)
                    ),
                  ),
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
              SizedBox(
                height: 160,
                width: Get.width,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: kMessage,
                    hintStyle: TextStyle(color: AppColors.greyColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.greyColor)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.greyColor)
                    ),
                  ),
                  maxLength: 500,     
                  maxLines: 100,           
                ),
              ),
              const Spacer(),              
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ButtonCustom(
                onPress: (){}, 
                text: kSubmit, 
                buttonWidth: Get.width, 
                buttonHeight: 50,
                backgroundColor: AppColors.blueColor,),
      ),
    );
  }
}
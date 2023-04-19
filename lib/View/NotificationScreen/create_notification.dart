import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/NotificationController/create_notification_controller.dart';
import '../../Controller/WidgetController/TextField/CustomTextField.dart';

class CreateNotification extends StatefulWidget {
  const CreateNotification({Key? key}) : super(key: key);

  @override
  State<CreateNotification> createState() => _CreateNotificationState();
}


class _CreateNotificationState extends State<CreateNotification> {

  CreateNotificationController createNotification = Get.put(CreateNotificationController());


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<CreateNotificationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateNotificationController>(
      init: createNotification,
      builder: (controller) {
        return SafeArea(
          child: GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: LoadScreen(
              widget: Scaffold(
                appBar: AppBarCustom.appBarStyle2(
                  title: kCreateNotification,
                  centerTitle: false,
                  titleColor: AppColors.whiteColor,
                  backgroundColor: AppColors.blueColor
                ),

                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      /// Notification Name
                      BuildText.buildText(text: kNotificationName,size: 18,weight: FontWeight.w500),
                      buildSizeBox(10.0, 0.0),
                      TextFieldCustom(
                        controller: controller.notificationNameController,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 100,
                        isCheckOut: true,
                        hintText: kName,
                        radiusField: 5.0,
                        errorText: controller.isName
                            ? kName
                            : null,
                        onChanged:(value){
                          if(value == " "){
                            controller.notificationNameController.clear();
                          }
                        },
                      ),

                      buildSizeBox(10.0, 0.0),

                      /// Notification Message
                      BuildText.buildText(text: kMessage,size: 18,weight: FontWeight.w500),
                      buildSizeBox(10.0, 0.0),
                      CustomTextFieldRaiseQuery(
                        controller: controller.messageController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        readOnly: false,
                        autofocus: false,
                        isCheckOut: true,
                        radiusField: 5.0,
                        hintText: kMessage,
                        errorText: controller.isMessage
                            ? kMessage
                            : null,
                        onTap: (){

                        },
                        onChanged:(value){
                          if(value == " "){
                            controller.messageController.clear();
                          }
                        },
                      ),

                      buildSizeBox(15.0, 0.0),
                    ],
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, left: 12.0, right: 12.0),
                  child: Container(
                    margin: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 0),
                    width: Get.width,
                    child: MaterialButton(
                        color: Colors.black,
                        height: 50,
                        onPressed: ()=> controller.onTapSubmit(context: context),
                        child: BuildText.buildText(text: kSubmit,size: 18,weight: FontWeight.w500,color: AppColors.whiteColor),

                    ),
                  ),
                ),
              ),
              isLoading: controller.isLoading,
            ),
          ),
        );
      },
    );
  }

}

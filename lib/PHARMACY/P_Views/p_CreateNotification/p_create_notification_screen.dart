import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';

class CreateNotificationScreen extends StatefulWidget {
  const CreateNotificationScreen({super.key});

  @override
  State<CreateNotificationScreen> createState() => _CreateNotificationScreenState();
}

class _CreateNotificationScreenState extends State<CreateNotificationScreen> {

PharmacyNotificationController phrNotfCtrl = Get.put(PharmacyNotificationController());

TextEditingController notificationNameController = TextEditingController();
TextEditingController notificationMessageController = TextEditingController();
TextEditingController pharStaffController = TextEditingController();

FocusNode focusNotificationName = FocusNode();

bool isSelectPharm = false;
bool isSelectPharmName = false;

@override
void initState() {     
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyNotificationController>(
      init: phrNotfCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            resizeToAvoidBottomInset: false,
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
              body: Stack(
          children:  [Padding(
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

                /// Notification Name
                TextFormField(
                  controller: notificationNameController,
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

                  /// Select Pharmacy Staff     
                  WidgetCustom.pharmacySelectStaffWidget(
                  title: controller.selectedStaff != null ? controller.selectedStaff?.name.toString() ?? "" :kSelectPharStaff,
                  onTap:()=> controller.onTapSelectStaff(context:context,controller:controller),),
              
                  buildSizeBox(20.0, 0.0),
                  BuildText.buildText(
                    text: kMessage,
                    size: 18,
                    weight: FontWeight.w500                
                  ),
                  buildSizeBox(10.0, 0.0),

                  /// Notification Message
                  SizedBox(
                    height: 160,
                    width: Get.width,
                    child: TextFormField(
                      controller: notificationMessageController,
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
          isSelectPharm == true ?
                Positioned(
                  top: 210,  
                  left: 10,
                  right: 10,              
                  child: Card(
                    elevation: 3,                  
                    margin: EdgeInsets.zero,
                    child: Container(
                      height: 300,
                      width: Get.width,
                      color: AppColors.whiteColor,
                      child: ListView.builder(
                        itemCount: controller.createNotificationData?.staffList?.length ?? 0,
                        shrinkWrap: true,                      
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15,left: 10,right: 10,bottom: 15),
                            child: InkWell(
                              onTap: (){
                                pharStaffController.text = controller.createNotificationData?.staffList?[index].name ?? "";
                              },
                              child: BuildText.buildText(
                                text: controller.createNotificationData?.staffList?[index].name ?? "",size: 14
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ) : const SizedBox.shrink()
               ]),
              bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ButtonCustom(
                  onPress: ()async{
                    await phrNotfCtrl.saveNotificationApi(
                      context: context, 
                      name: notificationNameController.text.toString().trim(), 
                      userList: controller.selectedStaff?.userId ?? "", 
                      message: notificationMessageController.text.toString().trim(), 
                      role: controller.selectedStaff?.role ?? "").then((value) async {
                        Get.back();
                      });                      
                  }, 
                  text: kSubmit, 
                  buttonWidth: Get.width, 
                  buttonHeight: 50,
                  backgroundColor: AppColors.blueColor,),
              ),
            ),
        );
      },
    );
  }
}
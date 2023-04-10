import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';

class PharmacyNotificationBottomSheet extends StatefulWidget{
  PharmacyNotificationController controller;  
  String? selectedID;
  PharmacyNotificationBottomSheet({Key? key,required this.controller, this.selectedID}) : super(key: key);

  @override
  State<PharmacyNotificationBottomSheet> createState() => _PharmacyNotificationBottomSheetState();
}

class _PharmacyNotificationBottomSheetState extends State<PharmacyNotificationBottomSheet> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyNotificationController>(
        init: widget.controller,
        builder: (ctrl){
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
                title: BuildText.buildText(
                  text: kSelectPharStaff,
                  size: 14,
                  color: AppColors.blackColor,                    
                ),
                leading: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back,color: AppColors.blackColor,),
                ),
                elevation: 1,
                backgroundColor: AppColors.whiteColor,
                centerTitle: true,
              ),

              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSizeBox(10.0,0.0),                                  
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.createNotificationData?.staffList?.length ?? 0,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ) ;
                        },
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){       
                             Navigator.of(context).pop(widget.controller.createNotificationData?.staffList?[i]);                             
                            },
                            child: Container(
                              width: Get.width,
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.createNotificationData?.staffList?[i].userId ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10, 
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.createNotificationData?.staffList?[i].name ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ),
                    buildSizeBox(10.0, 0.0)
                  ],
                ),
              ),
            ),
          );
        }
    );

  }
}
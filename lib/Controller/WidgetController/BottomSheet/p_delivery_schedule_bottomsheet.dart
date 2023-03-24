import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../../PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';

class SelectDeliveryScheduleBottomsheet extends StatefulWidget{
  DeliveryScheduleController controller;
  String listType;
  String? selectedID;
  SelectDeliveryScheduleBottomsheet({Key? key,required this.controller,required this.listType, this.selectedID}) : super(key: key);

  @override
  State<SelectDeliveryScheduleBottomsheet> createState() => _SelectDeliveryScheduleBottomsheetState();
}

class _SelectDeliveryScheduleBottomsheetState extends State<SelectDeliveryScheduleBottomsheet> {

  DeliveryScheduleController delSchdCtrl = Get.put(DeliveryScheduleController());


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryScheduleController>(
      init: delSchdCtrl,
      builder: (controller) {
        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
                title: BuildText.buildText(
                  text:  widget.listType == "service" ? kSelService : widget.listType == "recieved" ? kReceived : widget.listType == "nursing home" ? kSelectNursHome : widget.listType == "parcel location" ? kParcelLocation : widget.listType == "exempt" ? kSelectExempt : kSelDelCharge,
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
              
                    widget.listType == "service" ?
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.deliveryScheduleData?.shelf?.length ?? 0,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ) ;
                        },
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                             Navigator.of(context).pop(widget.controller.deliveryScheduleData?.shelf?[i]);
                            },
                            child: Container(
                              width: Get.width,
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.deliveryScheduleData?.shelf?[i].id ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10, 
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.deliveryScheduleData?.shelf?[i].name ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ) : 
                    widget.listType == "received" ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.statusItems.length,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                             Navigator.of(context).pop(controller.statusItems[i]);
                            },
                            child: Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == controller.statusItems[i] ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: controller.statusItems[i],
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ) :
                    widget.listType == "nursing home" ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.deliveryScheduleData?.nursingHomes?.length ?? 0,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).pop(widget.controller.deliveryScheduleData?.nursingHomes?[i]);
                            },
                            child: Container(                              
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.deliveryScheduleData?.nursingHomes?[i].id ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.deliveryScheduleData?.nursingHomes?[i].nursingHomeName ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ) : 
                    widget.listType == "parcel location" ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.parcelBoxList?.length ?? 0,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).pop(widget.controller.parcelBoxList?[i]);
                            },
                            child: Container(                              
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.parcelBoxList?[i].id ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.parcelBoxList?[i].name ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ) :  
                    widget.listType == "exempt" ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.deliveryScheduleData?.exemptions?.length ?? 0,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).pop(widget.controller.deliveryScheduleData?.exemptions?[i]);
                            },
                            child: Container(                              
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.deliveryScheduleData?.exemptions?[i].id ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.deliveryScheduleData?.exemptions?[i].code ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ) :
                    widget.listType == kSelDelCharge ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.deliveryScheduleData?.patientSubscriptions?.length ?? 0,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).pop(widget.controller.deliveryScheduleData?.patientSubscriptions?[i]);
                            },
                            child: Container(                              
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.deliveryScheduleData?.patientSubscriptions?[i].id ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.deliveryScheduleData?.patientSubscriptions?[i].name ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ) :
                    const SizedBox.shrink(),
                    buildSizeBox(10.0, 0.0)
                  ],
                ),
              ),
            ),
          );
      },
    );

  }
}
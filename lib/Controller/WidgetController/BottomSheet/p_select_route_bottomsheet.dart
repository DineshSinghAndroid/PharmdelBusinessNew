import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';

class PhramacySelectRouteBottomSheet extends StatefulWidget{
  NursingHomeController controller;
  String listType;
  String? selectedID;
  PhramacySelectRouteBottomSheet({Key? key,required this.controller,required this.listType, this.selectedID}) : super(key: key);

  @override
  State<PhramacySelectRouteBottomSheet> createState() => _PhramacySelectRouteBottomSheetState();
}

class _PhramacySelectRouteBottomSheetState extends State<PhramacySelectRouteBottomSheet> {



  @override
  Widget build(BuildContext context) {
    return GetBuilder<NursingHomeController>(
        init: widget.controller,
        builder: (ctrl){
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
                title: BuildText.buildText(
                  text:  widget.listType == "route" ? kSelectRoute : widget.listType == "driver" ? kSelectDriver : widget.listType == "nuring home" ? kSelectNursHome : kSelectTote,
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
              
                    widget.listType == "route" ?
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.getRouteListController.routeList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                          ) ;
                        },
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                             Navigator.of(context).pop(widget.controller.getRouteListController.routeList[i]);
                            },
                            child: Container(
                              width: Get.width,
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.getRouteListController.routeList[i].routeId ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10, 
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.getRouteListController.routeList[i].routeName ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    )
                        : widget.listType == "driver" ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.getDriverListController.driverList.length,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                             Navigator.of(context).pop(widget.controller.getDriverListController.driverList[i]);
                            },
                            child: Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.getDriverListController.driverList[i].driverId ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.getDriverListController.driverList[i].firstName ?? "",
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
                        itemCount: widget.controller.nursingHomeList.length,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                             Navigator.of(context).pop(widget.controller.nursingHomeList[i]);
                            },
                            child: Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.nursingHomeList[i].id ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.nursingHomeList[i].nursingHomeName ?? "",
                                size: 14,
                                color: AppColors.blueColorLight,
                                weight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                    ) :
                    widget.listType == kSelectTote ?
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.controller.boxesListData.length,
                        itemBuilder: (context,i){
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).pop(widget.controller.boxesListData[i]);
                            },
                            child: Container(                              
                              width: Get.width,
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: widget.selectedID == widget.controller.boxesListData[i].id ? AppColors.blueColorLight.withOpacity(0.2):AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                        color: Colors.grey.shade300
                                    )
                                  ]),
                              child: BuildText.buildText(
                                text: widget.controller.boxesListData[i].boxName ?? "",
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
        }
    );

  }
}
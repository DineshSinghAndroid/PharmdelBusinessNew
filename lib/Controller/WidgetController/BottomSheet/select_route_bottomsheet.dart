import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../../ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../Button/button.dart';
import '../Toast/ToastCustom.dart';


class SelectRouteBottomSheet extends StatefulWidget{
  DriverDashboardCTRL controller;
  String listType;
  String? selectedID;
  SelectRouteBottomSheet({Key? key,required this.controller,required this.listType, this.selectedID}) : super(key: key);

  @override
  State<SelectRouteBottomSheet> createState() => _SelectRouteBottomSheetState();
}

class _SelectRouteBottomSheetState extends State<SelectRouteBottomSheet> {



  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardCTRL>(
        init: widget.controller,
        builder: (ctrl){
          return Padding(
            padding: EdgeInsets.only(top:getHeightRatio(value: 20)),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor: AppColors.whiteColor,
                appBar: AppBar(
                  title: BuildText.buildText(
                    text:  widget.listType == "route" ? kSelectRoute:kSelectPhar,
                    size: 14,
                    color: AppColors.blueColorLight,
                    weight: FontWeight.w400,
                  ),
                  leading: InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back,color: AppColors.blueColor,),
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
                          itemCount: widget.controller.routeList?.length ?? 0,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ) ;
                          },
                          itemBuilder: (context,i){
                            return InkWell(
                              onTap: (){
                                setState(() {
                                  widget.selectedID = widget.controller.routeList?[i].routeId;
                                });
                              },
                              child: Container(
                                width: Get.width,
                                padding: const EdgeInsets.only(left: 13.0, right: 10.0, top: 12, bottom: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: widget.selectedID == widget.controller.routeList?[i].routeId ? AppColors.blueColorLight.withOpacity(0.05):AppColors.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                          color: Colors.grey.shade300
                                      )
                                    ]),
                                child: BuildText.buildText(
                                  text: widget.controller.routeList?[i].routeName ?? "",
                                  size: 14,
                                  color: AppColors.blueColorLight,
                                  weight: FontWeight.w400,
                                ),
                              ),
                            );
                          }
                      )
                          : widget.listType == "parcel" ?
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.controller.parcelBoxList?.length ?? 0,
                          itemBuilder: (context,i){
                            return InkWell(
                              onTap: (){
                                setState(() {
                                  widget.selectedID = widget.controller.parcelBoxList?[i].id;
                                });
                              },
                              child: Container(
                                width: Get.width,
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
                      )
                          : const SizedBox.shrink(),

                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 15,bottom: 10),
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              flex:1,
                              child: BtnCustom.btnSmall(
                                title: kCancel,
                                titleColor: AppColors.textFieldErrorBorderColor,
                                onPressed: ()=> Get.back(),
                              ),

                            ),
                            Flexible(
                              flex:1,
                              child:
                              BtnCustom.btnSmall(
                                title: kConfirm,
                                titleColor: AppColors.greenColor,
                                onPressed: (){
                                  if(widget.listType == "route" && widget.selectedID != null){
                                    widget.controller.routeList?.forEach((element) {
                                      if(widget.selectedID.toString() == element.routeId){
                                        Navigator.of(context).pop(element);
                                      }
                                    });
                                  }else if(widget.listType == "parcel" && widget.selectedID != null){
                                    widget.controller.parcelBoxList?.forEach((element) {
                                      if(widget.selectedID.toString() == element.id){
                                        Navigator.of(context).pop(element);
                                      }
                                    });
                                  }else{
                                    ToastCustom.showToast(
                                        msg: widget.listType == "route" ? kChooseRouteFirst:kChooseNursingHome
                                    );
                                  }
                                },
                              ),

                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );

  }
}
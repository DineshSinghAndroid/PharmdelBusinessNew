
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../Controller/ProjectController/DeliverySchedule/driver_delivery_schedule_controller.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';


class DriverExemptBottomSheet extends StatefulWidget{
  @override
  State<DriverExemptBottomSheet> createState() => _DriverExemptBottomSheetState();
}

class _DriverExemptBottomSheetState extends State<DriverExemptBottomSheet> {
  DriverDeliveryScheduleController ctrl = Get.find();

  int? selectedIndex;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init()async{
    if(ctrl.selectedExemption != null){
      if(ctrl.drDashCtrl.deliveryMasterData != null && ctrl.drDashCtrl.deliveryMasterData?.exemptions != null && ctrl.drDashCtrl.deliveryMasterData!.exemptions!.isNotEmpty){
        selectedIndex = ctrl.drDashCtrl.deliveryMasterData?.exemptions?.indexWhere((element) => element.id == ctrl.selectedExemption?.id);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<DriverDeliveryScheduleController>(
          init: ctrl,
          builder: (controller){
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  )
              ),
              margin: EdgeInsets.only(top:getHeightRatio(value: 0)),
              child: Scaffold(
                appBar: AppBar(
                  title: BuildText.buildText(
                    text:  kPaymentExemption,
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
                bottomNavigationBar: InkWell(
                  onTap: (){
                    if(selectedIndex != null){
                        Navigator.of(context).pop(ctrl.drDashCtrl.deliveryMasterData?.exemptions?[selectedIndex ?? 0]);
                    }else{
                      ToastCustom.showToast(msg: kFilterToastString);
                    }

                  },
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.yetToStartColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.greyColor,
                            spreadRadius: 1.0,
                            blurRadius: 5.0,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Center(
                        heightFactor: 2.5,
                        child: BuildText.buildText(text: kSelect,color: AppColors.whiteColor)
                    ),
                  ),
                ),
                body: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    physics: const ClampingScrollPhysics(),
                    itemCount: ctrl.drDashCtrl.deliveryMasterData != null && ctrl.drDashCtrl.deliveryMasterData?.exemptions != null ? ctrl.drDashCtrl.deliveryMasterData!.exemptions!.length : 0,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Divider(),
                      ) ;
                    },
                    itemBuilder: (context,i){
                      return InkWell(
                        onTap: ()=>onTap(index: i,controller: controller),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              activeColor: AppColors.themeColor,
                              value: i == selectedIndex,
                              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                              onChanged: (selected)=> onTap(index: i,controller: controller),
                            ),
                            Flexible(
                                child: BuildText.buildText(text: ctrl.drDashCtrl.deliveryMasterData?.exemptions?[i].code ?? "")
                            )
                          ],
                        ),
                      );
                    }
                ),
              ),
            );
          }
      ),
    );
  }

  onTap({required DriverDeliveryScheduleController controller, required int index}){
    setState(() {
      selectedIndex = index;
    });
  }
}
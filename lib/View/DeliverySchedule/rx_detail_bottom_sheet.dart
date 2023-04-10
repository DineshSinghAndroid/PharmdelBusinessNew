import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/Helper/Colors/custom_color.dart';
import '../../Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Controller/ProjectController/DeliverySchedule/driver_delivery_schedule_controller.dart';
import '../../Controller/WidgetController/TextField/CustomTextField.dart';


class RxDetailBottomSheet extends StatefulWidget{
  const RxDetailBottomSheet({Key? key,}) : super(key: key);

  @override
  State<RxDetailBottomSheet> createState() => _RxDetailBottomSheetState();
}

class _RxDetailBottomSheetState extends State<RxDetailBottomSheet> {

  DriverDeliveryScheduleController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDeliveryScheduleController>(
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
            margin: EdgeInsets.only(top:getHeightRatio(value: 20)),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                backgroundColor: AppColors.whiteColor,
                appBar: AppBar(
                  title: BuildText.buildText(
                    text:  kRxDetails,
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

                body: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.rxDetailList.length ?? 0,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ) ;
                    },
                    itemBuilder: (context,i){
                      return RxDetailBottomSheetWidget(
                        medicineName: controller.rxDetailList[i].name ?? "",
                        isCD: controller.rxDetailList[i].isControlDrug,
                        isFridge: controller.rxDetailList[i].isFridge,
                        quantity: controller.rxDetailList[i].quantity ?? "",
                        days: controller.rxDetailList[i].days ?? "",
                        index: i,
                      );
                    }
                ),
              ),
            ),
          );
        }
    );

  }
}


class RxDetailBottomSheetWidget extends StatefulWidget{
  bool isCD;
  bool isFridge;
  String quantity;
  String days;
  String medicineName;
  int index;
  RxDetailBottomSheetWidget({Key? key,required this.index,required this.medicineName,required this.isCD,required this.isFridge,required this.quantity,required this.days}) : super(key: key);
  @override
  State<RxDetailBottomSheetWidget> createState() => _RxDetailBottomSheetWidgetState();
}

class _RxDetailBottomSheetWidgetState extends State<RxDetailBottomSheetWidget> {

  TextEditingController qtyCtrl = TextEditingController();
  TextEditingController daysCtrl = TextEditingController();
  DriverDeliveryScheduleController ctrl = Get.find();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100),(){
      init();
    });

    super.initState();
  }

  @override
  void dispose() {
    qtyCtrl.dispose();
    daysCtrl.dispose();
    super.dispose();
  }

  Future<void>init()async{
    qtyCtrl.text = widget.quantity;
    daysCtrl.text = widget.days;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDeliveryScheduleController>(
      init: ctrl,
      builder: (controller){
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildText.buildText(text: widget.medicineName),
            buildSizeBox(10.0, 0.0),
            Row(
              children: [
                Flexible(
                  child: TextFieldCustom(
                    controller: qtyCtrl,
                    keyboardType: TextInputType.phone,
                    maxLength: 50,
                    radiusField: 10,
                    isCheckOut: true,
                    hintText: kQuantity,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged:(value)=> controller.onChangedQtyRxDetail(index: widget.index,value: value.toString().trim()),
                  ),
                ),
                buildSizeBox(0.0, 10.0),
                Flexible(
                  child: TextFieldCustom(
                    controller: daysCtrl,
                    keyboardType: TextInputType.phone,
                    maxLength: 50,
                    radiusField: 10,
                    isCheckOut: true,
                    hintText: kDays,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged:(value)=> controller.onChangedDaysRxDetail(index: widget.index,value: value.toString().trim()),
                  ),
                ),
                buildSizeBox(0.0, 50.0),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(5.0)),
                  child: InkWell(
                    onTap: ()=> controller.onTapRemoveMedicine(index: widget.index),
                    child: Icon(
                      Icons.delete,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
            buildSizeBox(10.0, 0.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                InkWell(
                  onTap: ()=> controller.onTapCdRxDetail(index: widget.index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          activeColor: AppColors.colorOrange,
                          visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                          value: widget.isCD,
                          onChanged: (newValue) =>controller.onTapCdRxDetail(index: widget.index),
                        ),
                        BuildText.buildText(
                            text: 'C. D.',
                            color: AppColors.whiteColor),
                      ],
                    ),
                  ),
                ),
                buildSizeBox(0.0, 5.0),
                InkWell(
                  onTap: ()=> controller.onTapFridgeRxDetail(index: widget.index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                    decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          activeColor: AppColors.colorOrange,
                          visualDensity: const VisualDensity( horizontal: -4,vertical: -4),
                          value: widget.isFridge,
                          onChanged: (newValue) =>controller.onTapFridgeRxDetail(index: widget.index),
                        ),
                        Padding(
                          padding:const EdgeInsets.only(right: 12.0),
                          child: Image.asset(
                            strIMG_Fridge,
                            height: 21,
                            color: AppColors.whiteColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            buildSizeBox(8.0, 0.0),
            Divider(color: AppColors.greyColor),
          ],
        );
      },
    );
  }
}
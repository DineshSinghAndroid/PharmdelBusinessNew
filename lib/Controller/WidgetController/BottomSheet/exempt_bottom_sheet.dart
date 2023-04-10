import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../Helper/Colors/custom_color.dart';
import '../../Helper/TextController/BuildText/BuildText.dart';
import '../../ProjectController/OrderDetails/order_detail_controller.dart';
import '../Toast/ToastCustom.dart';



class ExemptBottomSheet extends StatefulWidget{
  OrderDetailController controller;
  OrderDetailResponse orderDetail;
  ExemptBottomSheet({Key? key,required this.controller,required this.orderDetail}) : super(key: key);

  @override
  State<ExemptBottomSheet> createState() => _ExemptBottomSheetState();
}

class _ExemptBottomSheetState extends State<ExemptBottomSheet> {

  Exemptions? selectedExemptions;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100),(){
      if(widget.controller.selectedExemptions != null){
        selectedExemptions = widget.controller.selectedExemptions;
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(
        init: widget.controller,
        builder: (ctrl){
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
                title: BuildText.buildText(
                    text: kPaymentExemption,size: 20,weight: FontWeight.bold
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 70,
                        height: 50,
                        color: Colors.transparent,

                        child: const Icon(Icons.close,size: 30,color: Colors.black)
                    ),
                  ),
                ],
                backgroundColor: AppColors.whiteColor,
                elevation: 5,
                leadingWidth: 5,
                centerTitle: false,
              ),
              bottomNavigationBar: InkWell(
                onTap: () {
                  if(selectedExemptions != null) {
                    Navigator.of(context).pop(selectedExemptions);
                  }else{
                    ToastCustom.showToast(msg: kSelectExemptions);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(color: AppColors.yetToStartColor, boxShadow: [
                    BoxShadow(
                      color: AppColors.greyColor,
                      spreadRadius: 1.0,
                      blurRadius: 5.0,
                      offset: const Offset(0, 3),
                    )
                  ]),
                  child: Center(
                      heightFactor: 2.5,
                      child: BuildText.buildText(text: kSelect,size: 18,color: AppColors.whiteColor)
                  ),
                ),
              ),
              body:  ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.greyColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                physics: const ClampingScrollPhysics(),
                itemCount: widget.orderDetail.exemptions.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedExemptions = widget.orderDetail.exemptions[index];
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedExemptions?.id == widget.orderDetail.exemptions[index].id,
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          onChanged: (values) {
                            setState(() {
                              selectedExemptions = widget.orderDetail.exemptions[index];
                            });
                          },
                        ),
                        Flexible(
                            child: BuildText.buildText(
                                text: "${widget.orderDetail.exemptions[index].serialId != null && widget.orderDetail.exemptions[index].serialId!.isNotEmpty ? "${widget.orderDetail.exemptions[index].serialId!} - " : ''}${widget.orderDetail.exemptions[index].code != null && widget.orderDetail.exemptions[index].code!.isNotEmpty ? widget.orderDetail.exemptions[index].code : ''}"
                            )
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }
    );

  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/Helper/Colors/custom_color.dart';
import '../../Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../Controller/ProjectController/BulkDrop/bulk_drop_controller.dart';



class BulkDropBottomSheet extends StatefulWidget{
  BulkDropController controller;
  BulkDropBottomSheet({Key? key,required this.controller}) : super(key: key);

  @override
  State<BulkDropBottomSheet> createState() => _BulkDropBottomSheetState();
}

class _BulkDropBottomSheetState extends State<BulkDropBottomSheet> {



  @override
  Widget build(BuildContext context) {
    return GetBuilder<BulkDropController>(
        init: widget.controller,
        builder: (controller){
          return Padding(
            padding: EdgeInsets.only(top:getHeightRatio(value: 20)),
            child: SingleChildScrollView(
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: AppColors.transparentColor,
                  child: Container(
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppColors.blackColor)),
                                color: AppColors.materialAppThemeColor,
                              ),
                              child: BuildText.buildText(text: kDelivery,size: 20,weight: FontWeight.bold)
                            ),

                            buildSizeBox(10.0, 0.0),

                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Card(
                                  color: AppColors.deepOrangeColor.withOpacity(0.2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child:
                                    TextField(
                                      controller: controller.toController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      style: const TextStyle(decoration: TextDecoration.none),
                                      decoration: const InputDecoration(
                                        labelText: kDeliveredTo,
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child:  Card(
                                  color: AppColors.greenColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    child:  TextField(
                                      controller: controller.remarkController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      autofocus: false,
                                      decoration: const InputDecoration(
                                        labelText: kDeliveredRemark,
                                      ),
                                    ),
                                  )),
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right: 15.0, top: 5, bottom: 10),
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                            onChanged: (checked) {
                                              setState(() {
                                                controller.isDeliveryNote = checked ?? false;
                                              });
                                            },
                                            value: controller.isDeliveryNote,
                                            checkColor: Colors.white,
                                            activeColor: Colors.orange,
                                          ),
                                          buildSizeBox(0.0, 2.0),

                                          Flexible(
                                            child: BuildText.buildText(
                                                text: kReadAllControlledDrug,size: 12
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                        elevation: 2.0,
                                        backgroundColor: Colors.grey,
                                      ),
                                      onPressed: (){
                                        Navigator.of(context).pop(kSkip);
                                      },
                                      child: BuildText.buildText(
                                          text: kSkip,size: 16,color: AppColors.whiteColor,weight: FontWeight.w700
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                        elevation: 2.0,
                                        backgroundColor: Colors.blue,
                                      ),
                                        onPressed: (){
                                          Navigator.of(context).pop(kContinue);
                                        },
                                      child: BuildText.buildText(
                                          text: kContinue,size: 16,color: AppColors.whiteColor,weight: FontWeight.w700
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buildSizeBox(5.0, 0.0),

                          ],
                        ),
                      )),
                ),
              ),
            ),
          );
        }
    );

  }
}
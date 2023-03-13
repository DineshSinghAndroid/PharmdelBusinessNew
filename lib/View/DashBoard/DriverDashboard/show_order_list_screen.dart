import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import '../../../Controller/Helper/Colors/custom_color.dart';
import '../../../Controller/ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import '../../../Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';

class ShowOrderListScreen extends StatefulWidget{
  @override
  State<ShowOrderListScreen> createState() => _ShowOrderListScreenState();
}

class _ShowOrderListScreenState extends State<ShowOrderListScreen> {

  DriverDashboardCTRL drDashCtrl = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverDashboardCTRL>(
      init: drDashCtrl,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async => false,
          child: LoadScreen(
            widget: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 5,
                      padding: const EdgeInsets.all(10.00),
                      color: AppColors.materialAppThemeColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          BuildText.buildText(text: kOrdersList,size: 16,weight: FontWeight.bold),

                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.clear_rounded,color: AppColors.blackColor)
                          )
                        ],
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //         value: allSelected,
                    //         onChanged: (value) {
                    //           allSelected = value;
                    //           for (int i = 0; i < modelList.length; i++) {
                    //             checkboxIndex = 0;
                    //             modelList[i].isSelected = value;
                    //           }
                    //           setState(() {});
                    //         }),
                    //     Flexible(
                    //       child: BuildText.buildText(text: kSelectAll,size: 12,color: AppColors.blueColor),
                    //     )
                    //   ],
                    // ),
                    // Container(
                    //   color: AppColors.whiteColor,
                    //   height: Get.height - 250,
                    //   child: ListView.builder(
                    //     // physics: NeverScrollableScrollPhysics(),
                    //       itemCount: modelList.length,
                    //       itemBuilder: (context, index) {
                    //         return Card(
                    //           margin: EdgeInsets.only(
                    //             bottom: modelList.length - 1 == index ? 70.0 : 8.0,
                    //           ),
                    //           child: Stack(
                    //             children: [
                    //               Row(
                    //                 children: <Widget>[
                    //                   Flexible(
                    //                     fit: FlexFit.tight,
                    //                     child: Container(
                    //                       padding: EdgeInsets.all(10),
                    //                       child: Column(
                    //                         children: <Widget>[
                    //                           Row(
                    //                             crossAxisAlignment: CrossAxisAlignment.start,
                    //                             mainAxisAlignment: MainAxisAlignment.start,
                    //                             children: <Widget>[
                    //                               /*Text("Name", style: TextStyle(
                    //                                               color: Colors.grey,
                    //                                               fontSize: 14
                    //                                           ),),
                    //                                           SizedBox(width: 5, height: 0,),*/
                    //                               SizedBox(
                    //                                 height: 24,
                    //                                 width: 24,
                    //                                 child: Checkbox(
                    //                                     value: modelList[index].isSelected,
                    //                                     onChanged: (value) {
                    //                                       logger.i(value);
                    //                                       modelList[index].isSelected = value;
                    //
                    //                                       checkboxIndex = index;
                    //
                    //                                       allSelected = true;
                    //                                       for (int i = 0; i < modelList.length; i++) {
                    //                                         if (modelList[i].isSelected == false) {
                    //                                           allSelected = false;
                    //                                         }
                    //                                         setState(() {});
                    //                                       }
                    //                                     }),
                    //                               ),
                    //                               Flexible(
                    //                                 child: Text(
                    //                                   "${modelList[index].fullName ?? ""}",
                    //                                   maxLines: 2,
                    //                                   style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w700),
                    //                                 ),
                    //                               ),
                    //                               if (modelList[index].nursing_home_id == null || modelList[index].nursing_home_id == 0)
                    //                                 if (modelList[index].pmr_type != null &&
                    //                                     (modelList[index].pmr_type == "titan" || modelList[index].pmr_type == "nursing_box") &&
                    //                                     modelList[index].pr_id != null &&
                    //                                     modelList[index].pr_id.isNotEmpty)
                    //                                   Text(
                    //                                     '(P/N : ${modelList[index].pr_id ?? ""}) ',
                    //                                     style: TextStyle(color: CustomColors.pnColor),
                    //                                   ),
                    //                               if (modelList[index].isCronCreated == "t") Image.asset("assets/automatic_icon.png", height: 14, width: 14),
                    //                             ],
                    //                           ),
                    //                           SizedBox(
                    //                             width: 5,
                    //                             height: 5,
                    //                           ),
                    //                           Row(
                    //                             children: <Widget>[
                    //                               Image.asset("assets/home_icon.png", height: 18, width: 18, color: CustomColors.yetToStartColor),
                    //                               SizedBox(
                    //                                 width: 5,
                    //                                 height: 0,
                    //                               ),
                    //                               Flexible(
                    //                                 child: Text(
                    //                                   "${modelList[index].fullAddress ?? modelList[index].fullAddress ?? ""}",
                    //                                   style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w300),
                    //                                   overflow: TextOverflow.ellipsis,
                    //                                   maxLines: 1,
                    //                                 ),
                    //                               ),
                    //                               SizedBox(
                    //                                 width: 5,
                    //                                 height: 0,
                    //                               ),
                    //                               // if (modelList[index].c.customerAddress.alt_address ==
                    //                               //     "t")
                    //                               //   Image.asset(
                    //                               //     "assets/alt-add.png",
                    //                               //     height: 18,
                    //                               //     width: 18,
                    //                               //   ),
                    //                             ],
                    //                           ),
                    //                           SizedBox(
                    //                             height: 5.0,
                    //                           ),
                    //                           modelList[index].deliveryNotes != null && modelList[index].deliveryNotes != ""
                    //                               ? Row(
                    //                             crossAxisAlignment: CrossAxisAlignment.start,
                    //                             children: [
                    //                               Text(
                    //                                 'Delivery Note:   ',
                    //                                 style: TextStyle(fontSize: 14, color: CustomColors.yetToStartColor),
                    //                               ),
                    //                               Flexible(child: Text(modelList[index].deliveryNotes ?? "")),
                    //                             ],
                    //                           )
                    //                               : SizedBox(),
                    //                           SizedBox(
                    //                             height: 5.0,
                    //                           ),
                    //                           Container(
                    //                             child: Row(
                    //                               children: [
                    //                                 modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false
                    //                                     ? Container(
                    //                                   decoration: BoxDecoration(
                    //                                     borderRadius: BorderRadius.circular(5.0),
                    //                                     color: CustomColors.drugColor,
                    //                                     // border: Border.all(color: Colors.blue)
                    //                                   ),
                    //                                   child: Padding(
                    //                                     padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                    //                                     child: Text(
                    //                                       "C.D.",
                    //                                       style: TextStyle(fontSize: 10, color: Colors.white),
                    //                                     ),
                    //                                   ),
                    //                                 )
                    //                                     : Container(),
                    //                                 if (modelList[index].isControlledDrugs != null && modelList[index].isControlledDrugs != false)
                    //                                   SizedBox(
                    //                                     width: 10.0,
                    //                                   ),
                    //                                 modelList[index].isStorageFridge != null && modelList[index].isStorageFridge != false
                    //                                     ? Container(
                    //                                   decoration: BoxDecoration(
                    //                                     borderRadius: BorderRadius.circular(5.0),
                    //                                     color: CustomColors.fridgeColor,
                    //                                     // border: Border.all(color: Colors.blue)
                    //                                   ),
                    //                                   child: Padding(
                    //                                     padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                    //                                     child: Text(
                    //                                       "Fridge",
                    //                                       style: TextStyle(fontSize: 10, color: Colors.white),
                    //                                     ),
                    //                                   ),
                    //                                 )
                    //                                     : Container(),
                    //                                 SizedBox(
                    //                                   width: 10,
                    //                                 ),
                    //                                 if (modelList[index].pharmacyName != null && modelList[index].pharmacyName != "" && driverType == Constants.sharedDriver)
                    //                                   Flexible(
                    //                                     flex: 5,
                    //                                     child: Container(
                    //                                         decoration: BoxDecoration(
                    //                                             borderRadius: BorderRadius.all(Radius.circular(5)),
                    //                                             color: Colors.orange,
                    //                                             boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 10, offset: Offset(0, 4), color: Colors.grey[300])]),
                    //                                         padding: EdgeInsets.only(left: 10, right: 10, bottom: 2),
                    //                                         child: Text(
                    //                                           modelList[index].pharmacyName ?? "",
                    //                                           maxLines: 1,
                    //                                           style: TextStyle(color: Colors.white),
                    //                                         )),
                    //                                   ),
                    //                                 if (modelList != null && modelList.isNotEmpty && modelList[index].parcelName != null && modelList[index].parcelName != "")
                    //                                   Padding(
                    //                                     padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
                    //                                     child: Row(
                    //                                       mainAxisAlignment: MainAxisAlignment.start,
                    //                                       children: [
                    //                                         Container(
                    //                                           decoration: BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(5.0)),
                    //                                           child: Padding(
                    //                                             padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 2.0, bottom: 2.0),
                    //                                             child: Text(
                    //                                               "${modelList[index].parcelName}",
                    //                                               style: TextStyle(
                    //                                                 color: CustomColors.pickedUp,
                    //                                                 fontSize: 10,
                    //                                               ),
                    //                                             ),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           SizedBox(
                    //                             height: 5.0,
                    //                           ),
                    //                           Row(
                    //                             children: [
                    //                               if (deliveryChargeController[index].text != null &&
                    //                                   deliveryChargeController[index].text.isNotEmpty &&
                    //                                   deliveryChargeController[index].text != '0.0' &&
                    //                                   deliveryChargeController[index].text != '0')
                    //                                 Flexible(
                    //                                   flex: 1,
                    //                                   child: Padding(
                    //                                     padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                    //                                     child: Container(
                    //                                       height: 40,
                    //                                       child: new TextField(
                    //                                         controller: deliveryChargeController[index],
                    //                                         textInputAction: TextInputAction.next,
                    //                                         readOnly: true,
                    //                                         keyboardType: TextInputType.number,
                    //                                         style: TextStyle(color: Colors.blue),
                    //                                         autofocus: false,
                    //                                         inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
                    //                                         onChanged: (val) {
                    //                                           modelList[index].totalAmount = calculateAmount(setState, index);
                    //                                         },
                    //                                         decoration: new InputDecoration(
                    //                                           labelText: "Delivery Charge",
                    //                                           fillColor: Colors.white,
                    //                                           labelStyle: TextStyle(color: Colors.blue, fontSize: 14),
                    //                                           filled: true,
                    //                                           contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                    //                                           border: new OutlineInputBorder(
                    //                                             borderRadius: BorderRadius.circular(50.0),
                    //                                             borderSide: BorderSide(color: Colors.blue),
                    //                                           ),
                    //                                           focusedBorder: OutlineInputBorder(
                    //                                             borderRadius: BorderRadius.circular(50.0),
                    //                                             borderSide: BorderSide(color: Colors.blue),
                    //                                           ),
                    //                                           enabledBorder: OutlineInputBorder(
                    //                                             borderRadius: BorderRadius.circular(50.0),
                    //                                             borderSide: BorderSide(color: Colors.blue),
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               if (preChargeController[index].text != null &&
                    //                                   preChargeController[index].text.isNotEmpty &&
                    //                                   preChargeController[index].text != '0.00')
                    //                                 Flexible(
                    //                                   flex: 1,
                    //                                   child: Padding(
                    //                                     padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
                    //                                     child: Container(
                    //                                       height: 40,
                    //                                       child: new TextField(
                    //                                         controller: preChargeController[index],
                    //                                         readOnly: true,
                    //                                         textInputAction: TextInputAction.next,
                    //                                         keyboardType: TextInputType.number,
                    //                                         style: TextStyle(color: Colors.green, fontSize: 14),
                    //                                         autofocus: false,
                    //                                         inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))],
                    //                                         onChanged: (v) {
                    //                                           modelList[index].totalAmount = calculateAmount(
                    //                                             setState,
                    //                                             index,
                    //                                           );
                    //                                         },
                    //                                         decoration: new InputDecoration(
                    //                                           labelText: "Rx Charge",
                    //                                           labelStyle: TextStyle(color: Colors.green),
                    //                                           fillColor: Colors.white,
                    //                                           filled: true,
                    //                                           contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                    //                                           border: new OutlineInputBorder(
                    //                                             borderRadius: BorderRadius.circular(50.0),
                    //                                             borderSide: BorderSide(color: Colors.green),
                    //                                           ),
                    //                                           focusedBorder: OutlineInputBorder(
                    //                                             borderRadius: BorderRadius.circular(50.0),
                    //                                             borderSide: BorderSide(color: Colors.green),
                    //                                           ),
                    //                                           enabledBorder: OutlineInputBorder(
                    //                                             borderRadius: BorderRadius.circular(50.0),
                    //                                             borderSide: BorderSide(color: Colors.green),
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               SizedBox(
                    //                                 width: 10.0,
                    //                               ),
                    //                               // Column(
                    //                               //   crossAxisAlignment: CrossAxisAlignment.start,
                    //                               //   children: [
                    //                               //     Text("Amount",style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500),),
                    //                               //     Text("£ ${modelList[index].totalAmount}",style: TextStyle(fontSize: 15.0,),)
                    //                               //   ],
                    //                               // ),
                    //                             ],
                    //                           ),
                    //                           // SizedBox(
                    //                           //   height: 5.0,
                    //                           // ),
                    //                           //
                    //                           // Row(
                    //                           //   children: [
                    //                           //     if(modelList[index].paymentStatus != null && modelList[index].paymentStatus.isNotEmpty && modelList[index].paymentStatus != "unPaid")
                    //                           //       Container(
                    //                           //         height: 30,
                    //                           //         padding: EdgeInsets.only(right: 10, left: 10),
                    //                           //         decoration: BoxDecoration(
                    //                           //           borderRadius: BorderRadius.circular(50.0),
                    //                           //           color: Colors.orange,
                    //                           //         ),
                    //                           //         child: Row(
                    //                           //           children: [
                    //                           //             new Text(
                    //                           //               "${modelList[index].paymentStatus ?? ""}",
                    //                           //               style: TextStyle(color: Colors.white),
                    //                           //             ),
                    //                           //           ],
                    //                           //         ),
                    //                           //       ),
                    //                           //     SizedBox(
                    //                           //       width: 5.0,
                    //                           //     ),
                    //                           //       Row(
                    //                           //         children: [
                    //                           //           if(modelList[index].exemption != null && modelList[index].exemption.isNotEmpty)
                    //                           //           Container(
                    //                           //             height: 30,
                    //                           //             padding: EdgeInsets.only(right: 10, left: 10),
                    //                           //             decoration: BoxDecoration(
                    //                           //               borderRadius: BorderRadius.circular(50.0),
                    //                           //               color: Colors.green,
                    //                           //             ),
                    //                           //             child: Row(
                    //                           //               children: [
                    //                           //                 new Text(
                    //                           //                   "Exempt: ${modelList[index].exemption ?? ""}",
                    //                           //                   style: TextStyle(color: Colors.white),
                    //                           //                 ),
                    //                           //               ],
                    //                           //             ),
                    //                           //           ),
                    //                           //           SizedBox(
                    //                           //             width: 5.0,
                    //                           //           ),
                    //                           //           if(modelList[index].bagSize != null && modelList[index].bagSize.isNotEmpty)
                    //                           //             Align(
                    //                           //               alignment: Alignment.centerLeft,
                    //                           //               child: Container(
                    //                           //                 height: 30,
                    //                           //                 width: 100,
                    //                           //                 padding: EdgeInsets.only(right: 5,left: 5),
                    //                           //                 decoration: BoxDecoration(
                    //                           //                   borderRadius: BorderRadius.circular(50.0),
                    //                           //                   color: Colors.green,
                    //                           //                 ),
                    //                           //                 child: Row(
                    //                           //                   children: [
                    //                           //                     new Text(
                    //                           //                       "Bag Size : ${modelList[index].bagSize}",
                    //                           //                       style: TextStyle(color: Colors.white),
                    //                           //                     ),
                    //                           //                   ],
                    //                           //                 ),
                    //                           //               ),
                    //                           //             ),
                    //                           //         ],
                    //                           //       ),
                    //                           //   ],
                    //                           // ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       }),
                    // ),
                    // SizedBox(
                    //   height: 40,
                    //   width: MediaQuery.of(context).size.width - 40,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)), elevation: 2.0),
                    //     onPressed: () {
                    //       dynamic totalSelectedRxCharge = 0;
                    //       dynamic deliveryCharge = 0;
                    //       int subsId = 0;
                    //       modelList.forEach((element) {
                    //         if (element.isSelected == true) {
                    //           deliveryCharge = element.delCharge ?? 0;
                    //           logger.i('Print RXCharge Value: ${element.rxInvoice}');
                    //           totalSelectedRxCharge =
                    //               int.tryParse(totalSelectedRxCharge.toString() ?? "0") + int.tryParse(element.rxInvoice != null ? element.rxInvoice.toString() : "0");
                    //           subsId = element.subsId;
                    //           // if(element.isControlledDrugs){
                    //           //   checkIsCd = true;
                    //           // }else{
                    //           //
                    //           // }
                    //         }
                    //       });
                    //
                    //       logger.i('Print Total RXCharge Value: ${totalSelectedRxCharge}');
                    //
                    //       int count = modelList.where((elements) => elements.isSelected == true).toList().length;
                    //       if (count > 0) {
                    //         isCheckCdOnComplete = modelList.any((element) => element.isControlledDrugs == true && element.isSelected == true);
                    //         isCheckFridgeOnComplete = modelList.any((element) => element.isStorageFridge == true && element.isSelected == true);
                    //         isCheckDeliveryNote = modelList.any((element) => element.deliveryNotes != '' && element.isSelected == true);
                    //
                    //         //puran sir new conditions
                    //         if (isCheckCdOnComplete) {
                    //           modal.isControlledDrugs = true;
                    //         } else {
                    //           modal.isControlledDrugs = false;
                    //         }
                    //         if (isCheckFridgeOnComplete) {
                    //           modal.isStorageFridge = true;
                    //         } else {
                    //           modal.isStorageFridge = false;
                    //         }
                    //         if (isCheckDeliveryNote) {
                    //           modal.deliveryNote = true;
                    //         } else {
                    //           modal.deliveryNote = false;
                    //         }
                    //         logger.w("Is check delivery note is :: $isCheckDeliveryNote :: and delivery note is :: ${modal.deliveryNote.toString()}");
                    //         Navigator.of(context).pop();
                    //         logger.i('Delivery111');
                    //         redirectToDetailsPage(modal, modelList[checkboxIndex].orderId, totalSelectedRxCharge, deliveryCharge, subsId); //modelList[checkboxIndex].rxInvoice);
                    //       } else {
                    //         Fluttertoast.showToast(msg: "Select minimum 1 order");
                    //       }
                    //     },
                    //     child: new Text(
                    //       "Complete",
                    //       style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            isLoading: controller.isLoading,
          ),
        );
      },
    );
  }

}
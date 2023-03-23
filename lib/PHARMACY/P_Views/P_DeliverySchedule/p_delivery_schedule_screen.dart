import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Controller/PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';
import '../../../Controller/WidgetController/AdditionalWidget/DeliveryScheduleWidget/deliveryScheduleWidget.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';

class PharmacyDeliverySchedule extends StatefulWidget {
  String? customerName;
  String? dob;
  String? nhs;
  String? address;
  String? contact;
  String? email;
   PharmacyDeliverySchedule({super.key, 
    required this.customerName,
    required this.dob,
    required this.nhs,
    required this.address,
    required this.contact,
    required this.email,
  });

  @override
  State<PharmacyDeliverySchedule> createState() => _PharmacyDeliveryScheduleState();
}

class _PharmacyDeliveryScheduleState extends State<PharmacyDeliverySchedule> {

  DeliveryScheduleController delSchdCtrl = Get.put(DeliveryScheduleController());
  NursingHomeController nurHomeCtrl = Get.put(NursingHomeController());
  TextEditingController existingNoteController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {  
    await delSchdCtrl.deliveryScheduleApi(context: context,pharmacyId: '0');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryScheduleController>(
      init: delSchdCtrl,
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
              appBar: AppBar(
          title: BuildText.buildText(text: kDelSchd,size: 18),
          backgroundColor: AppColors.whiteColor,
          leading: InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back,color: AppColors.blackColor,)),
              ),
              body: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
               child: SingleChildScrollView(
                 child: SizedBox(
                  height: Get.height,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                               
                    ///Cusotmer Details
                    BuildText.buildText(
                    text: widget.customerName ?? ""),
                    BuildText.buildText(
                    text: "$kDateOfBirth" "${widget.dob}"),
                    BuildText.buildText(
                    text: "$kNHS" "${widget.nhs}"),
                    BuildText.buildText(
                    text: "Address : ${widget.address}"),
                    BuildText.buildText(
                    text: "$kContact" "${widget.contact}"),
                    BuildText.buildText(
                    text: "$kEmailId" "${widget.email}"),
                    Divider(color: AppColors.greyColorDark,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          /// Meds
                          DeliveryScheduleWidgets.customWidget(
                            onTap: (){},
                            title: kMeds,
                            bgColor: AppColors.blueColor,
                          ),
                          buildSizeBox(0.0, 10.0),
                               
                          /// Rx Image
                          DeliveryScheduleWidgets.customWidget(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                                builder: (context) {
                                  return BottomSheetCustom.selectMediaBottomsheet(
                                    onTapGallery: (){                                  
                                      Navigator.of(context).pop(controller.onTapGallery(context: context));
                                    },
                                    onTapCamera: (){
                                      controller.onTapCamera(context: context);
                                    }
                                    );
                                },);
                            },
                            title: kRxImage,
                            bgColor: AppColors.colorOrange
                          ),
                          buildSizeBox(0.0, 10.0),
                                
                          /// Rx Details
                          DeliveryScheduleWidgets.customWidget(
                            onTap: (){},
                            title: kRxDetails,
                            bgColor: AppColors.greenColor,
                            titleColor: AppColors.whiteColor
                          ),
                        ],
                      ),
                    ),
                                
                    ///Rx Image View
                    // SizedBox(                  
                    //   height: controller.imgPickerController.images.isNotEmpty ? 70 : 0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       SizedBox(
                    //         width: Get.width - 45,
                    //         child: ListView.builder(
                    //           itemCount: controller.imgPickerController.images.length,
                    //           scrollDirection: Axis.horizontal,
                    //           shrinkWrap: true,
                    //           itemBuilder: (context, index) {
                    //             return Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Container(
                    //                   height: 50,
                    //                   width: 50,
                    //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: AppColors.greyColor)),
                    //                   child: ClipRRect(
                    //                     borderRadius: BorderRadius.circular(5.0),
                    //                     child: Image.file(
                    //                       File(controller.imgPickerController.images[index].path),
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                 )
                    //               ],
                    //             );
                    //           },
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Divider(color: AppColors.greyColorDark,),
                               
                    /// Select Service
                    Flexible(
                      child: WidgetCustom.selectDeliveryScheduleWidget(
                      title: controller.selectedService != null ? controller.selectedService?.name.toString() ?? "" : kSelService,
                      onTap:()async{
                        controller.onTapSelectService(context: context, controller: controller);
                      },),
                    ),
                             
                    /// Select bag Size
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          BuildText.buildText(text: kBagSize,color: AppColors.greenColor),
                          buildSizeBox(0.0, 3.0),
                          Icon(Icons.shopping_bag_outlined,color: AppColors.greenColor,size: 20,),
                          buildSizeBox(0.0, 3.0),
                          BuildText.buildText(text: ':',color: AppColors.greenColor),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.bagSizeList.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    value: index,
                                    groupValue: controller.bagId,
                                    activeColor: AppColors.colorOrange,
                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    onChanged: (int? val) {
                                      setState(() {
                                        controller.bagId = val!;
                                      });
                                    },
                                  ),
                                  controller.bagSizeList[index] != "C" ?
                                  BuildText.buildText(
                                     text: controller.bagSizeList[index])
                                    : Icon(Icons.shopping_bag_outlined,size: 20,color: AppColors.greenColor,),
                                  buildSizeBox(0.0, 8.0)
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                                
                    Row(
                      children: [              
                      ///Select Date And Time
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                                builder: (context, child) {
                                  return Theme(
                                  data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                  primary: AppColors.colorOrange, 
                                  onPrimary: AppColors.whiteColor, 
                                  onSurface: AppColors.blackColor,
                                )),
                                child: child!,
                                  );
                                },
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day),
                                lastDate: DateTime(2101));
                            if (picked != null) {
                              setState(() {
                                controller.selectedDate = controller.formatter.format(picked);
                                controller.showDatedDate = controller.formatterShow.format(picked);
                              });
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: AppColors.greyColor),
                              color: AppColors.whiteColor,
                            ),
                            child: Row(
                              children: [                                                   
                                Icon(Icons.calendar_month_outlined,color: AppColors.greyColor,),
                                buildSizeBox(0.0, 15.0),
                                BuildText.buildText(text: controller.showDatedDate),
                              ],
                            ),
                          ),
                        ),
                      ),
                      buildSizeBox(0.0, 15.0),
                               
                      ///Select Route
                      Flexible(
                      child: WidgetCustom.selectDeliveryScheduleWidget(
                      title: controller.getRouteListController.selectedroute != null ? controller.getRouteListController.selectedroute?.routeName.toString() ?? "" : kSelectRoute,
                      onTap:()async{
                        controller.onTapSelectedRoute(context: context, controller: nurHomeCtrl);
                      },),),
                      ],
                    ),
                    Row(
                      children: [              
                      /// Select Driver
                      controller.getDriverListController.driverList.isNotEmpty ?
                      Flexible(
                      child: WidgetCustom.selectDeliveryScheduleWidget(
                      title: controller.getDriverListController.selectedDriver != null ? controller.getDriverListController.selectedDriver?.firstName.toString() ?? "" : kSelectDriver,
                      onTap:()async{
                        controller.onTapSelectedDriver(context: context, controller: nurHomeCtrl);
                      },),) : const SizedBox.shrink(),
                      controller.getDriverListController.driverList.isNotEmpty ? buildSizeBox(0.0, 15.0) : const SizedBox.shrink(),
                               
                      /// Select Status
                      Flexible(
                      child: WidgetCustom.selectDeliveryScheduleWidget(
                      title: 'Received',
                      onTap:()async{
                        controller.onTapSelectedDriver(context: context, controller: controller);
                      },),),
                      ],
                    ),
                    buildSizeBox(10.0, 0.0),
                               
                     /// Select Nursing Home
                     Flexible(
                      child: WidgetCustom.selectDeliveryScheduleWidget(
                      title: controller.selectedNursingHome != null ? controller.selectedNursingHome?.nursingHomeName.toString() ?? "" : kSelectNursHome,
                      onTap:()async{
                        controller.onTapSelectNursingHome(context: context, controller: controller);
                      },),),
                      buildSizeBox(10.0, 0.0),
                               
                      /// Select Delivery Charge
                      Row(
                        children: [
                          Flexible(
                          child: WidgetCustom.selectDeliveryScheduleWidget(
                          title: controller.selectedDeliveryCharge != null ? controller.selectedDeliveryCharge?.name.toString() ?? "" : kSelDelCharge,
                          onTap:()async{
                            controller.onTapSeletedDeliveryCharge(context: context, controller: controller);
                          },),),
                          controller.selectedDeliveryCharge?.name != null && controller.selectedDeliveryCharge?.name == "Per Delivery" ? 
                          buildSizeBox(0.0, 15.0) : const SizedBox.shrink(),
                                
                        /// Delivery Charge
                        controller.selectedDeliveryCharge?.name != null && controller.selectedDeliveryCharge?.name == "Per Delivery" ?
                        Flexible(                    
                        child: TextFormField(
                          readOnly: true,
                          controller: deliveryChargeController,
                          minLines: 1,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            hintText: kDeliveryCharge,
                            hintStyle: TextStyle(color: AppColors.blackColor,fontSize: 14),
                            filled: true,
                            fillColor: AppColors.whiteColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                            ),
                          )),
                          ) : const SizedBox.shrink(),
                        ],
                      ),                 
                      buildSizeBox(10.0, 0.0),
                               
                      Row(
                        children: [
                        /// Select Fridge
                        DeliveryScheduleWidgets.customWidgetwithCheckbox(
                        bgColor: AppColors.blueColor, 
                        title: 'C.D.', 
                        checkBoxValue: controller.fridgeSelected,
                        onChanged: (value) {
                          setState(() {
                            controller.fridgeSelected = !controller.fridgeSelected;
                          });
                        },),
                        buildSizeBox(0.0, 5.0),
                                
                        /// Select C.D.
                        DeliveryScheduleWidgets.customWidgetwithCheckbox(
                        bgColor: AppColors.redColor, 
                        title: 'C.D.', 
                        checkBoxValue: controller.controlDrugSelected,
                        onChanged: (value) {
                          setState(() {
                            controller.controlDrugSelected = !controller.controlDrugSelected;
                          });
                        }),
                        buildSizeBox(0.0, 5.0),
                                
                        /// Select Paid
                        DeliveryScheduleWidgets.customWidgetwithCheckbox(
                        bgColor: AppColors.colorOrange, 
                        title: 'Paid',
                        checkBoxValue: false,
                        onChanged: (value) {}),
                        buildSizeBox(0.0, 5.0),
                                
                        /// Select Exempt
                        DeliveryScheduleWidgets.customWidgetwithCheckbox(
                        onTap: (){                   
                          controller.onTapExempt(context: context, controller: controller);
                        },
                        bgColor: AppColors.greenColor, 
                        title: 'Exempt',
                        checkBoxValue: controller.exemptSelected,
                        onChanged: (value) {
                          
                        }),
                        buildSizeBox(0.0, 5.0),
                        ],
                      ),
                      buildSizeBox(10.0, 0.0),
                      /// Existing Delivery Note
                      BuildText.buildText(text: kExistingDelNote,color: AppColors.bluearrowcolor.withOpacity(0.7)),
                      buildSizeBox(5.0, 0.0),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                         alignment: Alignment.centerLeft,
                         decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: AppColors.greyColor)),
                        child: BuildText.buildText(text: kExistingDelNote),
                      ),
                      buildSizeBox(10.0, 0.0),
                               
                      /// Delivery Note
                      BuildText.buildText(text: kDeliveryNote,color: AppColors.bluearrowcolor.withOpacity(0.7)),
                      buildSizeBox(5.0, 0.0),                  
                      TextFormField(
                        controller: existingNoteController,
                        minLines: 1,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          hintText: kDeliveryNote,
                          hintStyle: TextStyle(color: AppColors.greyColor),
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: AppColors.greyColor, width: 1),
                          ),
                        )),                        
                            ],
                          ),
                 ),
               ),
              ),

              /// Book Delivery Button
              bottomNavigationBar: InkWell(
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.blueColorLight,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: BuildText.buildText(text: kBookDelivery,color: AppColors.whiteColor,size: 15,weight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        );
      },
    );
    }
}
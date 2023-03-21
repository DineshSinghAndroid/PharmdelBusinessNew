import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Controller/PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';
import '../../../Controller/WidgetController/AdditionalWidget/DeliveryScheduleWidget/deliveryScheduleWidget.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../../Controller/WidgetController/AdditionalWidget/RadioTileCustom/radioTileCustom.dart';
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
  TextEditingController existingNoteController = TextEditingController();

  String selectedDate = "";
  String showDatedDate = "";

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

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
                                onTapGallery: (){}, 
                                onTapCamera: (){}
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
                Divider(color: AppColors.greyColorDark,),
              
                /// Select Service
                Flexible(
                  child: WidgetCustom.selectDeliveryScheduleWidget(
                  title: controller.selectedService != null ? controller.selectedService?.name.toString() ?? "" : kSelService,
                  onTap:()async{
                    controller.onTapSelectService(context: context, controller: controller);
                  },),
                ),
                buildSizeBox(10.0, 0.0),

                /// Select bag Size
                Row(
                  children: [
                    BuildText.buildText(text: 'Bag Size',color: AppColors.greenColor),
                    buildSizeBox(0.0, 3.0),
                    Icon(Icons.work_outline,color: AppColors.greenColor,size: 20,),
                    buildSizeBox(0.0, 3.0),
                    BuildText.buildText(text: ':',color: AppColors.greenColor),
                    buildSizeBox(0.0, 5.0),

                    RadioTileCustom2(
                      onTap: (){},
                      text: 'S',
                    ),
                    buildSizeBox(0.0, 15.0),
                    RadioTileCustom2(
                      onTap: (){},
                      text: 'M',                      
                    ),
                    buildSizeBox(0.0, 15.0),
                    RadioTileCustom2(
                      onTap: (){},
                      text: 'L',                      
                    ),
                    buildSizeBox(0.0, 15.0),
                    RadioTileCustom2(
                      onTap: (){},                                          
                    ),
                    Icon(Icons.work_outline,color: AppColors.greenColor,size: 20,),
                  ],
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
                            selectedDate = formatter.format(picked);
                            showDatedDate = formatterShow.format(picked);
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
                            BuildText.buildText(text: showDatedDate),
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
                    controller.onTapSelectedRoute(context: context, controller: controller);
                  },),),
                  ],
                ),
                Row(
                  children: [              
                  /// Select Driver
                  Flexible(
                  child: WidgetCustom.selectDeliveryScheduleWidget(
                  title: controller.getDriverListController.selectedDriver != null ? controller.getDriverListController.selectedDriver?.firstName.toString() ?? "" : kSelectDriver,
                  onTap:()async{
                    controller.onTapSelectedDriver(context: context, controller: controller);
                  },),),
                  buildSizeBox(0.0, 15.0),
              
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
                  Flexible(
                  child: WidgetCustom.selectDeliveryScheduleWidget(
                  title: controller.selectedDeliveryCharge != null ? controller.selectedDeliveryCharge?.name.toString() ?? "" : kSelDelCharge,
                  onTap:()async{
                    controller.onTapSeletedDeliveryCharge(context: context, controller: controller);
                  },),),
                  buildSizeBox(10.0, 0.0),
              
                  Row(
                    children: [
                    DeliveryScheduleWidgets.customCheckWidget(
                    bgColor: AppColors.blueColor, 
                    title: 'C.D.', 
                    checkBoxValue: false),
                    buildSizeBox(0.0, 5.0),
                    DeliveryScheduleWidgets.customCheckWidget(
                    bgColor: AppColors.redColor, 
                    title: 'C.D.', 
                    checkBoxValue: false),
                    buildSizeBox(0.0, 5.0),
                    DeliveryScheduleWidgets.customCheckWidget(
                    bgColor: AppColors.colorOrange, 
                    title: 'Paid', 
                    checkBoxValue: false),
                    buildSizeBox(0.0, 5.0),
                    DeliveryScheduleWidgets.customCheckWidget(
                    bgColor: AppColors.greenColor, 
                    title: 'Exempt', 
                    checkBoxValue: false),
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
              // bottomNavigationBar: InkWell(
              //   onTap: (){},
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //       height: 50,
              //       alignment: Alignment.center,
              //       decoration: BoxDecoration(
              //         color: AppColors.blueColorLight,
              //         borderRadius: BorderRadius.circular(10)
              //       ),
              //       child: BuildText.buildText(text: kBookDelivery,color: AppColors.whiteColor,size: 15,weight: FontWeight.bold),
              //     ),
              //   ),
              // ),
            ),
        );
      },
    );
    }
}
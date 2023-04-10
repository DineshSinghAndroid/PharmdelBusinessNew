import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Model/PharmacyModels/P_ProcessScanApiResponse/p_processScanResponse.dart';
import '../../../Controller/PharmacyControllers/P_DeliveryScheduleController/p_deliveryScheduleController.dart';
import '../../../Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/DeliveryScheduleWidget/deliveryScheduleWidget.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Model/PmrResponse/pmrResponse.dart';

class DeliveryScheduleScreen extends StatefulWidget {
  List<Dd>? prescriptionList = [];
  List<PmrApiResponse>? pmrList = [];
  bool? isPatient = false;
  OrderInfo? orderInfo;
  String? type;
  String? amount;
  bool? otherPharmacy;
  String? pharmacyId;
  // BulkScanMode callApi;
  DeliveryScheduleScreen({
  this.amount,
  this.isPatient,
  this.orderInfo,
  this.otherPharmacy,
  this.pharmacyId,
  this.pmrList,
  this.prescriptionList,
  this.type
  });

  @override
  State<DeliveryScheduleScreen> createState() => _DeliveryScheduleScreenState();
}

class _DeliveryScheduleScreenState extends State<DeliveryScheduleScreen> {

DeliveryScheduleController delSchdCtrl = Get.put(DeliveryScheduleController());
NursingHomeController nurHomeCtrl = Get.put(NursingHomeController());  

TextEditingController recentNoteController = TextEditingController();
TextEditingController surgeryController = TextEditingController();
TextEditingController branchController = TextEditingController();
TextEditingController deliveryChargeController = TextEditingController();
TextEditingController preChargeController = TextEditingController();  

bool isShowDoctorDetails = false;

@override
  void initState() {   
    init();
    super.initState();
  }

  Future<void> init() async {
    await delSchdCtrl.deliveryScheduleApi(context: context,pharmacyId: '0');
  }

  @override
  void dispose() {
    Get.delete<DeliveryScheduleController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryScheduleController>(
      builder: (controller) {
        return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
  title: BuildText.buildText(text: kDelSchd,size: 18),
  backgroundColor: AppColors.whiteColor,
  leading: InkWell(
    onTap: () => Get.back(),
    child: Icon(Icons.arrow_back,color: AppColors.blackColor,)),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height - 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.pmrList != null)
                BuildText.buildText(
                text: " ${widget.pmrList?[0].xml?.patientInformation?.firstName != null && widget.pmrList?[0].xml?.patientInformation?.firstName != "null" ? widget.pmrList![0].xml?.patientInformation?.firstName : ""} "
                      "${widget.pmrList?[0].xml?.patientInformation?.middleName != null && widget.pmrList?[0].xml?.patientInformation?.middleName != "null" ? widget.pmrList![0].xml?.patientInformation?.middleName : ""} "
                      "${widget.pmrList?[0].xml?.patientInformation?.lastName != null ? (widget.pmrList?[0].xml?.patientInformation?.lastName != "null" ? widget.pmrList![0].xml?.patientInformation?.lastName : "") : ""}"),
                
                if (widget.pmrList != null && widget.type != "5")
                BuildText.buildText(
                  text: widget.pmrList?[0].xml?.customerId == 0 ? "DOB: ${widget.pmrList!.isNotEmpty && widget.pmrList?[0].xml?.patientInformation != null && widget.pmrList?[0].xml?.patientInformation?.dob != null ? widget.pmrList![0].xml!.patientInformation!.dob!.isNotEmpty ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.pmrList![0].xml?.patientInformation?.dob ?? "")) : "" : ""}" : "DOB : ${widget.pmrList?[0].xml?.patientInformation?.dob ?? ""}"),
                
                if (widget.pmrList != null && widget.type != "5")
                BuildText.buildText(
                text: "$kNHS ${widget.pmrList!.isNotEmpty ? "${widget.pmrList?[0].xml?.patientInformation?.nhs ?? ""}" : ""}"),
                  
                if (widget.pmrList != null)
                BuildText.buildText(
                text: "$kPostCode" "${widget.pmrList?[0].xml?.patientInformation?.postCode ?? ""}"),
                  
                if (widget.pmrList != null)
                BuildText.buildText(
                text: "Address : ${widget.pmrList!.isNotEmpty ? widget.pmrList![0].xml?.patientInformation?.address ?? "":""}"),
                Divider(color: AppColors.greyColorDark,),
                
                if (widget.pmrList?[0].xml?.doctorInformation != null)
                Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                color: Colors.green[100],
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                          margin: const EdgeInsets.only(left: 0, bottom: 5, top: 0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              BuildText.buildText(
                                text: kSurgery,
                                style: TextStyleblueGrey14,
                              ),
                              buildSizeBox(0.0, 10.0),
                              BuildText.buildText(text: widget.pmrList!.isNotEmpty ? "${widget.pmrList?[0].xml?.doctorInformation?.companyName ?? ""}" : ""),
                              const Spacer(),
                              isShowDoctorDetails
                                  ? Icon(Icons.keyboard_arrow_up,color: AppColors.greyColor,) : 
                                  Icon(Icons.keyboard_arrow_down,color: AppColors.greyColor,)
                            ],
                          )),
                    ),
                    isShowDoctorDetails
                        ? Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: BuildText.buildText(text: widget.pmrList!.isNotEmpty ? "${widget.pmrList?[0].xml?.doctorInformation?.doctorName ?? ""}" : ""),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: BuildText.buildText(text: "Surgery: ${widget.pmrList!.isNotEmpty ? "${widget.pmrList?[0].xml?.doctorInformation?.companyName ?? ""}" : ""}"),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: BuildText.buildText(text: "Address: ${widget.pmrList!.isNotEmpty ? "${widget.pmrList?[0].xml?.doctorInformation?.address ?? ""}" : ""}"),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              widget.type == "1" ? Divider(color: AppColors.greyColor,) : const SizedBox.shrink(),
                  
              ///Medicine Information
              Row(
                children: [
                  /// Meds
                  DeliveryScheduleWidgets.customWidget(
                    onTap: ()async{
                      controller.onTapMeds(type: widget.type ?? "");
                    },
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
                              // Navigator.of(context).pop(controller.onTapGallery(context: context));
                            },
                            onTapCamera: (){
                              // controller.onTapCamera(context: context);
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
                    title: kRxDetails,
                    bgColor: AppColors.greenDarkColor,
                    titleColor: AppColors.whiteColor,
                    onTap: (){
                      // controller.onTapRxDetails(context: context);
                    },), 
                ],
              ),
              Divider(color: AppColors.greyColorDark,),
                  
              ///Select Service
              Flexible(
                child: WidgetCustom.selectDeliveryScheduleWidget(
                title: controller.selectedService != null ? controller.selectedService?.name.toString() ?? "" : kSelService,
                onTap:()async{
                  controller.onTapSelectService(context: context, controller: controller);
                },),
              ),
                  
              ///Select Bag Size
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    BuildText.buildText(text: kBagSize,color: AppColors.greenDarkColor),
                    buildSizeBox(0.0, 3.0),
                    Icon(Icons.shopping_bag_outlined,color: AppColors.greenDarkColor,size: 20,),
                    buildSizeBox(0.0, 3.0),
                    BuildText.buildText(text: ':',color: AppColors.greenDarkColor),
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
                              groupValue: controller.selectedBagSize,
                              activeColor: AppColors.colorOrange,
                              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              onChanged: (int? value) {
                                PrintLog.printLog('Selected Bag : ${controller.selectedBagSize}');
                                setState(() {
                                  controller.selectedBagSize = value;
                                });
                              },
                            ),
                            controller.bagSizeList[index] != "C" ?
                            BuildText.buildText(
                                text: controller.bagSizeList[index])
                              : Icon(Icons.shopping_bag_outlined,size: 20,color: AppColors.greenDarkColor,),
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
            if (controller.userType == 'Pharmacy' || controller.userType == "Pharmacy Staff")
            Flexible(
            child: WidgetCustom.selectDeliveryScheduleWidget(
            title: controller.getDriverListController.selectedDriver != null ? controller.getDriverListController.selectedDriver?.firstName.toString() ?? "" : kSelectDriver,
            onTap:()async{
              if(controller.getRouteListController.selectedroute == null){
                ToastCustom.showToast(msg: 'Please select route');
              } else{
                controller.onTapSelectedDriver(context: context, controller: nurHomeCtrl);
              }                        
            },),),            
            buildSizeBox(0.0, 15.0),
                      
            /// Select Status               
            Visibility(
              visible: driverType == kDedicatedDriver ? !controller.isStartRoute ? true : false : false,
              child: Flexible(
              child: WidgetCustom.selectDeliveryScheduleWidget(
              title: controller.statusItems != null ? controller.statusItems[0].toString() ?? "" : kReceived,
              onTap:()async{
                controller.onTapSelectStatus(context: context, controller: controller);
              },),),
            ),
            ],
                ),
                 buildSizeBox(10.0, 0.0),        
            Row(
              children: [
              /// Select Nursing Home
              Flexible(
                child: WidgetCustom.selectDeliveryScheduleWidget(
                title: controller.selectedNursingHome != null ? controller.selectedNursingHome?.nursingHomeName.toString() ?? "" : kSelectNursHome,
                onTap:()async{
                  controller.onTapSelectNursingHome(context: context, controller: controller);
                },),),
                controller.parcelBoxList != null && controller.parcelBoxList!.isNotEmpty && controller.selectedStatus == "PickedUp" ?
                buildSizeBox(0.0, 15.0) : const SizedBox.shrink(),
                  
              /// Select Parcel Location  
              controller.parcelBoxList != null && controller.parcelBoxList!.isNotEmpty && controller.selectedStatus == "PickedUp" ?
              Flexible(
                child: WidgetCustom.selectDeliveryScheduleWidget(
                title: controller.selectedParcelBox != null ? controller.selectedParcelBox?.name.toString() ?? "" : kParcelLocation,
                onTap:()async{
                  controller.onTapSelectParcelLocation(context: context, controller: controller);
                },),) : const SizedBox.shrink(),
              ],
            ),
            buildSizeBox(10.0, 0.0),
                                     
            /// Select Delivery Charge
            // if (isDelCharge != null && isDelCharge == 1)
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
                controller: controller.deliveryChargeController,
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
              title: Image.asset(strImgFridge,color: AppColors.whiteColor,height: 20,),
              checkBoxValue: controller.fridgeSelected,
              onChanged: (value) {
                setState(() {
                  controller.fridgeSelected = value!;
                  PrintLog.printLog("Select Fridge : $value");
                });
              },),
              buildSizeBox(0.0, 5.0),
                      
              /// Select C.D.
              DeliveryScheduleWidgets.customWidgetwithCheckbox(
              bgColor: AppColors.redColor, 
              title: BuildText.buildText(text: 'C.D.',color: AppColors.whiteColor),
              checkBoxValue: controller.controlDrugSelected,
              onChanged: (value) {
                setState(() {
                  controller.controlDrugSelected = value!;
                  PrintLog.printLog("Select C.D : $value");
                });
              }),
              buildSizeBox(0.0, 5.0),
                      
              /// Select Paid
              DeliveryScheduleWidgets.customWidgetwithCheckbox(                        
              bgColor: AppColors.colorOrange, 
              title: BuildText.buildText(text: 'Paid',color: AppColors.whiteColor),
              checkBoxValue: controller.paidSelected,
              onChanged: (value) {
                setState(() {
                  controller.paidSelected = value!;
                });
                if(controller.paidSelected){
                  controller.onTapSelectPaid(context: context, controller: controller);
                }
              }),
              buildSizeBox(0.0, 5.0),
                      
              /// Select Exempt
              DeliveryScheduleWidgets.customWidgetwithCheckbox(                      
              bgColor: AppColors.greenColor,
              title: BuildText.buildText(text: 'Exempt',color: AppColors.whiteColor),
              checkBoxValue: controller.exemptSelected,
              onChanged: (value) {
                setState(() {                            
                  controller.exemptSelected = value!;
                });
                if(controller.exemptSelected) {
                  controller.onTapExempt(context: context, controller: controller);
                }
              }),
              buildSizeBox(0.0, 5.0),
              ],
            ),
             buildSizeBox(10.0, 0.0),
                  
            /// Existing Delivery Note
            BuildText.buildText(text: kExistingDelNote,color: AppColors.bluearrowcolor.withOpacity(0.7)),
            buildSizeBox(5.0, 0.0),
            InkWell(
              onTap: (){controller.subExpiryPopUp(context);},
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.greyColor)),
                child: BuildText.buildText(text: kExistingDelNote),
              ),
            ),
            buildSizeBox(10.0, 0.0),
                      
            /// Delivery Note
            BuildText.buildText(text: kDeliveryNote,color: AppColors.bluearrowcolor.withOpacity(0.7)),
            buildSizeBox(5.0, 0.0),                  
            TextFormField(
              controller: controller.deliveryNoteController,
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
          onTap: ()async{
            // await controller.createOrderApi(
            //   context: context,
            //   firstName: widget.firstName ?? "",
            //   middleName: widget.middleName ?? "",
            //   lastName: widget.lastName ?? "",
            //   postCode: widget.postCode ?? "",
            //   dob: widget.dob ?? "",
            //   emailId: widget.email ?? "",
            //   nhsNumber: widget.nhs ?? "",
            //   mobileNumber: widget.contact ?? "",
            //   addressLine1: widget.address ?? "").then((value) {
            //     Get.offAllNamed(pharmacyHomePage);
            //     PopupCustom.orderSuccess(context: context);
            //     Future.delayed(const Duration(seconds: 2)).then((value) {
            //       Get.back();
            //     });
            //   });
          },
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
    );
    },);
  }
}
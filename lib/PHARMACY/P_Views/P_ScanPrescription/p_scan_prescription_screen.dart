import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Model/PmrResponse/pmrResponse.dart';

import '../../../Controller/WidgetController/AdditionalWidget/CustomerListWidget/customer_list_widget.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';
import 'p_scan_prescription_ctrl.dart';

class P_ScanPrescriptionScreen extends StatefulWidget {
  bool? isAssignSelf = false;
  bool? isBulkScan;
  String? type;
  String? driverId;
  String? routeId;
  String? bulkScanDate;
  String? nursingHomeId;
  String? parcelBoxId;
  String? toteId;
  String? pharmacyId;
  bool? isRouteStart;
  List<PmrApiResponse>? pmrList = [];
  List<Dd>? prescriptionList = [];
  // callGetOrderApi callApi;
  // BulkScanMode callPickedApi;

  P_ScanPrescriptionScreen({super.key,
    this.isAssignSelf,
    this.parcelBoxId,
    this.routeId,
    this.driverId,
    this.nursingHomeId,
    this.isRouteStart,
    this.toteId,
    this.bulkScanDate,
    this.type,
    this.isBulkScan,
    this.pharmacyId,
    this.pmrList,
    this.prescriptionList,
  });

  @override
  State<P_ScanPrescriptionScreen> createState() => _P_ScanPrescriptionScreenState();
}

class _P_ScanPrescriptionScreenState extends State<P_ScanPrescriptionScreen> {

  String? accessToken;
  String? userType;
  String? startRouteId;
  String? endRouteId;
  bool? isStartRoute;
  String? driverType;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init()async{
    AppSharedPreferences.getInstance();
    accessToken = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.authToken);
    userType = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType);
    // endRouteId = ;
    // isStartRoute = ;
    // if (widget.toteId == null || widget.toteId!.isEmpty){
    // isStartRoute = value from shared preferences
    // } else{
    isStartRoute = false;
    driverType = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.driverType);
    // startRouteId = value from shared preferences
    scanPrescCtrl.buildQrView(
        context: context,
        qrCodeType: widget.type ?? "",
        isBulkScan: widget.isBulkScan ?? false,
        bulkScanDate: widget.bulkScanDate ?? "",
        driverId: widget.driverId ?? "",
        isRouteStart: widget.isRouteStart ?? false,
        nursingHomeId: widget.nursingHomeId ?? "",
        parcelBoxId: widget.parcelBoxId ?? "",
        routeId: widget.routeId ?? "",
        toteId: widget.toteId ?? "",
        pmrList: widget.pmrList ?? [],
        prescriptionList: widget.prescriptionList ?? []
    );
    scanPrescCtrl.getLocationData(context: context);
    // }
    if (widget.pharmacyId == null) {
      widget.pharmacyId = "0";
    }
  }

  ScanPrescriptionController scanPrescCtrl = Get.put(ScanPrescriptionController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanPrescriptionController>(
      init: scanPrescCtrl,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.materialAppThemeColor,
            centerTitle: true,
            title: BuildText.buildText(
                text: kCstmList,
                color: AppColors.blackColor,
                size: 18
            ),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.blackColor,
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child:
                controller.orderInfo != null &&  controller.orderInfo?.patientList != null &&  controller.orderInfo?.patientList?.userId != null &&  controller.orderInfo!.patientList!.userId!.isNotEmpty && controller.orderInfo!.patientList!.userId![0].toString().isNotEmpty ?
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.getProcessScanController.processScanData?.orderInfo?.userId?.length ?? 0,
                      // orderInfo != null ? orderInfo.patientsList.userId.length : 0,
                      itemBuilder: (context, index) {
                        return CustomerListWidget2(
                          address: controller.getProcessScanController.processScanData?.orderInfo?.address?.s0 ?? "N/A",
                          customerName: controller.getProcessScanController.processScanData?.orderInfo?.firstName?.s0 ?? "N/A",
                          dob: controller.getProcessScanController.processScanData?.orderInfo?.dob ?? "N/A",
                          nhsNumber: controller.getProcessScanController.processScanData?.orderInfo?.nhsNumber?.i0 ?? "N/A",
                          userId: controller.getProcessScanController.processScanData?.orderInfo?.userId ?? "N/A",
                          onSelect: () {
                            controller.selectCustomer(
                                userId: controller.getProcessScanController.processScanData?.orderInfo?.userId ?? "",
                                altAddress: controller.getProcessScanController.processScanData?.orderInfo?.altAddress ?? "");
                          },
                        );
                      }),
                )
                    : const SizedBox.shrink(),
              ),

              /// Add New Customer
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                    onPressed: (){
                      if(widget.type == "4" || widget.type == "6" || widget.type == "3" || widget.type == "2"){
                        controller.pmrData?.xml?.patientInformation?.firstName = controller.orderInfo?.prescriptionId ?? "";
                        controller.pmrData?.xml?.patientInformation?.middleName = controller.orderInfo?.prescriptionId ?? "";
                        controller.pmrData?.xml?.patientInformation?.lastName = controller.orderInfo?.prescriptionId ?? "";
                        controller.pmrData?.xml?.patientInformation?.address = controller.orderInfo?.patientList?.address != null ? controller.orderInfo?.patientList?.address![0] ?? controller.pmrData?.xml?.patientInformation?.address : controller.pmrData?.xml?.patientInformation?.address;
                        controller.pmrData?.xml?.patientInformation?.nhs = controller.orderInfo?.prescriptionId ?? "";
                        controller.pmrData?.xml?.patientInformation?.mobileNo = controller.orderInfo?.mobileNo ?? "";
                        controller.pmrData?.xml?.patientInformation?.email_id = controller.orderInfo?.email ?? "";
                        controller.pmrData?.xml?.patientInformation?.postCode = controller.orderInfo?.prescriptionId ?? "";
                        controller.pmrData?.xml?.patientInformation?.dob = "";

                        // if (widget.type == "4") {
                        //   if (!result.startsWith("pharm") && result.contains(";")) {
                        //     model.xml.sc.id = result.split(";")[1];
                        //     amount = result.split(";").last;
                        //   }
                        //   // else {
                        //   //   model.xml.sc.id = result;
                        //   // }
                        // } else {
                        //   amount = "";
                        // }
                      }
                      controller.pmrData?.xml?.alt_address = "";
                      controller.pmrData?.xml?.customerId = 0;
                      controller.pmrData?.xml?.isAddNewCustomer = true;
                      widget.pmrList?.add(controller.pmrData!);
                      widget.prescriptionList?.addAll(controller.pmrData?.xml?.dd ?? []);

                      if (widget.isBulkScan ?? false) {
                        controller.getDeliveryScheduleController.createOrderApi(
                            context: context,
                            firstName: controller.pmrData?.xml?.patientInformation?.firstName ?? "",
                            middleName: controller.pmrData?.xml?.patientInformation?.middleName ?? "",
                            lastName: controller.pmrData?.xml?.patientInformation?.lastName ?? "",
                            postCode: controller.pmrData?.xml?.patientInformation?.postCode ?? "",
                            addressLine1: controller.pmrData?.xml?.patientInformation?.address ?? "",
                            nhsNumber: controller.pmrData?.xml?.patientInformation?.nhs ?? "",
                            dob: controller.pmrData?.xml?.patientInformation?.dob ?? "",
                            mobileNumber: controller.pmrData?.xml?.patientInformation?.mobileNo ?? "",
                            emailId: controller.pmrData?.xml?.patientInformation?.email_id ?? "");
                      }else{
                        Get.toNamed(deliveryScheduleScreenRoute);
                      }
                    },
                    color: AppColors.colorOrange,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.whiteColor,
                        ),
                        BuildText.buildText(
                          text: kAddNewCustomer,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    )),
              )
            ],
          ),
        );
      },
    );
  }
}
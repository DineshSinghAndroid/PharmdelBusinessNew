import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import 'package:pharmdel/Controller/WidgetController/Loader/LoadScreen/LoadScreen.dart';
import 'package:pharmdel/View/ScanPrescription/scan_prescription_ctrl.dart';
import '../../Controller/ProjectController/QrCodeController/qr_code_controller.dart';
import '../../Controller/WidgetController/AdditionalWidget/CustomerListWidget/customer_list_widget.dart';
import '../../Controller/WidgetController/StringDefine/StringDefine.dart';
import '../DeliverySchedule/delivery_schedule_screen.dart';

class ScanPrescriptionScreen extends StatefulWidget {
  const ScanPrescriptionScreen({super.key});

  @override
  State<ScanPrescriptionScreen> createState() => _ScanPrescriptionScreenState();
}

class _ScanPrescriptionScreenState extends State<ScanPrescriptionScreen> {


  DriverScanPrescriptionController ctrl = Get.put(DriverScanPrescriptionController());
  QrCodeController qrCtrl = Get.put(QrCodeController());

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init()async{
    await qrCtrl.buildQrView(context: context);
  }

  @override
  void dispose() {
    Get.delete<QrCodeController>();
    Get.delete<DriverScanPrescriptionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrCodeController>(
      init: qrCtrl,
      builder: (controller){
        return LoadScreen(
          widget: Scaffold(
            appBar: AppBarCustom.appBarStyle2(
                title: kCustomerList,
                size: 18,centerTitle: false
            ),
            bottomNavigationBar: MaterialButton(
                onPressed: ()=> controller.onTapListWidget(context: context),
                color: AppColors.colorOrange,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    BuildText.buildText(
                      text: kAddNewCustomer,
                      color: AppColors.whiteColor,
                    ),
                  ],
                )),
            body: controller.orderInfo != null && controller.orderInfo?.patientsList != null && controller.orderInfo!.patientsList!.userId![0].toString().isNotEmpty ?
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 90),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.orderInfo!.patientsList?.userId?.length ?? 0,
                      itemBuilder: (context, index) {
                        return CustomerListWidget(
                          address:"N/A", // controller.orderInfo?.address ?? "N/A",
                          customerName: controller.orderInfo?.patientsList?.customerName?[index] ?? "N/A" ?? "",
                          dob: controller.orderInfo!.patientsList?.dob?[index] ?? "N/A",
                          nhsNumber: controller.orderInfo!.patientsList?.nhsNumber?[index].toString() ?? "N/A",
                          userId: controller.orderInfo!.patientsList?.userId?[index].toString() ?? "N/A",
                          onPressed: ()=> controller.onTapListWidget(context: context),
                        );
                      }),
                )
                    : const SizedBox.shrink(),
          ),
          isLoading: controller.isLoading,
        );
      },
    );
  }  
}

abstract class CustomerSelectedListner {
  void isSelected(dynamic userid, dynamic position, dynamic altAddress);
}
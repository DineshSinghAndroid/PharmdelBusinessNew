// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/PharmacyControllers/P_NotificationController/p_notification_controller.dart';
import '../../../Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/NursingHomeWidget/nursing_home_cardwidget.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';

class NursingHomeScreen extends StatefulWidget {
  const NursingHomeScreen({super.key});

  @override
  State<NursingHomeScreen> createState() => _NursingHomeScreenState();
}

class _NursingHomeScreenState extends State<NursingHomeScreen> {

  NursingHomeController nurHmCtrl = Get.put(NursingHomeController());  

  String selectedDate = "";
  String showDatedDate = "";
  bool? isCheckedCD = false;
  bool? isCheckedFridge = false;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  @override
  void initState() {        
    init();
    super.initState();
  }

  Future<void> init() async {
    final DateTime now = DateTime.now();
    selectedDate = formatter.format(now);
    showDatedDate = formatterShow.format(now);        
    await nurHmCtrl.nursingHomeApi(context: context);    
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NursingHomeController>(
      init: nurHmCtrl,
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
        title: BuildText.buildText(text: kBulkScan, size: 18),
        backgroundColor: AppColors.whiteColor,
        iconTheme: IconThemeData(color: AppColors.blackColor),
            ),
            body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
        
              ///Select Route
              Flexible(
                child: WidgetCustom.pharmacyTopSelectWidget(
                title: controller.getRouteListController.selectedroute != null ? controller.getRouteListController.selectedroute?.routeName.toString() ?? "" : kSelectRoute,
                onTap:()async{
                  controller.onTapSelectedRoute(context:context,controller:controller);                  
                },),
              ),
              buildSizeBox(0.0, 10.0),
        
               ///Select Driver
               nurHmCtrl.getDriverListController.driverList != null && nurHmCtrl.getDriverListController.driverList.isNotEmpty ?            
              Flexible(
                child: WidgetCustom.pharmacyTopSelectWidget(
                title: controller.getDriverListController.selectedDriver != null ? controller.getDriverListController.selectedDriver?.firstName.toString() ?? "" : kSelectDriver,
                onTap:()=> controller.onTapSelectedDriver(context:context,controller:controller),),
              ) : const SizedBox.shrink(),
              ],
            ),
            buildSizeBox(10.0, 0.0),
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
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColors.whiteColor,
                      ),
                      child: Row(
                        children: [
                          BuildText.buildText(text: showDatedDate),
                          const Spacer(),
                          const Icon(Icons.calendar_today_sharp)
                        ],
                      ),
                    ),
                  ),
                ),
                buildSizeBox(0.0, 10.0),

                ///Select Nursing Home
                Flexible(
                child: WidgetCustom.pharmacyTopSelectWidget(
                title: controller.selectedNursingHome != null ? controller.selectedNursingHome?.nursingHomeName.toString() ?? "" : kSelectNursHome,
                onTap:()=> controller.onTapSelectNursingHome(context:context,controller:controller),),
              ),
              ],
            ),

            // Get Boxes List
            nurHmCtrl.boxesListData != null && nurHmCtrl.boxesListData.isNotEmpty ?
            Flexible(
                child: WidgetCustom.pharmacyTopSelectWidget(
                title: controller.selectedBox != null ? controller.selectedBox?.boxName.toString() ?? "" : kSelectTote,
                onTap:()=> controller.onTapSelectTote(context:context,controller:controller, selectDate: selectedDate),),
              ) : const SizedBox.shrink(),
            
            buildSizeBox(20.0, 0.0),

            ///Nursing Order Delivery List
            nurHmCtrl.nursingOrdersData != null && nurHmCtrl.nursingOrdersData!.isNotEmpty ?
            Expanded(
              flex: 4,
              child: ListView.builder(
                itemCount: controller.nursingOrdersData?.length ?? 0,
                shrinkWrap: true,              
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return NursingHomeCardWidget(
                    index: index,
                    selectDate: selectedDate,
                    leadingText: "${index + 1}",
                    customerName: controller.nursingOrdersData?[index].customerName ?? "",
                    address: controller.nursingOrdersData?[index].address ?? "",
                    orderId: controller.nursingOrdersData?[index].orderId ?? "",
                    isShowFridge: controller.nursingOrdersData?[index].isStorageFridge == 't' ? true : false,
                    isShowCD: controller.nursingOrdersData?[index].isControlledDrugs == 't' ? true : false,
                    isCheckedFridge: controller.nursingOrdersData?[index].isStorageFridge == 't' ? true : false,
                    isCheckedCD: controller.nursingOrdersData?[index].isControlledDrugs == 't' ? true : false,
                  );
                },
              ),
            ) : const SizedBox.shrink()
          ],
        ),
            ),
        
        ///Floating Action Buttons
        floatingActionButton: Transform.translate(
        offset: const Offset(20,0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        
            ///Scan Rx
            FloatingActionButton.extended(
              heroTag: 'btn1',
                backgroundColor: AppColors.colorOrange,
                onPressed: () {
                  nurHmCtrl.onTapSelectScanRx();
                },
                label: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.whiteColor,
                    ),
                    BuildText.buildText(
                    text: kScanRx, 
                    color: AppColors.whiteColor),
                  ],
                )),

            ///Close Tote
            FloatingActionButton.extended(
              heroTag: 'btn2',
                onPressed: () {
                  nurHmCtrl.onTapSelectCloseTote();                  
                  },
                label: BuildText.buildText(
                  text: kCloseTote,
                  color: AppColors.whiteColor)),
          ],
        ),
            ),
          );
      },
    );
  }
 
}
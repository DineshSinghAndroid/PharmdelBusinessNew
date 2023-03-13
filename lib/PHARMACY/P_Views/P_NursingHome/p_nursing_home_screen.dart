// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/Helper/Colors/custom_color.dart';
import 'package:pharmdel/Controller/Helper/TextController/BuildText/BuildText.dart';
import 'package:pharmdel/Controller/WidgetController/AdditionalWidget/Default%20Functions/defaultFunctions.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Controller/PharmacyControllers/P_NursingHomeController/p_nursinghome_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/NursingHomeWidget/nursing_home_cardwidget.dart';
import '../../../Model/PharmacyModels/P_GetBoxesResponse/p_getBoxesApiResponse.dart';
import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';
import '../../../Model/PharmacyModels/P_NursingHomeResponse/p_nursingHomeResponse.dart';

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
    await nurHmCtrl.getDriverListController.getDriverList(context: context,routeId: '29');
    await nurHmCtrl.nursingHomeApi(context: context);        
    await nurHmCtrl.boxesApi(context: context,nursingId: '87134');
    await nurHmCtrl.nursingHomeOrderApi(
      context: context,
      dateTime: selectedDate,
      nursingHomeId: '10',
      driverId: '10',
      routeId: '29',
      toteBoxId: '12',
      );
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
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: BuildText.buildText(
                        text: kSelectRoute,
                        size: 14,                       
                      ),
                      items: [
                        for (RouteList route in controller.getRouteListController.routeList)
                          DropdownMenuItem(
                            value: controller.getRouteListController.routeList.indexOf(route).toString(),
                            child: BuildText.buildText(text: "${route.routeName}",color: AppColors.blackColor,size: 14),
                          ),
                      ],
                      value: controller.getRouteListController.selectedRouteName,
                      onChanged: (value) {
                        setState(() {
                          controller.getRouteListController.selectedRouteName = value.toString();
                        });
                      },                                                  
                    ),
                  ),
                ),
                buildSizeBox(0.0, 10.0),

               ///Select Driver
              //  controller.getRouteListController.routeList.isNotEmpty ?
               Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: BuildText.buildText(
                        text: kSelectDriver,
                        size: 14,                       
                      ),
                      onChanged: (DriverModel? newValue) {
                        setState(() {
                          controller.getDriverListController.selectedDriver = newValue;
                        });
                      },
                      items: controller.getDriverListController.driverList.map<DropdownMenuItem<DriverModel>>((DriverModel value) {
                        return DropdownMenuItem<DriverModel>(
                          value: value,
                          child: BuildText.buildText(
                            text: value.firstName ?? "No Driver",
                            size: 12,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      value: controller.getDriverListController.selectedDriver,                     
                    ),
                  ),
                ) 
                // : const SizedBox.shrink()
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
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: controller.selectedNursingValue,
                      items: [
                      for (NursingHome nursing in controller.nursingHomeList)
                      DropdownMenuItem(
                          value: controller.nursingHomeList.indexOf(nursing).toString(),
                          child: BuildText.buildText(text: "${nursing.nursingHomeName}",color: AppColors.blackColor,size: 14),
                        )],
                      hint: BuildText.buildText(
                        text: kSelectNursHome,
                        color: AppColors.blackColor,
                        size: 14,
                      ),
                      onChanged: (value) {
                        setState(() {
                          controller.selectedNursingValue = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(
                //     alignment: Alignment.center,
                //     padding: const EdgeInsets.all(5),
                //     height: 50,
                //     decoration: BoxDecoration(
                //         color: AppColors.whiteColor,
                //         borderRadius: BorderRadius.circular(5)),
                //     child: DropdownButton<NursingHome>(                      
                //       value: controller.nursingHomeValue,
                //       iconSize: 24,
                //       elevation: 2,
                //       isExpanded: true,
                //       underline: const SizedBox(),
                //       items: 
                //       controller.nursingHomeList != null && controller.nursingHomeList!.isNotEmpty ? 
                //             controller.nursingHomeList!.map((NursingHome? value) {
                //                 return DropdownMenuItem<NursingHome>(
                //                   value: value,
                //                   child: BuildText.buildText(
                //                     text: value!.nursingHomeName ?? "",                                      
                //                   ),
                //                 );
                //               }).toList()
                //             : null,
                //       hint: BuildText.buildText(
                //         text: kSelectNursHome,
                //         color: AppColors.blackColor,
                //         size: 14,
                //       ),
                //       onChanged: (NursingHome? newvalue) {
                //         setState(() {
                //           controller.nursingHomeValue = newvalue;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                
              ],
            ),

            ///Get Boxes List
            Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: controller.selectedBoxValue,
                      items: [
                      for (BoxesData boxes in controller.boxesListData)
                      DropdownMenuItem(
                          value: controller.boxesListData.indexOf(boxes).toString(),
                          child: BuildText.buildText(text: "${boxes.boxName}",color: AppColors.blackColor,size: 14),
                        )],
                      hint: BuildText.buildText(
                        text: 'Select Box',
                        color: AppColors.blackColor,
                        size: 14,
                      ),
                      onChanged: (value) {
                        setState(() {
                          controller.selectedBoxValue = value.toString();
                        });
                      },
                    ),
                  ),
                ),
            buildSizeBox(20.0, 0.0),
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return NursingHomeCardWidget(
                  customerName: 'Customer Name',
                  leadingText: 'M',                  
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: 'btn1',
                backgroundColor: AppColors.colorOrange,
                onPressed: () {
                  DefaultFuntions.barcodeScanning();
                },
                label: Column(
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: AppColors.whiteColor,
                    ),
                    BuildText.buildText(
                        text: kScanRx, color: AppColors.whiteColor),
                  ],
                )),
            FloatingActionButton.extended(
              heroTag: 'btn2',
                onPressed: () {},
                label: BuildText.buildText(
                    text: kCloseTote, color: AppColors.whiteColor)),
          ],
        ),
      ),
    );
      },
    );
  }
}

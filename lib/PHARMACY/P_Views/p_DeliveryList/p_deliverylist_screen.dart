import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../../Controller/PharmacyControllers/P_DeliveriesScreenController/P_deliverieslist_screen_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';
import '../../../Controller/WidgetController/AdditionalWidget/P_DeliveryCardCustom/deliveryCardCustom.dart';

class PharmacyDeliveryListScreen extends StatefulWidget {
  const PharmacyDeliveryListScreen({super.key});

  @override
  State<PharmacyDeliveryListScreen> createState() => _PharmacyDeliveryListScreenState();
}

class _PharmacyDeliveryListScreenState extends State<PharmacyDeliveryListScreen> {
  final PDeliveriesScreenController controller = Get.put(PDeliveriesScreenController());
  TabController? tabController;

  @override
  void initState() {
    controller.getRouteListController.selectedroute = null;
    controller.getDriverListController.selectedDriverPosition = 0;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PDeliveriesScreenController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.whiteColor,
              centerTitle: true,
              iconTheme: IconThemeData(color: AppColors.blackColor),
              actionsIconTheme: IconThemeData(color: AppColors.blackColor),
              title: BuildText.buildText(text: kDeliveryList, color: AppColors.blackColor, size: 18),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.search,
                            color: AppColors.blackColor,
                          )),
                      buildSizeBox(0.0, 10.0),
                      InkWell(onTap: () {}, child: Icon(Icons.refresh, color: AppColors.blackColor)),
                      buildSizeBox(0.0, 10.0),
                      InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.person,
                            color: AppColors.blackColor,
                          ))
                    ],
                  ),
                )
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(strIMG_HomeBg), fit: BoxFit.fitHeight)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: Get.height,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: WidgetCustom.pharmacyTopSelectWidget(
                          title: controller.getRouteListController.selectedroute != null ? controller.getRouteListController.selectedroute?.routeName.toString() ?? "" : kSelectRoute,
                          onTap: () async {
                            controller.onTapSelectedRoute(context: context, controller: controller.getNurHomeCtrl);
                          },
                        ),
                      ),
                      buildSizeBox(0.0, 10.0),

                      ///Select Driver
                      controller.getDriverListController.driverList.isNotEmpty && controller.getRouteListController.selectedroute != null
                          ? Flexible(
                              child: WidgetCustom.pharmacyTopSelectWidget(
                                title: controller.getDriverListController.selectedDriver != null ? controller.getDriverListController.selectedDriver?.firstName.toString() ?? "" : kSelectDriver,
                                onTap: () => controller.onTapSelectedDriver(context: context, controller: controller.getNurHomeCtrl),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  buildSizeBox(10.0, 0.0),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.onTodayTap();
                        },
                        child: Chip(
                          label: BuildText.buildText(text: kToday, color: AppColors.whiteColor),
                          backgroundColor: controller.todaySelected ? AppColors.redColor : AppColors.blueColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      buildSizeBox(0.0, 8.0),
                      InkWell(
                        onTap: () {
                          controller.onTomorrowTap();
                        },
                        child: Chip(
                          label: BuildText.buildText(text: kTomorrow, color: AppColors.whiteColor),
                          backgroundColor: controller.tomorrowSelected ? AppColors.redColor : AppColors.blueColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      buildSizeBox(0.0, 8.0),
                      InkWell(
                        onTap: () {},
                        child: Chip(
                          label: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: AppColors.whiteColor,
                                size: 20,
                              ),
                              buildSizeBox(0.0, 5.0),
                              BuildText.buildText(text: kSelect, color: AppColors.whiteColor),
                            ],
                          ),
                          backgroundColor: controller.otherDateSelected ? AppColors.redColor : AppColors.blueColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                    ],
                  ),
                  buildSizeBox(5.0, 0.0),
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                            bgColor: AppColors.blueColor,
                            label: kTotal,
                            selectedTopBtnName: controller.selectedTopBtnName,
                            counter: controller.totalList.length.toString() ?? "0",
                            onTap: () {},
                          )),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                            bgColor: AppColors.greyColor,
                            label: kPickedUp,
                            selectedTopBtnName: controller.selectedTopBtnName,
                            counter: controller.pickedUpList.length.toString() ?? "0",
                            onTap: () {},
                          )),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                            bgColor: AppColors.greenColor,
                            label: kDelivered,
                            selectedTopBtnName: controller.selectedTopBtnName,
                            counter: controller.deliveredList.length.toString() ?? "0",
                            onTap: () {},
                          )),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                            bgColor: AppColors.redColor,
                            label: kFailed,
                            selectedTopBtnName: controller.selectedTopBtnName,
                            counter: controller.failedList.length.toString() ?? "0",
                            onTap: () {},
                          )),
                    ],
                  ),
                  Container(
                    height: 450,
                    child: DefaultTabController(
                      length: 4,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          totalView(),
                          pickedUpView(),
                          deliverdView(),
                          failedView(),
                        ],
                      ),
                    ),
                  ),
                  buildSizeBox(10.0, 0.0),
                ],
              ),
            ));
      },
    );
  }

  ListView totalView() => ListView.separated(
        shrinkWrap: true,
        itemCount: controller.totalList.length ?? 0,
        itemBuilder: (context, i) {
          return PharmacyDeliveryCard(
            /// onTap
            onTap: () {
              controller.onTotalListTap(
                context: context,
                orderId: controller.totalList[i].orderId ?? 0,
                patientName: controller.totalList[i].customerName??"${controller.totalList[i].surName}" ??"",
                deliveryNotes: controller.totalList[i].deliveryNote??"",
                existingNotes: controller.totalList[i].exitingNote??"",
                patientAddress: controller.totalList[i].address??"",
                patientMobileNumber: controller.totalList[i].customerMobileNumber??"",
                patientBagSize: controller.totalList[i].bagSize??"",
                isCdType: controller.totalList[i].isControlledDrugs??"",
                isFridze: controller.totalList[i].isStorageFridge??"",
                rxCharge: controller.totalList[i].rxCharge??"",
                rxInvoice: controller.totalList[i].rxInvoice ??0,
                exemptionName: controller.totalList[i].exemption??"",
                delCharge: controller.totalList[i].delCharge??"",


              );
            },

            /// onTap Route
            onTapRoute: () {},

            /// onTap Manual
            onTapManual: () {},

            /// onTap DeliverNow
            onTapDeliverNow: () {},

            /// Customer Detail
            customerName: "${controller.getDeliveryResponse?.sortedList?[i].customerName}"  ,
            customerAddress: "${controller.getDeliveryResponse?.sortedList?[i].address}",
            altAddress: "",
            driverType: '',

            isSelected: false,
            nursingHomeId: "",
            pharmacyName: "",

            /// Order Detail
            orderListType: controller.orderListType,
            orderId: "",
            deliveryStatus: controller.totalList[i].deliveryStatusDesc??"" ?? "",
            isControlledDrugs: controller.getDeliveryResponse?.sortedList?[i].isControlledDrugs ?? "",
            isCronCreated: controller.getDeliveryResponse?.sortedList?[i].isCronCreated ?? "",
            isStorageFridge: controller.getDeliveryResponse?.sortedList?[i].isStorageFridge ?? "",
            parcelBoxName: controller.getDeliveryResponse?.sortedList?[i].parcelBoxName ?? "",
            serviceName: controller.getDeliveryResponse?.sortedList?[i].serviceName ?? "",
            pmrId: "",
            pmrType: "",
            rescheduleDate: controller.getDeliveryResponse?.sortedList?[i].rescheduleDate ?? "",

            /// PopUp Menu
            popUpMenu: [],
            isBulkScanSwitched: false,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 15),
          );
        },
      );

  ListView pickedUpView() => ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.pickedUpList?.length ?? 0,
        itemBuilder: (context, i) {
          return PharmacyDeliveryCard(
            /// onTap
            // onTap: ()=> controller.onTapDeliveryListItem(context: context,index: i),

            /// onTap Route
            onTapRoute: () {},

            /// onTap Manual
            onTapManual: () {},

            /// onTap DeliverNow
            onTapDeliverNow: () {},

            /// Customer Detail
            customerName: controller.pickedUpList[i].customerName ?? "",
            customerAddress: "${controller.pickedUpList[i].address}",
            altAddress: "",
            driverType: '',

            isSelected: false,
            nursingHomeId: "",
            pharmacyName: "",

            /// Order Detail
            orderListType: controller.orderListType,
            orderId: "",
            deliveryStatus: controller.pickedUpList[i].deliveryStatusDesc??"" ?? "",

//        deliveryStatus: "",
            isControlledDrugs: controller.getDeliveryResponse?.sortedList?[i].isControlledDrugs ?? "",
            isCronCreated: controller.getDeliveryResponse?.sortedList?[i].isCronCreated ?? "",
            isStorageFridge: controller.getDeliveryResponse?.sortedList?[i].isStorageFridge ?? "",
            parcelBoxName: controller.getDeliveryResponse?.sortedList?[i].parcelBoxName ?? "",
            serviceName: controller.getDeliveryResponse?.sortedList?[i].serviceName ?? "",
            pmrId: "",
            pmrType: "",
            rescheduleDate: controller.getDeliveryResponse?.sortedList?[i].rescheduleDate ?? "",

            /// PopUp Menu
            popUpMenu: [],
            isBulkScanSwitched: false,
            onTap: () {},
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 15),
          );
        },
      );

  ListView deliverdView() => ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.deliveredList.length ?? 0,
        itemBuilder: (context, i) {
          return PharmacyDeliveryCard(
            /// onTap
            // onTap: ()=> controller.onTapDeliveryListItem(context: context,index: i),

            /// onTap Route
            onTapRoute: () {},

            /// onTap Manual
            onTapManual: () {},

            /// onTap DeliverNow
            onTapDeliverNow: () {},

            /// Customer Detail
            customerName: "${controller.deliveredList[i].customerName ?? ""}",
            customerAddress: "${controller.deliveredList[i].address}",
            altAddress: "",
            driverType: '',

            isSelected: false,
            nursingHomeId: "",
            pharmacyName: "",

            /// Order Detail
            orderListType: controller.orderListType,
            orderId: "",
            // deliveryStatus: "",
            deliveryStatus: controller.deliveredList[i].deliveryStatusDesc??"" ?? "",

            isControlledDrugs: controller.getDeliveryResponse?.sortedList?[i].isControlledDrugs ?? "",
            isCronCreated: controller.getDeliveryResponse?.sortedList?[i].isCronCreated ?? "",
            isStorageFridge: controller.getDeliveryResponse?.sortedList?[i].isStorageFridge ?? "",
            parcelBoxName: controller.getDeliveryResponse?.sortedList?[i].parcelBoxName ?? "",
            serviceName: controller.getDeliveryResponse?.sortedList?[i].serviceName ?? "",
            pmrId: "",
            pmrType: "",
            rescheduleDate: controller.getDeliveryResponse?.sortedList?[i].rescheduleDate ?? "",

            /// PopUp Menu
            popUpMenu: [],
            isBulkScanSwitched: false,
            onTap: () {},
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 15),
          );
        },
      );

  ListView failedView() => ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.failedList?.length ?? 0,
        itemBuilder: (context, i) {
          return PharmacyDeliveryCard(
            /// onTap
            // onTap: ()=> controller.onTapDeliveryListItem(context: context,index: i),

            /// onTap Route
            onTapRoute: () {},

            /// onTap Manual
            onTapManual: () {},

            /// onTap DeliverNow
            onTapDeliverNow: () {},

            /// Customer Detail
            customerName: controller.failedList[i].customerName ?? "",
            customerAddress: "${controller.failedList[i].address}",
            altAddress: "",
            driverType: '',

            isSelected: false,
            nursingHomeId: "",
            pharmacyName: "",

            /// Order Detail
            orderListType: controller.orderListType,
            orderId: "",
            deliveryStatus: controller.failedList[i].deliveryStatusDesc??"" ?? "",
            isControlledDrugs: controller.getDeliveryResponse?.sortedList?[i].isControlledDrugs ?? "",
            isCronCreated: controller.getDeliveryResponse?.sortedList?[i].isCronCreated ?? "",
            isStorageFridge: controller.getDeliveryResponse?.sortedList?[i].isStorageFridge ?? "",
            parcelBoxName: controller.getDeliveryResponse?.sortedList?[i].parcelBoxName ?? "",
            serviceName: controller.getDeliveryResponse?.sortedList?[i].serviceName ?? "",
            pmrId: "",
            pmrType: "",
            rescheduleDate: controller.getDeliveryResponse?.sortedList?[i].rescheduleDate ?? "",

            /// PopUp Menu
            popUpMenu: [],
            isBulkScanSwitched: false,
            onTap: () {},
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 15),
          );
        },
      );
}

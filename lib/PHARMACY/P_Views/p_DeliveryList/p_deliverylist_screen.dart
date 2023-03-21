import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../../Controller/PharmacyControllers/P_DeliveriesScreenController/P_deliverieslist_screen_controller.dart';
import '../../../Controller/WidgetController/AdditionalWidget/Other/other_widget.dart';

class PharmacyDeliveryListScreen extends StatefulWidget {
  const PharmacyDeliveryListScreen({super.key});

  @override
  State<PharmacyDeliveryListScreen> createState() => _PharmacyDeliveryListScreenState();
}

class _PharmacyDeliveryListScreenState extends State<PharmacyDeliveryListScreen> {
  final PDeliveriesScreenController controller = Get.put(PDeliveriesScreenController());

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
                      controller.getDriverListController.driverList.isNotEmpty
                          ? Flexible(
                              child: WidgetCustom.pharmacyTopSelectWidget(
                                title:
                                    controller.getDriverListController.selectedDriver != null ? controller.getDriverListController.selectedDriver?.firstName.toString() ?? "" : kSelectDriver,
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
                          backgroundColor: AppColors.blueColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      buildSizeBox(0.0, 8.0),
                      InkWell(
                        onTap: () {},
                        child: Chip(
                          label: BuildText.buildText(text: kTomorrow, color: AppColors.whiteColor),
                          backgroundColor: AppColors.blueColor,
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
                          backgroundColor: AppColors.blueColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                    ],
                  ),
                  buildSizeBox(25.0, 0.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(flex: 1, fit: FlexFit.tight, child: DefaultWidget.topCounter(bgColor: AppColors.blueColor, label: kTotal, counter: '0', onTap: () {})),
                      Flexible(flex: 1, fit: FlexFit.tight, child: DefaultWidget.topCounter(bgColor: AppColors.greyColorDark, label: kPickedUp, counter: '0', onTap: () {})),
                      Flexible(flex: 1, fit: FlexFit.tight, child: DefaultWidget.topCounter(bgColor: AppColors.greenAccentColor, label: kDelivered, counter: '0', onTap: () {})),
                      Flexible(flex: 1, fit: FlexFit.tight, child: DefaultWidget.topCounter(bgColor: AppColors.redColor.withOpacity(0.9), label: kFailed, counter: '0', onTap: () {})),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}

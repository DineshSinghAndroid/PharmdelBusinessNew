import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

 import '../../../Controller/PharmacyControllers/P_DeliveriesScreenController/P_deliverieslist_screen_controller.dart';
import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';

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
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(strIMG_HomeBg))),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              height: Get.height,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [

                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            kSelectRoute,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: [
                            for (RouteList route in controller.getRouteListController.routeList)
                              DropdownMenuItem(
                                value: controller.getRouteListController.routeList.indexOf(route).toString(),
                                child: Text("${route.routeName}", style: const TextStyle(color: Colors.black87)),
                              ),
                          ],
                          value: controller.getRouteListController.selectedRouteValue,
                          onChanged: (value) {
                            setState(() {
                              controller.getRouteListController.selectedRouteValue = value.toString();
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              height: 40,
                              width: Get.width / 2.3,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                              )),
                          menuItemStyleData: const MenuItemStyleData(),
                        ),
                      ),
                      Spacer(),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            kSelectDriver,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: [
                            for (GetDriverListModelResponsePharmacy driver in controller.getDriverListController.driverList)
                              DropdownMenuItem(
                                value: controller.getDriverListController.driverList.indexOf(driver).toString(),
                                child: Text("${driver.firstName}", style: const TextStyle(color: Colors.black87)),
                              ),
                          ],
                          value: controller.getDriverListController.selectedDriverName,
                          onChanged: (value) {
                            setState(() {
                              controller.getDriverListController.selectedDriverName = value.toString();
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              height: 40,
                              width: Get.width / 2.3,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                              )),
                          menuItemStyleData: const MenuItemStyleData(),
                        ),
                      ),

                    ],
                  ),
                  buildSizeBox(10.0, 0.0),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
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
                      // Flexible(
                      //     flex: 1,
                      //     fit: FlexFit.tight,
                      //     child: DefaultWidget.topCounter(
                      //         bgColor: AppColors.yetToStartColor,
                      //         label: kOnTheWay,
                      //         counter: '0',
                      //         onTap: () {
                      //
                      //         })),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DefaultWidget.topCounter(
                              bgColor: AppColors.greyColorDark,
                              label: kPickedUp,
                              counter: '0',
                              onTap: () {
                                setState(() {});
                              })),
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

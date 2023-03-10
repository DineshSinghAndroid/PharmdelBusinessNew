import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import 'package:pharmdel/Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Controller/PharmacyControllers/P_TrackOrderController/pharmacy_track_order_controller.dart';
import '../../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';

class TrackOrderScreenPharmacy extends StatefulWidget {
  const TrackOrderScreenPharmacy({Key? key}) : super(key: key);

  @override
  State<TrackOrderScreenPharmacy> createState() => _TrackOrderScreenPharmacyState();
}

class _TrackOrderScreenPharmacyState extends State<TrackOrderScreenPharmacy> {
  final PharmacyTrackOrderController _controller = Get.put(PharmacyTrackOrderController());

  @override


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PharmacyTrackOrderController>(
      init: _controller,
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppBar.appBar(
              backgroundColor: Colors.transparent,
              onTap: () {
                Get.back();
              },
              centerTitle: true,
              title: kRoute),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(strImg_PharmacyBg))),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                height: Get.height,
                child: Column(
                  children: [
                    buildSizeBox(20.0, 0.0),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
                        setState(() {
                          _controller.selectedDate = _controller.formatter.format(picked!);
                          _controller.showDatedDate = _controller.formatterShow.format(picked);

                          if (_controller.selectedDriverPosition! > 0 && _controller.selectedRouteID > 0) {}
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10, right: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0), color: Colors.white,
                          //border: Border.all(color: Colors.grey[400]),
                        ),
                        child: Row(
                          children: [
                            Text(_controller.showDatedDate),
                            const Spacer(),
                            const Icon(Icons.calendar_today_sharp),
                          ],
                        ),
                      ),
                    ),
                    buildSizeBox(20.0, 0.0),
                    if (_controller.getRouteListController.routeList.isNotEmpty)
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
                                value: _controller.getRouteListController.routeList.indexOf(route).toString(),
                                child: Text("${route.routeName}", style: const TextStyle(color: Colors.black87)),
                              ),
                          ],
                          value: _controller.getRouteListController.selectedRouteName,
                          onChanged: (value) {
                            setState(() {
                              _controller.getRouteListController.selectedRouteName = value.toString();
                            });
                            // ),
                          },
                          buttonStyleData: ButtonStyleData(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              height: 40,
                              width: Get.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              )),
                          menuItemStyleData: const MenuItemStyleData(),
                        ),
                      ),
                    buildSizeBox(20.0, 0.0),
                    if (_controller.driverListController.driverList.isNotEmpty)
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            kSelectDriver,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          onChanged: ( DriverModel? newValue) {
                            setState(() {
                              controller.driverListController.selectedDriver = newValue;
                            });
                          },

                          items: controller.driverListController.driverList.map<DropdownMenuItem<DriverModel>>((DriverModel value) {
                            return DropdownMenuItem<DriverModel>(
                              value: value,
                              child: Text(
                                value.firstName??"No Driver",style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),


                          value: controller.driverListController.selectedDriver,

                          buttonStyleData: ButtonStyleData(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              height: 40,
                              width: Get.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              )),
                          menuItemStyleData: const MenuItemStyleData(),
                        ),
                      ),


                   ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

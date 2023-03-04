import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../../Controller/PharmacyControllers/P_DriverListController/get_driver_list_controller.dart';
import '../../../Controller/PharmacyControllers/P_RouteListController/P_get_route_list_controller.dart';
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
  void initState() {
    init();
    super.initState();
  }

  Future<void> init()async{
    _controller.callGetRoutesApi(context: context);
    // _controller.callGetDriverListApi(context: context);
  }

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

                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select Route*',
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
                        value: _controller.getRouteListController.selectedRouteValue,
                        onChanged: (value) {
                          setState(() {
                            _controller.getRouteListController.selectedRouteValue = value.toString();
                          });
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
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select Route*',
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
                        value: _controller.getRouteListController.selectedRouteValue,
                        onChanged: (value) {
                          setState(() {
                            _controller.getRouteListController.selectedRouteValue = value.toString();
                          });
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
                    Spacer(),
                    MaterialButton(
                      onPressed: () {
                        GetDriverListController().getDriverList(context: context);
                      },
                      child: const Text("get driver list"),
                    ),
                    buildSizeBox(20.0, 0.0),
                    MaterialButton(
                      onPressed: () {
                        PharmacyGetRouteListController().getRoutes(context: context);
                      },
                      child: const Text("get route  list"),
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

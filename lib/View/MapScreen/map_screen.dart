import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/AppBar/app_bar.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/MapController/map_controller.dart';
import '../../Model/DriverDashboard/driver_dashboard_response.dart';

class MapScreen extends StatefulWidget {
  List<DeliveryPojoModal>? list;
  String? driverId;
  String? routeId;
  MapScreen({super.key, required this.driverId, required this.routeId,required this.list});


  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapScreenController mapCtrl = Get.put(MapScreenController());

  final Completer<GoogleMapController> mapController = Completer();


  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MapScreenController>();
    super.dispose();
  }

  Future<void> init() async {
   await mapCtrl.initCtrl(
       context: context,
       list: widget.list,
       routeID: widget.routeId,
       driverID: widget.driverId
   );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapScreenController>(
      init: mapCtrl,
      builder: (controller) {
        return Scaffold(
          appBar: AppBarCustom.appBarStyle2(
            title: kMapView,
              centerTitle: false,
              size: 18,
              titleColor: AppColors.whiteColor,
              backgroundColor: AppColors.deepOrangeColor
          ),
          body: GoogleMap(
            buildingsEnabled: true,
            compassEnabled: true,
            indoorViewEnabled: true,
            mapToolbarEnabled: true,
            myLocationButtonEnabled: true,

            mapType: MapType.normal,
            //mapToolbarEnabled: false,
            polylines: controller.polyLines,

            initialCameraPosition: CameraPosition(
                target: controller.deliveryList.isNotEmpty ?
                LatLng(double.parse(controller.deliveryList[0].customerDetials?.customerAddress?.latitude.toString() ?? "0.0"),double.parse( controller.deliveryList[0].customerDetials?.customerAddress?.longitude.toString() ?? "0.0")) :
                const LatLng(0.0, 0.0), zoom: 9),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
            markers: Set.from(controller.markers),
          ),
        );
      },
    );
  }

}

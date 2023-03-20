import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmdel/Controller/PharmacyControllers/P_TrackOrderController/pharmacy_track_order_controller.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Controller/WidgetController/StringDefine/StringDefine.dart';

class DisplayMapRoutesScreen extends StatefulWidget {
  const DisplayMapRoutesScreen({super.key});

  @override
  State<DisplayMapRoutesScreen> createState() => _DisplayMapRoutesScreenState();
}

class _DisplayMapRoutesScreenState extends State<DisplayMapRoutesScreen> {
  PharmacyTrackOrderController phrTrckOdrCtrl = Get.put(PharmacyTrackOrderController());
  Completer<GoogleMapController> mapController = Completer();

  CameraPosition? initialCameraPosition;
  LatLng startLocation = const LatLng(27.6602292, 85.308027);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: phrTrckOdrCtrl,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.materialAppThemeColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.blackColor,
              ),
            ),
            elevation: 1,
            automaticallyImplyLeading: false,
            titleSpacing: 13,
            title: BuildText.buildText(
              text: kTotalMiles,
              size: 18,
              color: AppColors.blackColor,
              weight: FontWeight.w400,
            ),
          ),

          /// Google Mao View
          body: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: startLocation, zoom: 14.0),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },                       
          ),
        );
      },
    );
  }
}

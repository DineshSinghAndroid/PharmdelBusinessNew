import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../Controller/ProjectController/AllDeliveryController/allDeliveryController.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key, required this.driverId, required this.routeId});

  String? driverId;
  String? routeId;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

AllDeliveryController allDelCtrl = Get.put(AllDeliveryController());

String? token, userId, userType;

final LatLng center = const LatLng(37.7749, -122.4194);
final Completer<GoogleMapController> mapController = Completer();
final Set<Polyline> _polyLines = {};
LatLng? endLocationLatLng;
LatLng? startLocationLatLng;


Map<String, dynamic>? mapList;
List<Marker> markers = [];
List<LatLng> polylineCoordinates = [];
List<LatLng> polylineCoordinatesAll = [];


@override
void initState() {  
  init();  
  super.initState();
  }

Future<void> init() async {
    allDelCtrl.isNetworkError = false;
    allDelCtrl.isEmpty = false;
    if (await ConnectionValidator().check()) {
      await allDelCtrl.allDeliveryApi(context: context,driverID: widget.driverId!, routeID: widget.routeId!);
    } else {
      allDelCtrl.isNetworkError = true;
      setState(() {});
    }
  }  

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        // centerTitle: true,        
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Get.back(canPop: true);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.blackColor,
          ),
        ),
        titleSpacing: 0,
        title: BuildText.buildText(
          text: kMapView,
          size: 18,
          color: AppColors.blackColor,
          weight: FontWeight.w400,          
        ),        
      ),
      body: GetBuilder<AllDeliveryController>(
      init: allDelCtrl,
      builder: (controller) {
        return GoogleMap(
        myLocationButtonEnabled: false,                
        mapType: MapType.normal,
        polylines: _polyLines,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 10.0,),
        markers: Set.from(markers),
        onMapCreated: (GoogleMapController controller){
          mapController.complete(controller);
           },
      );
      },
    ),
    );
  }

  Future<void> createPolyLineStart(PointLatLng startLat, PointLatLng endLat, int type) async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    await polylinePoints
        .getRouteBetweenCoordinates(
      WebApiConstant.GOOGLE_API_KEY, // Google Maps API Key
      startLat,
      endLat,
      travelMode: TravelMode.driving,
    ).then((value) {
      value.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        // logger.i("print1${polylineCoordinates.length}");
      });
      polylineCoordinatesAll.addAll(polylineCoordinates);
      _polyLines.add(Polyline(
        polylineId: PolylineId(startLat.toString()),
        visible: true,
        width: 5,
        points: polylineCoordinatesAll,
        color: Colors.blue,
      ));
      setState(() {});
    });
  }
}






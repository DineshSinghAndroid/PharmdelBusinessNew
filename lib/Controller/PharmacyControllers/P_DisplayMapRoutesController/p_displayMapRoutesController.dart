import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/PharmacyModels/P_DriverRoutePointsResponse/p_driverRoutePointsResponse.dart';



class PharmacyNotificationController extends GetxController{

  ApiController apiCtrl = ApiController();
  DriverRoutePointsApiResponse? driverRoutePointsData;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;


///Create Polylines 
//   createPolylines(LatLng start, LatLng destination, List<PolylineWayPoint> wayPoints, List<LatLng> latLng) async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     List<LatLng> polylineCoordinates = [];

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       WebApiConstant.GOOGLE_API_KEY, // Google Maps API Key
//       PointLatLng(start.latitude, start.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );

//     // Adding the coordinates to the list
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
    
// // Adding the polyline to the map
//     Polyline polyline = Polyline(polylineId: PolylineId(latLng.toString()), width: 4, patterns: [PatternItem.dash(90), PatternItem.gap(1)], points: polylineCoordinates, color: AppColors.blueColorLight);
//     polyline.copyWith(geodesicParam: true);
//     _polyLines.add(polyline);
//     update();
//   }
  

  ///Recieve Notification Controller
  Future<DriverRoutePointsApiResponse?> driverRoutePointsApi({required BuildContext context,required String routeId,required String date,required String driverId}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "routeId":routeId,
    "date":date,
    "driverId":driverId,
    };

    String url = WebApiConstant.GET_PHARMACY_DRIVER_ROUTE_POINTS;

    await apiCtrl.getDriverRoutePointsApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){      
          try {            
             driverRoutePointsData = result;
              driverRoutePointsData == null ? changeEmptyValue(true):changeEmptyValue(false);              
              changeLoadingValue(false);
              changeSuccessValue(true);
          } catch (_) {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


  void changeSuccessValue(bool value){
    isSuccess = value;
    update();
  }
  void changeLoadingValue(bool value){
    isLoading = value;
    update();
  }
  void changeEmptyValue(bool value){
    isEmpty = value;
    update();
  }
  void changeNetworkValue(bool value){
    isNetworkError = value;
    update();
  }
  void changeErrorValue(bool value){
    isError = value;
    update();
  }

}


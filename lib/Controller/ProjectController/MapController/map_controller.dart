import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/AllDelivery/allDeliveryApiResponse.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import 'dart:ui' as ui;
import '../../ApiController/important_keys.dart';
import '../../Helper/TimeChecker/timer_checker.dart';
import '../../WidgetController/Popup/popup.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../MainController/main_controller.dart';


class MapScreenController extends GetxController{

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  List<DeliveryPojoModal> deliveryList = [];
  String? driverId;
  String? routeId;
  AllDeliveryApiResponse? allDeliveryData;


  String? driverAddress;
  String? driverName;
  String? endRouteType;
  String? pharmacyName;
  String? pharmacyAddress;
  LatLng? startLocationLatLng;
  LatLng? endLocationLatLng;


  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  int markerCount = 0;
  String wayPram = "";
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinatesAll = [];
  final Set<Polyline> polyLines = {};

  ///  Show Alert PopUP
  Future<void> showAlertPopUp({required String msg})async{
    PopupCustom.simpleTruckDialogBox(
      context: Get.overlayContext!,
      topWidget: const Icon(Icons.error_outline,color: Colors.red,size: 40,),
      title: kAlert,
      subTitle: msg,
      btnBackTitle: "",
      btnActionTitle: kOk,
      onValue: (value){

      },

    );
  }


  /// InitState Method
  Future<void> initCtrl({required BuildContext context,required List<DeliveryPojoModal>? list,required String? driverID,required String? routeID})async{
    if (list == null) {
      deliveryList = [];
    }else{
      deliveryList.addAll(list);
    }
    driverId = driverID;
    routeId = routeID;
    PrintLog.printLog("Delivery List Length: ${deliveryList.length} ");
    await TimeCheckerCustom.checkLastTime(context: context);
    await getAllDelivery(context: context);

  }


  /// Get All Delivery Api
  Future<AllDeliveryApiResponse?> getAllDelivery({required BuildContext context}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "routeId":routeId ?? "",
      "driverId":driverId ?? ""
    };


    await apiCtrl.getAllDeliveryApi(context:Get.overlayContext!,url: WebApiConstant.GET_ALL_DELIVERY, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {
              allDeliveryData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);
              PrintLog.printLog(result.message);


              if (result.endRoutePoint != null && result.endRoutePoint?.startLat != null && result.endRoutePoint?.startLat != "null" && result.endRoutePoint?.startLat != "0" && result.endRoutePoint?.startLng != null && result.endRoutePoint?.startLng != "0" && result.endRoutePoint?.startLng != "null" ) {
                if (double.parse(result.endRoutePoint?.startLat ?? "0") > 0) {
                  startLocationLatLng = LatLng(double.parse(result.endRoutePoint?.startLat ?? "0"), double.parse(result.endRoutePoint?.startLng ?? "0"));
                  if (result.endRoutePoint?.driverName != null && result.endRoutePoint!.driverName!.isNotEmpty) {
                    driverAddress = result.endRoutePoint?.driverAddress ?? "";
                    driverName = result.endRoutePoint?.driverName ?? "";
                  }
                }
                if (double.parse(result.endRoutePoint?.endLat ?? "0") > 0 && result.endRoutePoint?.pharmacyName != null) {
                  endLocationLatLng = LatLng(double.parse(result.endRoutePoint?.endLat ?? "0"), double.parse(result.endRoutePoint?.endLng ?? "0"));
                  if (result.endRoutePoint?.driverName != null && result.endRoutePoint!.driverName!.isNotEmpty) {
                    pharmacyAddress = result.endRoutePoint?.endRouteAddress ?? "";
                    endRouteType = result.endRoutePoint?.endroutetype ?? "";
                    pharmacyName = result.endRoutePoint?.pharmacyName ?? "";
                  }
                }
              }

              PrintLog.printLog(
              "startLocationLatLng::$startLocationLatLng"
              "\ndriverAddress::$driverAddress"
              "\ndriverName::$driverName"
              "\nendLocationLatLng::$endLocationLatLng"
              "\npharmacyAddress::$pharmacyAddress"
              "\nendRouteType::$endRouteType"
              "\npharmacyName::$pharmacyName"
              );
              
                await manageRoutePackage();
             


            } else {
              showAlertPopUp(msg: result.message ?? "");
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog(result.message);
            }

          } catch (_) {
            showAlertPopUp(msg: result.message ?? "");
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog("Exception : $_");
          }
        }else{
          showAlertPopUp(msg: result.message ?? "");
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog(result.message);
        }
      }else{
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
      }
    });
    update();
  }


  Future<void> manageRoutePackage() async {
    if (startLocationLatLng != null) {
      BitmapDescriptor sourceIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.5, size: Size(60, 60)), 'assets/driver_points.png');
      InfoWindow infoWindow = InfoWindow(title: pharmacyName ?? "", snippet: pharmacyAddress ?? "");
      Marker marker = Marker(
          markerId: MarkerId(markers.length.toString()),
          // infoWindow: infoWindow,
          position: startLocationLatLng ?? const LatLng(0.0,0.0),
          // icon: i<=1 ?   BitmapDescriptor.fromBytes(markerIcon) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          icon: await getClusterMarker2("S", Colors.blue, Colors.white, 80)
      );

      markers.add(marker);
      if (deliveryList.isNotEmpty) {
        LatLng endStart1 = LatLng(double.parse(deliveryList[0].customerDetials?.customerAddress?.latitude.toString() ?? "0.0"), double.parse(deliveryList[0].customerDetials?.customerAddress?.longitude.toString() ?? "0.0"));
        PointLatLng startLate = PointLatLng(startLocationLatLng?.latitude ?? 0.0, startLocationLatLng?.longitude ?? 0.0);
        PointLatLng endStart = PointLatLng(endStart1.latitude, endStart1.longitude);
        await createPolyLineStart(startLate, endStart, 1);
      }
    }
    if (deliveryList.isNotEmpty) {
      LatLng startLat = LatLng(double.parse(deliveryList[0].customerDetials?.customerAddress?.latitude.toString() ?? "0.0"), double.parse(deliveryList[0].customerDetials?.customerAddress?.longitude.toString() ?? "0.0"));

      LatLng lastLat = LatLng(double.parse(deliveryList[0].customerDetials?.customerAddress?.latitude.toString() ?? "0.0"), double.parse(deliveryList[0].customerDetials?.customerAddress?.longitude.toString() ?? "0.0"));
      if (deliveryList.length > 24) {
        double packageCount = deliveryList.length / 24;
        for (int i = 0; i < packageCount.toInt(); i++) {
          if (i != 0) startLat = lastLat;

          List<DeliveryPojoModal> route = [];
          for (int j = i * 24; j < i * 24 + 24; j++) {
            DeliveryPojoModal lng = deliveryList[j];
            route.add(lng);
            lastLat = LatLng(double.parse(lng.customerDetials?.customerAddress?.latitude.toString() ?? "0.0"), double.parse(lng.customerDetials?.customerAddress?.longitude.toString() ?? "0.0"));
          }
          await addMarkers(PointLatLng(startLat.latitude, startLat.longitude), route);
        }
        startLat = lastLat;
        List<DeliveryPojoModal> route = [];
        for (int i = packageCount.toInt() * 24; i < deliveryList.length; i++) {
          DeliveryPojoModal lng = deliveryList[i];
          route.add(lng);
        }
        await addMarkers(PointLatLng(startLat.latitude, startLat.longitude), route);
      } else {
        await addMarkers(PointLatLng(startLat.latitude, startLat.longitude), deliveryList);
      }
    }

    if (endLocationLatLng != null) {
      InfoWindow infoWindow;
      if (endRouteType == "pharmacy") {
        infoWindow = InfoWindow(title: pharmacyName ?? "", snippet: pharmacyAddress ?? "");
      } else {
        infoWindow = InfoWindow(title: driverName ?? "", snippet: driverAddress ?? "");
      }
      Marker marker = Marker(
        markerId: MarkerId(markers.length.toString()),
        infoWindow: infoWindow,
        position: endLocationLatLng ?? const LatLng(0.0, 0.0),
      );

      markers.add(marker);

      if (deliveryList.isNotEmpty) {
        LatLng endStart1 = LatLng(double.parse(deliveryList.last.customerDetials?.customerAddress?.latitude.toString() ?? "0.0"),double.parse( deliveryList.last.customerDetials?.customerAddress?.longitude.toString() ?? "0.0"));
        PointLatLng startLate = PointLatLng(endLocationLatLng?.latitude ?? 0.0, endLocationLatLng?.longitude ?? 0.0);
        PointLatLng endStart = PointLatLng(endStart1.latitude, endStart1.longitude);
        await createPolyLineStart(endStart, startLate, 2);
      }
      // _latLng.add(latLng);
    }
  }

  Future<void> createPolyLineStart(PointLatLng startLat, PointLatLng endLat, int type) async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    await polylinePoints
        .getRouteBetweenCoordinates(
      ImportantKey.GOOGLE_API_KEY,
      startLat,
      endLat,
      travelMode: TravelMode.driving,
    ).then((value) {
      value.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        // PrintLog.printLog("print1${polylineCoordinates.length}");
      });
      polylineCoordinatesAll.addAll(polylineCoordinates);
      polyLines.add(Polyline(
        polylineId: PolylineId(startLat.toString()),
        visible: true,
        width: 5,
        points: polylineCoordinatesAll,
        color: Colors.blue,
      ));

      update();
    });
  }

  Future<void> addMarkers(PointLatLng startLat, List<DeliveryPojoModal> driverDelivery) async {
    List<PolylineWayPoint> wayPoints = [];
    List<LatLng> _latLng = [];
    for (DeliveryPojoModal routeList in driverDelivery) {
      try {
        _latLng.add(LatLng(double.parse(routeList.customerDetials?.customerAddress?.latitude.toString() ?? "0.0"), double.parse(routeList.customerDetials?.customerAddress?.longitude.toString() ?? "0.0")));
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        PrintLog.printLog("Exception during add lat long : $e");
      }
    }
    for (int i = 0; i < _latLng.length; i++) {
      if (driverDelivery[i].deliveryStatus == 4) {
        markerCount++;
      }
      LatLng latLng = _latLng[i];

      wayPoints.add(PolylineWayPoint(location: "${latLng.latitude},${latLng.longitude}"));
      wayPram += "${latLng.latitude},${latLng.longitude}";

      InfoWindow infoWindow = InfoWindow(
          title: "${driverDelivery[i].customerDetials?.title ?? ""}"
              " ${driverDelivery[i].customerDetials?.firstName ?? ""} "
              "${driverDelivery[i].customerDetials?.middleName ?? ""} "
              "${driverDelivery[i].customerDetials?.lastName ?? ""}",
          snippet: driverDelivery[i].customerDetials?.customerAddress?.address1 ?? driverDelivery[i].customerDetials?.customerAddress?.address2 ?? "");
      Marker marker = Marker(
          markerId: MarkerId(markers.length.toString()),
          infoWindow: infoWindow,
          position: latLng,
          // icon: i<=1 ?   BitmapDescriptor.fromBytes(markerIcon) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          icon: await getClusterMarker(
              driverDelivery[i].deliveryStatus == 5
                  ? "D"
                  : driverDelivery[i].deliveryStatus == 4
                  ? markerCount
                  : driverDelivery[i].deliveryStatus == 1 || driverDelivery[i].deliveryStatus == 2 || driverDelivery[i].deliveryStatus == 3
                  ? "R"
                  : driverDelivery[i].deliveryStatus == 6
                  ? "F"
                  : "D",
              driverDelivery[i].deliveryStatus == 5
                  ? Colors.green
                  : driverDelivery[i].deliveryStatus == 4
                  ? Colors.orange
                  : driverDelivery[i].deliveryStatus == 1 || driverDelivery[i].deliveryStatus == 2 || driverDelivery[i].deliveryStatus == 3
                  ? Colors.blueAccent
                  : driverDelivery[i].deliveryStatus == 8
                  ? Colors.grey
                  : driverDelivery[i].deliveryStatus == 6
                  ? Colors.red
                  : Colors.deepOrangeAccent,
              Colors.white,
              80));

        markers.add(marker);
      update();
    }
    // print(_latLng);
    // widget.pharmacyRouteList.clear();
    if (_latLng.isNotEmpty) {
      polylineCoordinates.clear();
      PolylinePoints polylinePoints = PolylinePoints();
      await polylinePoints
          .getRouteBetweenCoordinates(
        ImportantKey.GOOGLE_API_KEY,
        startLat,
        PointLatLng(_latLng[_latLng.length - 1].latitude, _latLng[_latLng.length - 1].longitude),
        wayPoints: wayPoints,
        travelMode: TravelMode.driving,
      ).then((value) {
        value.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        polylineCoordinatesAll.addAll(polylineCoordinates);
        polyLines.add(Polyline(
          polylineId: PolylineId(_latLng.toString()),
          visible: true,
          width: 5,
          points: polylineCoordinatesAll,
          color: Colors.blue,
        ));
        update();
      });
    }
  }


  Future<BitmapDescriptor> getClusterMarker2(
      dynamic clusterSize,
      Color clusterColor,
      Color textColor,
      int width,
      ) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = width / 2;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );
    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );
    final image = await pictureRecorder.endRecording().toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> getClusterMarker(
      dynamic clusterSize,
      Color clusterColor,
      Color textColor,
      int width,
      ) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = width / 2;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );
    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );
    final image = await pictureRecorder.endRecording().toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );
    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
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


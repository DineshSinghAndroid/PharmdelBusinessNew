// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/delivery_pojo_model.dart';
import 'package:pharmdel_business/model/driver_dashboard_model.dart';
import 'package:pharmdel_business/util/CustomDialogBox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../collect_order.dart';
import '../login_screen.dart';
import '../splash_screen.dart';

class RouteMaker extends StatefulWidget {
  List<DeliveryPojoModal> deliveryList = [];
  String driverId;
  String routeId;

  RouteMaker({this.deliveryList, this.driverId, this.routeId});

  StateRouteMaker createState() => StateRouteMaker();
}

class StateRouteMaker extends State<RouteMaker> {
//LatLng(24.9286825, 67.0403249),
//     LatLng(24.985577, 67.0661056)
  String token, userId, userType;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = [];

  //List<LatLng> _latLng =[];
  final Set<Polyline> _polyLines = {};

  //PolylinePoints polylinePoints;
  //List<LatLng> polylineCoordinates = [];
  //List<PolylineWayPoint> wayPoints =[];
  String wayPram = "";
  int markerCount = 0;
  BitmapDescriptor deliverdIcon;

  List<LatLng> polylineCoordinates = [];

  List<LatLng> polylineCoordinatesAll = [];

  ApiCallFram _apiCallFram = new ApiCallFram();

  LatLng _endLocationLatLng;
  LatLng _startLocationLatLng;

  DriverDashBoardModal _responseModel;

  Map<String, dynamic> mapList;

  List<DeliveryPojoModal> deliveryList;

  var driverAddress;
  var driverName;
  String endRouteType;
  String pharmacyName;
  String pharmacyAddress;

  @override
  void initState() {
    super.initState();
    if (widget.deliveryList == null) widget.deliveryList = [];
    checkLastTime(context);
    /*for(DeliveryPojoModal delivery in widget.deliveryList){
      try{
        _latLng.add(LatLng(delivery.customerDetials.customerAddress.latitude,delivery.customerDetials.customerAddress.longitude));
        //_latLng.add(LatLng(26.9124, 75.7873));
      }catch(e){
        logger.i("Exception during add lat long : $e");
      }

    }*/
    getUserData();
  }

  void manageRoutePackage() async {
    if (_startLocationLatLng != null) {
      BitmapDescriptor sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5, size: Size(60, 60)), 'assets/driver_points.png');
      InfoWindow infoWindow = InfoWindow(title: pharmacyName ?? "", snippet: pharmacyAddress ?? "");
      Marker marker = Marker(
          markerId: MarkerId(_markers.length.toString()),
          // infoWindow: infoWindow,
          position: _startLocationLatLng,
          // icon: i<=1 ?   BitmapDescriptor.fromBytes(markerIcon) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          icon: await getClusterMarker2("S", Colors.blue, Colors.white, 80));

      _markers.add(marker);
      // _latLng.add(latLng);
      if (widget.deliveryList != null && widget.deliveryList.length > 0) {
        LatLng endStart1 = LatLng(widget.deliveryList[0].customerDetials.customerAddress.latitude ?? 0.0, widget.deliveryList[0].customerDetials.customerAddress.longitude ?? 0.0);
        PointLatLng startLate = PointLatLng(_startLocationLatLng.latitude, _startLocationLatLng.longitude);
        PointLatLng endStart = PointLatLng(endStart1.latitude, endStart1.longitude);
        await createPolyLineStart(startLate, endStart, 1);
      }
    }
    if (widget.deliveryList != null && widget.deliveryList.length > 0) {
      LatLng startLat = LatLng(widget.deliveryList[0].customerDetials.customerAddress.latitude ?? 0.0, widget.deliveryList[0].customerDetials.customerAddress.longitude ?? 0.0);

      LatLng lastLat = LatLng(widget.deliveryList[0].customerDetials.customerAddress.latitude ?? 0.0, widget.deliveryList[0].customerDetials.customerAddress.longitude ?? 0.0);
      if (widget.deliveryList.length > 24) {
        double packageCount = widget.deliveryList.length / 24;
        for (int i = 0; i < packageCount.toInt(); i++) {
          if (i != 0) startLat = lastLat;

          List<DeliveryPojoModal> route = [];
          for (int j = i * 24; j < i * 24 + 24; j++) {
            DeliveryPojoModal lng = widget.deliveryList[j];
            route.add(lng);
            lastLat = LatLng(lng.customerDetials.customerAddress.latitude ?? 0.0, lng.customerDetials.customerAddress.longitude ?? 0.0);
          }
          await addMarkers(PointLatLng(startLat.latitude, startLat.longitude), route);
        }
        startLat = lastLat;
        List<DeliveryPojoModal> route = [];
        for (int i = packageCount.toInt() * 24; i < widget.deliveryList.length; i++) {
          DeliveryPojoModal lng = widget.deliveryList[i];
          route.add(lng);
        }
        await addMarkers(PointLatLng(startLat.latitude, startLat.longitude), route);
      } else {
        await addMarkers(PointLatLng(startLat.latitude, startLat.longitude), widget.deliveryList);
      }
    }

    if (_endLocationLatLng != null) {
      InfoWindow infoWindow;
      if (endRouteType == "pharmacy") {
        infoWindow = InfoWindow(title: pharmacyName ?? "", snippet: pharmacyAddress ?? "");
      } else {
        infoWindow = InfoWindow(title: driverName ?? "", snippet: driverAddress ?? "");
      }
      Marker marker = Marker(
        markerId: MarkerId(_markers.length.toString()),
        infoWindow: infoWindow,
        position: _endLocationLatLng,
        // icon: i<=1 ?   BitmapDescriptor.fromBytes(markerIcon) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        // icon: await getClusterMarker2(
        //     "P", Colors.blue, Colors.white, 80)
      );

      // Marker marker = Marker(
      //   markerId: MarkerId(_markers.length.toString()),
      //   infoWindow: infoWindow,
      //   position: ,
      //
      //   icon: BitmapDescriptor.defaultMarkerWithHue(
      //       BitmapDescriptor.hueOrange),
      //
      //   // icon: markderCoutn == 0
      //   //     ? BitmapDescriptor.defaultMarkerWithHue(
      //   //     BitmapDescriptor.hueOrange)
      //   //     : await getClusterMarker(
      //   //     "E", Colors.red, Colors.white, 80),
      // );
      _markers.add(marker);

      if (widget.deliveryList != null && widget.deliveryList.length > 0) {
        LatLng endStart1 = LatLng(widget.deliveryList.last.customerDetials.customerAddress.latitude ?? 0.0, widget.deliveryList.last.customerDetials.customerAddress.longitude ?? 0.0);
        PointLatLng startLate = PointLatLng(_endLocationLatLng.latitude, _endLocationLatLng.longitude);
        PointLatLng endStart = PointLatLng(endStart1.latitude, endStart1.longitude);
        await createPolyLineStart(endStart, startLate, 2);
      }
      // _latLng.add(latLng);
    }
  }

  Future<void> addMarkers(PointLatLng startLat, List<DeliveryPojoModal> driverDelivery) async {
    List<PolylineWayPoint> wayPoints = [];
    List<LatLng> _latLng = [];
    for (DeliveryPojoModal routeList in driverDelivery) {
      // if (routeList.kmtom != 0){
      try {
        // print(routeList.customerDetials.customerAddress.latitude);

        _latLng.add(LatLng(routeList.customerDetials.customerAddress.latitude ?? 0.0, routeList.customerDetials.customerAddress.longitude ?? 0.0));
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // logger.i("Exception during add lat long : $e");
      }
      //}
    }
    for (int i = 0; i < _latLng.length; i++) {
      if (driverDelivery[i].deliveryStatus == 4) markerCount++;
      LatLng latLng = _latLng[i];
      //if(i == 0){
      wayPoints.add(PolylineWayPoint(location: "${latLng.latitude},${latLng.longitude}"));
      wayPram += "${latLng.latitude},${latLng.longitude}";
      // }
      InfoWindow infoWindow = InfoWindow(
          title: "${driverDelivery[i].customerDetials.title ?? ""}"
              " ${driverDelivery[i].customerDetials.firstName ?? ""} "
              "${driverDelivery[i].customerDetials.middleName ?? ""} "
              "${driverDelivery[i].customerDetials.lastName ?? ""}",
          snippet: "${driverDelivery[i].customerDetials.customerAddress.address1 ?? driverDelivery[i].customerDetials.customerAddress.address2 ?? ""}");
      Marker marker = Marker(
          markerId: MarkerId(_markers.length.toString()),
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
      setState(() {
        _markers.add(marker);
      });
    }
    // print(_latLng);
    // widget.pharmacyRouteList.clear();
    if (_latLng.length > 0) {
      polylineCoordinates.clear();
      PolylinePoints polylinePoints = PolylinePoints();
      await polylinePoints
          .getRouteBetweenCoordinates(
        WebConstant.GOOGLE_API_KEY, // Google Maps API Key
        startLat,
        PointLatLng(_latLng[_latLng.length - 1].latitude, _latLng[_latLng.length - 1].longitude),
        wayPoints: wayPoints,
        travelMode: TravelMode.driving,
      )
          .then((value) {
        value.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          // logger.i("print1${polylineCoordinates.length}");
        });
        polylineCoordinatesAll.addAll(polylineCoordinates);
        _polyLines.add(Polyline(
          polylineId: PolylineId(_latLng.toString()),
          visible: true,
          width: 5,
          points: polylineCoordinatesAll,
          color: Colors.blue,
        ));
        setState(() {});
      });
      // _polyLines.add(Polyline(
      //   polylineId: PolylineId(_lastMapPosition.toString()),
      //   visible: true,
      //   width: 5,
      //   patterns: [PatternItem.dash(50), PatternItem.gap(5)],
      //   //latlng is List<LatLng>
      //   points: _latLng,
      //   color: Colors.blue,
      // ));
      //   _createPolylines(_latLng[0], _latLng.last,wayPoints,_latLng);

    }
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
    // await CustomLoading().showLoadingDialog(context, true);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  _createPolylines(LatLng start, LatLng destination, List<PolylineWayPoint> wayPoints, List<LatLng> _latLng) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      WebConstant.GOOGLE_API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      wayPoints: wayPoints,
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // logger.i("${result.points}");
// Adding the polyline to the map
    Polyline polyline = Polyline(polylineId: PolylineId(_latLng.toString()), width: 5, patterns: [PatternItem.dash(90), PatternItem.gap(1)], points: polylineCoordinates, color: Colors.lightBlue);
    polyline.copyWith(geodesicParam: true);
    _polyLines.add(polyline);
    setState(() {});
    //Timer.periodic(Duration(seconds: 1), (Timer t) => streamData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          "Map View",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[],
      ),
      body: Center(
        child: Container(
          child: GoogleMap(
            mapType: MapType.normal,
            //mapToolbarEnabled: false,
            polylines: _polyLines,
            initialCameraPosition: CameraPosition(target: widget.deliveryList.length > 0 ? LatLng(widget.deliveryList[0].customerDetials.customerAddress.latitude ?? 0.0, widget.deliveryList[0].customerDetials.customerAddress.longitude ?? 0.0) : LatLng(0.0, 0.0), zoom: 9),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set.from(_markers),
          ),
        ),
      ),
    );
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
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(String title) async {
    TextSpan span = new TextSpan(
      style: new TextStyle(
        color: Colors.orange,
      ),
      text: title,
    );

    TextPainter tp = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.text = TextSpan(
      text: title,
      style: TextStyle(
        fontSize: 35.0,
        color: Theme.of(context).accentColor,
        letterSpacing: 1.0,
        fontFamily: 'Roboto Bold',
      ),
    );

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas c = new Canvas(recorder);

    tp.layout();
    tp.paint(c, new Offset(20.0, 10.0));

    /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

    ui.Picture p = recorder.endRecording();
    ByteData pngBytes = await (await p.toImage(tp.width.toInt() + 40, tp.height.toInt() + 20)).toByteData(format: ui.ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes.buffer);

    return BitmapDescriptor.fromBytes(data);
  }

  Future<void> getDriverMarker() async {
    // print(widget.routeId);
    // List<LatLng>_latLng = [];
    String prams = "${WebConstant.GETALLDELIVERY}" + "?routeId=${widget.routeId}&driverId=${widget.driverId}";
    // "?routeId=${widget.routeId}&date=${WebConstant.formate.format(DateTime.now())}&driverId=${widget.driverId}";
    logger.i(prams);
    logger.i(token);
    _apiCallFram.getDataRequestAPI(prams, token, context).then((response) async {
      logger.i(response.body);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          Fluttertoast.showToast(msg: "Authentication Failed. Login again");
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          prefs.remove('userId');
          prefs.remove('name');
          prefs.remove('email');
          prefs.remove('mobile');
          prefs.remove('route_list');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              ModalRoute.withName('/login_screen'));
          return;
        }
        if (response != null && response.body != null) {
          mapList = json.decode(response.body);
          if (json.decode(response.body)["error"] != null && json.decode(response.body)["error"] == true) {
            showAleartRouteStarted(json.decode(response.body)["message"] != null ? json.decode(response.body)["message"] : WebConstant.ERRORMESSAGE);
          } else {
            widget.deliveryList = List<DeliveryPojoModal>.from(mapList["deliveryList"].map((x) => DeliveryPojoModal.fromJson(x)));
            // end route location marker
            if (mapList != null && mapList.isNotEmpty) {
              Map<dynamic, dynamic> dd = mapList;
              logger.i(mapList);
              logger.i(dd["endRoutePoint"]);
              if (dd != null && dd["endRoutePoint"] != null && dd["endRoutePoint"]["start_lat"] != 0 && dd["endRoutePoint"]["start_lng"] != 0) {
                if (dd["endRoutePoint"]["start_lat"] > 0) {
                  _startLocationLatLng = LatLng(dd["endRoutePoint"]["start_lat"], dd["endRoutePoint"]["start_lng"]);
                  if (dd["endRoutePoint"]["driver_name"] != null && dd["endRoutePoint"]["driver_name"].toString().isNotEmpty) {
                    driverAddress = dd["endRoutePoint"]["driver_address"].toString();
                    driverName = dd["endRoutePoint"]["driver_name"].toString();
                  }
                }
                if (dd["endRoutePoint"]["end_lat"] > 0 && dd["endRoutePoint"]["pharmacy_name"] != null) {
                  _endLocationLatLng = LatLng(dd["endRoutePoint"]["end_lat"], dd["endRoutePoint"]["end_lng"]);
                  if (dd["endRoutePoint"]["driver_name"] != null && dd["endRoutePoint"]["driver_name"].toString().isNotEmpty) {
                    pharmacyAddress = dd["endRoutePoint"]["end_route_address"].toString();
                    endRouteType = dd["endRoutePoint"]["endroutetype"].toString();
                    pharmacyName = dd["endRoutePoint"]["pharmacy_name"].toString();
                  }
                }
              }
            }

            logger.i(_endLocationLatLng);
            if (response != null) {
              manageRoutePackage();
            }
          }
        } else {
          showAleartRouteStarted(WebConstant.ERRORMESSAGE);
        }
      } catch (exp, stackTrace) {
        // print(exp);
        SentryExemption.sentryExemption(exp, stackTrace);
        logger.i(exp);
        showAleartRouteStarted(WebConstant.ERRORMESSAGE);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
    // getDistanceAndTime();
  }

  void showAleartRouteStarted(String message) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return CustomDialogBox(
            icon: Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
            title: "Alert...",
            btnDone: "Ok",
            onClicked: onClick,
            descriptions: message,
          );
        });
  }

  void onClick(bool value) {
    Navigator.pop(context);
    // logger.i("testttttttt");
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    getDriverMarker();
  }

  Future<void> createPolyLineStart(PointLatLng startLat, PointLatLng endLat, int type) async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    await polylinePoints
        .getRouteBetweenCoordinates(
      WebConstant.GOOGLE_API_KEY, // Google Maps API Key
      startLat,
      endLat,
      travelMode: TravelMode.driving,
    )
        .then((value) {
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
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}

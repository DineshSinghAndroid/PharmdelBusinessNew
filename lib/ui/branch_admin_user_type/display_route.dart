// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/driver_point_model.dart';
import 'package:pharmdel_business/model/route_for_pharmacy.dart';
import 'package:pharmdel_business/model/update_location.dart';
import 'package:pharmdel_business/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../util/CustomDialogBox.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../collect_order.dart';
import '../login_screen.dart';
import '../splash_screen.dart';

class DisplayRoute extends StatefulWidget {
  // List<RouteForPharmacy> pharmacyRouteList;
  int routeId;
  int driverId;
  String selectedDate;
  bool isToday = false;

  DisplayRoute(this.routeId, this.driverId, this.selectedDate, this.isToday);

  @override
  StateDisplayRoute createState() => StateDisplayRoute();
}

class StateDisplayRoute extends State<DisplayRoute> {
  String token, userId, userType;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;

  Set<Marker> _markers = Set();

  Set<Polyline> _polyLines = {};
  String wayPram = "";
  GoogleMap mapView;

  BitmapDescriptor deliverdIcon;

  // UpdateLocation updatedLatLng;
  List<UpdateLocation> updatedLatLng = [];

  // var channel;

  List<DriverRoutePointList> driverRoutePointList = [];
  ApiCallFram _apiCallFram = new ApiCallFram();
  int markerCount = -1;
  double totalDistance = 0.0;

  static const LatLng _center = const LatLng(33.738045, 73.084488);
  CameraPosition initialCameraPosition;

//add your lat and lng where you wants to draw polyline
  LatLng _lastMapPosition = _center;
  LatLng _endLocationLatLng;
  bool isLoading = true;
  List<LatLng> polylineCoordinatesAll = [];

  bool routeStarted = false;
  BuildContext _buildContext;

//   List<LatLng> latlng = List();
//   LatLng _new = LatLng(33.738045, 73.084488);
//   LatLng _news = LatLng(33.567997728, 72.635997456);

  @override
  void initState() {
    super.initState();
    // print(widget.pharmacyRouteList.length);

    checkLastTime(context);
    getUserData();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    setState(() {
      userType = prefs.getString(WebConstant.USER_TYPE) ?? "";
    });

    getDriverMarker();
  }

  @override
  void dispose() {
    // channel.sink.close();
    super.dispose();
  }

  Future<void> addMarkers(List<RouteForPharmacy> pharmacyRouteList) async {
    if (markerCount > 0) markerCount--;
    //_latLng.clear();

    List<PolylineWayPoint> wayPoints = [];
    List<LatLng> _latLng = [];

    for (RouteForPharmacy routeList in pharmacyRouteList) {
      // if (routeList.kmtom != 0){
      try {
        double lat = routeList.latitude;
        double long = routeList.longitude;
        _latLng.add(LatLng(lat, long));
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // logger.i("Exception during add lat long : $e");
      }
      //}
    }
    for (int i = 0; i < _latLng.length; i++) {
      markerCount++;
      LatLng latLng = _latLng[i];

      //if(i == 0){
      wayPoints.add(PolylineWayPoint(location: "${latLng.latitude},${latLng.longitude}"));
      wayPram += "${latLng.latitude},${latLng.longitude}";
      // }
      String name = pharmacyRouteList[i].customerName;
      InfoWindow infoWindow = InfoWindow(
          title: name,
          snippet: pharmacyRouteList[i].deliveryStatus == 3
              ? pharmacyRouteList[i].completeTime != null
                  ? "Delivered at " + pharmacyRouteList[i].completeTime
                  : ""
              : "${pharmacyRouteList[i].customerAddress}");
      Marker marker = Marker(
        markerId: MarkerId(_markers.length.toString()),
        infoWindow: infoWindow,
        position: latLng,
        // icon: i<=1 ?   BitmapDescriptor.fromBytes(markerIcon) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        icon: markerCount == 0
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
            : await getClusterMarker(
                markerCount,
                pharmacyRouteList[i].deliveryStatus == 3
                    ? Colors.green
                    : pharmacyRouteList[i].deliveryStatus == 4
                        ? Colors.red
                        : pharmacyRouteList[i].deliveryStatus == 7
                            ? Colors.blueAccent
                            : Colors.deepOrangeAccent,
                Colors.white,
                80),
      );

      setState(() {
        _markers.add(marker);
      });
    }
    // print(_latLng);
    // widget.pharmacyRouteList.clear();
    if (_latLng.length > 0) {
      // _createPolylines(_latLng1[0], _latLng1.last,wayPoints);
      _createPolylines(_latLng[0], _latLng.last, wayPoints, _latLng);
      //_latLng.clear();

    }
    // ProgressDialog(context).hide();
    await CustomLoading().showLoadingDialog(context, false);
  }

  Future<BitmapDescriptor> getClusterMarker(
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  _createPolylines(LatLng start, LatLng destination, List<PolylineWayPoint> wayPoints, List<LatLng> _latLng) async {
    // Initializing PolylinePoints
    //polylineCoordinates.remove(true);

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      WebConstant.GOOGLE_API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      // wayPoints:wayPoints,
      // travelMode: TravelMode.bicycling,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // logger.i("${result.points}");
// Adding the polyline to the map
    Polyline polyline = Polyline(polylineId: PolylineId(_latLng.toString()), width: 4, patterns: [PatternItem.dash(90), PatternItem.gap(1)], points: polylineCoordinates, color: Colors.lightBlue);
    polyline.copyWith(geodesicParam: true);
    _polyLines.add(polyline);
    setState(() {});
  }

  _createDriverPolylines(List<dynamic> dd) async {
    List<LatLng> polylineCoordinates = [];
    if (dd != null && dd.length > 0) {
      logger.i("test2");
      dd.forEach((value) {
        if (value["latitude"] != null && value["longitude"] != null && double.tryParse(value["latitude"].toString()) > 0) {
          polylineCoordinates.add(LatLng(double.tryParse(value["latitude"].toString()), double.tryParse(value["longitude"].toString())));
        }
      });
      logger.i("test3");
      if (polylineCoordinates.isNotEmpty && polylineCoordinates.length > 0) {
        logger.i("test4  ${polylineCoordinates.length}");
        Polyline polyline = Polyline(polylineId: PolylineId(polylineCoordinates.toString()), width: 4, patterns: [PatternItem.dash(90), PatternItem.gap(1)], points: polylineCoordinates, color: Colors.red);
        polyline.copyWith(geodesicParam: true);
        _polyLines.add(polyline);
        setState(() {});
      }
    } else {
      logger.i("empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: materialAppThemeColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: appBarTextColor,
          ),
        ),
        elevation: 1,
        automaticallyImplyLeading: false,
        titleSpacing: 13,
        title: Text(
          "Total Miles ${totalDistance.round()}",
          style: TextStyle(color: appBarTextColor, fontWeight: FontWeight.w400),
        ),
      ),
      body: Stack(
        children: <Widget>[
          (driverRoutePointList != null && driverRoutePointList.length > 0 && initialCameraPosition != null)
              ? GoogleMap(
                  mapType: MapType.normal,
                  //mapToolbarEnabled: false,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  polylines: _polyLines,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers,
                )
              : Align(alignment: Alignment.center, child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Future<void> getDriverMarker() async {
    // print(widget.routeId);
    // List<LatLng>_latLng = [];
    String prams = "${WebConstant.GET_DRIVER_POINTS}" + "?routeId=${widget.routeId}&date=${widget.selectedDate}&driverId=${widget.driverId}";
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
          if (json.decode(response.body)["error"] != null && json.decode(response.body)["error"] == true) {
            showAleartRouteStarted(json.decode(response.body)["message"] != null ? json.decode(response.body)["message"] : WebConstant.ERRORMESSAGE);
          } else {
            DriverPointsModel modal = driverPointsModelFromJson(response.body);
            String driverAddress;
            String driverName;
            // end route location marker
            if (response.body != null && response.body.isNotEmpty) {
              Map<dynamic, dynamic> dd = json.decode(response.body);
              logger.i(dd["endRoutePoint"]);
              if (dd != null && dd["endRoutePoint"] != null && dd["endRoutePoint"]["lat"] != 0 && dd["endRoutePoint"]["lng"] != 0) {
                logger.i(dd["endRoutePoint"]["lat"]);
                if (dd["endRoutePoint"]["lat"] > 0) {
                  logger.i("Location getting");
                  _endLocationLatLng = LatLng(dd["endRoutePoint"]["lat"], dd["endRoutePoint"]["lng"]);
                  if (dd["endRoutePoint"]["driver_name"] != null && dd["endRoutePoint"]["driver_name"].toString().isNotEmpty) {
                    driverAddress = dd["endRoutePoint"]["end_route_address"].toString();
                    driverName = dd["endRoutePoint"]["driver_name"].toString();
                    logger.i("Name Added");
                  }
                }
              }
              if (dd["driverRouteLocations"] != null) {
                logger.i("test1");
                _createDriverPolylines(dd["driverRouteLocations"]);
              }
            }
            logger.i(_endLocationLatLng);
            if (modal != null) {
              driverRoutePointList.addAll(modal.driverRoutePointList);
              routeStarted = modal.routeStarted;
              int markderCoutn = 1;
              //Pharmacy Markder
              if (modal.latitude > 0) {
                _lastMapPosition = LatLng(modal.latitude, modal.longitude);
                initialCameraPosition = CameraPosition(
                  target: _lastMapPosition,
                  zoom: 8,
                );
                var lat = modal.latitude;
                var lng = modal.longitude;
                var latLng = LatLng(lat, lng);
                String name = modal.title;
                InfoWindow infoWindow = InfoWindow(title: name, snippet: modal.address);

                Marker marker = Marker(
                  markerId: MarkerId(_markers.length.toString()),
                  infoWindow: infoWindow,
                  position: latLng,
                  icon: markderCoutn == 0 ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange) : await getClusterMarker("P", Colors.blueAccent, Colors.white, 80),
                );
                _markers.add(marker);
                // _latLng.add(latLng);
              }
              //End Location Marker
              if (_endLocationLatLng != null) {
                InfoWindow infoWindow = InfoWindow(title: driverName ?? "", snippet: driverAddress ?? "");
                Marker marker = Marker(
                  markerId: MarkerId(_markers.length.toString()),
                  infoWindow: infoWindow,
                  position: _endLocationLatLng,
                  // icon: markderCoutn == 0
                  //     ? BitmapDescriptor.defaultMarkerWithHue(
                  //     BitmapDescriptor.hueOrange)
                  //     : await getClusterMarker(
                  //     "E", Colors.red, Colors.white, 80),
                );
                _markers.add(marker);
                // _latLng.add(latLng);
              }

              for (int i = 0; i < driverRoutePointList.length; i++) {
                if (driverRoutePointList[i].orderId == 0) {
                  var lat = double.parse("${driverRoutePointList[i].latitude}");
                  var lng = double.parse("${driverRoutePointList[i].longitude}");
                  String time = driverRoutePointList[i].breakTimeFrom + " to " + driverRoutePointList[i].breakTimeTo;
                  InfoWindow infoWindow = InfoWindow(title: "$time", snippet: "${driverRoutePointList[i].diffToFrom ?? ""}");
                  BitmapDescriptor sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5, size: Size(60, 60)), 'assets/driver_points.png');
                  var pinPosition = LatLng(lat, lng);
                  _markers.add(Marker(
                    markerId: MarkerId("break point" + _markers.length.toString()),
                    position: pinPosition,
                    infoWindow: infoWindow,
                    icon: sourceIcon,
                  ));
                } else {
                  if (driverRoutePointList[i].latitude > 0) {
                    var lat = driverRoutePointList[i].latitude;
                    var lng = driverRoutePointList[i].longitude;
                    var latLng = LatLng(lat, lng);
                    String name = driverRoutePointList[i].customerName;
                    InfoWindow infoWindow = InfoWindow(
                        title: name,
                        snippet: driverRoutePointList[i].deliveryStatus == 3
                            ? driverRoutePointList[i].completeTime != null
                                ? "Delivered at " + driverRoutePointList[i].completeTime
                                : ""
                            : "${driverRoutePointList[i].customerAddress}");

                    Marker marker = Marker(
                      markerId: MarkerId(_markers.length.toString()),
                      infoWindow: infoWindow,
                      position: latLng,
                      // icon: i<=1 ?   BitmapDescriptor.fromBytes(markerIcon) : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                      icon: markderCoutn == 0
                          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
                          : await getClusterMarker(
                              markderCoutn,
                              driverRoutePointList[i].deliveryStatus == 4
                                  ? Colors.yellow[700]
                                  : driverRoutePointList[i].deliveryStatus == 5
                                      ? Colors.green
                                      : driverRoutePointList[i].deliveryStatus == 6
                                          ? Colors.red
                                          : driverRoutePointList[i].deliveryStatus == 9
                                              ? Colors.grey
                                              : driverRoutePointList[i].deliveryStatus == 1 || driverRoutePointList[i].deliveryStatus == 2 || driverRoutePointList[i].deliveryStatus == 3
                                                  ? Colors.blueAccent
                                                  : Colors.deepOrangeAccent,
                              Colors.white,
                              80),
                    );
                    markderCoutn++;
                    _markers.add(marker);
                    // _latLng.add(latLng);
                  }
                }
              }
              // if routeStarted == true show the route else not showing
              if (widget.isToday) {
                List<LatLng> _latLng = [];
                List<PolylineWayPoint> _WayPoints = [];
                // print(driverRoutePointList.length);
                var lat = modal.latitude;
                var lng1 = modal.longitude;
                LatLng lng = LatLng(lat, lng1);

                _latLng.add(lng);

                // await addMarkers(driverRoutePointList);
                if (driverRoutePointList.length > 24) {
                  double packageCounte = driverRoutePointList.length / 24;
                  for (int i = 0; i < packageCounte.toInt(); i++) {
                    LatLng lngStart = LatLng(lat, lng1);
                    if (i == 0)
                      lngStart = lng;
                    else {
                      lngStart = _latLng.last;
                    }
                    _WayPoints.clear();
                    for (int j = i * 24; j < i * 24 + 24; j++) {
                      if (driverRoutePointList[j].orderId != 0 && driverRoutePointList[j].latitude > 0) {
                        // LatLng lng = LatLng((driverRoutePointList[i].latitude != null &&
                        //     driverRoutePointList[i].latitude
                        //         .toString()
                        //         .isNotEmpty) ? driverRoutePointList[i].latitude : 0.0,
                        //     (driverRoutePointList[i].longitude != null &&
                        //         driverRoutePointList[i].longitude
                        //             .toString()
                        //             .isNotEmpty)
                        //         ? driverRoutePointList[i].longitude
                        //         : 0.0);
                        var lat = driverRoutePointList[j].latitude;
                        var lng1 = driverRoutePointList[j].longitude;
                        LatLng lng = LatLng(lat, lng1);
                        _latLng.add(lng);

                        PolylineWayPoint polylineWayPoint = PolylineWayPoint(location: "$lat,$lng1", stopOver: true);
                        _WayPoints.add(polylineWayPoint);
                      }
                    }

                    await calculateDistane(lngStart, _latLng, _WayPoints);
                    // logger.i("distance :  $totalDistance km");
                    setState(() {});
                  }

                  LatLng lngStart = LatLng(lat, lng1);
                  if (_latLng.length > 0) lngStart = _latLng.last;
                  _WayPoints.clear();
                  for (int i = packageCounte.toInt() * 24; i < driverRoutePointList.length; i++) {
                    if (driverRoutePointList[i].orderId != 0 && driverRoutePointList[i].latitude > 0) {
                      // LatLng lng = LatLng((driverRoutePointList[i].latitude != null &&
                      //     driverRoutePointList[i].latitude
                      //         .toString()
                      //         .isNotEmpty) ? driverRoutePointList[i].latitude : 0.0,
                      //     (driverRoutePointList[i].longitude != null &&
                      //         driverRoutePointList[i].longitude
                      //             .toString()
                      //             .isNotEmpty)
                      //         ? driverRoutePointList[i].longitude
                      //         : 0.0);
                      var lat = driverRoutePointList[i].latitude;
                      var lng1 = driverRoutePointList[i].longitude;
                      LatLng lng = LatLng(lat, lng1);
                      _latLng.add(lng);

                      PolylineWayPoint polylineWayPoint = PolylineWayPoint(location: "$lat,$lng1", stopOver: true);
                      _WayPoints.add(polylineWayPoint);
                    }
                  }
                  if (_endLocationLatLng != null) {
                    PolylineWayPoint polylineWayPoint = PolylineWayPoint(location: "${_endLocationLatLng.latitude},${_endLocationLatLng.longitude}", stopOver: true);
                    _WayPoints.add(polylineWayPoint);
                    _latLng.add(_endLocationLatLng);
                  }
                  if (_WayPoints.isNotEmpty) calculateDistane(lngStart, _latLng, _WayPoints);
                } else {
                  LatLng lngStart = LatLng(lat, lng1);
                  for (int i = 0; i < driverRoutePointList.length; i++) {
                    if (driverRoutePointList[i].orderId != 0 && driverRoutePointList[i].latitude > 0) {
                      // LatLng lng = LatLng((driverRoutePointList[i].latitude != null &&
                      //     driverRoutePointList[i].latitude
                      //         .toString()
                      //         .isNotEmpty) ? driverRoutePointList[i].latitude : 0.0,
                      //     (driverRoutePointList[i].longitude != null &&
                      //         driverRoutePointList[i].longitude
                      //             .toString()
                      //             .isNotEmpty)
                      //         ? driverRoutePointList[i].longitude
                      //         : 0.0);
                      var lat = driverRoutePointList[i].latitude;
                      var lng1 = driverRoutePointList[i].longitude;
                      LatLng lng = LatLng(lat, lng1);
                      _latLng.add(lng);

                      PolylineWayPoint polylineWayPoint = PolylineWayPoint(location: "$lat,$lng1", stopOver: true);
                      _WayPoints.add(polylineWayPoint);
                    }
                  }
                  if (_endLocationLatLng != null) {
                    PolylineWayPoint polylineWayPoint = PolylineWayPoint(location: "${_endLocationLatLng.latitude},${_endLocationLatLng.longitude}", stopOver: true);
                    _WayPoints.add(polylineWayPoint);
                    _latLng.add(_endLocationLatLng);
                  }
                  // totalDistance = calculateDistane(_latLng) / 1609.34;
                  calculateDistane(lngStart, _latLng, _WayPoints);
                  // logger.i("distance :  $totalDistance km");
                  setState(() {});
                }
              } else {
                setState(() {});
              }
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

  Future<double> calculateDistane(LatLng start, List<LatLng> polyline, List<PolylineWayPoint> wayPoints) async {
    // double totalDistance = 0;
    List<LatLng> polylineCoordinates = [];

    // logger.i("valuesss $polyline");

    if (polyline.length > 1) {
      // for (int i = 0; i < polyline.length; i++) {
      if (polyline.length > 1) {
        PolylinePoints polylinePoints = PolylinePoints();
        await polylinePoints
            .getRouteBetweenCoordinates(
          WebConstant.GOOGLE_API_KEY, // G// oogle Maps API Key

          PointLatLng(start.latitude, start.longitude),
          PointLatLng(polyline[polyline.length - 1].latitude, polyline[polyline.length - 1].longitude),
          wayPoints: wayPoints,
          travelMode: TravelMode.driving,
        )
            .then((value) {
          polylineCoordinates.clear();
          // print(value.errorMessage);
          if (value.points.isNotEmpty) {
            value.points.forEach((PointLatLng point) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
              // logger.i("print1${polylineCoordinates.length}");
            });
            polylineCoordinatesAll.addAll(polylineCoordinates);
            _polyLines.add(Polyline(
              polylineId: PolylineId(_lastMapPosition.toString()),
              visible: true,
              width: 5,
              points: polylineCoordinatesAll,
              color: Colors.blue,
            ));
            for (int i = 0; i < polylineCoordinatesAll.length; i++) {
              if (i < polylineCoordinatesAll.length - 1) {
                // skip the last index
                totalDistance += getStraightLineDistance(polylineCoordinatesAll[i + 1].latitude, polylineCoordinatesAll[i + 1].longitude, polylineCoordinatesAll[i].latitude, polylineCoordinatesAll[i].longitude);
              }
            }
            totalDistance = (totalDistance / 1609.34);
            setState(() {});
          }
        });
      }
    }
    // }
    // return totalDistance;
  }

  double getStraightLineDistance(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1);
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(deg2rad(lat1)) * math.cos(deg2rad(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d * 1000; //in m
  }

  dynamic deg2rad(deg) {
    return deg * (math.pi / 180);
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    newGoogleMapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    // print(l1.toString());
    // print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) check(u, c);
  }

  void onClick(bool value) {
    Navigator.pop(_buildContext);
    // logger.i("testttttttt");
  }
}

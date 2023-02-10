// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
// import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/ui/driver_user_type/dashboard_driver.dart';
import 'package:pharmdel_business/util/permission_utils.dart';
import 'package:pharmdel_business/util/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../util/custom_loading.dart';
import '../../util/sentryExeptionHendler.dart';
import '../login_screen.dart';
import '../splash_screen.dart';

class DropPin extends StatefulWidget {
  // const DropPin({Key? key}) : super(key: key);
  final encoded;
  final File customerImage;
  final Map<String, dynamic> prams;
  final Map<String, dynamic> resBody;

  DropPin(this.prams, this.customerImage, this.encoded, this.resBody);

  @override
  _DropPinState createState() => _DropPinState();
}

class _DropPinState extends State<DropPin> {
  Completer<GoogleMapController> _controller = Completer();
  Position currentLocation;
  LatLng _center;

  //old kGoogleApiKey = "AIzaSyCOcaEtmYXt_xCluJPmmGP7ifCzw71qASE";
  static const kGoogleApiKey = WebConstant.GOOGLE_API_KEY; //'AIzaSyB6OqF1PX2oJ-LbGltJdYM3B8T1aWK6Gs8';//AIzaSyBDCNZmsfK2_HMk6WD1s555mOteuVFw1ZU
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  CameraPosition cPosition;
  ApiCallFram _apiCallFram = ApiCallFram();
  String userId, token, userType;
  String routeId;
  String strAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLastTime(context);
    init();
    getUserLocation();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    userId = prefs.getString('userId') ?? "";
    routeId = prefs.getString(WebConstant.ROUTE_ID) ?? "";
    userType = prefs.getString(WebConstant.USER_TYPE) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: _center != null
                    ? GoogleMap(
                        onTap: _handleTap,
                        mapType: MapType.normal,
                        zoomGesturesEnabled: true,
                        tiltGesturesEnabled: false,
                        initialCameraPosition: cPosition,
                        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        ].toSet(),
                        markers: Set<Marker>.of(
                          <Marker>[
                            Marker(
                              onTap: () {
                                // print('${latLng.latitude}, ${latLng.longitude}');
                                // // print('Tapped');
                                // // _center = LatLng(newPosition.latitude, newPosition.longitude);
                              },
                              draggable: true,
                              markerId: MarkerId('Marker'),
                              onDragEnd: ((newPosition) {
                                _center = LatLng(newPosition.latitude, newPosition.longitude);
                                updateMarkerOnselectedLocation();
                                // print('new Location1 $newPosition.latitude');
                                // print('new Location1 $newPosition.longitude');
                                // print(newPosition.longitude);
                              }),
                              position: LatLng(_center.latitude, _center.longitude),
                            ),
                          ],
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      )
                    : Container(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: InkWell(
                  onTap: () async {
                    Prediction p = await PlacesAutocomplete.show(
                      offset: 0,
                      radius: 1000,
                      strictbounds: false,
                      region: "us",
                      language: "en",
                      mode: Mode.fullscreen,
                      components: [new Component(Component.country, "uk")],
                      types: [""],
                      hint: "Search Address",
                      context: context,
                      apiKey: kGoogleApiKey,
                    );
                    displayPrediction(p);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 10.0, top: 00, right: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: [
                      // color: Colors.white, //background color of box
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          1.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ]),
                    child: Row(children: [
                      Icon(
                        Icons.search,
                        color: Colors.red,
                      ),
                      SizedBox(),
                      Text(
                        "Search for your location...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            child: MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  if (userType == 'Pharmacy' || userType == "Pharmacy Staff") {
                    widget.resBody["latitude"] = _center.latitude;
                    widget.resBody["longitude"] = _center.longitude;
                    widget.resBody["pinAddress"] = strAddress;
                    widget.resBody["routeId"] = "";
                    widget.resBody["baseSignature"] = widget.encoded;
                    widget.resBody["questionAnswerModels"] = [];
                    widget.resBody["customerRemarks"] = widget.prams["customerRemarks"];
                    updateSignature(widget.resBody);
                  } else {
                    // print('jhyuhuiooji');
                    widget.prams["latitude"] = _center.latitude;
                    widget.prams["longitude"] = _center.longitude;
                    widget.prams["pinAddress"] = strAddress;
                    // widget.resBody["baseSignature"] = widget.encoded;
                    updateSignature(widget.prams);
                  }
                },
                child: Text("Submit")),
          ),
        ],
      )),
    );
  }

  _handleTap(LatLng point) {
    // setState(() {
    _center = LatLng(point.latitude, point.longitude);
    updateMarkerOnselectedLocation();
    // print('new Location1 $_center.latitude');
    // print('new Location1 $_center.longitude');
    //});
  }

  LatLng currentPostion;

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    CheckPermission.checkLocationPermissionOnly(context).then((value) async {
      if (value) {
        if (Platform.isAndroid) {
          currentLocation = await locateUser();
          //setState(() {
          _center = LatLng(currentLocation.latitude, currentLocation.longitude);
          updateMarkerOnselectedLocation();
          //});
          setState(() {});
          // print('center $_center');
        } else {}
      }
    });
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      // var address = await Geocoder.local.findAddressesFromQuery(p.description);
      // strAddress = address.first.locality + address.first.sub;
      _center = LatLng(lat, lng);
      updateMarkerOnselectedLocation();
      // strAddress = address.first.addressLine;

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(_center));

      // print(address.first.locality);
      // print(address.first.subLocality);
      // print(address.first.addressLine);
      // print(lat);
      // print(lng);
    }
  }

  updateMarkerOnselectedLocation() async {
    cPosition = CameraPosition(
      target: LatLng(_center.latitude, _center.longitude),
      zoom: 15,
    );

    setState(() {});

    final coordinates = new Coordinates(_center.latitude, _center.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    strAddress = addresses.first.addressLine;
    // print(strAddress);
  }

  Future<void> updateSignature(Map<String, dynamic> prams) async {
    // logger.i("tesssss "+userType);
    // print(prams);
    // await ProgressDialog(context, isDismissible: false).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);
    String url = "";
    if (userType == 'Pharmacy' || userType == "Pharmacy Staff") {
      // logger.i("pharmacy");
      prams = widget.resBody;
      url = WebConstant.PHARMACY_SIGNATURE_UPLOAD_URL;
    } else {
      // logger.i("driver");
      url = WebConstant.DELIVERY_SIGNATURE_UPLOAD_URL;
    }
    logger.i(url);
    _apiCallFram.postFilesWithDataMaps(url, token, prams, widget.customerImage, context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      try {
        if (response != null) {
          var data = json.decode(response.body);
          // print(data);
          // logger.i("response: ${response.body}");

          if (data["status"] == true || data["status"] == 'true') {
            isDelivery = true;

            Fluttertoast.showToast(msg: "Successfully Uploaded");
            if ((data["isOrderAvailable"] == false || data["isOrderAvailable"] == 'false') && userType != 'Pharmacy') {
              isDelivery = false;
              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                //title: Text("AlertDialog"),
                content: Text("As you have completed all the deliveries please end your route."),
                actions: [
                  // cancelButton,
                  TextButton(
                      child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.green), shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(5.00))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "End Route",
                              style: TextStyle(color: Colors.green),
                            ),
                          )),
                      onPressed: () {
                        endRoute();
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (BuildContext context) => DashboardDriver(),
                        //     ),
                        //     ModalRoute.withName('/signature'));
                      }),
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return WillPopScope(onWillPop: () async => false, child: alert);
                },
              );
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DashboardDriver(0),
                  ),
                  ModalRoute.withName('/signature'));
            }
          } else {
            // ProgressDialog(context).hide();
            await CustomLoading().showLoadingDialog(context, false);
            // await CustomLoading().showLoadingDialog(context, true);
            ToastUtils.showCustomToast(context, "${data["message"]}, Please try again !");
          }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        // print(e.toString());
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
      }
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
    }, onError: (error, stackTrace) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      ToastUtils.showCustomToast(context, "Please try again !");
      // isDelivery = true;
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => DashboardDriver(),
      //     ),
      //     ModalRoute.withName('/signature'));
    });
  }

  Future<void> endRoute() async {
    // await ProgressDialog(context, isDismissible: false).show();
    // await CustomLoading().showLoadingDialog(context, false);
    await CustomLoading().showLoadingDialog(context, true);

    String url = "${WebConstant.END_ROUTE_BY_DRIVER}?routeId=$routeId";
    _apiCallFram.getDataRequestAPI(url, token, context).then((response) async {
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
      try {
        if (response != null) {
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
          } else if (response.body.toString() == "true") {
            SharedPreferences.getInstance().then((value) {
              value.setBool(WebConstant.IS_ROUTE_START, false);
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DashboardDriver(0),
                ),
                ModalRoute.withName('/signature'));
          } else {
            Fluttertoast.showToast(msg: "Route Not ended");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DashboardDriver(0),
                ),
                ModalRoute.withName('/signature'));
          }
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        String jsonUser = jsonEncode(e);
        Fluttertoast.showToast(msg: jsonUser);
        // ProgressDialog(context).hide();
        await CustomLoading().showLoadingDialog(context, false);
        // await CustomLoading().showLoadingDialog(context, true);
      }
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
    }).catchError((onError) async {
      String jsonUser = jsonEncode(onError);
      Fluttertoast.showToast(msg: jsonUser);
      // ProgressDialog(context).hide();
      await CustomLoading().showLoadingDialog(context, false);
      // await CustomLoading().showLoadingDialog(context, true);
    });
  }
}

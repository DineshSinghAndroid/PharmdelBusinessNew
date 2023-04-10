

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as L;
import 'package:permission_handler/permission_handler.dart';
import '../PrintLog/PrintLog.dart';
import '../TextController/BuildText/BuildText.dart';
import 'package:location/location.dart' as location1;

Future<location1.LocationData?> checkLocationPermission() async {
  bool serviceEnabled;
  location1.PermissionStatus permissionGranted;

  location1.Location location = location1.Location();

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  return await location.getLocation();
}


class CheckPermission {
  static CheckPermission? _instance;

  factory CheckPermission() => _instance ??= CheckPermission._();
  CheckPermission._();

  static L.LocationData? currentPosition;
  static L.Location? location;
  static bool? serviceEnabled;
  static L.PermissionStatus? permissionGranted;

  /// Get current Position
  static Future<L.LocationData?> getCurrentLocation(
      {required BuildContext context,required Function(L.LocationData)? onChangedLocation}) async {
    await checkLocationPermission(context).then((value) async {
      if (value == true) {
        serviceEnabled = await location?.serviceEnabled();
        if (serviceEnabled == false) {
          serviceEnabled = await location?.requestService();
          if (serviceEnabled == false) {
            return null;
          }
        }

        permissionGranted = await location?.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location?.requestPermission();
          if (permissionGranted != PermissionStatus.granted) {
            return null;
          }
        }

        currentPosition = await location?.getLocation();
        location?.changeSettings(distanceFilter: 10, accuracy: L.LocationAccuracy.high);
        location?.enableBackgroundMode(enable: true);
        location?.onLocationChanged.listen(onChangedLocation);

        PrintLog.printLog("Current Location Lat::::::${currentPosition?.latitude}");
        // location?.onLocationChanged.listen((L.LocationData currentLocation) {
        //
        //     currentPosition = currentLocation;
        //
        // });
      }else{
        await location?.requestPermission();
      }
    });




    return currentPosition;
  }

  // getLoc() async{
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //
  //   _currentPosition = await location.getLocation();
  //   _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
  //   location.onLocationChanged.listen((LocationData currentLocation) {
  //     print("${currentLocation.longitude} : ${currentLocation.longitude}");
  //     setState(() {
  //       _currentPosition = currentLocation;
  //       _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
  //
  //       DateTime now = DateTime.now();
  //       _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
  //       _getAddress(_currentPosition.latitude, _currentPosition.longitude)
  //           .then((value) {
  //         setState(() {
  //           _address = "${value.first.addressLine}";
  //         });
  //       });
  //     });
  //   });
  // }


  static Future<Object> checkCameraPermission(BuildContext context) async {
    bool isCameraPermission = false;
    await Permission.camera.request().then((value) async {
      PrintLog.printLog('value: $value');

      if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
        await showCameraPermissionPopUp(context).then((value) {
          if(value == true){
            openAppSettings();
          }
        } );
      }
    });

    final status = await Permission.camera.status;
    PrintLog.printLog('camera permission status: $status');
    if (status == PermissionStatus.granted) {
      PrintLog.printLog('Camera Permission granted');
    }else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      await Permission.camera.request().then((value) async {
        PrintLog.printLog('value: $value');

        if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
          await showCameraPermissionPopUp(context).then((value) {
            if(value == true){
              openAppSettings();
            }
          } );
        }
      });
    }

    PermissionStatus whenInUse = await Permission.camera.status;
    if (whenInUse == PermissionStatus.granted) isCameraPermission = true;

    return isCameraPermission;
  }

  static Future<Object> checkAudioRecordPermission(BuildContext context) async {
    bool isMicrophonePermission = false;
    final status = await Permission.microphone.status;
    PrintLog.printLog('microphone permission status: $status');

    if (status == PermissionStatus.granted) {
      PrintLog.printLog('Microphone Permission granted');
    }else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      await Permission.microphone.request().then((value) async {
        PrintLog.printLog('value: $value');
        if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
          await showMicroPhonePermissionPopUp(context).then((value) {
            if(value == true){
              openAppSettings();
            }
          } );
        }
      });
    }

    PermissionStatus whenInUse = await Permission.microphone.status;
    if (whenInUse == PermissionStatus.granted) isMicrophonePermission = true;

    return isMicrophonePermission;
  }

  static Future<Object> checkStoragePermission(BuildContext context) async {
    bool isStoragePermission = false;
    if(Platform.isAndroid){
      final status = await Permission.storage.status;

      if (status == PermissionStatus.granted) {
        PrintLog.printLog('Storage Permission granted');
      } else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied){
        await Permission.storage.request().then((value) async {
          if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
            await showStoragePermissionPopUp(context).then((value) {
              if(value == true){
                openAppSettings();
              }
            } );
          }
        });
      }

      PermissionStatus whenInUse = await Permission.storage.status;
      if (whenInUse == PermissionStatus.granted) isStoragePermission = true;
      PrintLog.printLog("isStoragePermission: $isStoragePermission");
    }
    if(Platform.isIOS){
      final status = await Permission.storage.status;
      PrintLog.printLog('storage permission status: $status');

      if (status == PermissionStatus.granted) {
        PrintLog.printLog('Storage Permission granted');
      } else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied){
        await Permission.storage.request().then((value) async {
          PrintLog.printLog('value: $value');

          if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
            await showStoragePermissionPopUp(context).then((value) {
              if(value == true){
                openAppSettings();
              }
            } );
          }
        });
      }

      PermissionStatus whenInUse = await Permission.storage.status;
      if (whenInUse == PermissionStatus.granted) isStoragePermission = true;
      PrintLog.printLog("isStoragePermission: $isStoragePermission");
    }

    return isStoragePermission;
  }

  static Future<Object> checkPhotosPermission(BuildContext context) async {
    bool isPhotosPermission = false;
    await Permission.photos.request().then((value) async {
      PrintLog.printLog('value: $value');

      if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
        await showPhotosPermissionPopUp(context).then((value) {
          if(value == true){
            openAppSettings();
          }
        } );
      }
    });

    final status = await Permission.photos.status;
    PrintLog.printLog('photos permission status: $status');
    if (status == PermissionStatus.granted) {
      PrintLog.printLog('photos Permission granted');
    }else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      await Permission.photos.request().then((value) async {
        PrintLog.printLog('value: $value');

        if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
          await showPhotosPermissionPopUp(context).then((value) {
            if(value == true){
              openAppSettings();
            }
          } );
        }
      });
    }

    PermissionStatus whenInUse = await Permission.photos.status;
    if (whenInUse == PermissionStatus.granted || whenInUse == PermissionStatus.limited) isPhotosPermission = true;

    return isPhotosPermission;
  }

  static Future<Object> checkLocationPermission(BuildContext context) async {
    bool isLocationPermission = false;
    await Permission.location.request().then((value) async {
      PrintLog.printLog('Location permission status: $value');
      await Permission.locationAlways.request();
      await Permission.locationWhenInUse.request();

      if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
        await showLocationPermissionPopUp(context).then((value) {
          if(value == true){
            openAppSettings();
          }
        } );
      }
    });


    // final status = await Permission.location.status;
    // PrintLog.printLog('Location permission status: $status');
    // if (status == PermissionStatus.granted) {
    //   PrintLog.printLog('Location Permission granted');
    // }else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
    //   await Permission.location.request().then((value) async {
    //     PrintLog.printLog('value: $value');
    //
    //     if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
    //       await showLocationPermissionPopUp(context).then((value) {
    //         if(value == true){
    //           openAppSettings();
    //         }
    //       } );
    //     }
    //   });
    // }

    PermissionStatus whenInUse = await Permission.location.status;
    if (whenInUse == PermissionStatus.granted || whenInUse == PermissionStatus.limited) isLocationPermission = true;

    return isLocationPermission;
  }


  static Future<Object> showLocationPermissionPopUp(context) async{
    bool isLocationPermission = false;
    var status = await Permission.locationAlways.status;
    if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      return showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:
            BuildText.buildText(text: "'PHARMDEL' Would Like to Access the Location",size: 18)
          ),
          content: BuildText.buildText(text: "Pharmdel collects location data to enable parcel tracking and creating an optimised delivery route for drivers even when the app is closed or not in use."),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },child:
              BuildText.buildText(text: "Don't Allow",size: 18,),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: BuildText.buildText(text: "OK",size: 18),
              ),
            ),

          ],
        ),
      ).then((value) {
        isLocationPermission = value;
        return isLocationPermission;
      } );
    }
    return isLocationPermission;
  }

  static Future<Object> showCameraPermissionPopUp(context) async{
    bool isCameraPermission = false;
    var status = await Permission.camera.status;
    if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      return showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BuildText.buildText(text: "'PHARMDEL' Would Like to Access the Camera",size: 18)
          ),
          content: BuildText.buildText(text: "This app uses the camera to take pictures and record videos."),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child:
                BuildText.buildText(text: "Don't Allow",size: 18),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: BuildText.buildText(text: "OK",size: 18),
              ),
            ),

          ],
        ),
      ).then((value) {
        isCameraPermission = value;
        return isCameraPermission;
      } );
    }
    return isCameraPermission;
  }

  static Future<Object> showMicroPhonePermissionPopUp(context) async{
    bool isMicroPhonePermission = false;
    var status = await Permission.microphone.status;
    if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      return showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BuildText.buildText(text: "'PHARMDEL' Would Like to Access the microphone",size: 18),
          ),
          content: BuildText.buildText(text: "PHARMDEL requires access to the microphone so you can record your voice for activities"),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: BuildText.buildText(text: "Don't Allow",size: 18),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: BuildText.buildText(text: "OK",size: 18),
                // const Text("OK"),
              ),
            ),

          ],
        ),
      ).then((value) {
        isMicroPhonePermission = value;
        return isMicroPhonePermission;
      } );
    }
    return isMicroPhonePermission;
  }

  static Future<Object> showStoragePermissionPopUp(context) async{
    bool isStoragePermission = false;
    var status = await Permission.storage.status;
    if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      return showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BuildText.buildText(text: "'PHARMDEL' Would Like to Access the storage",size: 18)
          ),
          content: BuildText.buildText(text: "This app requires access to the storage so you can save your images and voice record in your device"),

          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: BuildText.buildText(text: "Don't Allow",size: 18,),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: BuildText.buildText(text: "OK",size: 18),
              ),
            ),

          ],
        ),
      ).then((value) {
        isStoragePermission = value;
        return isStoragePermission;
      } );
    }
    return isStoragePermission;
  }

  static Future<Object> showPhotosPermissionPopUp(context) async{
    bool isPhotosPermission = false;
    var status = await Permission.photos.status;
    if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      return showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BuildText.buildText(text: "'PHARMDEL' Would Like to Access the photos",size: 18)
          ),
          content: BuildText.buildText(text: "This app uses the photos for your profile picture"),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: BuildText.buildText(text: "Don't Allow",size: 18,),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: BuildText.buildText(text: "OK",size: 18,)
              ),
            ),

          ],
        ),
      ).then((value) {
        isPhotosPermission = value;
        return isPhotosPermission;
      } );
    }
    return isPhotosPermission;
  }


  /// Get current Latitude
  static Future<String?> getLatitude(BuildContext context) async {
    bool permission = await checkLocationPermission(context) as bool;
    if (!permission) {
      return null;
    }
    Position position = await Geolocator.getCurrentPosition();
    return position.latitude.toString();
  }

  /// Get current Longitude
  static Future<String?> getLongitude(BuildContext context) async {
    bool permission = await checkLocationPermission(context) as bool;
    if (!permission) {
      return null;
    }
    Position position = await Geolocator.getCurrentPosition();
    return position.longitude.toString();
  }

  // /// Get current Position
  // static Future<Position?> getCurrentPosition(BuildContext context) async {
  //   bool permission = await checkLocationPermission(context) as bool;
  //   if (!permission) {
  //     return null;
  //   }
  //   Position position = await Geolocator.getCurrentPosition();
  //   return position;
  // }


  static Future<Placemark?> getPlaceMarkCurrentLocation({required BuildContext context}) async {
    Placemark? placeMark;
    await checkLocationPermission(context).then((value) async {
      if(value == true){
        await Geolocator.getCurrentPosition().then((value) async {
          await placemarkFromCoordinates(value.latitude, value.longitude).then((positionVlaue){
            placeMark = positionVlaue[0];
            return placeMark;
            // Placemark place = positionVlaue[0];
            // countryController.text = place.country ?? '';
            // addressController.text = place.street ?? "";
            // address2Controller.text = place.subLocality ?? '';
            // pinController.text = place.postalCode ?? '';
            // stateController.text = place.administrativeArea ?? "";
            // cityController.text = place.locality ?? '';
            // setState(() {
            //
            // });
          });
        });
      }
    });
    return placeMark;
  }

  static Future<Placemark?> getPlaceMarkWithLatLng({required String latitude,required String longitude}) async {
    Placemark? placeMark;
    await checkLocationPermission(Get.overlayContext!).then((value) async {
      if(value == true){
        await placemarkFromCoordinates(double.parse(latitude.toString()), double.parse(longitude.toString())).then((positionValue){
          placeMark = positionValue[0];
          PrintLog.printLog("PlaceMark: ${positionValue[0]}");
          PrintLog.printLog("PlaceMark-country: ${positionValue[0].country}");
          PrintLog.printLog("PlaceMark-street: ${positionValue[0].street}");
          PrintLog.printLog("PlaceMark-subLocality: ${positionValue[0].subLocality}");
          PrintLog.printLog("PlaceMark-postalCode: ${positionValue[0].postalCode}");
          PrintLog.printLog("PlaceMark-administrativeArea: ${positionValue[0].administrativeArea}");
          PrintLog.printLog("PlaceMark-locality: ${positionValue[0].locality}");
          return placeMark;
        });
      }
    });
    return placeMark;
  }






}

// abstract class PermissionCheckListner {
//   void permissionCheck(bool isGranted);
// }

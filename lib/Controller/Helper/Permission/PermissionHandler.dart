

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../PrintLog/PrintLog.dart';
import '../TextController/BuildText/BuildText.dart';


class CheckPermission {
  static CheckPermission? _instance;
  factory CheckPermission() => _instance  = new CheckPermission._();

  CheckPermission._();

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
      PrintLog.printLog('value: $value');

      if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
        await showLocationPermissionPopUp(context).then((value) {
          if(value == true){
            openAppSettings();
          }
        } );
      }
    });

    final status = await Permission.location.status;
    PrintLog.printLog('Location permission status: $status');
    if (status == PermissionStatus.granted) {
      PrintLog.printLog('Location Permission granted');
    }else if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      await Permission.location.request().then((value) async {
        PrintLog.printLog('value: $value');

        if(value == PermissionStatus.denied || value == PermissionStatus.permanentlyDenied){
          await showLocationPermissionPopUp(context).then((value) {
            if(value == true){
              openAppSettings();
            }
          } );
        }
      });
    }

    PermissionStatus whenInUse = await Permission.location.status;
    if (whenInUse == PermissionStatus.granted || whenInUse == PermissionStatus.limited) isLocationPermission = true;

    return isLocationPermission;
  }


  static Future<Object> showLocationPermissionPopUp(context) async{
    bool isLocationPermission = false;
    var status = await Permission.location.status;
    if (status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied) {
      return showDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:
            BuildText.buildText(text: "'PHARMDEL' Would Like to Access the Location",size: 18)
          ),
          content: BuildText.buildText(text: "This app uses location for provider nearby library details"),
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

}
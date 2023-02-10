// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'log_print.dart';

bool isShowLocationCustomPopup = false;

class CheckPermission {
  static CheckPermission _instance;

  factory CheckPermission() => _instance ??= new CheckPermission._();

  CheckPermission._();

  //
  // static Future<bool> checkLocationPermission(BuildContext context) async {
  //   bool isPermission = false;
  //   Permission.getPermissionsStatus([PermissionName.Location])
  //       .then((value) async {
  //     // print("ssss" + value[0].permissionStatus.toString());
  //     var status = value[0].permissionStatus;
  //     if (status.toString().contains("allow")) {
  //       isPermission = true;
  //       return isPermission;
  //     } else {
  //       // print("test");
  //       // ToastUtils.showCustomToast(context, "Location permission not allowed");
  //       List<PermissionName> permissionNames = [];
  //       permissionNames.add(PermissionName.Location);
  //       permissionNames.add(PermissionName.WhenInUse);
  //       var message = '';
  //       await Permission.requestPermissions(permissionNames).then((value) {
  //         value.forEach((permission) {
  //           message +=
  //               '${permission.permissionName}: ${permission.permissionStatus}\n';
  //           // print("mainPermission" + message);
  //           if (permission.permissionStatus.toString().contains("allow")) {
  //             isPermission = true;
  //             return isPermission;
  //           } else {
  //             isPermission = false;
  //             return isPermission;
  //           }
  //         });
  //       });
  //     }
  //   });
  //   return isPermission;
  // }
  //
  // static Future<bool> checkLocationPermissionDash(
  //     BuildContext context, PermissionCheckListner checkListner) async {
  //   bool isPermission = false;
  //   Permission.getPermissionsStatus([PermissionName.Location])
  //       .then((value) async {
  //     // print("ssss" + value[0].permissionStatus.toString());
  //     var status = value[0].permissionStatus;
  //     if (status.toString().contains("allow")) {
  //       isPermission = true;
  //       checkListner.permissionCheck(true);
  //       return isPermission;
  //     } else {
  //       // print("test");
  //       // ToastUtils.showCustomToast(context, "Location permission not allowed");
  //       List<PermissionName> permissionNames = [];
  //       permissionNames.add(PermissionName.Location);
  //       permissionNames.add(PermissionName.WhenInUse);
  //       var message = '';
  //       await Permission.requestPermissions(permissionNames).then((value) {
  //         value.forEach((permission) {
  //           message +=
  //               '${permission.permissionName}: ${permission.permissionStatus}\n';
  //           // print("mainPermission" + message);
  //           if (permission.permissionStatus.toString().contains("allow")) {
  //             isPermission = true;
  //             checkListner.permissionCheck(true);
  //             return isPermission;
  //           } else {
  //             isPermission = false;
  //             checkListner.permissionCheck(false);
  //             return isPermission;
  //           }
  //         });
  //       });
  //     }
  //   });
  //   return isPermission;
  // }

  ///

  static Future<Object> checkPermissionStatus(context) async {
    bool isLocationAccessGranted = false;

    var status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {
      //
      if (isShowLocationCustomPopup == false) {
        isShowLocationCustomPopup = true;
        return await showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                      opacity: a1.value,
                      child: AlertDialog(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        titlePadding: EdgeInsets.zero,
                        title: Container(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Use your location",
                                style: TextStyle(fontSize: 17, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        actionsPadding: EdgeInsets.only(bottom: 10.0),
                        // actions: [button],
                        content: Text(
                          "Pharmdel collects location data to enable parcel tracking and creating an optimised delivery route for drivers even when the app is closed or not in use."
                          // 'Pharmdel collects location data of driver to create an optimised delivery route even when the app is closed or not in use. '
                          ,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                    openAppSettings();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: Colors.grey), color: Colors.white),
                                    child: Center(
                                        child: Text(
                                      'No thanks',
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: Colors.grey), color: Colors.white),
                                    child: Center(
                                        child: Text(
                                      'Turn on',
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            transitionDuration: Duration(milliseconds: 500),
            barrierDismissible: false,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation1, animation2) {
              return Text('');
            }).then((value) {
          isLocationAccessGranted = value;
          return isLocationAccessGranted;
        });
      }
    }

    return isLocationAccessGranted;
  }

  static Future<Object> checkLocationPermissionOnly(BuildContext context) async {
    bool isPermission = false;

    await Permission.location.request().then((value) async {
      await checkPermissionStatus(context).then((value) async {
        if (value) {
          isShowLocationCustomPopup = false;
          final status = await Permission.locationWhenInUse.request();
          if (status == PermissionStatus.granted) {
            logger.i('Permission granted');
          } else if (status == PermissionStatus.denied) {
            openAppSettings();
            logger.i('Denied. Show a dialog with a reason and again ask for the permission.');
          } else if (status == PermissionStatus.permanentlyDenied) {
            openAppSettings();
            logger.i('Take the user to the settings page.');
          }
        }
      }
      );
    });


    // // var status = await Permission.location.status;
    // // if (status.isDenied || await Permission.location.isPermanentlyDenied) {
    // //   openAppSettings();
    // // }
    // final status = await Permission.locationWhenInUse.request();
    // if (status == PermissionStatus.granted) {
    //
    //   print('Permission granted');
    // } else if (status == PermissionStatus.denied) {
    //   openAppSettings();
    //   print('Denied. Show a dialog with a reason and again ask for the permission.');
    // } else if (status == PermissionStatus.permanentlyDenied) {
    //   openAppSettings();
    //   print('Take the user to the settings page.');
    // }

    PermissionStatus whenInUse = await Permission.locationWhenInUse.status;
    if (whenInUse == PermissionStatus.granted) isPermission = true;

    PermissionStatus always = await Permission.locationAlways.status;
    if (always == PermissionStatus.granted) isPermission = true;

    // await Permission.getPermissionsStatus([PermissionName.Location])
    //     .then((value) async {
    //   var openSettings = Permission.openSettings;
    //   // print("ssss" + value[0].permissionStatus.toString());
    //   var status = value[0].permissionStatus;
    //   if (status.toString().contains("allow")) {
    //     isPermission = true;
    //     return isPermission;
    //   } else {
    //     // print("test");
    //     isPermission = false;
    //     return isPermission;
    //   }
    // });
    return isPermission;
  }
}

abstract class PermissionCheckListner {
  void permissionCheck(bool isGranted);
}

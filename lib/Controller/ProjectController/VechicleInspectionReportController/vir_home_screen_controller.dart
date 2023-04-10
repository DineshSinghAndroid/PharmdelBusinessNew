import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ApiController/WebConstant.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/VIRUploadModel/GetInspectionModel.dart';
import '../../ApiController/ApiController.dart';
import '../../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';

bool tyreDone = false;
bool bodyDone = false;
bool bootDone = false;
bool insideDone = false;
bool engineDone = false;

class VirHomeScreenController extends GetxController{
  final ApiController _apiCtrl = ApiController();
@override
  void onInit() {
  init();
    // TODO: implement onInit
    super.onInit();
  }
  String vechicleId ='';
  List icons = [
    Icons.camera_rounded,
    Icons.car_rental_sharp,
    Icons.camera_enhance_rounded,
    Icons.motion_photos_auto,
    Icons.car_crash,
  ];

  List arrowIcons = [
    tyreDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
    bodyDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
    insideDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
    bootDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
    engineDone == true ? Icons.check_box : Icons.arrow_forward_ios_outlined,
  ];





  List texts = [
    "Tyre",
    "Body",
    "Inside",
    "Boot",
    "Engine",
  ];








   void  onPressedIconWithText(context)   {
     fetchUpdatedData(vehicleId: 0,context: context);

  }

Future<GetInspectionDataModel?> fetchUpdatedData({context, required  vehicleId}) async {
    if(vehicleId !="" && vehicleId != "0") {
      Map<String, dynamic> dictparam = {
        "vehicle_id": vehicleId,
      };
      String url = WebApiConstant.GET_VIR_STATUS;
      await _apiCtrl.getVehicleInspectionReportStatus(context:context,url:url,dictParameter:dictparam,token:authToken).then((result){
        if(result != null ){

          print(result.toString());
        }
      });
    }}

  void init()async {
   await SharedPreferences.getInstance().then((value) {
       vechicleId = value.getString(AppSharedPreferences.vehicleId) ?? "";
       update();
    });

  }
  // Future<void> fetchData() async {
  //         GetInspectionDataModel model = GetInspectionDataModel.fromJson(json.decode(response.body));
  //         if (model != null) {
  //           if (model.data != null) {
  //             if (model.data!.tyre == 1) {
  //
  //                 tyreDone = true;
  //
  //             }
  //             if (model.data!.boot == 1) {
  //
  //                 bootDone = true;
  //
  //             }
  //             if (model.data!.body == 1) {
  //
  //                 bodyDone = true;
  //
  //             }
  //             if (model.data!.engine == 1) {
  //                  engineDone = true;
  //              }
  //             if (model.data!.inside == 1) {
  //                  insideDone = true;
  //              }
  //
  //           } else {
  //             print(model.message.toString());
  //           }
  //         }
  //       }
  //     }
  //
  //   });
  // }




}
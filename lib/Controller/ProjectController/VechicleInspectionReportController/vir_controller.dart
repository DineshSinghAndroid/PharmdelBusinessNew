import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Model/VIRUploadModel/GetInspectionModel.dart';



class VirController extends GetxController{

  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  String vechicleId = "";
  TextEditingController remarkController = TextEditingController();

  InspectionData? inspectionData;

  List<ServiceDataType> servicePageList = [

    /// Tyre
    ServiceDataType(
        title: kTyre,
      icon: Icons.camera_rounded,
      isCompleted: false,
      imagesList: [
        InspectionImages(type: "Front Left", baseCode: ""),
        InspectionImages(type: "Front Right", baseCode: ""),
        InspectionImages(type: "Back Left", baseCode: ""),
        InspectionImages(type: "Back Right", baseCode: ""),
      ]
    ),

    /// Body
    ServiceDataType(
        title: kBody,
        icon: Icons.car_rental_sharp,
        isCompleted: false,
        imagesList: [
          InspectionImages(type: "Left", baseCode: ""),
          InspectionImages(type: "Right", baseCode: ""),
          InspectionImages(type: "Front", baseCode: ""),
          InspectionImages(type: "Back", baseCode: ""),
        ]
    ),

    /// Inside
    ServiceDataType(
        title: kInside,
        icon: Icons.camera_enhance_rounded,
        isCompleted: false,
        imagesList: [
          InspectionImages(type: "Dashboard", baseCode: ""),
          InspectionImages(type: "Driver Seat", baseCode: ""),
          InspectionImages(type: "Passenger", baseCode: ""),
          InspectionImages(type: "Rear Seat", baseCode: ""),
        ]
    ),

    /// Boot
    ServiceDataType(
        title: kBoot,
        icon: Icons.motion_photos_auto,
        isCompleted: false,
        imagesList: [
          InspectionImages(type: "Spare Wheel", baseCode: ""),
          InspectionImages(type: "Tool Kit", baseCode: ""),
          InspectionImages(type: "Floor", baseCode: ""),
          InspectionImages(type: "Full Back", baseCode: ""),
        ]
    ),

    /// Engine
    ServiceDataType(
        title: kEngine,
        icon: Icons.car_crash,
        isCompleted: false,
        imagesList: [
          InspectionImages(type: "Pic 1", baseCode: ""),
          InspectionImages(type: "Pic 2", baseCode: ""),
          InspectionImages(type: "Pic 3", baseCode: ""),
          InspectionImages(type: "Pic 4", baseCode: ""),
        ]
    ),
  ];


  @override
  void onInit() {
    vechicleId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.vehicleId) ?? "";
    super.onInit();
  }


  Future<void> addImage({required BuildContext context,required int mainIndex, required int listIndex})async {
    if(servicePageList[mainIndex].imagesList[listIndex].image == null){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CameraScreen()
          )).then((value) async {
        if (value != null) {
          servicePageList[mainIndex].imagesList[listIndex].image = File(value);
          final imageData = await File(value);
          final image = await imageData.readAsBytes();
          servicePageList[mainIndex].imagesList[listIndex].baseCode = base64Encode(image);
          PrintLog.printLog("Clicked  ${servicePageList[mainIndex].imagesList[listIndex].type.toString()}");
          update();
        }
      });
    }

  }

  Future<void> removeImage({required int mainIndex, required int listIndex})async {
    servicePageList[mainIndex].imagesList[listIndex].image = null;
    servicePageList[mainIndex].imagesList[listIndex].baseCode = '';
    PrintLog.printLog("Image Deleted Successfully");
    update();
  }

  Future<void> onTapSubmitImages({required BuildContext context,required int mainIndex})async {
    PrintLog.printLog("On Tap Submit Images");
    bool isBlanks = servicePageList[mainIndex].imagesList.any((element) => element.baseCode == "");
    if (vechicleId != "") {
      if (isBlanks == false) {
        List<Map<String, dynamic>> dictParameter = [];
        for (var data in servicePageList[mainIndex].imagesList) {
          Map<String, dynamic> tyreParameter = {
            "type": data.type ?? 0,
            "image": data.baseCode ?? "",
          };
          dictParameter.add(tyreParameter);
        }

        Map<String, dynamic> apiParameter = {
          "section": servicePageList[mainIndex].title.toLowerCase(),
          "remarks": remarkController.text.toString().trim() ?? '',
          "section_image": dictParameter,
          "vehicle_id": vechicleId
        };

        PrintLog.printLog("dictParameter: $apiParameter");
        await virUpload(context: context, dictData: apiParameter,indexUpdate: mainIndex);
      } else {
        ToastCustom.showToastWithGravity(msg: kPleaseClickAllImages);
      }
    } else {
      ToastCustom.showToastWithGravity(msg: kPleaseChooseAnyVehicleFirst);
    }

  }

  Future<void> fetchUpdatedData({required BuildContext context}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparam = {
      "vehicle_id": vechicleId,
    };

    String url = WebApiConstant.GET_VIR_STATUS;

    await apiCtrl.getVehicleInspectionReportStatus(context:context,url:url,dictParameter:dictparam,token:authToken).then((result) async {
      try {
        if (result != null) {
          if (result.error != true) {
            if(result.data != null){
              inspectionData = result.data;
              if(result.data?.tyre != null && result.data?.tyre == "1"){
                servicePageList[0].isCompleted = true;
              }
              if(result.data?.body != null && result.data?.body == "1"){
                servicePageList[1].isCompleted = true;
              }
              if(result.data?.inside != null && result.data?.inside == "1"){
                servicePageList[2].isCompleted = true;
              }
              if(result.data?.boot != null && result.data?.boot == "1"){
                servicePageList[3].isCompleted = true;
              }
              if(result.data?.engine != null && result.data?.engine == "1"){
                servicePageList[4].isCompleted = true;
              }
            }
            changeLoadingValue(false);
            changeSuccessValue(true);
          } else {
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog(result.message);
          }
        } else {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
        }
      } catch (_) {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
        PrintLog.printLog("Exception : $_");
      }
    });
    update();
  }


  Future<void> virUpload({required int indexUpdate,required BuildContext context, required dictData}) async {
    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);


    String url = WebApiConstant.INSPECTION_SUBMIT;

    await apiCtrl.virUploadApi(context: context, url: url, dictData: dictData, token: authToken).then((result) async {
      try {
        if (result != null) {
          if (result.error != true) {
            changeLoadingValue(false);
            changeSuccessValue(true);
            servicePageList[indexUpdate].isCompleted = true;
            Get.back();
          } else {
            servicePageList[indexUpdate].isCompleted = false;
            changeSuccessValue(false);
            changeLoadingValue(false);
            changeErrorValue(true);
            PrintLog.printLog(result.message);
          }
        } else {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
        }
      } catch (_) {
        changeSuccessValue(false);
        changeLoadingValue(false);
        changeErrorValue(true);
        PrintLog.printLog("Exception : $_");
      }
    });
    update();
  }



  void changeSuccessValue(bool value) {
    isSuccess = value;
    update();
  }

  void changeLoadingValue(bool value) {
    isLoading = value;
    update();
  }

  void changeEmptyValue(bool value) {
    isEmpty = value;
    update();
  }

  void changeNetworkValue(bool value) {
    isNetworkError = value;
    update();
  }

  void changeErrorValue(bool value) {
    isError = value;
    update();
  }



}


class InspectionImages {
  String type;
  String baseCode;
  File? image;

  InspectionImages({required this.type, this.image, required this.baseCode});
}

class ServiceDataType {
  String title;
  IconData icon;
  bool isCompleted;
  List<InspectionImages> imagesList;
  ServiceDataType({required this.title,required this.icon,required this.isCompleted,required this.imagesList});
}

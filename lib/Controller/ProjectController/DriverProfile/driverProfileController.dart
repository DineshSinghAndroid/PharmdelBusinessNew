import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/Shared%20Preferences/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Controller/ApiController/ApiController.dart';
import '../../../Controller/ApiController/WebConstant.dart';
import '../../../Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Model/DriverProfile/profileDriverResponse.dart';
import '../../../Model/Enum/enum.dart';
import '../../../main.dart';
import '../../Helper/Camera/CameraScreen.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';



class DriverProfileController extends GetxController{


  ApiController apiCtrl = ApiController();
  DriverProfileApiResponse? driverProfileData;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;
  Future<File> ? imageFile;

  double lat = 0.0;
  double lng = 0.0;

  Future<DriverProfileApiResponse?> driverProfileApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "":""
    };

    String url = WebApiConstant.GET_DRIVER_PROFILE_URL;

    await apiCtrl.getDriverProfileApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != "false") {
          try {
            if (result.status == "true") {
              driverProfileData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);
             
            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog("Status : ${result.status}");
            }

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
          PrintLog.printLog(result.status);
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
  void showStartMilesDialog(context) async {
    bool checkStartMiles = false;
    TextEditingController startMilesController = TextEditingController();
    File? image;
    String base64Image='';
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context1) {
          return StatefulBuilder(builder: (context, setStat) {
            return CustomDialogBox(
              // img: Image.asset("assets/delivery_truck.png"),
              descriptionWidget: Column(
                children: const [
                  Text(
                    "Enter miles",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "&",
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 17),
                  ),
                  Text(
                    "take speedometer picture",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              button2: TextButton(
                onPressed: () async {
                  if (startMilesController.text.toString().toString().isEmpty) {
                    Fluttertoast.showToast(msg: "Enter Start Miles");
                  } else if (image == null) {
                    Fluttertoast.showToast(msg: "Take Speedometer Picture");
                  } else {
                    Map<String, dynamic> prams = {
                      "entry_type": "start",
                      "start_miles": int.tryParse(
                          startMilesController.text.toString().trim()),
                      "end_miles": 0,
                      "end_miles_image": "",
                      "lat": "$lat",
                      "lng": "$lng",
                      "start_mile_image":
                      base64Image != null && base64Image.isNotEmpty
                          ? base64Image
                          : "",
                    };
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString(AppSharedPreferences.startMiles,
                        startMilesController.text.toString().trim());
                    updateStartMiles(context, prams);
                  }
                },
                child: Text("Okay",
                    style: TextStyle(fontSize: 18.0, color: Colors.black)),
              ),
              button1: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
              textField: TextField(
                controller: startMilesController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.blue),
                autofocus: false,
                onChanged: (value) {
                  setStat(() {});
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
                ],
                decoration: InputDecoration(
                  labelText: "Please enter start miles",
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  errorText: checkStartMiles ? "Enter Start Miles" : null,
                  contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              cameraIcon: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CameraScreen()))
                              .then((value) async {
                            if (value != null) {
                              setStat(() {
                                image = File(value);
                              });
                              final imageData = await image!.readAsBytes();
                              base64Image = base64Encode(imageData);
                            }
                          });
                        },
                        child: Container(
                          height: 75.0,
                          child: Image.asset("assets/images/speedometer.png"),
                        ),
                      ),
                      if (image != null)
                        SizedBox(
                          width: 10.0,
                        ),
                      if (image != null)
                        Container(
                          width: 70.0,
                          height: 70.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                    ],
                  ),
                  // if(vehicleList != null && vehicleList.isNotEmpty)
                  //   Text("Choose Vehicle", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),),
                  // // Row(
                  // //   children: [
                  // //     Checkbox(
                  // //       value: checkIdCar,
                  // //       visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                  // //       onChanged: (value){
                  // //         checkIdBike = false;
                  // //         checkIdCar = value;
                  // //         setStat(() {});setState(() {});
                  // //       },
                  // //     ),
                  // //     Text("Car", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
                  // //   ],
                  // // ),
                  // // if(checkIdCar && vehicleList != null && vehicleList.isNotEmpty)
                  // // Container(
                  // //   height: 30.0,
                  // //   child: ListView.builder(
                  // //     itemCount: vehicleList.length,
                  // //     shrinkWrap: true,
                  // //     scrollDirection: Axis.horizontal,
                  // //     itemBuilder: (context, index) {
                  // //       return Padding(
                  // //         padding: const EdgeInsets.only(left: 20.0),
                  // //         child: Row(
                  // //           children: [
                  // //             Radio(
                  // //               value: index,
                  // //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // //               groupValue: carId,
                  // //               visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                  // //               onChanged: (value){
                  // //                 setStat(() {
                  // //                   carId = value;
                  // //                 });
                  // //                 setState(() {});
                  // //               },
                  // //             ),
                  // //             Text(vehicleList[index].vehicleType ?? ""),
                  // //           ],
                  // //         ),
                  // //       );
                  // //     }),
                  // // ),
                  // // Row(
                  // //   children: [
                  // //     Checkbox(
                  // //       value: checkIdBike,
                  // //       visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                  // //       onChanged: (value){
                  // //         checkIdCar = false;
                  // //         carId = -1;
                  // //         checkIdBike = value;
                  // //         setState(() {});setStat(() {});
                  // //       },
                  // //     ),
                  // //     Text("Bike", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
                  // //   ],
                  // // ),
                  // // if(checkIdBike || carId >= 0)
                  // // SizedBox(
                  // //   height: 5.0,
                  // // ),
                  // // if(checkIdBike || carId >= 0)
                  // // Row(
                  // //   children: [
                  // //     Text("Registration No.: ", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),),
                  // //     Text("1235262", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),),
                  // //   ],
                  // // ),
                  // if(vehicleList != null && vehicleList.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.all(4.0),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.grey[700]),
                  //           borderRadius: BorderRadius.circular(50.0)
                  //       ),
                  //       child: DropdownButtonHideUnderline(
                  //         child: ButtonTheme(
                  //           alignedDropdown: true,
                  //           padding: EdgeInsets.zero,
                  //           child: DropdownButton<VehicleData>(
                  //             isExpanded: true,
                  //             value: selectedVehicle,
                  //             icon: Icon(Icons.arrow_drop_down),
                  //             iconSize: 24,
                  //             elevation: 16,
                  //             style: TextStyle(color: Colors.black),
                  //             underline: Container(
                  //               height: 2,
                  //               color: Colors.black,
                  //             ),
                  //             onChanged: (VehicleData newValue) {
                  //               setStat(() {
                  //                 selectedVehicle = newValue;
                  //               });
                  //             },
                  //             items: vehicleList
                  //                 .map<DropdownMenuItem<VehicleData>>(
                  //                     (VehicleData value) {
                  //                   return DropdownMenuItem<VehicleData>(
                  //                     value: value != null ? value : null,
                  //                     child: Container(
                  //                       height: 45.0,
                  //                       width: MediaQuery.of(context).size.width,
                  //                       alignment: Alignment.centerLeft,
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.only(left: 0.0),
                  //                         child: Text(
                  //                           "${value.name != null && value.name.isNotEmpty ? value.name : ""}${value.modal != null && value.modal.isNotEmpty ?" - " + value.modal : ""}${value.regNo != null && value.regNo.isNotEmpty ? " - " + value.regNo : ""}${value.color != null && value.color.isNotEmpty ? " - " + value.color : ""}".toUpperCase(),
                  //                           style: TextStyle(color: Colors.black),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 }).toList(),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            );
          });
        });
  }
  Future<void> updateStartMiles(
      BuildContext context1, Map<String, dynamic> prams) async {
    // PrintLog.printLog(prams['start_miles']);

    // await ProgressDialog(context, isDismissible: false).show();
    await CustomLoading().show(context1, true);
    PrintLog.printLog(AppSharedPreferences.updateMiles);
    PrintLog.printLog(prams);

  }
}


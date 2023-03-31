import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/GetPatient/getPatientApiResponse.dart';
import '../../PharmacyControllers/P_ProcessScanController/p_processScanController.dart';


class GetPatientContoller extends GetxController{

  ApiController apiCtrl = ApiController();
  List<PatientData>? patientData;
  Location location =  Location();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;


  ///OnTap Patient
   void onTileClicked({required int index, required BuildContext context}) {   
    if (patientData?[index].lastOrderId != null) {      
      PrintLog.printLog("Last order id is ${patientData?[index].lastOrderId}");
      String name = "";
      if (patientData?[index].firstName != null) name = "${patientData?[index].firstName.toString()} ";
      if (patientData?[index].middleName != null) name = "$name${patientData?[index].middleName.toString()} ";
      if (patientData?[index].lastName != null) name = "$name${patientData?[index].lastName.toString()} ";
      getProcessScanController.processScanApi(context: context, patientId: patientData?[index].customerId ?? "");      
    } else {      
      ToastCustom.showToast(msg: 'Order id not found');
    }
    //}
  }

  ///Process Scan Controller
  PharmacyProcessScanController getProcessScanController = Get.put(PharmacyProcessScanController());

  ///Get Patient List Controller
  Future<GetPatientApiResposne?> getPatientApi({required BuildContext context,required String firstName}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "firstName":firstName
    };

    String url = WebApiConstant.GET_PATIENT_LIST_URL;

    await apiCtrl.getPatientApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != false) {
          try {
            if (result.status == true) {              
              patientData = result.list;
              result.list == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);
              PrintLog.printLog(result.message);

            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog(result.message);
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


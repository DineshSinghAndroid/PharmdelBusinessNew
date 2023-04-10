import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';

import '../../../Model/ProcessScan/process_scan.dart';

class PharmacyProcessScanController extends GetxController {

  final ApiController _apiCtrl = ApiController();

  ProcessScanData? processScanData;  
  
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  ///Process Scan Controller  
  Future<ProcessScanApiResponse?> processScanApi({required BuildContext context, String? patientId, String? scanType, String? pharmacyId}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "patientid":patientId,
    "scan_type":scanType,
    "pharmacyId":pharmacyId,
    };

    String url = WebApiConstant.GET_PHARMACY_PROCESS_SCAN_URL;

    await _apiCtrl.getProcessScanApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
          try {
              processScanData = result.data;
              result.data == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);

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

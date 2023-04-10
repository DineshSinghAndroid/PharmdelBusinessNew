import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
<<<<<<< HEAD

import '../../../Model/PharmacyModels/P_MedicineListResponse/p_medicineListResponse.dart';
=======
import '../../../Model/PharmacyModels/P_MedicineListResponse/p_MedicineListResponse.dart';
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a


class GetMedicineListController extends GetxController{

  ApiController apiCtrl = ApiController();
  MedicineData? medicineData;  

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  ///Recieve Notification Controller
  Future<MedicineListApiResponse?> medicineListApi({required BuildContext context,required String searchValue}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "searchname":searchValue
    };

    String url = WebApiConstant.GET_PHARMACY_MEDICINE_LIST;

<<<<<<< HEAD
    await apiCtrl.p_getMedicineListApi(context:context,url: url, dictParameter: dictparm,token: authToken)
=======
    await apiCtrl.getMedicineListApi(context:context,url: url, dictParameter: dictparm,token: authToken)
>>>>>>> 8b081882a3eced9002e51a19f4537178dbc5c90a
        .then((result) async {
      if(result != null){
        if (result.error != true) {          
          try {            
            if (result.error == false) {              
              medicineData = result.medicineData;
              result.medicineData == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);
             

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


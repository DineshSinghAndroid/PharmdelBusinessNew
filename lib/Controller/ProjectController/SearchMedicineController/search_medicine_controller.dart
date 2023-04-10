import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/SearchMedicine/search_medicine_response.dart';


class SearchMedicineController extends GetxController{

  ApiController apiCtrl = ApiController();
  SearchMedicineData? medicineData;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  TextEditingController searchTextCtrl = TextEditingController();

  /// On Typing Medicine Name
  Future<void> onTypingText({required String value,required BuildContext context})async{
    if(value.toString().trim().isNotEmpty && value.length > 2){
      await medicineListApi(context: context, searchValue: value.toString().trim());
    }else{
      medicineData?.medicineListData?.clear();
      update();
    }
  }

  /// On Tap Clear
  Future<void> onTapClear()async{
    medicineData?.medicineListData?.clear();
    searchTextCtrl.clear();
    update();
  }


  /// Get Medicine List Api
  Future<SearchMedicineListApiResponse?> medicineListApi({required BuildContext context,required String searchValue}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "searchname":searchValue
    };

    String url = WebApiConstant.GET_MEDICINE_LIST;

    await apiCtrl.getMedicineListApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
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





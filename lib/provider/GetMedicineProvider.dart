import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:pharmdel_business/data/api_call_fram.dart';
import 'package:pharmdel_business/data/web_constent.dart';
import 'package:pharmdel_business/model/MedicineReaponse.dart';
import 'package:pharmdel_business/ui/login_screen.dart';
import 'package:pharmdel_business/util/custom_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMedicineProvider extends ChangeNotifier {
  List<MedicineDataList> selectedMedicineName = [];
  List<MedicineDataList> medicineList = [];
  ApiCallFram apiProvider = ApiCallFram();

  void getMedicineName(int index) {
    MedicineDataList dataList = medicineList[index];
    dataList.days = "";
    dataList.quntity = "";
    selectedMedicineName.add(dataList);
    notifyListeners();
  }

  void RemoveMedicineName(int index, List<TextEditingController> day, List<TextEditingController> qty) {
    selectedMedicineName.removeAt(index);
    day.removeAt(index);
    qty.removeAt(index);
    notifyListeners();
  }

  void clearSelctedList() {
    selectedMedicineName.clear();
    notifyListeners();
  }

  void clearMedicineList() {
    medicineList.clear();
    notifyListeners();
  }

  Future<List<MedicineDataList>> getMedicineList(context, String searchKey, dynamic pageNo, String accessToken) async {
    if (pageNo == 1) {
      medicineList.clear();
      // await ProgressDialog(context, isDismissible: false).show();
      CustomLoading().showLoadingDialog(context, true);
    }
    String url = WebConstant.GET_MEDICINELIST_PHARMACY + "?searchname=" + searchKey + "&page=$pageNo";
    // print(url);

    apiProvider.getDataRequestAPI(url, accessToken, context).then((response) async {
      // ProgressDialog(context).hide();
      CustomLoading().showLoadingDialog(context, false);
      try {
        if (response != null && response.body != null && response.body == "Unauthenticated") {
          Fluttertoast.showToast(msg: "Authentication Failed. Login again");
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          prefs.remove('userId');
          prefs.remove('name');
          prefs.remove('email');
          prefs.remove('mobile');
          prefs.remove('route_list');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              ModalRoute.withName('/login_screen'));
          return;
        }
        if (response != null) {
          MedicineReaponse model = MedicineReaponse.fromJson(json.decode(response.body));
          if (model != null && model.dataMain != null && model.dataMain.data != null) {
            medicineList.addAll(model.dataMain.data);
          }
        }
      } catch (_) {
        // print(_);
        Fluttertoast.showToast(msg: WebConstant.ERRORMESSAGE);
      }
    });
    notifyListeners();
    return medicineList;
  }

  void changeDays(int index, String value) {
    MedicineDataList dataList = selectedMedicineName[index];
    dataList.days = value;
    selectedMedicineName[index] = dataList;
    notifyListeners();
  }

  void changeQty(int index, String value) {
    MedicineDataList dataList = selectedMedicineName[index];
    dataList.quntity = value;
    selectedMedicineName[index] = dataList;
    notifyListeners();
  }
}

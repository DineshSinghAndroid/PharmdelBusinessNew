import 'dart:convert';

import 'package:get/get.dart';
import 'package:pharmdel/Controller/ApiController/ApiController.dart';

import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../main.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';

class GetDriverListController extends GetxController {
  final ApiController _apiCtrl = ApiController();

  List<DriverModel> driverList = [];
  DriverModel? selectedDriver;

  @override
  void onInit() {
    PrintLog.printLog("GetDriverListController is initialized::::::::");
    super.onInit();
    print(driverList.length);
  }

  Future<bool?> getDriverList(context) async {
    await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {"routeId": 23};
    driverList.clear();
    DriverModel driverModel = DriverModel();
    driverModel.driverId = 0;
    driverModel.firstName = "Select Driver";
    driverList.add(driverModel);

    String url = WebApiConstant.Get_PHARMACY_DriverList_ByRoute;
    await _apiCtrl.requestGetForDriverListApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
          driverList.clear();
          PrintLog.printLog("result.....${result.data[0]}");
          // // driverList = result;
          // for (var data in result) {
          //   print("data $data");
          // }
          List data = result.data;
          data.forEach((element) {
            DriverModel model = DriverModel();
            model.driverId = element["driverId"];
            model.firstName = element["firstName"];
            model.middleNmae = element["middleNmae"];
            model.lastName = element["lastName"];
            model.mobileNumber = element["mobileNumber"];
            model.emailId = element["emailId"];
            model.routeId = element["routeId"];
            model.route = element["route"];
            driverList.add(model);
          });

          print(driverList);

          PrintLog.printLog("Response of get driver list is :::::::>>>>>: $result");
        } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
        }
      } else {
        CustomLoading().show(context, false);

        update();
      }
    });
    update();
    CustomLoading().show(context, false);
    return null;
  }
}

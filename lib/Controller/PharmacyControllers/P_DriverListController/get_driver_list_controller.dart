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
  int selectedDriverPosition = 0;

  @override
  void onInit() {
    PrintLog.printLog("GetDriverListController is initialized::::::::");
    super.onInit();
    print(driverList.length);
  }

  Future<bool?> getDriverList({context, routeId}) async {
    PrintLog.printLog("GET DRIVER LIST INITIALIZED " );

    Map<String, dynamic> dictparm = {"routeId": routeId};
    driverList.clear();
    DriverModel driverModel = DriverModel();
    driverModel.driverId = '0';
    driverModel.firstName = "Select Driver";
    driverList.add(driverModel);

    String url = WebApiConstant.Get_PHARMACY_DriverList_ByRoute;
    await _apiCtrl.requestGetForDriverListApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {        
        try {                    
          driverList.clear();               
          List data = result.data;
          data.forEach((element) {
            DriverModel model = DriverModel();
            model.driverId = element["driverId"].toString();
            model.firstName = element["firstName"].toString();
            model.middleNmae = element["middleNmae"].toString();
            model.lastName = element["lastName"].toString();
            model.mobileNumber = element["mobileNumber"].toString();
            model.emailId = element["emailId"].toString();
            model.routeId = element["routeId"].toString();
            model.route = element["route"].toString();
            driverList.add(model);
          });

          PrintLog.printLog("Response_data: ${result}");

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

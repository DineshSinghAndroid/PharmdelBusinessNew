import 'package:get/get.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';

import '../../ApiController/ApiController.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class PDeliveriesScreenController extends GetxController {
  final ApiController _apiCtrl = ApiController();

  int selectedDriverPosition = 0;
  bool todaySelected = false;
  bool tomorrowSelected = false;
  bool otherDateSelected = false;
  @override
  void onInit() {
    getRouteListController.getRoutes();
    // TODO: implement onInit
    super.onInit();
  }

  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController getRouteListController = Get.put(PharmacyGetRouteListController());

  onRouteChange(value) async {
    getRouteListController.selectedRouteID = getRouteListController.routeList[int.parse(value)].routeId!;
    getRouteListController.selectedRouteName = value;

    PrintLog.printLog("Route id set to ::::>>>>>>${getRouteListController.selectedRouteID}");
    await getDriverListController.getDriverList(routeId: getRouteListController.selectedRouteID);
    onDriverChange(value);
    update();
  }

  onDriverChange(value) {
    getDriverListController.selectedDriverPosition = value;
    update();
  }

  onTodayTap()  {
    if(getRouteListController.selectedRouteID != 0){
      todaySelected = true;
      tomorrowSelected = false;
      otherDateSelected = false;



    }
    else{
      ToastCustom.showToast(msg: kSelectRoute);
      print(getRouteListController.selectedRouteName.toString());
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../ApiController/ApiController.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';


class PDashboardScreenController extends GetxController{
  final ApiController  apiCtrl = ApiController();


  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController  getRouteListController = Get.put(PharmacyGetRouteListController());





  Future<void> callGetRoutesApi({required BuildContext context})async{
    await getRouteListController.getRoutes(context: context).then((value) {
      PrintLog.printLog("Test print......${getRouteListController.routeList[0].routeName}");
      update();
    });
  }

  Future<void> callGetDriverListApi({required BuildContext context})async{
    await getDriverListController.getDriverList(context: context).then((value) {
      // PrintLog.printLog("Test print......${driverListController.driverList[0].toString()}");
      update();
    });

  }



}
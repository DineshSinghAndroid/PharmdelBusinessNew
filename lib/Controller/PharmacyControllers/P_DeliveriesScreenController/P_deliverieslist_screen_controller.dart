import 'package:get/get.dart';

import '../../ApiController/ApiController.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class PDeliveriesScreenController extends GetxController {
  final ApiController _apiCtrl = ApiController();

  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController getRouteListController = Get.put(PharmacyGetRouteListController());
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_pharmacy.dart';
import '../../../Model/PharmacyModels/P_GetRouteForPharmacy/P_GetRouteForPHarmacyModelResponse.dart';
import '../../Helper/LogoutController/logout_controller.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class PharmacyTrackOrderController extends GetxController {
  final ApiController _apiCtrl = ApiController();


  GetDriverListController driverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController  getRouteListController = Get.put(PharmacyGetRouteListController());
  String? selectedRouteValue ='';



   List<GetRouteForPharmacyModelResponse> pharmacyRouteList = [];
  String? accessToken, userType;

  String selectedDate = "";
  String showDatedDate = "";
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat formatterShow = DateFormat('dd-MM-yyyy');

  @override
  void onInit() {
     super.onInit();
    final DateTime now = DateTime.now();
    selectedDate = formatter.format(now);
    showDatedDate = formatterShow.format(now);
    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString(AppSharedPreferences.authToken);
      userType = value.getString(AppSharedPreferences.userType) ?? "";
     });

   }


  Future<void> callGetRoutesApi({required BuildContext context})async{
    await getRouteListController.getRoutes(context: context).then((value) {
      PrintLog.printLog("Test print......${getRouteListController.routeList[0].routeName}");
      update();
    });

  }



 }

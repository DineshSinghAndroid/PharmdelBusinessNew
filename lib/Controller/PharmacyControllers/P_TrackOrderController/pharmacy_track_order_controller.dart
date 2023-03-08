import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';
import '../../ProjectController/MainController/main_controller.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class PharmacyTrackOrderController extends GetxController {
  final ApiController _apiCtrl = ApiController();


  GetDriverListController driverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController  getRouteListController = Get.put(PharmacyGetRouteListController());


    int selectedRoutePosition = 0;
   int? selectedDriverPosition = 0;
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





 }

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';
import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Model/PharmacyModels/P_GetMapRoutesResponse/p_get_map_routes_response.dart';
import '../P_DriverListController/get_driver_list_controller.dart';
import '../P_NursingHomeController/p_nursinghome_controller.dart';
import '../P_RouteListController/P_get_route_list_controller.dart';

class PharmacyTrackOrderController extends GetxController {
  final ApiController _apiCtrl = ApiController();
  
  GetMapRoutesApiResponse? mapRoutesData;
  RouteList? selectedroute;  
  DriverModel? selectedDriver;

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;


  GetDriverListController getDriverListController = Get.put(GetDriverListController());

  PharmacyGetRouteListController  getRouteListController = Get.put(PharmacyGetRouteListController());

  NursingHomeController getNurHomeCtrl = Get.put(NursingHomeController());


  int selectedRouteID = 0;
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


  ///Select Route
  void onTapSelectedRoute(
      {required BuildContext context, required controller}) {
    PrintLog.printLog("Clicked on Select route");
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: selectedroute?.routeId,
      listType: "route",
      onValue: (value) async {
        if (value != null) {
          selectedroute = value;
          await getDriverListController.getDriverList(
              context: context, routeId: selectedroute?.routeId);
          update();
          PrintLog.printLog("Selected Route: ${selectedroute?.routeName}");
        }
      },
    );
  }

  ///Select Driver
  void onTapSelectedDriver(
      {required BuildContext context,
      required controller}) {
    PrintLog.printLog("Clicked on Select driver");    
    BottomSheetCustom.pShowSelectAddressBottomSheet(
      controller: controller,
      context: context,
      selectedID: selectedDriver?.driverId,
      listType: "driver",
      onValue: (value) async {
        if (value != null) {
          selectedDriver = value;
          await mapRoutesApi(
            context: context, 
            routeId: selectedroute?.routeId ?? "", 
            date: selectedDate, 
            driverId: selectedDriver?.driverId ?? "").then((value) {
              Get.toNamed(displayMapRoutesScreenRoute);
              update();
            });
          PrintLog.printLog("Selected Driver: ${selectedDriver?.firstName}");
        }
      },
    );
  }


  ///Get Map Routes Controller
  Future<GetMapRoutesApiResponse?> mapRoutesApi({required BuildContext context,required String routeId,required String date,required String driverId}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
    "routeId":routeId,
    "date":date,
    "driverID":driverId,
    };

    String url = WebApiConstant.GET_MAP_ROUTE_FOR_PHARMACY;

    await _apiCtrl.getMapRoutesApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
          try {
              mapRoutesData = result;
              result == null ? changeEmptyValue(true):changeEmptyValue(false);
              changeLoadingValue(false);
              changeSuccessValue(true);

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

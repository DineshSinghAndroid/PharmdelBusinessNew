import 'dart:convert';

import 'package:get/get.dart';
import 'package:pharmdel/Controller/ApiController/ApiController.dart';

import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
 import '../../../main.dart';
import '../../ApiController/WebConstant.dart';
 import '../../Helper/PrintLog/PrintLog.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';

class GetDriverListController extends GetxController
{

  List<GetDriverListModelResponsePharmacy> driverModelFromJson(String str) => List<GetDriverListModelResponsePharmacy>.from(json.decode(str).map((x) => GetDriverListModelResponsePharmacy.fromJson(x)));
  String driverModelToJson(List<GetDriverListModelResponsePharmacy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


  final ApiController _apiCtrl = ApiController();
  List  driverList = [];
   String? selectedDriverName = GetDriverListModelResponsePharmacy().firstName;


   @override
   void onInit() {
     PrintLog.printLog("GetDriverListController is initialized::::::::");
     super.onInit();
     print(driverList.length);
   }

  Future< GetDriverListModelResponsePharmacy?> getDriverList({context}) async{
    await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {

      "routeId":23

    };
    String url = WebApiConstant.Get_PHARMACY_DriverList_ByRoute;
    await _apiCtrl.requestGetForDriverListApi(context: context, url: url,
        dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
          PrintLog.printLog("Response: $result");

             driverList.addAll(List<GetDriverListModelResponsePharmacy>.from(json.decode(result.data).map((x) => GetDriverListModelResponsePharmacy.fromJson(x))));




          // PrintLog.printLog("Driver ID Response ${driverList[0].firstName.toString()}");


        } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
        }
      }
      else {
        CustomLoading().show(context, false);

         update();
      }
    }
    );
    update();
    CustomLoading().show(context, false);


  }


}
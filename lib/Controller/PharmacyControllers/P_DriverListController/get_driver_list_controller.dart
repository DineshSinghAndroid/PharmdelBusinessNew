import 'package:get/get.dart';
import 'package:pharmdel/Controller/ApiController/ApiController.dart';
import 'package:pharmdel/Model/DriverRoutes/driverRoutesResponse.dart';

import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../main.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/LogoutController/logout_controller.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

class GetDriverListController extends GetxController
{
   final ApiController _apiCtrl = ApiController();
  List driverList = [];


   @override
   void onInit() {
     PrintLog.printLog("GetDriverListController is initlized::::::::");
     super.onInit();
   }

  Future< GetDriverListModelResponsePharmacy?> getDriverList({context}) async{
    await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {

      "routeId":23

    };
    String url = WebApiConstant.Get_PHARMACY_DriverList_ByRoute;
    await _apiCtrl.getDriverListPharmacy(context: context, url: url,
        dictParameter: dictparm, token: authToken).then((_result) {
      if (_result != null) {
        try {
          driverList.add(GetDriverListModelResponsePharmacy);

          print("Driver ID Response ${driverList.toString()}");
          // driverList.addAll(_result.!);

          // print("HELLOssss2 ${routeList[0].routeName}");

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
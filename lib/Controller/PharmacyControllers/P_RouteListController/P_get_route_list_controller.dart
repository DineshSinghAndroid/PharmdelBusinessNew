import 'package:get/get.dart';
import 'package:pharmdel/main.dart';

import '../../../Model/PharmacyModels/P_GetDriverRoutesListPharmacy/P_get_driver_route_list_model_pharmacy.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';
import '../../WidgetController/Toast/ToastCustom.dart';

class PharmacyGetRouteListController extends GetxController {
  final ApiController _apiCtrl = ApiController();
  List<RouteList> routeList = [];
  String? selectedRouteName = RouteList().routeName;
  int selectedRouteID = 0;
  @override
  void onInit() {
     super.onInit();
  }

  Future<GetDriverRouteListModelResponse?> getRoutes({context}) async {
     await CustomLoading().show(context, true);

    Map<String, dynamic> dictparm = {};
    String url = WebApiConstant.GET_ROUTE_URL_PHARMACY;
    await _apiCtrl.getRouteListApiPharmacy(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
           routeList.addAll(result.routeList!);

         } catch (_) {
          CustomLoading().show(context, false);

          PrintLog.printLog("Exception : $_");
          ToastCustom.showToast(msg: result.message ?? "");
        }
      } else {
        CustomLoading().show(context, false);

        PrintLog.printLog(result?.message);
        ToastCustom.showToast(msg: result?.message ?? "");
        update();
      }
    });
    update();
    CustomLoading().show(context, false);
  }
}

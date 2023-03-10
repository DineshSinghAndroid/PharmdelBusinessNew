import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ApiController/ApiController.dart';

import '../../../main.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';
import '../../WidgetController/Loader/LoadingScreen.dart';

class GetDeliveryListController extends GetxController{
  ApiController _apiCtrl = ApiController();
  Future getDeliveryList({context}) async {
    PrintLog.printLog("GET DELIVERY LIST INITIALIZED " );
    String  date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Map<String, dynamic> dictparm = {
      "routeId":23,
      "dateTime":date,
      "driverId":8530,

    };
    await CustomLoading().show(context, true);


    String url = WebApiConstant.GET_PHARMACY_DELIVERY_LIST;
    await _apiCtrl.getPharmacyDeliveryListApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result) {
      if (result != null) {
        try {
           PrintLog.printLog("result.....${result.data[0].toString()}");

          List data = result.data;
          // data.forEach((element) {
          //   DriverModel model = DriverModel();
          //   model.driverId = element["driverId"];
          //   model.firstName = element["firstName"];
          //   model.middleNmae = element["middleNmae"];
          //   model.lastName = element["lastName"];
          //   model.mobileNumber = element["mobileNumber"];
          //   model.emailId = element["emailId"];
          //   model.routeId = element["routeId"];
          //   model.route = element["route"];
          //   driverList.add(model);
          // });


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
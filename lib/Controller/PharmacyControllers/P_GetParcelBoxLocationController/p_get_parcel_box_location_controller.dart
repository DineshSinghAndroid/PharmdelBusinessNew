import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../Model/ParcelBox/parcel_box_response.dart';
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../Helper/PrintLog/PrintLog.dart';

class GetParcelBoxLocationController extends GetxController{



  final ApiController _apiCtrl = ApiController();

  ///Dropdown select Parcel Box
  List<ParcelBoxData>? ParcleBoxList;
  String ? selectParcelBoxLocation;







  ///Get parcel box data
  Future<GetParcelBoxApiResponse?> getParcelBoxApi({required BuildContext context,required String driverId,}) async {


    Map<String, dynamic> dictparm = {"driverId":driverId};

    String url = WebApiConstant.GET_PHARMACY_PARCEL_BOX_URL;

    await _apiCtrl.getParcelBoxApi(context: context, url: url, dictParameter: dictparm, token: authToken).then((result)
    async {
      if (result != null) {
        try {
          if (result.error == false) {
            ParcleBoxList = result.data;
            print(ParcleBoxList?.length.toString());
            print("Hello world parcel box testing ${result.data![0].name}");

          } else {

            PrintLog.printLog(result.message);
          }
        } catch (_) {

          PrintLog.printLog("Exception : $_");
        }
      } else {

      }
    });

    update();
  }

}
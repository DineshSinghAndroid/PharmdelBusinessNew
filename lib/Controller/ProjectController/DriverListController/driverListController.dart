// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../Controller/ApiController/ApiController.dart';
// import '../../../Controller/ApiController/WebConstant.dart';
// import '../../../Controller/Helper/PrintLog/PrintLog.dart';
// import '../../../Model/GetPatient/getPatientApiResponse.dart';
// import '../../../main.dart';
//
//
// class DriverListController extends GetxController{
//
//   ApiController apiCtrl = ApiController();
//
//   bool isLoading = false;
//   bool isError = false;
//   bool isEmpty = false;
//   bool isNetworkError = false;
//   bool isSuccess = false;
//
//   Future<GetPatientApiResposne?> driverListApi({required BuildContext context,required String routeId}) async {
//
//     changeEmptyValue(false);
//     changeLoadingValue(true);
//     changeNetworkValue(false);
//     changeErrorValue(false);
//     changeSuccessValue(false);
//
//     Map<String, dynamic> dictparm = {
//     "routeId":routeId
//     };
//
//     String url = WebApiConstant.Get_PHARMACY_DriverList_ByRoute;
//
//     await apiCtrl.getDriverListApi(context:context,url: url, dictParameter: dictparm,token: authToken)
//         .then((result) async {
//       if(result != null){
//         if (result != false) {
//           try {
//             if (result == true) {
//               changeLoadingValue(false);
//               changeSuccessValue(true);
//               PrintLog.printLog("Get driver list successfully.");
//
//             } else {
//               changeLoadingValue(false);
//               changeSuccessValue(false);
//               // PrintLog.printLog(result.message);
//             }
//
//           } catch (_) {
//             changeSuccessValue(false);
//             changeLoadingValue(false);
//             changeErrorValue(true);
//             PrintLog.printLog("Exception : $_");
//           }
//         }else{
//           changeSuccessValue(false);
//           changeLoadingValue(false);
//           changeErrorValue(true);
//           // PrintLog.printLog(result.message);
//         }
//       }else{
//         changeSuccessValue(false);
//         changeLoadingValue(false);
//         changeErrorValue(true);
//       }
//     });
//     update();
//   }
//
//
//   void changeSuccessValue(bool value){
//     isSuccess = value;
//     update();
//   }
//   void changeLoadingValue(bool value){
//     isLoading = value;
//     update();
//   }
//   void changeEmptyValue(bool value){
//     isEmpty = value;
//     update();
//   }
//   void changeNetworkValue(bool value){
//     isNetworkError = value;
//     update();
//   }
//   void changeErrorValue(bool value){
//     isError = value;
//     update();
//   }
// }
//

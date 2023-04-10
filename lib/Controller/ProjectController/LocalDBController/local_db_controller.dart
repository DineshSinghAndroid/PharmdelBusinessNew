import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../DB_Controller/MyDatabase.dart';
import '../MainController/main_controller.dart';


class LocalDBController extends GetxController {
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  ExemptionsDataCompanion? exemptionsDataCompanion;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Exemptions
  Future<void> saveExemptions({required List<Exemptions> exemptions})async {

    /// Remove exemptions list
    await MyDatabase().deleteExemptionList().then((value) async {

      /// Add exemptions list
      await Future.forEach(exemptions, (Exemptions element) async {
        ExemptionsDataCompanion exemptionsDataCompanion;
        exemptionsDataCompanion = ExemptionsDataCompanion.insert(
            exemptionId: element.id != null ? int.tryParse(element.id.toString() ?? "0")! : 0,
            serialId: element.serialId != null && element.serialId!.isNotEmpty ? element.serialId ?? "" : "",
            name: element.code != null && element.code!.isNotEmpty ? element.code ?? "" : ""
        );
        await MyDatabase().insertExemption(exemptionsDataCompanion);
      });

    });

  }

  /// Local DB Method
  Future<void> checkPendingCompleteDataInDB({required BuildContext context})async{
    await MyDatabase().getAllOrderCompleteData().then((value) async {
      if(value.isNotEmpty){
        PrintLog.printLog("Found Completed Data in DB::::::::");
        await Future.forEach(value, (element) async {
          completeDataUpload(
            context: context,
            remarks: element.remarks,
            deliveredTo: element.deliveredTo,
            deliveryId: element.deliveryId.toString().split(","),
            routeId: element.routeId,
            exemptionId: element.exemptionId.toString() ?? "",
            paymentStatus: element.paymentStatus,
            userId: element.userId.toString() ?? "",
            paymentMethode: element.paymentMethode,
            addDelCharge: element.addDelCharge,
            notPaidReason: element.notPaidReason,
            subsId: element.subsId.toString(),
            rxInvoice: element.rxInvoice,
            rxCharge: element.rxCharge,
            mobileNo: element.param1,
            failedRemark: element.param2,
            customerRemarks: element.customerRemarks,
            baseSignature: element.baseSignature,
            deliveryStatus: element.deliveryStatus.toString() ?? "",
            reScheduleDate: element.reschudleDate,
            baseImage: element.baseImage,
            latitude: element.latitude.toString() ?? "0",
            longitude: element.longitude.toString() ?? "0",
          );
        });
      }else{
        PrintLog.printLog("Not Available Completed Data in DB::::::::");
      }
    });
  }


  /// Data Upload Api
  Future<void> completeDataUpload({
    required BuildContext context,required String remarks,
    required String deliveredTo, required deliveryId,
    required String routeId, required String exemptionId,
    required String paymentStatus, required String userId,
    required String paymentMethode, required String addDelCharge,
    required String notPaidReason, required String subsId,
    required String rxInvoice, required String rxCharge,
    required String mobileNo, required String failedRemark,
    required String customerRemarks, required String baseSignature,
    required String deliveryStatus, required String reScheduleDate,
    required String baseImage, required String latitude,
    required String longitude,
  }) async {

    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> prams = {
      "remarks": remarks,
      "deliveredTo": deliveredTo,
      "deliveryId": deliveryId,
      "routeId": routeId,
      "exemption": exemptionId,
      "paymentStatus": paymentStatus,
      "driverId": userId,
      "payment_method": paymentMethode,
      "del_charge": addDelCharge,
      "payment_remark": notPaidReason,
      "subs_id": subsId,
      "rx_invoice": rxInvoice,
      "rx_charge": rxCharge,
      "mobileNo": mobileNo,
      "failed_remark": failedRemark,
      "customerRemarks": customerRemarks,
      "baseSignature": baseSignature,
      "DeliveryStatus": deliveryStatus,
      "rescheduleDate": reScheduleDate,
      "customerImage": baseImage,
      "questionAnswerModels": "",
      "latitude": latitude,
      "longitude": longitude
    };

    String url = WebApiConstant.DELIVERY_SIGNATURE_UPLOAD_URL;

      apiCtrl.completeDataUploadAPI(context: context,url: url,dictParameter: prams).then((response) async {

        try {
          if (response != null) {
            if (response.data["status"].toString().toLowerCase() == "true") {
              changeLoadingValue(false);
              changeSuccessValue(true);
              // await MyDatabase().deleteCompletedDeliveryByOrderId(deliveryId.toString());

            }else{
              changeLoadingValue(false);
              changeSuccessValue(false);
            }
          }else{
            changeLoadingValue(false);
            changeSuccessValue(false);
          }
        } catch (e, stackTrace) {
          changeLoadingValue(false);
          changeSuccessValue(false);
          changeErrorValue(true);
          SentryExemption.sentryExemption(e, stackTrace);
          PrintLog.printLog("Ex____:$e");
        }
      }).catchError((onError) async {
        changeLoadingValue(false);
        changeSuccessValue(false);
        changeErrorValue(true);
        PrintLog.printLog("Ex____2:$onError");
      });

    update();
  }



  void changeSuccessValue(bool value) {
    isSuccess = value;
    update();
  }

  void changeLoadingValue(bool value) {
    isLoading = value;
    update();
  }

  void changeNetworkValue(bool value) {
    isNetworkError = value;
    update();
  }

  void changeErrorValue(bool value) {
    isError = value;
    update();
  }


}
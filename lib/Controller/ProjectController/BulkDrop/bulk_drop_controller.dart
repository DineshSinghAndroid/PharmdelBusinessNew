import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/ConnectionValidator/internet_check_return.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/DriverProfile/profile_driver_response.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../WidgetController/Popup/popup.dart';
import '../../WidgetController/QrCode/ar_code.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';




class BulkDropController extends GetxController{


  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  List<RelatedOrders> orderList = [];
  TextEditingController toController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  DriverProfileApiResponse? driverProfileApiResponse;



  String routeId = "";

  var yetToStartColor = const Color(0xFFF8A340);
  bool isFridgeNote = false, isControlledDrugs = false, isControlNote = false;
  bool isDeliveryNote = true;




  @override
  void onInit() {
    super.onInit();
  }

  Future<void> scanBarcodeNormal({required BuildContext context}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await ScannerCustom.getQrCode() ?? "";
      // barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#7EC3E6", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes != "-1") {
        FlutterBeep.beep();
        await getOrderDetails(context: context,orderId: barcodeScanRes,isScan:  true, isComplete: true);
      } else {
        ToastCustom.showToast(msg: kFormatNotCorrect);
      }
    } on PlatformException {
      barcodeScanRes = kFailedToGetPlatformVersion;
    }
  }

  ///Order Details Api // model check
  Future<void> getOrderDetails({required BuildContext context,required String orderId, required bool isScan, required bool isComplete}) async {
    await InternetCheck.check();

    Map<String, dynamic> dictparm = {
      "orderIdMain":"0",
      "OrderId":orderId,
      "driverId":userID,
      "isScan":isScan,
      "routeId":routeId,
      "isComplete":isComplete,
    };


    String url = WebApiConstant.SCAN_ORDER_BY_DRIVER;

    await apiCtrl.getOrderDetailApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
        try {
          if (result != null) {
            // OrderModal modal = orderModalFromJson(result);
            if ((result.message == "") || isComplete || result.deliveryStatusDesc?.toLowerCase() == kReceived.toLowerCase() || result.deliveryStatusDesc?.toLowerCase() == kReady.toLowerCase() || result.deliveryStatusDesc?.toLowerCase() == kRequested.toLowerCase()) {
              if (result.deliveryStatusDesc.toString().toLowerCase() == kCompleted.toLowerCase()) {
                ToastCustom.showToast(msg: kThisOrderAlreadyCompleted);
              } else if (result.deliveryStatusDesc.toString().toLowerCase() == kOutForDelivery.toLowerCase()) {
                if (result.relatedOrders != null && result.relatedOrders!.isNotEmpty && result.relatedOrders!.length > 1) {
                  List<RelatedOrders> relateOrder = [];
                  result.relatedOrders?.forEach((element1) {
                    int indelx = orderList.indexWhere((element) => element.orderId == element1.orderId);
                    if (indelx < 0) {
                      relateOrder.add(element1);
                    }
                  });
                  if (relateOrder.isNotEmpty) {
                    result.relatedOrders = relateOrder;
                    PopupCustom.showAlertOrderPopUp(
                        onValue: (value){

                        },
                        context: context,
                        descriptions: "${result.relatedOrderCount} more delivery for this address. Would you like to deliver?",
                        onClicked: (value){
                        ///  showOrderList(result, value);
                        }
                    );
                  } else {
                    ToastCustom.showToast(msg: kThisOrderAlreadyExits);
                  }
                } else {
                  if (orderList.isNotEmpty) {
                    int isAlreadyExits = orderList.indexWhere((element) => element.orderId == result.orderId);
                    if (isAlreadyExits < 0) {
                      PrintLog.printLog(orderList.last.fullAddress);
                      PrintLog.printLog(result.address?.address1);
                      if (orderList.last.fullAddress != null && result.address != null && orderList.last.fullAddress == result.address?.address1) {
                        orderList.add(result.relatedOrders![0]);
                      } else {
                        PopupCustom.showConfirmationDialog(
                            onValue: (value){
                              update();
                            },
                            onPressed: (){
                              if (result.relatedOrders != null && result.relatedOrders!.isNotEmpty) {
                                orderList.add(result.relatedOrders![0]);
                                Navigator.of(context).pop(true);
                              }
                            },
                            context: context,
                        );
                      }
                    } else {
                      ToastCustom.showToast(msg: kThisOrderAlreadyExits);
                    }
                  } else {
                    if (result.relatedOrders != null && result.relatedOrders!.isNotEmpty) orderList.add(result.relatedOrders![0]);
                  }
                }
              } else {
                ToastCustom.showToast(msg: kThisOrderAlreadyOutForDelivery);
              }
            } else if (result.message != null) {
              ToastCustom.showToast(msg: result.message ?? "");
            } else {

            }
          }
          changeLoadingValue(false);
          changeSuccessValue(true);
        } catch (_) {
          changeSuccessValue(false);
          changeLoadingValue(false);
          changeErrorValue(true);
          PrintLog.printLog("Exception : $_");
        }
    });
    update();
  }


  void onTapScanOrder({required BuildContext context}){
    PrintLog.printLog("Clicked on Add order");
  }

  /// Show bottom sheet
  void onTapComplete({required BuildContext context,required BulkDropController controller}){
    PrintLog.printLog("Clicked on Complete");
    BottomSheetCustom.showBulkDropBottomSheet(
        controller: controller,
        onValue: (value){
          if(value == kSkip){
            PrintLog.printLog("Clicked on Skip");
            redirectNextScreen(context: context);
          }else if(value == kContinue){
            PrintLog.printLog("Clicked on Continue");
            redirectNextScreen(context: context);
          }
        },
        context: context,
    );
  }



  void redirectNextScreen({required BuildContext context}) {
    if (!isDeliveryNote) {
      ToastCustom.showToast(msg: kCheckCDFridgeDeliveryNote);
      return;
    }
    if (orderList.isEmpty) {
      return;
    }
    List orderId = [];

    orderList.forEach((element) {
      orderId.add(element.orderId.toString());
    });

    int index = orderList.indexWhere((element) => element.isControlledDrugs == true);

    Get.toNamed(signOrImageScreenRoute);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ClickImage(
    //           delivery: null,
    //           routeId: routeId,
    //           isCdDelivery: index != null && index >= 0 ? orderList[index].isControlledDrugs : false,
    //           selectedStatusCode: 5,
    //           remarks: remarkController.text,
    //           deliveredTo: toController.text,
    //           orderid: orderId,
    //         ))
    // );
  }


  void onTapRemoveOrder({required int index}){
    PrintLog.printLog("Clicked on Remove Product");
    orderList.removeAt(index);
    update();
  }


  Future<DriverProfileApiResponse?> driverProfileApi({required BuildContext context,}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "":""
    };

    String url = WebApiConstant.GET_DRIVER_PROFILE_URL;

    await apiCtrl.getDriverProfileApi(url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        if (result.status != "false") {
          try {
            if (result.status == "true") {
              driverProfileApiResponse = result;

              changeLoadingValue(false);
              changeSuccessValue(true);

            } else {
              changeLoadingValue(false);
              changeSuccessValue(false);
              PrintLog.printLog("Status : ${result.status}");
            }

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
          PrintLog.printLog(result.status);
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


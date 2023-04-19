import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/TimeChecker/timer_checker.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../../View/SignOrImage/singnature_pad.dart';
import '../../DB_Controller/MyDatabase.dart';
import '../../Helper/LogoutController/logout_controller.dart';
import '../../WidgetController/GoToDashboard/go_to_dashboard.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/Popup/popup.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../Helper/SentryExemption/sentry_exemption.dart';
import '../DriverDashboard/driver_dashboard_ctrl.dart';
import '../LocalDBController/local_db_controller.dart';

class SignOrImageController extends GetxController {
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  File? imageCaptured;
  String? imageCapturedInBase64Encode;
  String? signatureCapturedInBase64Encode;
  bool isAvlInternet = false;
  bool isDialogShowing = false;
  String? userId, userType, routeID;

  LocalDBController dbCTRL = Get.find();
  DriverDashboardCTRL dashCTRL = Get.find();


  OrderCompleteDataCompanion? orderCompleteObj;

  double latitude = 0.0;
  double longitude = 0.0;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }



  /// InitState Call Method
  Future<void> init({required BuildContext context,required String routeId})async{

    userId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId);
    userType = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userType);
    routeID = routeId;
    TimeCheckerCustom.checkLastTime(context: context);
  }

  /// Click on Camera
  Future getImage({required BuildContext context}) async {
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CameraScreen()
          )).then((value) async {
        if (value != null) {
          imageCaptured = File(value);
          final imageData = File(value);
          final image = await imageData.readAsBytes();
          imageCapturedInBase64Encode = base64Encode(image);

          PrintLog.printLog("Clicked  ${imageCaptured?.path}");
          update();
        }
      });
    } catch (e, stackTrace) {
      SentryExemption.sentryExemption(e, stackTrace);
    }
  }

  /// On Tap Clear Btn
  Future<void> onTapClear({required SignatureState? currentState})async{
      currentState?.clear();
      signatureCapturedInBase64Encode = null;
    update();
  }


  /// On Tap Save or Skip Btn
  Future<void> onTapSave({required BuildContext context,
    required GlobalKey<SignatureState> signKey,
    required String onTapActionType,

    required OrderDetailResponse delivery,
    required final String remarks,
    required final String deliveredTo,
    required int selectedStatusCode,
    required List<String> orderIDs,
    required List<DeliveryPojoModal> outForDelivery,
    required String routeId,
    required String rescheduleDate,
    required String failedRemark,
    required String paymentStatus,
    required int exemptionId,
    required String mobileNo,
    required String addDelCharge,
    required int subsId,
    required String paymentType,
    required String rxInvoice,
    required String rxCharge,
    required String amount,
    required bool isCdDelivery,
    required String notPaidReason,})async{
    PrintLog.printLog(
        "log Print::::::::::::::"
            "\nremarks: $remarks"
            "\ndeliveredTo: $deliveredTo"
            "\nselectedStatusCode: $selectedStatusCode"
            "\norderIDs: $orderIDs"
            "\noutForDelivery: $outForDelivery"
            "\nrouteId: $routeId"
            "\nrescheduleDate: $rescheduleDate"
            "\nfailedRemark: $failedRemark"
            "\npaymentStatus: $paymentStatus"
            "\nexemptionId: $exemptionId"
            "\nmobileNo: $mobileNo"
            "\naddDelCharge: $addDelCharge"
            "\nsubsId: $subsId"
            "\npaymentType: $paymentType"
            "\nrxInvoice: $rxInvoice"
            "\nrxCharge: $rxCharge"
            "\namount: $amount"
            "\nisCdDelivery: $isCdDelivery"
            "\nnotPaidReason: $notPaidReason"
    );

    isAvlInternet = await ConnectionValidator().check();
    final sign = signKey.currentState;
    if (sign != null && sign.points.isNotEmpty) {
      final image = await sign.getData();
      var data = await image.toByteData(format: ui.ImageByteFormat.png);
      sign.clear();
      signatureCapturedInBase64Encode = base64.encode(data!.buffer.asUint8List());
    }

    if(isCdDelivery == true && signatureCapturedInBase64Encode == null && selectedStatusCode != 6){
      ToastCustom.showToast(msg: kPleaseWriteSign);
    }else if (selectedStatusCode == 5 || selectedStatusCode == 6) {
      try {
        if (userId == null || userId!.isEmpty) {
          userId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId);
        }
        if (userId != null && userId!.isNotEmpty && userId != "0" && userId != "" && userId != "null") {


          orderCompleteObj = OrderCompleteDataCompanion.insert(
              remarks: remarks ?? "",
              notPaidReason: notPaidReason.isNotEmpty ? notPaidReason : "",
              addDelCharge: addDelCharge ?? "",
              subsId: subsId ?? 0,
              rxCharge: rxCharge ?? "",
              rxInvoice: rxInvoice ?? "",
              paymentMethode: paymentType ?? "",
              exemptionId: exemptionId ?? 0,
              paymentStatus: paymentStatus.isNotEmpty ? paymentStatus : "",
              userId: int.tryParse(userId.toString()) ?? 0,
              baseImage: onTapActionType.toLowerCase() == kSkip.toLowerCase() ? "" : imageCapturedInBase64Encode != null && imageCapturedInBase64Encode != "" ? imageCapturedInBase64Encode ?? "" : "",
              deliveredTo: deliveredTo,
              deliveryId: orderIDs.join(","),
              routeId: routeId ?? "",
              customerRemarks: remarks ?? "",
              baseSignature: onTapActionType.toLowerCase() == kSkip.toLowerCase() ? "" : signatureCapturedInBase64Encode != null  ? signatureCapturedInBase64Encode ?? "":"",
              deliveryStatus: selectedStatusCode ?? 0,
              questionAnswerModels: "",
              reschudleDate: rescheduleDate ?? "",
              param1: mobileNo ?? "",
              param2: failedRemark ?? "",
              param5: "",
              param6: "",
              param7: "",
              param4: "",
              param8: "",
              param3: "",
              param9: "$latitude",
              param10: "$longitude",
              date_Time: "${DateTime.now().millisecondsSinceEpoch}",
              latitude: latitude,
              longitude: longitude);

          /// Get Location
          getLocationByClick();
          PrintLog.printLog("USER CURRENT LOCATION IS in OrderComplete Database is   " + latitude.toString() + "  " + longitude.toString());

          String status = "Completed";
          if (selectedStatusCode == 5) {
            status = "Completed";
          } else if (selectedStatusCode == 6) {
            status = "Failed";
          }
          PrintLog.printLog("Data Added........:::::");
          await MyDatabase().insertOrderCompleteData(orderCompleteObj!);
          await Future.forEach(orderIDs, (element) async {
            await MyDatabase().updateDeliveryStatus(int.tryParse(element.toString() ?? "0") ?? 0, status, selectedStatusCode);
          });

          if (!isAvlInternet) {

            /// Go to Dashboard
            GoToDashboard.popUntil(context: context);

          } else {

            if (outForDelivery.length - orderIDs.length != 1) {
              GoToDashboard.popUntil(context: context);
            }
            if (outForDelivery.length - orderIDs.length == 1) {
              checkOfflineDeliveryAvailable(context: context,outForDelivery: outForDelivery);
            }

          }
        } else {

          /// For logout
          logOut();
        }
      } catch (e, stackTrace) {
        SentryExemption.sentryExemption(e, stackTrace);
        ToastCustom.showToastWithLength(msg: e.toString());
      }
    }else{
      ToastCustom.showToastWithLength(msg: "Status Code:$selectedStatusCode");
    }
  }



  /// Check Offline Delivery
  Future<void> checkOfflineDeliveryAvailable({required BuildContext context,required outForDelivery}) async {
      isDialogShowing = true;
      showDialog(
          context: Get.overlayContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: CustomDialogBox(
                icon: const Icon(Icons.timer),
                title: kAlert,
                descriptions: kUpdatingAndEndingRouteMsg,
              ),
            );
          }
          );
      await dbCTRL.checkPendingCompleteDataInDB(context: context).then((value) async {
        await endRoute(context: context);
        // GoToDashboard.popUntil(context: context);
      });
  }

  /// End Route Api
  Future<void> endRoute({required BuildContext context}) async {
    if(isDialogShowing == true){
      Get.back();
    }

    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    String url = "";
    if (userType?.toLowerCase() == kPharmacy.toLowerCase() || userType?.toLowerCase() == kPharmacyStaffString.toLowerCase()) {
      changeLoadingValue(false);
      changeSuccessValue(false);
      GoToDashboard.popUntil(context: context);
      return;
    } else {

      Map<String, dynamic> dictparm = {
        "routeId":routeID,
      };

      url = WebApiConstant.END_ROUTE_BY_DRIVER;

      apiCtrl.endRoutesAPI(context: context,url: url,dictParameter: dictparm).then((response) async {

        try {
          if (response != null) {
            if (response.data.toString().toLowerCase() == "true") {
              changeLoadingValue(false);
              changeSuccessValue(true);
              dashCTRL.isRouteStart = false;
              dashCTRL.orderListType = 8;
              dashCTRL.systemDeliveryTime = null;
              var deliveryListData = await MyDatabase().getAllOutForDeliveriesOnly();
              if (deliveryListData == null || deliveryListData.isEmpty) {
                AppSharedPreferences.removeValueToSharedPref(variableName: AppSharedPreferences.deliveryTime);
                if (dashCTRL.stopWatchTimer != null) {
                  PrintLog.printLog("stopwatch disposed");
                  dashCTRL.showIncreaseTime = false;
                  dashCTRL.stopWatchTimer?.dispose();
                  dashCTRL.stopWatchTimer = null;
                }
              }
              AppSharedPreferences.addStringValueToSharedPref(variableName: AppSharedPreferences.isStartRoute, variableValue: "false");
              autoEndRoutePopUp(context: context);
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
          String jsonUser = jsonEncode(e);
          ToastCustom.showToast(msg: jsonUser);
        }
      }).catchError((onError) async {
        changeLoadingValue(false);
        changeSuccessValue(false);
        changeErrorValue(true);
        String jsonUser = jsonEncode(onError);
        ToastCustom.showToast(msg: jsonUser);
      });
    }
    update();
  }

  /// End Route PopUP
  void autoEndRoutePopUp({required BuildContext context}) {
    PopupCustom.simpleTruckDialogBox(
        context: context,
        onValue: (value){

        },
        btnBackTitle: "",
        title: kAlert,
        subTitle: kRouteEnd,
        btnActionTitle: kOkay,
        onTapActionBtn: ()async {
          GoToDashboard.popUntil(context: context);
          await dashCTRL.driverDashboardApi(context: context);

        }
    );

  }

  /// Logout
  Future<void> logOut() async {
    ToastCustom.showToast(msg: kSystemProblemMsg);
    LogoutController().logoutWithoutApi;
  }

  /// Get Location
  Future getLocationByClick() async {
    LocationSettings? locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),

          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: kExampleNotificationText,
            notificationTitle: kRunningInBackground,
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(accuracy: LocationAccuracy.high,activityType: ActivityType.fitness,distanceFilter: 100,pauseLocationUpdatesAutomatically: true,showBackgroundLocationIndicator: false,);
    } else {
      locationSettings = const LocationSettings(accuracy: LocationAccuracy.high,distanceFilter: 100);
    }

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) async {
      PrintLog.printLog(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
      latitude = position.latitude;
      longitude = position.longitude;

      PrintLog.printLog("$latitude${longitude}Calling Location Class::\nLat:$latitude\nLng:$longitude");
    });
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

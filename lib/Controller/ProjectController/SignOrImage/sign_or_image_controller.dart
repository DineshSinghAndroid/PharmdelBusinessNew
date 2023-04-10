import 'dart:async';
import 'dart:convert';
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
import '../../Helper/Base64/base_64_converter.dart';
import '../../Helper/LogoutController/logout_controller.dart';
import '../../WidgetController/GoToDashboard/go_to_dashboard.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/Popup/popup.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../MainController/main_controller.dart';

class SignOrImageController extends GetxController {
  ApiController apiCtrl = ApiController();
  ImagePickerController? imagePicker = Get.put(ImagePickerController());


  bool isLoading = false;
  bool isError = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  String? userId, userType, routeId;
  ByteData? signatureData;
  String? imageBase64Data;
  OrderCompleteDataCompanion? orderCompleteObj;

  double lat = 0.0;
  double lng = 0.0;
  bool isDialogShowing = false;


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
    routeId = routeId;

    TimeCheckerCustom.checkLastTime(context: context);
    update();
  }

  /// Click on Camera
  Future getImage({required BuildContext context}) async {
    try {
      imagePicker?.getImage(source: "Camera", context: context, type: "orderImage").then((value) async {
        if(imagePicker?.orderImage != null && imagePicker?.orderImage?.path != null){
          imageBase64Data = await Base64ConverterCustom.fileToBase64(filePath: imagePicker?.orderImage?.path ?? "");
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
      signatureData = ByteData(0);
    update();
  }

  /// On Tap Save or Skip Btn
  Future<void> onTapSave({
    required BuildContext context,
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
    required String notPaidReason,

  })async{

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
    // await MyDatabase().deleteEverything();

    // await MyDatabase().getAllOrderCompleteData().then((value) {
    //   print("value111...:$value");
    //
    //   if(value.isNotEmpty){
    //     print("value...:$value");
    //   }
    // });
///

      bool checkInternet = await ConnectionValidator().check();
      final sign = signKey.currentState;
      if (selectedStatusCode == 5 || selectedStatusCode == 6) {
        if (sign != null && sign.points.isNotEmpty || isCdDelivery == false) {
          final image = await sign?.getData();
          var data = await image?.toByteData(format: ui.ImageByteFormat.png);
          sign?.clear();
          final encoded = base64.encode(data!.buffer.asUint8List());
          signatureData = data;

          try {
            if (userId == null || userId!.isEmpty) {
              userId = AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.userId);
            }
            if (userId != null && userId!.isNotEmpty && userId != "0" && userId != "" && userId != "null") {
              await getLocationByClick();

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
                  baseImage: onTapActionType.toLowerCase() == kSkip.toLowerCase() ? "":imageBase64Data != null && imageBase64Data != "" ? imageBase64Data ?? "" : "",
                  deliveredTo: deliveredTo,
                  deliveryId: orderIDs.join(","),
                  routeId: routeId ?? "",
                  customerRemarks: remarks ?? "",
                  baseSignature: onTapActionType.toLowerCase() == kSkip.toLowerCase() ? "" :selectedStatusCode == 6 ? "" : encoded ?? "",
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
                  param9: "$lat",
                  param10: "$lng",
                  date_Time: "${DateTime.now().millisecondsSinceEpoch}",
                  latitude: lat,
                  longitude: lng);

              /// Get Location
              getLocationByClick();
              PrintLog.printLog("USER CURRENT LOCATION IS in OrderComplete Database is   " + lat.toString() + "  " + lng.toString());

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

              if (!checkInternet) {

                /// Go to Dashboard
                GoToDashboard.popUntil(context: context);

              } else {

                  if (outForDelivery.length - 1 != 1) {
                    GoToDashboard.popUntil(context: context);
                  }
                  if (outForDelivery.length - 1 == 1) {
                    PrintLog.printLog(outForDelivery.length - 1);
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
        } else {

          ToastCustom.showToastWithLength(msg: kWriteSign);
          final sign = signKey.currentState;
          sign?.clear();
            signatureData = ByteData(0);
        }
      }

  }


  /// Check Offline Delivery
  Future<void> checkOfflineDeliveryAvailable({required BuildContext context,required outForDelivery}) async {
    var completeAllList = await MyDatabase().getAllOrderCompleteData();
    if (completeAllList.isNotEmpty) {
      isDialogShowing = true;
      showDialog(
          context: Get.overlayContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            dialogDismissTimer(dialogContext: context,outForDelivery: outForDelivery);
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: CustomDialogBox(
                icon: const Icon(Icons.timer),
                title: kAlert,
                descriptions: kUpdatingAndEndingRouteMsg,
              ),
            );
          });
    }
  }

  /// Dialog Dismiss Timer
  Future<void> dialogDismissTimer({required BuildContext dialogContext,required outForDelivery}) async {
    Future.delayed(const Duration(seconds: 2),() async {
      PrintLog.printLog('Dashboard Background Service');
      var completeAllList = await MyDatabase().getAllOrderCompleteData();
      if (completeAllList == null || completeAllList.isEmpty) {
        if (isDialogShowing) {
          Get.back(closeOverlays: true);
        }
        if (outForDelivery.length - 1 == 1) {
          await endRoute(context: dialogContext);
        }
        isDialogShowing = false;
      }
    });

  }

  /// End Route Api
  Future<void> endRoute({required BuildContext context}) async {
    if (isDialogShowing) {
      Get.back(closeOverlays: true);
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
        "routeId":routeId,
      };

      url = WebApiConstant.END_ROUTE_BY_DRIVER;

      apiCtrl.endRoutesAPI(context: context,url: url,dictParameter: dictparm).then((response) async {

        try {
          if (response != null) {
            if (response.data.toString().toLowerCase() == "true") {
              changeLoadingValue(false);
              changeSuccessValue(true);
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
      lat = position.latitude;
      lng = position.longitude;

      PrintLog.printLog("$lat${lng}Calling Location Class::\nLat:$lat\nLng:$lng");
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

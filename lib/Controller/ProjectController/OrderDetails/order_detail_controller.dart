import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/DriverDashboard/driver_dashboard_ctrl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../../Model/OrderDetails/detail_response.dart';
import '../../../Model/ParcelBox/parcel_box_response.dart';
import '../../../View/SignOrImage/sign_image_screen.dart';
import '../../Helper/ConnectionValidator/internet_check_return.dart';
import '../../Helper/TimeChecker/timer_checker.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';


class OrderDetailController extends GetxController {
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  OrderDetailResponse? newOrderDetail;
  DriverDashboardCTRL driverDasCTRL = Get.find();
  List<RelatedOrders> newRelatedOrders = [];
  List<String> orderIDs = [];

  List<String> selectOrderStatus = [];
  String selectedDeliveryStatus = "OutForDelivery";
  int selectedStatusCode = 2;
  int selectedRadioBtn = 0;

  double charge = 0.0;
  double delCharge = 0.0;

  TextEditingController preChargeController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String? selectedDate;
  String? selectedDateTimeStamp;

  TextEditingController remarkController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController otherController = TextEditingController();

  ParcelBoxData? selectedParcelDropdownValue;
  List<String> failedRemarkList = ["Not at home", "No answer", "Can not find address", "Customer denied to take delivery", "Others"];
  int selectedFailedRemarkID = 0;

  List<String> paymentTypeList = ["Cash", "Card", "Not paid"];
  int selectedPaymentType = 0;
  bool paidSelected = false;

  bool isExpanded = false;

  Exemptions? selectedExemptions;

  String totalAmount = "0.00";




  var isCheked = false;
  final DateFormat formatter = DateFormat("dd-MM-yyyy");
  bool isUpdateMobile = false;
  bool isDeliveryNote = false, isCustomerNote = false, isFridgeNote = false, isControlledDrugs = false, isControlNote = false;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// On CLick PopUP
  void onClick({required bool value}) {
  }

  /// On Change Radio Btn Status
  void onChangeRadioBtnStatus({required int value}) {
    selectedRadioBtn = value;
    selectedDeliveryStatus = selectOrderStatus[value];
    getStatusCode();
    update();
  }

  /// init Function
  void init({required BuildContext context,required OrderDetailResponse orderDetailResponse,required bool isMultipleDeliveries}) {
    newRelatedOrders.clear();
    orderIDs.clear();
    selectOrderStatus.clear();

    /// Use for Remove multiple order when not selected multi order
    if(!isMultipleDeliveries && orderDetailResponse.relatedOrders != null && orderDetailResponse.relatedOrders!.isNotEmpty){
      for(int a = orderDetailResponse.relatedOrders!.length;a>1;a--){
        orderDetailResponse.relatedOrders?.removeAt(a-1);
      }
    }
    // if(!isMultipleDeliveries){
    //   for(int a = newRelatedOrders.length;a>1;a--){
    //     newRelatedOrders.removeAt(a-1);
    //   }
    // }

    if(orderDetailResponse.relatedOrders != null && orderDetailResponse.relatedOrders!.isNotEmpty  && orderDetailResponse.deliveryStatusDesc.toString().toLowerCase() != kPickedUp2.toLowerCase()){
      orderDetailResponse.relatedOrders?.forEach((element) {
       int isFindIndex = newRelatedOrders.indexWhere((newElement) => newElement.userId == element.userId);
       if(isFindIndex >= 0){
         if(element.orderId != null && element.orderId.toString().trim() != "" && element.orderId.toString().toLowerCase() != "null".toLowerCase()){

           /// Order ID
           newRelatedOrders[isFindIndex].orderId = "${newRelatedOrders[isFindIndex].orderId ?? ""}${newRelatedOrders[isFindIndex].orderId != null ? ",":""}${element.orderId}";
           orderIDs.add(element.orderId ?? "");
         }

         if(element.deliveryNotes != null && element.deliveryNotes.toString().trim() != "" && element.deliveryNotes.toString().toLowerCase() != "null".toLowerCase()){
           /// Delivery notes
           newRelatedOrders[isFindIndex].deliveryNotes = "${newRelatedOrders[isFindIndex].deliveryNotes ?? ""}${newRelatedOrders[isFindIndex].deliveryNotes != null && newRelatedOrders[isFindIndex].deliveryNotes != "" ? "\n":""}${element.deliveryNotes}";
         }

         if(element.existingDeliveryNotes != null && element.existingDeliveryNotes.toString().trim() != "" && element.existingDeliveryNotes.toString() != "null".toLowerCase()){
           /// Existing Delivery notes
           // newRelatedOrders[isFindIndex].existingDeliveryNotes = "${newRelatedOrders[isFindIndex].existingDeliveryNotes ?? ""}${newRelatedOrders[isFindIndex].existingDeliveryNotes != null ? "\n":""}${element.existingDeliveryNotes}";
         }

         if(element.bagSize != null && element.bagSize.toString().trim() != "" && element.bagSize.toString().toLowerCase() != "null".toLowerCase()){
           /// Bag Size
           orderDetailResponse.bagSize = "${newRelatedOrders[isFindIndex].bagSize ?? ""}${newRelatedOrders[isFindIndex].bagSize != null && newRelatedOrders[isFindIndex].bagSize != "" ? ",":""}${element.bagSize}";
         }

       }else{
         charge = element.rxCharge != null ? double.parse(element.rxCharge.toString() ?? "0.0") : 0.0;
         delCharge = delCharge + (element.delCharge != null ? double.parse(element.delCharge.toString() ?? "0.0") : 0.0);
         newRelatedOrders.add(element);
         orderIDs.add(element.orderId ?? "");
       }

       if(element.rxInvoice != null && element.rxInvoice.toString().isNotEmpty && element.rxInvoice.toString() != "null" && element.rxInvoice.toString() != "0"){
         preChargeController.text = preChargeController.text.toString().trim().isNotEmpty ? (int.parse(preChargeController.text.toString()) + int.parse(element.rxInvoice.toString())).toStringAsFixed(0) : element.rxInvoice.toString();
       }

      });

      if(orderDetailResponse.relatedOrders != null && orderDetailResponse.relatedOrders!.isNotEmpty){
        bool isCdFind = orderDetailResponse.relatedOrders!.any((element) => element.isControlledDrugs == true);
        bool isFridgeFind = orderDetailResponse.relatedOrders!.any((element) => element.isStorageFridge == true);
        bool isDelNoteFind = orderDetailResponse.relatedOrders!.any((element) => element.deliveryNotes != null && element.deliveryNotes != "null" && element.deliveryNotes != "");
        int isExemptIndexFind = orderDetailResponse.relatedOrders!.indexWhere((element) => element.exemption != null && element.exemption != "null" && element.exemption != "" && element.exemption != "0");
        orderDetailResponse.isControlledDrugs = isCdFind;
        orderDetailResponse.isStorageFridge = isFridgeFind;
        orderDetailResponse.deliveryNote = isDelNoteFind ? "true":"false";
        if(isExemptIndexFind>=0){
          orderDetailResponse.exemption = orderDetailResponse.relatedOrders?[isExemptIndexFind].exemption;
          // orderDetailResponse.exemptions.
          int isExemptAssign = orderDetailResponse.exemptions.indexWhere((element) => element.serialId != null && element.serialId?.toLowerCase() == orderDetailResponse.exemption?.toLowerCase());
          if(isExemptAssign >= 0){
            selectedExemptions = orderDetailResponse.exemptions[isExemptAssign];
          }
        }
      }
    }else {
      RelatedOrders data = RelatedOrders();
      data.orderId = orderDetailResponse.orderId;
      data.parcelBoxName = orderDetailResponse.parcelBoxName;
      data.pharmacyName = orderDetailResponse.pharmacyName;
      data.userId = orderDetailResponse.customerId;
      data.pmrType = orderDetailResponse.pmrType;
      data.isCronCreated = orderDetailResponse.isCronCreated;
      data.deliveryStatus = orderDetailResponse.deliveryStatusDesc;
      data.prId = orderDetailResponse.prId;
      data.isControlledDrugs = orderDetailResponse.isControlledDrugs;
      data.isStorageFridge = orderDetailResponse.isStorageFridge;
      data.deliveryNotes = orderDetailResponse.deliveryNote;
      data.fullName = orderDetailResponse.customer?.fullName;
      data.fullAddress = orderDetailResponse.customer?.fullAddress;
      data.altAddress = orderDetailResponse.altAddress;
      data.dob = orderDetailResponse.customer?.dob;
      data.existingDeliveryNotes = orderDetailResponse.exitingNote;
      data.subsId = orderDetailResponse.subsId;
      data.delCharge = orderDetailResponse.delCharge;
      data.rxCharge = orderDetailResponse.rxCharge;
      data.rxInvoice = orderDetailResponse.rxInvoice;
      data.nursingHomeId = orderDetailResponse.nursingHomeId;
      data.toteBoxId = orderDetailResponse.toteBoxId;
      newRelatedOrders.add(data);
      orderIDs.add(orderDetailResponse.orderId ?? "");

    }




    // redirectToDetailsPage(deliveryDetails, deliveryDetails.related_orders[0].orderId, deliveryDetails.related_orders[0].rxInvoice, deliveryDetails.delCharge, deliveryDetails.subsId);
    deliveryChargeController.text = '${delCharge == 0.0 ? orderDetailResponse.delCharge ?? 0 : delCharge}';

    // preChargeController.text = '${orderDetailResponse.rxInvoice != null ? int.parse(orderDetailResponse.rxInvoice.toString()) > 0 ? orderDetailResponse.rxInvoice : 0.0 : 0.0}';
    selectedDate = formatter.format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
    selectedDateTimeStamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).millisecondsSinceEpoch.toString();
    remarkController.text = orderDetailResponse.deliveryRemarks ?? "";
    toController.text = orderDetailResponse.deliveryTo ?? "";

    TimeCheckerCustom.checkLastTime(context: context);
    calculateAmount(orderDetailResponse: orderDetailResponse);

    if (toController.text == "") {
      toController.text = "Patient";
    }

    /// Delivery Status
    selectedDeliveryStatus = orderDetailResponse.deliveryStatusDesc == "Ready" ? "PickedUp" : orderDetailResponse.deliveryStatusDesc ?? "OutForDelivery";
    if(orderDetailResponse.deliveryStatusDesc != null && orderDetailResponse.deliveryStatusDesc != "" && orderDetailResponse.deliveryStatusDesc != "null" && orderDetailResponse.deliveryStatusDesc != null && orderDetailResponse.deliveryStatusDesc?.toLowerCase() == kPickedUpDelivery.toLowerCase()){
      selectedDeliveryStatus = kUnpick;
      selectOrderStatus.add(kUnpick);
      if(orderDetailResponse.nursingHomeId == null || orderDetailResponse.nursingHomeId == "0" || orderDetailResponse.nursingHomeId == ""){
        selectOrderStatus.add(kCancel);
      }
    }else if(selectedDeliveryStatus.toLowerCase() == kOutForDelivery.toLowerCase() || selectedDeliveryStatus.toLowerCase() == kFailed.toLowerCase()){
      selectedDeliveryStatus = kCompleted;
      selectedStatusCode = 5;
      selectOrderStatus.add(kCompleted);
      selectOrderStatus.add(kFailed);
    }else if(selectedDeliveryStatus.toLowerCase() == kPickedUp2.toLowerCase()){
      selectedDeliveryStatus = kPickedUp2;
      selectedStatusCode = 8;
      selectOrderStatus.add(kPickedUp2);
      if(orderDetailResponse.nursingHomeId == null || orderDetailResponse.nursingHomeId == "0" || orderDetailResponse.nursingHomeId == ""){
        selectOrderStatus.add(kCancel);
      }
    }else{
      selectOrderStatus.add(kPickedUp2);
      if(orderDetailResponse.nursingHomeId == null || orderDetailResponse.nursingHomeId == "0" || orderDetailResponse.nursingHomeId == ""){
        selectOrderStatus.add(kCancel);
      }
      selectedDeliveryStatus = selectOrderStatus[0];
    }

    getStatusCode();
    update();
  }

  Future<void> calculateAmount({required OrderDetailResponse orderDetailResponse}) async {
    double deliveryCharge = double.parse(deliveryChargeController.text.toString().trim() ?? "0.0") ?? 0.0;
    double rxInvoice = preChargeController.text.toString().trim().isNotEmpty ?  double.parse(preChargeController.text.toString().trim() ?? "0.0") :0.0;

    double rxCharge = charge == 0.0 ? double.parse(orderDetailResponse.rxCharge != null ? orderDetailResponse.rxCharge.toString() : "0.0"):charge;

    double multiRxCharge = (rxCharge ?? 0) * (rxInvoice ?? 0);

    double totalCharge = multiRxCharge + deliveryCharge;

    totalAmount = totalCharge.toStringAsFixed(2);

    update();
  }

  /// Get Status code
  void getStatusCode() {
    switch (selectedDeliveryStatus) {
      case "ReadyForDelivery":
        selectedStatusCode = 1;
        break;
      case "OutForDelivery":
        selectedStatusCode = 4;
        break;
      case "Completed":
        selectedStatusCode = 5;
        break;
      case "Failed":
        selectedStatusCode = 6;
        break;
      case "Returned":
        selectedStatusCode = 9;
        break;
      case "Cancel":
        selectedStatusCode = 9;
        break;
      case "Ready":
        selectedStatusCode = 3;
        break;
      case "PickedUp":
        selectedStatusCode = 8;
    }

  }

  /// On Tap Open Calender
  void openTapCalender({required BuildContext context}) {
    DateTime date = DateTime.now();
    showDatePicker(
        context: context,
        initialDate: DateTime(date.year, date.month, date.day + 1),
        firstDate: DateTime(date.year, date.month, date.day + 1),
        lastDate: DateTime(2050),
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: AppColors.colorOrange),
              buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        }).then((pickedDate) {

      if (pickedDate == null) {
        return;
      }else{
        selectedDate = formatter.format(pickedDate);
        selectedDateTimeStamp = pickedDate.millisecondsSinceEpoch.toString();
        update();
      }
    });
  }

  /// OnTap Edit Mobile Number
  void onTapEditMobile({required BuildContext context}) {
    isUpdateMobile = !isUpdateMobile;
    update();
  }

 /// OnTap Multi Patient heading
  void onTapMultiPatientHeadingTap({required BuildContext context}) {
    isExpanded = !isExpanded;
    update();
  }

  /// Validate fields
  bool isValidate({required OrderDetailResponse orderDetailResponse }) {

    if (selectedDeliveryStatus.isEmpty) {
      ToastCustom.showToast(msg: kSelectDeliveryStatusToastString);
      return false;
    } else if (selectedDeliveryStatus.toLowerCase() == kFailed.toLowerCase()) {
      if (otherController.text.toString().trim() == "" || otherController.text.toString().trim().isEmpty ) {
        if(failedRemarkList[selectedFailedRemarkID].toLowerCase() == kOthers.toLowerCase()){
          ToastCustom.showToast(msg: kTypeFailedRemarkToastString);
          return false;
        }

      }
    } else if (toController.text.trim().isEmpty) {
      ToastCustom.showToast(msg: kDeliveryIsNotEmptyToastString);
      return false;
    }
    else if (orderDetailResponse.deliveryNote != null && orderDetailResponse.deliveryNote != "f" && orderDetailResponse.deliveryNote != "false" && orderDetailResponse.deliveryNote != "" && !isDeliveryNote) {
      ToastCustom.showToast(msg: kCheckDeliveryNoteToastString);
      return false;
    } else if (orderDetailResponse.exitingNote != null && orderDetailResponse.exitingNote != "f" && orderDetailResponse.exitingNote != "false" && orderDetailResponse.exitingNote != "" && !isDeliveryNote) {
      ToastCustom.showToast(msg: kCheckDeliveryNoteToastString);
      return false;
    } else if (!isFridgeNote && (orderDetailResponse.isStorageFridge != false)) {
      ToastCustom.showToast(msg: kCheckFridgeToastString);
      return false;
    } else if (!isControlledDrugs && (orderDetailResponse.isControlledDrugs != false)) {
      ToastCustom.showToast(msg: kCheckControlledDrugsToastString);
      return false;
    } else if (!isCustomerNote && (orderDetailResponse.customer?.customerNote != null && orderDetailResponse.customer?.customerNote != "")) {
      ToastCustom.showToast(msg: kCheckCustomerNoteToastString);
      return false;
    }
    return true;
  }

  /// OnTap Update Status
  Future<void> onTapUpdateStatus({required BuildContext context,required OrderDetailResponse orderDetailResponse}) async {
    bool checkInternet = await ConnectionValidator().check();
    PrintLog.printLog("Selected Delivery Status: $selectedDeliveryStatus");
    PrintLog.printLog("Navigation \nData Collected: $orderDetailResponse");


    if (selectedDeliveryStatus.toLowerCase() == kPickedUp2.toLowerCase() || selectedDeliveryStatus.toLowerCase() == kCancel.toLowerCase()) {
      if (isValidate(orderDetailResponse: orderDetailResponse)) {
        if (!checkInternet) {
          ToastCustom.showToast(msg: "Internet Not Connected");
        } else {
          updateDeliveryStatus(context: context,orderDetailResponse: orderDetailResponse);
        }
      }
    } else if (isValidate(orderDetailResponse: orderDetailResponse)) {
      if (selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase() || selectedDeliveryStatus.toLowerCase() == kFailed.toLowerCase()) {

        PrintLog.printLog("Selected Date:$selectedDate");
        /// Navigate Img screen

        try{
          Get.toNamed(
              signOrImageScreenRoute,
              arguments: SignOrImageScreen(
                delivery: orderDetailResponse,
                selectedStatusCode: selectedStatusCode ?? 0,
                remarks: remarkController.text.toString().trim() ?? "",
                deliveredTo:  toController.text.toString().trim() ?? "",
                orderIDs: orderIDs ?? [],
                outForDelivery: driverDasCTRL.driverDashboardData?.deliveryList ?? [],
                routeId: orderDetailResponse.routeId ?? "0",
                rescheduleDate: isCheked && selectedDateTimeStamp != null && selectedDateTimeStamp != "" ? selectedDateTimeStamp  ?? "": "",
                failedRemark: selectedDeliveryStatus.toLowerCase() == kFailed.toLowerCase()
                    ? failedRemarkList[selectedFailedRemarkID].toLowerCase() == kOthers.toLowerCase()
                    ? otherController.text.toString().trim()
                    : failedRemarkList[selectedFailedRemarkID]
                    : "",
                paymentStatus: paidSelected ? "paid" : "unPaid",
                exemptionId: selectedExemptions != null ? int.parse(selectedExemptions?.id.toString() ?? "0") : 0,
                mobileNo: selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase() ? mobileController.text.toString().trim().isNotEmpty ? mobileController.text.toString().trim() : "" : "",
                addDelCharge: delCharge.toString() ?? "",
                subsId: orderDetailResponse.subsId != null ? int.parse(orderDetailResponse.subsId.toString() ?? "0") : 0,
                paymentType: selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase() && ((preChargeController.text.toString().trim().isNotEmpty && preChargeController.text != '0' && preChargeController.text != '0.0') || (deliveryChargeController.text.toString().trim().isNotEmpty && deliveryChargeController.text != '0' && deliveryChargeController.text != '0.0')) ? paymentTypeList[selectedPaymentType] : "",
                rxInvoice: preChargeController.text.toString().trim() ?? "",
                rxCharge: orderDetailResponse.rxCharge ?? "0",
                amount: totalAmount ?? "",
                isCdDelivery: isControlledDrugs ?? false,
                notPaidReason: selectedDeliveryStatus.toLowerCase() == kCompleted.toLowerCase()
                    ? paymentTypeList[selectedPaymentType] == "Not paid"
                    ? commentController.text.toString().trim()
                    : ""
                    : "",
              )
          );
        }catch(e){
          PrintLog.printLog("Update Status Through Error: $e");
        }


      } else {
        updateDeliveryStatus(context: context,orderDetailResponse: orderDetailResponse);
      }
    }
    update();
  }

  ///Order Details Api
  Future<void> updateDeliveryStatus({
    required BuildContext context,
    required OrderDetailResponse orderDetailResponse
  }) async {
    await InternetCheck.check();

    // List<String> orderIds = [];
    // newRelatedOrders.forEach((element) {
    //   orderIds.add(element.orderId ?? "");
    // });

    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "deliveryId": orderIDs,
      "exemption": selectedExemptions?.id ?? "0",
      "paymentStatus": paidSelected ? "paid" : "unPaid",
      "remarks": remarkController.text.toString().trim(),
      "deliveredTo": toController.text.toString().trim(),
      "parcel_box_id": selectedParcelDropdownValue != null && selectedParcelDropdownValue?.id != null ? selectedParcelDropdownValue?.id : 0,
      "deliveryStatus": selectedStatusCode,
      "routeId": AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.routeID),
      "pickupTypeId": orderDetailResponse.pickupTypeId,
    };

    String url = WebApiConstant.UPDATE_DELIVERY_STATUS_URL;

    await apiCtrl.updateDeliveryStatusApi(context:context,url: url, formData: dictparm)
        .then((result) async {
      if(result != null){
        try {
          if(result.data != null && result.data["status"].toString().toLowerCase() == "true"){
            Navigator.of(context).pop("ProductDetailPagePop");
            print("tes.....Details success");
            driverDasCTRL.driverDashboardApi(context: context).then((value){

            });

            changeLoadingValue(false);
            changeSuccessValue(true);

          }else{
            changeLoadingValue(false);
            changeSuccessValue(false);
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
      }
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

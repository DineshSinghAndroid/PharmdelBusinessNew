import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pharmdel/Controller/Helper/PrintLog/PrintLog.dart';
import '../../../Model/DriverDashboard/driver_dashboard_response.dart';
import '../../../Model/OrderDetails/detail_response.dart' as D;
import '../../../main.dart';
import '../../ApiController/ApiController.dart';
import '../../ApiController/WebConstant.dart';
import '../../DB_Controller/MyDatabase.dart';
import '../../Helper/ConnectionValidator/ConnectionValidator.dart';
import '../../WidgetController/StringDefine/StringDefine.dart';
import '../../Helper/SentryExemption/sentry_exemption.dart';
import '../DriverDashboard/driver_dashboard_ctrl.dart';


class LocalDBController extends GetxController {
  ApiController apiCtrl = ApiController();

  bool isLoading = false;
  bool isError = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  ExemptionsDataCompanion? exemptionsDataCompanion;
  DeliveryListCompanion? deliveryListObj;
  CustomerDetailsCompanion? customerDetailsObj;
  CustomerAddressesCompanion? customerAddressObj;

  List<DeliveryPojoModal> getDBDeliveryList = [];
  List<Exemptions> getExemptions = [];

  bool isAvlInternet = false;



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

  Future<List<Exemptions>> getExemptionList()async {
    getExemptions.clear();
      await MyDatabase().getExemptionsList().then((value) async {
        if (value != null && value.isNotEmpty) {
          await Future.forEach(value, (element) {
            Exemptions exemptions = Exemptions();
            exemptions.id = element.exemptionId.toString();
            exemptions.serialId = element.serialId;
            exemptions.code = element.name;

            getExemptions.add(exemptions);
          });
          PrintLog.printLog("Exemption Length: ${getExemptions.length}");
        }
      });

      return getExemptions;
  }

  Future<bool?> isFoundOrderInCompleted({required String orderID})async{
    bool? isAvl;
    var completeAllList = await MyDatabase().getAllOrderCompleteData();
    if (completeAllList != null && completeAllList.isNotEmpty) {
      completeAllList.forEach((element2) {

        var orderId = element2.deliveryId.split(",");
        PrintLog.printLog("Found Completed Order Id DB: $orderId");
        if (orderId != null && orderId.isNotEmpty) {
          isAvl = orderId.any((element3) => element3.toString() == orderID.toString());
        }
      });
    }
    return isAvl;
  }

  /// Save OutForDelivery List
  Future<void> saveOutForDeliverList({required List<DeliveryPojoModal> deliveryList})async {


    try{
      await clearDeliveryTable();
      bool isFoundDataInCompleted = false;
      // var completeAllList = await MyDatabase().getAllOrderCompleteData();
      await Future.forEach(deliveryList, (DeliveryPojoModal element) async {
        isFoundDataInCompleted = await isFoundOrderInCompleted(orderID: element.orderId.toString()) ?? false;
        // if (completeAllList != null && completeAllList.isNotEmpty) {
        //   completeAllList.forEach((element2) {
        //     var orderId = element2.deliveryId.split(",");
        //     if (orderId != null && orderId.isNotEmpty) {
        //       isFoundDataInCompleted = orderId.any((element3) => element3.toString() == element.orderId.toString());
        //     }
        //   });
        // }

        var delivery = await MyDatabase().getDeliveryDetails(int.parse(element.orderId.toString() ?? "0"));
        PrintLog.printLog("Delivery Data:$delivery");
        PrintLog.printLog("Delivery charge:${element.delCharge}");
        if (delivery == null && isFoundDataInCompleted == false) {


          PrintLog.printLog("Data added start in Local DB::::::::");
          deliveryListObj = DeliveryListCompanion.insert(
            param1: "",
            param2: "",
            param3: "",
            param4: "",
            param5: "",
            param6: "",
            totalStorageFridge: element.totalStorageFridge != null ? int.parse(element.totalStorageFridge.toString() ?? "") : 0,
            totalControlledDrugs: element.totalControlledDrugs != null ? int.parse(element.totalControlledDrugs.toString() ?? "") : 0,
            nursing_home_id: element.nursing_home_id != null ? int.parse(element.nursing_home_id.toString() ?? "") : 0,
            subsId: element.subsId != null ? int.parse(element.subsId.toString() ?? "") : 0,
            rxCharge: element.rxCharge != null ? element.rxCharge ?? "0" : '0',
            rxInvoice: element.rxInvoice != null ? int.parse(element.rxInvoice.toString() ?? "") : 0,
            delCharge: element.delCharge != null ? element.delCharge ?? "0": '0',
            paymentStatus: element.paymentStatus != null && element.paymentStatus!.isNotEmpty ? element.paymentStatus ?? "": "",
            pharmacyId: element.pharmacyId != null ? int.parse(element.pharmacyId.toString() ?? "") : 0,
            isDelCharge: element.isDelCharge != null ? int.parse(element.isDelCharge.toString() ?? "") : 0,
            isSubsCharge: element.isPresCharge != null ? int.parse(element.isPresCharge.toString() ?? "") : 0,
            bagSize: element.bagSize != null && element.bagSize!.isNotEmpty ? element.bagSize  ?? "": "",
            exemption: element.exemption != null && element.exemption!.isNotEmpty ? element.exemption ?? "": "",
            sortBy: element.sortBy != null ? element.sortBy  ?? "": "",
            parcelBoxName: "",
            userId: userID != "" ? userID : "",
            orderId: element.orderId != null ? int.parse(element.orderId.toString() ?? "0") : 0,
            routeId: element.routeId != null && element.routeId != "" ? element.routeId.toString() : "",
            serviceName: element.serviceName != null && element.serviceName != "" ? element.serviceName ?? "": "",
            deliveryNotes: element.deliveryNotes != null && element.deliveryNotes != "" ? element.deliveryNotes ?? "": "",
            existingDeliveryNotes: element.existingDeliveryNotes != null && element.existingDeliveryNotes != "" ? element.existingDeliveryNotes ?? "": "",
            isControlledDrugs: element.isControlledDrugs != null && element.isControlledDrugs != "" ? element.isControlledDrugs ?? "": "",
            isStorageFridge: element.isStorageFridge != null && element.isStorageFridge != "" ? element.isStorageFridge ?? "": "",
            isCronCreated: element.isCronCreated != null && element.isCronCreated != "null" && element.isCronCreated != "" ? element.isCronCreated ?? "": "",
            deliveryStatus: element.status != null && element.status?.toLowerCase() == kOutForDelivery.toLowerCase() ? 4 : 0,
            pharmacyName: element.pharmacyName != null && element.pharmacyName != "null" && element.pharmacyName != "" ? element.pharmacyName ?? "": "",
            status: element.status != null && element.status != "null" && element.status != "" ? element.status ?? "": "",
            pmr_type: element.pmr_type != null && element.pmr_type != "null" && element.pmr_type != "" ? element.pmr_type ?? "": "",
            pr_id: element.pr_id != null && element.pr_id != "null" && element.pr_id != "" ? element.pr_id ?? "": "",
          );

          // PrintLog.printLog("Add Delivery list Parm: $deliveryListObj");
          await MyDatabase().insertDeliveries(deliveryListObj!);

          customerDetailsObj = CustomerDetailsCompanion.insert(
              param4: "",
              param3: "",
              param2: "",
              param1: "",
              mobile: "",
              customerId: element.customerDetials?.customerId != null ? int.parse(element.customerDetials?.customerId.toString() ?? "") : 0,
              surgeryName: element.parcelBoxName != null && element.parcelBoxName != "" ? element.parcelBoxName ?? "": "",
              service_name: element.customerDetials?.service_name != null && element.customerDetials?.service_name != "" ? element.customerDetials?.service_name ?? "": "",
              firstName: element.customerDetials?.firstName != null && element.customerDetials?.firstName != "" ? element.customerDetials?.firstName ?? "": "",
              middleName: element.customerDetials?.middleName != null && element.customerDetials?.middleName != "" ? element.customerDetials?.middleName ?? "": "",
              lastName: element.customerDetials?.lastName != null && element.customerDetials?.lastName != "" ? element.customerDetials?.lastName ?? "": "",
              title: element.customerDetials?.title != null && element.customerDetials?.title != "" ? element.customerDetials?.title ?? "": "",
              address: element.customerDetials?.address != null && element.customerDetials?.address != "" ? element.customerDetials?.address ?? "": "",
              order_id: element.orderId != null ? int.parse(element.orderId.toString() ?? "") : 0
          );
          PrintLog.printLog("Add Delivery Customer Details Parm: $customerDetailsObj");
          await MyDatabase().insertCustomerDetails(customerDetailsObj!);

          customerAddressObj = CustomerAddressesCompanion.insert(
              matchAddress: "",
              param1: "",
              param2: "",
              param3: "",
              param4: "",
              address1: element.customerDetials?.customerAddress?.address1 != null && element.customerDetials?.customerAddress?.address1 != ""
                  ? element.customerDetials?.customerAddress?.address1 ?? ""
                  : "",
              alt_address: element.customerDetials?.customerAddress?.alt_address != null && element.customerDetials?.customerAddress?.alt_address != ""
                  ? element.customerDetials?.customerAddress?.alt_address ?? ""
                  : "",
              address2: element.customerDetials?.customerAddress?.address2 != null && element.customerDetials?.customerAddress?.address2 != ""
                  ? element.customerDetials?.customerAddress?.address2 ?? ""
                  : "",
              postCode: "${element.customerDetials?.customerAddress?.postCode != null && element.customerDetials?.customerAddress?.postCode != "" ? element.customerDetials?.customerAddress?.postCode : ""}${element.customerDetials?.mobile != null && element.customerDetials?.mobile != "" ? "#${element.customerDetials?.mobile ?? ""}": ""}",
              latitude: element.customerDetials?.customerAddress?.latitude != null && element.customerDetials?.customerAddress?.latitude != ""
                  ? double.parse(element.customerDetials?.customerAddress?.latitude.toString() ?? "")
                  : 0.0,
              longitude: element.customerDetials?.customerAddress?.longitude != null && element.customerDetials?.customerAddress?.longitude != ""
                  ? double.parse(element.customerDetials?.customerAddress?.longitude.toString() ?? "")
                  : 0.0,
              duration: element.customerDetials?.customerAddress?.matchAddress != null && element.customerDetials?.customerAddress?.matchAddress != ""
                  ? element.customerDetials?.customerAddress?.matchAddress ?? ""
                  : "",
              order_id: element.orderId != null ? int.parse(element.orderId.toString() ?? "") : 0);
          // PrintLog.printLog("Add Delivery Customer Address Parm: $customerAddressObj");
          await MyDatabase().insertCustomerAddress(customerAddressObj!);

        }
      });
    }catch(e){
      PrintLog.printLog("DB Error...:::::$e");
    }

  }

  /// Get OutForDelivery List
  Future<List<DeliveryPojoModal>> getOutForDeliverList()async {
    getDBDeliveryList.clear();

    await MyDatabase().getAllOutForDeliveriesOnly().then((value) async {
      if (value != null && value.isNotEmpty) {
        if (userID != value[0].userId) {
          await clearDeliveryTable();
        } else {
          await Future.forEach(value, (element) async {


            DeliveryPojoModal delivery = DeliveryPojoModal();
            PrintLog.printLog(element.orderId);
            delivery.orderId = element.orderId.toString();
            delivery.rxCharge = element.rxCharge;
            delivery.totalStorageFridge = element.totalStorageFridge.toString();
            delivery.totalControlledDrugs = element.totalControlledDrugs.toString();
            delivery.nursing_home_id = element.nursing_home_id.toString() ?? "";
            delivery.rxInvoice = element.rxInvoice.toString();
            delivery.subsId = element.subsId.toString();
            delivery.delCharge = element.delCharge;
            delivery.isPresCharge = element.isSubsCharge.toString();
            delivery.isDelCharge = element.isDelCharge.toString();
            delivery.orderId = element.orderId.toString();
            delivery.sortBy = element.sortBy;
            delivery.pharmacyId = element.pharmacyId.toString();
            delivery.bagSize = element.bagSize;
            delivery.paymentStatus = element.paymentStatus;
            delivery.exemption = element.exemption;
            delivery.routeId = element.routeId.toString();
            delivery.serviceName = element.serviceName;
            delivery.isStorageFridge = element.isStorageFridge;
            delivery.isControlledDrugs = element.isControlledDrugs;
            delivery.deliveryNotes = element.deliveryNotes;
            delivery.existingDeliveryNotes = element.existingDeliveryNotes;
            delivery.isCronCreated = element.isCronCreated;
            delivery.deliveryStatus = int.tryParse(element.deliveryStatus.toString());
            delivery.pharmacyName = element.pharmacyName;
            delivery.status = element.status;
            delivery.pmr_type = element.pmr_type;
            delivery.pr_id = element.pr_id;
            if (delivery.isControlledDrugs != null && delivery.isControlledDrugs == "t") {
              delivery.isCD = true;
            } else {
              delivery.isCD = false;
            }
            if (delivery.isStorageFridge != null && delivery.isStorageFridge == "t") {
              delivery.isFridge = true;
            } else {
              delivery.isFridge = false;
            }

            CustomerDetails customerDetails = CustomerDetails();

            var element1 = await MyDatabase().getCustomerDetails(element.orderId);
            if (element1 != null) {
              delivery.customerDetials = customerDetails;
              delivery.customerDetials?.firstName = element1.firstName;
              delivery.customerDetials?.service_name = element1.service_name;
              delivery.parcelBoxName = element1.surgeryName;
              delivery.customerDetials?.address = element1.address;
              delivery.customerDetials?.title = element1.title;
              delivery.customerDetials?.lastName = element1.lastName;
              delivery.customerDetials?.middleName = element1.middleName;
              delivery.customerDetials?.customerId = element1.customerId.toString();
            }
            CustomerAddress customerAddress = CustomerAddress();
            var value = await MyDatabase().getCustomerAddress(element.orderId);
            if (value != null) {
              delivery.customerDetials?.customerAddress = customerAddress;
              delivery.customerDetials?.customerAddress?.duration = value.duration;
              delivery.customerDetials?.customerAddress?.longitude = value.longitude.toString();
              delivery.customerDetials?.customerAddress?.latitude = value.latitude.toString();
              delivery.customerDetials?.customerAddress?.postCode = value.postCode;
              delivery.customerDetials?.customerAddress?.address2 = value.address2;
              delivery.customerDetials?.customerAddress?.address1 = value.address1;
              delivery.customerDetials?.customerAddress?.alt_address = value.alt_address;
            }
            getDBDeliveryList.add(delivery);
            update();
          });

          PrintLog.printLog("DB Delivery List Total Length= ${getDBDeliveryList.length}");
        }
      }

    });
    return getDBDeliveryList;
  }

  /// Clear Delivery Table
  Future<int> clearDeliveryTable() async {
    await MyDatabase().deleteDeliveryList();
    await MyDatabase().deleteCustomerList();
    await MyDatabase().deleteAddressList();
    return Future.value(1);
  }


  /// Get Order Detail
  Future<D.OrderDetailResponse?> getOrderDetailsDB({required DeliveryPojoModal delivery, required bool isScan, required bool isComplete}) async {
    D.OrderDetailResponse getOrderDetailResponse = D.OrderDetailResponse();
    getOrderDetailResponse.relatedOrders?.clear();

    try{
      await getExemptionList();
      PrintLog.printLog("DB Check Related Order ID: ${delivery.orderId}");
      await MyDatabase().getDeliveryMatchedList(delivery.customerDetials?.customerAddress?.duration ?? "").then((value) async {
        if (value != null && value.isNotEmpty) {
          PrintLog.printLog(value);
          List<D.RelatedOrders> foundRelatedOrders = [];
          /// RELATED ORDER ADDED
          await Future.forEach(value, (element) async {
            var deliveryDetails = await MyDatabase().getDeliveryDetails(int.tryParse(element.order_id.toString() ?? "0") ?? 0);
            PrintLog.printLog(deliveryDetails);
            if (deliveryDetails?.deliveryStatus == 4) {
              D.RelatedOrders relatedOrders = D.RelatedOrders();
              PrintLog.printLog(element);

              var customerDetails = await MyDatabase().getCustomerDetails(int.tryParse(element.order_id.toString()) ?? 0);
              var customerAddress = await MyDatabase().getCustomerAddress(int.tryParse(element.order_id.toString()) ?? 0);
              relatedOrders.orderId = deliveryDetails?.orderId.toString();
              relatedOrders.parcelBoxName = customerDetails?.surgeryName;
              relatedOrders.subsId = deliveryDetails?.subsId.toString();
              relatedOrders.rxCharge = deliveryDetails?.rxCharge;
              relatedOrders.rxInvoice = deliveryDetails?.rxInvoice.toString();
              relatedOrders.delCharge = deliveryDetails?.delCharge;
              relatedOrders.bagSize = deliveryDetails?.bagSize;
              relatedOrders.isDelCharge = deliveryDetails?.isDelCharge.toString();
              relatedOrders.isPresCharge = deliveryDetails?.isSubsCharge.toString();
              relatedOrders.exemption = deliveryDetails?.exemption;
              relatedOrders.prId = deliveryDetails?.pharmacyId.toString();
              relatedOrders.paymentStatus = deliveryDetails?.paymentStatus;
              relatedOrders.pharmacyName = deliveryDetails?.pharmacyName;
              relatedOrders.totalControlledDrugs = deliveryDetails?.totalControlledDrugs.toString();
              relatedOrders.totalStorageFridge = deliveryDetails?.totalStorageFridge.toString();
              relatedOrders.nursingHomeId = deliveryDetails?.nursing_home_id.toString();
              relatedOrders.userId = customerDetails?.customerId.toString();
              relatedOrders.mobileNo = customerDetails?.mobile;
              relatedOrders.fullName = (customerDetails?.title != null ? customerDetails!.title + " " : "") +
                  (customerDetails?.firstName != null ? "${customerDetails?.firstName} " : "") +
                  (customerDetails?.middleName != null ? customerDetails?.middleName ?? "": "") +
                  (customerDetails?.lastName != null ? " ${customerDetails?.lastName}" : "");
              relatedOrders.fullAddress = customerDetails?.address;
              relatedOrders.isStorageFridge = deliveryDetails?.isStorageFridge == "t" ? true : false; // need to add
              relatedOrders.deliveryNotes = deliveryDetails?.deliveryNotes; // need to add
              relatedOrders.isSelected = false;
              relatedOrders.isCronCreated = deliveryDetails?.isCronCreated;
              relatedOrders.altAddress = customerAddress?.alt_address;
              relatedOrders.existingDeliveryNotes = deliveryDetails?.existingDeliveryNotes; // need to add
              relatedOrders.isControlledDrugs = deliveryDetails?.isControlledDrugs == "t" ? true : false; // need to add
              relatedOrders.pmrType = deliveryDetails?.pmr_type;
              relatedOrders.prId = deliveryDetails?.pr_id;
              // getOrderDetailResponse.relatedOrders?.add(relatedOrders);
              foundRelatedOrders.add(relatedOrders);
            }
          });

          /// Related Order List Added
          getOrderDetailResponse.relatedOrders = foundRelatedOrders;
          PrintLog.printLog("Related Order List length:::::::::::: ${foundRelatedOrders.length}");


          /// Exemptions List Added
          getOrderDetailResponse.exemptions = getExemptions;
          PrintLog.printLog("Exemptions List length:::::::::::: ${getExemptions.length}");


          getOrderDetailResponse.orderId = delivery.orderId;
          getOrderDetailResponse.pharmacyId = delivery.pharmacyId;
          getOrderDetailResponse.delCharge = delivery.isDelCharge;
          getOrderDetailResponse.rxCharge = delivery.rxCharge;
          getOrderDetailResponse.rxInvoice = delivery.rxInvoice;
          getOrderDetailResponse.delCharge = delivery.delCharge;
          getOrderDetailResponse.subsId = delivery.subsId;
          getOrderDetailResponse.totalControlledDrugs = delivery.totalControlledDrugs;
          getOrderDetailResponse.totalStorageFridge = delivery.totalStorageFridge;
          getOrderDetailResponse.nursingHomeId = delivery.nursing_home_id;
          getOrderDetailResponse.isPresCharge = delivery.isPresCharge;
          getOrderDetailResponse.relatedOrderCount = "${getOrderDetailResponse.relatedOrders?.length ?? 0}";
          getOrderDetailResponse.deliveryRemarks = ""; // no need to add
          getOrderDetailResponse.deliveryTo = ""; // no need to add
          getOrderDetailResponse.deliveryStatusDesc = delivery.status;
          getOrderDetailResponse.parcelName = delivery.parcelBoxName;
          getOrderDetailResponse.exemption = delivery.exemption;
          getOrderDetailResponse.paymentStatus = delivery.paymentStatus;
          getOrderDetailResponse.bagSize = delivery.bagSize;
          getOrderDetailResponse.routeId = delivery.routeId;
          getOrderDetailResponse.prId = delivery.pr_id;
          getOrderDetailResponse.customerId = delivery.customerDetials?.customerId;
          getOrderDetailResponse.isControlledDrugs = delivery.isControlledDrugs == "t" ? true : false;
          getOrderDetailResponse.isStorageFridge = delivery.isStorageFridge == "t" ? true : false;
          getOrderDetailResponse.deliveryNote = delivery.deliveryNotes;
          getOrderDetailResponse.exitingNote = delivery.existingDeliveryNotes;
          getOrderDetailResponse.customer = D.Customer();
          getOrderDetailResponse.customer?.altAddress = delivery.customerDetials?.customerAddress?.alt_address;

          /// Doubt Method
          getOrderDetailResponse.customer?.mobile = delivery.customerDetials?.customerAddress?.postCode?.contains("#") != null && int.parse(delivery.customerDetials?.customerAddress?.postCode?.split("#").length.toString() ?? "0") > 1
              ? delivery.customerDetials?.customerAddress?.postCode?.split("#")[1]
              : "";

          getOrderDetailResponse.customer?.fullAddress = delivery.customerDetials?.address;
          getOrderDetailResponse.customer?.fullName = (delivery.customerDetials?.title != null ? delivery.customerDetials!.title! + " " : "") +
              (delivery.customerDetials?.firstName != null ? delivery.customerDetials!.firstName! + " " : "") +
              (delivery.customerDetials?.middleName != null ? delivery.customerDetials?.middleName ?? "": "") +
              (delivery.customerDetials?.lastName != null ? " " + delivery.customerDetials!.lastName!: "");

          PrintLog.printLog('ManuelDetailPage ${getOrderDetailResponse.delCharge}');
          return getOrderDetailResponse;
        }
      });

    }catch(e){
      PrintLog.printLog("Database controller error....:$e");
    }

    return getOrderDetailResponse;
  }

  /// Check Completed Data
  Future<void> checkPendingCompleteDataInDB({required BuildContext context})async{
    // await MyDatabase().deleteEverything();
    await MyDatabase().getAllOrderCompleteData().then((value) async {
      if(value.isNotEmpty){
        PrintLog.printLog("Found Completed Data in DB::::::::");
        isAvlInternet = await ConnectionValidator().check();



        if(isAvlInternet) {
          await Future.forEach(value, (element) async {
          await completeDataUpload(
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
        }
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
      "latitude": "",//latitude,
      "longitude": "",//longitude
    };

    String url = WebApiConstant.DELIVERY_SIGNATURE_UPLOAD_URL;

     await apiCtrl.completeDataUploadAPI(context: context,url: url,dictParameter: prams).then((response) async {

        try {
          if (response != null) {
            if (response.data["status"].toString().toLowerCase() == "true") {
              changeLoadingValue(false);
              changeSuccessValue(true);
              await MyDatabase().deleteCompletedDeliveryByOrderId(deliveryId.join(","));
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
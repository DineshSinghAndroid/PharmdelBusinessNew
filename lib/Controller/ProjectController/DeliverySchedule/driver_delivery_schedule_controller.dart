import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pharmdel/Controller/ProjectController/MainController/import_controller.dart';
import 'package:pharmdel/Controller/WidgetController/StringDefine/StringDefine.dart';
import '../../../Model/CreateOrder/driver_create_order_response.dart';
import '../../../Model/DriverRoutes/get_route_list_response.dart';
import '../../../Model/GetDeliveryMasterData/get_delivery_master_data.dart';
import '../../../Model/ParcelBox/parcel_box_response.dart';
import '../../../Model/PharmacyModels/P_GetDriverListModel/P_GetDriverListModel.dart';
import '../../../Model/ProcessScan/driver_process_scan.dart';
import '../../../Model/SearchMedicine/search_medicine_response.dart';
import '../../Helper/Calender/calender.dart';
import '../../WidgetController/Popup/CustomDialogBox.dart';
import '../../WidgetController/Popup/popup.dart';
import '../DriverDashboard/driver_dashboard_ctrl.dart';



class DriverDeliveryScheduleController extends GetxController{

  ApiController apiCtrl = ApiController();
  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;
  bool isNetworkError = false;
  bool isSuccess = false;

  double spaceBetweenCustomerDetail = 1.0;
  double borderRadius = 10.0;

  bool isFridgeSelected = false;
  bool isCdSelected = false;
  // bool isPaidSelected = false;

  List<TitleIDorSelectedValue> paidList = [
    TitleIDorSelectedValue(id:0,title: "1",isSelected: false),
    TitleIDorSelectedValue(id:1,title: "2",isSelected: false),
    TitleIDorSelectedValue(id:2,title: "3",isSelected: false),
    TitleIDorSelectedValue(id:3,title: "4",isSelected: false),
    TitleIDorSelectedValue(id:4,title: "5",isSelected: false),
    TitleIDorSelectedValue(id:5,title: "6",isSelected: false),
  ];
  TitleIDorSelectedValue? selectedPaidData;

  DeliveryMasterDataExemptions? selectedExemption;

  DriverProcessScanOrderInfo? ctrlOrderInfo;

  /// Use For Rx image
  ImagePickerController? imagePicker = Get.put(ImagePickerController());
  List<XFile> rxImagesList = [];

  /// Get Deliver Master data api call in DasCtrl
  DriverDashboardCTRL drDashCtrl = Get.find();

  DeliveryMasterDataShelf? selectedServices;
  List<TitleIDorSelectedValue> bagSizeList = [
    TitleIDorSelectedValue(title: "S",id: 0,isSelected: false),TitleIDorSelectedValue(title: "M",id: 1,isSelected: false),TitleIDorSelectedValue(title: "L",id: 2,isSelected: false),TitleIDorSelectedValue(title: "C",id: 3,isSelected: false),
  ];

  DateTime? selectedDate = DateTime.now();
  String? subscriptionExpiryDate;
  RouteList? selectedRoutePosition;
  DriverModel? selectedDriverPosition;
  String? selectedDefaultDeliveryType;

  /// Parcel box list
  List<ParcelBoxData>? parcelBoxList;
  ParcelBoxData? selectedParcelBox;

  List<String> statusType = ['Received','Requested','Ready','PickedUp',];
  String? selectedStatusType;

  DeliveryMasterDataNursingHomes? selectedNursingHome;
  DeliveryMasterDataPatientSubscriptions? selectedSubscriptions;
  DeliveryMasterDataSurgery? selectedSurgery;

  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController existingNoteController = TextEditingController();
  TextEditingController deliveryNoteController = TextEditingController();

  String? startRouteId;
  String? endRouteId;
  double? startLat;
  double? startLng;

  @override
  void onInit() async {
    selectedRoutePosition = drDashCtrl.selectedRoute;
    parcelBoxList = drDashCtrl.parcelBoxList;
    startRouteId =  AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.startRouteId);
    endRouteId =  AppSharedPreferences.getStringFromSharedPref(variableName: AppSharedPreferences.endRouteId);
    Future.delayed(const Duration(seconds: 2),(){
      startLat = double.parse(CheckPermission.getLatitude(Get.overlayContext!).toString() ?? "0.0") ?? 0.0;
      startLng = double.parse(CheckPermission.getLongitude(Get.overlayContext!).toString() ?? "0.0") ?? 0.0;
    });

    super.onInit();
  }


  /// Rx Details list
  List<SearchMedicineListData> rxDetailList = [];

  /// Pop Up
  void subExpiryPopUp(String msg) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            img: Image.asset(strImgSad),
            title: kAlert,
            btnDone: kOkay,
            btnNo: "",
            descriptions: msg,
          );
        });
  }

  getLocationData() async {
    startLat = double.parse(await CheckPermission.getLatitude(Get.overlayContext!) ?? "");
    startLng = double.parse(await CheckPermission.getLongitude(Get.overlayContext!) ?? "");
  }

  /// Initial call method
  Future<void> assignOrderInfoData({required DriverProcessScanOrderInfo orderInfo})async{
    ctrlOrderInfo = orderInfo;
    getLocationData();

    if (ctrlOrderInfo != null && ctrlOrderInfo?.subsExpiryDate != null) {
      subscriptionExpiryDate = ctrlOrderInfo?.subsExpiryDate;
      PrintLog.printLog('Expiry Subscription Date: $subscriptionExpiryDate');
      selectedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(subscriptionExpiryDate.toString()) * 1000);
      PrintLog.printLog('Converted Date Date: $selectedDate');
    }


    /// Delivery Subscription ID
      if (ctrlOrderInfo != null && ctrlOrderInfo?.delSubsId != null) {
        if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.patientSubscriptions != null) {
          int indexSub = drDashCtrl.deliveryMasterData!.patientSubscriptions!.indexWhere((element) => element.id == ctrlOrderInfo?.delSubsId);
          if(indexSub >= 0){
            selectedSubscriptions = drDashCtrl.deliveryMasterData?.patientSubscriptions?[indexSub];
            deliveryChargeController.text = ctrlOrderInfo?.delCharge ?? drDashCtrl.deliveryMasterData?.patientSubscriptions?[indexSub].price ?? "";
          }
        }
        PrintLog.printLog('selectedSubscription : ${ctrlOrderInfo?.delSubsId}');
      }

    /// Surgery Name
      if (ctrlOrderInfo != null && ctrlOrderInfo?.surgeryName != null && ctrlOrderInfo?.surgeryName != "") {
        if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.surgery != null) {
          int indexSurg = drDashCtrl.deliveryMasterData!.surgery!.indexWhere((element) => element.name == ctrlOrderInfo?.surgeryName);
          if(indexSurg >= 0){
            selectedSurgery = drDashCtrl.deliveryMasterData?.surgery?[indexSurg];
          }
        }
      }


    /// Payment Exemption
      if (ctrlOrderInfo != null && ctrlOrderInfo?.paymentExemption != null && ctrlOrderInfo?.paymentExemption != null) {
        if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.exemptions != null && drDashCtrl.deliveryMasterData!.exemptions!.isNotEmpty) {
          int indexExempt = drDashCtrl.deliveryMasterData!.exemptions!.indexWhere((element) => element.id == ctrlOrderInfo?.paymentExemption);
          if(indexExempt >= 0){
            selectedExemption = drDashCtrl.deliveryMasterData?.exemptions?[indexExempt];
            if(selectedExemption?.id == "2"){
              selectedPaidData = paidList[0];
            }
          }
        }
      }

    /// Default Delivery Type
    if (ctrlOrderInfo != null && ctrlOrderInfo?.defaultDeliveryType != null && ctrlOrderInfo?.defaultDeliveryType != "") {
      if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.deliveryType != null && drDashCtrl.deliveryMasterData!.deliveryType!.isNotEmpty) {
        selectedDefaultDeliveryType = drDashCtrl.deliveryMasterData?.deliveryType?[0];
      }
    }

    /// Default Service Type
    if (ctrlOrderInfo != null && ctrlOrderInfo?.defaultService != null && ctrlOrderInfo?.defaultService != "") {
      if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.services != null && drDashCtrl.deliveryMasterData!.services!.isNotEmpty) {
        int indexService = drDashCtrl.deliveryMasterData!.services!.indexWhere((element) => element.id == ctrlOrderInfo?.defaultService);
        if(indexService >= 0){
          selectedServices = drDashCtrl.deliveryMasterData?.services?[indexService];
        }
      }
    }

    /// Nursing Home ID
    if (ctrlOrderInfo != null && ctrlOrderInfo?.nursingHomeId != null && ctrlOrderInfo?.nursingHomeId != "") {
      if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.nursingHomes != null && drDashCtrl.deliveryMasterData!.nursingHomes!.isNotEmpty) {
        int indexNurs = drDashCtrl.deliveryMasterData!.nursingHomes!.indexWhere((element) => element.id == ctrlOrderInfo?.nursingHomeId);
        if(indexNurs >= 0){
          selectedNursingHome = drDashCtrl.deliveryMasterData?.nursingHomes?[indexNurs];
        }
      }
    }
    selectedStatusType = statusType[3];

    // if (selectedDate != null && selectedSubscriptions != null) {
    //   var now = DateTime.now();
    //   var berlinWallFellDate = DateTime.utc(selectedDate!.year, selectedDate!.month, selectedDate!.day);
    //   if (berlinWallFellDate.compareTo(now) < 0) {
    //     subExpiryPopUp('Your ${selectedSubscriptions?.name} Subscription Expired at ${"${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}"}');
    //   }
    // }
    update();
  }

  /// On Will Pop
  Future<bool> onWillPop({required BuildContext context}) async {
    PrintLog.printLog("Calling OnWillPop");
    FocusScope.of(context).unfocus();

    return PopupCustom.simpleTruckDialogBox(
      context: context,
        title: kAlert,
        subTitle: kAreYouSureYouWantToCancelAllPrescriptions,
        onValue: (value){
          if(value == "yes"){
            Get.back();
          }
        },
    );

  }

  /// On Tap Add Medicine
  Future<void> onTapAddMedicine()async{
    Get.toNamed(searchMedicineScreenRoute)?.then((value) {
      PrintLog.printLog("test......${value.name}");
      if(value != null){
        rxDetailList.add(value);
      }
      PrintLog.printLog("test......${value.name}...or rxDetail Length: ${rxDetailList.length}");

    });
  }

  /// On Tap Rx Images
  Future<void> onTapRxImageBtn({required BuildContext context})async{
    BottomSheetCustom.showImagePickerBottomSheet(
        context: context,
        onValue: (value){
          PrintLog.printLog("Selected Tap Value: $value");
          if(value == kCamera){
            getImage(source: kCamera, context: context);
          }else if(value == kGallery){
            getImage(source: kGallery, context: context);
          }

        }
    );
  }

  /// On Tap Rx Details
  Future<void> onTapRxDetails({required BuildContext context})async{
    BottomSheetCustom.showRxDetailBottomSheet(
      context: context,
        onValue: (value){

        },
    );
  }

  /// On Tap Rx Details
  Future<void> onTapRemoveMedicine({required int index})async{
    rxDetailList.removeAt(index);
    update();
  }

  /// On Changed Qty Rx Details
  Future<void> onChangedQtyRxDetail({required String value,required int index})async{
    rxDetailList[index].quantity = value;
    update();
  }

  /// On Changed Days Rx Details
  Future<void> onChangedDaysRxDetail({required String value,required int index})async{
    rxDetailList[index].days = value;
    update();
  }
  /// On Tap Cd Rx Details
  Future<void> onTapCdRxDetail({required int index})async{
    rxDetailList[index].isControlDrug = !rxDetailList[index].isControlDrug;
    update();
  }
  /// On Tap Fridge Rx Details
  Future<void> onTapFridgeRxDetail({required int index})async{
    rxDetailList[index].isFridge = !rxDetailList[index].isFridge;
    update();
  }

  /// On Tap Fridge Rx Details
  Future<void> onChangedBagSize({required int index})async{
    for (var element in bagSizeList) {
      element.isSelected = false;
    }
    bagSizeList[index].isSelected = !bagSizeList[index].isSelected;
    update();
  }


  /// Get image from ImageController
  Future<void> getImage({required String source, required BuildContext context}) async {
    imagePicker?.rxImage = null;
    await imagePicker?.getImage(source: source, context: context, type: "rxImage").then((value) {
      if(imagePicker?.rxImage != null){
        rxImagesList.add(imagePicker!.rxImage!);
        update();
      }
    });
  }

  /// Remove Rx Images
  Future<void> removeRxImage({required int index})async{
    rxImagesList.removeAt(index);
    update();
  }


  /// select Data
  Future<void> selectDate()async{
    await CalenderCustom.getCalenderDate().then((value){
      selectedDate = value;
      PrintLog.printLog("Selected Data: $selectedDate");

      update();
    });
  }

  /// Select Service
  Future<void> onTapSelectService({required value})async{
    selectedServices = value;
    update();
  }
    /// Select Route
  Future<void> onTapSelectRoute({required route})async{
    selectedRoutePosition = route;
    update();
  }
  /// Select Driver
  Future<void> onTapSelectDriver({required BuildContext context,required value})async{
    if(selectedDriverPosition?.driverId != value.driverId) {
      selectedDriverPosition = value;
      getParcelBoxApi(context: context,driverId: selectedDriverPosition?.driverId ?? "0");
    }

    update();
  }

  /// Select Order Status
  Future<void> onTapSelectOrderStatus({required value})async{
    selectedStatusType = value;
    update();
  }

  /// Select Nursing Home
  Future<void> onTapSelectNursingHome({required value})async{
    selectedNursingHome = value;
    update();
  }

  /// Select Parcel Box
  Future<void> onTapSelectParcelBox({required value})async{
    selectedParcelBox = value;
    update();
  }

  /// Select Subscription
  Future<void> onTapSelectSubscription({required value})async{
    selectedSubscriptions = value;
    if (selectedSubscriptions?.name == 'Per Delivery'){
      deliveryChargeController.text = ctrlOrderInfo?.delCharge ?? selectedSubscriptions?.price ?? ""  ;
      //   deliveryChargeController.text = widget.orderInof.delCharge ?? patientSubList[value].price;
    }
    update();
  }

  /// on Tap Fridge
  Future<void> onTapFridge()async{
    isFridgeSelected = !isFridgeSelected;
    update();
  }

  /// on Tap CD
  Future<void> onTapCD()async{
    isCdSelected = !isCdSelected;
    update();
  }

  /// on Tap Paid
  Future<void> onTapPaid({required BuildContext context})async{
    if(selectedPaidData == null){
      BottomSheetCustom.showRxChargeBottomSheet(
        context: context,
        onValue: (value){
          if(value != null){
            PrintLog.printLog("Paid selected $value");
            selectedPaidData = value;
            if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.exemptions != null && drDashCtrl.deliveryMasterData!.exemptions!.isNotEmpty){
              selectedExemption = drDashCtrl.deliveryMasterData?.exemptions?[0];
              update();
            }
            update();
          }
        },
      );
    }else{
      selectedPaidData = null;
      selectedExemption = null;
      update();
    }

  }

  /// on Tap Exempt
  Future<void> onTapExempt({required BuildContext context})async{
      BottomSheetCustom.showExemptBottomSheet(
        context: context,
        onValue: (value){
          if(value != null){
            PrintLog.printLog("Exempt selected $value");

            if(value?.id != "2"){
              selectedPaidData = null;
              selectedExemption = value;
            }else if(value?.id == "2"){
              BottomSheetCustom.showRxChargeBottomSheet(
                context: context,
                onValue: (value){
                  if(value != null){
                    PrintLog.printLog("Paid selected $value");
                    selectedPaidData = value;
                    if(drDashCtrl.deliveryMasterData != null && drDashCtrl.deliveryMasterData?.exemptions != null && drDashCtrl.deliveryMasterData!.exemptions!.isNotEmpty){
                      selectedExemption = drDashCtrl.deliveryMasterData?.exemptions?[0];
                      update();
                    }
                    update();
                  }
                },
              );
            }

            update();
          }
        },
      );
  }

  /// on Remove Exempt
  Future<void> onRemoveExempt()async{
    selectedPaidData = null;
    selectedExemption = null;
    update();
  }

  /// on Tap Book Delivery
  Future<void> onTapBookDelivery({required BuildContext context})async{

      if (selectedDate == null) {
        ToastCustom.showToast(msg: kChooseDeliveryDate);
        return;
      }

      if (drDashCtrl.userType?.toLowerCase() == kPharmacy.toLowerCase() || drDashCtrl.userType?.toLowerCase() == kPharmacyStaffString.toLowerCase()){
        if (drDashCtrl.driverList.isEmpty) {
          ToastCustom.showToast(msg: kSelectRouteAgain);
          return;
        }
      }

      if (selectedRoutePosition == null) {
        ToastCustom.showToast(msg: kSelectRouteAgain);
        return;
      }

      bool isValidate = true;
      for (int i = 0; i < rxDetailList.length; i++) {
        isValidate = false;
        if (rxDetailList[i].days!.isNotEmpty && rxDetailList[i].days != "") {
          if (rxDetailList[i].days!.contains(".") || rxDetailList[i].days!.contains("-") || rxDetailList[i].days!.contains(",")) {
            ToastCustom.showToast(msg: kPleaseEnterValidDay);
            break;
          }
          bool checkValidDay = RegExp(r'[0-9]$').hasMatch(rxDetailList[i].days!);
          if (!checkValidDay) {
            ToastCustom.showToast(msg: kPleaseEnterValidDay);
          } else {
            if (double.parse(rxDetailList[i].days.toString()) > 0) {
              isValidate = true;
            } else {
              ToastCustom.showToast(msg: kPleaseEnterValueGreaterThanEqualTo1);
              break;
            }
          }
        } else {
          isValidate = true;
        }
      }

      if (isValidate){
        await updateCustomerWithCreateOrder(context: context);
      }

    update();
  }

  /// Parcel box list api
  Future<GetParcelBoxApiResponse?> getParcelBoxApi({required BuildContext context,required String driverId}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    Map<String, dynamic> dictparm = {
      "driverId":driverId
    };

    String url = WebApiConstant.GET_PHARMACY_PARCEL_BOX_URL;

    await apiCtrl.getParcelBoxApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if (result.error == false) {
            parcelBoxList = result.data;
            changeLoadingValue(false);
            changeSuccessValue(true);

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
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

  Future<String> getTitle({required String title})async{
    String tittle = "";
    if (title == "Mr") {
      tittle = "M";
    } else if (title.toLowerCase() == "Miss".toLowerCase()) {
      tittle = "S";
    } else if (title.toLowerCase() == "Mrs".toLowerCase()) {
      tittle = "F";
    } else if (title.toLowerCase() == "Ms".toLowerCase()) {
      tittle = "Q";
    } else if (title.toLowerCase() == "Captain".toLowerCase()) {
      tittle = "C";
    } else if (title.toLowerCase() == "Dr".toLowerCase()) {
      tittle = "D";
    } else if (title.toLowerCase() == "Prof".toLowerCase()) {
      tittle = "P";
    } else if (title.toLowerCase() == "Rev".toLowerCase()) {
      tittle = "R";
    } else if (title.toLowerCase() == "Mx".toLowerCase()) {
      tittle = "X";
    }
    return tittle;
  }

  Future<String> getGender({required String title})async{
    String gender = "M";
    if (title.endsWith("Mrs") || title.endsWith("Miss") || title.endsWith("Ms")) {
      gender = "F";
    }
    return gender;
  }

  Future<String> getOrderStatusType()async{
    int status = 0;
    if (selectedStatusType == "Received") {
      status = 2;
    } else if (selectedStatusType == "Requested") {
      status = 1;
    } else if (selectedStatusType == "Ready") {
      status = 3;
    } else if (selectedStatusType == "PickedUp") {
      status = 8;
    }

    if (driverType.toLowerCase() == kDedicatedDriver.toLowerCase() && drDashCtrl.isRouteStart) {
      status = 4;
    }
    return status.toString();
  }


  /// Update Customer With Create Order Api
  Future<DriverCreateOrderApiResponse?> updateCustomerWithCreateOrder({required BuildContext context}) async {

    changeEmptyValue(false);
    changeLoadingValue(true);
    changeNetworkValue(false);
    changeErrorValue(false);
    changeSuccessValue(false);

    List<Map<String, dynamic>> medicineList1 = [];
    if (rxDetailList != null && rxDetailList.isNotEmpty) {
      rxDetailList.forEach((element) {
        Map<String, dynamic> medicine1 = {
          "drug_type_cd": element != null && element.isControlDrug ? "t" : "f",
          "drug_type_fr": element != null && element.isFridge ? "t" : "f",
          "pr_id": "",
          "medicine_name": element.name,
          "dosage": "",
          "quantity": element.quantity ?? "",
          "remark": "",
          "days": element.days ?? "",
        };
        medicineList1.add(medicine1);
      });
    }



    String driverID = "";
    if (drDashCtrl.userType?.toLowerCase() == kPharmacy.toLowerCase() || drDashCtrl.userType?.toLowerCase() == kPharmacyStaffString.toLowerCase()) {
      driverID = selectedDriverPosition != null ? selectedDriverPosition?.driverId.toString()  ?? "": "";
    } else {
      driverID = userID;
    }

    String dob = ctrlOrderInfo?.userId == "0" && ctrlOrderInfo?.dob != "" ? DateFormat('dd/MM/yyyy').format(DateTime.parse(ctrlOrderInfo?.dob ?? "")) ?? "" : ctrlOrderInfo?.dob ?? "";
    // print("object:$dob...or${ctrlOrderInfo?.dob}");

    String bagSize = "";
    int bagIndex = bagSizeList.indexWhere((element) => element.isSelected == true);
    if(bagIndex >= 0){
      bagSize = bagSizeList[bagIndex].title;
    }

    Map<String, dynamic> dictparm = {
      "order_type": "manual",
      "pharmacyId": 0,
      "otherpharmacy": false,
      "pmr_type": "0",
      "endRouteId": drDashCtrl.isRouteStart ? "$endRouteId" : "0",
      "startRouteId": drDashCtrl.isRouteStart ? "$startRouteId" : "0",
      "start_lat": drDashCtrl.isRouteStart ? "$startLat" : "",
      "start_lng": drDashCtrl.isRouteStart ? "$startLng" : "",

      "nursing_home_id": ctrlOrderInfo?.nursingHomeId ?? "",
      "tote_box_id": selectedParcelBox != null ? selectedParcelBox?.id :"",

      "del_subs_id": selectedSubscriptions != null ? selectedSubscriptions?.id : "0",
      "exemption": selectedExemption != null ? selectedSubscriptions?.id : "0",
      "paymentStatus": selectedPaidData != null ? selectedPaidData?.title : "",
      "bag_size": bagSize,
      "patient_id": ctrlOrderInfo?.userId ?? "",
      "pr_id": "",
      "lat": "",
      //na
      "lng": "",
      //na
      "parcel_box_id": selectedParcelBox != null ? "${selectedParcelBox?.id}" : "0",
      "surgery_name": selectedSurgery?.name ?? "",
      "surgery": selectedSurgery?.id ?? "0",
      "amount": "",
      "email_id": "",
      "mobile_no_2": "",
      "dob": "$dob",
      "nhs_number": ctrlOrderInfo?.nhsNumber ?? "",
      "title": await getTitle(title: ctrlOrderInfo?.title ?? ""),
      "first_name": ctrlOrderInfo?.firstName ?? "",
      "middle_name": ctrlOrderInfo?.middleName ?? "",
      "last_name": ctrlOrderInfo?.lastName ?? "",
      "address_line_1": ctrlOrderInfo?.address ?? "",
      "country_id": "",
      "post_code": ctrlOrderInfo?.postCode ?? "",
      "gender": await getGender(title: ctrlOrderInfo?.title ?? ""),
      "preferred_contact_type": "",
      "delivery_type": selectedDefaultDeliveryType ?? "Delivery",
      "driver_id": driverID,
      "delivery_route": selectedRoutePosition != null ? selectedRoutePosition?.routeId : "0",
      "storage_type_cd": isFridgeSelected ? "t" : "f",
      "storage_type_fr": isCdSelected ? "t" : "f",
      "delivery_status": await getOrderStatusType() ?? "",

      "nursing_homes_id": selectedNursingHome != null ? selectedNursingHome?.id :"0",
      "shelf": "",
      "delivery_service": selectedServices != null ? selectedServices?.id :"0",
      "doctor_name": "",
      "doctor_address": "",
      "new_delivery_notes": deliveryNoteController.text.toString().trim(),
      "existing_delivery_notes": ctrlOrderInfo?.defaultDeliveryNote ?? "",
      "del_charge": deliveryChargeController.text.toString().trim(),
      "rx_charge": drDashCtrl.deliveryMasterData?.rxCharge ?? "",
      "subs_id": selectedSubscriptions != null ? selectedSubscriptions?.id : "0",
      "rx_invoice": selectedPaidData != null ? selectedPaidData?.title :"",
      "branch_notes": ctrlOrderInfo?.defaultBranchNote ?? "",
      "surgery_notes": ctrlOrderInfo?.defaultSurgeryNote ?? "",
      "medicine_name": rxDetailList,
      "prescription_images": rxImagesList,
      "delivery_date": selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate ?? DateTime.now()) : "",
    };

    String url = WebApiConstant.UPDATE_CUSTOMER_WITH_CREATE_ORDER;

    await apiCtrl.driverCreateOrderApi(context:context,url: url, dictParameter: dictparm,token: authToken)
        .then((result) async {
      if(result != null){
        try {
          if (result.error == false) {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
            if(result.data != null){
              Navigator.of(context).pop("created");
              if(drDashCtrl.isRouteStart){
                await drDashCtrl.getDeliveriesWithRouteStart(context: context);
              }else{
                await drDashCtrl.driverDashboardApi(context: context);
              }
            }

          } else {
            changeLoadingValue(false);
            changeSuccessValue(false);
            PrintLog.printLog(result.message);
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

class TitleIDorSelectedValue{
  String title;
  int id;
  bool isSelected;
  TitleIDorSelectedValue({required this.title,required this.id,required this.isSelected});
}
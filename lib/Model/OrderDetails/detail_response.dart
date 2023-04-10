import '../DriverDashboard/driver_dashboard_response.dart';

class OrderDetailResponse {
  String? orderId;
  String? parcelBoxName;
  String? pharmacyName;
  String? prId;
  String? pmrType;
  String? isCronCreated;
  String? companyId;
  String? branchId;
  String? customerId;
  String? orderNo;
  String? orderCode;
  String? orderDate;
  String? orderTypeId;
  String? orderTypeDesc;
  String? pickupTypeId;
  String? deliveryNote;
  String? recentDeliveryNote;
  String? oldRecentDeliveryNote;
  String? branchNote;
  String? rackNo;
  String? deliveryDate;
  bool? isStorageFridge;
  bool? isControlledDrugs;
  String? storageId;
  String? orderStatus;
  String? orderStatusDesc;
  String? deliveryId;
  String? driverId;
  String? driverName;
  String? oldOrderStatus;
  String? documentCaption;
  String? documentPath;
  String? deliveryStatusDesc;
  String? deliveryTo;
  String? surgeryId;
  Customer? customer;
  String? intervalCount;
  String? surgeryNote;
  String? requestPrescription;
  String? orderDetails;
  String? orderHistory;
  String? caseTypeId;
  String? remarks;
  String? branchName;
  String? sendEmail;
  String? actionType;
  String? caseType;
  String? routeId;
  String? tempDeliveryNote;
  String? tempBranchNote;
  String? fullAddress;
  String? altAddress;
  String? companyName;
  String? companyPostCode;
  String? qrCodeText;
  String? qrCodeTextstring;
  bool? isExistDeliveryNote;
  String? deliveryRemarks;
  String? exitingNote;
  String? pickupTypes;
  String? states;
  String? countries;
  String? routes;
  String? products;
  String? intervals;
  String? orderStatusList;
  String? deliveryStatusList;
  String? deliveryTypes;
  String? storages;
  String? statusList;
  String? preferredContactTypes;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? firstName;
  String? middleName;
  String? lastName;
  String? mobile;
  String? oldMobile;
  String? email;
  String? oldEmail;
  String? landlineNumber;
  String? alternativeContact;
  String? dependentContactNumber;
  String? contactPerson;
  String? countryName;
  String? gender;
  String? title;
  CustomerAddress? address;
  String? showValidationMsg;
  String? token;
  String? taskStatusList;
  String? isApproved;
  String? message;
  List<RelatedOrders>? relatedOrders;
  String? relatedOrderCount;
  String? exemption;
  String? paymentStatus;
  String? bagSize;
  String? subsId;
  String? delCharge;
  String? rxCharge;
  String? rxInvoice;
  String? nursingHomeId;
  String? toteBoxId;
  String? totalStorageFridge;
  String? totalControlledDrugs;

  List<Exemptions> exemptions = [];

  String? parcelName;

  /// New added
  String? isPresCharge;
  String? pharmacyId;

  OrderDetailResponse(
      {
        this.parcelName,

        this.orderId,
        this.parcelBoxName,
        this.pharmacyName,
        this.prId,
        this.pmrType,
        this.isCronCreated,
        this.companyId,
        this.branchId,
        this.customerId,
        this.orderNo,
        this.orderCode,
        this.orderDate,
        this.orderTypeId,
        this.orderTypeDesc,
        this.pickupTypeId,
        this.deliveryNote,
        this.recentDeliveryNote,
        this.oldRecentDeliveryNote,
        this.branchNote,
        this.rackNo,
        this.deliveryDate,
        this.isStorageFridge,
        this.isControlledDrugs,
        this.storageId,
        this.orderStatus,
        this.orderStatusDesc,
        this.deliveryId,
        this.driverId,
        this.driverName,
        this.oldOrderStatus,
        this.documentCaption,
        this.documentPath,
        this.deliveryStatusDesc,
        this.deliveryTo,
        this.surgeryId,
        this.customer,
        this.intervalCount,
        this.surgeryNote,
        this.requestPrescription,
        this.orderDetails,
        this.orderHistory,
        this.caseTypeId,
        this.remarks,
        this.branchName,
        this.sendEmail,
        this.actionType,
        this.caseType,
        this.routeId,
        this.tempDeliveryNote,
        this.tempBranchNote,
        this.fullAddress,
        this.altAddress,
        this.companyName,
        this.companyPostCode,
        this.qrCodeText,
        this.qrCodeTextstring,
        this.isExistDeliveryNote,
        this.deliveryRemarks,
        this.exitingNote,
        this.pickupTypes,
        this.states,
        this.countries,
        this.routes,
        this.products,
        this.intervals,
        this.orderStatusList,
        this.deliveryStatusList,
        this.deliveryTypes,
        this.storages,
        this.statusList,
        this.preferredContactTypes,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn,
        this.firstName,
        this.middleName,
        this.lastName,
        this.mobile,
        this.oldMobile,
        this.email,
        this.oldEmail,
        this.landlineNumber,
        this.alternativeContact,
        this.dependentContactNumber,
        this.contactPerson,
        this.countryName,
        this.gender,
        this.title,
        this.address,
        this.showValidationMsg,
        this.token,
        this.taskStatusList,
        this.isApproved,
        this.message,
        this.relatedOrders,
        this.relatedOrderCount,
        this.exemption,
        this.paymentStatus,
        this.bagSize,
        this.subsId,
        this.delCharge,
        this.rxCharge,
        this.rxInvoice,
        this.nursingHomeId,
        this.toteBoxId,
        this.totalStorageFridge,
        this.totalControlledDrugs});

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'] != null ? json['orderId'].toString():null;
    parcelBoxName = json['parcel_box_name'] != null ? json['parcel_box_name'].toString():null;
    pharmacyName = json['pharmacy_name'] != null ? json['pharmacy_name'].toString():null;
    prId = json['pr_id'] != null ? json['pr_id'].toString():null;
    pmrType = json['pmr_type'] != null ? json['pmr_type'].toString():null;
    isCronCreated = json['isCronCreated'] != null ? json['isCronCreated'].toString():null;
    companyId = json['companyId'] != null ? json['companyId'].toString():null;
    branchId = json['branchId'] != null ? json['branchId'].toString():null;
    customerId = json['customerId'] != null ? json['customerId'].toString():null;
    orderNo = json['orderNo'] != null ? json['orderNo'].toString():null;
    orderCode = json['orderCode'] != null ? json['orderCode'].toString():null;
    orderDate = json['orderDate'] != null ? json['orderDate'].toString():null;
    orderTypeId = json['orderTypeId'] != null ? json['orderTypeId'].toString():null;
    orderTypeDesc = json['orderTypeDesc'] != null ? json['orderTypeDesc'].toString():null;
    pickupTypeId = json['pickupTypeId'] != null ? json['pickupTypeId'].toString():null;
    deliveryNote = json['deliveryNote'] != null ? json['deliveryNote'].toString():null;
    recentDeliveryNote = json['recentDeliveryNote'] != null ? json['recentDeliveryNote'].toString():null;
    oldRecentDeliveryNote = json['oldRecentDeliveryNote'] != null ? json['oldRecentDeliveryNote'].toString():null;
    branchNote = json['branchNote'] != null ? json['branchNote'].toString():null;
    rackNo = json['rackNo'] != null ? json['rackNo'].toString():null;
    deliveryDate = json['deliveryDate'] != null ? json['deliveryDate'].toString():null;
    isStorageFridge = json['isStorageFridge'] != null && json['isStorageFridge'].toString().toLowerCase() == "true" ? true:false;
    isControlledDrugs = json['isControlledDrugs'] != null && json['isControlledDrugs'].toString().toLowerCase() == "true" ? true:false;
    storageId = json['storageId'] != null ? json['storageId'].toString():null;
    orderStatus = json['orderStatus'] != null ? json['orderStatus'].toString():null;
    orderStatusDesc = json['orderStatusDesc'] != null ? json['orderStatusDesc'].toString():null;
    deliveryId = json['deliveryId'] != null ? json['deliveryId'].toString():null;
    driverId = json['driverId'] != null ? json['driverId'].toString():null;
    driverName = json['driverName'] != null ? json['driverName'].toString():null;
    oldOrderStatus = json['oldOrderStatus'] != null ? json['oldOrderStatus'].toString():null;
    documentCaption = json['documentCaption'] != null ? json['documentCaption'].toString():null;
    documentPath = json['documentPath'] != null ? json['documentPath'].toString():null;
    deliveryStatusDesc = json['deliveryStatusDesc'] != null ? json['deliveryStatusDesc'].toString():null;
    deliveryTo = json['deliveryTo'] != null ? json['deliveryTo'].toString():null;
    surgeryId = json['surgeryId'] != null ? json['surgeryId'].toString():null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    intervalCount = json['intervalCount'] != null ? json['intervalCount'].toString():null;
    surgeryNote = json['surgeryNote'] != null ? json['surgeryNote'].toString():null;
    requestPrescription = json['requestPrescription'] != null ? json['requestPrescription'].toString():null;
    orderDetails = json['orderDetails'] != null ? json['orderDetails'].toString():null;
    orderHistory = json['orderHistory'] != null ? json['orderHistory'].toString():null;
    caseTypeId = json['caseTypeId'] != null ? json['caseTypeId'].toString():null;
    remarks = json['remarks'] != null ? json['remarks'].toString():null;
    branchName = json['branchName'] != null ? json['branchName'].toString():null;
    sendEmail = json['sendEmail'] != null ? json['sendEmail'].toString():null;
    actionType = json['actionType'] != null ? json['actionType'].toString():null;
    caseType = json['caseType'] != null ? json['caseType'].toString():null;
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    tempDeliveryNote = json['tempDeliveryNote'] != null ? json['tempDeliveryNote'].toString():null;
    tempBranchNote = json['tempBranchNote'] != null ? json['tempBranchNote'].toString():null;
    fullAddress = json['fullAddress'] != null ? json['fullAddress'].toString():null;
    altAddress = json['alt_address'] != null ? json['alt_address'].toString():null;
    companyName = json['companyName'] != null ? json['companyName'].toString():null;
    companyPostCode = json['companyPostCode'] != null ? json['companyPostCode'].toString():null;
    qrCodeText = json['qrCodeText'] != null ? json['qrCodeText'].toString():null;
    qrCodeTextstring = json['qrCodeTextstring'] != null ? json['qrCodeTextstring'].toString():null;
    isExistDeliveryNote = json['isExistDeliveryNote'] != null && json['isExistDeliveryNote'].toString().toLowerCase() == "true" ? true:false;
    deliveryRemarks = json['deliveryRemarks'] != null ? json['deliveryRemarks'].toString():null;
    exitingNote = json['exitingNote'] != null ? json['exitingNote'].toString():null;
    pickupTypes = json['pickupTypes'] != null ? json['pickupTypes'].toString():null;
    states = json['states'] != null ? json['states'].toString():null;
    countries = json['countries'] != null ? json['countries'].toString():null;
    routes = json['routes'] != null ? json['routes'].toString():null;
    products = json['products'] != null ? json['products'].toString():null;
    intervals = json['intervals'] != null ? json['intervals'].toString():null;
    orderStatusList = json['orderStatusList'] != null ? json['orderStatusList'].toString():null;
    deliveryStatusList = json['deliveryStatusList'] != null ? json['deliveryStatusList'].toString():null;
    deliveryTypes = json['deliveryTypes'] != null ? json['deliveryTypes'].toString():null;
    storages = json['storages'] != null ? json['storages'].toString():null;
    statusList = json['statusList'] != null ? json['statusList'].toString():null;
    preferredContactTypes = json['preferredContactTypes'] != null ? json['preferredContactTypes'].toString():null;
    createdBy = json['createdBy'] != null ? json['createdBy'].toString():null;
    createdOn = json['createdOn'] != null ? json['createdOn'].toString():null;
    modifiedBy = json['modifiedBy'] != null ? json['modifiedBy'].toString():null;
    modifiedOn = json['modifiedOn'] != null ? json['modifiedOn'].toString():null;
    firstName = json['firstName'] != null ? json['firstName'].toString():null;
    middleName = json['middleName'] != null ? json['middleName'].toString():null;
    lastName = json['lastName'] != null ? json['lastName'].toString():null;
    mobile = json['mobile'] != null ? json['mobile'].toString():null;
    oldMobile = json['oldMobile'] != null ? json['oldMobile'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    oldEmail = json['oldEmail'] != null ? json['oldEmail'].toString():null;
    landlineNumber = json['landlineNumber'] != null ? json['landlineNumber'].toString():null;
    alternativeContact = json['alternativeContact'] != null ? json['alternativeContact'].toString():null;
    dependentContactNumber = json['dependentContactNumber'] != null ? json['dependentContactNumber'].toString():null;
    contactPerson = json['contactPerson'] != null ? json['contactPerson'].toString():null;
    countryName = json['countryName'] != null ? json['countryName'].toString():null;
    gender = json['gender'] != null ? json['gender'].toString():null;
    title = json['title'] != null ? json['title'].toString():null;
    address = json['address'] != null
        ? new CustomerAddress.fromJson(json['address'])
        : null;
    showValidationMsg = json['showValidationMsg'] != null ? json['showValidationMsg'].toString(): null;
    token = json['token'] != null ? json['token'].toString(): null;
    taskStatusList = json['taskStatusList'] != null ? json['taskStatusList'].toString(): null;
    isApproved = json['isApproved'] != null ? json['isApproved'].toString(): null;
    message = json['message'] != null ? json['message'].toString(): null;
    customer = json['Customer'] != null
        ? new Customer.fromJson(json['Customer'])
        : null;
    address = json['Address'] != null
        ? new CustomerAddress.fromJson(json['Address'])
        : null;
    if (json['related_orders'] != null) {
      relatedOrders = <RelatedOrders>[];
      json['related_orders'].forEach((v) {
        relatedOrders!.add(new RelatedOrders.fromJson(v));
      });
    }
    relatedOrderCount = json['related_order_count'] != null ? json['related_order_count'].toString(): null;
    exemption = json['exemption'] != null ? json['exemption'].toString(): null;
    paymentStatus = json['paymentStatus'] != null ? json['paymentStatus'].toString(): null;
    bagSize = json['bagSize'] != null ? json['bagSize'].toString(): null;
    subsId = json['subs_id'] != null ? json['subs_id'].toString(): null;
    delCharge = json['del_charge'] != null ? json['del_charge'].toString(): null;
    rxCharge = json['rx_charge'] != null ? json['rx_charge'].toString(): null;
    rxInvoice = json['rx_invoice'] != null ? json['rx_invoice'].toString(): null;
    nursingHomeId = json['nursing_home_id'] != null ? json['nursing_home_id'].toString(): null;
    toteBoxId = json['tote_box_id'] != null ? json['tote_box_id'].toString(): null;
    totalStorageFridge = json['totalStorageFridge'] != null ? json['totalStorageFridge'].toString(): null;
    totalControlledDrugs = json['totalControlledDrugs'] != null ? json['totalControlledDrugs'].toString(): null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['parcel_box_name'] = this.parcelBoxName;
    data['pharmacy_name'] = this.pharmacyName;
    data['pr_id'] = this.prId;
    data['pmr_type'] = this.pmrType;
    data['isCronCreated'] = this.isCronCreated;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['customerId'] = this.customerId;
    data['orderNo'] = this.orderNo;
    data['orderCode'] = this.orderCode;
    data['orderDate'] = this.orderDate;
    data['orderTypeId'] = this.orderTypeId;
    data['orderTypeDesc'] = this.orderTypeDesc;
    data['pickupTypeId'] = this.pickupTypeId;
    data['deliveryNote'] = this.deliveryNote;
    data['recentDeliveryNote'] = this.recentDeliveryNote;
    data['oldRecentDeliveryNote'] = this.oldRecentDeliveryNote;
    data['branchNote'] = this.branchNote;
    data['rackNo'] = this.rackNo;
    data['deliveryDate'] = this.deliveryDate;
    data['isStorageFridge'] = this.isStorageFridge;
    data['isControlledDrugs'] = this.isControlledDrugs;
    data['storageId'] = this.storageId;
    data['orderStatus'] = this.orderStatus;
    data['orderStatusDesc'] = this.orderStatusDesc;
    data['deliveryId'] = this.deliveryId;
    data['driverId'] = this.driverId;
    data['driverName'] = this.driverName;
    data['oldOrderStatus'] = this.oldOrderStatus;
    data['documentCaption'] = this.documentCaption;
    data['documentPath'] = this.documentPath;
    data['deliveryStatusDesc'] = this.deliveryStatusDesc;
    data['deliveryTo'] = this.deliveryTo;
    data['surgeryId'] = this.surgeryId;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['intervalCount'] = this.intervalCount;
    data['surgeryNote'] = this.surgeryNote;
    data['requestPrescription'] = this.requestPrescription;
    data['orderDetails'] = this.orderDetails;
    data['orderHistory'] = this.orderHistory;
    data['caseTypeId'] = this.caseTypeId;
    data['remarks'] = this.remarks;
    data['branchName'] = this.branchName;
    data['sendEmail'] = this.sendEmail;
    data['actionType'] = this.actionType;
    data['caseType'] = this.caseType;
    data['routeId'] = this.routeId;
    data['tempDeliveryNote'] = this.tempDeliveryNote;
    data['tempBranchNote'] = this.tempBranchNote;
    data['fullAddress'] = this.fullAddress;
    data['alt_address'] = this.altAddress;
    data['companyName'] = this.companyName;
    data['companyPostCode'] = this.companyPostCode;
    data['qrCodeText'] = this.qrCodeText;
    data['qrCodeTextstring'] = this.qrCodeTextstring;
    data['isExistDeliveryNote'] = this.isExistDeliveryNote;
    data['deliveryRemarks'] = this.deliveryRemarks;
    data['exitingNote'] = this.exitingNote;
    data['pickupTypes'] = this.pickupTypes;
    data['states'] = this.states;
    data['countries'] = this.countries;
    data['routes'] = this.routes;
    data['products'] = this.products;
    data['intervals'] = this.intervals;
    data['orderStatusList'] = this.orderStatusList;
    data['deliveryStatusList'] = this.deliveryStatusList;
    data['deliveryTypes'] = this.deliveryTypes;
    data['storages'] = this.storages;
    data['statusList'] = this.statusList;
    data['preferredContactTypes'] = this.preferredContactTypes;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['mobile'] = this.mobile;
    data['oldMobile'] = this.oldMobile;
    data['email'] = this.email;
    data['oldEmail'] = this.oldEmail;
    data['landlineNumber'] = this.landlineNumber;
    data['alternativeContact'] = this.alternativeContact;
    data['dependentContactNumber'] = this.dependentContactNumber;
    data['contactPerson'] = this.contactPerson;
    data['countryName'] = this.countryName;
    data['gender'] = this.gender;
    data['title'] = this.title;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['showValidationMsg'] = this.showValidationMsg;
    data['token'] = this.token;
    data['taskStatusList'] = this.taskStatusList;
    data['isApproved'] = this.isApproved;
    data['message'] = this.message;
    if (this.customer != null) {
      data['Customer'] = this.customer!.toJson();
    }
    if (this.address != null) {
      data['Address'] = this.address!.toJson();
    }
    if (this.relatedOrders != null) {
      data['related_orders'] =
          this.relatedOrders!.map((v) => v.toJson()).toList();
    }
    data['related_order_count'] = this.relatedOrderCount;
    data['exemption'] = this.exemption;
    data['paymentStatus'] = this.paymentStatus;
    data['bagSize'] = this.bagSize;
    data['subs_id'] = this.subsId;
    data['del_charge'] = this.delCharge;
    data['rx_charge'] = this.rxCharge;
    data['rx_invoice'] = this.rxInvoice;
    data['nursing_home_id'] = this.nursingHomeId;
    data['tote_box_id'] = this.toteBoxId;
    data['totalStorageFridge'] = this.totalStorageFridge;
    data['totalControlledDrugs'] = this.totalControlledDrugs;
    return data;
  }
}

class Customer {
  String? customerId;
  String? addressId;
  String? nhsNumber;
  String? oldNhsNumber;
  String? inputDob;
  String? dob;
  String? lastOrderDate;
  String? upcomingDeliveryDate;
  String? reminderDate;
  String? deliveryDate;
  String? pickupTypeId;
  String? pickupType;
  String? routeId;
  String? isActive;
  String? doctorId;
  String? surgeryId;
  String? surgeryEmail;
  String? surgeryMobile;
  String? paymentExemption;
  String? deliveryNote;
  String? branchNote;
  String? surgeryNote;
  bool? fridgeNote;
  String? customerNote;
  bool? controlNote;
  String? orders;
  String? surgeries;
  String? paymentExemptions;
  String? customerDocuments;
  String? preferredContactNumber;
  String? companyId;
  String? branchId;
  String? surgeryName;
  String? rating;
  String? fullName;
  String? fullAddress;
  String? altAddress;
  String? totalCount;
  String? rowNum;
  String? routeName;
  String? caseTypeId;
  String? paymentExemptionDesc;
  String? branchCode;
  CustomerAddress? customerAddress;
  String? pickupTypes;
  String? states;
  String? countries;
  String? routes;
  String? products;
  String? intervals;
  String? orderStatusList;
  String? deliveryStatusList;
  String? deliveryTypes;
  String? storages;
  String? statusList;
  String? preferredContactTypes;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? firstName;
  String? middleName;
  String? lastName;
  String? mobile;
  String? oldMobile;
  String? email;
  String? oldEmail;
  String? landlineNumber;
  String? alternativeContact;
  String? dependentContactNumber;
  String? contactPerson;
  String? countryName;
  String? gender;
  String? title;
  CustomerAddress? address;
  String? latitude;
  String? longitude;
  bool? showValidationMsg;
  String? token;
  String? taskStatusList;
  String? isApproved;

  Customer(
      {this.customerId,
        this.addressId,
        this.nhsNumber,
        this.oldNhsNumber,
        this.inputDob,
        this.dob,
        this.lastOrderDate,
        this.upcomingDeliveryDate,
        this.reminderDate,
        this.deliveryDate,
        this.pickupTypeId,
        this.pickupType,
        this.routeId,
        this.isActive,
        this.doctorId,
        this.surgeryId,
        this.surgeryEmail,
        this.surgeryMobile,
        this.paymentExemption,
        this.deliveryNote,
        this.branchNote,
        this.surgeryNote,
        this.fridgeNote,
        this.customerNote,
        this.controlNote,
        this.orders,
        this.surgeries,
        this.paymentExemptions,
        this.customerDocuments,
        this.preferredContactNumber,
        this.companyId,
        this.branchId,
        this.surgeryName,
        this.rating,
        this.fullName,
        this.fullAddress,
        this.altAddress,
        this.totalCount,
        this.rowNum,
        this.routeName,
        this.caseTypeId,
        this.paymentExemptionDesc,
        this.branchCode,
        this.customerAddress,
        this.pickupTypes,
        this.states,
        this.countries,
        this.routes,
        this.products,
        this.intervals,
        this.orderStatusList,
        this.deliveryStatusList,
        this.deliveryTypes,
        this.storages,
        this.statusList,
        this.preferredContactTypes,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn,
        this.firstName,
        this.middleName,
        this.lastName,
        this.mobile,
        this.oldMobile,
        this.email,
        this.oldEmail,
        this.landlineNumber,
        this.alternativeContact,
        this.dependentContactNumber,
        this.contactPerson,
        this.countryName,
        this.gender,
        this.title,
        this.address,
        this.latitude,
        this.longitude,
        this.showValidationMsg,
        this.token,
        this.taskStatusList,
        this.isApproved,
      });

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'] != null ? json['customerId'].toString():null;
    addressId = json['addressId'] != null ? json['addressId'].toString():null;
    nhsNumber = json['nhsNumber'] != null ? json['nhsNumber'].toString():null;
    oldNhsNumber = json['oldNhsNumber'] != null ? json['oldNhsNumber'].toString():null;
    inputDob = json['inputDob'] != null ? json['inputDob'].toString():null;
    dob = json['dob'] != null ? json['dob'].toString():null;
    lastOrderDate = json['lastOrderDate'] != null ? json['lastOrderDate'].toString():null;
    upcomingDeliveryDate = json['upcomingDeliveryDate'] != null ? json['upcomingDeliveryDate'].toString():null;
    reminderDate = json['reminderDate'] != null ? json['reminderDate'].toString():null;
    deliveryDate = json['deliveryDate'] != null ? json['deliveryDate'].toString():null;
    pickupTypeId = json['pickupTypeId'] != null ? json['pickupTypeId'].toString():null;
    pickupType = json['pickupType'] != null ? json['pickupType'].toString():null;
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    isActive = json['isActive'] != null ? json['isActive'].toString():null;
    doctorId = json['doctorId'] != null ? json['doctorId'].toString():null;
    surgeryId = json['surgeryId'] != null ? json['surgeryId'].toString():null;
    surgeryEmail = json['surgeryEmail'] != null ? json['surgeryEmail'].toString():null;
    surgeryMobile = json['surgeryMobile'] != null ? json['surgeryMobile'].toString():null;
    paymentExemption = json['paymentExemption'] != null ? json['paymentExemption'].toString():null;
    deliveryNote = json['deliveryNote'] != null ? json['deliveryNote'].toString():null;
    branchNote = json['branchNote'] != null ? json['branchNote'].toString():null;
    surgeryNote = json['surgeryNote'] != null ? json['surgeryNote'].toString():null;
    fridgeNote = json['fridgeNote'] != null && json['fridgeNote'].toString().toLowerCase() == "true" ? true:false;
    customerNote = json['customerNote'] != null ? json['customerNote'].toString():null;
    controlNote = json['controlNote'] != null && json['controlNote'].toString().toLowerCase() == "true" ? true:false;
    orders = json['orders'] != null ? json['orders'].toString():null;
    surgeries = json['surgeries'] != null ? json['surgeries'].toString():null;
    paymentExemptions = json['paymentExemptions'] != null ? json['paymentExemptions'].toString():null;
    customerDocuments = json['customerDocuments'] != null ? json['customerDocuments'].toString():null;
    preferredContactNumber = json['preferredContactNumber'] != null ? json['preferredContactNumber'].toString():null;
    companyId = json['companyId'] != null ? json['companyId'].toString():null;
    branchId = json['branchId'] != null ? json['branchId'].toString():null;
    surgeryName = json['surgeryName'] != null ? json['surgeryName'].toString():null;
    rating = json['rating'] != null ? json['rating'].toString():null;
    fullName = json['fullName'] != null ? json['fullName'].toString():null;
    fullAddress = json['fullAddress'] != null ? json['fullAddress'].toString():null;
    altAddress = json['alt_address'] != null ? json['alt_address'].toString():null;
    totalCount = json['totalCount'] != null ? json['totalCount'].toString():null;
    rowNum = json['rowNum'] != null ? json['rowNum'].toString():null;
    routeName = json['routeName'] != null ? json['routeName'].toString():null;
    caseTypeId = json['caseTypeId'] != null ? json['caseTypeId'].toString():null;
    paymentExemptionDesc = json['paymentExemptionDesc'] != null ? json['paymentExemptionDesc'].toString():null;
    branchCode = json['branchCode'] != null ? json['branchCode'].toString():null;
    customerAddress = json['customerAddress'] != null
        ? new CustomerAddress.fromJson(json['customerAddress'])
        : null;
    pickupTypes = json['pickupTypes'] != null ? json['pickupTypes'].toString():null;
    states = json['states'] != null ? json['states'].toString():null;
    countries = json['countries'] != null ? json['countries'].toString():null;
    routes = json['routes'] != null ? json['routes'].toString():null;
    products = json['products'] != null ? json['products'].toString():null;
    intervals = json['intervals'] != null ? json['intervals'].toString():null;
    orderStatusList = json['orderStatusList'] != null ? json['orderStatusList'].toString():null;
    deliveryStatusList = json['deliveryStatusList'] != null ? json['deliveryStatusList'].toString():null;
    deliveryTypes = json['deliveryTypes'] != null ? json['deliveryTypes'].toString():null;
    storages = json['storages'] != null ? json['storages'].toString():null;
    statusList = json['statusList'] != null ? json['statusList'].toString():null;
    preferredContactTypes = json['preferredContactTypes'] != null ? json['preferredContactTypes'].toString():null;
    createdBy = json['createdBy'] != null ? json['createdBy'].toString():null;
    createdOn = json['createdOn'] != null ? json['createdOn'].toString():null;
    modifiedBy = json['modifiedBy'] != null ? json['modifiedBy'].toString():null;
    modifiedOn = json['modifiedOn'] != null ? json['modifiedOn'].toString():null;
    firstName = json['firstName'] != null ? json['firstName'].toString():null;
    middleName = json['middleName'] != null ? json['middleName'].toString():null;
    lastName = json['lastName'] != null ? json['lastName'].toString():null;
    mobile = json['mobile'] != null ? json['mobile'].toString():null;
    oldMobile = json['oldMobile'] != null ? json['oldMobile'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    oldEmail = json['oldEmail'] != null ? json['oldEmail'].toString():null;
    landlineNumber = json['landlineNumber'] != null ? json['landlineNumber'].toString():null;
    alternativeContact = json['alternativeContact'] != null ? json['alternativeContact'].toString():null;
    dependentContactNumber = json['dependentContactNumber'] != null ? json['dependentContactNumber'].toString():null;
    contactPerson = json['contactPerson'] != null ? json['contactPerson'].toString():null;
    countryName = json['countryName'] != null ? json['countryName'].toString():null;
    gender = json['gender'] != null ? json['gender'].toString():null;
    title = json['title'] != null ? json['title'].toString():null;
    address = json['address'] != null
        ? new CustomerAddress.fromJson(json['address'])
        : null;
    latitude = json['latitude'] != null ? json['latitude'].toString():null;
    longitude = json['longitude'] != null ? json['longitude'].toString():null;
    showValidationMsg = json['showValidationMsg'] != null && json['showValidationMsg'].toString().toLowerCase() == "true" ? true:false;
    token = json['token'] != null ? json['token'].toString():null;
    taskStatusList = json['taskStatusList'] != null ? json['taskStatusList'].toString():null;
    isApproved = json['isApproved'] != null ? json['isApproved'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['addressId'] = this.addressId;
    data['nhsNumber'] = this.nhsNumber;
    data['oldNhsNumber'] = this.oldNhsNumber;
    data['inputDob'] = this.inputDob;
    data['dob'] = this.dob;
    data['lastOrderDate'] = this.lastOrderDate;
    data['upcomingDeliveryDate'] = this.upcomingDeliveryDate;
    data['reminderDate'] = this.reminderDate;
    data['deliveryDate'] = this.deliveryDate;
    data['pickupTypeId'] = this.pickupTypeId;
    data['pickupType'] = this.pickupType;
    data['routeId'] = this.routeId;
    data['isActive'] = this.isActive;
    data['doctorId'] = this.doctorId;
    data['surgeryId'] = this.surgeryId;
    data['surgeryEmail'] = this.surgeryEmail;
    data['surgeryMobile'] = this.surgeryMobile;
    data['paymentExemption'] = this.paymentExemption;
    data['deliveryNote'] = this.deliveryNote;
    data['branchNote'] = this.branchNote;
    data['surgeryNote'] = this.surgeryNote;
    data['fridgeNote'] = this.fridgeNote;
    data['customerNote'] = this.customerNote;
    data['controlNote'] = this.controlNote;
    data['orders'] = this.orders;
    data['surgeries'] = this.surgeries;
    data['paymentExemptions'] = this.paymentExemptions;
    data['customerDocuments'] = this.customerDocuments;
    data['preferredContactNumber'] = this.preferredContactNumber;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['surgeryName'] = this.surgeryName;
    data['rating'] = this.rating;
    data['fullName'] = this.fullName;
    data['fullAddress'] = this.fullAddress;
    data['alt_address'] = this.altAddress;
    data['totalCount'] = this.totalCount;
    data['rowNum'] = this.rowNum;
    data['routeName'] = this.routeName;
    data['caseTypeId'] = this.caseTypeId;
    data['paymentExemptionDesc'] = this.paymentExemptionDesc;
    data['branchCode'] = this.branchCode;
    if (this.customerAddress != null) {
      data['customerAddress'] = this.customerAddress!.toJson();
    }
    data['pickupTypes'] = this.pickupTypes;
    data['states'] = this.states;
    data['countries'] = this.countries;
    data['routes'] = this.routes;
    data['products'] = this.products;
    data['intervals'] = this.intervals;
    data['orderStatusList'] = this.orderStatusList;
    data['deliveryStatusList'] = this.deliveryStatusList;
    data['deliveryTypes'] = this.deliveryTypes;
    data['storages'] = this.storages;
    data['statusList'] = this.statusList;
    data['preferredContactTypes'] = this.preferredContactTypes;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['mobile'] = this.mobile;
    data['oldMobile'] = this.oldMobile;
    data['email'] = this.email;
    data['oldEmail'] = this.oldEmail;
    data['landlineNumber'] = this.landlineNumber;
    data['alternativeContact'] = this.alternativeContact;
    data['dependentContactNumber'] = this.dependentContactNumber;
    data['contactPerson'] = this.contactPerson;
    data['countryName'] = this.countryName;
    data['gender'] = this.gender;
    data['title'] = this.title;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['showValidationMsg'] = this.showValidationMsg;
    data['token'] = this.token;
    data['taskStatusList'] = this.taskStatusList;
    data['isApproved'] = this.isApproved;
    data['Title'] = this.title;
    return data;
  }
}

class CustomerAddress {
  String? altAddress;
  String? address1;
  String? oldAddress1;
  String? address2;
  String? oldAddress2;
  String? city;
  String? stateId;
  String? countryId;
  String? postCode;
  String? oldPostCode;
  String? contacts;
  String? countryName;
  String? preferredContactType;
  String? stateName;
  String? latitude;
  String? longitude;
  String? duration;
  String? distance;

  CustomerAddress(
      {this.altAddress,
        this.address1,
        this.oldAddress1,
        this.address2,
        this.oldAddress2,
        this.city,
        this.stateId,
        this.countryId,
        this.postCode,
        this.oldPostCode,
        this.contacts,
        this.countryName,
        this.preferredContactType,
        this.stateName,
        this.latitude,
        this.longitude,
        this.duration,
        this.distance});

  CustomerAddress.fromJson(Map<String, dynamic> json) {
    altAddress = json['alt_address'] != null ? json['alt_address'].toString() : null;
    address1 = json['address1'] != null ? json['address1'].toString() : null;
    oldAddress1 = json['oldAddress1'] != null ? json['oldAddress1'].toString() : null;
    address2 = json['address2'] != null ? json['address2'].toString() : null;
    oldAddress2 = json['oldAddress2'] != null ? json['oldAddress2'].toString() : null;
    city = json['city'] != null ? json['city'].toString() : null;
    stateId = json['stateId'] != null ? json['stateId'].toString() : null;
    countryId = json['countryId'] != null ? json['countryId'].toString() : null;
    postCode = json['postCode'] != null ? json['postCode'].toString() : null;
    oldPostCode = json['oldPostCode'] != null ? json['oldPostCode'].toString() : null;
    contacts = json['contacts'] != null ? json['contacts'].toString() : null;
    countryName = json['countryName'] != null ? json['countryName'].toString() : null;
    preferredContactType = json['preferredContactType'] != null ? json['preferredContactType'].toString() : null;
    stateName = json['stateName'] != null ? json['stateName'].toString() : null;
    latitude = json['latitude'] != null ? json['latitude'].toString() : null;
    longitude = json['longitude'] != null ? json['longitude'].toString() : null;
    duration = json['duration'] != null ? json['duration'].toString() : null;
    distance = json['distance'] != null ? json['distance'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alt_address'] = this.altAddress;
    data['address1'] = this.address1;
    data['oldAddress1'] = this.oldAddress1;
    data['address2'] = this.address2;
    data['oldAddress2'] = this.oldAddress2;
    data['city'] = this.city;
    data['stateId'] = this.stateId;
    data['countryId'] = this.countryId;
    data['postCode'] = this.postCode;
    data['oldPostCode'] = this.oldPostCode;
    data['contacts'] = this.contacts;
    data['countryName'] = this.countryName;
    data['preferredContactType'] = this.preferredContactType;
    data['stateName'] = this.stateName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

class RelatedOrders {
  String? orderId;
  String? parcelBoxName;
  String? pharmacyName;
  String? userId;
  String? pmrType;
  String? isCronCreated;
  String? deliveryStatus;
  String? prId;
  bool? isControlledDrugs;
  bool? isStorageFridge;
  String? deliveryNotes;
  String? fullName;
  String? fullAddress;
  String? altAddress;
  String? dob;
  String? existingDeliveryNotes;
  String? subsId;
  String? delCharge;
  String? rxCharge;
  String? rxInvoice;
  String? nursingHomeId;
  String? toteBoxId;

  bool isSelected = false;

  /// new add
  String? bagSize;
  String? exemption;
  String? totalStorageFridge;
  String? totalControlledDrugs;
  String? mobileNo;
  String? paymentStatus;
  String? isPresCharge;
  String? isDelCharge;

  RelatedOrders(
      {this.orderId,
        this.parcelBoxName,
        this.pharmacyName,
        this.userId,
        this.pmrType,
        this.isCronCreated,
        this.deliveryStatus,
        this.prId,
        this.isControlledDrugs,
        this.isStorageFridge,
        this.deliveryNotes,
        this.fullName,
        this.fullAddress,
        this.altAddress,
        this.dob,
        this.existingDeliveryNotes,
        this.subsId,
        this.delCharge,
        this.rxCharge,
        this.rxInvoice,
        this.nursingHomeId,
        this.toteBoxId});

  RelatedOrders.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'] != null ? json['orderId'].toString() : null;
    parcelBoxName = json['parcel_box_name'] != null ? json['parcel_box_name'].toString() : null;
    pharmacyName = json['pharmacy_name'] != null ? json['pharmacy_name'].toString() : null;
    userId = json['userId'] != null ? json['userId'].toString() : null;
    pmrType = json['pmr_type'] != null ? json['pmr_type'].toString() : null;
    isCronCreated = json['isCronCreated'] != null ? json['isCronCreated'].toString() : null;
    deliveryStatus = json['deliveryStatus'] != null ? json['deliveryStatus'].toString() : null;
    prId = json['pr_id'] != null ? json['pr_id'].toString() : null;
    isControlledDrugs = json['isControlledDrugs'] != null && json['isControlledDrugs'].toString().toLowerCase() == "true" ? true : false;
    isStorageFridge = json['isStorageFridge'] != null && json['isStorageFridge'].toString().toLowerCase() == "true" ? true : false;
    deliveryNotes = json['deliveryNotes'] != null ? json['deliveryNotes'].toString() : null;
    fullName = json['fullName'] != null ? json['fullName'].toString() : null;
    fullAddress = json['fullAddress'] != null ? json['fullAddress'].toString() : null;
    altAddress = json['alt_address'] != null ? json['alt_address'].toString() : null;
    dob = json['dob'] != null ? json['dob'].toString() : null;
    existingDeliveryNotes = json['existing_delivery_notes'] != null ? json['existing_delivery_notes'].toString() : null;
    subsId = json['subs_id'] != null ? json['subs_id'].toString() : null;
    delCharge = json['del_charge'] != null ? json['del_charge'].toString() : null;
    rxCharge = json['rx_charge'] != null ? json['rx_charge'].toString() : null;
    rxInvoice = json['rx_invoice'] != null ? json['rx_invoice'].toString() : null;
    nursingHomeId = json['nursing_home_id'] != null ? json['nursing_home_id'].toString() : null;
    toteBoxId = json['tote_box_id'] != null ? json['tote_box_id'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['parcel_box_name'] = this.parcelBoxName;
    data['pharmacy_name'] = this.pharmacyName;
    data['userId'] = this.userId;
    data['pmr_type'] = this.pmrType;
    data['isCronCreated'] = this.isCronCreated;
    data['deliveryStatus'] = this.deliveryStatus;
    data['pr_id'] = this.prId;
    data['isControlledDrugs'] = this.isControlledDrugs;
    data['isStorageFridge'] = this.isStorageFridge;
    data['deliveryNotes'] = this.deliveryNotes;
    data['fullName'] = this.fullName;
    data['fullAddress'] = this.fullAddress;
    data['alt_address'] = this.altAddress;
    data['dob'] = this.dob;
    data['existing_delivery_notes'] = this.existingDeliveryNotes;
    data['subs_id'] = this.subsId;
    data['del_charge'] = this.delCharge;
    data['rx_charge'] = this.rxCharge;
    data['rx_invoice'] = this.rxInvoice;
    data['nursing_home_id'] = this.nursingHomeId;
    data['tote_box_id'] = this.toteBoxId;
    return data;
  }
}


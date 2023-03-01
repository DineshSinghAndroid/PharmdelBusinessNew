class AllDeliveryApiResponse {
  bool? status;  
  int? totalRecords;  
  String? message;
  bool? isOrderAvailable;
  List<DeliveryList>? deliveryList;
  EndRoutePoint? endRoutePoint;

  AllDeliveryApiResponse(
      {this.status,
      this.deliveryList,
      this.totalRecords,
      this.endRoutePoint,
      this.message,
      this.isOrderAvailable});

  AllDeliveryApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['deliveryList'] != null) {
      deliveryList = <DeliveryList>[];
      json['deliveryList'].forEach((v) {
        deliveryList!.add(new DeliveryList.fromJson(v));
      });
    }
    totalRecords = json['totalRecords'];
    endRoutePoint = json['endRoutePoint'] != null
        ? new EndRoutePoint.fromJson(json['endRoutePoint'])
        : null;
    message = json['message'];
    isOrderAvailable = json['isOrderAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.deliveryList != null) {
      data['deliveryList'] = this.deliveryList!.map((v) => v.toJson()).toList();
    }
    data['totalRecords'] = this.totalRecords;
    if (this.endRoutePoint != null) {
      data['endRoutePoint'] = this.endRoutePoint!.toJson();
    }
    data['message'] = this.message;
    data['isOrderAvailable'] = this.isOrderAvailable;
    return data;
  }
}

class DeliveryList {
  int? orderId;
  String? prId;
  String? pmrType;
  int? deliveryId;
  String? status;
  int? deliveryStatus;
  String? deliveryDate;
  int? companyId;
  int? branchId;
  int? routeId;
  String? isCronCreated;
  CustomerDetials? customerDetials;

  DeliveryList(
      {this.orderId,
      this.prId,
      this.pmrType,
      this.deliveryId,
      this.status,
      this.deliveryStatus,
      this.deliveryDate,
      this.companyId,
      this.branchId,
      this.routeId,
      this.isCronCreated,
      this.customerDetials});

  DeliveryList.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    prId = json['pr_id'];
    pmrType = json['pmr_type'];
    deliveryId = json['deliveryId'];
    status = json['status'];
    deliveryStatus = json['delivery_status'];
    deliveryDate = json['deliveryDate'];
    companyId = json['companyId'];
    branchId = json['branchId'];
    routeId = json['routeId'];
    isCronCreated = json['isCronCreated'];
    customerDetials = json['customerDetials'] != null
        ? new CustomerDetials.fromJson(json['customerDetials'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['pr_id'] = this.prId;
    data['pmr_type'] = this.pmrType;
    data['deliveryId'] = this.deliveryId;
    data['status'] = this.status;
    data['delivery_status'] = this.deliveryStatus;
    data['deliveryDate'] = this.deliveryDate;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['routeId'] = this.routeId;
    data['isCronCreated'] = this.isCronCreated;
    if (this.customerDetials != null) {
      data['customerDetials'] = this.customerDetials!.toJson();
    }
    return data;
  }
}

class CustomerDetials {
  int? customerId;
  int? addressId;
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
  int? isActive;
  int? doctorId;
  String? surgeryId;
  String? surgeryEmail;
  String? surgeryMobile;
  String? paymentExemption;
  String? deliveryNote;
  String? branchNote;
  String? surgeryNote;
  String? orders;
  String? surgeries;
  String? paymentExemptions;
  String? customerDocuments;
  String? preferredContactNumber;
  String? companyId;
  String? branchId;
  String? surgeryName;
  int? rating;
  String? fullName;
  String? fullAddress;
  int? totalCount;
  int? rowNum;
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
  int? createdBy;
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
  String? address;
  bool? showValidationMsg;
  String? token;
  String? taskStatusList;
  String? isApproved;
  String? title;

  CustomerDetials(
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
      this.address,
      this.showValidationMsg,
      this.token,
      this.taskStatusList,
      this.isApproved,
      this.title});

  CustomerDetials.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    addressId = json['addressId'];
    nhsNumber = json['nhsNumber'];
    oldNhsNumber = json['oldNhsNumber'];
    inputDob = json['inputDob'];
    dob = json['dob'];
    lastOrderDate = json['lastOrderDate'];
    upcomingDeliveryDate = json['upcomingDeliveryDate'];
    reminderDate = json['reminderDate'];
    deliveryDate = json['deliveryDate'];
    pickupTypeId = json['pickupTypeId'];
    pickupType = json['pickupType'];
    routeId = json['routeId'];
    isActive = json['isActive'];
    doctorId = json['doctorId'];
    surgeryId = json['surgeryId'];
    surgeryEmail = json['surgeryEmail'];
    surgeryMobile = json['surgeryMobile'];
    paymentExemption = json['paymentExemption'];
    deliveryNote = json['deliveryNote'];
    branchNote = json['branchNote'];
    surgeryNote = json['surgeryNote'];
    orders = json['orders'];
    surgeries = json['surgeries'];
    paymentExemptions = json['paymentExemptions'];
    customerDocuments = json['customerDocuments'];
    preferredContactNumber = json['preferredContactNumber'];
    companyId = json['companyId'];
    branchId = json['branchId'];
    surgeryName = json['surgeryName'];
    rating = json['rating'];
    fullName = json['fullName'];
    fullAddress = json['fullAddress'];
    totalCount = json['totalCount'];
    rowNum = json['rowNum'];
    routeName = json['routeName'];
    caseTypeId = json['caseTypeId'];
    paymentExemptionDesc = json['paymentExemptionDesc'];
    branchCode = json['branchCode'];
    customerAddress = json['customerAddress'] != null
        ? new CustomerAddress.fromJson(json['customerAddress'])
        : null;
    pickupTypes = json['pickupTypes'];
    states = json['states'];
    countries = json['countries'];
    routes = json['routes'];
    products = json['products'];
    intervals = json['intervals'];
    orderStatusList = json['orderStatusList'];
    deliveryStatusList = json['deliveryStatusList'];
    deliveryTypes = json['deliveryTypes'];
    storages = json['storages'];
    statusList = json['statusList'];
    preferredContactTypes = json['preferredContactTypes'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    oldMobile = json['oldMobile'];
    email = json['email'];
    oldEmail = json['oldEmail'];
    landlineNumber = json['landlineNumber'];
    alternativeContact = json['alternativeContact'];
    dependentContactNumber = json['dependentContactNumber'];
    contactPerson = json['contactPerson'];
    countryName = json['countryName'];
    gender = json['gender'];
    title = json['title'];
    address = json['address'];
    showValidationMsg = json['showValidationMsg'];
    token = json['token'];
    taskStatusList = json['taskStatusList'];
    isApproved = json['isApproved'];    
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
    data['address'] = this.address;
    data['showValidationMsg'] = this.showValidationMsg;
    data['token'] = this.token;
    data['taskStatusList'] = this.taskStatusList;
    data['isApproved'] = this.isApproved;
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
  int? stateId;
  int? countryId;
  String? postCode;
  String? oldPostCode;
  String? contacts;
  String? countryName;
  Null? preferredContactType;
  String? stateName;
  double? latitude;
  double? longitude;
  String? duration;

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
      this.duration});

  CustomerAddress.fromJson(Map<String, dynamic> json) {
    altAddress = json['alt_address'];
    address1 = json['address1'];
    oldAddress1 = json['oldAddress1'];
    address2 = json['address2'];
    oldAddress2 = json['oldAddress2'];
    city = json['city'];
    stateId = json['stateId'];
    countryId = json['countryId'];
    postCode = json['postCode'];
    oldPostCode = json['oldPostCode'];
    contacts = json['contacts'];
    countryName = json['countryName'];
    preferredContactType = json['preferredContactType'];
    stateName = json['stateName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    duration = json['duration'];
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
    return data;
  }
}

class EndRoutePoint {
  double? startLat;
  double? startLng;
  double? endLat;
  double? endLng;
  String? driverName;
  String? driverAddress;
  String? pharmacyName;
  String? pharmacyAddress;
  String? endroutetype;
  String? endRouteAddress;

  EndRoutePoint(
      {this.startLat,
      this.startLng,
      this.endLat,
      this.endLng,
      this.driverName,
      this.driverAddress,
      this.pharmacyName,
      this.pharmacyAddress,
      this.endroutetype,
      this.endRouteAddress});

  EndRoutePoint.fromJson(Map<String, dynamic> json) {
    startLat = json['start_lat'];
    startLng = json['start_lng'];
    endLat = json['end_lat'];
    endLng = json['end_lng'];
    driverName = json['driver_name'];
    driverAddress = json['driver_address'];
    pharmacyName = json['pharmacy_name'];
    pharmacyAddress = json['pharmacy_address'];
    endroutetype = json['endroutetype'];
    endRouteAddress = json['end_route_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_lat'] = this.startLat;
    data['start_lng'] = this.startLng;
    data['end_lat'] = this.endLat;
    data['end_lng'] = this.endLng;
    data['driver_name'] = this.driverName;
    data['driver_address'] = this.driverAddress;
    data['pharmacy_name'] = this.pharmacyName;
    data['pharmacy_address'] = this.pharmacyAddress;
    data['endroutetype'] = this.endroutetype;
    data['end_route_address'] = this.endRouteAddress;
    return data;
  }
}

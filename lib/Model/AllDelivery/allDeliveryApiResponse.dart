import '../DriverDashboard/driver_dashboard_response.dart';

class AllDeliveryApiResponse {
  bool? status;  
  int? totalRecords;  
  String? message;
  bool? isOrderAvailable;
  List<DeliveryPojoModal>? deliveryList;
  MapEndRoutePoint? endRoutePoint;

  AllDeliveryApiResponse(
      {this.status,
      this.deliveryList,
      this.totalRecords,
      this.endRoutePoint,
      this.message,
      this.isOrderAvailable});

  AllDeliveryApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null && json['status'].toString().toLowerCase() == "true" ? true:false;
    if (json['deliveryList'] != null) {
      deliveryList = <DeliveryPojoModal>[];
      json['deliveryList'].forEach((v) {
        deliveryList!.add(new DeliveryPojoModal.fromJson(v));
      });
    }
    totalRecords = json['totalRecords'] != null ? int.parse(json['totalRecords'].toString()) : null;
    endRoutePoint = json['endRoutePoint'] != null
        ? new MapEndRoutePoint.fromJson(json['endRoutePoint'])
        : null;
    message = json['message'] != null ? json['message'].toString():null;
    isOrderAvailable = json['isOrderAvailable'] != null && json['isOrderAvailable'].toString().toLowerCase() == "true" ? true:false;
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

// class MapDeliveryList {
//   String? orderId;
//   String? prId;
//   String? pmrType;
//   String? deliveryId;
//   String? status;
//   String? deliveryStatus;
//   String? deliveryDate;
//   String? companyId;
//   String? branchId;
//   String? routeId;
//   String? isCronCreated;
//   MapCustomerDetials? customerDetials;
//
//   MapDeliveryList(
//       {this.orderId,
//       this.prId,
//       this.pmrType,
//       this.deliveryId,
//       this.status,
//       this.deliveryStatus,
//       this.deliveryDate,
//       this.companyId,
//       this.branchId,
//       this.routeId,
//       this.isCronCreated,
//       this.customerDetials});
//
//   MapDeliveryList.fromJson(Map<String, dynamic> json) {
//     orderId = json['orderId'] != null ? json['orderId'].toString():null;
//     prId = json['pr_id'] != null ? json['pr_id'].toString():null;
//     pmrType = json['pmr_type'] != null ? json['pmr_type'].toString():null;
//     deliveryId = json['deliveryId'] != null ? json['deliveryId'].toString():null;
//     status = json['status'] != null ? json['status'].toString():null;
//     deliveryStatus = json['delivery_status'] != null ? json['delivery_status'].toString():null;
//     deliveryDate = json['deliveryDate'] != null ? json['deliveryDate'].toString():null;
//     companyId = json['companyId'] != null ? json['companyId'].toString():null;
//     branchId = json['branchId'] != null ? json['branchId'].toString():null;
//     routeId = json['routeId'] != null ? json['routeId'].toString():null;
//     isCronCreated = json['isCronCreated'] != null ? json['isCronCreated'].toString():null;
//     customerDetials = json['customerDetials'] != null
//         ? new MapCustomerDetials.fromJson(json['customerDetials'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['orderId'] = this.orderId;
//     data['pr_id'] = this.prId;
//     data['pmr_type'] = this.pmrType;
//     data['deliveryId'] = this.deliveryId;
//     data['status'] = this.status;
//     data['delivery_status'] = this.deliveryStatus;
//     data['deliveryDate'] = this.deliveryDate;
//     data['companyId'] = this.companyId;
//     data['branchId'] = this.branchId;
//     data['routeId'] = this.routeId;
//     data['isCronCreated'] = this.isCronCreated;
//     if (this.customerDetials != null) {
//       data['customerDetials'] = this.customerDetials!.toJson();
//     }
//     return data;
//   }
// }
//
// class MapCustomerDetials {
//   String? customerId;
//   String? addressId;
//   String? nhsNumber;
//   String? oldNhsNumber;
//   String? inputDob;
//   String? dob;
//   String? lastOrderDate;
//   String? upcomingDeliveryDate;
//   String? reminderDate;
//   String? deliveryDate;
//   String? pickupTypeId;
//   String? pickupType;
//   String? routeId;
//   String? isActive;
//   String? doctorId;
//   String? surgeryId;
//   String? surgeryEmail;
//   String? surgeryMobile;
//   String? paymentExemption;
//   String? deliveryNote;
//   String? branchNote;
//   String? surgeryNote;
//   String? orders;
//   String? surgeries;
//   String? paymentExemptions;
//   String? customerDocuments;
//   String? preferredContactNumber;
//   String? companyId;
//   String? branchId;
//   String? surgeryName;
//   String? rating;
//   String? fullName;
//   String? fullAddress;
//   String? totalCount;
//   String? rowNum;
//   String? routeName;
//   String? caseTypeId;
//   String? paymentExemptionDesc;
//   String? branchCode;
//   MapCustomerAddress? customerAddress;
//   String? pickupTypes;
//   String? states;
//   String? countries;
//   String? routes;
//   String? products;
//   String? intervals;
//   String? orderStatusList;
//   String? deliveryStatusList;
//   String? deliveryTypes;
//   String? storages;
//   String? statusList;
//   String? preferredContactTypes;
//   String? createdBy;
//   String? createdOn;
//   String? modifiedBy;
//   String? modifiedOn;
//   String? firstName;
//   String? middleName;
//   String? lastName;
//   String? mobile;
//   String? oldMobile;
//   String? email;
//   String? oldEmail;
//   String? landlineNumber;
//   String? alternativeContact;
//   String? dependentContactNumber;
//   String? contactPerson;
//   String? countryName;
//   String? gender;
//   String? address;
//   bool? showValidationMsg;
//   String? token;
//   String? taskStatusList;
//   String? isApproved;
//   String? title;
//
//   MapCustomerDetials(
//       {this.customerId,
//       this.addressId,
//       this.nhsNumber,
//       this.oldNhsNumber,
//       this.inputDob,
//       this.dob,
//       this.lastOrderDate,
//       this.upcomingDeliveryDate,
//       this.reminderDate,
//       this.deliveryDate,
//       this.pickupTypeId,
//       this.pickupType,
//       this.routeId,
//       this.isActive,
//       this.doctorId,
//       this.surgeryId,
//       this.surgeryEmail,
//       this.surgeryMobile,
//       this.paymentExemption,
//       this.deliveryNote,
//       this.branchNote,
//       this.surgeryNote,
//       this.orders,
//       this.surgeries,
//       this.paymentExemptions,
//       this.customerDocuments,
//       this.preferredContactNumber,
//       this.companyId,
//       this.branchId,
//       this.surgeryName,
//       this.rating,
//       this.fullName,
//       this.fullAddress,
//       this.totalCount,
//       this.rowNum,
//       this.routeName,
//       this.caseTypeId,
//       this.paymentExemptionDesc,
//       this.branchCode,
//       this.customerAddress,
//       this.pickupTypes,
//       this.states,
//       this.countries,
//       this.routes,
//       this.products,
//       this.intervals,
//       this.orderStatusList,
//       this.deliveryStatusList,
//       this.deliveryTypes,
//       this.storages,
//       this.statusList,
//       this.preferredContactTypes,
//       this.createdBy,
//       this.createdOn,
//       this.modifiedBy,
//       this.modifiedOn,
//       this.firstName,
//       this.middleName,
//       this.lastName,
//       this.mobile,
//       this.oldMobile,
//       this.email,
//       this.oldEmail,
//       this.landlineNumber,
//       this.alternativeContact,
//       this.dependentContactNumber,
//       this.contactPerson,
//       this.countryName,
//       this.gender,
//       this.address,
//       this.showValidationMsg,
//       this.token,
//       this.taskStatusList,
//       this.isApproved,
//       this.title});
//
//   MapCustomerDetials.fromJson(Map<String, dynamic> json) {
//     customerId = json['customerId'] != null ? json['customerId'].toString():null;
//     addressId = json['addressId'] != null ? json['addressId'].toString():null;
//     nhsNumber = json['nhsNumber'] != null ? json['nhsNumber'].toString():null;
//     oldNhsNumber = json['oldNhsNumber'] != null ? json['oldNhsNumber'].toString():null;
//     inputDob = json['inputDob'] != null ? json['inputDob'].toString():null;
//     dob = json['dob'] != null ? json['dob'].toString():null;
//     lastOrderDate = json['lastOrderDate'] != null ? json['lastOrderDate'].toString():null;
//     upcomingDeliveryDate = json['upcomingDeliveryDate'] != null ? json['upcomingDeliveryDate'].toString():null;
//     reminderDate = json['reminderDate'] != null ? json['reminderDate'].toString():null;
//     deliveryDate = json['deliveryDate'] != null ? json['deliveryDate'].toString():null;
//     pickupTypeId = json['pickupTypeId'] != null ? json['pickupTypeId'].toString():null;
//     pickupType = json['pickupType'] != null ? json['pickupType'].toString():null;
//     routeId = json['routeId'] != null ? json['routeId'].toString():null;
//     isActive = json['isActive'] != null ? json['isActive'].toString():null;
//     doctorId = json['doctorId'] != null ? json['doctorId'].toString():null;
//     surgeryId = json['surgeryId'] != null ? json['surgeryId'].toString():null;
//     surgeryEmail = json['surgeryEmail'] != null ? json['surgeryEmail'].toString():null;
//     surgeryMobile = json['surgeryMobile'] != null ? json['surgeryMobile'].toString():null;
//     paymentExemption = json['paymentExemption'] != null ? json['paymentExemption'].toString():null;
//     deliveryNote = json['deliveryNote'] != null ? json['deliveryNote'].toString():null;
//     branchNote = json['branchNote'] != null ? json['branchNote'].toString():null;
//     surgeryNote = json['surgeryNote'] != null ? json['surgeryNote'].toString():null;
//     orders = json['orders'] != null ? json['orders'].toString():null;
//     surgeries = json['surgeries'] != null ? json['surgeries'].toString():null;
//     paymentExemptions = json['paymentExemptions'] != null ? json['paymentExemptions'].toString():null;
//     customerDocuments = json['customerDocuments'] != null ? json['customerDocuments'].toString():null;
//     preferredContactNumber = json['preferredContactNumber'] != null ? json['preferredContactNumber'].toString():null;
//     companyId = json['companyId'] != null ? json['companyId'].toString():null;
//     branchId = json['branchId'] != null ? json['branchId'].toString():null;
//     surgeryName = json['surgeryName'] != null ? json['surgeryName'].toString():null;
//     rating = json['rating'] != null ? json['rating'].toString():null;
//     fullName = json['fullName'] != null ? json['fullName'].toString():null;
//     fullAddress = json['fullAddress'] != null ? json['fullAddress'].toString():null;
//     totalCount = json['totalCount'] != null ? json['totalCount'].toString():null;
//     rowNum = json['rowNum'] != null ? json['rowNum'].toString():null;
//     routeName = json['routeName'] != null ? json['routeName'].toString():null;
//     caseTypeId = json['caseTypeId'] != null ? json['caseTypeId'].toString():null;
//     paymentExemptionDesc = json['paymentExemptionDesc'] != null ? json['paymentExemptionDesc'].toString():null;
//     branchCode = json['branchCode'] != null ? json['branchCode'].toString():null;
//     customerAddress = json['customerAddress'] != null
//         ? new MapCustomerAddress.fromJson(json['customerAddress'])
//         : null;
//     pickupTypes = json['pickupTypes'] != null ? json['pickupTypes'].toString():null;
//     states = json['states'] != null ? json['states'].toString():null;
//     countries = json['countries'] != null ? json['countries'].toString():null;
//     routes = json['routes'] != null ? json['routes'].toString():null;
//     products = json['products'] != null ? json['products'].toString():null;
//     intervals = json['intervals'] != null ? json['intervals'].toString():null;
//     orderStatusList = json['orderStatusList'] != null ? json['orderStatusList'].toString():null;
//     deliveryStatusList = json['deliveryStatusList'] != null ? json['deliveryStatusList'].toString():null;
//     deliveryTypes = json['deliveryTypes'] != null ? json['deliveryTypes'].toString():null;
//     storages = json['storages'] != null ? json['storages'].toString():null;
//     statusList = json['statusList'] != null ? json['statusList'].toString():null;
//     preferredContactTypes = json['preferredContactTypes'] != null ? json['preferredContactTypes'].toString():null;
//     createdBy = json['createdBy'] != null ? json['createdBy'].toString():null;
//     createdOn = json['createdOn'] != null ? json['createdOn'].toString():null;
//     modifiedBy = json['modifiedBy'] != null ? json['modifiedBy'].toString():null;
//     modifiedOn = json['modifiedOn'] != null ? json['modifiedOn'].toString():null;
//     firstName = json['firstName'] != null ? json['firstName'].toString():null;
//     middleName = json['middleName'] != null ? json['middleName'].toString():null;
//     lastName = json['lastName'] != null ? json['lastName'].toString():null;
//     mobile = json['mobile'] != null ? json['mobile'].toString():null;
//     oldMobile = json['oldMobile'] != null ? json['oldMobile'].toString():null;
//     email = json['email'] != null ? json['email'].toString():null;
//     oldEmail = json['oldEmail'] != null ? json['oldEmail'].toString():null;
//     landlineNumber = json['landlineNumber'] != null ? json['landlineNumber'].toString():null;
//     alternativeContact = json['alternativeContact'] != null ? json['alternativeContact'].toString():null;
//     dependentContactNumber = json['dependentContactNumber'] != null ? json['dependentContactNumber'].toString():null;
//     contactPerson = json['contactPerson'] != null ? json['contactPerson'].toString():null;
//     countryName = json['countryName'] != null ? json['countryName'].toString():null;
//     gender = json['gender'] != null ? json['gender'].toString():null;
//     title = json['title'] != null ? json['title'].toString():null;
//     address = json['address'] != null ? json['address'].toString():null;
//     showValidationMsg = json['showValidationMsg'] != null && json['showValidationMsg'].toString().toLowerCase()=="true" ? true:false;
//     token = json['token'] != null ? json['token'].toString():null;
//     taskStatusList = json['taskStatusList'] != null ? json['taskStatusList'].toString():null;
//     isApproved = json['isApproved'] != null ? json['isApproved'].toString():null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['customerId'] = this.customerId;
//     data['addressId'] = this.addressId;
//     data['nhsNumber'] = this.nhsNumber;
//     data['oldNhsNumber'] = this.oldNhsNumber;
//     data['inputDob'] = this.inputDob;
//     data['dob'] = this.dob;
//     data['lastOrderDate'] = this.lastOrderDate;
//     data['upcomingDeliveryDate'] = this.upcomingDeliveryDate;
//     data['reminderDate'] = this.reminderDate;
//     data['deliveryDate'] = this.deliveryDate;
//     data['pickupTypeId'] = this.pickupTypeId;
//     data['pickupType'] = this.pickupType;
//     data['routeId'] = this.routeId;
//     data['isActive'] = this.isActive;
//     data['doctorId'] = this.doctorId;
//     data['surgeryId'] = this.surgeryId;
//     data['surgeryEmail'] = this.surgeryEmail;
//     data['surgeryMobile'] = this.surgeryMobile;
//     data['paymentExemption'] = this.paymentExemption;
//     data['deliveryNote'] = this.deliveryNote;
//     data['branchNote'] = this.branchNote;
//     data['surgeryNote'] = this.surgeryNote;
//     data['orders'] = this.orders;
//     data['surgeries'] = this.surgeries;
//     data['paymentExemptions'] = this.paymentExemptions;
//     data['customerDocuments'] = this.customerDocuments;
//     data['preferredContactNumber'] = this.preferredContactNumber;
//     data['companyId'] = this.companyId;
//     data['branchId'] = this.branchId;
//     data['surgeryName'] = this.surgeryName;
//     data['rating'] = this.rating;
//     data['fullName'] = this.fullName;
//     data['fullAddress'] = this.fullAddress;
//     data['totalCount'] = this.totalCount;
//     data['rowNum'] = this.rowNum;
//     data['routeName'] = this.routeName;
//     data['caseTypeId'] = this.caseTypeId;
//     data['paymentExemptionDesc'] = this.paymentExemptionDesc;
//     data['branchCode'] = this.branchCode;
//     if (this.customerAddress != null) {
//       data['customerAddress'] = this.customerAddress!.toJson();
//     }
//     data['pickupTypes'] = this.pickupTypes;
//     data['states'] = this.states;
//     data['countries'] = this.countries;
//     data['routes'] = this.routes;
//     data['products'] = this.products;
//     data['intervals'] = this.intervals;
//     data['orderStatusList'] = this.orderStatusList;
//     data['deliveryStatusList'] = this.deliveryStatusList;
//     data['deliveryTypes'] = this.deliveryTypes;
//     data['storages'] = this.storages;
//     data['statusList'] = this.statusList;
//     data['preferredContactTypes'] = this.preferredContactTypes;
//     data['createdBy'] = this.createdBy;
//     data['createdOn'] = this.createdOn;
//     data['modifiedBy'] = this.modifiedBy;
//     data['modifiedOn'] = this.modifiedOn;
//     data['firstName'] = this.firstName;
//     data['middleName'] = this.middleName;
//     data['lastName'] = this.lastName;
//     data['mobile'] = this.mobile;
//     data['oldMobile'] = this.oldMobile;
//     data['email'] = this.email;
//     data['oldEmail'] = this.oldEmail;
//     data['landlineNumber'] = this.landlineNumber;
//     data['alternativeContact'] = this.alternativeContact;
//     data['dependentContactNumber'] = this.dependentContactNumber;
//     data['contactPerson'] = this.contactPerson;
//     data['countryName'] = this.countryName;
//     data['gender'] = this.gender;
//     data['title'] = this.title;
//     data['address'] = this.address;
//     data['showValidationMsg'] = this.showValidationMsg;
//     data['token'] = this.token;
//     data['taskStatusList'] = this.taskStatusList;
//     data['isApproved'] = this.isApproved;
//     return data;
//   }
// }
//
// class MapCustomerAddress {
//   String? altAddress;
//   String? address1;
//   String? oldAddress1;
//   String? address2;
//   String? oldAddress2;
//   String? city;
//   String? stateId;
//   String? countryId;
//   String? postCode;
//   String? oldPostCode;
//   String? contacts;
//   String? countryName;
//   String? preferredContactType;
//   String? stateName;
//   String? latitude;
//   String? longitude;
//   String? duration;
//
//   MapCustomerAddress(
//       {this.altAddress,
//       this.address1,
//       this.oldAddress1,
//       this.address2,
//       this.oldAddress2,
//       this.city,
//       this.stateId,
//       this.countryId,
//       this.postCode,
//       this.oldPostCode,
//       this.contacts,
//       this.countryName,
//       this.preferredContactType,
//       this.stateName,
//       this.latitude,
//       this.longitude,
//       this.duration});
//
//   MapCustomerAddress.fromJson(Map<String, dynamic> json) {
//     altAddress = json['alt_address'] != null ? json['alt_address'].toString():null;
//     address1 = json['address1'] != null ? json['address1'].toString():null;
//     oldAddress1 = json['oldAddress1'] != null ? json['oldAddress1'].toString():null;
//     address2 = json['address2'] != null ? json['address2'].toString():null;
//     oldAddress2 = json['oldAddress2'] != null ? json['oldAddress2'].toString():null;
//     city = json['city'] != null ? json['city'].toString():null;
//     stateId = json['stateId'] != null ? json['stateId'].toString():null;
//     countryId = json['countryId'] != null ? json['countryId'].toString():null;
//     postCode = json['postCode'] != null ? json['postCode'].toString():null;
//     oldPostCode = json['oldPostCode'] != null ? json['oldPostCode'].toString():null;
//     contacts = json['contacts'] != null ? json['contacts'].toString():null;
//     countryName = json['countryName'] != null ? json['countryName'].toString():null;
//     preferredContactType = json['preferredContactType'] != null ? json['preferredContactType'].toString():null;
//     stateName = json['stateName'] != null ? json['stateName'].toString():null;
//     latitude = json['latitude'] != null ? json['latitude'].toString():null;
//     longitude = json['longitude'] != null ? json['longitude'].toString():null;
//     duration = json['duration'] != null ? json['duration'].toString():null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['alt_address'] = this.altAddress;
//     data['address1'] = this.address1;
//     data['oldAddress1'] = this.oldAddress1;
//     data['address2'] = this.address2;
//     data['oldAddress2'] = this.oldAddress2;
//     data['city'] = this.city;
//     data['stateId'] = this.stateId;
//     data['countryId'] = this.countryId;
//     data['postCode'] = this.postCode;
//     data['oldPostCode'] = this.oldPostCode;
//     data['contacts'] = this.contacts;
//     data['countryName'] = this.countryName;
//     data['preferredContactType'] = this.preferredContactType;
//     data['stateName'] = this.stateName;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['duration'] = this.duration;
//     return data;
//   }
// }

class MapEndRoutePoint {
  String? startLat;
  String? startLng;
  String? endLat;
  String? endLng;
  String? driverName;
  String? driverAddress;
  String? pharmacyName;
  String? pharmacyAddress;
  String? endroutetype;
  String? endRouteAddress;

  MapEndRoutePoint(
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

  MapEndRoutePoint.fromJson(Map<String, dynamic> json) {
    startLat = json['start_lat'] != null ? json['start_lat'].toString():null;
    startLng = json['start_lng'] != null ? json['start_lng'].toString():null;
    endLat = json['end_lat'] != null ? json['end_lat'].toString():null;
    endLng = json['end_lng'] != null ? json['end_lng'].toString():null;
    driverName = json['driver_name'] != null ? json['driver_name'].toString():null;
    driverAddress = json['driver_address'] != null ? json['driver_address'].toString():null;
    pharmacyName = json['pharmacy_name'] != null ? json['pharmacy_name'].toString():null;
    pharmacyAddress = json['pharmacy_address'] != null ? json['pharmacy_address'].toString():null;
    endroutetype = json['endroutetype'] != null ? json['endroutetype'].toString():null;
    endRouteAddress = json['end_route_address'] != null ? json['end_route_address'].toString():null;
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

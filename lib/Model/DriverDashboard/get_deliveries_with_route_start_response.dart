// class GetDeliveriesWithRouteStartResponse {
//   List<DeliveryList>? deliveryList;
//   bool? status;
//   int? pageNumber;
//   int? pageSize;
//   int? totalRecords;
//   OrderCounts? orderCounts;
//   bool? isStart;
//   String? systemTime;
//   String? message;
//   bool? isOrderAvailable;
//
//   GetDeliveriesWithRouteStartResponse(
//       {this.deliveryList,
//         this.status,
//         this.pageNumber,
//         this.pageSize,
//         this.totalRecords,
//         this.orderCounts,
//         this.isStart,
//         this.systemTime,
//         this.message,
//         this.isOrderAvailable});
//
//   GetDeliveriesWithRouteStartResponse.fromJson(Map<String, dynamic> json) {
//     if (json['deliveryList'] != null) {
//       deliveryList = <DeliveryList>[];
//       json['deliveryList'].forEach((v) {
//         deliveryList!.add(new DeliveryList.fromJson(v));
//       });
//     }
//     status = json['status'];
//     pageNumber = json['pageNumber'];
//     pageSize = json['pageSize'];
//     totalRecords = json['totalRecords'];
//     orderCounts = json['orderCounts'] != null
//         ? new OrderCounts.fromJson(json['orderCounts'])
//         : null;
//     isStart = json['isStart'];
//     systemTime = json['system_time'];
//     message = json['message'];
//     isOrderAvailable = json['isOrderAvailable'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.deliveryList != null) {
//       data['deliveryList'] = this.deliveryList!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = this.status;
//     data['pageNumber'] = this.pageNumber;
//     data['pageSize'] = this.pageSize;
//     data['totalRecords'] = this.totalRecords;
//     if (this.orderCounts != null) {
//       data['orderCounts'] = this.orderCounts!.toJson();
//     }
//     data['isStart'] = this.isStart;
//     data['system_time'] = this.systemTime;
//     data['message'] = this.message;
//     data['isOrderAvailable'] = this.isOrderAvailable;
//     return data;
//   }
// }
//
// class DeliveryList {
//   int? orderId;
//   String? parcelBoxName;
//   Null? sortBy;
//   String? pharmacyName;
//   int? pharmacyId;
//   int? isDelCharge;
//   int? isPresCharge;
//   Null? prId;
//   String? pmrType;
//   int? deliveryId;
//   String? status;
//   String? deliveryDate;
//   int? companyId;
//   int? branchId;
//   int? routeId;
//   String? isCronCreated;
//   CustomerDetials? customerDetials;
//   Null? exemption;
//   String? paymentStatus;
//   Null? bagSize;
//   String? serviceName;
//   String? isStorageFridge;
//   String? isControlledDrugs;
//   String? deliveryNotes;
//   String? existingDeliveryNotes;
//   Null? subsId;
//   Null? delCharge;
//   Null? rxCharge;
//   Null? rxInvoice;
//   int? totalStorageFridge;
//   int? totalControlledDrugs;
//   int? nursingHomeId;
//   int? toteBoxId;
//
//   DeliveryList(
//       {this.orderId,
//         this.parcelBoxName,
//         this.sortBy,
//         this.pharmacyName,
//         this.pharmacyId,
//         this.isDelCharge,
//         this.isPresCharge,
//         this.prId,
//         this.pmrType,
//         this.deliveryId,
//         this.status,
//         this.deliveryDate,
//         this.companyId,
//         this.branchId,
//         this.routeId,
//         this.isCronCreated,
//         this.customerDetials,
//         this.exemption,
//         this.paymentStatus,
//         this.bagSize,
//         this.serviceName,
//         this.isStorageFridge,
//         this.isControlledDrugs,
//         this.deliveryNotes,
//         this.existingDeliveryNotes,
//         this.subsId,
//         this.delCharge,
//         this.rxCharge,
//         this.rxInvoice,
//         this.totalStorageFridge,
//         this.totalControlledDrugs,
//         this.nursingHomeId,
//         this.toteBoxId});
//
//   DeliveryList.fromJson(Map<String, dynamic> json) {
//     orderId = json['orderId'];
//     parcelBoxName = json['parcel_box_name'];
//     sortBy = json['sort_by'];
//     pharmacyName = json['pharmacy_name'];
//     pharmacyId = json['pharmacy_id'];
//     isDelCharge = json['is_del_charge'];
//     isPresCharge = json['is_pres_charge'];
//     prId = json['pr_id'];
//     pmrType = json['pmr_type'];
//     deliveryId = json['deliveryId'];
//     status = json['status'];
//     deliveryDate = json['deliveryDate'];
//     companyId = json['companyId'];
//     branchId = json['branchId'];
//     routeId = json['routeId'];
//     isCronCreated = json['isCronCreated'];
//     customerDetials = json['customerDetials'] != null
//         ? new CustomerDetials.fromJson(json['customerDetials'])
//         : null;
//     exemption = json['exemption'];
//     paymentStatus = json['paymentStatus'];
//     bagSize = json['bagSize'];
//     serviceName = json['serviceName'];
//     isStorageFridge = json['isStorageFridge'];
//     isControlledDrugs = json['isControlledDrugs'];
//     deliveryNotes = json['deliveryNotes'];
//     existingDeliveryNotes = json['existingDeliveryNotes'];
//     subsId = json['subs_id'];
//     delCharge = json['del_charge'];
//     rxCharge = json['rx_charge'];
//     rxInvoice = json['rx_invoice'];
//     totalStorageFridge = json['totalStorageFridge'];
//     totalControlledDrugs = json['totalControlledDrugs'];
//     nursingHomeId = json['nursing_home_id'];
//     toteBoxId = json['tote_box_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['orderId'] = this.orderId;
//     data['parcel_box_name'] = this.parcelBoxName;
//     data['sort_by'] = this.sortBy;
//     data['pharmacy_name'] = this.pharmacyName;
//     data['pharmacy_id'] = this.pharmacyId;
//     data['is_del_charge'] = this.isDelCharge;
//     data['is_pres_charge'] = this.isPresCharge;
//     data['pr_id'] = this.prId;
//     data['pmr_type'] = this.pmrType;
//     data['deliveryId'] = this.deliveryId;
//     data['status'] = this.status;
//     data['deliveryDate'] = this.deliveryDate;
//     data['companyId'] = this.companyId;
//     data['branchId'] = this.branchId;
//     data['routeId'] = this.routeId;
//     data['isCronCreated'] = this.isCronCreated;
//     if (this.customerDetials != null) {
//       data['customerDetials'] = this.customerDetials!.toJson();
//     }
//     data['exemption'] = this.exemption;
//     data['paymentStatus'] = this.paymentStatus;
//     data['bagSize'] = this.bagSize;
//     data['serviceName'] = this.serviceName;
//     data['isStorageFridge'] = this.isStorageFridge;
//     data['isControlledDrugs'] = this.isControlledDrugs;
//     data['deliveryNotes'] = this.deliveryNotes;
//     data['existingDeliveryNotes'] = this.existingDeliveryNotes;
//     data['subs_id'] = this.subsId;
//     data['del_charge'] = this.delCharge;
//     data['rx_charge'] = this.rxCharge;
//     data['rx_invoice'] = this.rxInvoice;
//     data['totalStorageFridge'] = this.totalStorageFridge;
//     data['totalControlledDrugs'] = this.totalControlledDrugs;
//     data['nursing_home_id'] = this.nursingHomeId;
//     data['tote_box_id'] = this.toteBoxId;
//     return data;
//   }
// }
//
// class CustomerDetials {
//   int? customerId;
//   int? addressId;
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
//   int? isActive;
//   int? doctorId;
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
//   int? rating;
//   String? fullName;
//   String? fullAddress;
//   int? totalCount;
//   int? rowNum;
//   String? routeName;
//   String? caseTypeId;
//   String? paymentExemptionDesc;
//   String? branchCode;
//   CustomerAddress? customerAddress;
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
//   int? createdBy;
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
//   String? title;
//   String? address;
//   bool? showValidationMsg;
//   String? token;
//   String? taskStatusList;
//   String? isApproved;
//   // String? title;
//
//   CustomerDetials(
//       {this.customerId,
//         this.addressId,
//         this.nhsNumber,
//         this.oldNhsNumber,
//         this.inputDob,
//         this.dob,
//         this.lastOrderDate,
//         this.upcomingDeliveryDate,
//         this.reminderDate,
//         this.deliveryDate,
//         this.pickupTypeId,
//         this.pickupType,
//         this.routeId,
//         this.isActive,
//         this.doctorId,
//         this.surgeryId,
//         this.surgeryEmail,
//         this.surgeryMobile,
//         this.paymentExemption,
//         this.deliveryNote,
//         this.branchNote,
//         this.surgeryNote,
//         this.orders,
//         this.surgeries,
//         this.paymentExemptions,
//         this.customerDocuments,
//         this.preferredContactNumber,
//         this.companyId,
//         this.branchId,
//         this.surgeryName,
//         this.rating,
//         this.fullName,
//         this.fullAddress,
//         this.totalCount,
//         this.rowNum,
//         this.routeName,
//         this.caseTypeId,
//         this.paymentExemptionDesc,
//         this.branchCode,
//         this.customerAddress,
//         this.pickupTypes,
//         this.states,
//         this.countries,
//         this.routes,
//         this.products,
//         this.intervals,
//         this.orderStatusList,
//         this.deliveryStatusList,
//         this.deliveryTypes,
//         this.storages,
//         this.statusList,
//         this.preferredContactTypes,
//         this.createdBy,
//         this.createdOn,
//         this.modifiedBy,
//         this.modifiedOn,
//         this.firstName,
//         this.middleName,
//         this.lastName,
//         this.mobile,
//         this.oldMobile,
//         this.email,
//         this.oldEmail,
//         this.landlineNumber,
//         this.alternativeContact,
//         this.dependentContactNumber,
//         this.contactPerson,
//         this.countryName,
//         this.gender,
//         this.title,
//         this.address,
//         this.showValidationMsg,
//         this.token,
//         this.taskStatusList,
//         this.isApproved,
//         // this.title
//       });
//
//   CustomerDetials.fromJson(Map<String, dynamic> json) {
//     customerId = json['customerId'];
//     addressId = json['addressId'];
//     nhsNumber = json['nhsNumber'];
//     oldNhsNumber = json['oldNhsNumber'];
//     inputDob = json['inputDob'];
//     dob = json['dob'];
//     lastOrderDate = json['lastOrderDate'];
//     upcomingDeliveryDate = json['upcomingDeliveryDate'];
//     reminderDate = json['reminderDate'];
//     deliveryDate = json['deliveryDate'];
//     pickupTypeId = json['pickupTypeId'];
//     pickupType = json['pickupType'];
//     routeId = json['routeId'];
//     isActive = json['isActive'];
//     doctorId = json['doctorId'];
//     surgeryId = json['surgeryId'];
//     surgeryEmail = json['surgeryEmail'];
//     surgeryMobile = json['surgeryMobile'];
//     paymentExemption = json['paymentExemption'];
//     deliveryNote = json['deliveryNote'];
//     branchNote = json['branchNote'];
//     surgeryNote = json['surgeryNote'];
//     orders = json['orders'];
//     surgeries = json['surgeries'];
//     paymentExemptions = json['paymentExemptions'];
//     customerDocuments = json['customerDocuments'];
//     preferredContactNumber = json['preferredContactNumber'];
//     companyId = json['companyId'];
//     branchId = json['branchId'];
//     surgeryName = json['surgeryName'];
//     rating = json['rating'];
//     fullName = json['fullName'];
//     fullAddress = json['fullAddress'];
//     totalCount = json['totalCount'];
//     rowNum = json['rowNum'];
//     routeName = json['routeName'];
//     caseTypeId = json['caseTypeId'];
//     paymentExemptionDesc = json['paymentExemptionDesc'];
//     branchCode = json['branchCode'];
//     customerAddress = json['customerAddress'] != null
//         ? new CustomerAddress.fromJson(json['customerAddress'])
//         : null;
//     pickupTypes = json['pickupTypes'];
//     states = json['states'];
//     countries = json['countries'];
//     routes = json['routes'];
//     products = json['products'];
//     intervals = json['intervals'];
//     orderStatusList = json['orderStatusList'];
//     deliveryStatusList = json['deliveryStatusList'];
//     deliveryTypes = json['deliveryTypes'];
//     storages = json['storages'];
//     statusList = json['statusList'];
//     preferredContactTypes = json['preferredContactTypes'];
//     createdBy = json['createdBy'];
//     createdOn = json['createdOn'];
//     modifiedBy = json['modifiedBy'];
//     modifiedOn = json['modifiedOn'];
//     firstName = json['firstName'];
//     middleName = json['middleName'];
//     lastName = json['lastName'];
//     mobile = json['mobile'];
//     oldMobile = json['oldMobile'];
//     email = json['email'];
//     oldEmail = json['oldEmail'];
//     landlineNumber = json['landlineNumber'];
//     alternativeContact = json['alternativeContact'];
//     dependentContactNumber = json['dependentContactNumber'];
//     contactPerson = json['contactPerson'];
//     countryName = json['countryName'];
//     gender = json['gender'];
//     title = json['title'];
//     address = json['address'];
//     showValidationMsg = json['showValidationMsg'];
//     token = json['token'];
//     taskStatusList = json['taskStatusList'];
//     isApproved = json['isApproved'];
//     title = json['Title'];
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
//     data['Title'] = this.title;
//     return data;
//   }
// }
//
// class CustomerAddress {
//   String? altAddress;
//   String? address1;
//   String? matchAddress;
//   String? oldAddress1;
//   String? address2;
//   String? oldAddress2;
//   String? city;
//   int? stateId;
//   int? countryId;
//   String? postCode;
//   String? oldPostCode;
//   String? contacts;
//   String? countryName;
//   String? preferredContactType;
//   String? stateName;
//   double? latitude;
//   double? longitude;
//   String? duration;
//   int? distance;
//
//   CustomerAddress(
//       {this.altAddress,
//         this.address1,
//         this.matchAddress,
//         this.oldAddress1,
//         this.address2,
//         this.oldAddress2,
//         this.city,
//         this.stateId,
//         this.countryId,
//         this.postCode,
//         this.oldPostCode,
//         this.contacts,
//         this.countryName,
//         this.preferredContactType,
//         this.stateName,
//         this.latitude,
//         this.longitude,
//         this.duration,
//         this.distance});
//
//   CustomerAddress.fromJson(Map<String, dynamic> json) {
//     altAddress = json['alt_address'];
//     address1 = json['address1'];
//     matchAddress = json['matchAddress'];
//     oldAddress1 = json['oldAddress1'];
//     address2 = json['address2'];
//     oldAddress2 = json['oldAddress2'];
//     city = json['city'];
//     stateId = json['stateId'];
//     countryId = json['countryId'];
//     postCode = json['postCode'];
//     oldPostCode = json['oldPostCode'];
//     contacts = json['contacts'];
//     countryName = json['countryName'];
//     preferredContactType = json['preferredContactType'];
//     stateName = json['stateName'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     duration = json['duration'];
//     distance = json['distance'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['alt_address'] = this.altAddress;
//     data['address1'] = this.address1;
//     data['matchAddress'] = this.matchAddress;
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
//     data['distance'] = this.distance;
//     return data;
//   }
// }
//
// class OrderCounts {
//   int? totalOrders;
//   int? pendingOrders;
//   int? outForDeliveryOrders;
//   int? deliveredOrders;
//   int? faildOrders;
//   int? pickedupOrders;
//   int? receviedOrders;
//   int? todayTotalOrders;
//
//   OrderCounts(
//       {this.totalOrders,
//         this.pendingOrders,
//         this.outForDeliveryOrders,
//         this.deliveredOrders,
//         this.faildOrders,
//         this.pickedupOrders,
//         this.receviedOrders,
//         this.todayTotalOrders});
//
//   OrderCounts.fromJson(Map<String, dynamic> json) {
//     totalOrders = json['totalOrders'];
//     pendingOrders = json['pendingOrders'];
//     outForDeliveryOrders = json['outForDeliveryOrders'];
//     deliveredOrders = json['deliveredOrders'];
//     faildOrders = json['faildOrders'];
//     pickedupOrders = json['pickedupOrders'];
//     receviedOrders = json['receviedOrders'];
//     todayTotalOrders = json['todayTotalOrders'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['totalOrders'] = this.totalOrders;
//     data['pendingOrders'] = this.pendingOrders;
//     data['outForDeliveryOrders'] = this.outForDeliveryOrders;
//     data['deliveredOrders'] = this.deliveredOrders;
//     data['faildOrders'] = this.faildOrders;
//     data['pickedupOrders'] = this.pickedupOrders;
//     data['receviedOrders'] = this.receviedOrders;
//     data['todayTotalOrders'] = this.todayTotalOrders;
//     return data;
//   }
// }





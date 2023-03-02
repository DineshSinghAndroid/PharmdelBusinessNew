// class DeliveryPojoResponse {
//   bool? status;    
//   String? message;
//   List<DeliveryPojoModal>? deliveryPojoList;

//   DeliveryPojoResponse(
//       {this.status,
//       this.message,});

//   DeliveryPojoResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['deliveryList'] != null) {
//       deliveryPojoList = <DeliveryPojoModal>[];
//       json['deliveryList'].forEach((v) {
//         deliveryPojoList!.add(new DeliveryPojoModal.fromJson(v));
//       });
//     }
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.deliveryPojoList != null) {
//       data['deliveryList'] = this.deliveryPojoList!.map((v) => v.toJson()).toList();
//     }    
//     return data;
//   }
// }

// class DeliveryPojoModal {
//   DeliveryPojoModal({
//     //  this.deliveryId,
//     this.orderId,
//     this.serviceName,
//     this.isStorageFridge,
//     this.isControlledDrugs,
//     this.deliveryNotes,
//     this.rescheduleDate,
//     this.sortBy,
//     this.parcelBoxName,
//     this.existingDeliveryNotes,
//     this.rxCharge,
//     this.delCharge,
//     this.rxInvoice,
//     //  this.companyId,
//     // this.branchId,
//     //  this.deliveryDate,
//     this.deliveryStatus,
//     this.pharmacyId,
//     this.isDelCharge,
//     this.routeId,
//     this.customerDetials,
//     this.status,
//     this.isCronCreated,
//     this.exemption,
//     this.paymentStatus,
//     this.bagSize,
//     this.isPresCharge,
//     this.totalStorageFridge,
//     this.totalControlledDrugs,
//     this.nursing_home_id,
//     this.pmr_type,
//     this.pr_id,
//     this.pharmacyName,
//     this.subsId,
//   });

//   int? orderId;
//   int? deliveryStatus = 0;
//   int? routeId;
//   String? isControlledDrugs;
//   int? pharmacyId;
//   int? isDelCharge;
//   int? isPresCharge;
//   String? sortBy;
//   String? isStorageFridge;
//   String? deliveryNotes;
//   String? existingDeliveryNotes;
//   dynamic rxCharge;
//   dynamic delCharge;
//   dynamic rxInvoice;
//   int? subsId;
//   int? totalControlledDrugs;
//   int? totalStorageFridge;
//   int? nursing_home_id;
//   bool? isCD = false;
//   bool? isFridge = false;
//   String? status;
//   String? rescheduleDate;
//   String? exemption;
//   String? parcelBoxName;
//   String? serviceName;
//   String? isCronCreated;
//   String? bagSize;
//   String? paymentStatus;
//   String? pmr_type;
//   String? pr_id;
//   String? pharmacyName = "test";
//   bool? isSelected = false;
//   CustomerDetials? customerDetials;

//   factory DeliveryPojoModal.fromJson(Map<String, dynamic> json) => DeliveryPojoModal(
//         orderId: json["orderId"],
//         routeId: json["routeId"] != null && json["routeId"] != "" ? int.tryParse(json["routeId"].toString()) : 0,
//         totalStorageFridge: json["totalStorageFridge"] != null && json["totalStorageFridge"] != "" ? int.tryParse(json["totalStorageFridge"].toString()) : null,
//         totalControlledDrugs: json["totalControlledDrugs"] != null && json["totalControlledDrugs"] != "" ? int.tryParse(json["totalControlledDrugs"].toString()) : null,
//         nursing_home_id: json["nursing_home_id"] != null && json["nursing_home_id"] != "" ? int.tryParse(json["nursing_home_id"].toString()) : null,
//         isControlledDrugs: json["isControlledDrugs"],
//         isStorageFridge: json["isStorageFridge"],
//         bagSize: json["bagSize"],
//         subsId: json["subs_id"],
//         pharmacyId: json["pharmacy_id"],
//         paymentStatus: json["paymentStatus"],
//         isDelCharge: json["is_del_charge"],
//         isPresCharge: json["is_pres_charge"],
//         exemption: json["exemption"],
//         parcelBoxName: json["parcel_box_name"] != null && json["parcel_box_name"].toString().isNotEmpty ? json["parcel_box_name"].toString() : "",
//         deliveryNotes: json["deliveryNotes"],
//         rescheduleDate: json["reschedule_date"],
//         existingDeliveryNotes: json["existingDeliveryNotes"],
//         rxCharge: json['rx_charge'],
//         rxInvoice: json['rx_invoice'],
//         delCharge: json['del_charge'],
//         sortBy: json["sort_by"] != null ? json["sort_by"].toString() : "",
//         deliveryStatus: json["delivery_status"],
//         serviceName: json["serviceName"],
//         isCronCreated: json["isCronCreated"],
//         pmr_type: json["pmr_type"],
//         pr_id: json["pr_id"],
//         status: json["status"],
//         pharmacyName: json["pharmacy_name"],
//         customerDetials: CustomerDetials.fromJson(json["customerDetials"]),
//       );

//   Map<String, dynamic> toJson() => {
//         //  "deliveryId": deliveryId,
//         "orderId": orderId,
//         "routeId": routeId,
//         "exemption": exemption,
//         "paymentStatus": paymentStatus,
//         "pharmacy_id": pharmacyId,
//         "is_del_charge": isDelCharge,
//         "totalControlledDrugs": totalControlledDrugs,
//         "totalStorageFridge": totalStorageFridge,
//         "nursing_home_id": nursing_home_id,
//         "is_pres_charge": isPresCharge,
//         "subs_id": subsId,
//         "bagSize": bagSize,
//         "existingDeliveryNotes": existingDeliveryNotes,
//         "rx_charge": rxCharge,
//         "rx_invoice": rxInvoice,
//         "del_charge": delCharge,
//         "reschedule_date": rescheduleDate,
//         "parcel_box_name": parcelBoxName,
//         "sort_by": sortBy,
//         "isControlledDrugs": isControlledDrugs,
//         "isStorageFridge": isStorageFridge,
//         "deliveryNotes": deliveryNotes,
//         "serviceName": serviceName,
//         "delivery_status": deliveryStatus,
//         "pmr_type": pmr_type,
//         "pr_id": pr_id,
//         "pharmacy_name": pharmacyName,
//         "isCronCreated": isCronCreated,
//         "status": status,
//         "customerDetials": customerDetials!.toJson(),
//       };
// }

// class CustomerDetials {
//   CustomerDetials({
//     this.customerId,
//     this.surgeryName,
//     this.service_name,
//     this.mobile,
//     this.customerAddress,
//     this.firstName,
//     this.middleName,
//     this.lastName,
//     this.title,
//     this.address,
//   });

//   int? customerId;
//   dynamic surgeryName;
//   dynamic service_name;
//   dynamic mobile;
//   CustomerAddress? customerAddress;
//   String? firstName;
//   dynamic middleName;
//   String? lastName;
//   dynamic title;
//   dynamic address;

//   factory CustomerDetials.fromJson(Map<String, dynamic> json) => CustomerDetials(
//         customerId: json["customerId"],
//         surgeryName: json["surgeryName"] != null ? json["surgeryName"].toString() : "",
//         service_name: json["service_name"] != null ? json["service_name"].toString() : "",
//         customerAddress: CustomerAddress.fromJson(json["customerAddress"]),
//         firstName: json["firstName"],
//         middleName: json["middleName"] != null ? json["middleName"].toString() : "",
//         lastName: json["lastName"],
//         mobile: json["mobile"],
//         title: json["title"] != null ? json["title"] : "",
//         address: json["address"] != null ? json["address"] : "",
//       );

//   Map<String, dynamic> toJson() => {
//         "customerId": customerId,
//         "surgeryName": surgeryName,
//         "service_name": service_name,
//         "customerAddress": customerAddress!.toJson(),
//         "firstName": firstName,
//         "middleName": middleName,
//         "lastName": lastName,
//         "mobile": mobile,
//         "title": title,
//         "address": address,
//       };
// }

// class CustomerAddress {
//   CustomerAddress({
//     this.address1,
//     this.alt_address,
//     this.address2,
//     this.postCode,
//     this.matchAddress,
//     this.latitude,
//     this.longitude,
//     this.duration,
//   });

//   String? address1;
//   String? alt_address;
//   String? address2;
//   String? matchAddress;
//   String? postCode;
//   dynamic latitude;
//   dynamic longitude;
//   String? duration;

//   factory CustomerAddress.fromJson(Map<String, dynamic> json) => CustomerAddress(
//         address1: json["address1"] == null ? "" : json["address1"],
//         alt_address: json["alt_address"] == null ? "" : json["alt_address"],
//         address2: json["address2"] == null ? "" : json["address2"],
//         matchAddress: json["matchAddress"] == null ? "" : json["matchAddress"],
//         postCode: json["postCode"] == null ? "" : json["postCode"],
//         latitude: (json["latitude"] == null || json["latitude"] == "") ? 0.0 : double.parse(json["latitude"].toString()),
//         //double.parse(json["latitude"] ?? "0.0"),
//         longitude: (json["longitude"] == null || json["longitude"] == "") ? 0.0 : double.parse(json["longitude"].toString()),
//         //double.parse(json["longitude"] ?? "0.0"),
//         duration: json["duration"] ?? "",
//       );

//   Map<String, dynamic> toJson() => {
//         "address1": address1,
//         "alt_address": alt_address,
//         "address2": address2 == null ? null : address2,
//         "postCode": postCode,
//         "matchAddress": matchAddress,
//         "contacts": "", //List<dynamic>.from(contacts.map((x) => x)),
//         "countryName": "", //countryNameValues.reverse[countryName],
//         "stateName": "", //stateNameValues.reverse[stateName],
//         "latitude": "${latitude ?? 0.0}",
//         "longitude": "${longitude ?? 0.0}",
//         "duration": duration,
//       };
// }

// enum CountryName { ENGLAND, WALES }

// final countryNameValues = EnumValues({"England": CountryName.ENGLAND, "Wales": CountryName.WALES});

// enum StateName { TEST }

// final stateNameValues = EnumValues({"TEST": StateName.TEST});

// class EnumValues<T> {
//   Map<String, T>? map;
//   Map<T, String>? reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map!.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap!;
//   }
// }
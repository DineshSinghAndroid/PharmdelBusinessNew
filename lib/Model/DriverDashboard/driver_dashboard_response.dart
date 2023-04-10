
class GetDeliveryApiResponse {
  List<DeliveryPojoModal>? deliveryList;
  bool? status;
  int? pageNumber;
  int? pageSize;
  int? totalRecords;
  OrderCounts? orderCounts;
  bool? isStart;
  String? message;
  bool? isOrderAvailable;
  CheckUpdateApp? checkUpdateApp;
  int? notificationCount;
  List<Exemptions>? exemptions;
  int? onLunch;
  String? systemTime;

  GetDeliveryApiResponse(
      {this.systemTime,
        this.deliveryList,
        this.status,
        this.pageNumber,
        this.pageSize,
        this.totalRecords,
        this.orderCounts,
        this.isStart,
        this.message,
        this.isOrderAvailable,
        this.checkUpdateApp,
        this.notificationCount,
        this.exemptions,
        this.onLunch});

  GetDeliveryApiResponse.fromJson(Map<String, dynamic> json) {
    systemTime = json['system_time'] != null ? json['system_time'].toString():null;
    if (json['deliveryList'] != null) {
      deliveryList = <DeliveryPojoModal>[];
      json['deliveryList'].forEach((v) {
        deliveryList!.add(new DeliveryPojoModal.fromJson(v));
      });
    }
    status = json['status'];
    pageNumber = json['pageNumber'] != null ? int.parse(json['pageNumber'].toString()):null;
    pageSize = json['pageSize'] != null ? int.parse(json['pageSize'].toString()):null;
    totalRecords = json['totalRecords'] != null ? int.parse(json['totalRecords'].toString()):null;
    orderCounts = json['orderCounts'] != null
        ? new OrderCounts.fromJson(json['orderCounts'])
        : null;
    isStart = json['isStart'];
    message = json['message'] != null ? json['message'].toString():null;
    isOrderAvailable = json['isOrderAvailable'];
    checkUpdateApp = json['checkUpdateApp'] != null
        ? new CheckUpdateApp.fromJson(json['checkUpdateApp'])
        : null;
    notificationCount = json['notification_count'] != null ? int.parse(json['notification_count'].toString()):null;
    if (json['exemptions'] != null) {
      exemptions = <Exemptions>[];
      json['exemptions'].forEach((v) {
        exemptions!.add(new Exemptions.fromJson(v));
      });
    }
    onLunch = json['on_lunch'] != null ? int.parse(json['on_lunch'].toString()):null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['system_time'] = this.systemTime;
    if (this.deliveryList != null) {
      data['deliveryList'] = this.deliveryList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    if (this.orderCounts != null) {
      data['orderCounts'] = this.orderCounts!.toJson();
    }
    data['isStart'] = this.isStart;
    data['message'] = this.message;
    data['isOrderAvailable'] = this.isOrderAvailable;
    if (this.checkUpdateApp != null) {
      data['checkUpdateApp'] = this.checkUpdateApp!.toJson();
    }
    data['notification_count'] = this.notificationCount;
    if (this.exemptions != null) {
      data['exemptions'] = this.exemptions!.map((v) => v.toJson()).toList();
    }
    data['on_lunch'] = this.onLunch;
    return data;
  }
}

class OrderCounts {
  String? totalOrders;
  String? pendingOrders;
  String? outForDeliveryOrders;
  String? deliveredOrders;
  String? faildOrders;
  String? pickedupOrders;
  String? receviedOrders;
  String? todayTotalOrders;

  OrderCounts(
      {this.totalOrders,
        this.pendingOrders,
        this.outForDeliveryOrders,
        this.deliveredOrders,
        this.faildOrders,
        this.pickedupOrders,
        this.receviedOrders,
        this.todayTotalOrders});

  OrderCounts.fromJson(Map<String, dynamic> json) {
    totalOrders = json['totalOrders'] != null ? json['totalOrders'].toString():null;
    pendingOrders = json['pendingOrders'] != null ? json['pendingOrders'].toString():null;
    outForDeliveryOrders = json['outForDeliveryOrders'] != null ? json['outForDeliveryOrders'].toString():null;
    deliveredOrders = json['deliveredOrders'] != null ? json['deliveredOrders'].toString():null;
    faildOrders = json['faildOrders'] != null ? json['faildOrders'].toString():null;
    pickedupOrders = json['pickedupOrders'] != null ? json['pickedupOrders'].toString():null;
    receviedOrders = json['receviedOrders'] != null ? json['receviedOrders'].toString():null;
    todayTotalOrders = json['todayTotalOrders'] != null ? json['todayTotalOrders'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalOrders'] = this.totalOrders;
    data['pendingOrders'] = this.pendingOrders;
    data['outForDeliveryOrders'] = this.outForDeliveryOrders;
    data['deliveredOrders'] = this.deliveredOrders;
    data['faildOrders'] = this.faildOrders;
    data['pickedupOrders'] = this.pickedupOrders;
    data['receviedOrders'] = this.receviedOrders;
    data['todayTotalOrders'] = this.todayTotalOrders;
    return data;
  }
}

class CheckUpdateApp {
  String? appVersion;
  String? message;
  String? forceUpdate;
  String? iosAppVersion;
  String? iosMessage;
  String? iosForceUpdate;

  CheckUpdateApp(
      {this.appVersion,
        this.message,
        this.forceUpdate,
        this.iosAppVersion,
        this.iosMessage,
        this.iosForceUpdate});

  CheckUpdateApp.fromJson(Map<String, dynamic> json) {
    appVersion = json['app_version'] != null ? json['app_version'].toString():null;
    message = json['message'] != null ? json['message'].toString():null;
    forceUpdate = json['force_update'] != null ? json['force_update'].toString():null;
    iosAppVersion = json['ios_app_version'] != null ? json['ios_app_version'].toString():null;
    iosMessage = json['ios_message'] != null ? json['ios_message'].toString():null;
    iosForceUpdate = json['ios_force_update'] != null ? json['ios_force_update'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_version'] = this.appVersion;
    data['message'] = this.message;
    data['force_update'] = this.forceUpdate;
    data['ios_app_version'] = this.iosAppVersion;
    data['ios_message'] = this.iosMessage;
    data['ios_force_update'] = this.iosForceUpdate;
    return data;
  }
}

class Exemptions {
  String? id;
  String? serialId;
  String? code;
  bool isSelected = false;

  Exemptions({this.id, this.serialId, this.code});

  Exemptions.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    serialId = json['serial_id'] != null ? json['serial_id'].toString():null;
    code = json['code'] != null ? json['code'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serial_id'] = this.serialId;
    data['code'] = this.code;
    return data;
  }
}


class DeliveryPojoModal {
  String? orderId;
  int? deliveryStatus = 0;
  String? routeId;
  String? isControlledDrugs;
  String? pharmacyId;
  String? isDelCharge;
  String? isPresCharge;
  String? sortBy;
  String? isStorageFridge;
  String? deliveryNotes;
  String? existingDeliveryNotes;
  String? rxCharge;
  String? delCharge;
  String? rxInvoice;
  String? subsId;
  String? totalControlledDrugs;
  String? totalStorageFridge;
  String? nursing_home_id;
  bool? isCD = false;
  bool? isFridge = false;
  String? status;
  String? rescheduleDate;
  String? exemption;
  String? parcelBoxName;
  String? serviceName;
  String? isCronCreated;
  String? bagSize;
  String? paymentStatus;
  String? pmr_type;
  String? pr_id;
  String? pharmacyName = "test";
  bool? isSelected = false;
  CustomerDetails? customerDetials;
  ///

  String? deliveryId;
  String? deliveryDate;
  String? companyId;
  String? branchId;
  String? toteBoxId;
  String? isSubsCharge;


  DeliveryPojoModal({
    //  this.deliveryId,
    this.orderId,
    this.serviceName,
    this.isStorageFridge,
    this.isControlledDrugs,
    this.deliveryNotes,
    this.rescheduleDate,
    this.sortBy,
    this.parcelBoxName,
    this.existingDeliveryNotes,
    this.rxCharge,
    this.delCharge,
    this.rxInvoice,
    //  this.companyId,
    // this.branchId,
    //  this.deliveryDate,
    this.deliveryStatus,
    this.pharmacyId,
    this.isDelCharge,
    this.routeId,
    this.customerDetials,
    this.status,
    this.isCronCreated,
    this.exemption,
    this.paymentStatus,
    this.bagSize,
    this.isPresCharge,
    this.totalStorageFridge,
    this.totalControlledDrugs,
    this.nursing_home_id,
    this.pmr_type,
    this.pr_id,
    this.pharmacyName,
    this.subsId,

    ///

    this.deliveryId,
    this.deliveryDate,
    this.companyId,
    this.branchId,
    this.toteBoxId,
  });


  DeliveryPojoModal.fromJson(Map<String, dynamic> json) {
    orderId = json["orderId"] != null ? json["orderId"].toString() : null;
    routeId = json["routeId"] != null ? json["routeId"].toString() : null;
    totalStorageFridge = json["totalStorageFridge"] != null ? json["totalStorageFridge"].toString() : null;
    totalControlledDrugs = json["totalControlledDrugs"] != null ? json["totalControlledDrugs"].toString() : null;
    nursing_home_id = json["nursing_home_id"] != null ? json["nursing_home_id"].toString() : null;
    isControlledDrugs = json["isControlledDrugs"] != null ? json["isControlledDrugs"].toString() : null;
    isStorageFridge = json["isStorageFridge"] != null ? json["isStorageFridge"].toString() : null;
    bagSize = json["bagSize"] != null ? json["bagSize"].toString() : null;
    subsId = json["subs_id"] != null ? json["subs_id"].toString() : null;
    pharmacyId = json["pharmacy_id"] != null ? json["pharmacy_id"].toString() : null;
    paymentStatus = json["paymentStatus"] != null ? json["paymentStatus"].toString() : null;
    isDelCharge = json["is_del_charge"] != null ? json["is_del_charge"].toString() : null;
    isPresCharge = json["is_pres_charge"] != null ? json["is_pres_charge"].toString() : null;
    exemption = json["exemption"] != null ? json["exemption"].toString() : null;
    parcelBoxName = json["parcel_box_name"] != null ? json["parcel_box_name"].toString() : null;
    deliveryNotes = json["deliveryNotes"] != null ? json["deliveryNotes"].toString() : null;
    rescheduleDate = json["reschedule_date"] != null ? json["reschedule_date"].toString() : null;
    existingDeliveryNotes = json["existingDeliveryNotes"] != null ? json["existingDeliveryNotes"].toString() : null;
    rxCharge = json["rx_charge"] != null ? json["rx_charge"].toString() : null;
    rxInvoice = json["rx_invoice"] != null ? json["rx_invoice"].toString() : null;
    delCharge = json["del_charge"] != null ? json["del_charge"].toString() : null;
    sortBy = json["sort_by"] != null ? json["sort_by"].toString() : null;
    deliveryStatus = json["delivery_status"] != null ? int.parse(json["delivery_status"].toString()) : null;
    serviceName = json["serviceName"] != null ? json["serviceName"].toString() : null;
    isCronCreated = json["isCronCreated"] != null ? json["isCronCreated"].toString() : null;
    pmr_type = json["pmr_type"] != null ? json["pmr_type"].toString() : null;
    pr_id = json["pr_id"] != null ? json["pr_id"].toString() : null;
    status = json["status"] != null ? json["status"].toString() : null;
    pharmacyName = json["pharmacy_name"] != null ? json["pharmacy_name"].toString() : null;
    customerDetials = CustomerDetails.fromJson(json["customerDetials"]);
    ///
    deliveryId = json["deliveryId"] != null ? json["deliveryId"].toString() : null;
    deliveryDate = json["deliveryDate"] != null ? json["deliveryDate"].toString() : null;
    companyId = json["companyId"] != null ? json["companyId"].toString() : null;
    branchId = json["branchId"] != null ? json["branchId"].toString() : null;
    toteBoxId = json["tote_box_id"] != null ? json["tote_box_id"].toString() : null;
  }

  Map<String, dynamic> toJson() => {
    //  "deliveryId": deliveryId,
    "orderId": orderId,
    "routeId": routeId,
    "exemption": exemption,
    "paymentStatus": paymentStatus,
    "pharmacy_id": pharmacyId,
    "is_del_charge": isDelCharge,
    "totalControlledDrugs": totalControlledDrugs,
    "totalStorageFridge": totalStorageFridge,
    "nursing_home_id": nursing_home_id,
    "is_pres_charge": isPresCharge,
    "subs_id": subsId,
    "bagSize": bagSize,
    "existingDeliveryNotes": existingDeliveryNotes,
    "rx_charge": rxCharge,
    "rx_invoice": rxInvoice,
    "del_charge": delCharge,
    "reschedule_date": rescheduleDate,
    "parcel_box_name": parcelBoxName,
    "sort_by": sortBy,
    "isControlledDrugs": isControlledDrugs,
    "isStorageFridge": isStorageFridge,
    "deliveryNotes": deliveryNotes,
    "serviceName": serviceName,
    "delivery_status": deliveryStatus,
    "pmr_type": pmr_type,
    "pr_id": pr_id,
    "pharmacy_name": pharmacyName,
    "isCronCreated": isCronCreated,
    "status": status,
    "customerDetials": customerDetials?.toJson(),

    ///
    "deliveryId" : deliveryId,
    "deliveryDate" : deliveryDate,
    "companyId" : companyId,
    "branchId" : branchId,
    "tote_box_id" : toteBoxId,
  };
}

class CustomerDetails {

  String? customerId;
  String? surgeryName;
  String? service_name;
  String? mobile;
  CustomerAddress? customerAddress;
  String? firstName;
  String? middleName;
  String? lastName;
  String? title;
  String? address;

  CustomerDetails({
    this.customerId,
    this.surgeryName,
    this.service_name,
    this.mobile,
    this.customerAddress,
    this.firstName,
    this.middleName,
    this.lastName,
    this.title,
    this.address,
  });


  CustomerDetails.fromJson(Map<String, dynamic> json) {
    customerId =  json["customerId"] != null ? json["customerId"].toString():null;
    surgeryName = json["surgeryName"] != null ? json["surgeryName"].toString():null;
    service_name =json["service_name"] != null ? json["service_name"].toString():null;
    customerAddress = json['customerAddress'] != null
        ? CustomerAddress.fromJson(json['customerAddress'])
        : null;
    firstName =json["firstName"] != null ? json["firstName"].toString():null;
    middleName = json["middleName"] != null ? json["middleName"].toString():null;
    lastName = json["lastName"] != null ? json["lastName"].toString():null;
    mobile = json["mobile"] != null ? json["mobile"].toString():null;
    title = json["title"] != null ? json["title"].toString():null;
    address = json["address"] != null ? json["address"].toString():null;
  }

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "surgeryName": surgeryName,
    "service_name": service_name,
    "customerAddress": customerAddress?.toJson(),
    "firstName": firstName,
    "middleName": middleName,
    "lastName": lastName,
    "mobile": mobile,
    "title": title,
    "address": address,
  };
}

class CustomerAddress {
  String? address1;
  String? alt_address;
  String? address2;
  String? matchAddress;
  String? postCode;
  String? latitude;
  String? longitude;
  String? duration;

  CustomerAddress({
    this.address1,
    this.alt_address,
    this.address2,
    this.postCode,
    this.matchAddress,
    this.latitude,
    this.longitude,
    this.duration,
  });


  CustomerAddress.fromJson(Map<String, dynamic> json){
    address1 = json["address1"] != null ? json["address1"].toString():null;
    alt_address = json["alt_address"] != null ? json["alt_address"].toString():null;
    address2 = json["address2"] != null ? json["address2"].toString():null;
    matchAddress = json["matchAddress"] != null ? json["matchAddress"].toString():null;
    postCode = json["postCode"] != null ? json["postCode"].toString():null;
    latitude = json["latitude"] != null ? json["latitude"].toString():null;
    longitude = json["longitude"] != null ? json["longitude"].toString():null;
    duration = json["duration"] != null ? json["duration"].toString():null;
  }

  Map<String, dynamic> toJson() => {
    "address1": address1,
    "alt_address": alt_address,
    "address2": address2 == null ? null : address2,
    "postCode": postCode,
    "matchAddress": matchAddress,
    "contacts": "", //List<dynamic>.from(contacts.map((x) => x)),
    "countryName": "", //countryNameValues.reverse[countryName],
    "stateName": "", //stateNameValues.reverse[stateName],
    "latitude": "${latitude ?? 0.0}",
    "longitude": "${longitude ?? 0.0}",
    "duration": duration,
  };
}
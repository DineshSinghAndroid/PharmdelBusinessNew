class P_FetchDeliveryListModel {
  List<ListData>? list;
  List<ListData>? sortedList;
  String? status;
  String? message;
  bool? isRouteStarted;
  String? isOrderAvailable;
  List<Exemptions>? exemptions;

  P_FetchDeliveryListModel(
      {this.list,
        this.sortedList,
        this.status,
        this.message,
        this.isRouteStarted,
        this.isOrderAvailable,
        this.exemptions});

  P_FetchDeliveryListModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListData>[];
      json['list'].forEach((v) {
        list!.add(new ListData.fromJson(v));
      });
    }
    if (json['sorted_list'] != null) {
      sortedList = <ListData>[];
      json['sorted_list'].forEach((v) {
        sortedList!.add(new ListData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
    isRouteStarted = json['isRouteStarted'];
    isOrderAvailable = json['isOrderAvailable'];
    if (json['exemptions'] != null) {
      exemptions = <Exemptions>[];
      json['exemptions'].forEach((v) {
        exemptions!.add(new Exemptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.sortedList != null) {
      data['sorted_list'] = this.sortedList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    data['isRouteStarted'] = this.isRouteStarted;
    data['isOrderAvailable'] = this.isOrderAvailable;
    if (this.exemptions != null) {
      data['exemptions'] = this.exemptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  int? orderId;
  int? id;
  String? prId;
  String? parcelBoxName;
  String? pmrType;
  String? isCronCreated;
  int? deliveryId;
  String? customerName;
  String? surName;
  String? rescheduleDate;
  String? altAddress;
  String? address;
  double? latitude;
  double? longitude;
  String? deliveryNote;
  int? deliveryStatus;
  String? deliveryStatusDesc;
  String? deliveryDate;
  String? customerMobileNumber;
  String? branchName;
  String? recentDeliveryNote;
  String? isStorageFridge;
  String? isControlledDrugs;
  String? deliveredTo;
  String? exitingNote;
  dynamic? surgeryId;
  String? surgeryName;
  String? serviceName;
  dynamic? paymentStatus;
  String? bagSize;
  int? subsId;
  String? delCharge;
  String? rxCharge;
  int? rxInvoice;
  String? exemption;
  dynamic? driverLatitude;
  dynamic? driverLongitude;
  String? eta;
  String? routeName;

  ListData(
      {this.orderId,
        this.id,
        this.prId,
        this.parcelBoxName,
        this.pmrType,
        this.isCronCreated,
        this.deliveryId,
        this.customerName,
        this.surName,
        this.rescheduleDate,
        this.altAddress,
        this.address,
        this.latitude,
        this.longitude,
        this.deliveryNote,
        this.deliveryStatus,
        this.deliveryStatusDesc,
        this.deliveryDate,
        this.customerMobileNumber,
        this.branchName,
        this.recentDeliveryNote,
        this.isStorageFridge,
        this.isControlledDrugs,
        this.deliveredTo,
        this.exitingNote,
        this.surgeryId,
        this.surgeryName,
        this.serviceName,
        this.paymentStatus,
        this.bagSize,
        this.subsId,
        this.delCharge,
        this.rxCharge,
        this.rxInvoice,
        this.exemption,
        this.driverLatitude,
        this.driverLongitude,
        this.eta,
        this.routeName});

  ListData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'] != null ?  int.parse(json['orderId'].toString()): null;
    id = json['id']!= null ? int.parse(json['id'].toString()) : null;
    prId = json['pr_id'] != null ? json['pr_id'].toString() : null;
    parcelBoxName = json['parcel_box_name'] != null ? json['parcel_box_name'].toString() : null;
    pmrType = json['pmr_type'] != null ?  json['pmr_type'].toString(): null;
    isCronCreated = json['isCronCreated'] != null ? json['isCronCreated'].toString() : null;
    deliveryId = json['deliveryId'] != null ? int.parse(json['deliveryId'].toString()) : null;
    customerName = json['customerName'] != null ? json['customerName'].toString() : null;
    surName = json['surName'] != null ?  json['surName'].toString() : null;
    rescheduleDate = json['reschedule_date'] != null?  json['reschedule_date'].toString() :null;
    altAddress = json['alt_address'] != null ?  json['alt_address'].toString() :null;
    address = json['address'] != null ? json['address'].toString() : null;
    latitude = json['latitude']!= null ?  double.parse(json['latitude'].toString()) :null;
    longitude = json['longitude'] != null ? double.parse(json['longitude'].toString()) : null;
    deliveryNote = json['deliveryNote'] != null ? json['deliveryNote'].toString() :null;
    deliveryStatus = json['deliveryStatus'] != null ? int.parse(json['deliveryStatus'].toString()) :null;
    deliveryStatusDesc = json['deliveryStatusDesc'] != null ? json['deliveryStatusDesc'].toString() :null;
    deliveryDate = json['deliveryDate'] != null ? json['deliveryDate'].toString() :null;
    customerMobileNumber = json['customerMobileNumber'] != null ? json['customerMobileNumber'].toString() :null;
    branchName = json['branchName'] != null ? json['branchName'].toString() :null;
    recentDeliveryNote = json['recentDeliveryNote'] != null ? json['recentDeliveryNote'].toString() :null;
    isStorageFridge = json['isStorageFridge'] != null ? json['isStorageFridge'].toString() :null;
    isControlledDrugs = json['isControlledDrugs'] != null ? json['isControlledDrugs'].toString() :null;
    deliveredTo = json['delivered_to']  != null ? json['delivered_to'].toString() :null;
    exitingNote = json['exitingNote'] != null ? json['exitingNote'].toString() :null;
    surgeryId = json['surgeryId']!= null ? json['surgeryId'].toString() : null;
    surgeryName = json['surgeryName'] != null ? json['surgeryName'].toString() : null;
    serviceName =  json['serviceName'] != null ? json['serviceName'].toString() : null;
    paymentStatus = json['paymentStatus']!= null ? json['paymentStatus'].toString() : null;
    delCharge = json['paymentStatus'] != null ? json['paymentStatus'].toString() :null;
    bagSize = json['bagSize'] != null ? json['bagSize'].toString() : null;
    subsId = json['subs_id'] != null ? int.parse(json['subs_id'].toString()) : null;
    rxCharge = json['rx_charge'] != null ? json['rx_charge'].toString() : null;
    rxInvoice = json['rx_invoice'] != null ? int.parse(json['rx_invoice'].toString()) : null;
    exemption = json['exemption'] != null ? json['exemption'].toString() : null;
    driverLatitude = json['driver_latitude'] != null ? json[''].toString() : null;
    driverLongitude = json['driver_longitude'] != null ? json[''].toString() : null;
    eta = json['eta'];
    routeName = json['route_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['id'] = this.id;
    data['pr_id'] = this.prId;
    data['parcel_box_name'] = this.parcelBoxName;
    data['pmr_type'] = this.pmrType;
    data['isCronCreated'] = this.isCronCreated;
    data['deliveryId'] = this.deliveryId;
    data['customerName'] = this.customerName;
    data['surName'] = this.surName;
    data['reschedule_date'] = this.rescheduleDate;
    data['alt_address'] = this.altAddress;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['deliveryNote'] = this.deliveryNote;
    data['deliveryStatus'] = this.deliveryStatus;
    data['deliveryStatusDesc'] = this.deliveryStatusDesc;
    data['deliveryDate'] = this.deliveryDate;
    data['customerMobileNumber'] = this.customerMobileNumber;
    data['branchName'] = this.branchName;
    data['recentDeliveryNote'] = this.recentDeliveryNote;
    data['isStorageFridge'] = this.isStorageFridge;
    data['isControlledDrugs'] = this.isControlledDrugs;
    data['delivered_to'] = this.deliveredTo;
    data['exitingNote'] = this.exitingNote;
    data['surgeryId'] = this.surgeryId;
    data['surgeryName'] = this.surgeryName;
    data['serviceName'] = this.serviceName;
    data['paymentStatus'] = this.paymentStatus;
    data['bagSize'] = this.bagSize;
    data['subs_id'] = this.subsId;
    data['del_charge'] = this.delCharge;
    data['rx_charge'] = this.rxCharge;
    data['rx_invoice'] = this.rxInvoice;
    data['exemption'] = this.exemption;
    data['driver_latitude'] = this.driverLatitude;
    data['driver_longitude'] = this.driverLongitude;
    data['eta'] = this.eta;
    data['route_name'] = this.routeName;
    return data;
  }
}

class Exemptions {
  int? id;
  String? serialId;
  String? code;

  Exemptions({this.id, this.serialId, this.code});

  Exemptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialId = json['serial_id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serial_id'] = this.serialId;
    data['code'] = this.code;
    return data;
  }
}

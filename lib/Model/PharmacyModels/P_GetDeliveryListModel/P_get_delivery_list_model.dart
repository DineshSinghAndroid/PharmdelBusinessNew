
class P_GetDeliveryListModel {
  List<ListData>? list;
  List<SortedList>? sortedList;
  String? status;
  String? message;
  bool? isRouteStarted;
  String? isOrderAvailable;
  List<Exemptions>? exemptions;

  P_GetDeliveryListModel(
      {this.list,
        this.sortedList,
        this.status,
        this.message,
        this.isRouteStarted,
        this.isOrderAvailable,
        this.exemptions});

  P_GetDeliveryListModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListData>[];
      json['list'].forEach((v) {
        list!.add(new ListData.fromJson(v));
      });
    }
    if (json['sorted_list'] != null) {
      sortedList = <SortedList>[];
      json['sorted_list'].forEach((v) {
        sortedList!.add(new SortedList.fromJson(v));
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
  String? surgeryId;
  String? surgeryName;
  String? serviceName;
  String? paymentStatus;
  String? bagSize;
  int? subsId;
  Null? delCharge;
  String? rxCharge;
  int? rxInvoice;
  String? exemption;
  double? driverLatitude;
  double? driverLongitude;
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
    orderId = json['orderId'];
    id = json['id'];
    prId = json['pr_id'];
    parcelBoxName = json['parcel_box_name'];
    pmrType = json['pmr_type'];
    isCronCreated = json['isCronCreated'];
    deliveryId = json['deliveryId'];
    customerName = json['customerName'];
    surName = json['surName'];
    rescheduleDate = json['reschedule_date'];
    altAddress = json['alt_address'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deliveryNote = json['deliveryNote'];
    deliveryStatus = json['deliveryStatus'];
    deliveryStatusDesc = json['deliveryStatusDesc'];
    deliveryDate = json['deliveryDate'];
    customerMobileNumber = json['customerMobileNumber'];
    branchName = json['branchName'];
    recentDeliveryNote = json['recentDeliveryNote'];
    isStorageFridge = json['isStorageFridge'];
    isControlledDrugs = json['isControlledDrugs'];
    deliveredTo = json['delivered_to'];
    exitingNote = json['exitingNote'];
    surgeryId = json['surgeryId'];
    surgeryName = json['surgeryName'];
    serviceName = json['serviceName'];
    paymentStatus = json['paymentStatus'];
    bagSize = json['bagSize'];
    subsId = json['subs_id'];
    delCharge = json['del_charge'];
    rxCharge = json['rx_charge'];
    rxInvoice = json['rx_invoice'];
    exemption = json['exemption'];
    driverLatitude = json['driver_latitude'];
    driverLongitude = json['driver_longitude'];
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

class SortedList {
  int? orderId;
  int? id;
  Null? prId;
  String? parcelBoxName;
  String? pmrType;
  String? isCronCreated;
  int? deliveryId;
  String? customerName;
  String? surName;
  Null? rescheduleDate;
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
  Null? deliveredTo;
  Null? exitingNote;
  String? surgeryId;
  String? surgeryName;
  String? serviceName;
  String? paymentStatus;
  String? bagSize;
  Null? subsId;
  Null? delCharge;
  String? rxCharge;
  Null? rxInvoice;
  Null? exemption;
  double? driverLatitude;
  double? driverLongitude;
  String? eta;
  String? routeName;

  SortedList(
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

  SortedList.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    id = json['id'];
    prId = json['pr_id'];
    parcelBoxName = json['parcel_box_name'];
    pmrType = json['pmr_type'];
    isCronCreated = json['isCronCreated'];
    deliveryId = json['deliveryId'];
    customerName = json['customerName'];
    surName = json['surName'];
    rescheduleDate = json['reschedule_date'];
    altAddress = json['alt_address'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deliveryNote = json['deliveryNote'];
    deliveryStatus = json['deliveryStatus'];
    deliveryStatusDesc = json['deliveryStatusDesc'];
    deliveryDate = json['deliveryDate'];
    customerMobileNumber = json['customerMobileNumber'];
    branchName = json['branchName'];
    recentDeliveryNote = json['recentDeliveryNote'];
    isStorageFridge = json['isStorageFridge'];
    isControlledDrugs = json['isControlledDrugs'];
    deliveredTo = json['delivered_to'];
    exitingNote = json['exitingNote'];
    surgeryId = json['surgeryId'];
    surgeryName = json['surgeryName'];
    serviceName = json['serviceName'];
    paymentStatus = json['paymentStatus'];
    bagSize = json['bagSize'];
    subsId = json['subs_id'];
    delCharge = json['del_charge'];
    rxCharge = json['rx_charge'];
    rxInvoice = json['rx_invoice'];
    exemption = json['exemption'];
    driverLatitude = json['driver_latitude'];
    driverLongitude = json['driver_longitude'];
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

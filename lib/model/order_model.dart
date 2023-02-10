// @dart=2.9
import 'dart:convert';

OrderModal orderModalFromJson(String str) => OrderModal.fromJson(json.decode(str));

String orderModalToJson(OrderModal data) => json.encode(data.toJson());

class OrderModal {
  OrderModal({
    this.orderId,
    this.related_order_count,
    this.alt_address,
    this.customerId,
    this.pickupTypeId,
    this.deliveryNote,
    this.exitingNote,
    this.isStorageFridge,
    this.parcelBoxName,
    this.isControlledDrugs,
    this.deliveryId,
    this.deliveryStatusDesc,
    this.nursing_home_id,
    this.rxCharge,
    this.subsId,
    this.rxInvoice,
    this.delCharge,
    this.deliveryTo,
    this.customer,
    this.routeId,
    this.pr_id,
    this.pmr_type,
    this.deliveryRemarks,
    this.totalStorageFridge,
    this.totalControlledDrugs,
    this.firstName,
    this.middleName,
    this.lastName,
    this.title,
    this.address,
    this.pharmacyId,
    this.related_orders,
    this.paymentStatus,
    this.isPresCharge,
    this.isDelCharge,
    this.bagSize,
    this.exemption,
    this.exemptions,
    this.message,
  });

  int orderId;
  int pharmacyId;
  int isPresCharge;
  int isDelCharge;
  String paymentStatus;
  String bagSize;
  String exemption;
  int related_order_count;
  int customerId;
  dynamic rxCharge;
  dynamic rxInvoice;
  dynamic delCharge;
  int subsId;
  int totalControlledDrugs;
  int totalStorageFridge;
  int nursing_home_id;
  dynamic pmr_type;
  dynamic pr_id;
  int pickupTypeId;
  dynamic deliveryNote;
  dynamic exitingNote;
  bool isStorageFridge;
  bool isControlledDrugs;
  int deliveryId;
  dynamic deliveryStatusDesc;
  String parcelBoxName;
  dynamic deliveryTo;
  dynamic parcelName;
  Customer customer;
  String alt_address;
  dynamic routeId;
  dynamic deliveryRemarks;
  dynamic firstName;
  dynamic middleName;
  dynamic lastName;
  dynamic title;
  Address address;
  List<ReletedOrders> related_orders = [];

  List<ExemptionsList> exemptions = [];
  String message;

  factory OrderModal.fromJson(Map<String, dynamic> json) => OrderModal(
        related_order_count: json["related_order_count"],
        orderId: json["orderId"],
        exemption: json["exemption"],
        pharmacyId: json["pharmacy_id"],
        isDelCharge: json["is_del_charge"],
        isPresCharge: json["is_pres_charge"],
        nursing_home_id: json["nursing_home_id"],
        totalStorageFridge: json["totalStorageFridge"],
        totalControlledDrugs: json["totalControlledDrugs"],
        delCharge: json['del_charge'],
        bagSize: json["bagSize"],
        rxCharge: json["rx_charge"],
        rxInvoice: json["rx_invoice"],
        // delCharge: json["del_charge"],
        paymentStatus: json["paymentStatus"],
        alt_address: json["alt_address"],
        pmr_type: json["pmr_type"],
        pr_id: json["pr_id"],
        customerId: json["customerId"],
        parcelBoxName: json["parcel_box_name"],
        pickupTypeId: json["pickupTypeId"],
        deliveryNote: json["deliveryNote"] ?? "",
        exitingNote: json["exitingNote"] ?? "",
        isStorageFridge: json["isStorageFridge"],
        isControlledDrugs: json["isControlledDrugs"],
        deliveryId: json["deliveryId"],
        deliveryStatusDesc: json["deliveryStatusDesc"],
        deliveryTo: json["deliveryTo"],
        customer: Customer.fromJson(json["customer"]),
        related_orders: List<ReletedOrders>.from(json["related_orders"].map((x) => ReletedOrders.fromJson(x))),
        routeId: json["routeId"],
        deliveryRemarks: json["deliveryRemarks"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        title: json["title"],
        address: Address.fromJson(json["address"]),
        // exemptions: List<ExemptionsList>.from(json["exemptions"].map((x) => ExemptionsList.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "related_order_count ": related_order_count,
        "orderId ": orderId,
        "paymentStatus": paymentStatus,
        "pharmacy_id": pharmacyId,
        "bagSize": bagSize,
        "del_charge": delCharge,
        "totalControlledDrugs": totalControlledDrugs,
        "totalStorageFridge": totalStorageFridge,
        "nursing_home_id": nursing_home_id,
        "rx_charge": rxCharge,
        "rx_invoice": rxInvoice,
        // "del_charge": delCharge ,
        "is_pres_charge": isPresCharge,
        "is_del_charge": isDelCharge,
        "exemption": exemption,
        "pmr_type ": pmr_type,
        "pr_id ": pr_id,
        "orderId": orderId,
        "alt_address": alt_address,
        "customerId": customerId,
        "parcel_box_name": parcelBoxName,
        "pickupTypeId": pickupTypeId,
        "exitingNote": exitingNote,
        "isStorageFridge": isStorageFridge,
        "isControlledDrugs": isControlledDrugs,
        "deliveryId": deliveryId,
        "deliveryStatusDesc": deliveryStatusDesc,
        "deliveryTo": deliveryTo,
        "customer": customer.toJson(),
        "routeId": routeId,
        "deliveryRemarks": deliveryRemarks,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "title": title,
        "address": address.toJson(),
        "related_orders": List<dynamic>.from(related_orders.map((x) => x.toJson())),
        // "exemptions": List<dynamic>.from(exemptions.map((x) => x.toJson())),
        "message": message,
      };
}

class Address {
  Address({
    this.address1,
    this.address2,
    this.alt_address,
    this.postCode,
    this.longitude,
    this.latitude,
    this.duration,
  });

  dynamic address1;
  dynamic address2;
  String alt_address;
  String postCode;
  dynamic longitude;
  dynamic latitude;
  dynamic duration;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address1: json["address1"],
        address2: json["address2"],
        alt_address: json["alt_address"],
        postCode: json["postCode"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "address1": address1,
        "address2": address2,
        "alt_address": alt_address,
        "postCode": postCode,
        "longitude": longitude,
        "latitude": latitude,
        "duration": duration,
      };
}

class ReletedOrders {
  ReletedOrders({
    this.orderId,
    this.userId,
    this.isControlledDrugs,
    this.parcelBoxName,
    this.existing_delivery_notes,
    this.rxCharge,
    this.rxInvoice,
    this.delCharge,
    this.isStorageFridge,
    this.pmr_type,
    this.isCronCreated,
    this.deliveryNotes,
    this.pharmacyId,
    this.fullName,
    this.pr_id,
    this.mobileNo,
    this.subsId,
    this.fullAddress,
    this.exemption,
    this.paymentStatus,
    this.bagSize,
    this.isDelCharge,
    this.isPresCharge,
    this.alt_address,
    this.pharmacyName,
  });

  int orderId;
  int userId;
  int pharmacyId;
  int isPresCharge;
  int isDelCharge;
  bool isControlledDrugs;
  String parcelBoxName;
  bool isStorageFridge;
  String totalAmount = "0.00";
  String isCronCreated;
  String parcelName;
  String bagSize;
  String paymentStatus;
  String exemption;
  String pmr_type;
  String deliveryNotes;
  String existing_delivery_notes;
  dynamic rxCharge;
  dynamic rxInvoice;
  dynamic delCharge;
  int subsId;
  int totalControlledDrugs;
  int totalStorageFridge;
  int nursing_home_id;
  String fullName;
  String fullAddress;
  String mobileNo;
  String alt_address;
  String pharmacyName;
  bool isSelected = false;
  dynamic pr_id;

  factory ReletedOrders.fromJson(Map<String, dynamic> json) => ReletedOrders(
        existing_delivery_notes: json["existing_delivery_notes"],
        rxCharge: json["rx_charge"],
        rxInvoice: json["rx_invoice"],
        delCharge: json["del_charge"],
        subsId: json["subs_id"],
        orderId: json["orderId"],
        pr_id: json["pr_id"],
        isControlledDrugs: json["isControlledDrugs"],
        parcelBoxName: json["parcel_box_name"],
        pmr_type: json["pmr_type"],
        isCronCreated: json["isCronCreated"],
        isStorageFridge: json["isStorageFridge"],
        deliveryNotes: json["deliveryNotes"],
        fullName: json["fullName"],
        userId: json["userId"],
        fullAddress: json["fullAddress"],
        alt_address: json["alt_address"],
        pharmacyName: json["pharmacy_name"],
      );

  Map<String, dynamic> toJson() => {
        "pr_id": pr_id,
        "existing_delivery_notes": existing_delivery_notes,
        "rx_invoice": rxInvoice,
        "rx_charge": rxCharge,
        "del_charge": delCharge,
        "subs_id": subsId,
        "orderId": orderId,
        "isControlledDrugs": isControlledDrugs,
        "parcel_box_name": parcelBoxName,
        "userId": userId,
        "pmr_type": pmr_type,
        "isStorageFridge": isStorageFridge,
        "deliveryNotes": deliveryNotes,
        "isCronCreated": isCronCreated,
        "fullName": fullName,
        "fullAddress": fullAddress,
        "alt_address": alt_address,
        "pharmacy_name": pharmacyName,
      };
}

class ExemptionsList {
  int id;
  String name;
  String serialId;

  bool isSelected = false;

  ExemptionsList({this.id, this.name});

  ExemptionsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['code'];
    serialId = json['serial_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.name;
    data['serialId'] = this.serialId;
    return data;
  }
}

class Customer {
  Customer({this.customerId, this.alt_address, this.surgeryName, this.fullName, this.fullAddress, this.customerAddress, this.customerNote, this.fridgeNote, this.controlNote, this.firstName, this.middleName, this.lastName, this.mobile, this.title, this.address, this.latitude, this.longitude});

  int customerId;
  dynamic surgeryName;
  dynamic fullName;
  dynamic fullAddress;
  Address customerAddress;
  dynamic customerNote;
  dynamic fridgeNote;
  dynamic controlNote;
  dynamic firstName;
  dynamic middleName;
  dynamic lastName;
  String mobile;
  String alt_address;
  dynamic title;
  Address address;
  dynamic longitude;
  dynamic latitude;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json["customerId"],
        alt_address: json["alt_address"],
        surgeryName: json["surgeryName"],
        fullName: json["fullName"],
        fullAddress: json["fullAddress"],
        customerAddress: Address.fromJson(json["customerAddress"]),
        customerNote: json["customerNote"],
        fridgeNote: json["fridgeNote"],
        controlNote: json["controlNote"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        mobile: json["mobile"],
        title: json["title"],
        address: Address.fromJson(json["address"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "alt_address": alt_address,
        "surgeryName": surgeryName,
        "fullName": fullName,
        "fullAddress": fullAddress,
        "customerAddress": customerAddress.toJson(),
        "customerNote": customerNote,
        "fridgeNote": fridgeNote,
        "controlNote": controlNote,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "mobile": mobile,
        "title": title,
        "address": address.toJson(),
        "latitude": latitude,
        "longitude": longitude,
      };
}

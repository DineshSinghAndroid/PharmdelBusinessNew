// @dart=2.9
// To parse this JSON data, do
// Final driverDashBoardModal = driverDashBoardModalFromJson(jsonString);

import 'dart:convert';

import 'delivery_pojo_model.dart';

DriverDashBoardModal driverDashBoardModalFromJson(String str) => DriverDashBoardModal.fromJson(json.decode(str));

String driverDashBoardModalToJson(DriverDashBoardModal data) => json.encode(data.toJson());

class DriverDashBoardModal {
  DriverDashBoardModal({
    this.pageNumber,
    this.pageSize,
    this.totalRecords,
    this.notification_count,
    this.systemTime,
    this.orderCounts,
    this.deliveryList,
    this.isStart,
    this.exemptions,
  });

  int pageNumber;
  int pageSize;
  int totalRecords;
  int notification_count;
  bool isStart;
  OrderCounts orderCounts;
  String systemTime;
  List<DeliveryPojoModal> deliveryList;
  List<Exemptions> exemptions;

  factory DriverDashBoardModal.fromJson(Map<String, dynamic> json) => DriverDashBoardModal(pageNumber: json["pageNumber"], pageSize: json["pageSize"], systemTime: json["system_time"], notification_count: json["notification_count"], isStart: json["isStart"], totalRecords: json["totalRecords"], orderCounts: OrderCounts.fromJson(json["orderCounts"]), deliveryList: List<DeliveryPojoModal>.from(json["deliveryList"].map((x) => DeliveryPojoModal.fromJson(x))), exemptions: json["exemptions"] != null ? List<Exemptions>.from(json["exemptions"].map((x) => Exemptions.fromJson(x))) : []);

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "notification_count": notification_count,
        "isStart": isStart,
        "system_time": systemTime,
        "totalRecords": totalRecords,
        "orderCounts": orderCounts.toJson(),
        "deliveryList": deliveryPojoModalToJson(deliveryList),
        "exemptions": List<dynamic>.from(exemptions.map((x) => x.toJson())),
      };
}

class Exemptions {
  int id;
  String name;
  String serialId;

  Exemptions({this.id, this.name});

  Exemptions.fromJson(Map<String, dynamic> json) {
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

class OrderCounts {
  OrderCounts({
    this.totalOrders,
    this.pendingOrders,
    this.outForDeliveryOrders,
    this.deliveredOrders,
    this.faildOrders,
    this.pickedupOrders,
    this.receviedOrders,
  });

  int totalOrders;
  int pendingOrders;
  int outForDeliveryOrders;
  int deliveredOrders;
  int faildOrders;
  int pickedupOrders;
  int receviedOrders;
  int todayTotalOrders;

  factory OrderCounts.fromJson(Map<String, dynamic> json) => OrderCounts(
        totalOrders: json["totalOrders"],
        pendingOrders: json["pendingOrders"],
        outForDeliveryOrders: json["outForDeliveryOrders"],
        deliveredOrders: json["deliveredOrders"],
        faildOrders: json["faildOrders"],
        pickedupOrders: json["pickedupOrders"],
        receviedOrders: json["receviedOrders"],
      );

  Map<String, dynamic> toJson() => {
        "totalOrders": totalOrders,
        "pendingOrders": pendingOrders,
        "outForDeliveryOrders": outForDeliveryOrders,
        "deliveredOrders": deliveredOrders,
        "faildOrders": faildOrders,
        "pickedupOrders": pickedupOrders,
        "receviedOrders": receviedOrders,
      };
}

// @dart=2.9
import 'dart:convert';

DriverPointsModel driverPointsModelFromJson(String str) => DriverPointsModel.fromJson(json.decode(str));

String driverPointsModelToJson(DriverPointsModel data) => json.encode(data.toJson());

class DriverPointsModel {
  List<DriverRoutePointList> driverRoutePointList;
  String driverRouteBreakPointList;
  int driverId;
  String routeId;
  String isStartRoute;
  String isBreakPoint;
  dynamic latitude;
  dynamic longitude;
  dynamic title;
  dynamic address;
  String createdOn;
  String updatedOn;
  String breakTimeTo;
  String breakTimeFrom;
  String diffToFrom;
  bool routeStarted;

  DriverPointsModel({this.driverRoutePointList, this.driverRouteBreakPointList, this.driverId, this.routeId, this.isStartRoute, this.isBreakPoint, this.latitude, this.longitude, this.createdOn, this.title, this.updatedOn, this.breakTimeTo, this.address, this.breakTimeFrom, this.routeStarted, this.diffToFrom});

  DriverPointsModel.fromJson(Map<String, dynamic> json) {
    if (json['driverRoutePointList'] != null) {
      driverRoutePointList = new List<DriverRoutePointList>();
      json['driverRoutePointList'].forEach((v) {
        driverRoutePointList.add(new DriverRoutePointList.fromJson(v));
      });
    }
    driverRouteBreakPointList = json['driverRouteBreakPointList'];
    driverId = json['driverId'];
    routeStarted = json['routeStarted'];
    routeId = json['routeId'];
    isStartRoute = json['isStartRoute'];
    isBreakPoint = json['isBreakPoint'];
    latitude = json['latitude'];
    longitude = json['longitude'] ?? 0.0;
    createdOn = json['createdOn'] ?? 0.0;
    updatedOn = json['updatedOn'];
    breakTimeTo = json['breakTimeTo'];
    breakTimeFrom = json['breakTimeFrom'];
    diffToFrom = json['diffToFrom'];
    title = json['title'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.driverRoutePointList != null) {
      data['driverRoutePointList'] = this.driverRoutePointList.map((v) => v.toJson()).toList();
    }
    data['driverRouteBreakPointList'] = this.driverRouteBreakPointList;
    data['driverId'] = this.driverId;
    data['routeId'] = this.routeId;
    data['isStartRoute'] = this.isStartRoute;
    data['isBreakPoint'] = this.isBreakPoint;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    data['breakTimeTo'] = this.breakTimeTo;
    data['routeStarted'] = this.routeStarted;
    data['breakTimeFrom'] = this.breakTimeFrom;
    data['diffToFrom'] = this.diffToFrom;
    data['title'] = this.title;
    data['address'] = this.address;
    return data;
  }
}

class DriverRoutePointList {
  int orderId;
  int driverId;
  int routeId;
  bool isStartRoute;
  bool isBreakPoint;
  dynamic latitude;
  dynamic longitude;
  String createdOn;
  String updatedOn;
  String breakTimeTo;
  String breakTimeFrom;
  String diffToFrom;
  String completeTime;
  String customerAddress;
  String customerName;
  int deliveryStatus;

  DriverRoutePointList({this.orderId, this.driverId, this.routeId, this.isStartRoute, this.isBreakPoint, this.latitude, this.longitude, this.createdOn, this.updatedOn, this.breakTimeTo, this.breakTimeFrom, this.completeTime, this.deliveryStatus, this.customerAddress, this.customerName, this.diffToFrom});

  DriverRoutePointList.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    driverId = json['driverId'];
    routeId = json['routeId'];
    isStartRoute = json['isStartRoute'];
    isBreakPoint = json['isBreakPoint'];
    latitude = json['latitude'] ?? 0.0;
    longitude = json['longitude'] ?? 0.0;
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    breakTimeTo = json['breakTimeTo'];
    breakTimeFrom = json['breakTimeFrom'];
    diffToFrom = json['diffToFrom'];
    completeTime = json['completeTime'];
    customerName = json['customerName'];
    customerAddress = json['customerAddress'];
    deliveryStatus = json['deliveryStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['driverId'] = this.driverId;
    data['routeId'] = this.routeId;
    data['isStartRoute'] = this.isStartRoute;
    data['isBreakPoint'] = this.isBreakPoint;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    data['breakTimeTo'] = this.breakTimeTo;
    data['breakTimeFrom'] = this.breakTimeFrom;
    data['diffToFrom'] = this.diffToFrom;
    data['customerName'] = this.customerName;
    data['completeTime'] = this.completeTime;
    data['deliveryStatus'] = this.deliveryStatus;
    data['customerAddress'] = this.customerAddress;
    return data;
  }
}

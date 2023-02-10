// @dart=2.9
// To parse this JSON data, do
//
//     final routeForPharmacy = routeForPharmacyFromJson(jsonString);

import 'dart:convert';

List<RouteForPharmacy> routeForPharmacyFromJson(String str) => List<RouteForPharmacy>.from(json.decode(str).map((x) => RouteForPharmacy.fromJson(x)));

String routeForPharmacyToJson(List<RouteForPharmacy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RouteForPharmacy {
  RouteForPharmacy({
    this.longitude,
    this.latitude,
    this.kmtom,
    this.isPharmacyAddress,
    this.deliveryStatus,
    this.deliveryStatusDec,
    this.customerName,
    this.customerAddress,
    this.completeTime,
  });

  dynamic longitude;
  dynamic latitude;
  dynamic kmtom;
  bool isPharmacyAddress;
  int deliveryStatus;
  String deliveryStatusDec;
  String customerAddress;
  String customerName;
  String completeTime;

  factory RouteForPharmacy.fromJson(Map<String, dynamic> json) => RouteForPharmacy(
        longitude: json["longitude"] ?? 0.0,
        latitude: json["latitude"] ?? 0.0,
        kmtom: json["kmtom"] ?? '',
        isPharmacyAddress: json["isPharmacyAddress"],
        deliveryStatus: json["deliveryStatus"] ?? 0,
        deliveryStatusDec: json["deliveryStatusDec"] ?? '',
        customerAddress: json["customerAddress"] ?? '',
        customerName: json["customerName"] ?? '',
        completeTime: json["completeTime"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
        "kmtom": kmtom,
        "isPharmacyAddress": isPharmacyAddress,
        "deliveryStatus": deliveryStatus,
        "deliveryStatusDec": deliveryStatusDec,
        "customerAddress": customerAddress,
        "customerName": customerName,
      };
}

// @dart=2.9
// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

List<DriverModel> driverModelFromJson(String str) => List<DriverModel>.from(json.decode(str).map((x) => DriverModel.fromJson(x)));

String driverModelToJson(List<DriverModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DriverModel {
  DriverModel({
    this.driverId,
    this.firstName,
    this.middleNmae,
    this.lastName,
    this.mobileNumber,
    this.emailId,
    this.routeId,
    this.route,
  });

  int driverId;
  String firstName;
  dynamic middleNmae;
  String lastName;
  dynamic mobileNumber;
  dynamic emailId;
  dynamic routeId;
  String route;

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        driverId: json["driverId"],
        firstName: json["firstName"],
        middleNmae: json["middleNmae"],
        lastName: json["lastName"],
        mobileNumber: json["mobileNumber"],
        emailId: json["emailId"],
        routeId: json["routeId"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
        "firstName": firstName,
        "middleNmae": middleNmae,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "emailId": emailId,
        "routeId": routeId,
        "route": route,
      };
}

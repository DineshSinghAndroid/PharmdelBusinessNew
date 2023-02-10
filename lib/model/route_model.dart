// @dart=2.9
import 'dart:convert';

RouteModel routeModelFromJson(String str) => RouteModel.fromJson(json.decode(str));

NursingHomeList nHomeModelFromJson(String str) => NursingHomeList.fromJson(json.decode(str));

String routeModelToJson(RouteModel data) => json.encode(data.toJson());

class RouteModel {
  RouteModel({
    this.routeList,
    this.pharmacyList,
    this.routeListAll,
    this.nHomeList,
    this.status,
    this.message,
  });

  List<RouteList> routeList;
  List<RouteList> routeListAll;
  List<PharmacyList> pharmacyList;
  List<NursingHomeList> nHomeList;
  bool status;
  String message;

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        routeList: List<RouteList>.from(json["routeList"].map((x) => RouteList.fromJson(x))),
        routeListAll: json["allRouteList"] != null ? List<RouteList>.from(json["allRouteList"].map((x) => RouteList.fromJson(x))) : null,
        pharmacyList: json["pharmacyList"] != null ? List<PharmacyList>.from(json["pharmacyList"].map((x) => PharmacyList.fromJson(x))) : [],
        nHomeList: json["nHomeList"] != null ? List<NursingHomeList>.from(json["nHomeList"].map((x) => NursingHomeList.fromJson(x))) : [],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "allRouteList": List<dynamic>.from(routeListAll.map((x) => x.toJson())),
        "routeList": List<dynamic>.from(routeList.map((x) => x.toJson())),
        "pharmacyList": List<dynamic>.from(pharmacyList.map((x) => x.toJson())),
        "nHomeList": List<dynamic>.from(nHomeList.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class RouteList {
  RouteList({
    this.routeId,
    this.routeName,
    this.isActive,
    this.companyId,
    this.branchId,
  });

  dynamic routeId;
  String routeName;
  int isActive;
  int companyId;
  int branchId;

  factory RouteList.fromJson(Map<String, dynamic> json) => RouteList(
        routeId: json["routeId"],
        routeName: json["routeName"],
        isActive: json["isActive"],
        companyId: json["companyId"],
        branchId: json["branchId"],
      );

  Map<String, dynamic> toJson() => {
        "routeId": routeId,
        "routeName": routeName,
        "isActive": isActive,
        "companyId": companyId,
        "branchId": branchId,
      };
}

class PharmacyList {
  PharmacyList({
    this.pharmacyId,
    this.pharmacyName,
    this.address,
    this.post_code,
    this.lat,
    this.lng,
  });

  dynamic pharmacyId;
  String pharmacyName;
  String address;
  String post_code;
  dynamic lat;
  dynamic lng;

  factory PharmacyList.fromJson(Map<String, dynamic> json) => PharmacyList(
        pharmacyId: json["pharmacyId"],
        pharmacyName: json["pharmacyName"],
        address: json["address"],
        post_code: json["post_code"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "pharmacyId": pharmacyId,
        "pharmacyName": pharmacyName,
        "address": address,
        "post_code": post_code,
        "lat": lat,
        "lng": lng,
      };
}

class NursingHomeList {
  NursingHomeList({
    this.id,
    this.nursing_home_name,
  });

  int id;
  String nursing_home_name;

  factory NursingHomeList.fromJson(Map<String, dynamic> json) => NursingHomeList(
        id: json["id"] != null ? int.tryParse(json["id"].toString()) : null,
        nursing_home_name: json["nursing_home_name"] != null ? json["nursing_home_name"].toString() : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nursing_home_name": nursing_home_name,
      };
}

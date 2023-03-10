class GetRouteListResponse {
  List<RouteList>? routeList;
  List<AllRouteList>? allRouteList;
  List<PharmacyList>? pharmacyList;
  List<NHomeList>? nHomeList;
  bool? status;
  String? message;
  bool? isOrderAvailable;
  String? vehicleInspection;
  String? vehicleId;

  GetRouteListResponse(
      {this.routeList,
        this.allRouteList,
        this.pharmacyList,
        this.nHomeList,
        this.status,
        this.message,
        this.isOrderAvailable,
        this.vehicleInspection,
        this.vehicleId});

  GetRouteListResponse.fromJson(Map<String, dynamic> json) {
    if (json['routeList'] != null) {
      routeList = <RouteList>[];
      json['routeList'].forEach((v) {
        routeList!.add(new RouteList.fromJson(v));
      });
    }
    if (json['allRouteList'] != null) {
      allRouteList = <AllRouteList>[];
      json['allRouteList'].forEach((v) {
        allRouteList!.add(new AllRouteList.fromJson(v));
      });
    }
    if (json['pharmacyList'] != null) {
      pharmacyList = <PharmacyList>[];
      json['pharmacyList'].forEach((v) {
        pharmacyList!.add(new PharmacyList.fromJson(v));
      });
    }
    if (json['nHomeList'] != null) {
      nHomeList = <NHomeList>[];
      json['nHomeList'].forEach((v) {
        nHomeList!.add(new NHomeList.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'] != null ? json['message'].toString():null;
    isOrderAvailable = json['isOrderAvailable'];
    vehicleInspection = json['vehicle_inspection'] != null ? json['vehicle_inspection'].toString():null;
    vehicleId = json['vehicle_id'] != null ? json['vehicle_id'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.routeList != null) {
      data['routeList'] = this.routeList!.map((v) => v.toJson()).toList();
    }
    if (this.allRouteList != null) {
      data['allRouteList'] = this.allRouteList!.map((v) => v.toJson()).toList();
    }
    if (this.pharmacyList != null) {
      data['pharmacyList'] = this.pharmacyList!.map((v) => v.toJson()).toList();
    }
    if (this.nHomeList != null) {
      data['nHomeList'] = this.nHomeList!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    data['isOrderAvailable'] = this.isOrderAvailable;
    data['vehicle_inspection'] = this.vehicleInspection;
    data['vehicle_id'] = this.vehicleId;
    return data;
  }
}

class RouteList {
  String? routeId;
  String? routeName;
  String? isActive;
  String? companyId;
  String? branchId;

  RouteList(
      {this.routeId,
        this.routeName,
        this.isActive,
        this.companyId,
        this.branchId});

  RouteList.fromJson(Map<String, dynamic> json) {
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    routeName = json['routeName'] != null ? json['routeName'].toString():null;
    isActive = json['isActive'] != null ? json['isActive'].toString():null;
    companyId = json['companyId'] != null ? json['companyId'].toString():null;
    branchId =  json['branchId'] != null ? json['branchId'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['routeId'] = this.routeId;
    data['routeName'] = this.routeName;
    data['isActive'] = this.isActive;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    return data;
  }
}

class AllRouteList {
  String? routeId;
  String? routeName;
  String? isActive;
  String? companyId;
  String? branchId;

  AllRouteList(
      {this.routeId,
        this.routeName,
        this.isActive,
        this.companyId,
        this.branchId});

  AllRouteList.fromJson(Map<String, dynamic> json) {
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    routeName = json['routeName'] != null ? json['routeName'].toString():null;
    isActive = json['isActive'] != null ? json['isActive'].toString():null;
    companyId = json['companyId'] != null ? json['companyId'].toString():null;
    branchId =  json['branchId'] != null ? json['branchId'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['routeId'] = this.routeId;
    data['routeName'] = this.routeName;
    data['isActive'] = this.isActive;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    return data;
  }
}

class PharmacyList {
  String? pharmacyId;
  String? pharmacyName;
  String? address;
  String? postCode;
  String? lat;
  String? lng;
  String? isPresCharge;
  String? isDelCharge;

  PharmacyList(
      {this.pharmacyId,
        this.pharmacyName,
        this.address,
        this.postCode,
        this.lat,
        this.lng,
        this.isPresCharge,
        this.isDelCharge});

  PharmacyList.fromJson(Map<String, dynamic> json) {
    pharmacyId = json['pharmacyId'] != null ? json['pharmacyId'].toString():null;
    pharmacyName = json['pharmacyName'] != null ? json['pharmacyName'].toString():null;
    address = json['address'] != null ? json['address'].toString():null;
    postCode = json['post_code'] != null ? json['post_code'].toString():null;
    lat = json['lat'] != null ? json['lat'].toString():null;
    lng = json['lng'] != null ? json['lng'].toString():null;
    isPresCharge = json['is_pres_charge'] != null ? json['is_pres_charge'].toString():null;
    isDelCharge = json['is_del_charge'] != null ? json['is_del_charge'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pharmacyId'] = this.pharmacyId;
    data['pharmacyName'] = this.pharmacyName;
    data['address'] = this.address;
    data['post_code'] = this.postCode;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['is_pres_charge'] = this.isPresCharge;
    data['is_del_charge'] = this.isDelCharge;
    return data;
  }
}

class NHomeList {
  String? id;
  String? nursingHomeName;

  NHomeList({this.id, this.nursingHomeName});

  NHomeList.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    nursingHomeName = json['nursing_home_name'] != null ? json['nursing_home_name'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nursing_home_name'] = this.nursingHomeName;
    return data;
  }
}

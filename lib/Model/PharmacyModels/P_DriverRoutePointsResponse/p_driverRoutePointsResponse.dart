class DriverRoutePointsApiResponse {
  List<DriverRoutePointList>? driverRoutePointList;
  List<DriverRouteLocations>? driverRouteLocations;
  String? driverRouteBreakPointList;
  String? driverId;
  String? pharmacyId;
  String? routeId;
  String? isStartRoute;
  String? isBreakPoint;
  String? title;
  String? address;
  String? latitude;
  String? longitude;
  String? createdOn;
  String? updatedOn;
  String? breakTimeTo;
  String? breakTimeFrom;
  String? diffToFrom;
  bool? routeStarted;
  EndRoutePoint? endRoutePoint;

  DriverRoutePointsApiResponse(
      {this.driverRoutePointList,
      this.driverRouteLocations,
      this.driverRouteBreakPointList,
      this.driverId,
      this.pharmacyId,
      this.routeId,
      this.isStartRoute,
      this.isBreakPoint,
      this.title,
      this.address,
      this.latitude,
      this.longitude,
      this.createdOn,
      this.updatedOn,
      this.breakTimeTo,
      this.breakTimeFrom,
      this.diffToFrom,
      this.routeStarted,
      this.endRoutePoint});

  DriverRoutePointsApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['driverRoutePointList'] != null) {
      driverRoutePointList = <DriverRoutePointList>[];
      json['driverRoutePointList'].forEach((v) {
        driverRoutePointList!.add(new DriverRoutePointList.fromJson(v));
      });
    }
    if (json['driverRouteLocations'] != null) {
      driverRouteLocations = <DriverRouteLocations>[];
      json['driverRouteLocations'].forEach((v) {
        driverRouteLocations!.add(new DriverRouteLocations.fromJson(v));
      });
    }
    driverRouteBreakPointList = json['driverRouteBreakPointList'] != null ? json['driverRouteBreakPointList'].toString():null;
    driverId = json['driverId'] != null ? json['driverId'].toString():null;
    pharmacyId = json['pharmacyId'] != null ? json['pharmacyId'].toString():null;
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    isStartRoute = json['isStartRoute'] != null ? json['isStartRoute'].toString():null;
    isBreakPoint = json['isBreakPoint'] != null ? json['isBreakPoint'].toString():null;
    title = json['title'] != null ? json['title'].toString():null;
    address = json['address'] != null ? json['address'].toString():null;
    latitude = json['latitude'] != null ? json['latitude'].toString():null;
    longitude = json['longitude'] != null ? json['longitude'].toString():null;
    createdOn = json['createdOn'] != null ? json['createdOn'].toString():null;
    updatedOn = json['updatedOn'] != null ? json['updatedOn'].toString():null;
    breakTimeTo = json['breakTimeTo'] != null ? json['breakTimeTo'].toString():null;
    breakTimeFrom = json['breakTimeFrom'] != null ? json['breakTimeFrom'].toString():null;
    diffToFrom = json['diffToFrom'] != null ? json['diffToFrom'].toString():null;
    routeStarted = json['routeStarted'];
    endRoutePoint = json['endRoutePoint'] != null
        ? new EndRoutePoint.fromJson(json['endRoutePoint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.driverRoutePointList != null) {
      data['driverRoutePointList'] =
          this.driverRoutePointList!.map((v) => v.toJson()).toList();
    }
    if (this.driverRouteLocations != null) {
      data['driverRouteLocations'] =
          this.driverRouteLocations!.map((v) => v.toJson()).toList();
    }
    data['driverRouteBreakPointList'] = this.driverRouteBreakPointList;
    data['driverId'] = this.driverId;
    data['pharmacyId'] = this.pharmacyId;
    data['routeId'] = this.routeId;
    data['isStartRoute'] = this.isStartRoute;
    data['isBreakPoint'] = this.isBreakPoint;
    data['title'] = this.title;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    data['breakTimeTo'] = this.breakTimeTo;
    data['breakTimeFrom'] = this.breakTimeFrom;
    data['diffToFrom'] = this.diffToFrom;
    data['routeStarted'] = this.routeStarted;
    if (this.endRoutePoint != null) {
      data['endRoutePoint'] = this.endRoutePoint!.toJson();
    }
    return data;
  }
}

class DriverRoutePointList {
  String? orderId;
  String? driverId;
  String? routeId;
  bool? isStartRoute;
  bool? isBreakPoint;
  double? latitude;
  double? longitude;
  String? createdOn;
  String? completeTime;
  String? deliveryStatus;
  String? customerName;
  String? customerAddress;
  String? isCronCreated;
  String? breakTimeTo;
  String? breakTimeFrom;
  String? diffToFrom;

  DriverRoutePointList(
      {this.orderId,
      this.driverId,
      this.routeId,
      this.isStartRoute,
      this.isBreakPoint,
      this.latitude,
      this.longitude,
      this.createdOn,
      this.completeTime,
      this.deliveryStatus,
      this.customerName,
      this.customerAddress,
      this.isCronCreated,
      this.breakTimeTo,
      this.breakTimeFrom,
      this.diffToFrom});

  DriverRoutePointList.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'] != null ? json['orderId'].toString():null;
    driverId = json['orddriverIderId'] != null ? json['driverId'].toString():null;
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    isStartRoute = json['isStartRoute'];
    isBreakPoint = json['isBreakPoint'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdOn = json['createdOn'] != null ? json['createdOn'].toString():null;
    completeTime = json['completeTime'] != null ? json['completeTime'].toString():null;
    deliveryStatus = json['deliveryStatus'] != null ? json['deliveryStatus'].toString():null;
    customerName = json['customerName'] != null ? json['customerName'].toString():null;
    customerAddress = json['customerAddress'] != null ? json['customerAddress'].toString():null;
    isCronCreated = json['isCronCreated'] != null ? json['isCronCreated'].toString():null;
    breakTimeTo = json['breakTimeTo'] != null ? json['breakTimeTo'].toString():null;
    breakTimeFrom = json['breakTimeFrom'] != null ? json['breakTimeFrom'].toString():null;
    diffToFrom = json['diffToFrom'] != null ? json['diffToFrom'].toString():null;
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
    data['completeTime'] = this.completeTime;
    data['deliveryStatus'] = this.deliveryStatus;
    data['customerName'] = this.customerName;
    data['customerAddress'] = this.customerAddress;
    data['isCronCreated'] = this.isCronCreated;
    data['breakTimeTo'] = this.breakTimeTo;
    data['breakTimeFrom'] = this.breakTimeFrom;
    data['diffToFrom'] = this.diffToFrom;
    return data;
  }
}

class DriverRouteLocations {
  String? id;
  String? driverid;
  String? pharmacyid;
  String? routeid;
  String? latitude;
  String? longitude;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  DriverRouteLocations(
      {this.id,
      this.driverid,
      this.pharmacyid,
      this.routeid,
      this.latitude,
      this.longitude,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  DriverRouteLocations.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    driverid = json['driverid'] != null ? json['driverid'].toString():null;
    pharmacyid = json['pharmacyid'] != null ? json['pharmacyid'].toString():null;
    routeid = json['routeid'] != null ? json['routeid'].toString():null;
    latitude = json['latitude'] != null ? json['latitude'].toString():null;
    longitude = json['longitude'] != null ? json['longitude'].toString():null;
    deletedAt = json['deleted_at'] != null ? json['deleted_at'].toString():null;
    createdAt = json['created_at'] != null ? json['created_at'].toString():null;
    updatedAt = json['updated_at'] != null ? json['updated_at'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driverid'] = this.driverid;
    data['pharmacyid'] = this.pharmacyid;
    data['routeid'] = this.routeid;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class EndRoutePoint {
  String? lat;
  String? lng;
  String? driverName;
  String? endRouteAddress;

  EndRoutePoint({this.lat, this.lng, this.driverName, this.endRouteAddress});

  EndRoutePoint.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] != null ? json['lat'].toString():null;
    lng = json['lng'] != null ? json['lng'].toString():null;
    driverName =json['driver_name'] != null ? json['driver_name'].toString():null;
    endRouteAddress = json['end_route_address'] != null ? json['end_route_address'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['driver_name'] = this.driverName;
    data['end_route_address'] = this.endRouteAddress;
    return data;
  }
}

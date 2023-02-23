class DriverDashboardApiresponse {
  bool? status;
  String? pageNumber;
  String? pageSize;
  String? totalRecords;
  OrderCounts? orderCounts;
  bool? isStart;
  String? message;
  bool? isOrderAvailable;
  CheckUpdateApp? checkUpdateApp;
  String? notificationCount;
  List<Exemptions>? exemptions;
  String? onLunch;

  DriverDashboardApiresponse(
      {
      this.status,
      this.pageNumber,
      this.pageSize,
      this.totalRecords,
      this.orderCounts,
      this.isStart,
      this.message,
      this.isOrderAvailable,
      this.checkUpdateApp,
      this.notificationCount,
      this.exemptions,
      this.onLunch});

  DriverDashboardApiresponse.fromJson(Map<String, dynamic> json) {
    // if (json['deliveryList'] != null) {
    //   deliveryList = <Null>[];
    //   json['deliveryList'].forEach((v) {
    //     deliveryList!.add(Null.fromJson(v));
    //   });
    // }
    status = json['status'];
    pageNumber = json['pageNumber'] != null ? json['pageNumber'].toString():null;
    pageSize = json['pageSize'] != null ? json['pageSize'].toString():null;
    totalRecords = json['totalRecords'] != null ? json['totalRecords'].toString():null;
    orderCounts = json['orderCounts'] != null
        ? OrderCounts.fromJson(json['orderCounts'])
        : null;
    isStart = json['isStart'];
    message = json['message'] != null ? json['message'].toString():null;
    isOrderAvailable = json['isOrderAvailable'];
    checkUpdateApp = json['checkUpdateApp'] != null
        ? CheckUpdateApp.fromJson(json['checkUpdateApp'])
        : null;
    notificationCount = json['notification_count'] != null ? json['notification_count'].toString():null;
    if (json['exemptions'] != null) {
      exemptions = <Exemptions>[];
      json['exemptions'].forEach((v) {
        exemptions!.add(Exemptions.fromJson(v));
      });
    }
    onLunch = json['on_lunch'] != null ? json['on_lunch'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (this.deliveryList != null) {
    //   data['deliveryList'] = this.deliveryList!.map((v) => v.toJson()).toList();
    // }
    data['status'] = this.status;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    if (this.orderCounts != null) {
      data['orderCounts'] = this.orderCounts!.toJson();
    }
    data['isStart'] = this.isStart;
    data['message'] = this.message;
    data['isOrderAvailable'] = this.isOrderAvailable;
    if (this.checkUpdateApp != null) {
      data['checkUpdateApp'] = this.checkUpdateApp!.toJson();
    }
    data['notification_count'] = this.notificationCount;
    if (this.exemptions != null) {
      data['exemptions'] = this.exemptions!.map((v) => v.toJson()).toList();
    }
    data['on_lunch'] = this.onLunch;
    return data;
  }
}

class OrderCounts {
  String? totalOrders;
  String? pendingOrders;
  String? outForDeliveryOrders;
  String? deliveredOrders;
  String? faildOrders;
  String? pickedupOrders;
  String? receviedOrders;
  String? todayTotalOrders;

  OrderCounts(
      {this.totalOrders,
      this.pendingOrders,
      this.outForDeliveryOrders,
      this.deliveredOrders,
      this.faildOrders,
      this.pickedupOrders,
      this.receviedOrders,
      this.todayTotalOrders});

  OrderCounts.fromJson(Map<String, dynamic> json) {
    totalOrders = json['totalOrders'] != null ? json['totalOrders'].toString():null;
    pendingOrders = json['pendingOrders'] != null ? json['pendingOrders'].toString():null;
    outForDeliveryOrders = json['outForDeliveryOrders'] != null ? json['outForDeliveryOrders'].toString():null;
    deliveredOrders = json['deliveredOrders'] != null ? json['deliveredOrders'].toString():null;
    faildOrders = json['faildOrders'] != null ? json['faildOrders'].toString():null;
    pickedupOrders = json['pickedupOrders'] != null ? json['pickedupOrders'].toString():null;
    receviedOrders = json['receviedOrders'] != null ? json['receviedOrders'].toString():null;
    todayTotalOrders = json['todayTotalOrders'] != null ? json['todayTotalOrders'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalOrders'] = this.totalOrders;
    data['pendingOrders'] = this.pendingOrders;
    data['outForDeliveryOrders'] = this.outForDeliveryOrders;
    data['deliveredOrders'] = this.deliveredOrders;
    data['faildOrders'] = this.faildOrders;
    data['pickedupOrders'] = this.pickedupOrders;
    data['receviedOrders'] = this.receviedOrders;
    data['todayTotalOrders'] = this.todayTotalOrders;
    return data;
  }
}

class CheckUpdateApp {
  String? appVersion;
  String? message;
  String? forceUpdate;
  String? iosAppVersion;
  String? iosMessage;
  String? iosForceUpdate;

  CheckUpdateApp(
      {this.appVersion,
      this.message,
      this.forceUpdate,
      this.iosAppVersion,
      this.iosMessage,
      this.iosForceUpdate});

  CheckUpdateApp.fromJson(Map<String, dynamic> json) {
    appVersion = json['app_version'] != null ? json['app_version'].toString():null;
    message = json['message'] != null ? json['message'].toString():null;
    forceUpdate = json['force_update'] != null ? json['force_update'].toString():null;
    iosAppVersion = json['ios_app_version'] != null ? json['ios_app_version'].toString():null;
    iosMessage = json['ios_message'] != null ? json['ios_message'].toString():null;
    iosForceUpdate = json['ios_force_update'] != null ? json['ios_force_update'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_version'] = this.appVersion;
    data['message'] = this.message;
    data['force_update'] = this.forceUpdate;
    data['ios_app_version'] = this.iosAppVersion;
    data['ios_message'] = this.iosMessage;
    data['ios_force_update'] = this.iosForceUpdate;
    return data;
  }
}

class Exemptions {
  String? id;
  String? serialId;
  String? code;

  Exemptions({this.id, this.serialId, this.code});

  Exemptions.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    serialId = json['serial_id'] != null ? json['serial_id'].toString():null;
    code = json['code'] != null ? json['code'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serial_id'] = this.serialId;
    data['code'] = this.code;
    return data;
  }
}

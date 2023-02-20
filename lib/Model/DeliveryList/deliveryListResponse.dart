// class DeliveryListApiResponse {
//   List<Null>? deliveryList;
//   bool? status;
//   int? pageNumber;
//   int? pageSize;
//   int? totalRecords;
//   OrderCounts? orderCounts;
//   bool? isStart;
//   String? message;
//   bool? isOrderAvailable;
//   CheckUpdateApp? checkUpdateApp;
//   int? notificationCount;
//   List<Exemptions>? exemptions;
//   int? onLunch;

//   DeliveryListApiResponse(
//       {this.deliveryList,
//       this.status,
//       this.pageNumber,
//       this.pageSize,
//       this.totalRecords,
//       this.orderCounts,
//       this.isStart,
//       this.message,
//       this.isOrderAvailable,
//       this.checkUpdateApp,
//       this.notificationCount,
//       this.exemptions,
//       this.onLunch});

//   DeliveryListApiResponse.fromJson(Map<String, dynamic> json) {
//     if (json['deliveryList'] != null) {
//       deliveryList = <Null>[];
//       json['deliveryList'].forEach((v) {
//         deliveryList!.add(new Null.fromJson(v));
//       });
//     }
//     status = json['status'];
//     pageNumber = json['pageNumber'];
//     pageSize = json['pageSize'];
//     totalRecords = json['totalRecords'];
//     orderCounts = json['orderCounts'] != null
//         ? new OrderCounts.fromJson(json['orderCounts'])
//         : null;
//     isStart = json['isStart'];
//     message = json['message'];
//     isOrderAvailable = json['isOrderAvailable'];
//     checkUpdateApp = json['checkUpdateApp'] != null
//         ? new CheckUpdateApp.fromJson(json['checkUpdateApp'])
//         : null;
//     notificationCount = json['notification_count'];
//     if (json['exemptions'] != null) {
//       exemptions = <Exemptions>[];
//       json['exemptions'].forEach((v) {
//         exemptions!.add(new Exemptions.fromJson(v));
//       });
//     }
//     onLunch = json['on_lunch'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.deliveryList != null) {
//       data['deliveryList'] = this.deliveryList!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = this.status;
//     data['pageNumber'] = this.pageNumber;
//     data['pageSize'] = this.pageSize;
//     data['totalRecords'] = this.totalRecords;
//     if (this.orderCounts != null) {
//       data['orderCounts'] = this.orderCounts!.toJson();
//     }
//     data['isStart'] = this.isStart;
//     data['message'] = this.message;
//     data['isOrderAvailable'] = this.isOrderAvailable;
//     if (this.checkUpdateApp != null) {
//       data['checkUpdateApp'] = this.checkUpdateApp!.toJson();
//     }
//     data['notification_count'] = this.notificationCount;
//     if (this.exemptions != null) {
//       data['exemptions'] = this.exemptions!.map((v) => v.toJson()).toList();
//     }
//     data['on_lunch'] = this.onLunch;
//     return data;
//   }
// }

// class OrderCounts {
//   int? totalOrders;
//   int? pendingOrders;
//   int? outForDeliveryOrders;
//   int? deliveredOrders;
//   int? faildOrders;
//   int? pickedupOrders;
//   int? receviedOrders;
//   int? todayTotalOrders;

//   OrderCounts(
//       {this.totalOrders,
//       this.pendingOrders,
//       this.outForDeliveryOrders,
//       this.deliveredOrders,
//       this.faildOrders,
//       this.pickedupOrders,
//       this.receviedOrders,
//       this.todayTotalOrders});

//   OrderCounts.fromJson(Map<String, dynamic> json) {
//     totalOrders = json['totalOrders'];
//     pendingOrders = json['pendingOrders'];
//     outForDeliveryOrders = json['outForDeliveryOrders'];
//     deliveredOrders = json['deliveredOrders'];
//     faildOrders = json['faildOrders'];
//     pickedupOrders = json['pickedupOrders'];
//     receviedOrders = json['receviedOrders'];
//     todayTotalOrders = json['todayTotalOrders'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['totalOrders'] = this.totalOrders;
//     data['pendingOrders'] = this.pendingOrders;
//     data['outForDeliveryOrders'] = this.outForDeliveryOrders;
//     data['deliveredOrders'] = this.deliveredOrders;
//     data['faildOrders'] = this.faildOrders;
//     data['pickedupOrders'] = this.pickedupOrders;
//     data['receviedOrders'] = this.receviedOrders;
//     data['todayTotalOrders'] = this.todayTotalOrders;
//     return data;
//   }
// }

// class CheckUpdateApp {
//   String? appVersion;
//   String? message;
//   String? forceUpdate;
//   String? iosAppVersion;
//   String? iosMessage;
//   String? iosForceUpdate;

//   CheckUpdateApp(
//       {this.appVersion,
//       this.message,
//       this.forceUpdate,
//       this.iosAppVersion,
//       this.iosMessage,
//       this.iosForceUpdate});

//   CheckUpdateApp.fromJson(Map<String, dynamic> json) {
//     appVersion = json['app_version'];
//     message = json['message'];
//     forceUpdate = json['force_update'];
//     iosAppVersion = json['ios_app_version'];
//     iosMessage = json['ios_message'];
//     iosForceUpdate = json['ios_force_update'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['app_version'] = this.appVersion;
//     data['message'] = this.message;
//     data['force_update'] = this.forceUpdate;
//     data['ios_app_version'] = this.iosAppVersion;
//     data['ios_message'] = this.iosMessage;
//     data['ios_force_update'] = this.iosForceUpdate;
//     return data;
//   }
// }

// class Exemptions {
//   int? id;
//   String? serialId;
//   String? code;

//   Exemptions({this.id, this.serialId, this.code});

//   Exemptions.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     serialId = json['serial_id'];
//     code = json['code'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['serial_id'] = this.serialId;
//     data['code'] = this.code;
//     return data;
//   }
// }

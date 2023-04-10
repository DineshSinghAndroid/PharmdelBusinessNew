class NursingOrderApiResponse {
  List<NursingOrdersData>? nursingOrderData;
  String? status;
  String? message;
  bool? isRouteStarted;
  String? isOrderAvailable;

  NursingOrderApiResponse({this.nursingOrderData, this.status, this.message, this.isRouteStarted, this.isOrderAvailable});

  NursingOrderApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      nursingOrderData = <NursingOrdersData>[];
      json['list'].forEach((v) {
        nursingOrderData!.add(new NursingOrdersData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
    isRouteStarted = json['isRouteStarted'];
    isOrderAvailable = json['isOrderAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nursingOrderData != null) {
      data['list'] = this.nursingOrderData!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    data['isRouteStarted'] = this.isRouteStarted;
    data['isOrderAvailable'] = this.isOrderAvailable;
    return data;
  }
}

class NursingOrdersData {
  String? orderId;
  String? customerName;
  String? address;
  String? deliveryStatus;
  String? deliveryStatusDesc;
  String? deliveryDate;
  String? customerMobileNumber;
  String? isStorageFridge;
  String? isControlledDrugs;
  String? routeName;

  NursingOrdersData({this.orderId, this.customerName, this.address, this.deliveryStatus, this.deliveryStatusDesc, this.deliveryDate, this.customerMobileNumber, this.isStorageFridge, this.isControlledDrugs, this.routeName});

  NursingOrdersData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'] != null ? json['orderId'].toString() : null;
    customerName = json['customerName'] != null ? json['customerName'].toString() : null;
    address = json['address'] != null ? json['address'].toString() : null;
    deliveryStatus = json['deliveryStatus'] != null ? json['deliveryStatus'].toString() : null;
    deliveryStatusDesc = json['deliveryStatusDesc'] != null ? json['deliveryStatusDesc'].toString() : null;
    deliveryDate = json['deliveryDate'] != null ? json['deliveryDate'].toString() : null;
    customerMobileNumber = json['customerMobileNumber'] != null ? json['customerMobileNumber'].toString() : null;
    isStorageFridge = json['isStorageFridge'] != null ? json['isStorageFridge'].toString() : null;
    isControlledDrugs = json['isControlledDrugs'] != null ? json['isControlledDrugs'].toString() : null;
    routeName = json['route_name'] != null ? json['route_name'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['customerName'] = this.customerName;
    data['address'] = this.address;
    data['deliveryStatus'] = this.deliveryStatus;
    data['deliveryStatusDesc'] = this.deliveryStatusDesc;
    data['deliveryDate'] = this.deliveryDate;
    data['customerMobileNumber'] = this.customerMobileNumber;
    data['isStorageFridge'] = this.isStorageFridge;
    data['isControlledDrugs'] = this.isControlledDrugs;
    data['route_name'] = this.routeName;
    return data;
  }
}

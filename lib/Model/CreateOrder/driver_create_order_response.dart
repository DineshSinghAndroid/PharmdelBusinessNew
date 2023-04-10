class DriverCreateOrderApiResponse {
  bool? error;
  String? message;
  DriverCreateOrderData? data;

  DriverCreateOrderApiResponse({this.error, this.message, this.data});

  DriverCreateOrderApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new DriverCreateOrderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DriverCreateOrderData {
  String? orderInfo;

  DriverCreateOrderData({this.orderInfo});

  DriverCreateOrderData.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null ? json['orderInfo'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderInfo'] = this.orderInfo;
    return data;
  }
}

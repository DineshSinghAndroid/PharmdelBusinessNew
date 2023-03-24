class CreateOrderApiResponse {
  bool? error;
  String? message;
  OrderData? data;

  CreateOrderApiResponse({this.error, this.message, this.data});

  CreateOrderApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
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

class OrderData {
  String? orderInfo;

  OrderData({this.orderInfo});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null ? json['orderInfo'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderInfo'] = this.orderInfo;
    return data;
  }
}

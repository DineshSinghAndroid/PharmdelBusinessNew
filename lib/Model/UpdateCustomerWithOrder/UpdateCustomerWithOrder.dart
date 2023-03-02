class UpdateCustomerWithOrderModel {
  bool? error;
  String? message;
  Data? data;

  UpdateCustomerWithOrderModel({this.error, this.message, this.data});

  UpdateCustomerWithOrderModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? orderInfo;

  Data({this.orderInfo});

  Data.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderInfo'] = this.orderInfo;
    return data;
  }
}

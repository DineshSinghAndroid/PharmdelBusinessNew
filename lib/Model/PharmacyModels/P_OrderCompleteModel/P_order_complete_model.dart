class P_OrderCompleteModel {
  bool? status;
  String? message;

  P_OrderCompleteModel({this.status, this.message});

  P_OrderCompleteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

// @dart=2.9

class DeliveryModel {
  final String status;
  final String mobile;
  final String list;

  DeliveryModel({this.status, this.mobile, this.list});

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      status: json['status'],
      mobile: json['mobile'],
    );
  }
}

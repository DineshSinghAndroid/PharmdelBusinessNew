class NotificationCountApiResponse {
  String? list;
  bool? status;
  String? message;

  NotificationCountApiResponse({this.list, this.status, this.message});

  NotificationCountApiResponse.fromJson(Map<String, dynamic> json) {
    list = json['list'] != null ? json['list'].toString():null;
    status = json['status'];
    message = json['message'] != null ? json['message'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list'] = this.list;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class NotificationApiResponse {
  List<NotificationData>? data;
  bool? status;
  String? message;

  NotificationApiResponse({this.data, this.status, this.message});

  NotificationApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      data = <NotificationData>[];
      json['list'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['list'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class NotificationData {
  String? id;
  String? name;
  String? message;
  String? created;

  NotificationData({this.id, this.name, this.message, this.created});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = id = json['id'] != null ? json['id'].toString():null;
    name = id = json['name'] != null ? json['name'].toString():null;
    message = id = json['message'] != null ? json['message'].toString():null;
    created = id = json['created'] != null ? json['created'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['message'] = this.message;
    data['created'] = this.created;
    return data;
  }
}

// @dart=2.9

class NotificationBean {
  List<NotificationList> list;
  bool status;
  String message;

  NotificationBean({this.list, this.status, this.message});

  NotificationBean.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list.add(new NotificationList.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class NotificationList {
  int id;
  String name;
  String message;
  String created = "22-10-2021 12:10";

  NotificationList({this.id, this.name, this.message, this.created});

  NotificationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    created = json['created'] != null ? json['created'] : "22-10-2021 12:10";
    message = json['message'];
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

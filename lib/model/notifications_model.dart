// @dart=2.9
class NotificationsResponse {
  List<Notifications> notifications;
  bool status;
  int pageNumber;
  int pageSize;
  int totalRecords;
  String message;

  NotificationsResponse({this.notifications, this.status, this.pageNumber, this.pageSize, this.totalRecords, this.message});

  NotificationsResponse.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = new List<Notifications>();
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
    status = json['status'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] = this.notifications.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    data['message'] = this.message;
    return data;
  }
}

class Notifications {
  String name;
  String user;
  String type;
  String dateAdded;
  String message;

  Notifications({this.name, this.user, this.type, this.dateAdded});

  Notifications.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    user = json['user'];
    type = json['type'];
    dateAdded = json['date_added'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user'] = this.user;
    data['type'] = this.type;
    data['date_added'] = this.dateAdded;
    data['message'] = this.message;
    return data;
  }
}

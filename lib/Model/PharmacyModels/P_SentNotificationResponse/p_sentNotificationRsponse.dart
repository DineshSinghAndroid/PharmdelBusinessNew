class SentNotificationApiResponse {
  List<SentNotificationData>? sentNotificationData;
  bool? status;
  String? pageNumber;
  String? pageSize;
  String? totalRecords;
  String? message;

  SentNotificationApiResponse(
      {this.sentNotificationData,
      this.status,
      this.pageNumber,
      this.pageSize,
      this.totalRecords,
      this.message});

  SentNotificationApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      sentNotificationData = <SentNotificationData>[];
      json['notifications'].forEach((v) {
        sentNotificationData!.add(new SentNotificationData.fromJson(v));
      });
    }
    status = json['status'];
    pageNumber = json['pageNumber'] != null ? json['pageNumber'].toString():null;
    pageSize = json['pageSize'] != null ? json['pageSize'].toString():null;
    totalRecords = json['totalRecords'] != null ? json['totalRecords'].toString():null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sentNotificationData != null) {
      data['notifications'] =
          this.sentNotificationData!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRecords'] = this.totalRecords;
    data['message'] = this.message;
    return data;
  }
}

class SentNotificationData {
  String? name;
  String? message;
  String? user;
  String? type;
  String? dateAdded;

  SentNotificationData(
      {this.name, this.message, this.user, this.type, this.dateAdded});

  SentNotificationData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    message = json['message'];
    user = json['user'];
    type = json['type'];
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['message'] = this.message;
    data['user'] = this.user;
    data['type'] = this.type;
    data['date_added'] = this.dateAdded;
    return data;
  }
}

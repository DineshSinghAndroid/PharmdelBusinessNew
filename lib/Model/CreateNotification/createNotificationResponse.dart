class CreateNotificationApiResponse {
  CreateNotificationData? data;
  bool? status;
  String? message;

  CreateNotificationApiResponse({this.data, this.status, this.message});

  CreateNotificationApiResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CreateNotificationData.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class CreateNotificationData {
  List<StaffManagerInfo>? staffManagerInfo;
  List<StaffList>? staffList;

  CreateNotificationData({this.staffManagerInfo, this.staffList});

  CreateNotificationData.fromJson(Map<String, dynamic> json) {
    if (json['staff_manager_info'] != null) {
      staffManagerInfo = <StaffManagerInfo>[];
      json['staff_manager_info'].forEach((v) {
        staffManagerInfo!.add(new StaffManagerInfo.fromJson(v));
      });
    }
    if (json['staff_list'] != null) {
      staffList = <StaffList>[];
      json['staff_list'].forEach((v) {
        staffList!.add(new StaffList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.staffManagerInfo != null) {
      data['staff_manager_info'] =
          this.staffManagerInfo!.map((v) => v.toJson()).toList();
    }
    if (this.staffList != null) {
      data['staff_list'] = this.staffList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffManagerInfo {
  String? id;
  String? name;
  String? email;
  String? role;

  StaffManagerInfo({this.id, this.name, this.email, this.role});

  StaffManagerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    role = json['role'] != null ? json['role'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}

class StaffList {
  String? name;
  String? userId;
  String? role;

  StaffList({this.name, this.userId, this.role});

  StaffList.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? json['name'].toString():null;
    userId = json['user_id'] != null ? json['user_id'].toString():null;
    role = json['role'] != null ? json['role'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['role'] = this.role;
    return data;
  }
}

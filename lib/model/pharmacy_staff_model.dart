// @dart=2.9
class PharmacyStaffResponse {
  Data data;
  bool status;
  String message;

  PharmacyStaffResponse({this.data, this.status, this.message});

  PharmacyStaffResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<StaffManagerInfo> staffManagerInfo;
  List<StaffList> staffList;

  Data({this.staffManagerInfo, this.staffList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['staff_manager_info'] != null) {
      staffManagerInfo = new List<StaffManagerInfo>();
      json['staff_manager_info'].forEach((v) {
        staffManagerInfo.add(new StaffManagerInfo.fromJson(v));
      });
    }
    if (json['staff_list'] != null) {
      staffList = new List<StaffList>();
      json['staff_list'].forEach((v) {
        staffList.add(new StaffList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.staffManagerInfo != null) {
      data['staff_manager_info'] = this.staffManagerInfo.map((v) => v.toJson()).toList();
    }
    if (this.staffList != null) {
      data['staff_list'] = this.staffList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffManagerInfo {
  int id;
  String name;
  String email;
  String role;

  StaffManagerInfo({this.id, this.name, this.email, this.role});

  StaffManagerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
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
  String name;
  int userId;
  String role;

  StaffList({this.name, this.userId, this.role});

  StaffList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userId = json['user_id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['role'] = this.role;
    return data;
  }
}

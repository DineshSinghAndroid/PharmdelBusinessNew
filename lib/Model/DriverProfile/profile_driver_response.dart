class DriverProfileApiResponse {
  String? status;
  DriverProfileData? data;
  String? userManual;

  DriverProfileApiResponse({this.status, this.data, this.userManual});

  DriverProfileApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? json['status'].toString():null;
    data = json['driverProfile'] != null
        ? DriverProfileData.fromJson(json['driverProfile'])
        : null;
    userManual = json['user_manual'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['driverProfile'] = this.data!.toJson();
    }
    data['user_manual'] = this.userManual;
    return data;
  }
}

class DriverProfileData {
  String? firstName;
  String? middleName;
  String? lastName;
  String? addressLine1;
  String? addressLine2;
  String? townName;
  String? postCode;
  String? mobileNumber;
  String? emailId;

  DriverProfileData(
      {this.firstName,
      this.middleName,
      this.lastName,
      this.addressLine1,
      this.addressLine2,
      this.townName,
      this.postCode,
      this.mobileNumber,
      this.emailId});

  DriverProfileData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'] != null ? json['firstName'].toString():null;
    middleName = json['middleName'] != null ? json['middleName'].toString():null;
    lastName = json['lastName'] != null ? json['lastName'].toString():null;
    addressLine1 = json['address_line_1'] != null ? json['address_line_1'].toString():null;
    addressLine2 = json['address_line_2'] != null ? json['address_line_2'].toString():null;
    townName = json['town_name'] != null ? json['town_name'].toString():null;
    postCode = json['post_code'] != null ? json['post_code'].toString():null;
    mobileNumber = json['mobileNumber'] != null ? json['mobileNumber'].toString():null;
    emailId = json['emailId'] != null ? json['emailId'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['town_name'] = this.townName;
    data['post_code'] = this.postCode;
    data['mobileNumber'] = this.mobileNumber;
    data['emailId'] = this.emailId;
    return data;
  }
}

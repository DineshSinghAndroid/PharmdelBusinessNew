class PharmacyProfileApiResponse {
  String? status;
  DriverProfileData? driverProfiledata;

  PharmacyProfileApiResponse({this.status, this.driverProfiledata});

  PharmacyProfileApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    driverProfiledata = json['driverProfile'] != null
        ? new DriverProfileData.fromJson(json['driverProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.driverProfiledata != null) {
      data['driverProfile'] = this.driverProfiledata!.toJson();
    }
    return data;
  }
}

class DriverProfileData {
  String? firstName;
  String? middleName;
  String? lastName;
  String? pharmacyName;
  String? mobileNumber;
  String? emailId;
  String? scanType;
  String? isPresCharge;
  String? isDelCharge;

  DriverProfileData(
      {this.firstName,
      this.middleName,
      this.lastName,
      this.pharmacyName,
      this.mobileNumber,
      this.emailId,
      this.scanType,
      this.isPresCharge,
      this.isDelCharge});

  DriverProfileData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'] != null ? json['firstName'].toString():null;
    middleName = json['middleName'] != null ? json['middleName'].toString():null;
    lastName = json['lastName'] != null ? json['lastName'].toString():null;
    pharmacyName = json['pharmacy_name'] != null ? json['pharmacy_name'].toString():null;
    mobileNumber = json['mobileNumber'] != null ? json['mobileNumber'].toString():null;
    emailId = json['emailId'] != null ? json['emailId'].toString():null;
    scanType = json['scan_type'] != null ? json['scan_type'].toString():null;
    isPresCharge = json['is_pres_charge'] != null ? json['is_pres_charge'].toString():null;
    isDelCharge = json['is_del_charge'] != null ? json['is_del_charge'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['pharmacy_name'] = this.pharmacyName;
    data['mobileNumber'] = this.mobileNumber;
    data['emailId'] = this.emailId;
    data['scan_type'] = this.scanType;
    data['is_pres_charge'] = this.isPresCharge;
    data['is_del_charge'] = this.isDelCharge;
    return data;
  }
}

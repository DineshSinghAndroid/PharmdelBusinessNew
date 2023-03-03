class GetDriverListModelResponsePharmacy {
  int? driverId;
  String? firstName;
  String? middleNmae;
  String? lastName;
  Null? mobileNumber;
  String? emailId;
  String? routeId;
  String? route;

  GetDriverListModelResponsePharmacy(
      {this.driverId,
        this.firstName,
        this.middleNmae,
        this.lastName,
        this.mobileNumber,
        this.emailId,
        this.routeId,
        this.route});

  GetDriverListModelResponsePharmacy.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    firstName = json['firstName'];
    middleNmae = json['middleNmae'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    routeId = json['routeId'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverId'] = this.driverId;
    data['firstName'] = this.firstName;
    data['middleNmae'] = this.middleNmae;
    data['lastName'] = this.lastName;
    data['mobileNumber'] = this.mobileNumber;
    data['emailId'] = this.emailId;
    data['routeId'] = this.routeId;
    data['route'] = this.route;
    return data;
  }
}

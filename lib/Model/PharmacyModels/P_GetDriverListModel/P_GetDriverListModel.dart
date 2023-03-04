class GetDriverListModelResponsePharmacy {
  String? driverId;
  String? firstName;
  String? middleNmae;
  String? lastName;
  String? mobileNumber;
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
    driverId =  json['driverId'] != null ? json['driverId'].toString() :null;
    firstName = json['firstName'] != null ? json['firstName'].toString() : null ;
    middleNmae =   json['middleNmae'] != null ? json['middleNmae'].toString() : null;
    lastName =   json['lastName'] != null ? json['lastName'].toString() : null;
    mobileNumber =  json['mobileNumber'] != null ? json['mobileNumber'].toString() : null;
    emailId =  json['emailId'] != null ? json['emailId'].toString() : null;
    routeId =   json['routeId'] != null ? json['routeId'].toString() : null;
    route =   json['route'] != null ? json['route'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

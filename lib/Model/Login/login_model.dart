class LoginModel {
  int? userId;
  int? customerId;
  String? name;
  String? email;
  Null? mobile;
  String? userType;
  int? companyId;
  int? pharmacyId;
  int? changePassword;
  int? routeId;
  bool? isStartRoute;
  String? driverType;
  bool? status;
  String? message;
  bool? isOrderAvailable;
  String? token;
  String? pin;
  bool? isAddressUpdated;
  bool? error;
  int? startMiles;
  Null? endMiles;
  int? showWages;

  LoginModel(
      {this.userId,
        this.customerId,
        this.name,
        this.email,
        this.mobile,
        this.userType,
        this.companyId,
        this.pharmacyId,
        this.changePassword,
        this.routeId,
        this.isStartRoute,
        this.driverType,
        this.status,
        this.message,
        this.isOrderAvailable,
        this.token,
        this.pin,
        this.isAddressUpdated,
        this.error,
        this.startMiles,
        this.endMiles,
        this.showWages});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    customerId = json['customerId'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    userType = json['userType'];
    companyId = json['companyId'];
    pharmacyId = json['pharmacy_id'];
    changePassword = json['changePassword'];
    routeId = json['routeId'];
    isStartRoute = json['isStartRoute'];
    driverType = json['driver_type'];
    status = json['status'];
    message = json['message'];
    isOrderAvailable = json['isOrderAvailable'];
    token = json['token'];
    pin = json['pin'];
    isAddressUpdated = json['isAddressUpdated'];
    error = json['error'];
    startMiles = json['start_miles'];
    endMiles = json['end_miles'];
    showWages = json['show_wages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['customerId'] = this.customerId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['userType'] = this.userType;
    data['companyId'] = this.companyId;
    data['pharmacy_id'] = this.pharmacyId;
    data['changePassword'] = this.changePassword;
    data['routeId'] = this.routeId;
    data['isStartRoute'] = this.isStartRoute;
    data['driver_type'] = this.driverType;
    data['status'] = this.status;
    data['message'] = this.message;
    data['isOrderAvailable'] = this.isOrderAvailable;
    data['token'] = this.token;
    data['pin'] = this.pin;
    data['isAddressUpdated'] = this.isAddressUpdated;
    data['error'] = this.error;
    data['start_miles'] = this.startMiles;
    data['end_miles'] = this.endMiles;
    data['show_wages'] = this.showWages;
    return data;
  }
}

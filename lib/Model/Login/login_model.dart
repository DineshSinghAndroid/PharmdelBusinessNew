class LoginModel {
  dynamic userId;
  dynamic  customerId;
  dynamic name;
  dynamic email;
  dynamic mobile;
  dynamic userType;
  dynamic companyId;
  dynamic pharmacyId;
  dynamic changePassword;
  dynamic routeId;
  dynamic isStartRoute;
  dynamic driverType;
  dynamic status;
  dynamic message;
  dynamic isOrderAvailable;
  dynamic token;
  dynamic pin;
  dynamic isAddressUpdated;
  dynamic error;
  dynamic startMiles;
  dynamic endMiles;
  dynamic showWages;

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
    userId = json['userId'] != null ? json['userId'].toString():null;
    customerId = json['customerId'] != null ? json['customerId'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    mobile = json['mobile'] != null ? json['mobile'].toString():null;
    userType = json['userType'] != null ? json['userType'].toString():null;
    companyId = json['companyId'] != null ? json['companyId'].toString():null;
    pharmacyId = json['pharmacy_id'] != null ? json['pharmacy_id'].toString():null;
    changePassword = json['changePassword'] != null ? json['changePassword'].toString():null;
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    isStartRoute = json['isStartRoute'];
    driverType = json['driver_type'] != null ? json['driver_type'].toString():null;
    status = json['status'];
    message = json['message'] != null ? json['message'].toString():null;
    isOrderAvailable = json['isOrderAvailable'];
    token = json['token'] != null ? json['token'].toString():null;
    pin = json['pin'] != null ? json['pin'].toString():null;
    isAddressUpdated = json['isAddressUpdated'];
    error = json['error'];
    startMiles = json['start_miles'] != null ? json['start_miles'].toString():null;
    endMiles = json['end_miles'] != null ? json['end_miles'].toString():null;
    showWages = json['show_wages'] != null ? json['show_wages'].toString():null;
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

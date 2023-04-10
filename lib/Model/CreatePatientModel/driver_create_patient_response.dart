class DriverCreatePatientApiResponse {
  bool? error;
  int? errorCode;
  String? message;

  DriverCreatePatientApiResponse({this.error, this.errorCode, this.message});

  DriverCreatePatientApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null && json['error'].toString().toLowerCase() == "true" ? true:false;
    errorCode = json['errorCode'] != null ? int.parse(json['errorCode'].toString()):null;
    message = json['message'] != null ? json['message'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    return data;
  }
}

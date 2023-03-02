class CreatePatientModelResponse {
  bool? error;
  dynamic errorCode;
  String? message;

  CreatePatientModelResponse(
      {this.error, this.errorCode, this.message,  });

  CreatePatientModelResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorCode =errorCode != null ? json['errorCode'] :1;
    message = json['message'];
   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
     return data;
  }
}

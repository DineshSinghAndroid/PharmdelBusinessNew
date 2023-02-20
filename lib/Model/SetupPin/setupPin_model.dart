class SetupMPinApiResponse {
  bool? error;
  String? message;

  SetupMPinApiResponse({this.error, this.message});

  SetupMPinApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}

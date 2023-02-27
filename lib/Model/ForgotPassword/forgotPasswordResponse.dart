class ForgotPasswordApiResponse {
  bool? error;
  bool? authenticated;
  String? message;
  String? state;

  ForgotPasswordApiResponse(
      {this.error, this.authenticated, this.message, this.state});

  ForgotPasswordApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    authenticated = json['authenticated'];
    message = json['message'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['authenticated'] = this.authenticated;
    data['message'] = this.message;
    data['state'] = this.state;
    return data;
  }
}

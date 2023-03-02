class UpdateProfileApiResponse {
  bool? error;
  bool? status;
  String? message;

  UpdateProfileApiResponse({this.error, this.status, this.message});

  UpdateProfileApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

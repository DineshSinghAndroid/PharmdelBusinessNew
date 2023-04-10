class UpdateOrderStorageOrCDResponse {
  bool? error;
  bool? authenticated;
  String? message;
  String? data;

  UpdateOrderStorageOrCDResponse(
      {this.error, this.authenticated, this.message, this.data});

  UpdateOrderStorageOrCDResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    authenticated = json['authenticated'];
    message = json['message'] != null ? json['message'].toString():null;
    data = json['data'] != null ? json['data'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['authenticated'] = this.authenticated;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}

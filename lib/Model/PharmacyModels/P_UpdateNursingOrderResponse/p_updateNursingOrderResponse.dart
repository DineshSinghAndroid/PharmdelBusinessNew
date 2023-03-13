class UpdateNursingOrderApiResposne {
  bool? error;
  bool? authenticated;
  String? message;
  String? data;

  UpdateNursingOrderApiResposne(
      {this.error, this.authenticated, this.message, this.data});

  UpdateNursingOrderApiResposne.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    authenticated = json['authenticated'];
    message = json['message'];
    data = json['data'];
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

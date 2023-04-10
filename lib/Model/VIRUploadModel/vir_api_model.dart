class VirUploadApiModel {
  bool? error;
  String? message;

  VirUploadApiModel({this.error, this.message});

  VirUploadApiModel.fromJson(Map<String, dynamic> json) {
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

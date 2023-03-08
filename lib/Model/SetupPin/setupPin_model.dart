
class SetUpPinModel {
  bool? error;
  String? message;


  SetUpPinModel(
      {this.error,
        this.message,
      });

  SetUpPinModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
 }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}

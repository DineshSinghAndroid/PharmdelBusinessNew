class SetUpPinModel {
  SetUpPinModel({
    required this.error,
    required this.message,
    required this.data,
  });
  late final bool error;
  late final String message;
  late final Data data;

  SetUpPinModel.fromJson(Map<String, dynamic> json){
    error = json['error'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['error'] = error;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data();

  Data.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}
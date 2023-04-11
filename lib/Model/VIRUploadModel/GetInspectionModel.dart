class GetInspectionDataModel {
  bool? error;
  bool? authenticated;
  String? message;
  Data? data;

  GetInspectionDataModel({this.error, this.authenticated, this.message, this.data});

  GetInspectionDataModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    authenticated = json['authenticated'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['authenticated'] = this.authenticated;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? tyre;
  int? body;
  int? boot;
  int? engine;
  int? inside;

  Data({this.tyre, this.body, this.boot, this.engine, this.inside});

  Data.fromJson(Map<String, dynamic> json) {
    tyre = json['tyre'];
    body = json['body'];
    boot = json['boot'];
    engine = json['engine'];
    inside = json['inside'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tyre'] = this.tyre;
    data['body'] = this.body;
    data['boot'] = this.boot;
    data['engine'] = this.engine;
    data['inside'] = this.inside;
    return data;
  }
}

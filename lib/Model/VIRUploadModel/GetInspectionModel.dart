class GetInspectionDataModel {
  bool? error;
  bool? authenticated;
  String? message;
  InspectionData? data;

  GetInspectionDataModel({this.error, this.authenticated, this.message, this.data});

  GetInspectionDataModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    authenticated = json['authenticated'];
    message = json['message'];
    data = json['data'] != null ? new InspectionData.fromJson(json['data']) : null;
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

class InspectionData {
  String? tyre;
  String? body;
  String? boot;
  String? engine;
  String? inside;

  InspectionData({this.tyre, this.body, this.boot, this.engine, this.inside});

  InspectionData.fromJson(Map<String, dynamic> json) {
    tyre = json['tyre'] != null ? json['tyre'].toString():null;
    body = json['body'] != null ? json['body'].toString():null;
    boot = json['boot'] != null ? json['boot'].toString():null;
    engine = json['engine'] != null ? json['engine'].toString():null;
    inside = json['inside'] != null ? json['inside'].toString():null;
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

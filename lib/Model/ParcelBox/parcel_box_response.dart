class GetParcelBoxApiResponse {
  bool? error;
  bool? authenticated;
  String? message;
  List<ParcelBoxData>? data;

  GetParcelBoxApiResponse({this.error, this.authenticated, this.message, this.data});

  GetParcelBoxApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    authenticated = json['authenticated'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ParcelBoxData>[];
      json['data'].forEach((v) {
        data?.add(new ParcelBoxData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['authenticated'] = this.authenticated;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParcelBoxData {
  String? id;
  String? name;

  ParcelBoxData({this.id, this.name});

  ParcelBoxData.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
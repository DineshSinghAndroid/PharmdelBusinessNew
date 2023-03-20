class NursingHomeApiResponse {
  bool? error;
  String? message;
  List<NursingHome>? nursingHomeData;

  NursingHomeApiResponse({this.error, this.message, this.nursingHomeData});

  NursingHomeApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      nursingHomeData = <NursingHome>[];
      json['data'].forEach((v) {
        nursingHomeData!.add(new NursingHome.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.nursingHomeData != null) {
      data['data'] = this.nursingHomeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NursingHome {
  String? id;
  String? nursingHomeName;

  NursingHome({this.id, this.nursingHomeName});

  NursingHome.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    nursingHomeName = json['nursing_home_name'] != null ? json['nursing_home_name'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nursing_home_name'] = this.nursingHomeName;
    return data;
  }
}

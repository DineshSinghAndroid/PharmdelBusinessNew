//@dart=2.9

class nursingHomeModel {
  bool error;
  String message;
  List<nursingHome> data;

  nursingHomeModel({this.error, this.message, this.data});

  nursingHomeModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <nursingHome>[];
      json['data'].forEach((v) {
        data.add(new nursingHome.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class nursingHome {
  int id;
  String nursingHomeName;

  nursingHome({this.id, this.nursingHomeName});

  nursingHome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nursingHomeName = json['nursing_home_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nursing_home_name'] = this.nursingHomeName;
    return data;
  }
}

//@dart=2.9
class toteModel {
  bool error;
  String message;
  List<toteData> data;

  toteModel({this.error, this.message, this.data});

  toteModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <toteData>[];
      json['data'].forEach((v) {
        data.add(new toteData.fromJson(v));
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

class toteData {
  int id;
  int boxNo;
  String boxName;

  toteData({this.id, this.boxNo, this.boxName});

  toteData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    boxNo = json['box_no'];
    boxName = json['box_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['box_no'] = this.boxNo;
    data['box_name'] = this.boxName;
    return data;
  }
}

//@dart=2.9
class nursingHomeList {
  bool error;
  String message;
  List<SharedNursing> data;

  nursingHomeList({this.error, this.message, this.data});

  nursingHomeList.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SharedNursing>[];
      json['data'].forEach((v) {
        data.add(new SharedNursing.fromJson(v));
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

class SharedNursing {
  int id;
  String nursingHomeName;

  SharedNursing({this.id, this.nursingHomeName});

  SharedNursing.fromJson(Map<String, dynamic> json) {
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

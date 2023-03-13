class GetBoxesApiResponse {
  bool? error;
  String? message;
  List<BoxesData>? boxesdata;

  GetBoxesApiResponse({this.error, this.message, this.boxesdata});

  GetBoxesApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      boxesdata = <BoxesData>[];
      json['data'].forEach((v) {
        boxesdata!.add(new BoxesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.boxesdata != null) {
      data['data'] = this.boxesdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BoxesData {
  String? id;
  String? boxNo;
  String? boxName;

  BoxesData({this.id, this.boxNo, this.boxName});

  BoxesData.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    boxNo = json['box_no'] != null ? json['box_no'].toString():null;
    boxName = json['box_name'] != null ? json['box_name'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['box_no'] = this.boxNo;
    data['box_name'] = this.boxName;
    return data;
  }
}

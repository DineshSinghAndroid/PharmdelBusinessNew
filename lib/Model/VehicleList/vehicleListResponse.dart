class VehicleListApiResponse {
  List<VehicleListData>? list;
  bool? status;
  String? message;

  VehicleListApiResponse({this.list, this.status, this.message});

  VehicleListApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <VehicleListData>[];
      json['list'].forEach((v) {
        list!.add(new VehicleListData.fromJson(v));
      });
    }
    status = json['status'] != null && json['status'].toString().toLowerCase() == "true" ? true:false;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class VehicleListData {
  String? id;
  String? name;
  String? modal;
  String? color;
  String? regNo;
  String? vehicleType;

  VehicleListData(
      {this.id,
      this.name,
      this.modal,
      this.color,
      this.regNo,
      this.vehicleType});

  VehicleListData.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    modal = json['modal'] != null ? json['modal'].toString():null;
    color = json['color'] != null ? json['color'].toString():null;
    regNo = json['reg_no'] != null ? json['reg_no'].toString():null;
    vehicleType = json['vehicle_type'] != null ? json['vehicle_type'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['modal'] = this.modal;
    data['color'] = this.color;
    data['reg_no'] = this.regNo;
    data['vehicle_type'] = this.vehicleType;
    return data;
  }
}

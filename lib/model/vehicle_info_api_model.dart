//@dart=2.9
class GetVehicleInfoApiResponse {
  List<VehicleData> vehicleData;
  bool status;
  String message;

  GetVehicleInfoApiResponse({this.vehicleData, this.status, this.message});

  GetVehicleInfoApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      vehicleData = <VehicleData>[];
      json['list'].forEach((v) {
        vehicleData.add(new VehicleData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vehicleData != null) {
      data['list'] = this.vehicleData.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class VehicleData {
  int id;
  String name;
  String modal;
  String color;
  String regNo;
  String vehicleType;

  VehicleData({this.id, this.name, this.modal, this.color, this.regNo, this.vehicleType});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    modal = json['modal'];
    color = json['color'];
    regNo = json['reg_no'];
    vehicleType = json['vehicle_type'];
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

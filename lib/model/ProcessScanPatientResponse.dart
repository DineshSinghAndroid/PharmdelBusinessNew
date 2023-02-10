// @dart=2.9
class ProcessScanPatientResponse {
  bool error;
  String message;
  int isExist;
  Data data;

  ProcessScanPatientResponse({this.error, this.message, this.isExist, this.data});

  ProcessScanPatientResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    isExist = json['isExist'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['isExist'] = this.isExist;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  OrderInfo orderInfo;

  Data({this.orderInfo});

  Data.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null ? new OrderInfo.fromJson(json['orderInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderInfo != null) {
      data['orderInfo'] = this.orderInfo.toJson();
    }

    return data;
  }
}

class OrderInfo {
  dynamic userId;
  double lat;
  double lng;
  String defaultDeliveryType;
  dynamic defaultDeliveryRoute;
  dynamic prescriptionId;
  String prescriptionFt;
  String prescriptionT;
  String prescriptionDn;
  String lastName;
  String middleName;
  String firstName;
  String title;
  int delSubsId;
  dynamic delCharge;
  dynamic paymentExemption;
  dynamic subExpDate;
  dynamic nhsNumber;
  String default_delivery_type;
  dynamic default_delivery_route;
  dynamic default_branch_note;
  dynamic default_delivery_note;
  dynamic default_surgery_note;
  dynamic default_service;
  String alt_address;
  String dob;
  String x;
  String address;
  dynamic nursing_home_id;
  String mobile_no;
  String email;
  String postCode;
  String exemption;
  String drId;
  String doctorName;
  String surgeryName;
  String pi;
  String doctorAddress;
  String drPostCode;

  OrderInfo({this.userId, this.lat, this.lng, this.defaultDeliveryType, this.defaultDeliveryRoute, this.prescriptionId, this.prescriptionFt, this.prescriptionT, this.prescriptionDn, this.lastName, this.middleName, this.delCharge, this.exemption, this.mobile_no, this.delSubsId, this.subExpDate, this.paymentExemption, this.email, this.firstName, this.title, this.alt_address, this.nhsNumber, this.dob, this.x, this.default_surgery_note, this.default_delivery_route, this.default_branch_note, this.default_delivery_note, this.default_service, this.address, this.postCode, this.nursing_home_id, this.drId, this.doctorName, this.surgeryName, this.pi, this.doctorAddress, this.drPostCode});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    lat = json['lat'];
    lng = json['lng'];
    default_delivery_type = json['default_delivery_type'];
    default_service = json['default_service'];
    mobile_no = json['mobile_no'];
    exemption = json['exemption'];
    delCharge = json['del_charge'];
    paymentExemption = json['payment_exemption'];
    alt_address = json['alt_address'];
    default_delivery_note = json['default_delivery_note'];
    delSubsId = json['del_subs_id'];
    subExpDate = json['subs_expiry_date'];
    default_surgery_note = json['default_surgery_note'];
    email = json['email'];
    default_branch_note = json['default_branch_note'];
    default_delivery_route = json['default_delivery_route'];
    prescriptionId = json['prescription_id'];
    prescriptionFt = json['prescription_ft'];
    prescriptionT = json['prescription_t'];
    prescriptionDn = json['prescription_dn'];
    nursing_home_id = json['nursing_home_id'];
    lastName = json['last_name'];
    middleName = json['middle_name'];
    firstName = json['first_name'];
    title = json['title'];
    nhsNumber = json['nhs_number'];
    dob = json['dob'];
    x = json['x'];
    address = json['address'];
    postCode = json['post_code'];
    drId = json['dr_id'];
    doctorName = json['doctor_name'];
    surgeryName = json['surgery_name'];
    pi = json['pi'];
    doctorAddress = json['doctor_address'];
    drPostCode = json['dr_post_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['payment_exemption'] = this.paymentExemption;
    data['default_delivery_type'] = this.defaultDeliveryType;
    data['default_delivery_route'] = this.defaultDeliveryRoute;
    data['prescription_id'] = this.prescriptionId;
    data['del_subs_id'] = this.delSubsId;
    data['del_charge'] = this.delCharge;
    data['subs_expiry_date'] = this.subExpDate;
    data['prescription_ft'] = this.prescriptionFt;
    data['alt_address'] = this.alt_address;
    data['prescription_t'] = this.prescriptionT;
    data['nursing_home_id'] = this.nursing_home_id;
    data['email'] = this.email;
    data['exemption'] = this.exemption;
    data['mobile_no'] = this.mobile_no;
    data['prescription_dn'] = this.prescriptionDn;
    data['last_name'] = this.lastName;
    data['middle_name'] = this.middleName;
    data['first_name'] = this.firstName;
    data['title'] = this.title;
    data['nhs_number'] = this.nhsNumber;
    data['dob'] = this.dob;
    data['x'] = this.x;
    data['address'] = this.address;
    data['post_code'] = this.postCode;
    data['dr_id'] = this.drId;
    data['doctor_name'] = this.doctorName;
    data['surgery_name'] = this.surgeryName;
    data['pi'] = this.pi;
    data['doctor_address'] = this.doctorAddress;
    data['dr_post_code'] = this.drPostCode;
    return data;
  }
}

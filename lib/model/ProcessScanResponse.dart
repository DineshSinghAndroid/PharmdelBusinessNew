// @dart=2.9
class ProcessScanResponse {
  bool error;
  String message;
  Data data;

  ProcessScanResponse({this.error, this.message, this.data});

  ProcessScanResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  OrderInfoResponse orderInfo;

  Data({this.orderInfo});

  Data.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null ? new OrderInfoResponse.fromJson(json['orderInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderInfo != null) {
      data['orderInfo'] = this.orderInfo.toJson();
    }
    return data;
  }
}

class OrderInfoResponse {
  dynamic userId;
  bool otherpharmacy;
  PatientsList patientsList;
  PrescriptionId prescriptionId;
  PrescriptionId prescriptionFt;
  PrescriptionId prescriptionT;
  PrescriptionId prescriptionDn;
  PrescriptionId lastName;
  PrescriptionId middleName;
  PrescriptionId firstName;
  PrescriptionId title;
  PrescriptionId nhsNumber;
  PrescriptionId nursing_home_id;
  dynamic titanScaInfo;
  String exemption;
  int delSubsId;
  dynamic subExpDate;
  dynamic paymentExemption;
  dynamic delCharge;
  dynamic default_delivery_type;
  dynamic default_delivery_route;
  dynamic delivery_note;
  dynamic default_branch_note;
  dynamic default_delivery_note;
  dynamic default_surgery_note;
  dynamic default_service;
  dynamic surgery_id;
  bool nhs_matched;
  dynamic mobile_no_new;
  dynamic email_id;
  dynamic dob;
  PrescriptionId x;
  PrescriptionId address;
  PrescriptionId postCode;
  PrescriptionId drId;
  PrescriptionId doctorName;
  dynamic surgeryName;
  PrescriptionId pi;
  PrescriptionId doctorAddress;
  PrescriptionId drPostCode;

  OrderInfoResponse({
    this.userId,
    this.otherpharmacy,
    this.patientsList,
    this.prescriptionId,
    this.prescriptionFt,
    this.delCharge,
    this.prescriptionT,
    this.prescriptionDn,
    this.lastName,
    this.middleName,
    this.subExpDate,
    this.delSubsId,
    this.firstName,
    this.title,
    this.paymentExemption,
    this.default_delivery_type,
    this.delivery_note,
    this.surgery_id,
    this.exemption,
    this.nhsNumber,
    this.nhs_matched,
    this.dob,
    this.x,
    this.address,
    this.postCode,
    this.drId,
    this.doctorName,
    this.mobile_no_new,
    this.default_surgery_note,
    this.default_delivery_route,
    this.nursing_home_id,
    this.titanScaInfo,
    this.default_branch_note,
    this.default_delivery_note,
    this.default_service,
    this.surgeryName,
    this.email_id,
    this.pi,
    this.doctorAddress,
    this.drPostCode,
  });

  OrderInfoResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    otherpharmacy = json['otherpharmacy'];
    default_delivery_type = json['default_delivery_type'];
    default_service = json['default_service'];
    exemption = json['exemption'];
    delCharge = json['del_charge'];
    delSubsId = json['del_subs_id'];
    paymentExemption = json['payment_exemption'];
    default_delivery_note = json['default_delivery_note'];
    subExpDate = json['subs_expiry_date'];
    surgery_id = json['surgery_id'];
    default_surgery_note = json['default_surgery_note'];
    default_branch_note = json['default_branch_note'];
    default_delivery_route = json['default_delivery_route'];
    mobile_no_new = json['mobile_no_new'];
    email_id = json['email_id'];
    delivery_note = json['delivery_note'];
    titanScaInfo = json['titan_scan_info'];

    patientsList = json['patients_list'] != null ? new PatientsList.fromJson(json['patients_list']) : null;
    prescriptionId = json['prescription_id'] != null ? new PrescriptionId.fromJson(json['prescription_id']) : null;
    prescriptionFt = json['prescription_ft'] != null ? new PrescriptionId.fromJson(json['prescription_ft']) : null;
    prescriptionT = json['prescription_t'] != null ? new PrescriptionId.fromJson(json['prescription_t']) : null;
    prescriptionDn = json['prescription_dn'] != null ? new PrescriptionId.fromJson(json['prescription_dn']) : null;
    lastName = json['last_name'] != null ? new PrescriptionId.fromJson(json['last_name']) : null;
    middleName = json['middle_name'] != null ? new PrescriptionId.fromJson(json['middle_name']) : null;
    firstName = json['first_name'] != null ? new PrescriptionId.fromJson(json['first_name']) : null;
    title = json['title'] != null ? new PrescriptionId.fromJson(json['title']) : null;

    nursing_home_id = json['nursing_home_id'] != null ? new PrescriptionId.fromJson(json['nursing_home_id']) : null;

    nhsNumber = json['nhs_number'] != null ? new PrescriptionId.fromJson(json['nhs_number']) : null;
    dob = json['dob'];
    nhs_matched = json['nhs_matched'];
    x = json['x'] != null ? new PrescriptionId.fromJson(json['x']) : null;
    address = json['address'] != null ? new PrescriptionId.fromJson(json['address']) : null;
    postCode = json['post_code'] != null ? new PrescriptionId.fromJson(json['post_code']) : null;
    drId = json['dr_id'] != null ? new PrescriptionId.fromJson(json['dr_id']) : null;
    doctorName = json['doctor_name'] != null ? new PrescriptionId.fromJson(json['doctor_name']) : null;
    // surgeryName = json['surgery_name'] != null
    //     ? new PrescriptionId.fromJson(json['surgery_name'])
    //     : null;
    pi = json['pi'] != null ? new PrescriptionId.fromJson(json['pi']) : null;
    doctorAddress = json['doctor_address'] != null ? new PrescriptionId.fromJson(json['doctor_address']) : null;
    drPostCode = json['dr_post_code'] != null ? new PrescriptionId.fromJson(json['dr_post_code']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['otherpharmacy'] = this.otherpharmacy;
    data['email_id'] = this.email_id;
    data['delivery_note'] = this.delivery_note;
    data['mobile_no_new'] = this.mobile_no_new;
    data['exemption'] = this.exemption;
    data['del_charge'] = this.delCharge;
    data['payment_exemption'] = this.paymentExemption;
    data['del_subs_id'] = this.delSubsId;
    data['subs_expiry_date'] = this.subExpDate;
    data['titan_scan_info'] = this.titanScaInfo;
    if (this.patientsList != null) {
      data['patients_list'] = this.patientsList.toJson();
    }
    if (this.prescriptionId != null) {
      data['prescription_id'] = this.prescriptionId.toJson();
    }
    if (this.prescriptionFt != null) {
      data['prescription_ft'] = this.prescriptionFt.toJson();
    }
    if (this.prescriptionT != null) {
      data['prescription_t'] = this.prescriptionT.toJson();
    }
    if (this.prescriptionDn != null) {
      data['prescription_dn'] = this.prescriptionDn.toJson();
    }
    if (this.lastName != null) {
      data['last_name'] = this.lastName.toJson();
    }
    if (this.middleName != null) {
      data['middle_name'] = this.middleName.toJson();
    }
    if (this.firstName != null) {
      data['first_name'] = this.firstName.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.nhsNumber != null) {
      data['nhs_number'] = this.nhsNumber.toJson();
    }
    data['nhs_matched'] = this.nhs_matched;
    data['dob'] = this.dob;
    if (this.x != null) {
      data['x'] = this.x.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.postCode != null) {
      data['post_code'] = this.postCode.toJson();
    }
    if (this.drId != null) {
      data['dr_id'] = this.drId.toJson();
    }
    if (this.doctorName != null) {
      data['doctor_name'] = this.doctorName.toJson();
    }
    // if (this.surgeryName != null) {
    //   data['surgery_name'] = this.surgeryName.toJson();
    // }
    if (this.pi != null) {
      data['pi'] = this.pi.toJson();
    }
    if (this.doctorAddress != null) {
      data['doctor_address'] = this.doctorAddress.toJson();
    }
    if (this.drPostCode != null) {
      data['dr_post_code'] = this.drPostCode.toJson();
    }
    return data;
  }
}

class PatientsList {
  List<dynamic> userId = [];
  List<dynamic> customerName = [];
  List<dynamic> dob = [];
  List<dynamic> nhsNumber = [];
  List<dynamic> lat = [];
  List<dynamic> lng = [];
  List<dynamic> address = [];
  List<dynamic> mobile_no_new = [];
  List<dynamic> default_delivery_type = [];
  List<dynamic> default_delivery_route = [];
  List<dynamic> default_service = [];
  List<dynamic> default_surgery_note = [];
  List<dynamic> default_branch_note = [];
  List<dynamic> default_delivery_note = [];
  List<dynamic> nursing_home_id = [];
  List<dynamic> alt_address = [];

  PatientsList({this.userId, this.customerName, this.dob, this.nhsNumber, this.lat, this.default_delivery_route, this.default_surgery_note, this.default_service, this.default_delivery_note, this.default_branch_note, this.default_delivery_type, this.lng, this.nursing_home_id, this.alt_address, this.mobile_no_new, this.address});

  PatientsList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    default_delivery_route = json['default_delivery_route'];
    default_delivery_type = json['default_delivery_type'];
    default_service = json['default_service'];
    customerName = json['customer_name'];
    default_delivery_note = json['default_delivery_note'];
    alt_address = json['alt_address'];
    default_branch_note = json['default_branch_note'];
    default_surgery_note = json['default_surgery_note'];
    dob = json['dob'];
    nhsNumber = json['nhs_number'];
    mobile_no_new = json['mobile_no_new'];
    lat = json['lat'].cast<double>();
    lng = json['lng'].cast<double>();
    nursing_home_id = json['nursing_home_id'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['customer_name'] = this.customerName;
    data['default_delivery_type'] = this.default_delivery_type;
    data['default_service'] = this.default_service;
    data['default_delivery_route'] = this.default_delivery_route;
    data['default_branch_note'] = this.default_branch_note;
    data['default_surgery_note'] = this.default_surgery_note;
    data['default_delivery_note'] = this.default_delivery_note;
    data['alt_address'] = this.alt_address;
    data['dob'] = this.dob;
    data['nhs_number'] = this.nhsNumber;
    data['mobile_no_new'] = this.mobile_no_new;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['nursing_home_id'] = this.nursing_home_id;
    data['address'] = this.address;
    return data;
  }
}

class PrescriptionId {
  String s0;

  PrescriptionId({this.s0});

  PrescriptionId.fromJson(Map<String, dynamic> json) {
    s0 = json['0'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    return data;
  }
}

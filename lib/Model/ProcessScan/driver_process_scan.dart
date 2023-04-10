class DriverProcessScan {
  bool? error;
  String? message;
  int? isExist;
  DriverProcessScanData? data;

  DriverProcessScan({this.error, this.message, this.isExist, this.data});

  DriverProcessScan.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    isExist = json['isExist'] != null ? int.parse(json['isExist'].toString()):null;
    data = json['data'] != null ? new DriverProcessScanData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['isExist'] = this.isExist;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DriverProcessScanData {
  DriverProcessScanOrderInfo? orderInfo;

  DriverProcessScanData({this.orderInfo});

  DriverProcessScanData.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null
        ? new DriverProcessScanOrderInfo.fromJson(json['orderInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderInfo != null) {
      data['orderInfo'] = this.orderInfo!.toJson();
    }
    return data;
  }
}

class DriverProcessScanOrderInfo {
  bool? otherpharmacy;
  bool? existsAnotherPharmacy;
  String? userId;
  String? delSubsId;
  String? delCharge;
  String? subsExpiryDate;
  String? paymentExemption;
  String? lat;
  String? lng;
  String? email;
  String? mobileNo;
  String? nursingHomeId;
  bool? nhsMatched;
  String? defaultDeliveryType;
  String? defaultDeliveryRoute;
  String? countryId;
  String? defaultBranchNote;
  String? defaultDeliveryNote;
  String? defaultService;
  String? defaultSurgeryNote;
  String? altAddress;
  String? prescriptionId;
  String? prescriptionFt;
  String? prescriptionT;
  String? prescriptionDn;
  String? lastName;
  String? middleName;
  String? firstName;
  String? title;
  String? nhsNumber;
  String? dob;
  String? x;
  String? address;
  String? postCode;
  String? drId;
  String? doctorName;
  String? surgeryName;
  String? pi;
  String? doctorAddress;
  String? drPostCode;

  DriverProcessScanOrderInfo(
      {this.otherpharmacy,
        this.existsAnotherPharmacy,
        this.userId,
        this.delSubsId,
        this.delCharge,
        this.subsExpiryDate,
        this.paymentExemption,
        this.lat,
        this.lng,
        this.email,
        this.mobileNo,
        this.nursingHomeId,
        this.nhsMatched,
        this.defaultDeliveryType,
        this.defaultDeliveryRoute,
        this.countryId,
        this.defaultBranchNote,
        this.defaultDeliveryNote,
        this.defaultService,
        this.defaultSurgeryNote,
        this.altAddress,
        this.prescriptionId,
        this.prescriptionFt,
        this.prescriptionT,
        this.prescriptionDn,
        this.lastName,
        this.middleName,
        this.firstName,
        this.title,
        this.nhsNumber,
        this.dob,
        this.x,
        this.address,
        this.postCode,
        this.drId,
        this.doctorName,
        this.surgeryName,
        this.pi,
        this.doctorAddress,
        this.drPostCode});

  DriverProcessScanOrderInfo.fromJson(Map<String, dynamic> json) {
    otherpharmacy = json['otherpharmacy'] != null && json['otherpharmacy'].toString().toLowerCase() == "true" ? true:false;
    existsAnotherPharmacy = json['exists_another_pharmacy'] != null && json['exists_another_pharmacy'].toString().toLowerCase() == "true" ? true:false;
    userId = json['user_id'] != null ? json['user_id'].toString():null;
    delSubsId = json['del_subs_id'] != null ? json['del_subs_id'].toString():null;
    delCharge = json['del_charge'] != null ? json['del_charge'].toString():null;
    subsExpiryDate = json['subs_expiry_date'] != null ? json['subs_expiry_date'].toString():null;
    paymentExemption = json['payment_exemption'] != null ? json['payment_exemption'].toString():null;
    lat = json['lat'] != null ? json['lat'].toString():null;
    lng = json['lng'] != null ? json['lng'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    mobileNo = json['mobile_no'] != null ? json['mobile_no'].toString():null;
    nursingHomeId = json['nursing_home_id'] != null ? json['nursing_home_id'].toString():null;
    nhsMatched = json['nhs_matched'] != null && json['nhs_matched'].toString().toLowerCase() == "true" ? true:false;
    defaultDeliveryType = json['default_delivery_type'] != null ? json['default_delivery_type'].toString():null;
    defaultDeliveryRoute = json['default_delivery_route'] != null ? json['default_delivery_route'].toString():null;
    countryId = json['country_id'] != null ? json['country_id'].toString():null;
    defaultBranchNote = json['default_branch_note'] != null ? json['default_branch_note'].toString():null;
    defaultDeliveryNote = json['default_delivery_note'] != null ? json['default_delivery_note'].toString():null;
    defaultService = json['default_service'] != null ? json['default_service'].toString():null;
    defaultSurgeryNote = json['default_surgery_note'] != null ? json['default_surgery_note'].toString():null;
    altAddress = json['alt_address'] != null ? json['alt_address'].toString():null;
    prescriptionId = json['prescription_id'] != null ? json['prescription_id'].toString():null;
    prescriptionFt = json['prescription_ft'] != null ? json['prescription_ft'].toString():null;
    prescriptionT = json['prescription_t'] != null ? json['prescription_t'].toString():null;
    prescriptionDn = json['prescription_dn'] != null ? json['prescription_dn'].toString():null;
    lastName = json['last_name'] != null ? json['last_name'].toString():null;
    middleName = json['middle_name'] != null ? json['middle_name'].toString():null;
    firstName = json['first_name'] != null ? json['first_name'].toString():null;
    title = json['title'] != null ? json['title'].toString():null;
    nhsNumber = json['nhs_number'] != null ? json['nhs_number'].toString():null;
    dob = json['dob'] != null ? json['dob'].toString():null;
    x = json['x'] != null ? json['x'].toString():null;
    address = json['address'] != null ? json['address'].toString():null;
    postCode = json['post_code'] != null ? json['post_code'].toString():null;
    drId = json['dr_id'] != null ? json['dr_id'].toString():null;
    doctorName = json['doctor_name'] != null ? json['doctor_name'].toString():null;
    surgeryName = json['surgery_name'] != null ? json['surgery_name'].toString():null;
    pi = json['pi'] != null ? json['pi'].toString():null;
    doctorAddress = json['doctor_address'] != null ? json['doctor_address'].toString():null;
    drPostCode = json['dr_post_code'] != null ? json['dr_post_code'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otherpharmacy'] = this.otherpharmacy;
    data['exists_another_pharmacy'] = this.existsAnotherPharmacy;
    data['user_id'] = this.userId;
    data['del_subs_id'] = this.delSubsId;
    data['del_charge'] = this.delCharge;
    data['subs_expiry_date'] = this.subsExpiryDate;
    data['payment_exemption'] = this.paymentExemption;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['nursing_home_id'] = this.nursingHomeId;
    data['nhs_matched'] = this.nhsMatched;
    data['default_delivery_type'] = this.defaultDeliveryType;
    data['default_delivery_route'] = this.defaultDeliveryRoute;
    data['country_id'] = this.countryId;
    data['default_branch_note'] = this.defaultBranchNote;
    data['default_delivery_note'] = this.defaultDeliveryNote;
    data['default_service'] = this.defaultService;
    data['default_surgery_note'] = this.defaultSurgeryNote;
    data['alt_address'] = this.altAddress;
    data['prescription_id'] = this.prescriptionId;
    data['prescription_ft'] = this.prescriptionFt;
    data['prescription_t'] = this.prescriptionT;
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

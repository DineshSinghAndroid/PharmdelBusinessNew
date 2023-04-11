class ProcessScanApiResponse {
  bool? error;
  String? message;
  int? isExist;
  ProcessScanData? data;

  ProcessScanApiResponse({this.error, this.message, this.isExist, this.data});

  ProcessScanApiResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null && json['error'].toString().toLowerCase() == "true" ? true:false;
    message = json['message'] != null ? json['message'].toString():null;
    isExist = json['isExist'] != null ? int.parse(json['isExist'].toString()):null;
    data = json['data'] != null ? new ProcessScanData.fromJson(json['data']) : null;
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

class ProcessScanData {
  ProcessScanOrderInfo? orderInfo;

  ProcessScanData({this.orderInfo});

  ProcessScanData.fromJson(Map<String, dynamic> json) {
    orderInfo = json['orderInfo'] != null
        ? new ProcessScanOrderInfo.fromJson(json['orderInfo'])
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

class ProcessScanOrderInfo {
  bool? otherpharmacy;
  String? userId;
  String? delSubsId;
  String? delCharge;
  String? subsExpiryDate;
  String? paymentExemption;
  bool? nhsMatched;
  Title? title;
  FirstName? firstName;
  Title? middleName;
  FirstName? lastName;
  Title? nursingHomeId;
  FirstName? address;
  FirstName? postCode;
  NhsNumber? nhsNumber;
  String? lat;
  String? lng;
  String? altAddress;
  String? emailId;
  String? email;
  String? mobileNo;
  String? mobileNoNew;
  String? countryId;
  String? surgeryId;
  String? surgeryName;
  String? dob;
  String? defaultDeliveryType;
  String? defaultDeliveryRoute;
  String? defaultService;
  String? defaultDeliveryNote;
  String? defaultSurgeryNote;
  String? defaultBranchNote;
  PatientsList? patientsList;

  ProcessScanOrderInfo(
      {this.otherpharmacy,
        this.userId,
        this.delSubsId,
        this.delCharge,
        this.subsExpiryDate,
        this.paymentExemption,
        this.nhsMatched,
        this.title,
        this.firstName,
        this.middleName,
        this.lastName,
        this.nursingHomeId,
        this.address,
        this.postCode,
        this.nhsNumber,
        this.lat,
        this.lng,
        this.altAddress,
        this.emailId,
        this.email,
        this.mobileNo,
        this.mobileNoNew,
        this.countryId,
        this.surgeryId,
        this.surgeryName,
        this.dob,
        this.defaultDeliveryType,
        this.defaultDeliveryRoute,
        this.defaultService,
        this.defaultDeliveryNote,
        this.defaultSurgeryNote,
        this.defaultBranchNote,
        this.patientsList});

  ProcessScanOrderInfo.fromJson(Map<String, dynamic> json) {
    otherpharmacy = json['otherpharmacy'] != null && json['otherpharmacy'].toString().toLowerCase() == "true" ? true:false;
    userId = json['user_id'] != null ? json['user_id'].toString(): null;
    delSubsId = json['del_subs_id'] != null ? json['del_subs_id'].toString(): null;
    delCharge = json['del_charge'] != null ? json['del_charge'].toString(): null;
    subsExpiryDate = json['subs_expiry_date'] != null ? json['subs_expiry_date'].toString(): null;
    paymentExemption = json['payment_exemption'] != null ? json['payment_exemption'].toString(): null;
    nhsMatched = json['nhs_matched'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    firstName = json['first_name'] != null
        ? new FirstName.fromJson(json['first_name'])
        : null;
    middleName = json['middle_name'] != null
        ? new Title.fromJson(json['middle_name'])
        : null;
    lastName = json['last_name'] != null
        ? new FirstName.fromJson(json['last_name'])
        : null;
    nursingHomeId = json['nursing_home_id'] != null
        ? new Title.fromJson(json['nursing_home_id'])
        : null;
    address = json['address'] != null
        ? new FirstName.fromJson(json['address'])
        : null;
    postCode = json['post_code'] != null
        ? new FirstName.fromJson(json['post_code'])
        : null;
    nhsNumber = json['nhs_number'] != null
        ? new NhsNumber.fromJson(json['nhs_number'])
        : null;
    lat = json['lat'] != null ? json['lat'].toString() : null;
    lng = json['lng'] != null ? json['lng'].toString() : null;
    altAddress = json['alt_address'] != null ? json['alt_address'].toString() : null;
    emailId = json['email_id'] != null ? json['email_id'].toString() : null;
    email = json['email'] != null ? json['email'].toString() : null;
    mobileNo = json['mobile_no'] != null ? json['mobile_no'].toString() : null;
    mobileNoNew = json['mobile_no_new'] != null ? json['mobile_no_new'].toString() : null;
    countryId = json['country_id'] != null ? json['country_id'].toString() : null;
    surgeryId = json['surgery_id'] != null ? json['surgery_id'].toString() : null;
    surgeryName = json['surgery_name'] != null ? json['surgery_name'].toString() : null;
    dob = json['dob'] != null ? json['dob'].toString() : null;
    defaultDeliveryType = json['default_delivery_type'] != null ? json['default_delivery_type'].toString() : null;
    defaultDeliveryRoute = json['default_delivery_route'] != null ? json['default_delivery_route'].toString() : null;
    defaultService = json['default_service'] != null ? json['default_service'].toString() : null;
    defaultDeliveryNote = json['default_delivery_note'] != null ? json['default_delivery_note'].toString() : null;
    defaultSurgeryNote = json['default_surgery_note'] != null ? json['default_surgery_note'].toString() : null;
    defaultBranchNote = json['default_branch_note'] != null ? json['default_branch_note'].toString() : null;
    patientsList = json['patients_list'] != null
        ? new PatientsList.fromJson(json['patients_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otherpharmacy'] = this.otherpharmacy;
    data['user_id'] = this.userId;
    data['del_subs_id'] = this.delSubsId;
    data['del_charge'] = this.delCharge;
    data['subs_expiry_date'] = this.subsExpiryDate;
    data['payment_exemption'] = this.paymentExemption;
    data['nhs_matched'] = this.nhsMatched;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.firstName != null) {
      data['first_name'] = this.firstName!.toJson();
    }
    if (this.middleName != null) {
      data['middle_name'] = this.middleName!.toJson();
    }
    if (this.lastName != null) {
      data['last_name'] = this.lastName!.toJson();
    }
    if (this.nursingHomeId != null) {
      data['nursing_home_id'] = this.nursingHomeId!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.postCode != null) {
      data['post_code'] = this.postCode!.toJson();
    }
    if (this.nhsNumber != null) {
      data['nhs_number'] = this.nhsNumber!.toJson();
    }
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['alt_address'] = this.altAddress;
    data['email_id'] = this.emailId;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['mobile_no_new'] = this.mobileNoNew;
    data['country_id'] = this.countryId;
    data['surgery_id'] = this.surgeryId;
    data['surgery_name'] = this.surgeryName;
    data['dob'] = this.dob;
    data['default_delivery_type'] = this.defaultDeliveryType;
    data['default_delivery_route'] = this.defaultDeliveryRoute;
    data['default_service'] = this.defaultService;
    data['default_delivery_note'] = this.defaultDeliveryNote;
    data['default_surgery_note'] = this.defaultSurgeryNote;
    data['default_branch_note'] = this.defaultBranchNote;
    if (this.patientsList != null) {
      data['patients_list'] = this.patientsList!.toJson();
    }
    return data;
  }
}

class Title {
  String? n0;

  Title({this.n0});

  Title.fromJson(Map<String, dynamic> json) {
    n0 = json['0'] != null ? json['0'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.n0;
    return data;
  }
}

class FirstName {
  String? s0;

  FirstName({this.s0});

  FirstName.fromJson(Map<String, dynamic> json) {
    s0 = json['0'] != null ? json['0'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    return data;
  }
}

class NhsNumber {
  String? i0;

  NhsNumber({this.i0});

  NhsNumber.fromJson(Map<String, dynamic> json) {
    i0 = json['0'] != null ? json['0'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.i0;
    return data;
  }
}

class PatientsList {
  List<int>? userId;
  List<String>? customerName;
  List<String>? firstName;
  List<String>? middleName;
  List<String>? lastName;
  List<String>? dob;
  List<String>? emailId;
  List<String>? mobileNoNew;
  List<int>? nhsNumber;
  List<double>? lat;
  List<double>? lng;

  PatientsList(
      {this.userId,
        this.customerName,
        this.firstName,
        this.middleName,
        this.lastName,
        this.dob,
        this.emailId,
        this.mobileNoNew,
        this.nhsNumber,
        this.lat,
        this.lng});

  PatientsList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].cast<int>();
    customerName = json['customer_name'].cast<String>();
    firstName = json['first_name'].cast<String>();
    middleName = json['middle_name'].cast<String>();
    lastName = json['last_name'].cast<String>();
    dob = json['dob'].cast<String>();
    emailId = json['email_id'].cast<String>();
    mobileNoNew = json['mobile_no_new'].cast<String>();
    nhsNumber = json['nhs_number'].cast<int>();
    lat = json['lat'].cast<double>();
    lng = json['lng'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['customer_name'] = this.customerName;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['email_id'] = this.emailId;
    data['mobile_no_new'] = this.mobileNoNew;
    data['nhs_number'] = this.nhsNumber;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

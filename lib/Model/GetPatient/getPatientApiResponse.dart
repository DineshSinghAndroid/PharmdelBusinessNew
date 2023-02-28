class GetPatientApiResposne {
  List<PatientData>? list;
  bool? status;
  String? message;
  bool? isOrderAvailable;

  GetPatientApiResposne(
      {this.list, this.status, this.message, this.isOrderAvailable});

  GetPatientApiResposne.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <PatientData>[];
      json['list'].forEach((v) {
        list!.add(new PatientData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
    isOrderAvailable = json['isOrderAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    data['isOrderAvailable'] = this.isOrderAvailable;
    return data;
  }
}

class PatientData {
  String? customerId;
  String? title;
  String? firstName;
  String? middleName;
  String? lastName;
  String? altAddress;
  String? address1;
  String? address2;
  String? countryId;
  String? townName;
  String? contactNumber;
  String? email;
  String? postalCode;
  String? nhsNumber;
  String? pharmacyId;
  String? branchId;
  String? dob;
  String? gender;
  String? paymentExemption;
  String? landlineNumber;
  String? alternativeContact;
  String? dependentContactNumber;
  String? surgeryId;
  String? surgeryName;
  String? isApproved;
  String? pharmacyContactNo;
  String? branchContactNo;
  String? deliveryNote;
  String? branchNote;
  String? surgeryNote;
  String? serviceId;
  String? routeId;
  String? lastOrderId;
  String? orderId;
  String? tag;
  bool? status;
  String? message;
  String? rackNo;
  String? deliveryStatusDesc;
  bool? isStorageFridge;
  bool? isControlledDrugs;

  PatientData(
      {this.customerId,
      this.title,
      this.firstName,
      this.middleName,
      this.lastName,
      this.altAddress,
      this.address1,
      this.address2,
      this.countryId,
      this.townName,
      this.contactNumber,
      this.email,
      this.postalCode,
      this.nhsNumber,
      this.pharmacyId,
      this.branchId,
      this.dob,
      this.gender,
      this.paymentExemption,
      this.landlineNumber,
      this.alternativeContact,
      this.dependentContactNumber,
      this.surgeryId,
      this.surgeryName,
      this.isApproved,
      this.pharmacyContactNo,
      this.branchContactNo,
      this.deliveryNote,
      this.branchNote,
      this.surgeryNote,
      this.serviceId,
      this.routeId,
      this.lastOrderId,
      this.orderId,
      this.tag,
      this.status,
      this.message,
      this.rackNo,
      this.deliveryStatusDesc,
      this.isStorageFridge,
      this.isControlledDrugs});

  PatientData.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'] != null ? json['customerId'].toString():null;
    title = json['title'] != null ? json['title'].toString():null;
    firstName = json['firstName'] != null ? json['firstName'].toString():null;
    middleName = json['middleName'] != null ? json['middleName'].toString():null;
    lastName = json['lastName'] != null ? json['lastName'].toString():null;
    altAddress = json['alt_address'] != null ? json['alt_address'].toString():null;
    address1 = json['address1'] != null ? json['address1'].toString():null;
    address2 = json['address2'] != null ? json['address2'].toString():null;
    countryId = json['countryId'] != null ? json['countryId'].toString():null;
    townName = json['townName'] != null ? json['townName'].toString():null;
    contactNumber = json['contactNumber'] != null ? json['contactNumber'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    postalCode = json['postalCode'] != null ? json['postalCode'].toString():null;
    nhsNumber = json['nhsNumber'] != null ? json['nhsNumber'].toString():null;
    pharmacyId = json['pharmacyId'] != null ? json['pharmacyId'].toString():null;
    branchId = json['branchId'] != null ? json['branchId'].toString():null;
    dob = json['dob'] != null ? json['dob'].toString():null;
    gender = json['gender'] != null ? json['gender'].toString():null;
    paymentExemption = json['paymentExemption'] != null ? json['paymentExemption'].toString():null;
    landlineNumber = json['landlineNumber'] != null ? json['landlineNumber'].toString():null;
    alternativeContact = json['alternativeContact'] != null ? json['alternativeContact'].toString():null;
    dependentContactNumber = json['dependentContactNumber'] != null ? json['dependentContactNumber'].toString():null;
    surgeryId = json['surgeryId'] != null ? json['surgeryId'].toString():null;
    surgeryName = json['surgeryName'] != null ? json['surgeryName'].toString():null;
    isApproved = json['isApproved'] != null ? json['isApproved'].toString():null;
    pharmacyContactNo = json['pharmacyContactNo'] != null ? json['pharmacyContactNo'].toString():null;
    branchContactNo = json['branchContactNo'] != null ? json['branchContactNo'].toString():null;
    deliveryNote = json['deliveryNote'] != null ? json['deliveryNote'].toString():null;
    branchNote = json['branchNote'] != null ? json['branchNote'].toString():null;
    surgeryNote = json['surgeryNote'] != null ? json['surgeryNote'].toString():null;
    serviceId = json['serviceId'] != null ? json['serviceId'].toString():null;
    routeId = json['routeId'] != null ? json['routeId'].toString():null;
    lastOrderId = json['lastOrderId'] != null ? json['lastOrderId'].toString():null;
    orderId = json['orderId'] != null ? json['orderId'].toString():null;
    tag = json['tag'] != null ? json['tag'].toString():null;
    status = json['status'] != null ? json['status']:null;
    message = json['message'] != null ? json['message'].toString():null;
    rackNo = json['rackNo'] != null ? json['rackNo'].toString():null;
    deliveryStatusDesc = json['deliveryStatusDesc'] != null ? json['deliveryStatusDesc'].toString():null;
    isStorageFridge = json['isStorageFridge'] != null ? json['isStorageFridge']:null;
    isControlledDrugs = json['isControlledDrugs'] != null ? json['isControlledDrugs']:null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['alt_address'] = this.altAddress;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['countryId'] = this.countryId;
    data['townName'] = this.townName;
    data['contactNumber'] = this.contactNumber;
    data['email'] = this.email;
    data['postalCode'] = this.postalCode;
    data['nhsNumber'] = this.nhsNumber;
    data['pharmacyId'] = this.pharmacyId;
    data['branchId'] = this.branchId;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['paymentExemption'] = this.paymentExemption;
    data['landlineNumber'] = this.landlineNumber;
    data['alternativeContact'] = this.alternativeContact;
    data['dependentContactNumber'] = this.dependentContactNumber;
    data['surgeryId'] = this.surgeryId;
    data['surgeryName'] = this.surgeryName;
    data['isApproved'] = this.isApproved;
    data['pharmacyContactNo'] = this.pharmacyContactNo;
    data['branchContactNo'] = this.branchContactNo;
    data['deliveryNote'] = this.deliveryNote;
    data['branchNote'] = this.branchNote;
    data['surgeryNote'] = this.surgeryNote;
    data['serviceId'] = this.serviceId;
    data['routeId'] = this.routeId;
    data['lastOrderId'] = this.lastOrderId;
    data['orderId'] = this.orderId;
    data['tag'] = this.tag;
    data['status'] = this.status;
    data['message'] = this.message;
    data['rackNo'] = this.rackNo;
    data['deliveryStatusDesc'] = this.deliveryStatusDesc;
    data['isStorageFridge'] = this.isStorageFridge;
    data['isControlledDrugs'] = this.isControlledDrugs;
    return data;
  }
}

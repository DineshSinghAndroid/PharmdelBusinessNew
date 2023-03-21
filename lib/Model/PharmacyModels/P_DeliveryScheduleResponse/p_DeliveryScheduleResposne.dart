class DeliveryScheduleApiResponse {
  List<Shelf>? shelf;
  List<Services>? services;
  List<Surgery>? surgery;
  List<String>? deliveryType;
  List<NursingHomes>? nursingHomes;
  List<Exemptions>? exemptions;
  List<PatientSubscriptions>? patientSubscriptions;
  String? rxCharge;

  DeliveryScheduleApiResponse(
      {this.shelf,
      this.services,
      this.surgery,
      this.deliveryType,
      this.nursingHomes,
      this.exemptions,
      this.patientSubscriptions,
      this.rxCharge});

  DeliveryScheduleApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['shelf'] != null) {
      shelf = <Shelf>[];
      json['shelf'].forEach((v) {
        shelf!.add(new Shelf.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    if (json['surgery'] != null) {
      surgery = <Surgery>[];
      json['surgery'].forEach((v) {
        surgery!.add(new Surgery.fromJson(v));
      });
    }
    deliveryType = json['delivery_type'].cast<String>();
    if (json['nursing_homes'] != null) {
      nursingHomes = <NursingHomes>[];
      json['nursing_homes'].forEach((v) {
        nursingHomes!.add(new NursingHomes.fromJson(v));
      });
    }
    if (json['exemptions'] != null) {
      exemptions = <Exemptions>[];
      json['exemptions'].forEach((v) {
        exemptions!.add(new Exemptions.fromJson(v));
      });
    }
    if (json['patient_subscriptions'] != null) {
      patientSubscriptions = <PatientSubscriptions>[];
      json['patient_subscriptions'].forEach((v) {
        patientSubscriptions!.add(new PatientSubscriptions.fromJson(v));
      });
    }
    rxCharge = json['rx_charge'] != null ? json['rx_charge'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shelf != null) {
      data['shelf'] = this.shelf!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.surgery != null) {
      data['surgery'] = this.surgery!.map((v) => v.toJson()).toList();
    }
    data['delivery_type'] = this.deliveryType;
    if (this.nursingHomes != null) {
      data['nursing_homes'] =
          this.nursingHomes!.map((v) => v.toJson()).toList();
    }
    if (this.exemptions != null) {
      data['exemptions'] = this.exemptions!.map((v) => v.toJson()).toList();
    }
    if (this.patientSubscriptions != null) {
      data['patient_subscriptions'] =
          this.patientSubscriptions!.map((v) => v.toJson()).toList();
    }
    data['rx_charge'] = this.rxCharge;
    return data;
  }
}

class Shelf {
  String? id;
  String? name;
  String? isActive;

  Shelf({this.id, this.name, this.isActive});

  Shelf.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    isActive = json['isActive'] != null ? json['isActive'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    return data;
  }
}

class Services {
  String? id;
  String? name;
  String? isActive;

  Services({this.id, this.name, this.isActive});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    isActive = json['isActive'] != null ? json['isActive'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    return data;
  }
}

class Surgery {
  String? id;
  String? name;
  String? email;
  String? mobileNo;
  String? isActive;

  Surgery({this.id, this.name, this.email, this.mobileNo, this.isActive});

  Surgery.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    mobileNo = json['mobile_no'] != null ? json['mobile_no'].toString():null;
    isActive = json['isActive'] != null ? json['isActive'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['isActive'] = this.isActive;
    return data;
  }
}

class NursingHomes {
  String? id;
  String? name;
  String? email;
  String? status;
  String? pharmacyId;
  String? nursingHomeId;
  String? nursingHomeName;
  String? address;
  String? postCode;
  String? pharmacyName;

  NursingHomes(
      {this.id,
      this.name,
      this.email,
      this.status,
      this.pharmacyId,
      this.nursingHomeId,
      this.nursingHomeName,
      this.address,
      this.postCode,
      this.pharmacyName});

  NursingHomes.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    email = json['email'] != null ? json['email'].toString():null;
    status = json['status'] != null ? json['status'].toString():null;
    pharmacyId = json['pharmacy_id'] != null ? json['pharmacy_id'].toString():null;
    nursingHomeId = json['nursing_home_id'] != null ? json['nursing_home_id'].toString():null;
    nursingHomeName = json['nursing_home_name'] != null ? json['nursing_home_name'].toString():null;
    address = json['address'] != null ? json['address'].toString():null;
    postCode = json['post_code'] != null ? json['post_code'].toString():null;
    pharmacyName = json['pharmacy_name'] != null ? json['pharmacy_name'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['status'] = this.status;
    data['pharmacy_id'] = this.pharmacyId;
    data['nursing_home_id'] = this.nursingHomeId;
    data['nursing_home_name'] = this.nursingHomeName;
    data['address'] = this.address;
    data['post_code'] = this.postCode;
    data['pharmacy_name'] = this.pharmacyName;
    return data;
  }
}

class Exemptions {
  String? id;
  String? serialId;
  String? code;

  Exemptions({this.id, this.serialId, this.code});

  Exemptions.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    serialId = json['serial_id'] != null ? json['serial_id'].toString():null;
    code = json['code'] != null ? json['code'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serial_id'] = this.serialId;
    data['code'] = this.code;
    return data;
  }
}

class PatientSubscriptions {
  String? id;
  String? name;
  String? noOfDays;
  String? price;

  PatientSubscriptions({this.id, this.name, this.noOfDays, this.price});

  PatientSubscriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():null;
    name = json['name'] != null ? json['name'].toString():null;
    noOfDays = json['no_of_days'] != null ? json['no_of_days'].toString():null;
    price = json['price'] != null ? json['price'].toString():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['no_of_days'] = this.noOfDays;
    data['price'] = this.price;
    return data;
  }
}

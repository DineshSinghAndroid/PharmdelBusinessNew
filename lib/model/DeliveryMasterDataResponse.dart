// @dart=2.9
class DeliveryMasterDataResponse {
  List<Shelf> shelf;
  List<Shelf> services;
  List<Surgery> surgery;
  List<String> deliveryType;
  List<NursingHome> nursingHome;
  List<Exemptions> exemptions;
  List<PatientSubscription> patientSub;
  String rxCharge;

  DeliveryMasterDataResponse({this.shelf, this.services, this.surgery, this.deliveryType, this.nursingHome, this.exemptions, this.rxCharge});

  DeliveryMasterDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['rx_charge'] != null) {
      rxCharge = json['rx_charge'];
    }

    if (json['shelf'] != null) {
      shelf = new List<Shelf>();
      json['shelf'].forEach((v) {
        shelf.add(new Shelf.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = new List<Shelf>();
      json['services'].forEach((v) {
        services.add(new Shelf.fromJson(v));
      });
    }
    if (json['surgery'] != null) {
      surgery = new List<Surgery>();
      json['surgery'].forEach((v) {
        surgery.add(new Surgery.fromJson(v));
      });
    }
    deliveryType = json['delivery_type'].cast<String>();
    if (json['nursing_homes'] != null) {
      nursingHome = new List<NursingHome>();
      json['nursing_homes'].forEach((v) {
        nursingHome.add(new NursingHome.fromJson(v));
      });
    }
    if (json['exemptions'] != null) {
      exemptions = <Exemptions>[];
      json['exemptions'].forEach((v) {
        exemptions.add(new Exemptions.fromJson(v));
      });
    }
    if (json['patient_subscriptions'] != null) {
      patientSub = <PatientSubscription>[];
      json['patient_subscriptions'].forEach((v) {
        patientSub.add(new PatientSubscription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rxCharge != null) {
      data['rx_charge'] = this.rxCharge;
    }
    if (this.shelf != null) {
      data['shelf'] = this.shelf.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    if (this.surgery != null) {
      data['surgery'] = this.surgery.map((v) => v.toJson()).toList();
    }
    data['delivery_type'] = this.deliveryType;
    if (this.nursingHome != null) {
      data['nursing_homes'] = this.nursingHome.map((v) => v.toJson()).toList();
    }
    if (this.exemptions != null) {
      data['exemptions'] = this.exemptions.map((v) => v.toJson()).toList();
    }
    if (this.patientSub != null) {
      data['patient_subscriptions'] = this.patientSub.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shelf {
  int id;
  String name;
  int isActive;

  Shelf({this.id, this.name, this.isActive});

  Shelf.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
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
  int id;
  String name;
  String email;
  String mobileNo;
  int isActive;

  Surgery({this.id, this.name, this.email, this.mobileNo, this.isActive});

  Surgery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    isActive = json['isActive'];
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

class Exemptions {
  String serialId;
  int id;
  bool isSelected = false;
  String code;

  Exemptions({this.serialId, this.code});

  Exemptions.fromJson(Map<String, dynamic> json) {
    serialId = json['serial_id'];
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serial_id'] = this.serialId;
    data['id'] = this.id;
    data['code'] = this.code;
    return data;
  }
}

class NursingHome {
  int id;
  int pharmacy_id;
  String pharmacy_name;
  int nursing_home_id;
  String name;
  String nursing_home_name;
  String address;
  String post_code;
  String email;
  String status;

  NursingHome({this.id, this.name, this.pharmacy_id, this.pharmacy_name, this.nursing_home_id, this.nursing_home_name, this.address, this.post_code, this.email, this.status});

  NursingHome.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    pharmacy_id = json['pharmacy_id'];
    pharmacy_name = json['pharmacy_name'];
    nursing_home_id = json['nursing_home_id'];
    nursing_home_name = json['nursing_home_name'];
    address = json['address'];
    post_code = json['post_code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['pharmacy_id'] = pharmacy_id;
    data['pharmacy_name'] = pharmacy_name;
    data['nursing_home_id'] = nursing_home_id;
    data['nursing_home_name'] = nursing_home_name;
    data['address'] = address;
    data['post_code'] = post_code;
    data['status'] = status;
    return data;
  }
}

class PatientSubscription {
  String name;
  int id;
  int noOfDays;
  String price;

  PatientSubscription({this.id, this.name, this.noOfDays, this.price});

  PatientSubscription.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    noOfDays = json['no_of_days'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['no_of_days'] = this.noOfDays;
    data['price'] = this.price;
    return data;
  }
}

// @dart=2.9
// To parse this JSON data, do
//
//     final assignToShelf = assignToShelfFromJson(jsonString);

import 'dart:convert';

AssignToShelf assignToShelfFromJson(String str) => AssignToShelf.fromJson(json.decode(str));

String assignToShelfToJson(AssignToShelf data) => json.encode(data.toJson());

class AssignToShelf {
  AssignToShelf({
    //this.sc,
    this.patientInfoModel,
    this.doctorInfoModel,
    this.medicineDetails,
    //   this.isAddNewCustomer,
    this.status,
    // this.customerId,
    // this.orderId,
    // this.branchNote,
    // this.orderStatus,
    // this.deliveryDate,
    // this.deliveryNote,
    // this.surgeryNote,
    // this.caseTypeId,
    // this.recentDeliveryNote,
    // this.routeId,
    // this.pickupTypeId,
    // this.rackNo,
    // this.shelfId,
    // this.mobileNumer,
    // this.email,
    this.isStorageFridge,
    this.isControlledDrugs,
    this.message,
    this.isCollection,
    this.isValidOrder,
  });

  //Sc sc;
  PatientInfoModel patientInfoModel;
  DoctorInfoModel doctorInfoModel;
  List<MedicineDetail> medicineDetails;

  // bool isAddNewCustomer;
  bool status;

  // int customerId;
  // int orderId;
  //  dynamic branchNote;
  //  String orderStatus;
  //  dynamic deliveryDate;
  //  String deliveryNote;
  //  dynamic surgeryNote;
  //  dynamic caseTypeId;
  //  dynamic recentDeliveryNote;
  //  dynamic routeId;
  //  int pickupTypeId;
  //  dynamic rackNo;
  //  int shelfId;
  //  dynamic mobileNumer;
  //  dynamic email;
  //  dynamic deliveryStatusDesc;
  //  dynamic pickupType;
  String message;
  bool isCollection;
  bool isStorageFridge;
  bool isControlledDrugs;
  bool isValidOrder;

  factory AssignToShelf.fromJson(Map<String, dynamic> json) => AssignToShelf(
        // sc: Sc.fromJson(json["sc"]),
        patientInfoModel: PatientInfoModel.fromJson(json["patientInfoModel"]),
        doctorInfoModel: DoctorInfoModel.fromJson(json["doctorInfoModel"]),
        medicineDetails: List<MedicineDetail>.from(json["medicineDetails"].map((x) => MedicineDetail.fromJson(x))),
        //  isAddNewCustomer: json["isAddNewCustomer"],
        status: json["status"],
        // customerId: json["customerId"],
        // orderId: json["orderId"],
        // branchNote: json["branchNote"],
        // orderStatus: json["orderStatus"],
        // deliveryDate: json["deliveryDate"],
        // deliveryNote: json["deliveryNote"],
        // surgeryNote: json["surgeryNote"],
        // caseTypeId: json["caseTypeId"],
        // recentDeliveryNote: json["recentDeliveryNote"],
        // routeId: json["routeId"],
        // pickupTypeId: json["pickupTypeId"],
        // rackNo: json["rackNo"],
        // shelfId: json["shelfId"],
        // mobileNumer: json["mobileNumer"],
        // email: json["email"],
        // deliveryStatusDesc: json["deliveryStatusDesc"],
        isControlledDrugs: json["isControlledDrugs"],
        isCollection: json["isCollection"],
        isStorageFridge: json["isStorageFridge"],
        message: json["message"],
        isValidOrder: json["isValidOrder"],
      );

  Map<String, dynamic> toJson() => {
        // "sc": sc.toJson(),
        "patientInfoModel": patientInfoModel.toJson(),
        "doctorInfoModel": doctorInfoModel.toJson(),
        "medicineDetails": List<dynamic>.from(medicineDetails.map((x) => x.toJson())),
        //   "isAddNewCustomer": isAddNewCustomer,
        "status": status,
        // "customerId": customerId,
        // "orderId": orderId,
        // "branchNote": branchNote,
        // "orderStatus": orderStatus,
        // "deliveryDate": deliveryDate,
        // "deliveryNote": deliveryNote,
        // "surgeryNote": surgeryNote,
        // "caseTypeId": caseTypeId,
        // "recentDeliveryNote": recentDeliveryNote,
        // "routeId": routeId,
        // "pickupTypeId": pickupTypeId,
        // "rackNo": rackNo,
        // "shelfId": shelfId,
        // "mobileNumer": mobileNumer,
        // "email": email,
        "isStorageFridge": isStorageFridge,
        "isControlledDrugs": isControlledDrugs,
        "message": message,
        "isCollection": isCollection,
        "IsValidOrder": isValidOrder,
      };
}

class DoctorInfoModel {
  DoctorInfoModel({
    this.i,
    this.doctorName,
    this.companyName,
    this.companyId,
    this.address,
    this.postCode,
  });

  String i;
  String doctorName;
  String companyName;
  dynamic companyId;
  dynamic address;
  dynamic postCode;

  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) => DoctorInfoModel(
        i: json["i"],
        doctorName: json["doctorName"],
        companyName: json["companyName"],
        companyId: json["companyId"],
        address: json["address"],
        postCode: json["postCode"],
      );

  Map<String, dynamic> toJson() => {
        "i": i,
        "doctorName": doctorName,
        "companyName": companyName,
        "companyId": companyId,
        "address": address,
        "postCode": postCode,
      };
}

class MedicineDetail {
  MedicineDetail({
    this.medicineName,
    this.dosage,
    this.drugType,
    this.isFridge,
    this.isControl,
    this.remarks,
    this.days,
    //   this.u,
    //   this.abbesion,
    //   this.dm,
    this.quantity,
    //  this.isVisible,
  });

  String medicineName;
  String dosage;
  dynamic drugType;
  bool isFridge;
  bool isControl;
  dynamic remarks;
  dynamic days;

  // String u;
  // String abbesion;
  // dynamic dm;
  String quantity;

  //dynamic isVisible;

  factory MedicineDetail.fromJson(Map<String, dynamic> json) => MedicineDetail(
        medicineName: json["medicineName"],
        dosage: json["dosage"],
        drugType: json["drugType"],
        isFridge: json["isFridge"],
        isControl: json["isControl"],
        remarks: json["remarks"],
        days: json["days"],
        //  u: json["u"],
        //   abbesion: json["abbesion"],
        // dm: json["dm"],
        quantity: json["quantity"],
        //   isVisible: json["isVisible"],
      );

  Map<String, dynamic> toJson() => {
        "medicineName": medicineName,
        "dosage": dosage,
        "drugType": drugType,
        "isFridge": isFridge,
        "isControl": isControl,
        "remarks": remarks,
        "days": days,
        //  "u": u,
        // "abbesion": abbesion,
        //  "dm": dm,
        "quantity": quantity,
        //  "isVisible": isVisible,
      };
}

class PatientInfoModel {
  PatientInfoModel({
    this.lastName,
    this.middleName,
    this.firstName,
    this.salutation,
    this.nhsNumber,
    this.dob,
    this.x,
    this.age,
    this.address,
    this.postCode,
  });

  String lastName;
  String middleName;
  String firstName;
  String salutation;
  String nhsNumber;
  String dob;
  dynamic x;
  dynamic age;
  String address;
  String postCode;

  factory PatientInfoModel.fromJson(Map<String, dynamic> json) => PatientInfoModel(
        lastName: json["lastName"],
        middleName: json["middleName"],
        firstName: json["firstName"],
        salutation: json["salutation"],
        nhsNumber: json["nhsNumber"],
        dob: json["dob"],
        x: json["x"],
        age: json["age"],
        address: json["address"],
        postCode: json["postCode"],
      );

  Map<String, dynamic> toJson() => {
        "lastName": lastName,
        "middleName": middleName,
        "firstName": firstName,
        "salutation": salutation,
        "nhsNumber": nhsNumber,
        "dob": dob,
        "x": x,
        "age": age,
        "address": address,
        "postCode": postCode,
      };
}

class Sc {
  Sc({
    this.id,
    this.ft,
    this.t,
    this.dn,
  });

  dynamic id;
  dynamic ft;
  dynamic t;
  dynamic dn;

  factory Sc.fromJson(Map<String, dynamic> json) => Sc(
        id: json["id"],
        ft: json["ft"],
        t: json["t"],
        dn: json["dn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ft": ft,
        "t": t,
        "dn": dn,
      };
}

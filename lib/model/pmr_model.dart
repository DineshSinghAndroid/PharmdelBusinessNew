// @dart=2.9
// To parse this JSON data, do
//
//     final pmrModel = pmrModelFromJson(jsonString);

import 'dart:convert';
import 'dart:core';

PmrModel pmrModelFromJson(String str) => PmrModel.fromJson(json.decode(str));

String pmrModelToJson(PmrModel data) => json.encode(data.toJson());

class PmrModel {
  PmrModel({
    this.xml,
  });

  Xml xml;

  factory PmrModel.fromJson(Map<String, dynamic> json) => PmrModel(
        xml: Xml.fromJson(json["xml"]),
      );

  Map<String, dynamic> toJson() => {
        "xml": xml.toJson(),
      };
}

class Xml {
  Xml({
    this.sc,
    this.patientInformation,
    this.doctorInformation,
    this.dd,
    this.deliveryDate,
    this.deliveryNote,
    this.surgeryNote,
    this.recentDeliveryNote,
    this.routeId,
    this.isAddNewCustomer,
    this.status,
    this.customerId,
    this.orderId,
    this.branchNote,
    this.rackNo,
    this.pickUpType,
  });

  Sc sc;
  Pa patientInformation;
  Pb doctorInformation;
  List<Dd> dd = List();

  DateTime deliveryDate;
  String deliveryNote;
  String surgeryNote;
  String recentDeliveryNote;
  int routeId;
  bool isAddNewCustomer;
  bool status;
  dynamic customerId;
  dynamic alt_address;
  int orderId;
  String branchNote;
  String rackNo;
  String pickUpType;

  Xml.fromJson(Map<String, dynamic> json) {
    sc = Sc.fromJson(json["sc"]);
    patientInformation = Pa.fromJson(json["pa"]);
    doctorInformation = Pb.fromJson(json["pb"]);

    try {
      dd = List<Dd>.from(json["dd"].map((x) => Dd.fromJson(x)));
    } catch (_) {
      Dd dd1 = Dd.fromJson(json["dd"]);
      dd = <Dd>[dd1];
    }

    deliveryDate = json["DeliveryDate"];
    deliveryNote = json["DeliveryNote"];
    surgeryNote = json["SurgeryNote"];
    recentDeliveryNote = json["RecentDeliveryNote"];
    alt_address = json["alt_address"];
    routeId = json["RouteId"];
    isAddNewCustomer = json["IsAddNewCustomer"];
    status = json["Status"];
    customerId = json["CustomerId"];
    orderId = json["OrderId"];
    branchNote = json["BranchNote"];
    rackNo = json["RackNo"];
    pickUpType = json["PickupType"];
  }

  Map<String, dynamic> toJson() => {
        "sc": sc.toJson(),
        "pa": patientInformation.toJson(),
        "pb": doctorInformation.toJson(),
        "dd": List<dynamic>.from(dd.map((x) => x.toJson())),
        "DeliveryDate": deliveryDate,
        "DeliveryNote": deliveryNote,
        "alt_address": alt_address,
        "SurgeryNote": surgeryNote,
        "RecentDeliveryNote": recentDeliveryNote,
        "RouteId": routeId,
        "IsAddNewCustomer": isAddNewCustomer ?? false,
        "Status": status ?? false,
        "CustomerId": customerId ?? 0,
        "OrderId": orderId ?? 0,
        "BranchNote": branchNote,
        "RackNo": rackNo,
        "PickupType": pickUpType,
      };
}

class Dd {
  Dd({
    this.d,
    this.ddDo,
    this.dm,
    this.q,
    this.u,
    this.sq,
    this.drugsTypeFr,
    this.drugsTypeCD,
  });

  String d;
  String ddDo;
  String dm;
  String q;
  String u;
  String sq;
  bool drugsTypeFr;
  bool drugsTypeCD;

  factory Dd.fromJson(Map<String, dynamic> json) => Dd(
        d: json["d"],
        ddDo: json["do"],
        dm: json["dm"],
        q: json["q"],
        u: json["u"],
        sq: json["sq"],
        drugsTypeFr: json["drugsType"],
        drugsTypeCD: json["drugsTypeCD"],
      );

  Map<String, dynamic> toJson() => {"d": d, "do": ddDo, "dm": dm, "q": q, "u": u, "sq": sq, "drugsType": drugsTypeFr, "drugsTypeCD": drugsTypeCD};
}

class Pa {
  Pa({
    this.lastName,
    this.middleName,
    this.firstName,
    this.salutation,
    this.nhs,
    this.dob,
    this.x,
    this.age,
    this.address,
    this.postCode,
  });

  String lastName = "";
  String middleName = "";
  String firstName = "";
  String salutation = "";
  dynamic nhs;
  dynamic nursing_home_id;
  String dob = "";
  String x = "";
  String age = "";
  String address = "";
  String mobileNo = "";
  String email_id = "";
  String postCode = "";

  factory Pa.fromJson(Map<String, dynamic> json) => Pa(
        lastName: json["l"],
        middleName: json["m"],
        firstName: json["f"],
        salutation: json["s"],
        nhs: json["h"],
        dob: json["b"],
        x: json["x"],
        age: json["o"],
        address: json["a"],
        postCode: json["pc"],
      );

  Map<String, dynamic> toJson() => {
        "l": lastName,
        "m": middleName,
        "f": firstName,
        "s": salutation,
        "h": nhs,
        "b": dob,
        "x": x,
        "o": age,
        "a": address,
        "pc": postCode,
      };
}

class Pb {
  Pb({
    this.i,
    this.doctorName,
    this.companyName,
    this.companyId,
    this.address,
    this.postCode,
  });

  String i;
  String doctorName;
  String companyName; //Surgery
  String companyId;
  String address;
  String postCode;

  factory Pb.fromJson(Map<String, dynamic> json) => Pb(
        i: json["i"],
        doctorName: json["d"],
        companyName: json["n"],
        companyId: json["pi"],
        address: json["a"],
        postCode: json["pc"],
      );

  Map<String, dynamic> toJson() => {
        "i": i,
        "d": doctorName,
        "n": companyName,
        "pi": companyId,
        "a": address,
        "pc": postCode,
      };
}

class Sc {
  Sc({
    this.id,
    this.ft,
    this.t,
    this.dn,
  });

  String id;
  String ft;
  String t;
  String dn;

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

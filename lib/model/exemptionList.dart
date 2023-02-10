// @dart=2.9
import 'dart:convert';

ExemptionList1 exemptionList1FromJson(String str) => ExemptionList1.fromJson(json.decode(str));

String exemptionList1ToJson(ExemptionList1 data) => json.encode(data.toJson());

class ExemptionList1 {
  List<Exemptions> exemptions;

  ExemptionList1({this.exemptions});

  ExemptionList1.fromJson(Map<String, dynamic> json) {
    if (json['exemptions'] != null) {
      exemptions = <Exemptions>[];
      json['exemptions'].forEach((v) {
        exemptions.add(new Exemptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exemptions != null) {
      data['exemptions'] = this.exemptions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exemptions {
  int id;
  String serialId;
  String code;
  bool isSelected = false;

  Exemptions({this.id, this.serialId, this.code});

  Exemptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serialId = json['serial_id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serial_id'] = this.serialId;
    data['code'] = this.code;
    return data;
  }
}

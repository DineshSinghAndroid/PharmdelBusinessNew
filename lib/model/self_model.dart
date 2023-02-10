// @dart=2.9
import 'dart:convert';

List<ShelfModel> shelfModelFromJson(String str) => List<ShelfModel>.from(json.decode(str).map((x) => ShelfModel.fromJson(x)));

String shelfModelToJson(List<ShelfModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShelfModel {
  ShelfModel({
    this.shelfId,
    this.branchId,
    this.name,
    this.isActive,
    this.qrCodeText,
  });

  int shelfId;
  int branchId;
  String name;
  int isActive;
  String qrCodeText;

  factory ShelfModel.fromJson(Map<String, dynamic> json) => ShelfModel(
        shelfId: json["shelfId"],
        branchId: json["branchId"],
        name: json["name"],
        isActive: json["isActive"],
        qrCodeText: json["qrCodeText"],
      );

  Map<String, dynamic> toJson() => {
        "shelfId": shelfId,
        "branchId": branchId,
        "name": name,
        "isActive": isActive,
        "qrCodeText": qrCodeText,
      };
}

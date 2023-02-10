// @dart=2.9
import 'dart:convert';

List<UpdateLocation> updateLocationFromJson(String str) => List<UpdateLocation>.from(json.decode(str).map((x) => UpdateLocation.fromJson(x)));

String updateLocationToJson(List<UpdateLocation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UpdateLocation {
  UpdateLocation({
    this.longitude,
    this.latitude,
  });

  String longitude;
  String latitude;

  factory UpdateLocation.fromJson(Map<String, dynamic> json) => UpdateLocation(
        longitude: json["Longitude"],
        latitude: json["Latitude"],
      );

  Map<String, dynamic> toJson() => {
        "Longitude": longitude,
        "Latitude": latitude,
      };
}

// To parse this JSON data, do
//
//     final cutOffModel = cutOffModelFromJson(jsonString);

import 'dart:convert';

List<CutOffModel> cutOffModelFromJson(String str) =>
    List<CutOffModel>.from(json.decode(str).map((x) => CutOffModel.fromJson(x)));

String cutOffModelToJson(List<CutOffModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CutOffModel {
  int id;
  int locationId;
  bool isActive;
  DateTime startDate;
  DateTime endDate;

  CutOffModel({
    required this.id,
    required this.locationId,
    required this.isActive,
    required this.startDate,
    required this.endDate,
  });

  factory CutOffModel.fromJson(Map<String, dynamic> json) => CutOffModel(
        id: json["Id"],
        locationId: json["LocationId"],
        isActive: json["isActive"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "LocationId": locationId,
        "isActive": isActive,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };
}

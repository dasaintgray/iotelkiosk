// To parse this JSON data, do
//
//     final cutOffModel = cutOffModelFromJson(jsonString);

import 'dart:convert';

CutOffModel cutOffModelFromJson(String str) => CutOffModel.fromJson(json.decode(str));

String cutOffModelToJson(CutOffModel data) => json.encode(data.toJson());

class CutOffModel {
  Data data;

  CutOffModel({
    required this.data,
  });

  factory CutOffModel.fromJson(Map<String, dynamic> json) => CutOffModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<CutOff> cutOffs;

  Data({
    required this.cutOffs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cutOffs: List<CutOff>.from(json["CutOffs"].map((x) => CutOff.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CutOffs": List<dynamic>.from(cutOffs.map((x) => x.toJson())),
      };
}

class CutOff {
  int id;
  int locationId;
  bool isActive;
  DateTime startDate;
  DateTime endDate;

  CutOff({
    required this.id,
    required this.locationId,
    required this.isActive,
    required this.startDate,
    required this.endDate,
  });

  factory CutOff.fromJson(Map<String, dynamic> json) => CutOff(
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

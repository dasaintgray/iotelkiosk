// To parse this JSON data, do
//
//     final accomTypeModel = accomTypeModelFromJson(jsonString);

import 'dart:convert';

AccomTypeModel accomTypeModelFromJson(String str) => AccomTypeModel.fromJson(json.decode(str));

String accomTypeModelToJson(AccomTypeModel data) => json.encode(data.toJson());

class AccomTypeModel {
  AccomTypeModel({
    required this.data,
  });

  Data data;

  factory AccomTypeModel.fromJson(Map<String, dynamic> json) => AccomTypeModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.accommodationTypes,
  });

  List<AccommodationType> accommodationTypes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accommodationTypes:
            List<AccommodationType>.from(json["AccommodationTypes"].map((x) => AccommodationType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AccommodationTypes": List<dynamic>.from(accommodationTypes.map((x) => x.toJson())),
      };
}

class AccommodationType {
  AccommodationType({
    required this.id,
    required this.valueMin,
    required this.valueMax,
    required this.description,
    required this.code,
    required this.seq,
    this.translatedText,
  });

  int id;
  double valueMin;
  double valueMax;
  String description;
  String code;
  int seq;
  late String? translatedText;

  factory AccommodationType.fromJson(Map<String, dynamic> json) => AccommodationType(
        id: json["Id"],
        valueMin: json["valueMin"],
        valueMax: json["valueMax"],
        description: json["description"],
        code: json["code"],
        seq: json["seq"],
        translatedText: json["translatedText"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "valueMin": valueMin,
        "valueMax": valueMax,
        "description": description,
        "code": code,
        "seq": seq,
        "translatedText": translatedText
      };
}

// To parse this JSON data, do
//
//     final lenguwaheModel = lenguwaheModelFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

LenguwaheModel lenguwaheModelFromJson(String str) => LenguwaheModel.fromJson(json.decode(str));

String lenguwaheModelToJson(LenguwaheModel data) => json.encode(data.toJson());

class LenguwaheModel {
  Data data;

  LenguwaheModel({
    required this.data,
  });

  factory LenguwaheModel.fromJson(Map<String, dynamic> json) => LenguwaheModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<Lenguwahe> lenguwahe;

  Data({
    required this.lenguwahe,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lenguwahe: List<Lenguwahe>.from(json["lenguwahe"].map((x) => Lenguwahe.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lenguwahe": List<dynamic>.from(lenguwahe.map((x) => x.toJson())),
      };
}

class Lenguwahe {
  int id;
  String code;
  String description;
  String flag;
  List<LenguwaheDetail> lenguwaheDetails;

  Lenguwahe({
    required this.id,
    required this.code,
    required this.description,
    required this.flag,
    required this.lenguwaheDetails,
  });

  factory Lenguwahe.fromJson(Map<String, dynamic> json) => Lenguwahe(
        id: json["Id"],
        code: json["code"],
        description: json["description"],
        flag: json["flag"],
        lenguwaheDetails: List<LenguwaheDetail>.from(json["lenguwahe_details"].map((x) => LenguwaheDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "description": description,
        "flag": flag,
        "lenguwahe_details": List<dynamic>.from(lenguwaheDetails.map((x) => x.toJson())),
      };
}

class LenguwaheDetail {
  int languageId;
  String code;
  Type type;
  String translationText;
  String description;
  String images;

  LenguwaheDetail({
    required this.languageId,
    required this.code,
    required this.type,
    required this.translationText,
    required this.description,
    required this.images,
  });

  factory LenguwaheDetail.fromJson(Map<String, dynamic> json) => LenguwaheDetail(
        languageId: json["LanguageId"],
        code: json["code"],
        type: typeValues.map[json["type"]]!,
        translationText: json["translationText"],
        description: json["description"],
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "LanguageId": languageId,
        "code": code,
        "type": typeValues.reverse[type],
        "translationText": translationText,
        "description": description,
        "images": images,
      };
}

enum Type { TITLE, MESSAGE, BUTTON, ITEM }

final typeValues = EnumValues({"BUTTON": Type.BUTTON, "ITEM": Type.ITEM, "MESSAGE": Type.MESSAGE, "TITLE": Type.TITLE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// To parse this JSON data, do
//
//     final roomTypesModel = roomTypesModelFromJson(jsonString);

import 'dart:convert';

RoomTypesModel roomTypesModelFromJson(String str) => RoomTypesModel.fromJson(json.decode(str));

String roomTypesModelToJson(RoomTypesModel data) => json.encode(data.toJson());

class RoomTypesModel {
  Data data;

  RoomTypesModel({
    required this.data,
  });

  factory RoomTypesModel.fromJson(Map<String, dynamic> json) => RoomTypesModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<RoomType> roomTypes;

  Data({
    required this.roomTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        roomTypes: List<RoomType>.from(json["RoomTypes"].map((x) => RoomType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RoomTypes": List<dynamic>.from(roomTypes.map((x) => x.toJson())),
      };
}

class RoomType {
  int id;
  bool isActive;
  String code;
  String description;
  late String? translatedText;

  RoomType({
    required this.id,
    required this.isActive,
    required this.code,
    required this.description,
    this.translatedText,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
        id: json["Id"],
        isActive: json["isActive"],
        code: json["code"],
        description: json["description"],
        translatedText: json["translatedText"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "isActive": isActive,
        "code": code,
        "description": description,
        "translatedText": translatedText,
      };
}

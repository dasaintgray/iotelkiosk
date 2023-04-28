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
  int locationId;
  bool isActive;
  String description;
  String code;

  RoomType({
    required this.id,
    required this.locationId,
    required this.isActive,
    required this.description,
    required this.code,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
        id: json["Id"],
        locationId: json["LocationId"],
        isActive: json["isActive"],
        description: json["description"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "LocationId": locationId,
        "isActive": isActive,
        "description": description,
        "code": code,
      };
}

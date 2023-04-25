// To parse this JSON data, do
//
//     final roomTypesModel = roomTypesModelFromJson(jsonString);

import 'dart:convert';

RoomTypesModel roomTypesModelFromJson(String str) => RoomTypesModel.fromJson(json.decode(str));

String roomTypesModelToJson(RoomTypesModel data) => json.encode(data.toJson());

class RoomTypesModel {
  RoomTypesModel({
    required this.data,
  });

  Data data;

  factory RoomTypesModel.fromJson(Map<String, dynamic> json) => RoomTypesModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.roomTypes,
  });

  List<RoomType> roomTypes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        roomTypes: List<RoomType>.from(json["RoomTypes"].map((x) => RoomType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RoomTypes": List<dynamic>.from(roomTypes.map((x) => x.toJson())),
      };
}

class RoomType {
  RoomType({
    required this.id,
    required this.locationId,
    required this.isActive,
    required this.code,
    required this.description,
  });

  int id;
  int locationId;
  bool isActive;
  String code;
  String description;

  factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
        id: json["Id"],
        locationId: json["LocationId"],
        isActive: json["isActive"],
        code: json["code"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "LocationId": locationId,
        "isActive": isActive,
        "code": code,
        "description": description,
      };
}

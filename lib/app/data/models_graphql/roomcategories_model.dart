// To parse this JSON data, do
//
//     final roomCategoriesModel = roomCategoriesModelFromJson(jsonString);

import 'dart:convert';

RoomCategoriesModel roomCategoriesModelFromJson(String str) => RoomCategoriesModel.fromJson(json.decode(str));

String roomCategoriesModelToJson(RoomCategoriesModel data) => json.encode(data.toJson());

class RoomCategoriesModel {
  RoomCategoriesModel({
    required this.data,
  });

  Data data;

  factory RoomCategoriesModel.fromJson(Map<String, dynamic> json) => RoomCategoriesModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.roomCategories,
  });

  List<RoomCategory> roomCategories;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        roomCategories: List<RoomCategory>.from(json["RoomCategories"].map((x) => RoomCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RoomCategories": List<dynamic>.from(roomCategories.map((x) => x.toJson())),
      };
}

class RoomCategory {
  RoomCategory({
    required this.id,
    required this.isActive,
    required this.description,
    required this.code,
    required this.roomCategoriesLocation,
  });

  int id;
  bool isActive;
  String description;
  String code;
  RoomCategoriesLocation roomCategoriesLocation;

  factory RoomCategory.fromJson(Map<String, dynamic> json) => RoomCategory(
        id: json["Id"],
        isActive: json["isActive"],
        description: json["description"],
        code: json["code"],
        roomCategoriesLocation: RoomCategoriesLocation.fromJson(json["RoomCategories_Location"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "isActive": isActive,
        "description": description,
        "code": code,
        "RoomCategories_Location": roomCategoriesLocation.toJson(),
      };
}

class RoomCategoriesLocation {
  RoomCategoriesLocation({
    this.code,
    required this.description,
  });

  dynamic code;
  String description;

  factory RoomCategoriesLocation.fromJson(Map<String, dynamic> json) => RoomCategoriesLocation(
        code: json["code"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
      };
}

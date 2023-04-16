// To parse this JSON data, do
//
//     final availableRoomsModel = availableRoomsModelFromJson(jsonString);

import 'dart:convert';

AvailableRoomsModel availableRoomsModelFromJson(String str) => AvailableRoomsModel.fromJson(json.decode(str));

String availableRoomsModelToJson(AvailableRoomsModel data) => json.encode(data.toJson());

class AvailableRoomsModel {
  AvailableRoomsModel({
    required this.data,
  });

  Data data;

  factory AvailableRoomsModel.fromJson(Map<String, dynamic> json) => AvailableRoomsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.rooms,
  });

  List<Room> rooms;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        rooms: List<Room>.from(json["rooms"].map((x) => Room.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
      };
}

class Room {
  Room({
    required this.id,
    required this.description,
    required this.code,
  });

  int id;
  String description;
  String code;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["Id"],
        description: json["description"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "description": description,
        "code": code,
      };
}

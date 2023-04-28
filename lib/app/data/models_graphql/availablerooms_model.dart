// To parse this JSON data, do
//
//     final availableRoomsModel = availableRoomsModelFromJson(jsonString);

import 'dart:convert';

AvailableRoomsModel availableRoomsModelFromJson(String str) => AvailableRoomsModel.fromJson(json.decode(str));

String availableRoomsModelToJson(AvailableRoomsModel data) => json.encode(data.toJson());

class AvailableRoomsModel {
  Data data;

  AvailableRoomsModel({
    required this.data,
  });

  factory AvailableRoomsModel.fromJson(Map<String, dynamic> json) => AvailableRoomsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<AvailableRoom> availableRooms;

  Data({
    required this.availableRooms,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        availableRooms: List<AvailableRoom>.from(json["AvailableRooms"].map((x) => AvailableRoom.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "AvailableRooms": List<dynamic>.from(availableRooms.map((x) => x.toJson())),
      };
}

class AvailableRoom {
  String description;
  double rate;
  double serviceCharge;
  String? photo;
  String id;

  AvailableRoom({
    required this.description,
    required this.rate,
    required this.serviceCharge,
    this.photo,
    required this.id,
  });

  factory AvailableRoom.fromJson(Map<String, dynamic> json) => AvailableRoom(
        description: json["description"],
        rate: json["rate"],
        serviceCharge: json["serviceCharge"],
        photo: json["photo"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "rate": rate,
        "serviceCharge": serviceCharge,
        "photo": photo,
        "id": id,
      };
}

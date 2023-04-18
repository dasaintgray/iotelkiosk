// To parse this JSON data, do
//
//     final roomAvailableModel = roomAvailableModelFromJson(jsonString);

import 'dart:convert';

List<RoomAvailableModel> roomAvailableModelFromJson(String str) =>
    List<RoomAvailableModel>.from(json.decode(str).map((x) => RoomAvailableModel.fromJson(x)));

String roomAvailableModelToJson(List<RoomAvailableModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoomAvailableModel {
  RoomAvailableModel({
    required this.rate,
    required this.serviceCharge,
    this.photo,
    required this.id,
    required this.description,
  });

  double rate;
  double serviceCharge;
  String? photo;
  int id;
  String description;

  factory RoomAvailableModel.fromJson(Map<String, dynamic> json) => RoomAvailableModel(
        rate: json["rate"],
        serviceCharge: json["serviceCharge"],
        photo: json["photo"],
        id: json["Id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "serviceCharge": serviceCharge,
        "photo": photo,
        "Id": id,
        "description": description,
      };
}

// To parse this JSON data, do
//
//     final locationsModel = locationsModelFromJson(jsonString);

import 'dart:convert';

LocationsModel locationsModelFromJson(String str) => LocationsModel.fromJson(json.decode(str));

String locationsModelToJson(LocationsModel data) => json.encode(data.toJson());

class LocationsModel {
  LocationsModel({
    required this.data,
  });

  Data data;

  factory LocationsModel.fromJson(Map<String, dynamic> json) => LocationsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.locations,
  });

  List<Location> locations;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        locations: List<Location>.from(json["Locations"].map((x) => Location.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Locations": List<dynamic>.from(locations.map((x) => x.toJson())),
      };
}

class Location {
  Location({
    required this.id,
    this.code,
    required this.description,
    this.locationsRoomCategories,
  });

  int id;
  String? code;
  String description;
  List<Location>? locationsRoomCategories;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["Id"],
        code: json["code"],
        description: json["description"],
        locationsRoomCategories: json["Locations_RoomCategories"] == null
            ? []
            : List<Location>.from(json["Locations_RoomCategories"]!.map((x) => Location.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "description": description,
        "Locations_RoomCategories":
            locationsRoomCategories == null ? [] : List<dynamic>.from(locationsRoomCategories!.map((x) => x.toJson())),
      };
}

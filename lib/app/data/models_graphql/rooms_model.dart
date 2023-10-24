// To parse this JSON data, do
//
//     final roomsModel = roomsModelFromJson(jsonString);

import 'dart:convert';

RoomsModel roomsModelFromJson(String str) => RoomsModel.fromJson(json.decode(str));

String roomsModelToJson(RoomsModel data) => json.encode(data.toJson());

class RoomsModel {
    final Data data;

    RoomsModel({
        required this.data,
    });

    factory RoomsModel.fromJson(Map<String, dynamic> json) => RoomsModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    final List<Room> rooms;

    Data({
        required this.rooms,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        rooms: List<Room>.from(json["Rooms"].map((x) => Room.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Rooms": List<dynamic>.from(rooms.map((x) => x.toJson())),
    };
}

class Room {
    final int id;
    final int isActive;
    final String description;
    final String code;
    final bool isFunctionRoom;
    final int minPax;
    final int maxPax;
    final int isWithBreakfast;
    final int isLockset;
    final int bed;

    Room({
        required this.id,
        required this.isActive,
        required this.description,
        required this.code,
        required this.isFunctionRoom,
        required this.minPax,
        required this.maxPax,
        required this.isWithBreakfast,
        required this.isLockset,
        required this.bed,
    });

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["Id"],
        isActive: json["isActive"],
        description: json["description"],
        code: json["code"],
        isFunctionRoom: json["isFunctionRoom"],
        minPax: json["minPAX"],
        maxPax: json["maxPAX"],
        isWithBreakfast: json["isWithBreakfast"],
        isLockset: json["isLockset"],
        bed: json["bed"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "isActive": isActive,
        "description": description,
        "code": code,
        "isFunctionRoom": isFunctionRoom,
        "minPAX": minPax,
        "maxPAX": maxPax,
        "isWithBreakfast": isWithBreakfast,
        "isLockset": isLockset,
        "bed": bed,
    };
}

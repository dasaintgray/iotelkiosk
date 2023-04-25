// To parse this JSON data, do
//
//     final peopleModel = peopleModelFromJson(jsonString);

import 'dart:convert';

PeopleModel peopleModelFromJson(String str) => PeopleModel.fromJson(json.decode(str));

String peopleModelToJson(PeopleModel data) => json.encode(data.toJson());

class PeopleModel {
  PeopleModel({
    required this.data,
  });

  Data data;

  factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.people,
  });

  List<Person> people;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        people: List<Person>.from(json["People"].map((x) => Person.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "People": List<dynamic>.from(people.map((x) => x.toJson())),
      };
}

class Person {
  Person({
    required this.id,
    required this.code,
    required this.name,
    required this.discriminator,
    required this.isBanned,
    this.bannedDate,
    required this.peopleContactPhotoes,
  });

  int id;
  String code;
  String name;
  Discriminator discriminator;
  bool isBanned;
  dynamic bannedDate;
  List<dynamic> peopleContactPhotoes;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["Id"],
        code: json["code"],
        name: json["Name"],
        discriminator: discriminatorValues.map[json["Discriminator"]]!,
        isBanned: json["isBanned"],
        bannedDate: json["bannedDate"],
        peopleContactPhotoes: List<dynamic>.from(json["People_ContactPhotoes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "Name": name,
        "Discriminator": discriminatorValues.reverse[discriminator],
        "isBanned": isBanned,
        "bannedDate": bannedDate,
        "People_ContactPhotoes": List<dynamic>.from(peopleContactPhotoes.map((x) => x)),
      };
}

// ignore: constant_identifier_names
enum Discriminator { CONTACT, EMPTY }

final discriminatorValues = EnumValues({"Contact": Discriminator.CONTACT, "": Discriminator.EMPTY});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

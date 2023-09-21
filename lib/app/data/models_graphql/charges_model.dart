// To parse this JSON data, do
//
//     final chargesModel = chargesModelFromJson(jsonString);

import 'dart:convert';

ChargesModel chargesModelFromJson(String str) => ChargesModel.fromJson(json.decode(str));

String chargesModelToJson(ChargesModel data) => json.encode(data.toJson());

class ChargesModel {
  final Data data;

  ChargesModel({
    required this.data,
  });

  factory ChargesModel.fromJson(Map<String, dynamic> json) => ChargesModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<Charge> charges;

  Data({
    required this.charges,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        charges: List<Charge>.from(json["Charges"].map((x) => Charge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Charges": List<dynamic>.from(charges.map((x) => x.toJson())),
      };
}

class Charge {
  final int id;
  final int locationId;
  final int seq;
  final bool isActive;
  final bool isAllowEdit;
  final double rate;
  final bool isDefault;
  final bool useFormula;
  final String description;
  final bool isAllowEditQty;
  final bool isForCheckOut;
  final bool isForDebit;
  String? code;

  Charge({
    required this.id,
    required this.locationId,
    required this.seq,
    required this.isActive,
    required this.isAllowEdit,
    required this.rate,
    required this.isDefault,
    required this.useFormula,
    required this.description,
    required this.isAllowEditQty,
    required this.isForCheckOut,
    required this.isForDebit,
    this.code,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
        id: json["Id"],
        locationId: json["locationID"],
        seq: json["seq"],
        isActive: json["isActive"],
        isAllowEdit: json["isAllowEdit"],
        rate: json["rate"],
        isDefault: json["isDefault"],
        useFormula: json["useFormula"],
        description: json["description"],
        isAllowEditQty: json["isAllowEditQty"],
        isForCheckOut: json["isForCheckOut"],
        isForDebit: json["isForDebit"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "locationID": locationId,
        "seq": seq,
        "isActive": isActive,
        "isAllowEdit": isAllowEdit,
        "rate": rate,
        "isDefault": isDefault,
        "useFormula": useFormula,
        "description": description,
        "isAllowEditQty": isAllowEditQty,
        "isForCheckOut": isForCheckOut,
        "isForDebit": isForDebit,
        "code": code,
      };
}

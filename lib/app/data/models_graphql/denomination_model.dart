// To parse this JSON data, do
//
//     final denominationModel = denominationModelFromJson(jsonString);

import 'dart:convert';

DenominationModel denominationModelFromJson(String str) => DenominationModel.fromJson(json.decode(str));

String denominationModelToJson(DenominationModel data) => json.encode(data.toJson());

class DenominationModel {
  List<TerminalDenomination> terminalDenominations;

  DenominationModel({
    required this.terminalDenominations,
  });

  factory DenominationModel.fromJson(Map<String, dynamic> json) => DenominationModel(
        terminalDenominations:
            List<TerminalDenomination>.from(json["TerminalDenominations"].map((x) => TerminalDenomination.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TerminalDenominations": List<dynamic>.from(terminalDenominations.map((x) => x.toJson())),
      };
}

class TerminalDenomination {
  int id;
  int p20;
  int p50;
  int p100;
  int p200;
  int p500;
  int p1000;
  int total;
  int terminalId;

  TerminalDenomination({
    required this.id,
    required this.p20,
    required this.p50,
    required this.p100,
    required this.p200,
    required this.p500,
    required this.p1000,
    required this.total,
    required this.terminalId,
  });

  factory TerminalDenomination.fromJson(Map<String, dynamic> json) => TerminalDenomination(
        id: json["Id"],
        p20: json["p20"],
        p50: json["p50"],
        p100: json["p100"],
        p200: json["p200"],
        p500: json["p500"],
        p1000: json["p1000"],
        total: json["total"],
        terminalId: json["TerminalId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "p20": p20,
        "p50": p50,
        "p100": p100,
        "p200": p200,
        "p500": p500,
        "p1000": p1000,
        "total": total,
        "TerminalId": terminalId,
      };
}

// To parse this JSON data, do
//
//     final cashPositionModel = cashPositionModelFromJson(jsonString);

import 'dart:convert';

CashPositionModel cashPositionModelFromJson(String str) => CashPositionModel.fromJson(json.decode(str));

String cashPositionModelToJson(CashPositionModel data) => json.encode(data.toJson());

class CashPositionModel {
  Data data;

  CashPositionModel({
    required this.data,
  });

  factory CashPositionModel.fromJson(Map<String, dynamic> json) => CashPositionModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<CashPosition> cashPositions;

  Data({
    required this.cashPositions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cashPositions: List<CashPosition>.from(json["CashPositions"].map((x) => CashPosition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CashPositions": List<dynamic>.from(cashPositions.map((x) => x.toJson())),
      };
}

class CashPosition {
  int id;
  DateTime startDate;
  DateTime endDate;
  double begBalance;
  double endBalance;
  String username;
  int cutOffId;

  CashPosition({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.begBalance,
    required this.endBalance,
    required this.username,
    required this.cutOffId,
  });

  factory CashPosition.fromJson(Map<String, dynamic> json) => CashPosition(
        id: json["Id"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        begBalance: json["begBalance"],
        endBalance: json["endBalance"],
        username: json["username"],
        cutOffId: json["CutOffId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "begBalance": begBalance,
        "endBalance": endBalance,
        "username": username,
        "CutOffId": cutOffId,
      };
}

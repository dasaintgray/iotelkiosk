// To parse this JSON data, do
//
//     final terminalDataModel = terminalDataModelFromJson(jsonString);

import 'dart:convert';

List<TerminalDataModel> terminalDataModelFromJson(String str) =>
    List<TerminalDataModel>.from(json.decode(str).map((x) => TerminalDataModel.fromJson(x)));

String terminalDataModelToJson(List<TerminalDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TerminalDataModel {
  String meta;
  String status;
  String code;
  String value;
  dynamic modifiedDate;
  int id;
  int terminalId;

  TerminalDataModel({
    required this.meta,
    required this.status,
    required this.code,
    required this.value,
    this.modifiedDate,
    required this.id,
    required this.terminalId,
  });

  factory TerminalDataModel.fromJson(Map<String, dynamic> json) => TerminalDataModel(
        meta: json["meta"],
        status: json["status"],
        code: json["code"],
        value: json["value"],
        modifiedDate: json["modifiedDate"],
        id: json["Id"],
        terminalId: json["TerminalId"],
      );

  Map<String, dynamic> toJson() => {
        "meta": meta,
        "status": status,
        "code": code,
        "value": value,
        "modifiedDate": modifiedDate,
        "Id": id,
        "TerminalId": terminalId,
      };
}

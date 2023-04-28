// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    required this.data,
  });

  final Data data;

  TransactionModel copyWith({
    required Data data,
  }) =>
      TransactionModel(
        data: data,
      );

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.conversion,
  });

  final List<Conversion> conversion;

  Data copyWith({
    required List<Conversion> conversion,
  }) =>
      Data(
        conversion: conversion,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        conversion: List<Conversion>.from(json["Conversion"].map((x) => Conversion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Conversion": List<dynamic>.from(conversion.map((x) => x.toJson())),
      };
}

class Conversion {
  Conversion({
    required this.languageId,
    required this.translationText,
    required this.description,
    required this.code,
    this.images,
    this.type,
  });

  final int languageId;
  late String translationText;
  final String description;
  final String code;
  final String? images;
  final String? type;

  Conversion copyWith({
    required int languageId,
    required String translationText,
    required String description,
    required String code,
    String? images,
    String? type,
  }) =>
      Conversion(
        languageId: languageId,
        translationText: translationText,
        description: description,
        code: code,
        images: images ?? this.images,
        type: type ?? this.type,
      );

  factory Conversion.fromJson(Map<String, dynamic> json) => Conversion(
        languageId: json["LanguageId"],
        translationText: json["translationText"],
        description: json["description"],
        code: json["code"],
        images: json["images"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "LanguageId": languageId,
        "translationText": translationText,
        "description": description,
        "code": code,
        "images": images,
        "type": type,
      };
}

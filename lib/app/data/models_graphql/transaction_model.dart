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
    required this.translations,
  });

  final List<Translation> translations;

  Data copyWith({
    required List<Translation> translations,
  }) =>
      Data(
        translations: translations,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        translations: List<Translation>.from(json["Translations"].map((x) => Translation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Translations": List<dynamic>.from(translations.map((x) => x.toJson())),
      };
}

class Translation {
  Translation({
    required this.languageId,
    required this.translationText,
    required this.description,
    required this.code,
    this.images,
    this.type,
  });

  final int languageId;
  final String translationText;
  final String description;
  final String code;
  final String? images;
  final String? type;

  Translation copyWith({
    required int languageId,
    required String translationText,
    required String description,
    required String code,
    String? images,
    String? type,
  }) =>
      Translation(
        languageId: languageId,
        translationText: translationText,
        description: description,
        code: code,
        images: images ?? this.images,
        type: type ?? this.type,
      );

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
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

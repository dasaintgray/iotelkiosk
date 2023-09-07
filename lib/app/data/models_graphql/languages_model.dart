// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'dart:convert';

LanguageModel languageModelFromJson(String str) => LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  LanguageModel({
    required this.data,
  });

  final Data data;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.languages,
  });

  final List<Language> languages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        languages: List<Language>.from(json["Languages"].map((x) => Language.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Languages": List<dynamic>.from(languages.map((x) => x.toJson())),
      };
}

class Language {
  Language({
    required this.id,
    required this.description,
    required this.code,
    required this.disclaimer,
    this.flag,
  });

  final int id;
  final String description;
  final String code;
  final String disclaimer;
  String? flag;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["Id"],
        description: json["description"],
        code: json["code"],
        disclaimer: json["disclaimer"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "description": description,
        "code": code,
        "disclaimer": disclaimer,
        "flag": flag,
      };
}

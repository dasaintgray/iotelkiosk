// To parse this JSON data, do
//
//     final translationTermsModel = translationTermsModelFromJson(jsonString);

import 'dart:convert';

TranslationTermsModel translationTermsModelFromJson(String str) => TranslationTermsModel.fromJson(json.decode(str));

String translationTermsModelToJson(TranslationTermsModel data) => json.encode(data.toJson());

class TranslationTermsModel {
  Data data;

  TranslationTermsModel({
    required this.data,
  });

  factory TranslationTermsModel.fromJson(Map<String, dynamic> json) => TranslationTermsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<TranslationTerm> translationTerms;

  Data({
    required this.translationTerms,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        translationTerms: List<TranslationTerm>.from(json["TranslationTerms"].map((x) => TranslationTerm.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TranslationTerms": List<dynamic>.from(translationTerms.map((x) => x.toJson())),
      };
}

class TranslationTerm {
  int languageId;
  String translationText;

  TranslationTerm({
    required this.languageId,
    required this.translationText,
  });

  factory TranslationTerm.fromJson(Map<String, dynamic> json) => TranslationTerm(
        languageId: json["LanguageId"],
        translationText: json["translationText"],
      );

  Map<String, dynamic> toJson() => {
        "LanguageId": languageId,
        "translationText": translationText,
      };
}

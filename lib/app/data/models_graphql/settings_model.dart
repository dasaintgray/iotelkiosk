// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromJson(jsonString);

import 'dart:convert';

SettingsModel settingsModelFromJson(String str) => SettingsModel.fromJson(json.decode(str));

String settingsModelToJson(SettingsModel data) => json.encode(data.toJson());

class SettingsModel {
  SettingsModel({
    required this.data,
  });

  Data data;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.settings,
  });

  List<Setting> settings;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        settings: List<Setting>.from(json["Settings"].map((x) => Setting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Settings": List<dynamic>.from(settings.map((x) => x.toJson())),
      };
}

class Setting {
  Setting({
    required this.code,
    required this.value,
    required this.description,
  });

  String code;
  String value;
  String description;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        code: json["code"],
        value: json["value"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "value": value,
        "description": description,
      };
}

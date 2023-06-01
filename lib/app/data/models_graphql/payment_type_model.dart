// To parse this JSON data, do
//
//     final paymentTypeModel = paymentTypeModelFromJson(jsonString);

import 'dart:convert';

PaymentTypeModel paymentTypeModelFromJson(String str) => PaymentTypeModel.fromJson(json.decode(str));

String paymentTypeModelToJson(PaymentTypeModel data) => json.encode(data.toJson());

class PaymentTypeModel {
  Data data;

  PaymentTypeModel({
    required this.data,
  });

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) => PaymentTypeModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<PaymentType> paymentTypes;

  Data({
    required this.paymentTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentTypes: List<PaymentType>.from(json["PaymentTypes"].map((x) => PaymentType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PaymentTypes": List<dynamic>.from(paymentTypes.map((x) => x.toJson())),
      };
}

class PaymentType {
  int id;
  bool isActive;
  String description;
  String code;
  bool isWithDetail;
  late String? translatedText;

  PaymentType({
    required this.id,
    required this.isActive,
    required this.description,
    required this.code,
    required this.isWithDetail,
    this.translatedText,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        id: json["Id"],
        isActive: json["isActive"],
        description: json["description"],
        code: json["code"],
        isWithDetail: json["isWithDetail"],
        translatedText: json["translatedText"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "isActive": isActive,
        "description": description,
        "code": code,
        "isWithDetail": isWithDetail,
        "translatedText": translatedText
      };
}

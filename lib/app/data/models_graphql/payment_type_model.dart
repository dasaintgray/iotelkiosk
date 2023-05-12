// To parse this JSON data, do
//
//     final paymentTypeModel = paymentTypeModelFromJson(jsonString);

import 'dart:convert';

PaymentTypeModel paymentTypeModelFromJson(String str) => PaymentTypeModel.fromJson(json.decode(str));

String paymentTypeModelToJson(PaymentTypeModel data) => json.encode(data.toJson());

class PaymentTypeModel {
  Data? data;

  PaymentTypeModel({
    this.data,
  });

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) => PaymentTypeModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  List<PaymentType>? paymentTypes;

  Data({
    this.paymentTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentTypes: json["PaymentTypes"] == null
            ? []
            : List<PaymentType>.from(json["PaymentTypes"]!.map((x) => PaymentType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PaymentTypes": paymentTypes == null ? [] : List<dynamic>.from(paymentTypes!.map((x) => x.toJson())),
      };
}

class PaymentType {
  int? id;
  bool? isActive;
  String? code;
  String? description;
  bool? isWithDetail;

  PaymentType({
    this.id,
    this.isActive,
    this.code,
    this.description,
    this.isWithDetail,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        id: json["Id"],
        isActive: json["isActive"],
        code: json["code"],
        description: json["description"],
        isWithDetail: json["isWithDetail"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "isActive": isActive,
        "code": code,
        "description": description,
        "isWithDetail": isWithDetail,
      };
}

// To parse this JSON data, do
//
//     final apiResponseModel = apiResponseModelFromJson(jsonString);

import 'dart:convert';

ApiResponseModel apiResponseModelFromJson(String str) => ApiResponseModel.fromJson(json.decode(str));

String apiResponseModelToJson(ApiResponseModel data) => json.encode(data.toJson());

class ApiResponseModel {
  String message;
  int statuscode;

  ApiResponseModel({
    required this.message,
    required this.statuscode,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) => ApiResponseModel(
        message: json["message"],
        statuscode: json["statuscode"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "statuscode": statuscode,
      };
}

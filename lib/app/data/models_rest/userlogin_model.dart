// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) => UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
  String accessToken;
  int expiresIn;
  int creationTime;
  int expirationTime;

  UserLoginModel({
    required this.accessToken,
    required this.expiresIn,
    required this.creationTime,
    required this.expirationTime,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        creationTime: json["creation_time"],
        expirationTime: json["expiration_Time"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_in": expiresIn,
        "creation_time": creationTime,
        "expiration_Time": expirationTime,
      };
}

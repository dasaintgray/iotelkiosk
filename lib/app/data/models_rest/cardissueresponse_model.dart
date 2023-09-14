// To parse this JSON data, do
//
//     final cardIssueResponseModel = cardIssueResponseModelFromJson(jsonString);

import 'dart:convert';

CardIssueResponseModel cardIssueResponseModelFromJson(String str) => CardIssueResponseModel.fromJson(json.decode(str));

String cardIssueResponseModelToJson(CardIssueResponseModel data) => json.encode(data.toJson());

class CardIssueResponseModel {
  List<Datum> data;
  String message;
  int statuscode;

  CardIssueResponseModel({
    required this.data,
    required this.message,
    required this.statuscode,
  });

  factory CardIssueResponseModel.fromJson(Map<String, dynamic> json) => CardIssueResponseModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
        statuscode: json["statuscode"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "statuscode": statuscode,
      };
}

class Datum {
  String id;
  String cardNumber;
  String roomStatus;
  String roomNumber;
  String cardType;
  String checkinDate;
  String checkoutDate;
  String liftReaderOption;
  String commonDoorOption;
  String guestName;

  Datum({
    required this.id,
    required this.cardNumber,
    required this.roomStatus,
    required this.roomNumber,
    required this.cardType,
    required this.checkinDate,
    required this.checkoutDate,
    required this.liftReaderOption,
    required this.commonDoorOption,
    required this.guestName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["Id"],
        cardNumber: json["CardNumber"],
        roomStatus: json["RoomStatus"],
        roomNumber: json["RoomNumber"],
        cardType: json["CardType"],
        checkinDate: json["CheckinDate"],
        checkoutDate: json["CheckoutDate"],
        liftReaderOption: json["LiftReaderOption"],
        commonDoorOption: json["CommonDoorOption"],
        guestName: json["GuestName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "CardNumber": cardNumber,
        "RoomStatus": roomStatus,
        "RoomNumber": roomNumber,
        "CardType": cardType,
        "CheckinDate": checkinDate,
        "CheckoutDate": checkoutDate,
        "LiftReaderOption": liftReaderOption,
        "CommonDoorOption": commonDoorOption,
        "GuestName": guestName,
      };
}

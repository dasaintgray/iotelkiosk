// To parse this JSON data, do
//
//     final cardResponseModel = cardResponseModelFromJson(jsonString);

import 'dart:convert';

CardResponseModel cardResponseModelFromJson(String str) => CardResponseModel.fromJson(json.decode(str));

String cardResponseModelToJson(CardResponseModel data) => json.encode(data.toJson());

class CardResponseModel {
  List<Message> message;
  int statuscode;

  CardResponseModel({
    required this.message,
    required this.statuscode,
  });

  factory CardResponseModel.fromJson(Map<String, dynamic> json) => CardResponseModel(
        message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
        statuscode: json["statuscode"],
      );

  Map<String, dynamic> toJson() => {
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
        "statuscode": statuscode,
      };
}

class Message {
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

  Message({
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

  factory Message.fromJson(Map<String, dynamic> json) => Message(
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

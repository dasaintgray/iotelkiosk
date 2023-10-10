// To parse this JSON data, do
//
//     final bookingInfoModel = bookingInfoModelFromJson(jsonString);

import 'dart:convert';

BookingInfoModel bookingInfoModelFromJson(String str) => BookingInfoModel.fromJson(json.decode(str));

String bookingInfoModelToJson(BookingInfoModel data) => json.encode(data.toJson());

class BookingInfoModel {
  Data data;

  BookingInfoModel({
    required this.data,
  });

  factory BookingInfoModel.fromJson(Map<String, dynamic> json) => BookingInfoModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<ViewBooking> viewBookings;

  Data({
    required this.viewBookings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        viewBookings: List<ViewBooking>.from(json["ViewBookings"].map((x) => ViewBooking.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ViewBookings": List<dynamic>.from(viewBookings.map((x) => x.toJson())),
      };
}

class ViewBooking {
  int id;
  bool isWithBreakfast;
  bool isDoNotDesturb;
  dynamic wakeUpTime;
  bool isActive;
  String docNo;
  String room;
  DateTime startDate;
  DateTime endDate;
  String roomType;
  int bookingStatusId;
  String bookingStatus;
  double roomRate;
  String agentDocNo;
  int contactId;
  String contact;
  int agentId;
  String description;
  String accommodationType;
  int bed;

  ViewBooking({
    required this.id,
    required this.isWithBreakfast,
    required this.isDoNotDesturb,
    required this.wakeUpTime,
    required this.isActive,
    required this.docNo,
    required this.room,
    required this.startDate,
    required this.endDate,
    required this.roomType,
    required this.bookingStatusId,
    required this.bookingStatus,
    required this.roomRate,
    required this.agentDocNo,
    required this.contactId,
    required this.contact,
    required this.agentId,
    required this.description,
    required this.accommodationType,
    required this.bed,
  });

  factory ViewBooking.fromJson(Map<String, dynamic> json) => ViewBooking(
        id: json["Id"],
        isWithBreakfast: json["isWithBreakfast"],
        isDoNotDesturb: json["isDoNotDesturb"],
        wakeUpTime: json["wakeUpTime"],
        isActive: json["isActive"],
        docNo: json["docNo"],
        room: json["room"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        roomType: json["RoomType"],
        bookingStatusId: json["BookingStatusId"],
        bookingStatus: json["BookingStatus"],
        roomRate: json["roomRate"],
        agentDocNo: json["AgentDocNo"],
        contactId: json["ContactId"],
        contact: json["Contact"],
        agentId: json["AgentId"],
        description: json["description"],
        accommodationType: json["AccommodationType"],
        bed: json["bed"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "isWithBreakfast": isWithBreakfast,
        "isDoNotDesturb": isDoNotDesturb,
        "wakeUpTime": wakeUpTime,
        "isActive": isActive,
        "docNo": docNo,
        "room": room,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "RoomType": roomType,
        "BookingStatusId": bookingStatusId,
        "BookingStatus": bookingStatus,
        "roomRate": roomRate,
        "AgentDocNo": agentDocNo,
        "ContactId": contactId,
        "Contact": contact,
        "AgentId": agentId,
        "description": description,
        "AccommodationType": accommodationType,
        "bed": bed,
      };
}

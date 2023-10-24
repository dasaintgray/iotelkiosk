// To parse this JSON data, do
//
//     final paymentsModel = paymentsModelFromJson(jsonString);

import 'dart:convert';

PaymentsModel paymentsModelFromJson(String str) => PaymentsModel.fromJson(json.decode(str));

String paymentsModelToJson(PaymentsModel data) => json.encode(data.toJson());

class PaymentsModel {
  Data data;

  PaymentsModel({
    required this.data,
  });

  factory PaymentsModel.fromJson(Map<String, dynamic> json) => PaymentsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  List<Payment> payments;

  Data({
    required this.payments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        payments: List<Payment>.from(json["Payments"].map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Payments": List<dynamic>.from(payments.map((x) => x.toJson())),
      };
}

class Payment {
  int id;
  String? invoiceNo;
  String bookingNo;
  DateTime tranDate;
  int totalQuantity;
  double totalAmount;
  int discount;
  double discountAmount;
  int vat;
  double vatAmount;
  DateTime dueDate;
  double totalPaid;
  double balance;
  int cashPositionId;
  int chargeId;
  int cutOffId;

  Payment({
    required this.id,
    this.invoiceNo,
    required this.bookingNo,
    required this.tranDate,
    required this.totalQuantity,
    required this.totalAmount,
    required this.discount,
    required this.discountAmount,
    required this.vat,
    required this.vatAmount,
    required this.dueDate,
    required this.totalPaid,
    required this.balance,
    required this.cashPositionId,
    required this.chargeId,
    required this.cutOffId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["Id"],
        invoiceNo: json["invoiceNo"],
        bookingNo: json["bookingNo"],
        tranDate: DateTime.parse(json["tranDate"]),
        totalQuantity: json["totalQuantity"],
        totalAmount: json["totalAmount"],
        discount: json["discount"],
        discountAmount: json["discountAmount"],
        vat: json["vat"],
        vatAmount: json["vatAmount"],
        dueDate: DateTime.parse(json["dueDate"]),
        totalPaid: json["totalPaid"],
        balance: json["balance"],
        cashPositionId: json["cashPositionID"],
        chargeId: json["chargeID"],
        cutOffId: json["CutOffId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "invoiceNo": invoiceNo,
        "bookingNo": bookingNo,
        "tranDate": tranDate.toIso8601String(),
        "totalQuantity": totalQuantity,
        "totalAmount": totalAmount,
        "discount": discount,
        "discountAmount": discountAmount,
        "vat": vat,
        "vatAmount": vatAmount,
        "dueDate": dueDate.toIso8601String(),
        "totalPaid": totalPaid,
        "balance": balance,
        "cashPositionID": cashPositionId,
        "chargeID": chargeId,
        "CutOffId": cutOffId,
      };
}

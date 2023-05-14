// To parse this JSON data, do
//
//     final seriesDetailsModel = seriesDetailsModelFromJson(jsonString);

import 'dart:convert';

SeriesDetailsModel seriesDetailsModelFromJson(String str) => SeriesDetailsModel.fromJson(json.decode(str));

String seriesDetailsModelToJson(SeriesDetailsModel data) => json.encode(data.toJson());

class SeriesDetailsModel {
  SeriesDetailsModel({
    required this.data,
  });

  Data data;

  factory SeriesDetailsModel.fromJson(Map<String, dynamic> json) => SeriesDetailsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.seriesDetails,
  });

  List<SeriesDetail> seriesDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        seriesDetails: List<SeriesDetail>.from(json["SeriesDetails"].map((x) => SeriesDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "SeriesDetails": List<dynamic>.from(seriesDetails.map((x) => x.toJson())),
      };
}

class SeriesDetail {
  SeriesDetail({
    required this.id,
    required this.seriesId,
    required this.docNo,
    required this.description,
    required this.locationId,
    required this.moduleId,
    required this.isActive,
    required this.tranDate,
  });

  int id;
  int seriesId;
  String docNo;
  String description;
  int locationId;
  int moduleId;
  bool isActive;
  DateTime tranDate;

  factory SeriesDetail.fromJson(Map<String, dynamic> json) => SeriesDetail(
        id: json["Id"],
        seriesId: json["SeriesId"],
        docNo: json["docNo"],
        description: json["description"],
        locationId: json["LocationId"],
        moduleId: json["ModuleId"],
        isActive: json["isActive"],
        tranDate: DateTime.parse(json["tranDate"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "SeriesId": seriesId,
        "docNo": docNo,
        "description": description,
        "LocationId": locationId,
        "ModuleId": moduleId,
        "isActive": isActive,
        "tranDate": tranDate.toIso8601String(),
      };
}

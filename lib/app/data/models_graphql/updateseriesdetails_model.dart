// To parse this JSON data, do
//
//     final updateSeriesDetailsModel = updateSeriesDetailsModelFromJson(jsonString);

import 'dart:convert';

UpdateSeriesDetailsModel updateSeriesDetailsModelFromJson(String str) =>
    UpdateSeriesDetailsModel.fromJson(json.decode(str));

String updateSeriesDetailsModelToJson(UpdateSeriesDetailsModel data) => json.encode(data.toJson());

class UpdateSeriesDetailsModel {
  UpdateSeriesDetailsModel({
    required this.data,
  });

  Data data;

  factory UpdateSeriesDetailsModel.fromJson(Map<String, dynamic> json) => UpdateSeriesDetailsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.updateSeriesDetails,
  });

  UpdateSeriesDetails updateSeriesDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        updateSeriesDetails: UpdateSeriesDetails.fromJson(json["update_SeriesDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "update_SeriesDetails": updateSeriesDetails.toJson(),
      };
}

class UpdateSeriesDetails {
  UpdateSeriesDetails({
    required this.returning,
    required this.affectedRows,
  });

  List<Returning> returning;
  int affectedRows;

  factory UpdateSeriesDetails.fromJson(Map<String, dynamic> json) => UpdateSeriesDetails(
        returning: List<Returning>.from(json["returning"].map((x) => Returning.fromJson(x))),
        affectedRows: json["affected_rows"],
      );

  Map<String, dynamic> toJson() => {
        "returning": List<dynamic>.from(returning.map((x) => x.toJson())),
        "affected_rows": affectedRows,
      };
}

class Returning {
  Returning({
    required this.id,
    required this.docNo,
    required this.isActive,
    required this.modifiedBy,
    required this.locationId,
    required this.moduleId,
    required this.seriesId,
  });

  int id;
  String docNo;
  bool isActive;
  String modifiedBy;
  int locationId;
  int moduleId;
  int seriesId;

  factory Returning.fromJson(Map<String, dynamic> json) => Returning(
        id: json["Id"],
        docNo: json["docNo"],
        isActive: json["isActive"],
        modifiedBy: json["modifiedBy"],
        locationId: json["LocationId"],
        moduleId: json["ModuleId"],
        seriesId: json["SeriesId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "docNo": docNo,
        "isActive": isActive,
        "modifiedBy": modifiedBy,
        "LocationId": locationId,
        "ModuleId": moduleId,
        "SeriesId": seriesId,
      };
}

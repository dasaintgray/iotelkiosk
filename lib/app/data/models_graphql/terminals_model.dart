// To parse this JSON data, do
//
//     final terminalsModel = terminalsModelFromJson(jsonString);

import 'dart:convert';

TerminalsModel terminalsModelFromJson(String str) => TerminalsModel.fromJson(json.decode(str));

String terminalsModelToJson(TerminalsModel data) => json.encode(data.toJson());

class TerminalsModel {
    Data data;

    TerminalsModel({
        required this.data,
    });

    factory TerminalsModel.fromJson(Map<String, dynamic> json) => TerminalsModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    List<Terminal> terminals;

    Data({
        required this.terminals,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        terminals: List<Terminal>.from(json["Terminals"].map((x) => Terminal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Terminals": List<dynamic>.from(terminals.map((x) => x.toJson())),
    };
}

class Terminal {
    int id;
    String description;
    String code;
    bool isActive;
    dynamic macAddress;
    dynamic ipAddress;

    Terminal({
        required this.id,
        required this.description,
        required this.code,
        required this.isActive,
        this.macAddress,
        this.ipAddress,
    });

    factory Terminal.fromJson(Map<String, dynamic> json) => Terminal(
        id: json["Id"],
        description: json["description"],
        code: json["code"],
        isActive: json["isActive"],
        macAddress: json["macAddress"],
        ipAddress: json["ipAddress"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "description": description,
        "code": code,
        "isActive": isActive,
        "macAddress": macAddress,
        "ipAddress": ipAddress,
    };
}

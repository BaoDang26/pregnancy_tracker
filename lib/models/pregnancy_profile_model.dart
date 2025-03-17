// To parse this JSON data, do
//
//     final pregnancyProfileModel = pregnancyProfileModelFromJson(jsonString);

import 'dart:convert';

List<PregnancyProfileModel> pregnancyProfileModelFromJson(String str) =>
    List<PregnancyProfileModel>.from(
        json.decode(str).map((x) => PregnancyProfileModel.fromJson(x)));

String pregnancyProfileModelToJson(List<PregnancyProfileModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PregnancyProfileModel {
  int? id;
  String? nickName;
  DateTime? dueDate;
  // DateTime? conceptionDate;
  DateTime? lastPeriodDate;
  int? pregnancyWeek;
  String? notes;
  String? status;
  DateTime? createdDate;

  PregnancyProfileModel({
    this.id,
    this.nickName,
    this.dueDate,
    // this.conceptionDate,
    this.lastPeriodDate,
    this.pregnancyWeek,
    this.notes,
    this.createdDate,
    this.status,
  });

  factory PregnancyProfileModel.fromJson(Map<String, dynamic> json) =>
      PregnancyProfileModel(
        id: json["id"],
        nickName: json["nickName"] ?? '',
        dueDate:
            json["dueDate"] != null ? DateTime.parse(json["dueDate"]) : null,
        // conceptionDate: json["conceptionDate"] != null
        //     ? DateTime.parse(json["conceptionDate"])
        //     : null,
        lastPeriodDate: json["lastPeriodDate"] != null
            ? DateTime.parse(json["lastPeriodDate"])
            : null,
        pregnancyWeek: json["pregnancyWeek"] ?? 0,
        notes: json["notes"] ?? '',
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : null,
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickName": nickName,
        "dueDate":
            "${dueDate?.year.toString().padLeft(4, '0')}-${dueDate?.month.toString().padLeft(2, '0')}-${dueDate?.day.toString().padLeft(2, '0')}",
        // "conceptionDate":
        //     "${conceptionDate?.year.toString().padLeft(4, '0')}-${conceptionDate?.month.toString().padLeft(2, '0')}-${conceptionDate?.day.toString().padLeft(2, '0')}",
        "lastPeriodDate":
            "${lastPeriodDate?.year.toString().padLeft(4, '0')}-${lastPeriodDate?.month.toString().padLeft(2, '0')}-${lastPeriodDate?.day.toString().padLeft(2, '0')}",
        "pregnancyWeek": pregnancyWeek,
        "notes": notes,
        "createdDate": createdDate?.toIso8601String(),
        "status": status,
      };

  Map<String, dynamic> toCreateJson() => {
        "nickName": nickName,
        "dueDate":
            "${dueDate?.year.toString().padLeft(4, '0')}-${dueDate?.month.toString().padLeft(2, '0')}-${dueDate?.day.toString().padLeft(2, '0')}",
        "lastPeriodDate":
            "${lastPeriodDate?.year.toString().padLeft(4, '0')}-${lastPeriodDate?.month.toString().padLeft(2, '0')}-${lastPeriodDate?.day.toString().padLeft(2, '0')}",
        "notes": notes,
      };

  Map<String, dynamic> toUpdateJson() => {
        "id": id,
        "nickName": nickName,
        "notes": notes,
      };
}

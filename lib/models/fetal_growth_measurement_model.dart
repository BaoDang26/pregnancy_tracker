// To parse this JSON data, do
//
//     final fetalGrowthMeasurementModel = fetalGrowthMeasurementModelFromJson(jsonString);

import 'dart:convert';

List<FetalGrowthMeasurementModel> fetalGrowthMeasurementModelFromJson(
        String str) =>
    List<FetalGrowthMeasurementModel>.from(
        json.decode(str).map((x) => FetalGrowthMeasurementModel.fromJson(x)));

String fetalGrowthMeasurementModelToJson(
        List<FetalGrowthMeasurementModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetalGrowthMeasurementModel {
  int? id;
  int? weekNumber;
  DateTime? measurementDate;
  double? weight;
  double? height;
  double? headCircumference;
  double? bellyCircumference;
  double? heartRate;
  int? movementCount;
  String? notes;
  int? pregnancyProfileId;
  DateTime? createdDate;

  FetalGrowthMeasurementModel({
    this.id,
    this.weekNumber,
    this.measurementDate,
    this.weight,
    this.height,
    this.headCircumference,
    this.bellyCircumference,
    this.heartRate,
    this.movementCount,
    this.notes,
    this.createdDate,
    this.pregnancyProfileId,
  });

  factory FetalGrowthMeasurementModel.fromJson(Map<String, dynamic> json) =>
      FetalGrowthMeasurementModel(
        id: json["id"],
        weekNumber: json["weekNumber"],
        measurementDate: DateTime.parse(json["measurementDate"]),
        weight: json["weight"],
        height: json["height"],
        headCircumference: json["headCircumference"],
        bellyCircumference: json["bellyCircumference"],
        heartRate: json["heartRate"],
        movementCount: json["movementCount"],
        notes: json["notes"],
        createdDate: DateTime.parse(json["createdDate"]),
        pregnancyProfileId: json["pregnancyProfileId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weekNumber": weekNumber,
        "measurementDate":
            "${measurementDate?.year.toString().padLeft(4, '0')}-${measurementDate?.month.toString().padLeft(2, '0')}-${measurementDate?.day.toString().padLeft(2, '0')}",
        "weight": weight,
        "height": height,
        "headCircumference": headCircumference,
        "bellyCircumference": bellyCircumference,
        "heartRate": heartRate,
        "movementCount": movementCount,
        "notes": notes,
        "createdDate": createdDate?.toIso8601String(),
        "pregnancyProfileId": pregnancyProfileId,
      };
}

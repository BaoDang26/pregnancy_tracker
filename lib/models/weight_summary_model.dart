// To parse this JSON data, do
//
//     final weightSummaryModel = weightSummaryModelFromJson(jsonString);

import 'dart:convert';

List<WeightSummaryModel> weightSummaryModelFromJson(String str) =>
    List<WeightSummaryModel>.from(
        json.decode(str).map((x) => WeightSummaryModel.fromJson(x)));

String weightSummaryModelToJson(List<WeightSummaryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeightSummaryModel {
  int? id;
  int? weekNumber;
  DateTime? measurementDate;
  int? weight;
  int? pregnancyProfileId;

  WeightSummaryModel({
    this.id,
    this.weekNumber,
    this.measurementDate,
    this.weight,
    this.pregnancyProfileId,
  });

  factory WeightSummaryModel.fromJson(Map<String, dynamic> json) =>
      WeightSummaryModel(
        id: json["id"],
        weekNumber: json["weekNumber"],
        measurementDate: DateTime.parse(json["measurementDate"]),
        weight: json["weight"],
        pregnancyProfileId: json["pregnancyProfileId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weekNumber": weekNumber,
        "measurementDate":
            "${measurementDate?.year.toString().padLeft(4, '0')}-${measurementDate?.month.toString().padLeft(2, '0')}-${measurementDate?.day.toString().padLeft(2, '0')}",
        "weight": weight,
        "pregnancyProfileId": pregnancyProfileId,
      };
}

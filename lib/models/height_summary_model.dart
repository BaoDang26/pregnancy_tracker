// To parse this JSON data, do
//
//     final heightSummaryModel = heightSummaryModelFromJson(jsonString);

import 'dart:convert';

List<HeightSummaryModel> heightSummaryModelFromJson(String str) =>
    List<HeightSummaryModel>.from(
        json.decode(str).map((x) => HeightSummaryModel.fromJson(x)));

String heightSummaryModelToJson(List<HeightSummaryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HeightSummaryModel {
  int? id;
  int? weekNumber;
  DateTime? measurementDate;
  double? height;
  int? pregnancyProfileId;

  HeightSummaryModel({
    this.id,
    this.weekNumber,
    this.measurementDate,
    this.height,
    this.pregnancyProfileId,
  });

  factory HeightSummaryModel.fromJson(Map<String, dynamic> json) =>
      HeightSummaryModel(
        id: json["id"],
        weekNumber: json["weekNumber"],
        measurementDate: DateTime.parse(json["measurementDate"]),
        height: json["height"],
        pregnancyProfileId: json["pregnancyProfileId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weekNumber": weekNumber,
        "measurementDate":
            "${measurementDate?.year.toString().padLeft(4, '0')}-${measurementDate?.month.toString().padLeft(2, '0')}-${measurementDate?.day.toString().padLeft(2, '0')}",
        "height": height,
        "pregnancyProfileId": pregnancyProfileId,
      };
}

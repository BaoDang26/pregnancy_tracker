// To parse this JSON data, do
//
//     final scheduleModel = scheduleModelFromJson(jsonString);

import 'dart:convert';

List<ScheduleModel> scheduleModelFromJson(String str) =>
    List<ScheduleModel>.from(
        json.decode(str).map((x) => ScheduleModel.fromJson(x)));

String scheduleModelToJson(List<ScheduleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScheduleModel {
  int? id;
  String? title;
  String? description;
  DateTime? eventDate;
  String? status;
  bool? isCompleted;
  DateTime? createdDate;
  UserModel? user;
  PregnancyProfile? pregnancyProfile;
  int? pregnancyProfileId;

  ScheduleModel({
    this.id,
    this.title,
    this.description,
    this.eventDate,
    this.status,
    this.isCompleted,
    this.createdDate,
    this.user,
    this.pregnancyProfile,
    this.pregnancyProfileId,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        eventDate: DateTime.parse(json["eventDate"]),
        status: json["status"],
        isCompleted: json["isCompleted"],
        createdDate: DateTime.parse(json["createdDate"]),
        user: UserModel.fromJson(json["user"]),
        pregnancyProfile: PregnancyProfile.fromJson(json["pregnancyProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "eventDate":
            "${eventDate?.year.toString().padLeft(4, '0')}-${eventDate?.month.toString().padLeft(2, '0')}-${eventDate?.day.toString().padLeft(2, '0')}",
        "status": status,
        "isCompleted": isCompleted,
        "createdDate":
            "${createdDate?.year.toString().padLeft(4, '0')}-${createdDate?.month.toString().padLeft(2, '0')}-${createdDate?.day.toString().padLeft(2, '0')}",
        "user": user?.toJson(),
        "pregnancyProfile": pregnancyProfile?.toJson(),
      };

  Map<String, dynamic> toCreateJson() => {
        "title": title,
        "description": description,
        "eventDate":
            "${eventDate?.year.toString().padLeft(4, '0')}-${eventDate?.month.toString().padLeft(2, '0')}-${eventDate?.day.toString().padLeft(2, '0')}",
        "pregnancyProfileId": pregnancyProfileId,
      };

  Map<String, dynamic> toUpdateJson() => {
        "title": title,
        "description": description,
        "eventDate":
            "${eventDate?.year.toString().padLeft(4, '0')}-${eventDate?.month.toString().padLeft(2, '0')}-${eventDate?.day.toString().padLeft(2, '0')}",
        "pregnancyProfileId": pregnancyProfileId,
      };
}

class PregnancyProfile {
  int? id;

  PregnancyProfile({
    this.id,
  });

  factory PregnancyProfile.fromJson(Map<String, dynamic> json) =>
      PregnancyProfile(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class UserModel {
  int? id;

  UserModel({
    this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

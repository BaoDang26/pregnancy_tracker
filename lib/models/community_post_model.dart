// To parse this JSON data, do
//
//     final communityPostModel = communityPostModelFromJson(jsonString);

import 'dart:convert';

import 'package:pregnancy_tracker/models/comment_model.dart';

List<CommunityPostModel> communityPostModelFromJson(String str) =>
    List<CommunityPostModel>.from(
        json.decode(str).map((x) => CommunityPostModel.fromJson(x)));

String communityPostModelToJson(List<CommunityPostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommunityPostModel {
  int? id;
  int? userId;
  String? title;
  String? content;
  int? commentCount;
  String? attachmentUrl;
  String? status;
  DateTime? createdDate;
  List<CommentModel>? comments;

  CommunityPostModel({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.commentCount,
    this.attachmentUrl,
    this.status,
    this.createdDate,
    this.comments,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) =>
      CommunityPostModel(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        content: json["content"],
        commentCount: json["commentCount"],
        attachmentUrl: json["attachmentUrl"],
        status: json["status"],
        createdDate: DateTime.parse(json["createdDate"]),
        comments: List<CommentModel>.from(
            json["comments"].map((x) => CommentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "content": content,
        "commentCount": commentCount,
        "attachmentUrl": attachmentUrl,
        "status": status,
        "createdDate": createdDate?.toIso8601String(),
        "comments": List<dynamic>.from(comments?.map((x) => x.toJson()) ?? []),
      };

  Map<String, dynamic> toCreateJson() => {
        "userId": userId,
        "title": title,
        "content": content,
        "attachmentUrl": attachmentUrl,
      };

  Map<String, dynamic> toUpdateJson() => {
        "userId": userId,
        "title": title,
        "content": content,
        "attachmentUrl": attachmentUrl,
      };
}

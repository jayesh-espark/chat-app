// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<ReelsModel> welcomeFromJson(String str) =>
    List<ReelsModel>.from(json.decode(str).map((x) => ReelsModel.fromJson(x)));

String welcomeToJson(List<ReelsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReelsModel {
  String? userName;
  String? caption;
  String? videoUrl;
  int? likes;
  int? comments;

  ReelsModel({
    this.userName,
    this.caption,
    this.videoUrl,
    this.likes,
    this.comments,
  });

  factory ReelsModel.fromJson(Map<String, dynamic> json) => ReelsModel(
    userName: json["userName"],
    caption: json["caption"],
    videoUrl: json["videoUrl"],
    likes: json["likes"],
    comments: json["comments"],
  );

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "caption": caption,
    "videoUrl": videoUrl,
    "likes": likes,
    "comments": comments,
  };
}

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'addBlogModel.g.dart';

@JsonSerializable()
class AddBlogModel{
  String title;
  String body;
  int    likes;
  int    comments;
  int    shares;
  String coverImage;
  @JsonKey(name: "_id")
  String id;
  String username;
  AddBlogModel({
    this.title,
    this.body,
    this.likes,
    this.comments,
    this.shares,
    this.coverImage,
    this.username,
    this.id
  });
  factory AddBlogModel.fromJson(Map<String,dynamic>json)=> _$AddBlogModelFromJson(json);
  Map<String,dynamic> toJson()=>_$AddBlogModelToJson(this);
}
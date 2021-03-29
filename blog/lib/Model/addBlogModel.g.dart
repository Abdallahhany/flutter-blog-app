// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addBlogModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddBlogModel _$AddBlogModelFromJson(Map<String, dynamic> json) {
  return AddBlogModel(
    title: json['title'] as String,
    body: json['body'] as String,
    likes: json['likes'] as int,
    comments: json['comments'] as int,
    shares: json['shares'] as int,
    coverImage: json['coverImage'] as String,
    username: json['username'] as String,
    id: json['_id'] as String,
  );
}

Map<String, dynamic> _$AddBlogModelToJson(AddBlogModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'likes': instance.likes,
      'comments': instance.comments,
      'shares': instance.shares,
      'coverImage': instance.coverImage,
      '_id': instance.id,
      'username': instance.username,
    };

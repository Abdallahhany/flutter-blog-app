import 'package:json_annotation/json_annotation.dart';

part 'ProfileModel.g.dart';

@JsonSerializable()
class ProfileModel{
  String name;
  String username;
  String profession;
  String DOB;
  //String titleLine;
  String about;
  ProfileModel({
    this.name,
    this.username,
    this.profession,
    this.DOB,
    //this.titleLine,
    this.about
});
  factory ProfileModel.fromJson(Map<String,dynamic>json)=> _$ProfileModelFromJson(json);
  Map<String,dynamic> toJson()=>_$ProfileModelToJson(this);
}
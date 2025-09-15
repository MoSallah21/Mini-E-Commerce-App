import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  UserModel({
    super.uId,
    required super.email,
    super.username,
    super.fullName,
    super.phone,
    super.city,
    super.birthday,
    super.imgUrl,
    this.img,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? img;
  @JsonKey(includeFromJson: true, includeToJson: false)
   String? uId;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

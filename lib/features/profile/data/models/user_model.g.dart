// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uId: json['uId'] as String?,
  email: json['email'] as String,
  username: json['username'] as String?,
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
  city: json['city'] as String?,
  birthday: json['birthday'] as String?,
  imgUrl: json['imgUrl'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'email': instance.email,
  'username': instance.username,
  'fullName': instance.fullName,
  'imgUrl': instance.imgUrl,
  'city': instance.city,
  'phone': instance.phone,
  'birthday': instance.birthday,
};

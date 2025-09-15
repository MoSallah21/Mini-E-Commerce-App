import 'dart:io';

class UserEntity{
  final String? uId;
  final String email;
  final String? username;
  final String? fullName;
  final String? imgUrl;
  final String? city;
  final String? phone;
  final String? birthday;
  final File? img;

  UserEntity({this.uId,required this.email,this.city,this.phone,this.birthday, this.username,this.fullName,
      this.imgUrl, this.img});

}
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_user_entity.dart';
part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel extends AuthUserEntity {
  AuthUserModel({
    super.uId,
    required super.email,
     super.password,
    super.username,
  });


  @override
  @JsonKey(includeFromJson: false, includeToJson: true)
  String? get password => super.password;

  @override
  @JsonKey(includeFromJson: true, includeToJson: false)
  String? get uId => super.uId;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);
}

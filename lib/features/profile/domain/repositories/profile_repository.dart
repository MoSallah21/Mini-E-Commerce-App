import 'dart:io';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// ===========================================
/// Abstract repository for Profile features
/// ===========================================
abstract class ProfileRepository {
  /// Update an existing user profile
  Future<Result<UserEntity>> updateProfile({
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? city,
    File? image,
    String? imgUrl,
  });

  /// Fetch the current user profile
  Future<Result<UserEntity>> getProfile();

  /// Add a new user profile
  Future<Result<UserEntity>> addProfile({
    required String fullName,
    required String phone,
    required String city,
    File? image,
    String? imgUrl,
  });
}

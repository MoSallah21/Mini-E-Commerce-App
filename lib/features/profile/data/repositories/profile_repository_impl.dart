import 'dart:io';

import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/core/utils/result.dart';
import 'package:ecommerce/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:ecommerce/features/profile/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';

/// ===========================================
/// Implementation of ProfileRepository
/// ===========================================
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final AuthLocalDatasource _authLocalDatasource;
  final ProfileLocalDatasource _localDatasource;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDatasource localDatasource,
    required AuthLocalDatasource authLocalDatasource,
  })  : _remoteDataSource = remoteDataSource,
        _localDatasource = localDatasource,
        _authLocalDatasource = authLocalDatasource;

  /// Update existing profile
  @override
  Future<Result<UserEntity>> updateProfile({
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? city,
    File? image,
    String? imgUrl,
  }) async {
    try {
      // Get current user UID from auth token
      final String uId = await _authLocalDatasource.getAuthToken();

      // Call remote datasource to update profile
      final result = await _remoteDataSource.updateProfile(
        uId,
        username: username,
        fullName: fullName,
        phone: phone,
        city: city,
        image: image,
        imgUrl: imgUrl,
      );

      // Cache updated user locally if successful
      return result.when(
        success: (userModel) {
          _localDatasource.cacheUser(userModel);
          return Result.success(_mapToEntity(userModel));
        },
        failure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  /// Add a new profile
  @override
  Future<Result<UserEntity>> addProfile({
    required String fullName,
    required String phone,
    required String city,
    File? image,
    String? imgUrl,
  }) async {
    try {
      final String uId = await _authLocalDatasource.getAuthToken();

      final result = await _remoteDataSource.addProfile(
        uId,
        fullName: fullName,
        phone: phone,
        city: city,
        image: image,
        imgUrl: imgUrl,
      );

      return result.when(
        success: (userModel) {
          _localDatasource.cacheUser(userModel);
          return Result.success(_mapToEntity(userModel));
        },
        failure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  /// Fetch user profile
  @override
  Future<Result<UserEntity>> getProfile() async {
    try {
      final String uId = await _authLocalDatasource.getAuthToken();
      final result = await _remoteDataSource.getProfile(uId);

      return result.when(
        success: (userModel) {
          _localDatasource.cacheUser(userModel);
          return Result.success(_mapToEntity(userModel));
        },
        failure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  /// Map UserModel to UserEntity
  UserEntity _mapToEntity(UserModel model) {
    return UserEntity(
      uId: model.uId,
      username: model.username,
      fullName: model.fullName,
      email: model.email,
      phone: model.phone,
      city: model.city,
      birthday: model.birthday,
      imgUrl: model.imgUrl,
    );
  }
}

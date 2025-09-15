// ============================================
// Auth Repository Implementation
// ============================================

import 'package:ecommerce/core/cache/cache_helper.dart';
import 'package:ecommerce/features/auth/data/models/auth_user_model.dart';
import 'package:ecommerce/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce/core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

// ==========================
// AuthRepositoryImpl
// ==========================
// Implements AuthRepository interface.
// Handles login, registration, Google sign-in, and sign-out
// using both remote (Firebase) and local (secure storage) data sources.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDatasource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDatasource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  // ==========================
  // Login with email and password
  // ==========================
  @override
  Future<Result<AuthUserEntity>> login(String email, String password) async {
    try {
      final result = await _remoteDataSource.login(email, password);

      return result.when(
        success: (userModel) async {
          final entity = _mapToEntity(userModel);
          _localDataSource.cacheAuthSession(entity.uId!); // Cache session locally
          return Result.success(entity);
        },
        failure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ==========================
  // Register a new user
  // ==========================
  @override
  Future<Result<AuthUserEntity>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.register(
        email,
        username,
        password,
      );

      return result.when(
        success: (userModel) async {
          final entity = _mapToEntity(userModel);
          _localDataSource.cacheAuthSession(entity.uId!); // Cache session locally
          return Result.success(entity);
        },
        failure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ==========================
  // Sign in using Google account
  // ==========================
  @override
  Future<Result<AuthUserEntity>> signInWithGoogle() async {
    try {
      final result = await _remoteDataSource.signInWithGoogle();

      return result.when(
        success: (userModel) async {
          final entity = _mapToEntity(userModel);
          _localDataSource.cacheAuthSession(entity.uId!); // Cache session locally
          return Result.success(entity);
        },
        failure: (error) => Result.failure(error),
      );
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ==========================
  // Sign out user
  // ==========================
  @override
  Future<Result<bool>> signOut() async {
    try {
      _localDataSource.clearAuthSession(); // Clear local session
      CacheHelper.removeData(key: 'fcm_token'); // Remove cached FCM token
      CacheHelper.removeData(key: 'CACHED_USER_DATA'); // Remove cached user data
      return Result.success(true);
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ==========================
  // Convert AuthUserModel to AuthUserEntity
  // ==========================
  AuthUserEntity _mapToEntity(AuthUserModel userModel) {
    return AuthUserEntity(
      uId: userModel.uId,
      email: userModel.email,
      password: '', // Password is not stored locally
      username: userModel.username,
    );
  }
}

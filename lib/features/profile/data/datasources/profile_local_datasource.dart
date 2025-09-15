import 'dart:convert';
import '../../../../core/cache/cache_helper.dart';
import '../models/user_model.dart';

/// ===========================================
/// Profile Local Data Source
/// ===========================================
/// Handles caching and retrieving user profile data locally.
abstract class ProfileLocalDatasource {
  /// Get the cached user from local storage
  UserModel getCachedUser();

  /// Save the user to local cache
  Future<void> cacheUser(UserModel user);

  /// Clear cached user data
  Future<void> clearCache();
}

// Key used for storing user data in cache
const String CACHED_USER_DATA = "CACHED_USER_DATA";

/// ===========================================
/// Implementation of ProfileLocalDatasource
/// ===========================================
class ProfileLocalDatasourceImp implements ProfileLocalDatasource {
  UserModel? _cachedUser;

  @override
  UserModel getCachedUser() {
    // Return cached user if available
    if (_cachedUser != null) {
      return _cachedUser!;
    }

    // Fetch user data from cache
    final jsonString = CacheHelper.getData(key: CACHED_USER_DATA);
    if (jsonString != null) {
      final Map<String, dynamic> decodedJsonData = json.decode(jsonString);
      final userModel = UserModel.fromJson(decodedJsonData);
      _cachedUser = userModel;
      return userModel;
    } else {
      // Throw an exception if no cached data is found
      throw Exception('No cached user data found');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    // Encode user data as JSON and save to cache
    final userJson = json.encode(user.toJson());
    await CacheHelper.saveData(key: CACHED_USER_DATA, value: userJson);
    _cachedUser = user;
  }

  @override
  Future<void> clearCache() async {
    // Clear cached user data
    _cachedUser = null;
    await CacheHelper.removeData(key: CACHED_USER_DATA);
  }
}

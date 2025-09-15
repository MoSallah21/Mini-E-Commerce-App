import 'package:shared_preferences/shared_preferences.dart';

/// A utility class for managing local data storage using [SharedPreferences].
///
/// This class provides static methods to initialize the preferences,
/// save various types of data, retrieve them, and remove them by key.
class CacheHelper {
  /// The shared preferences instance used to store key-value data locally.
  static late SharedPreferences sharedPreferences;

  /// Initializes the [SharedPreferences] instance.
  ///
  /// Must be called before using any other methods in this class.
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Saves a value to local storage under the given [key].
  ///
  /// Supported types for [value] include: `String`, `bool`, `int`, and `double`.
  /// Any unsupported type will be converted to a `String` using `toString()`.
  ///
  /// Returns a [Future] that resolves to `true` if the value was successfully saved,
  /// or `false` if not. Returns `null` if the value was `null`.
  static Future<dynamic> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value != null) {
      if (value is String) {
        return await sharedPreferences.setString(key, value.toString());
      } else if (value is bool) {
        return await sharedPreferences.setBool(key, value);
      } else if (value is int) {
        return await sharedPreferences.setInt(key, value);
      } else if (value is double) {
        return await sharedPreferences.setDouble(key, value);
      } else {
        return await sharedPreferences.setString(key, value.toString());
      }
    }
    return null;
  }

  /// Retrieves a value from local storage using the given [key].
  ///
  /// Returns the value if it exists, or `null` if the key is not found.
  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  /// Removes a value from local storage using the given [key].
  ///
  /// Returns a [Future] that resolves to `true` if the key was successfully removed.
  static Future<bool> removeData({required String key}) async {
    return await CacheHelper.sharedPreferences.remove(key);
  }
}

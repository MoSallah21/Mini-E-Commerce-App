import 'package:ecommerce/core/cache/cache_helper.dart';

class LocaleLocalDataSource {
  static const String _languageCodeKey = 'language_code';

  /// Save selected language code to local storage
  Future<void> saveLanguageCode(String code) async {
    await CacheHelper.saveData(key: _languageCodeKey, value: code);
  }

  /// Retrieve saved language code from local storage
  String? getSavedLanguageCode() {
    return CacheHelper.getData(key: _languageCodeKey)?.toString();
  }

  /// Remove saved language code (reset to default)
  Future<void> clearLanguageCode() async {
    await CacheHelper.removeData(key: _languageCodeKey);
  }
}

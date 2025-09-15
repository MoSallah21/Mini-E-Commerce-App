import 'package:flutter/material.dart';

import '../data/locale_local_datasource.dart';

class LocaleProvider extends ChangeNotifier {
  final LocaleLocalDataSource _localDataSource;

  Locale _locale = const Locale('en'); // default language

  Locale get locale => _locale;

  LocaleProvider(this._localDataSource) {
    _loadSavedLocale();
  }

  /// Load saved language code from local storage
  void _loadSavedLocale() {
    final code = _localDataSource.getSavedLanguageCode();
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  /// Change language
  Future<void> setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return; // only supported languages
    _locale = locale;
    notifyListeners();
    await _localDataSource.saveLanguageCode(locale.languageCode);
  }

  /// Reset to default language
  Future<void> clearLocale() async {
    _locale = const Locale('en');
    notifyListeners();
    await _localDataSource.clearLanguageCode();
  }
}

/// Supported locales
class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
  ];
}

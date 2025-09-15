// ============================================
// Auth Local Datasource - Secure Storage
// ============================================

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ==========================
// AuthLocalDatasource Interface
// ==========================
// Defines the contract for local authentication operations.
// Responsible for caching, retrieving, and clearing auth tokens.
abstract class AuthLocalDatasource {
  // Cache the authentication token securely
  void cacheAuthSession(String token);

  // Retrieve the cached authentication token
  Future<String> getAuthToken();

  // Clear the cached authentication token
  void clearAuthSession();
}

// Key used for storing the auth token in secure storage
const String SECURE_STORAGE_TOKEN_KEY = "AUTH_TOKEN";

// ==========================
// AuthLocalDatasource Implementation
// ==========================
// Implements AuthLocalDatasource using FlutterSecureStorage.
// Provides caching in memory for faster access.
class AuthLocalDatasourceImp implements AuthLocalDatasource {
  final FlutterSecureStorage secureStorage;
  String? _cachedToken; // In-memory cache to reduce storage reads

  // Constructor with required secure storage dependency
  AuthLocalDatasourceImp({required this.secureStorage});

  // ==========================
  // Cache authentication token
  // ==========================
  @override
  void cacheAuthSession(String token) {
    secureStorage.write(key: SECURE_STORAGE_TOKEN_KEY, value: token);
    _cachedToken = token; // Update in-memory cache
  }

  // ==========================
  // Retrieve authentication token
  // ==========================
  @override
  Future<String> getAuthToken() async {
    // Return cached token if available
    if (_cachedToken != null) {
      return _cachedToken!;
    }

    // Read token from secure storage
    final token = await secureStorage.read(key: SECURE_STORAGE_TOKEN_KEY);
    if (token == null) {
      throw Exception('No Auth Token in Cache');
    }

    _cachedToken = token; // Update in-memory cache
    return token;
  }

  // ==========================
  // Clear authentication token
  // ==========================
  @override
  void clearAuthSession() {
    secureStorage.delete(key: SECURE_STORAGE_TOKEN_KEY);
    _cachedToken = null; // Clear in-memory cache
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:ecommerce/features/profile/domain/entities/user_entity.dart';
import 'package:ecommerce/features/profile/domain/usecases/add_profile.dart';
import 'package:ecommerce/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:ecommerce/features/profile/domain/usecases/update_profile_usecase.dart';
import '../../../../core/utils/result.dart';

/// Provider to manage user profile state
class ProfileProvider with ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final AddProfileUseCase _addProfileUseCase;

  ProfileProvider(
      this._getCurrentUserUseCase,
      this._updateProfileUseCase,
      this._addProfileUseCase,
      );

  UserEntity? _currentUser;
  bool _isLoading = false;

  // ============================
  // Getters
  // ============================
  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // ============================
  // Private helpers
  // ============================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setCurrentUser(UserEntity user) {
    _currentUser = user;
    notifyListeners();
  }

  // ============================
  // Public methods
  // ============================

  /// Fetches the current user profile
  Future<void> getCurrentUser() async {
    _setLoading(true);

    final result = await _getCurrentUserUseCase.call();

    result.when(
      success: (user) {
        if (user != null) _setCurrentUser(user);
      },
      failure: (error) {
        // You can handle errors globally or with a separate field
        debugPrint('GetCurrentUser error: $error');
      },
    );

    _setLoading(false);
  }

  /// Updates the current user profile
  Future<void> updateProfile({
    String? username,
    String? email,
    String? fullName,
    String? phone,
    String? city,
    File? image,
    String? imageUrl,
  }) async {
    _setLoading(true);

    final result = await _updateProfileUseCase.call(
      username: username,
      email: email,
      fullName: fullName,
      phone: phone,
      city: city,
      image: image,
      imageUrl: imageUrl,
    );

    result.when(
      success: (updatedUser) {
        if (updatedUser != null) _setCurrentUser(updatedUser);
      },
      failure: (error) {
        debugPrint('UpdateProfile error: $error');
      },
    );

    _setLoading(false);
  }

  /// Adds a new profile for the current user
  Future<void> addProfile({
    required String fullName,
    required String phone,
    required String city,
    File? image,
    String? imageUrl,
  }) async {
    _setLoading(true);

    final result = await _addProfileUseCase.call(
      fullName: fullName,
      phone: phone,
      city: city,
      image: image,
      imageUrl: imageUrl,
    );

    result.when(
      success: (newUser) {
        if (newUser != null) _setCurrentUser(newUser);
      },
      failure: (error) {
        debugPrint('AddProfile error: $error');
      },
    );

    _setLoading(false);
  }
}

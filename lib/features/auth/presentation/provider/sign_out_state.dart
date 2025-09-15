// ============================================
// SignOut State
// ============================================

import 'package:ecommerce/core/utils/result.dart';
import 'package:ecommerce/features/auth/domain/usecases/signout_usecase.dart';
import 'package:flutter/material.dart';

/// ==========================
/// SignOutState
/// ==========================
/// Handles the user sign-out state and communicates with the SignOutUseCase.
class SignOutState extends ChangeNotifier {
  final SignOutUseCase signOutUseCase;

  // ==========================
  // Private state variables
  // ==========================
  bool _isLoading = false;
  String? _errorMessage;

  SignOutState(this.signOutUseCase);

  // ==========================
  // Getters for UI bindings
  // ==========================
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ==========================
  // Perform user sign-out
  // ==========================
  Future<bool> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await signOutUseCase.call();

      bool isSuccess = false;

      // ==========================
      // Handle the result
      // ==========================
      result.when(
        success: (_) {
          isSuccess = true;
        },
        failure: (error) {
          print('Sign out error: $error');
          _errorMessage = 'Logout failed. Please try again.';
        },
      );

      _isLoading = false;
      notifyListeners();

      return isSuccess;

    } catch (e) {
      print('Unexpected error during sign out: $e');
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

// ============================================
// Register State
// ============================================

import 'package:ecommerce/core/utils/result.dart';
import 'package:ecommerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/signin_google_usecase.dart';

// ==========================
// RegisterState
// ==========================
// Handles the registration screen state management using ChangeNotifier.
// Manages email/password registration and Google Sign-In.
class RegisterState extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;

  // ==========================
  // Private state variables
  // ==========================
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _email = '';
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  String? _errorMessage;

  RegisterState({
    required this.registerUseCase,
    required this.signInWithGoogleUseCase,
  });

  // ==========================
  // Getters for UI bindings
  // ==========================
  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String get email => _email;
  String get username => _username;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String? get errorMessage => _errorMessage;

  // ==========================
  // Setters
  // ==========================
  void setEmail(String email) {
    _email = email;
    _clearError();
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    _clearError();
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    _clearError();
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _clearError();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // ==========================
  // Perform Google Sign-In
  // ==========================
  Future<bool> signInWithGoogle() async {
    _errorMessage = null;
    notifyListeners();

    final result = await signInWithGoogleUseCase.call();
    bool isSuccess = false;

    result.when(
      success: (user) {
        isSuccess = true;
      },
      failure: (error) {
        print(error);
        _errorMessage = error;
      },
    );

    notifyListeners();
    return isSuccess;
  }

  // ==========================
  // Perform registration
  // ==========================
  Future<bool> register() async {
    // ==========================
    // Input validations
    // ==========================
    if (username.isEmpty) {
      _errorMessage = 'Username is required';
      notifyListeners();
      return false;
    }

    if (username.length < 3) {
      _errorMessage = 'Username must be more than 3 characters';
      notifyListeners();
      return false;
    }

    if (email.isEmpty || !_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    // ==========================
    // Call register use case
    // ==========================
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await registerUseCase.call(
      email: email,
      username: username,
      password: password,
    );

    bool isSuccess = false;

    result.when(
      success: (user) {
        isSuccess = true;
      },
      failure: (error) {
        print(error);
        _errorMessage = 'Registration failed. Please try again.';
      },
    );

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  // ==========================
  // Validate email format
  // ==========================
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

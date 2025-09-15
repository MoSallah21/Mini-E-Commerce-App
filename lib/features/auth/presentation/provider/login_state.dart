// ============================================
// Login State
// ============================================

import 'package:ecommerce/core/utils/result.dart';
import 'package:ecommerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/signin_google_usecase.dart';
import 'package:flutter/material.dart';

// ==========================
// LoginState
// ==========================
// Handles the login screen state management using ChangeNotifier.
// Manages both email/password login and Google Sign-In.
class LoginState extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;

  // ==========================
  // Private state variables
  // ==========================
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isPasswordVisible = false;
  String _email = '';
  String _password = '';
  String? _errorMessage;

  LoginState({
    required this.loginUseCase,
    required this.signInWithGoogleUseCase,
  });

  // ==========================
  // Getters for UI bindings
  // ==========================
  bool get isLoading => _isLoading;
  bool get isGoogleLoading => _isGoogleLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  String get email => _email;
  String get password => _password;
  String? get errorMessage => _errorMessage;

  // ==========================
  // Setters
  // ==========================
  void setEmail(String email) {
    _email = email;
    _clearError();
  }

  void setPassword(String password) {
    _password = password;
    _clearError();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // ==========================
  // Perform login with email and password
  // ==========================
  Future<bool> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Please fill email and password';
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(_email)) {
      _errorMessage = 'Please confirm your email format';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase.call(_email, _password);
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

    _isLoading = false;
    notifyListeners();

    return isSuccess;
  }

  // ==========================
  // Perform login with Google
  // ==========================
  Future<bool> signInWithGoogle() async {
    _isGoogleLoading = true;
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

    _isGoogleLoading = false;
    notifyListeners();

    return isSuccess;
  }

  // ==========================
  // Validate email format
  // ==========================
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // ==========================
  // Reset the state to initial values
  // ==========================
  void resetState() {
    _email = '';
    _password = '';
    _errorMessage = null;
    _isLoading = false;
    _isGoogleLoading = false;
    _isPasswordVisible = false;
    notifyListeners();
  }
}

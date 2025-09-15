// ============================================
// Auth Repository Interface
// ============================================

import 'package:ecommerce/features/auth/domain/entities/auth_user_entity.dart';
import 'package:ecommerce/core/utils/result.dart';

// ==========================
// AuthRepository
// ==========================
// Defines the contract for authentication operations.
// Supports email/password login, registration, Google sign-in, and sign-out.
abstract class AuthRepository {
  // ==========================
  // Login using email and password
  // ==========================
  Future<Result<AuthUserEntity>> login(String email, String password);

  // ==========================
  // Register a new user with email, username, and password
  // ==========================
  Future<Result<AuthUserEntity>> register({
    required String email,
    required String username,
    required String password,
  });

  // ==========================
  // Sign in using Google account
  // ==========================
  Future<Result<AuthUserEntity>> signInWithGoogle();

  // ==========================
  // Sign out the current user
  // ==========================
  Future<Result<bool>> signOut();
}

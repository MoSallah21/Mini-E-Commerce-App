// ============================================
// Google Sign-In Use Case
// ============================================

import '../../../../core/utils/result.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

// ==========================
// SignInWithGoogleUseCase
// ==========================
// Handles user authentication via Google Sign-In by interacting with the AuthRepository.
// Part of the Clean Architecture use case layer.
class SignInWithGoogleUseCase {
  final AuthRepository authRepository;

  SignInWithGoogleUseCase(this.authRepository);

  // ==========================
  // Execute Google Sign-In
  // ==========================
  Future<Result<AuthUserEntity>> call() async {
    return await authRepository.signInWithGoogle();
  }
}

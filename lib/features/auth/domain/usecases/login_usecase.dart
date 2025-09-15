// ============================================
// Login Use Case
// ============================================

import '../../../../core/utils/result.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

// ==========================
// LoginUseCase
// ==========================
// Handles the login process by interacting with the AuthRepository.
// This is part of the Clean Architecture use case layer.
class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  // ==========================
  // Execute login with email and password
  // ==========================
  Future<Result<AuthUserEntity>> call(String email, String password) async {
    return await authRepository.login(email, password);
  }
}

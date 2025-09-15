// ============================================
// Register Use Case
// ============================================

import '../../../../core/utils/result.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

// ==========================
// RegisterUseCase
// ==========================
// Handles user registration by interacting with the AuthRepository.
// Part of the Clean Architecture use case layer.
class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  // ==========================
  // Execute user registration with email, username, and password
  // ==========================
  Future<Result<AuthUserEntity>> call({
    required String email,
    required String username,
    required String password,
  }) async {
    return await authRepository.register(
      email: email,
      username: username,
      password: password,
    );
  }
}

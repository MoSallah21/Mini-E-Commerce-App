// ============================================
// Sign-Out Use Case
// ============================================

import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

// ==========================
// SignOutUseCase
// ==========================
// Handles signing out the current user by interacting with the AuthRepository.
// Part of the Clean Architecture use case layer.
class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  // ==========================
  // Execute sign-out
  // ==========================
  Future<Result<bool>> call() async {
    return await authRepository.signOut();
  }
}

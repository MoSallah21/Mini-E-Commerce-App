import 'package:ecommerce/features/profile/domain/entities/user_entity.dart';
import 'package:ecommerce/features/profile/domain/repositories/profile_repository.dart';
import '../../../../core/utils/result.dart';

/// Use case for retrieving the current user's profile
class GetCurrentUserUseCase {
  final ProfileRepository profileRepository;

  GetCurrentUserUseCase(this.profileRepository);

  /// Executes the use case
  Future<Result<UserEntity>> call() async {
    return await profileRepository.getProfile();
  }
}

import 'dart:io';
import 'package:ecommerce/features/profile/domain/entities/user_entity.dart';
import 'package:ecommerce/features/profile/domain/repositories/profile_repository.dart';
import '../../../../core/utils/result.dart';

/// Use case for updating the current user's profile
class UpdateProfileUseCase {
  final ProfileRepository profileRepository;

  UpdateProfileUseCase(this.profileRepository);

  /// Executes the update profile operation
  Future<Result<UserEntity>> call({
    String? username,
    String? email,
    String? fullName,
    String? phone,
    String? city,
    File? image,
    String? imageUrl,
  }) async {
    return await profileRepository.updateProfile(
      username: username,
      fullName: fullName,
      email: email,
      phone: phone,
      city: city,
      image: image,
      imgUrl: imageUrl,
    );
  }
}

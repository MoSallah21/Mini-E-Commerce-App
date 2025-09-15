import 'dart:io';
import 'package:ecommerce/features/profile/domain/entities/user_entity.dart';
import 'package:ecommerce/features/profile/domain/repositories/profile_repository.dart';
import '../../../../core/utils/result.dart';

/// Use case for adding a new user profile
class AddProfileUseCase {
  final ProfileRepository profileRepository;

  AddProfileUseCase(this.profileRepository);

  /// Executes the use case
  Future<Result<UserEntity>> call({
    required String fullName,
    required String phone,
    required String city,
    File? image,
    String? imageUrl,
  }) async {
    return await profileRepository.addProfile(
      fullName: fullName,
      phone: phone,
      city: city,
      image: image,
      imgUrl: imageUrl,
    );
  }
}

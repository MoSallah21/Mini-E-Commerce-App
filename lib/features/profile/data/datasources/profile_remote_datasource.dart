import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ecommerce/features/profile/data/models/user_model.dart';
import '../../../../core/utils/result.dart';

/// ===========================================
/// Profile Remote Data Source
/// ===========================================
/// Handles fetching, adding, and updating user profile data from Firestore & Firebase Storage
abstract class ProfileRemoteDataSource {
  /// Update the user profile
  Future<Result<UserModel>> updateProfile(
      String uId, {
        String? username,
        String? fullName,
        String? email,
        String? phone,
        String? city,
        String? birthday,
        String? imgUrl,
        File? image,
      });

  /// Add a new user profile
  Future<Result<UserModel>> addProfile(
      String uId, {
        required String fullName,
        required String phone,
        required String city,
        String? imgUrl,
        File? image,
      });

  /// Get user profile by UID
  Future<Result<UserModel>> getProfile(String uId);
}

/// ===========================================
/// Implementation of ProfileRemoteDataSource
/// ===========================================
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<Result<UserModel>> updateProfile(
      String uId, {
        String? username,
        String? fullName,
        String? email,
        String? phone,
        String? city,
        String? birthday,
        String? imgUrl,
        File? image,
      }) async {
    try {
      final docRef = firestore.collection('users').doc(uId);
      String? imageUrl = imgUrl;

      // Upload image if provided
      if (image != null) {
        final storageRef = storage.ref().child('users/$uId/avatar.jpg');
        await storageRef.putFile(image);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Prepare the update data
      final Map<String, dynamic> updateData = {};
      if (username != null) updateData['username'] = username;
      if (fullName != null) updateData['fullName'] = fullName;
      if (email != null) updateData['email'] = email;
      if (phone != null) updateData['phone'] = phone;
      if (city != null) updateData['city'] = city;
      if (birthday != null) updateData['birthday'] = birthday;
      if (imageUrl != null) updateData['imgUrl'] = imageUrl;
      updateData['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

      // Update Firestore document
      await docRef.update(updateData);

      // Fetch updated user
      final updatedSnapshot = await docRef.get();
      final user = UserModel.fromJson(updatedSnapshot.data()!);

      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<UserModel>> getProfile(String uId) async {
    try {
      final docSnapshot = await firestore.collection('users').doc(uId).get();
      if (!docSnapshot.exists) {
        return Result.failure("User not found");
      }
      final user = UserModel.fromJson(docSnapshot.data()!);
      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<UserModel>> addProfile(
      String uId, {
        required String fullName,
        required String phone,
        required String city,
        String? imgUrl,
        File? image,
      }) async {
    try {
      final docRef = firestore.collection('users').doc(uId);
      String? imageUrl = imgUrl;

      // Upload image if provided
      if (image != null) {
        final storageRef = storage.ref().child('users/$uId/avatar.jpg');
        await storageRef.putFile(image);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Prepare user data
      final Map<String, dynamic> data = {
        'fullName': fullName,
        'phone': phone,
        'city': city,
      };
      if (imageUrl != null) data['imgUrl'] = imageUrl;

      // Add or merge the user data in Firestore
      await docRef.set(data, SetOptions(merge: true));

      // Fetch newly added user
      final updatedSnapshot = await docRef.get();
      final user = UserModel.fromJson(updatedSnapshot.data()!);

      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}

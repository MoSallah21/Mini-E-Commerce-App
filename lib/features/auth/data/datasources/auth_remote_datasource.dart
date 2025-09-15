// ============================================
// Auth Remote DataSource - Firebase & Google Sign-In
// ============================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ecommerce/features/auth/data/models/auth_user_model.dart';
import 'package:ecommerce/core/utils/result.dart';

// ==========================
// AuthRemoteDataSource Interface
// ==========================
// Defines the contract for remote authentication operations.
// Handles login, registration, Google sign-in, and sign-out.
abstract class AuthRemoteDataSource {
  Future<Result<AuthUserModel>> login(String email, String password);
  Future<Result<AuthUserModel>> register(
      String email, String username, String password);
  Future<Result<AuthUserModel>> signInWithGoogle();
  Future<Result<void>> signOut();
}

// ==========================
// AuthRemoteDataSource Implementation
// ==========================
// Implements AuthRemoteDataSource using FirebaseAuth, Firestore, and GoogleSignIn.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  late final GoogleSignIn _googleSignIn;

  // Constructor with optional dependency injection
  AuthRemoteDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _googleSignIn = GoogleSignIn.instance;
  }

  // ==========================
  // Login with email and password
  // ==========================
  @override
  Future<Result<AuthUserModel>> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (credential.user != null) {
        final doc = await _firestore.collection('users').doc(credential.user!.uid).get();

        if (doc.exists) {
          final data = doc.data()!;
          data['uId'] = credential.user!.uid;
          final userModel = AuthUserModel.fromJson(data);
          return Result.success(userModel);
        } else {
          return Result.failure('Server error: user data not found');
        }
      } else {
        return Result.failure('Login failed');
      }
    } on FirebaseAuthException catch (error) {
      return Result.failure(_getErrorMessage(error.code));
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ==========================
  // Register a new user
  // ==========================
  @override
  Future<Result<AuthUserModel>> register(
      String email, String username, String password) async {
    try {
      // Check if username is already taken
      final usernameExists = await _checkUsernameExists(username);
      if (usernameExists) {
        return Result.failure('Username already in use');
      }

      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await credential.user!.updateDisplayName(username);

        final userMap = {
          'uId': credential.user!.uid,
          'email': email,
          'username': username,
          'imgUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(credential.user!.uid).set(userMap);

        await credential.user!.sendEmailVerification();

        final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
        final finalData = doc.data()!;
        finalData['uId'] = credential.user!.uid;
        final userModel = AuthUserModel.fromJson(finalData);

        return Result.success(userModel);
      } else {
        return Result.failure('Registration failed');
      }
    } on FirebaseAuthException catch (error) {
      return Result.failure(_getErrorMessage(error.code));
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ==========================
  // Sign in with Google
  // ==========================
  @override
  Future<Result<AuthUserModel>> signInWithGoogle() async {
    try {
      await _initializeGoogleSignIn();

      // Authenticate the user
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create Firebase credential using idToken
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          // Existing user
          final data = doc.data()!;
          data['uId'] = user.uid;
          return Result.success(AuthUserModel.fromJson(data));
        } else {
          // New user, create record
          return await _createNewGoogleUser(user);
        }
      } else {
        return Result.failure('Google sign-in failed');
      }
    } on GoogleSignInException catch (error) {
      return Result.failure(_handleGoogleSignInException(error));
    } on FirebaseAuthException catch (error) {
      return Result.failure(_getErrorMessage(error.code));
    } catch (e) {
      return Result.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ==========================
  // Initialize Google Sign-In
  // ==========================
  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        clientId: '1:895977742080:android:aff5fc1dcc0275925b5de5',
        serverClientId: '895977742080-a6su7dlinvtb1k7tkn9g4goh267j8hu2.apps.googleusercontent.com',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Google Sign-In already initialized or failed: $e');
      }
    }
  }

  // ==========================
  // Handle Google Sign-In errors
  // ==========================
  String _handleGoogleSignInException(GoogleSignInException error) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Sign-in cancelled';
      case GoogleSignInExceptionCode.interrupted:
        return 'Sign-in interrupted';
      case GoogleSignInExceptionCode.unknownError:
      default:
        return 'Google sign-in failed: ${error.description}';
    }
  }

  // ==========================
  // Create new Google user in Firestore
  // ==========================
  Future<Result<AuthUserModel>> _createNewGoogleUser(User user) async {
    try {
      String username = user.displayName ?? 'GoogleUser';

      if (await _checkUsernameExists(username)) {
        username = '${username}_${user.uid.substring(0, 6)}';
      }

      final userMap = {
        'uId': user.uid,
        'email': user.email ?? '',
        'username': username,
        'imgUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(user.uid).set(userMap);

      final newDoc = await _firestore.collection('users').doc(user.uid).get();
      final finalData = newDoc.data()!;
      finalData['uId'] = user.uid;
      return Result.success(AuthUserModel.fromJson(finalData));
    } catch (e) {
      return Result.failure('Failed to create account: ${e.toString()}');
    }
  }

  // ==========================
  // Sign out from Firebase and Google
  // ==========================
  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return Result.success(null);
    } catch (e) {
      return Result.failure('Sign-out failed: ${e.toString()}');
    }
  }

  // ==========================
  // Check if username exists in Firestore
  // ==========================
  Future<bool> _checkUsernameExists(String username) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ==========================
  // Convert Firebase error codes to user-friendly messages
  // ==========================
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Weak password';
      case 'invalid-email':
        return 'Invalid email';
      case 'user-disabled':
        return 'User disabled';
      case 'too-many-requests':
        return 'Too many requests, try again later';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'requires-recent-login':
        return 'Recent login required';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'quota-exceeded':
        return 'Quota exceeded';
      case 'credential-already-in-use':
        return 'Credential already in use';
      case 'account-exists-with-different-credential':
        return 'Account exists with different credential';
      case 'network-request-failed':
        return 'Network request failed';
      case 'internal-error':
        return 'Internal error, try again later';
      default:
        return 'Unexpected error: $errorCode';
    }
  }
}

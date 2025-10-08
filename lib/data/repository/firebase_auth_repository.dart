import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/firebase_credentials.dart';

abstract class FirebaseAuthRepository {
  Future<Result<User>> createUser(FirebaseCredentials credentials);

  Future<Result<User>> login(FirebaseCredentials credentials);

  Future<Result<void>> logOut();

  Future<Result<void>> resetPassword(String email);

  bool isAuthenticated();
}

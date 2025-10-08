import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/operation_status.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/firebase_credentials.dart';

abstract class FirebaseAuthSource {
  Future<Result<User>> signUp(FirebaseCredentials credentials);

  Future<Result<User>> signIn(FirebaseCredentials credentials);

  Future<Result<OperationStatus>> signOut();

  bool isAuthenticated();

  String getUserUID();

  Future<Result<OperationStatus>> resetPassword(String email);

  Future<void> sendEmailVerification();
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/data/repository/firebase_auth_repository.dart';
import 'package:firebase_social_auth_demo/data/source/remote/firebase/firebase_auth_source.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/firebase_credentials.dart';

class FirebaseAuthRepositoryImpl extends FirebaseAuthRepository {
  final FirebaseAuthSource _authSource;

  FirebaseAuthRepositoryImpl(this._authSource);

  @override
  Future<Result<User>> createUser(FirebaseCredentials credentials) async {
    final registrationResponse = await _authSource.signUp(credentials);
    if (registrationResponse.isOk) {
      await _authSource.sendEmailVerification();
    }
    return registrationResponse;
  }

  @override
  Future<Result<User>> login(FirebaseCredentials credentials) async {
    final loginResponse = await _authSource.signIn(credentials);
    return loginResponse;
  }

  @override
  Future<Result<void>> logOut() async {
    final response = await _authSource.signOut();
    if (response.isOk) {
      return Result.ok(null);
    }
    return response;
  }

  @override
  bool isAuthenticated() => _authSource.isAuthenticated();

  @override
  Future<Result<void>> resetPassword(String email) async {
    final response = await _authSource.resetPassword(email);
    if (response.isOk) {
      return Result.ok(null);
    }
    return response;
  }
}

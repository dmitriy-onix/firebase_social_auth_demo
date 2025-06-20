import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';

abstract class BaseAuthService {
  Future<Result<UserCredential>> signIn();

  Future<void> signOut();
}

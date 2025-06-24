import 'package:firebase_social_auth_demo/domain/entity/auth/auth_method.dart';

abstract class AuthMethodRepository {
  Future<void> saveAuthMethod(SocialAuthMethod method);

  Future<SocialAuthMethod?> getAuthMethod();

  Future<void> clearAuthMethod();
}

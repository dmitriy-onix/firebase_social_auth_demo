import 'package:firebase_social_auth_demo/auth/apple/apple_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/base_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/facebook/facebook_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/google/google_auth_service.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/auth_method.dart';

class AuthServiceFactory {
  BaseAuthService getAuthService(SocialAuthMethod method) {
    switch (method) {
      case SocialAuthMethod.google:
        return GoogleAuthService();
      case SocialAuthMethod.facebook:
        return FacebookAuthService();
      case SocialAuthMethod.apple:
        return AppleAuthService();
    }
  }
}

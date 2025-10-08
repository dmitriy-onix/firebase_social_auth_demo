import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/auth/apple/apple_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/base_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/facebook/facebook_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/google/google_auth_service.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/auth_method.dart';

class AuthServiceFactory {
  final FirebaseAuth _firebaseAuth;

  AuthServiceFactory(this._firebaseAuth);

  BaseAuthService getAuthService(SocialAuthMethod method) {
    switch (method) {
      case SocialAuthMethod.google:
        return GoogleAuthService(_firebaseAuth);
      case SocialAuthMethod.facebook:
        return FacebookAuthService(_firebaseAuth);
      case SocialAuthMethod.apple:
        return AppleAuthService(_firebaseAuth);
    }
  }
}

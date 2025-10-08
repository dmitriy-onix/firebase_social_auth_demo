import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/social_auth_failure.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthExceptionHandler {
  static const String _cancelledMessage =
      'Google sign-in was cancelled by the user.';
  static const String _networkErrorMessage =
      'A network error occurred during Google sign-in.';
  static const String _platformErrorMessage =
      'A platform error occurred during Google sign-in.';
  static const String _firebaseErrorMessage = 'A Firebase error occurred.';
  static const String _unknownErrorMessage =
      'An unknown error occurred during Google sign-in.';

  static SocialAuthFailure handleGoogleSignInException(
    GoogleSignInException e,
  ) {
    if (e.code == GoogleSignInExceptionCode.canceled ||
        e.code == GoogleSignInExceptionCode.interrupted) {
      return SocialAuthFailure(
        SocialAuthFailureType.cancelled,
        message: _cancelledMessage,
      );
    }

    return SocialAuthFailure(
      SocialAuthFailureType.unknown,
      message: _unknownErrorMessage,
      originalException: e,
    );
  }

  static SocialAuthFailure handlePlatformException(PlatformException e) {
    if (e.code == 'network_error') {
      return SocialAuthFailure(
        SocialAuthFailureType.networkError,
        message: _networkErrorMessage,
        originalException: e,
      );
    }

    return SocialAuthFailure(
      SocialAuthFailureType.unknown,
      message: _platformErrorMessage,
      originalException: e,
    );
  }

  static SocialAuthFailure handleFirebaseAuthException(
    FirebaseAuthException e,
  ) {
    final type =
        e.code == 'account-exists-with-different-credential'
            ? SocialAuthFailureType.accountExistsWithDifferentCredential
            : SocialAuthFailureType.unknown;

    return SocialAuthFailure(
      type,
      message: e.message ?? _firebaseErrorMessage,
      originalException: e,
    );
  }

  static SocialAuthFailure handleUnknownException(Object e) {
    return SocialAuthFailure(
      SocialAuthFailureType.unknown,
      message: _unknownErrorMessage,
      originalException: e,
    );
  }
}

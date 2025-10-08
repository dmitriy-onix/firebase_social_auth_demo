import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/social_auth_failure.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthExceptionHandler {
  static const String _cancelledMessage =
      'Apple sign-in was cancelled by the user.';
  static const String _authorizationErrorMessage =
      'An error occurred during Apple sign-in.';
  static const String _firebaseErrorMessage = 'A Firebase error occurred.';
  static const String _unknownErrorMessage =
      'An unknown error occurred during Apple sign-in.';

  static SocialAuthFailure handleAuthorizationException(
    SignInWithAppleAuthorizationException e,
  ) {
    if (e.code == AuthorizationErrorCode.canceled) {
      return SocialAuthFailure(
        SocialAuthFailureType.cancelled,
        message: _cancelledMessage,
      );
    }

    return SocialAuthFailure(
      SocialAuthFailureType.unknown,
      message: _authorizationErrorMessage,
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

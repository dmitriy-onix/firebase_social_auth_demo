import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/social_auth_failure.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthExceptionHandler {
  static const String _cancelledMessage =
      'Facebook sign-in was cancelled by the user.';
  static const String _accessTokenNullMessage =
      'Facebook login succeeded but access token was null.';
  static const String _firebaseErrorMessage = 'A Firebase error occurred.';
  static const String _unknownErrorMessage =
      'An unknown error occurred during Facebook sign-in.';
  static const String _operationInProgressMessage =
      'A Facebook sign-in operation is already in progress.';

  static SocialAuthFailure handleNullAccessToken() {
    return SocialAuthFailure(
      SocialAuthFailureType.unknown,
      message: _accessTokenNullMessage,
    );
  }

  static SocialAuthFailure handleCanceled() {
    return SocialAuthFailure(
      SocialAuthFailureType.cancelled,
      message: _cancelledMessage,
    );
  }

  static SocialAuthFailure handleFailed(LoginResult result) {
    return SocialAuthFailure(
      SocialAuthFailureType.unknown,
      message: result.message ?? _unknownErrorMessage,
    );
  }

  static SocialAuthFailure handleOperationInProgress() {
    return SocialAuthFailure(
      SocialAuthFailureType.unknown,
      message: _operationInProgressMessage,
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

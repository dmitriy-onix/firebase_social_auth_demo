import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/firebase_auth_failure.dart';

class FirebaseAuthExceptionHandler {
  static FirebaseAuthFailure handleAuthException(FirebaseAuthException e) {
    logger.e('FirebaseAuthException [${e.code}]: ${e.message}');
    final failureType = _mapExceptionToFailure(e);
    return FirebaseAuthFailure(
      failureType,
      message: generateErrorMessage(failureType),
    );
  }

  static FirebaseAuthFailure generateUnknownFailure([String? message]) {
    return FirebaseAuthFailure(
      FirebaseAuthFailureType.unknown,
      message: message ?? generateErrorMessage(FirebaseAuthFailureType.unknown),
    );
  }

  static String generateErrorMessage(FirebaseAuthFailureType error) {
    switch (error) {
      case FirebaseAuthFailureType.invalidEmail:
        return 'The email address is badly formatted.';
      case FirebaseAuthFailureType.weakPassword:
        return 'The password is too weak.';
      case FirebaseAuthFailureType.wrongPassword:
        return 'Incorrect password. Please try again.';
      case FirebaseAuthFailureType.emailAlreadyExists:
        return 'An account already exists with this email address.';
      case FirebaseAuthFailureType.requiresRecentLogin:
        return 'This operation is sensitive and requires recent authentication. Please sign in again.';
      case FirebaseAuthFailureType.userNotFound:
        return 'No user found for this email.';
      case FirebaseAuthFailureType.userDisabled:
        return 'This user has been disabled. Please contact support.';
      case FirebaseAuthFailureType.tooManyRequests:
        return 'Too many requests. Please try again later.';
      case FirebaseAuthFailureType.networkRequestFailed:
        return 'Network error. Please check your connection and try again.';
      case FirebaseAuthFailureType.accountExistsWithDifferentCredential:
        return 'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.';
      case FirebaseAuthFailureType.invalidCredential:
        return 'The credential received is malformed or has expired.';
      case FirebaseAuthFailureType.unknown:
        return 'An unexpected error occurred. Please try again.';
      case FirebaseAuthFailureType.operationNotAllowed:
        return 'Check is email authorization enabled on your Firebase account.';
      case FirebaseAuthFailureType.profileNotFound:
        return "Can't fetch User Profile.";
      case FirebaseAuthFailureType.logoutFailed:
        return 'Log Out failed.';
    }
  }

  static FirebaseAuthFailureType _mapExceptionToFailure(
      FirebaseAuthException e,) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseAuthFailureType.invalidEmail;
      case 'wrong-password':
        return FirebaseAuthFailureType.wrongPassword;
      case 'weak-password':
        return FirebaseAuthFailureType.weakPassword;
      case 'email-already-in-use':
        return FirebaseAuthFailureType.emailAlreadyExists;
      case 'requires-recent-login':
        return FirebaseAuthFailureType.requiresRecentLogin;
      case 'user-not-found':
        return FirebaseAuthFailureType.userNotFound;
      case 'user-disabled':
        return FirebaseAuthFailureType.userDisabled;
      case 'too-many-requests':
        return FirebaseAuthFailureType.tooManyRequests;
      case 'network-request-failed':
        return FirebaseAuthFailureType.networkRequestFailed;
      case 'account-exists-with-different-credential':
        return FirebaseAuthFailureType.accountExistsWithDifferentCredential;
      case 'invalid-credential':
        return FirebaseAuthFailureType.invalidCredential;
      case 'operation-not-allowed':
        return FirebaseAuthFailureType.operationNotAllowed;
      case 'profile-not-found':
        return FirebaseAuthFailureType.profileNotFound;
      case 'logout-failed':
        return FirebaseAuthFailureType.logoutFailed;
      default:
        return FirebaseAuthFailureType.unknown;
    }
  }
}


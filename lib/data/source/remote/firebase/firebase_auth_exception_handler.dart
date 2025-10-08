import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/data/source/remote/firebase/firebase_const.dart';
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
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case FirebaseConst.errInvalidEmail:
        return FirebaseAuthFailureType.invalidEmail;
      case FirebaseConst.errWrongPassword:
        return FirebaseAuthFailureType.wrongPassword;
      case FirebaseConst.errWeakPassword:
        return FirebaseAuthFailureType.weakPassword;
      case FirebaseConst.errEmailAlreadyInUse:
        return FirebaseAuthFailureType.emailAlreadyExists;
      case FirebaseConst.errRequiresRecentLogin:
        return FirebaseAuthFailureType.requiresRecentLogin;
      case FirebaseConst.errUserNotFound:
        return FirebaseAuthFailureType.userNotFound;
      case FirebaseConst.errUserDisabled:
        return FirebaseAuthFailureType.userDisabled;
      case FirebaseConst.errTooManyRequests:
        return FirebaseAuthFailureType.tooManyRequests;
      case FirebaseConst.errNetworkRequestFailed:
        return FirebaseAuthFailureType.networkRequestFailed;
      case FirebaseConst.errAccountExistsWithDifferentCredential:
        return FirebaseAuthFailureType.accountExistsWithDifferentCredential;
      case FirebaseConst.errInvalidCredential:
        return FirebaseAuthFailureType.invalidCredential;
      case FirebaseConst.errOperationNotAllowed:
        return FirebaseAuthFailureType.operationNotAllowed;
      case FirebaseConst.errProfileNotFound:
        return FirebaseAuthFailureType.profileNotFound;
      case FirebaseConst.errLogoutFailed:
        return FirebaseAuthFailureType.logoutFailed;
      default:
        return FirebaseAuthFailureType.unknown;
    }
  }
}

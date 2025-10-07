class FirebaseAuthFailure implements Exception {
  final FirebaseAuthFailureType failure;
  final String message;

  FirebaseAuthFailure(this.failure, {this.message = ''});

  @override
  String toString() {
    return 'FirebaseAuthFailure{$failure, message: $message}';
  }
}

enum FirebaseAuthFailureType {
  wrongPassword,
  userNotFound,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  requiresRecentLogin,
  userDisabled,
  tooManyRequests,
  networkRequestFailed,
  accountExistsWithDifferentCredential,
  invalidCredential,
  operationNotAllowed,
  profileNotFound,
  logoutFailed,
  unknown,
}

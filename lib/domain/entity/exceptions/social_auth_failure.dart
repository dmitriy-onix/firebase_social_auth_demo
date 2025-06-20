class SocialAuthFailure implements Exception {
  final SocialAuthFailureType type;

  final String message;

  final dynamic originalException;

  SocialAuthFailure(this.type, {required this.message, this.originalException});

  @override
  String toString() {
    return 'SocialAuthFailure(type: $type, message: "$message", originalException: $originalException)';
  }
}

enum SocialAuthFailureType {
  cancelled,
  networkError,
  accountExistsWithDifferentCredential,
  invalidCredential,
  unknown,
}

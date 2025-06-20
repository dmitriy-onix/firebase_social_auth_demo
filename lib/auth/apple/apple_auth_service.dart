import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/auth/base_auth_service.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/social_auth_failure.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthService implements BaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Result<UserCredential>> signIn() async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        rawNonce: rawNonce,
        accessToken: credential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );
      return Result.ok(userCredential);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return Result.error(
          error: SocialAuthFailure(
            SocialAuthFailureType.cancelled,
            message: 'Apple sign-in was cancelled by the user.',
          ),
        );
      }
      logger.e(
        'Apple sign-in failed with AuthorizationException: ${e.code}',
        error: e,
      );
      return Result.error(
        error: SocialAuthFailure(
          SocialAuthFailureType.unknown,
          message: 'An error occurred during Apple sign-in.',
          originalException: e,
        ),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(
        'Apple sign-in failed with FirebaseAuthException: ${e.code}',
        error: e,
      );
      final type =
          e.code == 'account-exists-with-different-credential'
              ? SocialAuthFailureType.accountExistsWithDifferentCredential
              : SocialAuthFailureType.unknown;
      return Result.error(
        error: SocialAuthFailure(
          type,
          message: e.message ?? 'A Firebase error occurred.',
          originalException: e,
        ),
      );
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Apple signIn');
      return Result.error(
        error: SocialAuthFailure(
          SocialAuthFailureType.unknown,
          message: 'An unknown error occurred during Apple sign-in.',
          originalException: e,
        ),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s);
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

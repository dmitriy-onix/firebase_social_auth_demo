import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/auth/base_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/facebook/facebook_auth_exception_handler.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService implements BaseAuthService {
  final FacebookAuth _facebookAuth;

  final FirebaseAuth _firebaseAuth;

  FacebookAuthService(this._firebaseAuth, [FacebookAuth? facebookAuth])
    : _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  @override
  Future<Result<UserCredential>> signIn() async {
    try {
      final rawNonce = Platform.isIOS ? _generateNonce() : null;
      final nonce = rawNonce != null ? _sha256ofString(rawNonce) : null;

      final result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
        nonce: nonce,
      );

      switch (result.status) {
        case LoginStatus.success:
          return _handleLoginSuccess(result, rawNonce);
        case LoginStatus.cancelled:
          return Result.error(
            error: FacebookAuthExceptionHandler.handleCanceled(),
          );
        case LoginStatus.failed:
          return Result.error(
            error: FacebookAuthExceptionHandler.handleFailed(result),
          );
        case LoginStatus.operationInProgress:
          return Result.error(
            error: FacebookAuthExceptionHandler.handleOperationInProgress(),
          );
      }
    } on FirebaseAuthException catch (e) {
      logger.e(
        'Facebook sign-in failed with FirebaseAuthException: ${e.code}',
        error: e,
      );
      return Result.error(
        error: FacebookAuthExceptionHandler.handleFirebaseAuthException(e),
      );
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Facebook signIn');

      return Result.error(
        error: FacebookAuthExceptionHandler.handleUnknownException(e),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _facebookAuth.logOut();
      await _firebaseAuth.signOut();
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Facebook signOut');
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

  Future<Result<UserCredential>> _handleLoginSuccess(
    LoginResult result,
    String? rawNonce,
  ) async {
    final accessToken = result.accessToken;
    if (accessToken == null) {
      return Result.error(
        error: FacebookAuthExceptionHandler.handleNullAccessToken(),
      );
    }
    final OAuthCredential credential;
    if (Platform.isAndroid) {
      credential = FacebookAuthProvider.credential(accessToken.tokenString);
    } else {
      credential = OAuthProvider(
        'facebook.com',
      ).credential(idToken: accessToken.tokenString, rawNonce: rawNonce);
    }
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return Result.ok(userCredential);
  }
}

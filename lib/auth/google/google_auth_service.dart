import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/auth/base_auth_service.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/social_auth_failure.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService implements BaseAuthService {
  @override
  Future<Result<UserCredential>> signIn() async {
    try {
      await GoogleSignIn.instance.initialize();

      GoogleSignIn.instance.signOut();
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      return Result.ok(userCredential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return Result.error(
          error: SocialAuthFailure(
            SocialAuthFailureType.cancelled,
            message: 'Google sign-in was cancelled by the user.',
          ),
        );
      }

      if (e.code == GoogleSignInExceptionCode.interrupted) {
        return Result.error(
          error: SocialAuthFailure(
            SocialAuthFailureType.cancelled,
            message: 'Google sign-in was cancelled by the user.',
          ),
        );
      }

      return Result.error(
        error: SocialAuthFailure(
          SocialAuthFailureType.unknown,
          message: 'An unknown error occurred during Google sign-in.',
          originalException: e,
        ),
      );
    } on PlatformException catch (e) {
      logger.e(
        'Google sign-in failed with PlatformException: ${e.code}',
        error: e,
      );
      if (e.code == 'network_error') {
        return Result.error(
          error: SocialAuthFailure(
            SocialAuthFailureType.networkError,
            message: 'A network error occurred during Google sign-in.',
            originalException: e,
          ),
        );
      }
      return Result.error(
        error: SocialAuthFailure(
          SocialAuthFailureType.unknown,
          message: 'A platform error occurred during Google sign-in.',
          originalException: e,
        ),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(
        'Google sign-in failed with FirebaseAuthException: ${e.code}',
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
      logger.crash(error: e, stackTrace: s, reason: 'Google signIn');
      return Result.error(
        error: SocialAuthFailure(
          SocialAuthFailureType.unknown,
          message: 'An unknown error occurred during Google sign-in.',
          originalException: e,
        ),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Google signOut');
    }
  }
}

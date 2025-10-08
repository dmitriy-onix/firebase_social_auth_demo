import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/auth/base_auth_service.dart';
import 'package:firebase_social_auth_demo/auth/google/google_auth_exception_handler.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService implements BaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthService(this._firebaseAuth, [GoogleSignIn? googleSignIn])
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<Result<UserCredential>> signIn() async {
    try {
      await _googleSignIn.initialize();

      _googleSignIn.signOut();
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return Result.ok(userCredential);
    } on GoogleSignInException catch (e) {
      return Result.error(
        error: GoogleAuthExceptionHandler.handleGoogleSignInException(e),
      );
    } on PlatformException catch (e) {
      logger.e(
        'Google sign-in failed with PlatformException: ${e.code}',
        error: e,
      );

      return Result.error(
        error: GoogleAuthExceptionHandler.handlePlatformException(e),
      );
    } on FirebaseAuthException catch (e) {
      logger.e(
        'Google sign-in failed with FirebaseAuthException: ${e.code}',
        error: e,
      );
      return Result.error(
        error: GoogleAuthExceptionHandler.handleFirebaseAuthException(e),
      );
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Google signIn');

      return Result.error(
        error: GoogleAuthExceptionHandler.handleUnknownException(e),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Google signOut');
    }
  }
}

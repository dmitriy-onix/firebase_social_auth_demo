import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/operation_status.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/auth/firebase_auth_exception_handler.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/firebase_credentials.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get emailVerified => _auth.currentUser?.emailVerified ?? false;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Send Email Verification');
    }
  }

  Future<Result<User>> signIn(FirebaseCredentials cred) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: cred.email,
        password: cred.password,
      );
      return Result.ok(userCred.user!);
    } on FirebaseAuthException catch (e) {
      final failure = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.e(failure.message);
      return Result.error(error: failure);
    } catch (e) {
      logger.e(e);
      return _generateUnknownFailure<User>();
    }
  }

  Future<Result<User>> signUp(FirebaseCredentials cred) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: cred.email,
        password: cred.password,
      );
      final user = newUser.user!;
      await sendEmailVerification();
      return Result.ok(user);
    } on FirebaseAuthException catch (e) {
      final failure = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.e(failure.message);
      return Result.error(error: failure);
    } catch (e) {
      logger.e(e);
      return _generateUnknownFailure<User>();
    }
  }

  Future<Result<OperationStatus>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return Result.ok(OperationStatus.success);
    } on FirebaseAuthException catch (e) {
      final failure = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.e(failure.message);
      return Result.error(error: failure);
    } catch (e) {
      logger.e(e);
      return _generateUnknownFailure<OperationStatus>();
    }
  }

  Result<T> _generateUnknownFailure<T>() {
    final failure = FirebaseAuthExceptionHandler.generateUnknownFailure();
    return Result<T>.error(error: failure);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/operation_status.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/data/source/remote/firebase/firebase_auth_exception_handler.dart';
import 'package:firebase_social_auth_demo/data/source/remote/firebase/firebase_auth_source.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/firebase_credentials.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/firebase_auth_failure.dart';


class FirebaseAuthSourceImpl extends FirebaseAuthSource {
  final FirebaseAuth _client;

  FirebaseAuthSourceImpl(this._client);

  @override
  Future<Result<User>> signIn(FirebaseCredentials credentials) async {
    return _makeAuthCall(
      _client.signInWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      ),
    );
  }

  @override
  Future<Result<User>> signUp(FirebaseCredentials credentials) async {
    return _makeAuthCall(
      _client.createUserWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      ),
    );
  }

  @override
  Future<Result<OperationStatus>> signOut() async {
    try {
      await _client.signOut();
      return Result.ok(OperationStatus.success);
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Firebase signOut');

      return Result.error(
        error: FirebaseAuthFailure(
          FirebaseAuthFailureType.logoutFailed,
          message: FirebaseAuthExceptionHandler.generateErrorMessage(
            FirebaseAuthFailureType.logoutFailed,
          ),
        ),
      );
    }
  }

  @override
  String getUserUID() => _client.currentUser?.uid ?? '';

  @override
  bool isAuthenticated() => _client.currentUser != null;

  @override
  Future<Result<OperationStatus>> resetPassword(String email) async {
    try {
      await _client.sendPasswordResetEmail(email: email);
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

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _client.currentUser?.sendEmailVerification();
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Send Email Verification');
    }
  }

  Future<Result<User>> _makeAuthCall(
    Future<UserCredential> authFunction,
  ) async {
    try {
      final credential = await authFunction;
      final user = credential.user;
      if (user != null) {
        return Result.ok(user);
      } else {
        return Result.error(
          error: FirebaseAuthFailure(
            FirebaseAuthFailureType.userNotFound,
            message: FirebaseAuthExceptionHandler.generateErrorMessage(
              FirebaseAuthFailureType.userNotFound,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      final failure = FirebaseAuthExceptionHandler.handleAuthException(e);
      logger.e(failure.message);
      return Result.error(error: failure);
    } catch (e) {
      logger.e(e);
      return _generateUnknownFailure<User>();
    }
  }

  Result<T> _generateUnknownFailure<T>() {
    final failure = FirebaseAuthExceptionHandler.generateUnknownFailure();
    return Result<T>.error(error: failure);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_social_auth_demo/arch/domain/entity/common/result.dart';
import 'package:firebase_social_auth_demo/arch/logger/app_logger_impl.dart';
import 'package:firebase_social_auth_demo/auth/auth_service_factory.dart';
import 'package:firebase_social_auth_demo/data/repository/auth_method_repository.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/auth_method.dart';
import 'package:firebase_social_auth_demo/domain/entity/exceptions/social_auth_failure.dart';

class SocialAuthService {
  final AuthServiceFactory _factory;
  final FirebaseAuth _firebaseAuth;
  final AuthMethodRepository _authMethodRepository;

  SocialAuthService({
    required AuthMethodRepository authMethodRepository,
    AuthServiceFactory? factory,
    FirebaseAuth? firebaseAuth,
  }) : _factory = factory ?? AuthServiceFactory(),
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _authMethodRepository = authMethodRepository;

  Future<Result<String>> signIn(SocialAuthMethod method) async {
    final service = _factory.getAuthService(method);
    final result = await service.signIn();

    return result.fold(
      (userCredential) async {
        final tokenResult = await userCredential.user?.getIdTokenResult();
        final token = tokenResult?.token;
        if (token != null) {
          logger.i('Social sign in successful. Token acquired.');
          await _authMethodRepository.saveAuthMethod(method);
          return Result.ok(token);
        } else {
          logger.e('Social sign in successful, but failed to get ID token.');
          return Result.error(
            error: SocialAuthFailure(
              SocialAuthFailureType.unknown,
              message: 'Social sign in successful, but failed to get ID token.',
            ),
          );
        }
      },
      (error) {
        logger.e('Social sign in failed: ${error.error}');
        return Result.error(error: error.error);
      },
    );
  }

  bool _isUserLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> signOut() async {
    try {
      if (_isUserLoggedIn()) {
        final method = await _authMethodRepository.getAuthMethod();
        if (method != null) {
          final service = _factory.getAuthService(method);
          await service.signOut();
          await _authMethodRepository.clearAuthMethod();
        } else {
          await _firebaseAuth.signOut();
        }
      }
    } catch (e, s) {
      logger.crash(error: e, stackTrace: s, reason: 'Social signOut');
    }
  }

  bool isSocialAuth() {
    return _firebaseAuth.currentUser != null;
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;
}

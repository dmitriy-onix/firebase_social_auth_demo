import 'package:firebase_social_auth_demo/data/repository/auth_method_repository.dart';
import 'package:firebase_social_auth_demo/data/source/preferences_source/preferences_source.dart';
import 'package:firebase_social_auth_demo/domain/entity/auth/auth_method.dart';


class AuthMethodRepositoryImpl implements AuthMethodRepository {
  final PreferencesSource _preferencesSource;

  AuthMethodRepositoryImpl(this._preferencesSource);

  @override
  Future<void> saveAuthMethod(SocialAuthMethod method) async {
    await _preferencesSource.saveAuthMethod(method.name);
  }

  @override
  Future<SocialAuthMethod?> getAuthMethod() async {
    final methodName = await _preferencesSource.getAuthMethod();
    if (methodName.isNotEmpty) {
      try {
        return SocialAuthMethod.values.byName(methodName);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearAuthMethod() async {
    await _preferencesSource.clearAuthMethod();
  }
}

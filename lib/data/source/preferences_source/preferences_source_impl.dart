import 'package:firebase_social_auth_demo/arch/data/local/prefs/shared_preferences_storage.dart';
import 'package:firebase_social_auth_demo/data/source/preferences_source/preferences_keys.dart';
import 'package:firebase_social_auth_demo/data/source/preferences_source/preferences_source.dart';

class PreferencesSourceImpl implements PreferencesSource {
  final SharedPreferencesStorage _preferences;

  PreferencesSourceImpl(this._preferences);

  @override
  Future<void> clearAuthMethod() async {
    final isContains = await _preferences.contains(PrefsKeys.kAuthMethodKey);
    if (isContains) {
      _preferences.remove(PrefsKeys.kAuthMethodKey);
    }
  }

  @override
  Future<String> getAuthMethod() {
    return _preferences.get<String>(PrefsKeys.kAuthMethodKey, '');
  }

  @override
  Future<void> saveAuthMethod(String value) async {
    await _preferences.put<String>(PrefsKeys.kAuthMethodKey, value);
  }
}

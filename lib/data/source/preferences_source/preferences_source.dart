abstract class PreferencesSource {
  Future<String> getAuthMethod();

  Future<void> saveAuthMethod(String value);

  Future<void> clearAuthMethod();
}

import 'package:firebase_social_auth_demo/arch/data/local/base/key_value_reloadable_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage
    extends KeyValueReloadableStorage<SharedPreferences> {
  @override
  Future<SharedPreferences> create() => SharedPreferences.getInstance();

  @override
  Future<K> get<K>(String key, K defaultValue) async {
    final s = await storage();
    K? result;

    switch (defaultValue.runtimeType) {
      case const (String):
        result = s.getString(key) as K?;
      case const (bool):
        result = s.getBool(key) as K?;
      case const (int):
        result = s.getInt(key) as K?;
      case const (double):
        result = s.getDouble(key) as K?;
      case const (List<String>):
        result = s.getStringList(key) as K?;
    }
    return result ?? defaultValue;
  }

  @override
  Future<void> put<K>(String key, K value) async {
    final prefs = await storage();
    switch (value.runtimeType) {
      case const (String):
        await prefs.setString(key, value as String);
      case const (bool):
        await prefs.setBool(key, value as bool);
      case const (double):
        await prefs.setDouble(key, value as double);
      case const (int):
        await prefs.setInt(key, value as int);
      case const (List<String>):
        await prefs.setStringList(key, value as List<String>);
    }
  }

  @override
  Future<void> clear() async {
    final prefs = await storage();
    await prefs.clear();
  }

  @override
  Future<void> reload() async {
    final prefs = await storage();
    await prefs.reload();
  }

  @override
  Future<bool> remove(String key) async {
    final prefs = await storage();
    return prefs.remove(key);
  }

  @override
  Future<bool> contains(String key) async {
    final prefs = await storage();
    return prefs.containsKey(key);
  }
}

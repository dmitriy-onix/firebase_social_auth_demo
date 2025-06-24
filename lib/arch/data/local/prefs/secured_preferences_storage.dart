import 'package:firebase_social_auth_demo/arch/data/local/base/key_value_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredPreferencesStorage extends KeyValueStorage<FlutterSecureStorage> {
  @override
  Future<FlutterSecureStorage> create() async => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @override
  Future<K> get<K>(String key, K defaultValue) async {
    final s = await storage();
    final value = await s.read(key: key);
    return (value ?? '') as K;
  }

  @override
  Future<void> put<K>(String key, K value) async {
    final s = await storage();
    await s.write(key: key, value: value as String);
  }

  @override
  Future<void> clear() async {
    final s = await storage();
    await s.deleteAll();
  }

  @override
  Future<bool> remove(String key) async {
    final s = await storage();
    await s.delete(key: key);
    return true;
  }

  @override
  Future<bool> contains(String key) async {
    final s = await storage();
    return s.containsKey(key: key);
  }
}

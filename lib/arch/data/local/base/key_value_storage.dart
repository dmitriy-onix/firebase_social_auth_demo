import 'package:flutter/foundation.dart';

abstract class KeyValueStorage<T> {
  T? _storage;

  @protected
  Future<T> storage() async {
    if (_storage != null) {
      return _storage!;
    }
    final newStorage = await create();
    _storage = newStorage;
    return newStorage;
  }

  @protected
  Future<T> create();

  Future<K> get<K>(String key, K defaultValue);

  Future<void> put<K>(String key, K value);

  Future<void> clear();

  Future<bool> remove(String key);

  Future<bool> contains(String key);
}

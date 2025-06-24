
import 'package:firebase_social_auth_demo/arch/data/local/base/key_value_storage.dart';

abstract class KeyValueReloadableStorage<T> extends KeyValueStorage<T> {
  Future<void> reload();
}

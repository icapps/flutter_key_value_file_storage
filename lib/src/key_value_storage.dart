import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synchronized/synchronized.dart';

class KeyValueStorage {
  static const _keysStorageDelimiter = ',';
  final FlutterSecureStorage _storage;
  final _keysLock = Lock();
  final String keysStorageKey;

  KeyValueStorage(
    this._storage, {
    required this.keysStorageKey,
  });

  Future<void> saveKeys(List<String> keys) {
    return _keysLock.synchronized(() async {
      if (keys.isEmpty) return _storage.delete(key: keysStorageKey);
      return _storage.write(
          key: keysStorageKey, value: keys.join(_keysStorageDelimiter));
    });
  }

  Future<List<String>> readKeys() async => _keysLock.synchronized(() async {
        final value = await _storage.read(key: keysStorageKey);
        if (value == null) return [];
        return value.split(_keysStorageDelimiter);
      });
}

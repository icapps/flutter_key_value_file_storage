import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synchronized/synchronized.dart';

class KeyValueStorage {
  static const _keysStorageKeyDefault = 'flutter_file_storage_keys';
  static const _keysStorageDelimiter = ',';
  final FlutterSecureStorage _storage;
  final _keysLock = Lock();
  late final String _keysStorageKey;

  KeyValueStorage(
    this._storage, {
    String? keysStorageKey,
  }) {
    _keysStorageKey = keysStorageKey ?? _keysStorageKeyDefault;
  }

  Future<void> saveKeys(List<String> keys) {
    return _keysLock.synchronized(() async {
      if (keys.isEmpty) return _storage.delete(key: _keysStorageKey);
      return _storage.write(key: _keysStorageKey, value: keys.join(_keysStorageDelimiter));
    });
  }

  Future<List<String>> readKeys() async => _keysLock.synchronized(() async {
        final value = await _storage.read(key: _keysStorageKey);
        if (value == null) return [];
        return value.split(_keysStorageDelimiter);
      });
}

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_key_value_file_storage/src/file_storage/documents_file_storage.dart';
import 'package:flutter_key_value_file_storage/src/file_storage/file_storage.dart';
import 'package:flutter_key_value_file_storage/src/key_value_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synchronized/synchronized.dart';

/// FlutterFileStorage storage allows you to save, read and delete files
/// The files are saved using the fileStorage
abstract class FileStorageManager {
  late final KeyValueStorage _keyValueStorage;
  late FileStorage fileStorage;
  final _locksLock = Lock();
  final Map<String, Lock> _locks = {};
  var _keys = <String>{};

  /// FlutterFileStorage will use
  ///   - storage to save the keys
  ///   - fileStorage to save, read, delete the file
  FileStorageManager(
    FlutterSecureStorage storage, {
    required String keysStorageKey,
    FileStorage? fileStorage,
  }) {
    _keyValueStorage = KeyValueStorage(storage, keysStorageKey: keysStorageKey);
    this.fileStorage = fileStorage ?? DocumentsFileStorage();
  }

  /// Encrypts the given [value] with the encryption key associated with [key]
  ///
  /// If the key was already in the storage, its associated value is changed.
  /// If the value is null, deletes associated value for the given [key].
  /// Supports String and Uint8List values.
  Future<void> write<T>({
    required String key,
    required T? value,
  }) async {
    assert(key.isNotEmpty, 'key must not be empty');
    await _synchronized(key, () async {
      if (value == null) return delete(key: key);
      assert(
          T == String || T == Uint8List, 'value must be String or Uint8List');
      final convertedValue = (value is String)
          ? Uint8List.fromList(utf8.encode(value))
          : value as Uint8List;
      await performWrite(key: key, value: convertedValue);
      await _getKeys();
      _keys.add(key);
      await _updateKeys();
    });
  }

  /// Returns the value for the given [key] or null if [key] is not in the storage.
  ///
  /// Supports String and Uint8List values.
  Future<T?> read<T>({required String key}) async {
    assert(key.isNotEmpty, 'key must not be empty');
    return _synchronized(key, () async {
      final result = await performRead(key: key);
      if (result == null) return null;
      if (T == String) return utf8.decode(result) as T;
      return result as T;
    });
  }

  /// Returns true if the storage contains the given [key].
  Future<bool> containsKey({
    required String key,
  }) async {
    assert(key.isNotEmpty, 'key must not be empty');
    return _synchronized(key, () async {
      await _getKeys();
      if (!_keys.contains(key)) return false;
      return performContainsKey(key: key);
    });
  }

  /// Deletes associated value for the given [key].
  ///
  /// All associated data for the given key is removed
  Future<void> delete({
    required String key,
  }) async {
    assert(key.isNotEmpty, 'key must not be empty');
    await _synchronized(key, () async {
      await performDelete(key: key);
      await _getKeys();
      _keys.remove(key);
      await _updateKeys();
    });
  }

  /// Returns all keys with associated values.
  Future<Set<String>> getAllKeys() async {
    await _getKeys();
    return _keys;
  }

  /// Deletes all keys with associated values.
  Future<void> deleteAll() async {
    await _getKeys();
    await Future.wait(_keys.map((key) => delete(key: key)));
    await _getKeys();
  }

  Future<void> _updateKeys() async {
    final encodedData = _keys.map((e) => base64Encode(utf8.encode(e))).toList();
    await _keyValueStorage.saveKeys(encodedData);
  }

  Future<void> _getKeys() async {
    final decodedData = await _keyValueStorage.readKeys();
    _keys = decodedData.map((e) => utf8.decode(base64Decode(e))).toSet();
  }

  Future<T> _synchronized<T>(
    String key,
    FutureOr<T> Function() computation,
  ) async {
    final lock = await _locksLock.synchronized(
        () => _locks.putIfAbsent(key, () => Lock(reentrant: true)));
    try {
      final result = await lock.synchronized(() => computation.call());
      await _locksLock
          .synchronized(() => _locks.removeWhere((_, value) => value == lock));
      return result;
    } finally {
      await _locksLock
          .synchronized(() => _locks.removeWhere((_, value) => value == lock));
    }
  }

  Future<void> performWrite({required String key, required Uint8List value});

  Future<Uint8List?> performRead({required String key});

  Future<bool> performContainsKey({required String key});

  Future<void> performDelete({required String key});
}

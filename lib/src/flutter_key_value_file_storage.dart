import 'dart:async';

import 'package:flutter_key_value_file_storage/src/file_storage_manager/file_storage_manager.dart';
import 'package:flutter_key_value_file_storage/src/file_storage/file_storage.dart';
import 'package:flutter_key_value_file_storage/src/file_storage_manager/flutter_file_storage_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// FlutterFileStorage storage allows you to save, read and delete files
/// The files are saved using the fileStorage but the content is always encrypted using: AES/GCM
class FlutterKeyValueFileStorage {
  late final FileStorageManager fileStorageManager;

  /// FlutterFileStorage will use
  ///   - storage to save the keys
  ///   - fileStorage to save, read, delete the file
  FlutterKeyValueFileStorage(
    FlutterSecureStorage storage, {
    FileStorage? fileStorage,
    String? keysStorageKey,
  }) {
    fileStorageManager = FlutterFileStorageManager(storage,
        fileStorage: fileStorage, keysStorageKey: keysStorageKey);
  }

  /// Saved the given [value] with [key]
  ///
  /// If the key was already in the storage, its associated value is changed.
  /// If the value is null, deletes associated value for the given [key].
  /// Supports String and Uint8List values.
  Future<void> write<T>({
    required String key,
    required T? value,
  }) async {
    await fileStorageManager.write<T>(key: key, value: value);
  }

  /// Returns the value for the given [key] or null if [key] is not in the storage.
  ///
  /// Supports String and Uint8List values.
  Future<T?> read<T>({required String key}) async {
    return fileStorageManager.read<T>(key: key);
  }

  /// Returns true if the storage contains the given [key].
  Future<bool> containsKey({
    required String key,
  }) async =>
      fileStorageManager.containsKey(key: key);

  /// Deletes associated value for the given [key].
  ///
  /// All associated data for the given key is removed
  Future<void> delete({
    required String key,
  }) async {
    await fileStorageManager.delete(key: key);
  }

  /// Returns all keys with associated values.
  Future<Set<String>> getAllKeys() async => fileStorageManager.getAllKeys();

  /// Deletes all keys with associated values.
  Future<void> deleteAll() async => fileStorageManager.deleteAll();
}

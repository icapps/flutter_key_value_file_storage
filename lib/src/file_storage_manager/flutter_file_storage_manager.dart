import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_file_storage/src/file_storage/file_storage.dart';
import 'package:flutter_file_storage/src/file_storage_manager/file_storage_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterFileStorageManager extends FileStorageManager {
  static const _keysStorageKeyDefault = 'flutter_file_storage_keys';

  FlutterFileStorageManager(
    FlutterSecureStorage storage, {
    FileStorage? fileStorage,
    String? keysStorageKey,
  }) : super(storage,
            fileStorage: fileStorage,
            keysStorageKey: keysStorageKey ?? _keysStorageKeyDefault);

  @override
  Future<void> performWrite(
      {required String key, required Uint8List value}) async {
    await fileStorage.write(_filename(key), value);
  }

  @override
  Future<Uint8List?> performRead({required String key}) async {
    return fileStorage.read(_filename(key));
  }

  @override
  Future<bool> performContainsKey({required String key}) =>
      fileStorage.exists(_filename(key));

  @override
  Future<void> performDelete({required String key}) async {
    await fileStorage.delete(_filename(key));
  }

  String _filename(String key) => base64Encode(utf8.encode(key));
}

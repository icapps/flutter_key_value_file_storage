import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_file_storage/src/file_storage/file_storage.dart';
import 'package:flutter_file_storage/src/file_storage_manager/file_storage_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterFileStorageManager extends FileStorageManager {
  FlutterFileStorageManager(
    FlutterSecureStorage storage, {
    FileStorage? fileStorage,
    String? keysStorageKey,
  }) : super(storage, fileStorage: fileStorage, keysStorageKey: keysStorageKey);

  @override
  Future<void> performWrite(
      {required String fileName, required Uint8List value}) async {
    await fileStorage.write(fileName, value);
  }

  @override
  Future<Uint8List?> performRead({required String fileName}) async {
    return fileStorage.read(fileName);
  }

  @override
  Future<bool> performContainsKey({required String fileName}) =>
      fileStorage.exists(fileName);

  @override
  Future<void> performDelete({required String fileName}) async {
    await fileStorage.delete(fileName);
  }

  @override
  Future<void> performDeleteAll(Set<String> keys) async {
    await Future.wait(keys.map((key) => delete(key: key)));
  }
}

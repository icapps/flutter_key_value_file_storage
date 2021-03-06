import 'package:flutter_key_value_file_storage/src/key_value_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'key_value_storage_test.mocks.dart';

@GenerateMocks([
  FlutterSecureStorage,
])
void main() {
  group('Test the write keys', () {
    test('Write empty list', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: ''))
          .thenAnswer((realInvocation) => Future.value());
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer((realInvocation) async => '');
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      await secureStorage.saveKeys([]);
      verify(mockSecureStorage.delete(
              key: 'flutter_key_value_file_storage_keys'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
    test('Empty text', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: ''))
          .thenAnswer((realInvocation) => Future.value());
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      await secureStorage.saveKeys(['']);
      verify(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: ''))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
    test('1 value', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: 'test'))
          .thenAnswer((realInvocation) => Future.value());
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      await secureStorage.saveKeys(['test']);
      verify(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: 'test'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
    test('2 values', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: 'test,test2'))
          .thenAnswer((realInvocation) => Future.value());
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      await secureStorage.saveKeys(['test', 'test2']);
      verify(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: 'test,test2'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
  });
  group('Test the read keys', () {
    test('Null value', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer((realInvocation) async => null);
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      final data = await secureStorage.readKeys();
      expect(data, <String>[]);
      verify(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
    test('Empty text', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer((realInvocation) async => '');
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      final data = await secureStorage.readKeys();
      expect(data, ['']);
      verify(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
    test('1 value', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer((realInvocation) async => 'test');
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      final data = await secureStorage.readKeys();
      expect(data, ['test']);
      verify(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
    test('2 values', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer(
              (realInvocation) async => 'sdalkjfia3924e,sdajlkfjal390u2');
      final secureStorage = KeyValueStorage(mockSecureStorage,
          keysStorageKey: 'flutter_key_value_file_storage_keys');
      final data = await secureStorage.readKeys();
      expect(data, ['sdalkjfia3924e', 'sdajlkfjal390u2']);
      verify(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);
    });
  });
}

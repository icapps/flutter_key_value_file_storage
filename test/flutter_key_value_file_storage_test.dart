import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_key_value_file_storage/flutter_key_value_file_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flutter_key_value_file_storage_test.mocks.dart';

@GenerateMocks([
  FlutterSecureStorage,
  FileStorage,
])
void main() {
  group('Test the FlutterFileStorage', () {
    test('Single write', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      final mockFileStorage = MockFileStorage();
      when(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: 'dGVzdA=='))
          .thenAnswer((realInvocation) => Future.value());
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer((realInvocation) async => null);
      when(mockFileStorage.write('dGVzdA==',
              Uint8List.fromList([99, 111, 110, 116, 101, 110, 116])))
          .thenAnswer((realInvocation) async => File('test_path'));
      final flutterSecureStorage =
          FlutterFileStorage(mockSecureStorage, fileStorage: mockFileStorage);
      await flutterSecureStorage.write(key: 'test', value: 'content');
      verify(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: 'dGVzdA=='))
          .called(1);
      verify(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);

      verify(mockFileStorage.write('dGVzdA==',
          Uint8List.fromList([99, 111, 110, 116, 101, 110, 116]))).called(1);
      verifyNoMoreInteractions(mockFileStorage);
    });
    test('2 writes', () async {
      final mockSecureStorage = MockFlutterSecureStorage();
      final mockFileStorage = MockFileStorage();
      when(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: ''))
          .thenAnswer((realInvocation) => Future.value());
      when(mockSecureStorage.read(key: 'test-key')).thenAnswer(
          (realInvocation) async => 'test-key123456789123456789123456');
      when(mockSecureStorage.read(key: 'test-iv'))
          .thenAnswer((realInvocation) async => 'test-iv123456789');
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer((realInvocation) async => null);
      when(mockFileStorage.write('dGVzdA==',
              Uint8List.fromList([99, 111, 110, 116, 101, 110, 116])))
          .thenAnswer((realInvocation) async => File('test_path'));
      final flutterFileStorage =
          FlutterFileStorage(mockSecureStorage, fileStorage: mockFileStorage);
      await flutterFileStorage.write(key: 'test', value: 'content');
      reset(mockFileStorage);
      reset(mockSecureStorage);

      when(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys', value: ''))
          .thenAnswer((realInvocation) => Future.value());
      when(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .thenAnswer((realInvocation) async => 'dGVzdA==');
      when(mockFileStorage.write('dGVzdDI=',
              Uint8List.fromList([99, 111, 110, 116, 101, 110, 116])))
          .thenAnswer((realInvocation) async => File('test_path'));

      await flutterFileStorage.write(key: 'test2', value: 'content');
      verify(mockSecureStorage.write(
              key: 'flutter_key_value_file_storage_keys',
              value: 'dGVzdA==,dGVzdDI='))
          .called(1);
      verify(mockSecureStorage.read(key: 'flutter_key_value_file_storage_keys'))
          .called(1);
      verifyNoMoreInteractions(mockSecureStorage);

      verify(mockFileStorage.write('dGVzdDI=',
          Uint8List.fromList([99, 111, 110, 116, 101, 110, 116]))).called(1);
      verifyNoMoreInteractions(mockFileStorage);
    });
  });
}

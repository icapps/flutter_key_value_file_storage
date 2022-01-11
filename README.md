# Flutter file storage

[![pub package](https://img.shields.io/pub/v/flutter_key_value_file_storage.svg)](https://pub.dartlang.org/packages/flutter_key_value_file_storage)

An implementation for flutter file storage. For example keychain has a soft limit of 4kb. Using the file system instead we can store much larger content.
## Usage

```dart
import 'package:flutter_key_value_file_storage/flutter_key_value_file_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
final storage = FlutterFileStorage(FlutterSecureStorage());

// Read value
final value = await storage.read<String>(key: key);

// Read all values
Map<String, String> allValues = await storage.readAll();

// Delete value
await storage.delete(key: key);

// Delete all
await storage.deleteAll();

// Write value
await storage.write(key: key, value: value);
```
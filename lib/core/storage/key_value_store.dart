import 'package:get_storage/get_storage.dart';

/// Minimal persistence contract for non-sensitive data.
///
/// The interface exists for one concrete reason: tests swap in
/// [InMemoryKeyValueStore] instead of touching the disk. Anything secret goes
/// through `SecureStorage`, never here.
abstract interface class KeyValueStore {
  T? read<T>(String key);

  Future<void> write<T>(String key, T value);

  Future<void> remove(String key);

  Future<void> clear();

  bool contains(String key);
}

/// Default implementation backed by `get_storage`.
class GetStorageAdapter implements KeyValueStore {
  GetStorageAdapter([GetStorage? box]) : _box = box ?? GetStorage();

  final GetStorage _box;

  /// Must be awaited once, before the container is used.
  static Future<void> init() => GetStorage.init();

  @override
  T? read<T>(String key) => _box.read<T>(key);

  @override
  Future<void> write<T>(String key, T value) => _box.write(key, value);

  @override
  Future<void> remove(String key) => _box.remove(key);

  @override
  Future<void> clear() => _box.erase();

  @override
  bool contains(String key) => _box.hasData(key);
}

/// Test double — no I/O, no async setup.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, Object?> _data = {};

  Map<String, Object?> get entries => Map.unmodifiable(_data);

  @override
  T? read<T>(String key) => _data[key] as T?;

  @override
  Future<void> write<T>(String key, T value) async => _data[key] = value;

  @override
  Future<void> remove(String key) async => _data.remove(key);

  @override
  Future<void> clear() async => _data.clear();

  @override
  bool contains(String key) => _data.containsKey(key);
}

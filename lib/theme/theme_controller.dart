import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/storage_keys.dart';
import '../core/storage/key_value_store.dart';

/// Owns the active [ThemeMode] and persists the user's choice.
///
/// Storage is injected rather than reached for globally, so tests can drive it
/// with `InMemoryKeyValueStore` and no disk access.
class ThemeController extends GetxController {
  ThemeController(this._store);

  final KeyValueStore _store;

  late final Rx<ThemeMode> _mode = Rx<ThemeMode>(_readStoredMode());

  ThemeMode get mode => _mode.value;

  /// True only when dark is explicitly selected — "system" is reported by
  /// [isPlatformDark] instead.
  bool get isDark => _mode.value == ThemeMode.dark;

  bool isPlatformDark(BuildContext context) => switch (_mode.value) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark,
  };

  Future<void> setMode(ThemeMode mode) async {
    if (_mode.value == mode) return;
    _mode.value = mode;
    Get.changeThemeMode(mode);
    await _store.write(StorageKeys.themeMode, mode.name);
  }

  /// Convenience for a single switch: system → light → dark → system.
  Future<void> toggle() => setMode(switch (_mode.value) {
    ThemeMode.system => ThemeMode.light,
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.system,
  });

  ThemeMode _readStoredMode() {
    final stored = _store.read<String>(StorageKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }
}

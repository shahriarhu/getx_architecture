import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../core/constants/storage_keys.dart';
import '../core/storage/key_value_store.dart';

/// A language the app ships with.
@immutable
class AppLocale {
  const AppLocale({
    required this.locale,
    required this.name,
    required this.nativeName,
  });

  final Locale locale;

  /// English name, for developer-facing surfaces.
  final String name;

  /// The language's own name — always what a user sees in a language picker.
  final String nativeName;

  String get code => locale.languageCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppLocale && other.locale == locale;

  @override
  int get hashCode => locale.hashCode;
}

/// Owns the active language and persists the choice.
class LocaleController extends GetxController {
  LocaleController(this._store);

  final KeyValueStore _store;

  static const english = AppLocale(
    locale: Locale('en', 'US'),
    name: 'English',
    nativeName: 'English',
  );

  static const bangla = AppLocale(
    locale: Locale('bn', 'BD'),
    name: 'Bangla',
    nativeName: 'বাংলা',
  );

  /// Add a language here and in `AppTranslations.keys` — nothing else changes.
  static const supported = <AppLocale>[english, bangla];

  static List<Locale> get supportedLocales =>
      supported.map((l) => l.locale).toList(growable: false);

  static const fallback = english;

  late final Rx<AppLocale> _current = Rx<AppLocale>(_readStoredLocale());

  AppLocale get current => _current.value;

  Locale get locale => _current.value.locale;

  Future<void> setLocale(AppLocale value) async {
    if (_current.value == value) return;
    _current.value = value;
    await Get.updateLocale(value.locale);
    await _store.write(StorageKeys.localeCode, value.code);
  }

  /// Resolves, in order: saved choice → device language → fallback.
  AppLocale _readStoredLocale() {
    final saved = _store.read<String>(StorageKeys.localeCode);
    if (saved != null) {
      final match = supported.where((l) => l.code == saved);
      if (match.isNotEmpty) return match.first;
    }

    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    final device = supported.where((l) => l.code == deviceCode);
    return device.isNotEmpty ? device.first : fallback;
  }
}

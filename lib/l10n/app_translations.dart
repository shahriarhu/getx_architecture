import 'package:get/get.dart';

import 'locales/bn_bd.dart';
import 'locales/en_us.dart';

/// Wires the locale maps into GetX.
///
/// The map keys must equal `Locale.toString()` (`en_US`, not `en_us`),
/// otherwise GetX silently falls through and renders raw keys.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'bn_BD': bnBD};
}

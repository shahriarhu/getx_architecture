import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:getx_architecture/app/translations/bd_bn.dart';
import 'package:getx_architecture/app/translations/en_us.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_us': enUs,
        'bd_bn': bdBn,
      };
}

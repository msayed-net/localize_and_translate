import 'package:localize_and_translate/src/core/localize_and_translate.dart';

/// [DBKeys] is a singleton class that contains all the keys used in the database.
class DBKeys {
  /// [DBKeys] constructor
  factory DBKeys() => _appTranslator;
  DBKeys._internal();
  static final DBKeys _appTranslator = DBKeys._internal();

  /// [boxName] is the name of the box.
  static const String boxName = 'localize_and_translate_config_box';

  /// [languageCode] is the key for the language code.
  static const String languageCode = 'language_code';

  /// [countryCode] is the key for the country code.
  static const String countryCode = 'country_code';

  /// [isRTL] is the key for the isRTL.
  static const String isRTL = 'is_rtl';

  /// [locales] is the key for the isRTL.
  static const String locales = 'locales';

  /// [hivePath] is the path of the hive database.
  static const String hivePath = 'localize_and_translate_hive_db_path';

  /// [appendPrefix] is the prefix for the translations.
  static String appendPrefix(String key) {
    return 'tr__${LocalizeAndTranslate.getLanguageCode()}_${LocalizeAndTranslate.getCountryCode()}_$key';
  }

  /// [appendPrefix] is the prefix for the translations.
  static String buildPrefix({
    required String key,
    required String languageCode,
    required String? countryCode,
  }) {
    return 'tr__${languageCode}_${countryCode ?? ''}_$key';
  }
}

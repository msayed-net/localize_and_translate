import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:localize_and_translate/src/assets/asset_loader_base.dart';
import 'package:localize_and_translate/src/constants/db_keys.dart';
import 'package:localize_and_translate/src/constants/enums.dart';
import 'package:localize_and_translate/src/db/box.dart';
import 'package:localize_and_translate/src/db/usecases.dart';
import 'package:localize_and_translate/src/exceptions/not_found_exception.dart';

/// [LocalizeAndTranslate] is the main class of the package.
/// It is used to initialize the package and to translate the words.
/// It is a singleton class.
/// It is used as follows:
/// ```dart
class LocalizeAndTranslate {
  /// [LocalizeAndTranslate] constructor
  factory LocalizeAndTranslate() => _appTranslator;
  LocalizeAndTranslate._internal() {
    debugPrint('--LocalizeAndTranslate-- (Instance Created --> Singleton)');
  }
  static final LocalizeAndTranslate _appTranslator = LocalizeAndTranslate._internal();

  ///---
  /// ### setLocale
  /// ---
  static Future<void> setLocale(Locale locale) async {
    await DBUseCases.write(DBKeys.languageCode, locale.languageCode);

    await DBUseCases.write(DBKeys.countryCode, locale.countryCode ?? '');

    await DBUseCases.write(
      DBKeys.isRTL,
      intl.Bidi.isRtlLanguage(locale.languageCode) ? 'true' : 'false',
    );
  }

  ///---
  /// ### setLanguageCode
  /// ---
  static Future<void> setLanguageCode(String languageCode) async {
    await DBUseCases.write(DBKeys.languageCode, languageCode);

    await DBUseCases.write(DBKeys.countryCode, '');

    await DBUseCases.write(
      DBKeys.isRTL,
      intl.Bidi.isRtlLanguage(languageCode) ? 'true' : 'false',
    );
  }

  ///---
  /// ###  Returns app locales.
  ///
  /// used in app entry point e.g. MaterialApp()
  /// ---
  static List<Locale> getLocals() {
    return DBUseCases.localesFromDBString(
      DBUseCases.read(DBKeys.locales) ?? '',
    );
  }

  ///---
  /// ###  Sets app locales.
  /// It takes the list of locales.
  /// It saves the list of locales to the database.
  /// ---
  static Future<void> setLocales(List<Locale> locales) async {
    await DBUseCases.write(
      DBKeys.locales,
      DBUseCases.dbStringFromLocales(locales),
    );
  }

  /// ---
  /// ###  Ensures that the package is initialized.
  /// ---
  static Future<void> writeSettings({
    List<Locale>? supportedLocales,
    List<String>? supportedLanguageCodes,
    LocalizationDefaultType? type = LocalizationDefaultType.device,
  }) async {
    await DBBox.openBox();

    final locales = supportedLocales ?? supportedLanguageCodes?.map(Locale.new).toList();

    if (locales == null) {
      throw NotFoundException('Locales not provided');
    }

    await setLocales(locales);

    if (type == LocalizationDefaultType.device) {
      await setLanguageCode(
        intl.Intl.getCurrentLocale(),
      );
      return;
    } else if (locales.isNotEmpty) {
      await setLocale(locales.first);
    }

    // Todo: save translations to db
  }

  /// ---
  /// ###  Writes translations to the database.
  /// ---
  static Future<void> writeTranslations({
    required Map<String, dynamic> data,
  }) async {
    await DBUseCases.writeMap(
      data.map((key, value) {
        return MapEntry(
          DBKeys.trPrefix(getLanguageCode(), getCountryCode()) + key,
          value.toString(),
        );
      }),
    );
  }

  /// ---
  /// ###  Ensures that the package is initialized.
  /// ---
  static Future<void> ensureInitialized({
    required AssetLoaderBase assetLoader,
    List<Locale>? supportedLocales,
    List<String>? supportedLanguageCodes,
    LocalizationDefaultType defaultType = LocalizationDefaultType.device,
  }) async {
    await DBBox.openBox();

    await writeSettings(
      supportedLocales: supportedLocales,
      supportedLanguageCodes: supportedLanguageCodes,
      type: defaultType,
    );

    final translations = await assetLoader.load();

    await writeTranslations(data: translations);
  }

  /// ---
  /// ###  Returns Locale
  /// ---
  static Locale getLocale() {
    return Locale(
      getLanguageCode(),
      getCountryCode(),
    );
  }

  /// ---
  /// ###  Returns language code
  /// ---
  static String getCountryCode() {
    final langCode = DBUseCases.read(DBKeys.countryCode);

    if (langCode == null) {
      throw NotFoundException('Country code not found');
    }

    return langCode;
  }

  /// ---
  /// ###  Returns language code
  /// ---
  static String getLanguageCode() {
    final langCode = DBUseCases.read(DBKeys.languageCode);

    if (langCode == null) {
      throw NotFoundException('Language code not found');
    }

    return langCode;
  }

  /// ---
  /// ###  Returns boolean value for isRTL
  /// ---
  static bool isRTL() {
    return DBUseCases.read(DBKeys.isRTL) == 'true';
  }

  /// ---
  /// ###  Returns translated string
  ///
  /// It takes the key and the default value.
  /// It returns the translated string.
  /// If the key is not found, it returns the default value.
  ///
  /// ---
  static String translate(String key, {String? defaultValue}) {
    final dbKey = DBUseCases.read(
      DBKeys.trPrefix(getLanguageCode(), getCountryCode()) + key,
    );

    if (dbKey == null) {
      return defaultValue ?? key;
    }

    return DBUseCases.read(dbKey) ?? defaultValue ?? key;
  }

  ///---
  /// ###  Returns app delegates.
  ///
  /// used in app entry point e.g. MaterialApp()
  /// ---
  static Iterable<LocalizationsDelegate<dynamic>> get delegates => <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ];
}

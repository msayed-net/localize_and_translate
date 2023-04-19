import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'translations.dart';

class LocalizeAndTranslateController extends ChangeNotifier {
  LocalizeAndTranslateController({
    required List<Locale> supportedLocales,
    required this.useFallbackTranslations,
    required this.saveLocale,
    required this.assetLoader,
    required this.path,
    required this.useOnlyLangCode,
    required this.onLoadError,
    Locale? startLocale,
    Locale? fallbackLocale,
    Locale? forceLocale, // used for testing
  }) {
    _fallbackLocale = fallbackLocale;
    if (forceLocale != null) {
      _locale = forceLocale;
    } else if (_savedLocale == null && startLocale != null) {
      _locale = _getFallbackLocale(supportedLocales, startLocale);
      developer.log('Start locale loaded $_locale');
    }
    // If saved locale then get
    else if (saveLocale && _savedLocale != null) {
      developer.log('Saved locale loaded $_savedLocale');
      _locale = selectLocaleFrom(
        supportedLocales,
        _savedLocale!,
        fallbackLocale: fallbackLocale,
      );
    } else {
      // From Device Locale
      _locale = selectLocaleFrom(
        supportedLocales,
        _deviceLocale,
        fallbackLocale: fallbackLocale,
      );
    }
  }
  static Locale? _savedLocale;
  static late Locale _deviceLocale;

  late Locale _locale;
  Locale? _fallbackLocale;

  final Function(FlutterError e) onLoadError;
  // ignore: prefer_typing_uninitialized_variables
  final AssetLoader assetLoader;
  final String path;
  final bool useFallbackTranslations;
  final bool saveLocale;
  final bool useOnlyLangCode;
  Translations? _translations, _fallbackTranslations;
  Translations? get translations => _translations;
  Translations? get fallbackTranslations => _fallbackTranslations;

  @visibleForTesting
  static Locale selectLocaleFrom(
    List<Locale> supportedLocales,
    Locale deviceLocale, {
    Locale? fallbackLocale,
  }) {
    final Locale selectedLocale = supportedLocales.firstWhere(
      (Locale locale) => locale.supports(deviceLocale),
      orElse: () => _getFallbackLocale(supportedLocales, fallbackLocale),
    );
    return selectedLocale;
  }

  //Get fallback Locale
  static Locale _getFallbackLocale(List<Locale> supportedLocales, Locale? fallbackLocale) {
    //If fallbackLocale not set then return first from supportedLocales
    if (fallbackLocale != null) {
      return fallbackLocale;
    } else {
      return supportedLocales.first;
    }
  }

  Future<void> loadTranslations() async {
    Map<String, dynamic> data;
    try {
      data = Map<String, dynamic>.from(await loadTranslationData(_locale));
      _translations = Translations(data);
      if (useFallbackTranslations && _fallbackLocale != null) {
        Map<String, dynamic>? baseLangData;
        if (_locale.countryCode != null && _locale.countryCode!.isNotEmpty) {
          baseLangData = await loadBaseLangTranslationData(Locale(locale.languageCode));
        }
        data = Map<String, dynamic>.from(await loadTranslationData(_fallbackLocale!));
        if (baseLangData != null) {
          try {
            data.addAll(baseLangData);
          } on UnsupportedError {
            data = Map<String, dynamic>.of(data)..addAll(baseLangData);
          }
        }
        _fallbackTranslations = Translations(data);
      }
    } on FlutterError catch (e) {
      onLoadError(e);
    } catch (e) {
      onLoadError(FlutterError(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> loadBaseLangTranslationData(Locale locale) async {
    try {
      return await loadTranslationData(Locale(locale.languageCode));
    } on FlutterError catch (e) {
      // Disregard asset not found FlutterError when attempting to load base language fallback
      developer.log(e.message);
    }
    return null;
  }

  Future<Map<String, dynamic>> loadTranslationData(Locale locale) async {
    late Map<String, dynamic>? data;

    if (useOnlyLangCode) {
      data = await assetLoader.load(path, Locale(locale.languageCode));
    } else {
      data = await assetLoader.load(path, locale);
    }

    if (data == null) {
      return <String, dynamic>{};
    }

    return data;
  }

  Locale get locale => _locale;

  Future<void> setLocale(Locale l) async {
    _locale = l;
    await loadTranslations();
    notifyListeners();
    developer.log('Locale $locale changed');
    await _saveLocale(_locale);
  }

  Future<void> _saveLocale(Locale? locale) async {
    if (!saveLocale) {
      return;
    }

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('locale', locale.toString());
    developer.log('Locale $locale saved');
  }

  static Future<bool> init() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? strLocale = preferences.getString('locale');
    _savedLocale = strLocale?.toLocale();
    final String foundPlatformLocale = await findSystemLocale();
    _deviceLocale = foundPlatformLocale.toLocale();
    developer.log('Localization initialized');
    return true;
  }

  Future<void> deleteSaveLocale() async {
    _savedLocale = null;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('locale');
    developer.log('Saved locale deleted');
  }

  Locale get deviceLocale => _deviceLocale;

  Future<void> resetLocale() async {
    developer.log('Reset locale to platform locale $_deviceLocale');

    await setLocale(_deviceLocale);
  }
}

@visibleForTesting
extension LocaleExtension on Locale {
  bool supports(Locale locale) {
    if (this == locale) {
      return true;
    }
    if (languageCode != locale.languageCode) {
      return false;
    }
    if (countryCode != null && countryCode!.isNotEmpty && countryCode != locale.countryCode) {
      return false;
    }
    if (scriptCode != null && scriptCode != locale.scriptCode) {
      return false;
    }

    return true;
  }
}

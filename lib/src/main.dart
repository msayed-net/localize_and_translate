import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localize_and_translate.dart';

class LocalizeAndTranslate {
  // Thread Safe - Singleton
  factory LocalizeAndTranslate() => _appTranslator;
  LocalizeAndTranslate._internal() {
    debugPrint('--LocalizeAndTranslate-- (Instance Created --> Singleton)');
  }
  static final LocalizeAndTranslate _appTranslator = LocalizeAndTranslate._internal();

  // Config Vars
  LocalizationDefaultType? _localeType;
  List<String> _langList = <String>[];
  String? _assetsDir;
  Locale? _locale;
  dynamic _values;
  late SharedPreferences _prefs;

  ///---
  /// ###  init(LocalizationDefaultType.device, languagesList=["en", "ar"], assetsDirectory="assets/lang/")
  ///
  /// Initialize things
  ///---
  Future<void> init({
    LocalizationDefaultType? localeType,
    String? language,
    required List<String> languagesList,
    String? assetsDirectory,
    Map<String, String>? valuesAsMap, // Later
  }) async {
    _prefs = await SharedPreferences.getInstance();

    // --- assets directory --- //
    if (assetsDirectory != null && !assetsDirectory.endsWith('/')) {
      assetsDirectory = '$assetsDirectory/';
    }
    _assetsDir = assetsDirectory;

    // --- locale type --- //
    _localeType = localeType ?? LocalizationDefaultType.device;

    // --- language list --- //
    _langList = languagesList;

    if (language != null) {
      _locale = Locale(language);
    } else if (_prefs.getString('pActiveLanguageCode') != null) {
      _locale = Locale(_prefs.getString('pActiveLanguageCode')!, '');
    } else if (_localeType == LocalizationDefaultType.device) {
      if ('${window.locale}'.contains(RegExp('[-_]'))) {
        _locale = Locale('${window.locale}'.split(RegExp('[-_]'))[0]);
      } else {
        _locale = Locale('${window.locale}');
      }
    } else {
      _locale = Locale(_langList[0]);
    }

    if (_assetsDir == null && valuesAsMap == null) {
      assert(
        _assetsDir != null || valuesAsMap != null,
        '--You must define assetsDirectory or valuesAsMap',
      );
      return;
    }

    if (_assetsDir != null) {
      _assetsDir = assetsDirectory;
      _values = await initLanguage(_locale!.languageCode);
    } else {
      _values = valuesAsMap;
    }

    if (kDebugMode) {
      print(
        '--LocalizeAndTranslate-- LangList$_langList | Dir($_assetsDir) | Active(${_locale!.languageCode}.json)',
      );
    }
  }

  ///---
  /// Loads language Map<key, value>
  ///---
  Future<dynamic> initLanguage(String languageCode) async {
    final String filePath = '$_assetsDir$languageCode.json';
    final String contentString = await rootBundle.loadString(filePath);
    final dynamic data = json.decode(contentString);
    return data;
  }

  ///---
  /// ###  translate("cat")
  ///
  /// translates a word
  ///---
  @Deprecated(
    'Now tr() attached to String, e.g. "door".tr() will work, make sure you imported the package @ the working file',
  )
  String translate(String key, [Map<String, String>? arguments]) {
    String value = _values?[key]?.toString() ?? key;

    if (arguments != null) {
      for (final String key in arguments.keys) {
        value = value.replaceAll(key, arguments[key]!);
      }
      return value;
    }

    return value;
  }

  ///---
  /// ### setNewLanguage(context, newLanguage="en", restart=true, remember = true)
  ///
  /// changes active language
  ///---
  Future<void> setNewLanguage(
    BuildContext context, {
    required String newLanguage,
    bool remember = true,
  }) async {
    if (newLanguage == '') {
      newLanguage = _locale?.languageCode ?? _langList[0];
    }

    _locale = Locale(newLanguage, '');

    _values = await initLanguage(newLanguage);

    if (remember) {
      await _prefs.setString('pActiveLanguageCode', newLanguage);
    }

    applyChanges(context);
  }

  ///----
  /// ###  isDirectionRTL(BuildContext context)
  ///
  /// returns `true` if active language direction is TRL
  ///---
  bool isDirectionRTL(BuildContext context) => Directionality.of(context) == TextDirection.rtl;

  ///---
  /// ###  restart(BuildContext context)
  ///
  /// reloads the app
  ///---
  dynamic applyChanges(BuildContext context) => LocalizedApp.applyChanges(context);

  @Deprecated('Use `activeLanguageCode` instead')
  String get currentLanguage => _locale!.languageCode;

  ///---
  /// ###  Returns active language code as string
  ///---
  String get activeLanguageCode => _locale!.languageCode;

  @Deprecated('Use `activeLocale` instead')
  Locale get locale => _locale ?? Locale(_langList[0]);

  ///---
  /// ###  Returns active locale as Locale
  ///---
  Locale get activeLocale => _locale ?? Locale(_langList[0]);

  ///---
  /// ###  Returns app delegates.
  ///
  /// used in app entry point e.g. MaterialApp()
  /// ---
  Iterable<LocalizationsDelegate<dynamic>> get delegates => <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ];

  ///---
  /// ###  Returns app locales.
  ///
  /// used in app entry point e.g. MaterialApp()
  /// ---
  Iterable<Locale> locals() => _langList.map<Locale>((String lang) => Locale(lang, ''));
}

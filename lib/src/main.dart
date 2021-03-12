import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../localize_and_translate.dart';

class LocalizeAndTranslate {
  ///------------------------------------------------
  /// Config
  ///------------------------------------------------
  LocalizationDefaultType? _localeType;
  List<String> _langList = [];
  String? _assetsDir;
  String _apiKeyGoogle = '';
  Locale? _locale;
  Map<String, dynamic>? _values;
  SharedPreferences? _prefs;

  ///------------------------------------------------
  /// Initialize Plugin
  ///------------------------------------------------
  Future<Null> init({
    LocalizationDefaultType? localeDefault,
    String? language,
    required List<String> languagesList,
    String? assetsDirectory,
    Map<String, String>? valuesAsMap, // Later
    String? apiKeyGoogle,
    SharedPreferences? prefsInstance,
  }) async {
    // ---- Vars ---- //
    _assetsDir = assetsDirectory!.endsWith('/') ? '$assetsDirectory' : '$assetsDirectory/';
    _prefs = prefsInstance ?? await SharedPreferences.getInstance();
    _localeType = localeDefault ?? LocalizationDefaultType.device;
    _langList = languagesList;
    _apiKeyGoogle = apiKeyGoogle ?? '';
    _locale = language != null
        ? Locale(language)
        : _prefs!.getString('currentLang') != null
            ? Locale(_prefs!.getString('currentLang')!, "")
            : _localeType == LocalizationDefaultType.device
                ? '${window.locale}'.contains(RegExp('[-_]'))
                    ? Locale('${window.locale}'.split(RegExp('[-_]'))[0])
                    : Locale('${window.locale}')
                : Locale(_langList[0]);

    if (_assetsDir == null && valuesAsMap == null) {
      assert(
        _assetsDir != null || valuesAsMap != null,
        '--You must define _assetsDirectory or valuesAsMap',
      );
      return null;
    }

    if (_assetsDir != null) {
      _assetsDir = assetsDirectory;
      _values = await initLanguage(_locale!.languageCode);
    } else {
      _values = valuesAsMap;
    }

    print(
      '--LocalizeAndTranslate : Google(${apiKeyGoogle != null}) | LangList$_langList | Dir($_assetsDir) | Active(${_locale!.languageCode}.json)',
    );

    return null;
  }

  ///------------------------------------------------
  /// Initialize Active Language Values
  ///------------------------------------------------
  initLanguage(String languageCode) async {
    String filePath = "$_assetsDir$languageCode.json";
    String content = await rootBundle.loadString(filePath);
    return json.decode(content);
  }

  ///------------------------------------------------
  /// Transle : [key]
  ///------------------------------------------------
  String? translate(String key, [Map<String, String>? arguments]) {
    String? value = (_values == null || _values![key] == null) ? '$key' : _values![key];
    if (arguments == null) return value;
    for (var key in arguments.keys) {
      value = value!.replaceAll(key, arguments[key]!);
    }
    return value;
  }

  ///------------------------------------------------
  /// Google Translate
  /// --- will be removed, if you are using it feel free to notify package admin
  ///------------------------------------------------
  @deprecated
  Future<String?> translateWithGoogle({
    required String key,
    required String from,
    String? to,
  }) async {
    try {
      if (_apiKeyGoogle.isEmpty) {
        print('--LocalizeAndTranslate : Google(false)');
        return key;
      }

      if (to == null) to = _locale!.languageCode;

      var response = await http.post(
        Uri(path: 'https://translation.googleapis.com/language/translate/v2'),
        headers: {
          'Authorization': 'Bearer $_apiKeyGoogle',
        },
        body: {
          "q": key,
          "source": from,
          "target": to,
          "format": "text",
        },
      ).timeout(Duration(seconds: 10));

      var data = json.decode(response.body);

      String? text = key;
      if (response.statusCode == 200) {
        text = data['data']['translations']['translatedText'];
      } else {
        print('--LocalizeAndTranslate : $data');
      }

      return text;
    } catch (e) {
      return key;
    }
  }

  ///------------------------------------------------
  /// Change Language
  ///------------------------------------------------
  Future<Null> setNewLanguage(
    context, {
    required String newLanguage,
    bool restart = true,
    bool remember = true,
  }) async {
    if (newLanguage == "") {
      newLanguage = _locale?.languageCode ?? _langList[0];
    }

    _locale = Locale(newLanguage, "");

    String filePath = "$_assetsDir$newLanguage.json";
    String content = await rootBundle.loadString(filePath);

    _values = json.decode(content);

    if (remember) {
      SharedPreferences prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setString('currentLang', newLanguage);
    }

    if (restart) {
      LocalizedApp.restart(context);
    }

    return null;
  }

  ///------------------------------------------------
  /// Determine Active Layout (bool)
  ///------------------------------------------------
  isDirectionRTL(BuildContext context) => Directionality.of(context) == TextDirection.rtl;

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  restart(BuildContext context) => LocalizedApp.restart(context);

  ///------------------------------------------------
  /// Active Language Code (String)
  ///------------------------------------------------
  String get currentLanguage => _locale!.languageCode;

  ///------------------------------------------------
  /// Active Locale
  ///------------------------------------------------
  Locale get locale => _locale ?? Locale(_langList[0]);

  ///------------------------------------------------
  /// delegatess
  ///------------------------------------------------
  Iterable<LocalizationsDelegate> get delegates => [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ];

  ///------------------------------------------------
  /// Locals List
  ///------------------------------------------------
  Iterable<Locale> locals() => _langList.map<Locale>((lang) => new Locale(lang, ''));
}

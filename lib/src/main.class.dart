import 'dart:convert';

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:localize_and_translate/src/defaults.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizeAndTranslate {
  ///------------------------------------------------
  /// Config
  ///------------------------------------------------
  LocalizationDefaultType _localeType;
  List<String> langsList = [];
  String assetsDir;
  String _apiKeyGoogle = '';
  Locale _locale;
  Map<String, dynamic> _values;
  SharedPreferences prefs;

  ///------------------------------------------------
  /// Initialize Plugin
  ///------------------------------------------------
  Future<Null> init({
    LocalizationDefaultType localeDefault,
    String language,
    @required List<String> languagesList,
    @required assetsDirectory,
    Map<String, String> valuesAsMap, // Later
    String apiKeyGoogle,
  }) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    if (apiKeyGoogle != null) {
      _apiKeyGoogle = apiKeyGoogle;
    }

    if (!assetsDirectory.endsWith('/')) {
      assetsDirectory += '/';
    }

    // ---- Vars ---- //
    _localeType = localeDefault ?? LocalizationDefaultType.device;
    langsList = languagesList ?? ['en', 'ar'];

    // ---- Locale ---- //
    if (_locale == null) {
      if (language != null) {
        _locale = Locale(language);
      } else if (prefs.getString('currentLang') != null) {
        _locale = Locale(prefs.getString('currentLang'), "");
      } else {
        if (_localeType == LocalizationDefaultType.device) {
          String deviceLocale = await Devicelocale.currentLocale;
          if (deviceLocale.contains('-')) {
            deviceLocale = deviceLocale.split('-')[0];
          }
          if (deviceLocale.contains('_')) {
            deviceLocale = deviceLocale.split('_')[0];
          }
          print(
            '--LocalizeAndTranslate : deviceLocale($deviceLocale)',
          );
          _locale = Locale(deviceLocale);
        } else {
          _locale = Locale(langsList[0]);
        }
      }
    }

    if (assetsDirectory == null && valuesAsMap == null) {
      assert(
        assetsDirectory != null || valuesAsMap != null,
        '--You must define assetsDirectory or valuesAsMap',
      );
      return null;
    }

    if (assetsDirectory != null) {
      assetsDir = assetsDirectory;
      await initLanguage(_locale.languageCode);
    } else {
      _values = valuesAsMap;
    }

    print(
      '--LocalizeAndTranslate : Google(${apiKeyGoogle != null}) | LangList$langsList | Dir($assetsDir) | Active(${_locale.languageCode}.json)',
    );

    return null;
  }

  ///------------------------------------------------
  /// Initialize Active Language Values
  ///------------------------------------------------
  Future<Null> initLanguage(String languageCode) async {
    String content = await rootBundle.loadString(
      assetsDir + "$languageCode.json",
    );

    _values = json.decode(content);

    return null;
  }

  ///------------------------------------------------
  /// Transle : [key]
  ///------------------------------------------------
  String translate(String key, [Map<String, String> arguments]) {
    String value =
        (_values == null || _values[key] == null) ? '$key' : _values[key];
    if (arguments == null) return value;
    for (var key in arguments.keys) {
      value = value.replaceAll(key, arguments[key]);
    }
    return value;
  }

  ///------------------------------------------------
  /// Google Translate
  ///------------------------------------------------
  Future<String> translateWithGoogle({
    @required String key,
    @required String from,
    String to,
  }) async {
    try {
      if (_apiKeyGoogle.isEmpty) {
        print('--LocalizeAndTranslate : Google(false)');
        return key;
      }

      if (to == null) to = _locale.languageCode;

      var response = await http.post(
        'https://translation.googleapis.com/language/translate/v2',
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

      String text = key;
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
    @required String newLanguage,
    @required bool restart,
    bool remember = true,
  }) async {
    if (newLanguage == null || newLanguage == "") {
      newLanguage = _locale == null ? langsList[0] : _locale.languageCode;
    }

    _locale = Locale(newLanguage, "");

    String content = await rootBundle.loadString(
      assetsDir + "$newLanguage.json",
    );
    _values = json.decode(content);

    if (remember) {
      if (prefs == null) {
        prefs = await SharedPreferences.getInstance();
      }
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
  isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  restart(BuildContext context) {
    LocalizedApp.restart(context);
  }

  ///------------------------------------------------
  /// Active Language Code (String)
  ///------------------------------------------------
  String get currentLanguage => _locale.languageCode ?? langsList[0];

  ///------------------------------------------------
  /// Active Locale
  ///------------------------------------------------
  Locale get locale => _locale ?? Locale(langsList[0]);

  ///------------------------------------------------
  /// delegatess
  ///------------------------------------------------
  Iterable<LocalizationsDelegate> delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
  ];

  ///------------------------------------------------
  /// Locals List
  ///------------------------------------------------
  Iterable<Locale> locals() => langsList.map<Locale>(
        (lang) => new Locale(lang, ''),
      );
}

LocalizeAndTranslate translator = new LocalizeAndTranslate();

class LocalizedApp extends StatefulWidget {
  final Widget child;

  LocalizedApp({this.child});

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  static restart(BuildContext context) {
    final _LocalizedAppState state = context.findAncestorStateOfType();
    state.restart();
  }

  @override
  _LocalizedAppState createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  Key key = new UniqueKey();

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  void restart() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }
}

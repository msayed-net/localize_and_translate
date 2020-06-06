import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

List<String> LIST_OF_LANGS = [];
String LANGS_DIR;

class LocalizeAndTranslate with ChangeNotifier {
  // ---- Config ---- //
  Locale _locale;
  Map<dynamic, dynamic> _values;

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
  Iterable<Locale> locals() => LIST_OF_LANGS.map<Locale>(
        (lang) => new Locale(lang, ''),
      );

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
  /// Transle : [key] using Google Translate API
  ///------------------------------------------------
  // Future<String> googleTranslate(
  //   String key, {
  //   @required String from,
  //   @required String to,
  // }) async {
  //   try {
  //     final trans = new GoogleTranslator();
  //     String text = await trans.translate(key, from: from, to: to);
  //     return text ?? key;
  //   } catch (e) {
  //     return key;
  //   }
  // }

  ///------------------------------------------------
  /// Active Language Code (String)
  ///------------------------------------------------
  String get currentLanguage => _locale.languageCode ?? LIST_OF_LANGS[0];

  ///------------------------------------------------
  /// Active Locale
  ///------------------------------------------------
  Locale get locale => _locale ?? Locale(LIST_OF_LANGS[0]);

  ///------------------------------------------------
  /// Initialize Plugin
  ///------------------------------------------------
  Future<Null> init([String lang]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_locale == null) {
      if (prefs.getString('currentLang') != null) {
        _locale = Locale(prefs.getString('currentLang'), "");
      } else {
        _locale = Locale(LIST_OF_LANGS[0]);
      }
      await initLanguage();
    }
    return null;
  }

  ///------------------------------------------------
  /// Initialize Active Language
  ///------------------------------------------------
  Future<Null> initLanguage() async {
    if (_locale == null) {
      _locale = Locale(LIST_OF_LANGS[0]);
    }

    String content = await rootBundle.loadString(
      LANGS_DIR + "${_locale.languageCode}.json",
    );
    _values = json.decode(content);

    return null;
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
      newLanguage = _locale == null ? LIST_OF_LANGS[0] : _locale.languageCode;
    }

    _locale = Locale(newLanguage, "");

    String content = await rootBundle.loadString(
      LANGS_DIR + "$newLanguage.json",
    );
    _values = json.decode(content);

    if (remember) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentLang', newLanguage);
    }

    // if (restart) {
    //   LocalizedApp.restart(context);
    // }
    notifyListeners();
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
  // restart(BuildContext context) {
  //   LocalizedApp.restart(context);
  // }
}

LocalizeAndTranslate translator = new LocalizeAndTranslate();

class LocalizedApp extends StatefulWidget {
  final Widget child;

  LocalizedApp({this.child});

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  // static restart(BuildContext context) {
  //   final _LocalizedAppState state = context.findAncestorStateOfType();
  //   state.restart();
  // }

  @override
  _LocalizedAppState createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  Key key = new UniqueKey();

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  // void restart() {
  //   this.setState(() {
  //     key = new UniqueKey();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new ChangeNotifierProvider.value(
      value: translator,
      key: key,
      child: widget.child,
    );
  }
}

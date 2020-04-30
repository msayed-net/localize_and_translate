import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

List<String> LIST_OF_LANGS = [];
String LANGS_DIR;

class LocalizeAndTranslate {
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
  String translate(String key) {
    return (_values == null || _values[key] == null)
        ? '404 : $key'
        : _values[key];
  }

  ///------------------------------------------------
  /// Transle : [key]
  ///------------------------------------------------
  Future<String> googleTranslate(
    String key, {
    @required String from,
    @required String to,
  }) async {
    try {
      final trans = new GoogleTranslator();
      String text = await trans.translate(key, from: from, to: to);
      return text;
    } catch (e) {
      return key;
    }
  }

  get currentLanguage =>
      _locale == null ? LIST_OF_LANGS[0] : _locale.languageCode;
  get locale => _locale;

  Future<Null> init([String lang]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_locale == null) {
      if (prefs.getString('currentLang') != null) {
        _locale = Locale(prefs.getString('currentLang'), "");
      }
      await setNewLanguage(lang, restart: false);
    }
    return null;
  }

  Future<Null> setNewLanguage(
    context, {
    @required bool restart,
    String newLanguage,
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

    if (restart) {
      LocalizedApp.restart(context);
    }

    return null;
  }

  isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }

  restart(BuildContext context) {
    LocalizedApp.restart(context);
  }
}

LocalizeAndTranslate translator = new LocalizeAndTranslate();

class LocalizedApp extends StatefulWidget {
  final Widget child;

  LocalizedApp({this.child});

  static restart(BuildContext context) {
    final _LocalizedAppState state = context.findAncestorStateOfType();
    state.restart();
  }

  @override
  _LocalizedAppState createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  Key key = new UniqueKey();

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

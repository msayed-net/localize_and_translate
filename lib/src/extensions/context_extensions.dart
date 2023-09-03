import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

/// [ContextExtensions] is the extension class for the [BuildContext].
extension ContextExtensions on BuildContext {
  /// [locale] is the getter for the localization delegates.
  Locale get locale => Localizations.localeOf(this);

  /// [supportedLocales] is the getter for the supported locales.
  List<Locale> get supportedLocales => LocalizeAndTranslate.getLocals();

  /// [languageCode] is the getter for the language code.
  String get languageCode => locale.languageCode;

  /// [isRTL] is the getter for the right to left.
  bool get isRTL => LocalizeAndTranslate.isRTL();

  /// [delegates] is the getter for the localization delegates.
  Iterable<LocalizationsDelegate<dynamic>> get delegates => LocalizeAndTranslate.delegates;
}

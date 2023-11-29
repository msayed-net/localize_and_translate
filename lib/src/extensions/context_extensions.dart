import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

/// [ContextExtensions] is the extension class for the [BuildContext].
extension ContextExtensions on BuildContext {
  /// [locale] is the getter for the localization delegates.
  Locale get locale => LocalizeAndTranslate.getLocale();

  /// [supportedLocales] is the getter for the supported locales.
  List<Locale> get supportedLocales => LocalizeAndTranslate.getLocals();

  /// [languageCode] is the getter for the language code.
  String get languageCode => locale.languageCode;

  /// [isRTL] is the getter for the right to left.
  bool get isRTL => LocalizeAndTranslate.isRTL();

  /// [delegates] is the getter for the localization delegates.
  Iterable<LocalizationsDelegate<dynamic>> get delegates =>
      LocalizeAndTranslate.delegates;

  /// [setLocale] is the setter for the locale.
  void setLocale(Locale locale) => LocalizeAndTranslate.setLocale(locale);

  /// [setLanguageCode] is the setter for the language code.
  void setLanguageCode(String languageCode) =>
      LocalizeAndTranslate.setLanguageCode(languageCode);

  // /// [resetLocale] is the setter for the language code.
  // void resetLocale() => LocalizeAndTranslate.resetLocale();

  /// [countryCode] is the setter for the language code.
  void countryCode() => LocalizeAndTranslate.getCountryCode();
}

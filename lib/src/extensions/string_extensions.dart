import 'package:localize_and_translate/src/core/localize_and_translate.dart';

/// [Translation] is the extension of the [String] class.
extension Translation on String {
  /// [tr] is the extension method that translates the string.
  String tr({String? defaultValue}) => LocalizeAndTranslate.translate(
        this,
        defaultValue: defaultValue,
      );
}

import 'dart:ui';

import 'package:localize_and_translate/src/db/box.dart';

/// [DBUseCases] is a use case that localize and translate a text.
class DBUseCases {
  /// [DBUseCases] constructor
  const DBUseCases();

  /// [read] is used to retrieve a data from the database.
  static String read(String key) => DBBox.box.get(key) ?? key;

  /// [readNullable] is used to retrieve a data from the database.
  static String? readNullable(String key) => DBBox.box.get(key);

  /// [write] is used to write a data to the database.
  static Future<void> write(String key, String value) async {
    await DBBox.box.put(key, value);
  }

  /// [writeMap] is used to write a map to the database.
  static Future<void> writeMap(Map<String, String> map) async {
    await DBBox.box.putAll(map);
  }

  /// [delete] is used to delete a data from the database.
  static Future<void> delete(String key) async {
    await DBBox.box.delete(key);
  }

  /// [dbStringFromLocales]
  static String dbStringFromLocales(List<Locale> data) {
    return data
        .map((Locale e) => '[${e.languageCode},${e.countryCode}]')
        .join('===');
  }

  /// [localesFromDBString]
  static List<Locale> localesFromDBString(String data) {
    return data.split('===').map((String e) {
      final List<String> parts =
          e.replaceAll('[', '').replaceAll(']', '').split(',');
      return Locale(parts[0], parts[1]);
    }).toList();
  }
}

import 'package:hive/hive.dart';
import 'package:localize_and_translate/src/constants/db_keys.dart';

/// [DBBox] is the data source for the names of allah.
class DBBox {
  /// [DBBox] constructor
  factory DBBox() => _instance;
  DBBox._();
  static final DBBox _instance = DBBox._();

  static late Box<String> _box;

  /// [boxName] is the name of the box.
  static const String boxName = DBKeys.boxName;

  /// [box] is the getter for the box.
  static Box<String> get box => _box;

  /// [openBox] is used to open the box.
  static Future<void> openBox() async {
    _box = await Hive.openBox<String>(boxName);
  }
}

import 'package:localize_and_translate/localize_and_translate.dart';

extension Translation on String {
  String tr() => translator.translate(this);
}

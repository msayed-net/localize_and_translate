import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localize_and_translate/src/db/box.dart';

/// [LocalizeAndTranslateApp] is the widget that is used to localize the app.
class LocalizeAndTranslateApp extends StatefulWidget {
  /// [LocalizeAndTranslateApp] constructor
  const LocalizeAndTranslateApp({
    required this.child,
    super.key,
  });

  /// [child] is the child widget.
  final Widget child;

  @override
  State<LocalizeAndTranslateApp> createState() => _LocalizeAndTranslateAppState();
}

class _LocalizeAndTranslateAppState extends State<LocalizeAndTranslateApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: DBBox.box.listenable(),
      builder: (BuildContext context, Box<dynamic> box, Widget? child) {
        return widget.child;
      },
    );
  }
}

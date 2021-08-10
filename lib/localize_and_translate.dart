import 'package:flutter/material.dart';

import 'src/main.dart';

// Locale Types
enum LocalizationDefaultType { device, asDefined }

// Instance
LocalizeAndTranslate translator = new LocalizeAndTranslate();

class LocalizedApp extends StatefulWidget {
  final Widget? child;

  LocalizedApp({this.child});

  ///---
  /// Reloads the app
  ///---
  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_LocalizedAppState>()!.restart();
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

extension Translation on String {
  String tr() => translator.translate(this);
}

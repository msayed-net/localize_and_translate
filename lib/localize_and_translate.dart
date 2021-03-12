import 'package:flutter/material.dart';

import 'src/main.dart';

enum LocalizationDefaultType { device, asDefined }
LocalizeAndTranslate translator = new LocalizeAndTranslate();

class LocalizedApp extends StatefulWidget {
  final Widget? child;

  LocalizedApp({this.child});

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_LocalizedAppState>()!.restart();
  }

  @override
  _LocalizedAppState createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  Key key = new UniqueKey();

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
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

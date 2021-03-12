import 'package:flutter/material.dart';

class LocalizedApp extends StatefulWidget {
  final Widget child;

  LocalizedApp({this.child});

  ///------------------------------------------------
  /// Restart App
  ///------------------------------------------------
  static restart(BuildContext context) {
    final _LocalizedAppState state = context.findAncestorStateOfType();
    state.restart();
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

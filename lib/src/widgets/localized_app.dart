import 'package:flutter/material.dart';
import 'package:localize_and_translate/src/core/localize_and_translate.dart';

/// [LocalizedApp] is the widget that is used to localize the app.
class LocalizedApp extends StatefulWidget {
  /// [LocalizedApp] constructor
  const LocalizedApp({
    required this.child,
    super.key,
  });

  /// [child] is the child widget.
  final Widget child;

  @override
  State<LocalizedApp> createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  @override
  void initState() {
    LocalizeAndTranslate.notifyUI = _onLocaleChange;
    super.initState();
  }

  void _onLocaleChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (context as Element).visitChildren(_rebuildElement);
    });
  }

  void _rebuildElement(Element element) {
    element
      ..markNeedsBuild()
      ..visitChildren(_rebuildElement);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

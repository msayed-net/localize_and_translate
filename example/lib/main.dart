import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('print_color'),
        ),
        body: Center(
            child: OutlineButton(
          onPressed: () {
          },
          child: Text('Click Me For Magic'),
        )),
      ),
    );
  }
}
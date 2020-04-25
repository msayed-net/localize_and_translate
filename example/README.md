# localize_and_translate_example

```dart
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

Future<void> main() async {
  // if your flutter > 1.7.8 :  ensure flutter activated
  WidgetsFlutterBinding.ensureInitialized();

  LIST_OF_LANGS = ['ar', 'en']; // define languages
  LANGS_DIR = 'assets/langs/'; // define directory
  await translator.init(); // intialize

  runApp(
    LocalizedApp(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      localizationsDelegates: translator.delegates,
      locale: translator.locale,
      supportedLocales: translator.locals(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String testText =
      translator.currentLanguage == 'ar' ? 'جار الترجمة' : 'Translating..';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      translator.currentLanguage == 'ar'
          ? testText = await translator.googleTranslate(
              'This text translated using google translate',
              from: 'en',
              to: 'ar',
            )
          : testText = await translator.googleTranslate(
              'هذا النص ترجم باستخدام ترجمة جوجل',
              from: 'ar',
              to: 'en',
            );

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(translator.translate('appTitle')),
        // centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              translator.translate('textArea'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35),
            ),
            Text(
              testText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35),
            ),
            OutlineButton(
              onPressed: () {
                translator.setNewLanguage(
                  context,
                  newLanguage: translator.currentLanguage == 'ar' ? 'en' : 'ar',
                  remember: true,
                  restart: true,
                );
              },
              child: Text(translator.translate('buttonTitle')),
            ),
          ],
        ),
      ),
    );
  }
}

```
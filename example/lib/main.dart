import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'generated/locale_keys.g.dart';
import 'lang_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizeAndTranslate.ensureInitialized();

  runApp(LocalizeAndTranslate(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('ar', 'EG'),
      Locale('de', 'DE'),
      Locale('ru', 'RU'),
    ],
    path: 'assets/lang',
    child: const MyApp(),
    // fallbackLocale: Locale('en', 'US'),
    // startLocale: Locale('de', 'DE'),
    // saveLocale: false,
    // useOnlyLangCode: true,

    // optional assetLoader default used is RootBundleAssetLoader which uses flutter's assetloader
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Localize And Translate'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  bool _gender = true;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void switchGender(bool val) {
    setState(() {
      _gender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.title).tr(),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguageView(), fullscreenDialog: true),
              );
            },
            child: const Icon(
              Icons.language,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Text(
              LocaleKeys.gender_with_arg,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 19, fontWeight: FontWeight.bold),
            ).tr(
              args: <String>['ahmed'],
              gender: _gender ? 'female' : 'male',
            ),
            Text(
              tr(
                LocaleKeys.gender,
                gender: _gender ? 'female' : 'male',
              ),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.male),
                Switch(value: _gender, onChanged: switchGender),
                const Icon(Icons.female),
              ],
            ),
            const Spacer(),
            const Text(LocaleKeys.msg).tr(args: <String>['ahmed', 'Flutter']),
            const Text(LocaleKeys.msg_named).tr(
              namedArgs: <String, String>{'lang': 'Dart'},
              args: <String>['Localize And Translate'],
            ),
            const Text(LocaleKeys.clicked).plural(counter),
            TextButton(
              onPressed: () {
                incrementCounter();
              },
              child: const Text(LocaleKeys.clickMe).tr(),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
                plural(LocaleKeys.amount, counter,
                    format: NumberFormat.currency(locale: Intl.defaultLocale, symbol: '€')),
                style: TextStyle(color: Colors.grey.shade900, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.resetLocale();
              },
              child: const Text(LocaleKeys.reset_locale).tr(),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        child: const Text('+1'),
      ),
    );
  }
}

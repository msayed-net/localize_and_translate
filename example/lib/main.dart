import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

main() async {
  // if your flutter > 1.7.8 :  ensure flutter activated
  WidgetsFlutterBinding.ensureInitialized();

  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/lang/',
  );

  runApp(LocalizedApp(child: MyApp()));
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

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('appTitle'.tr()),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              'textArea'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35),
            ),
            Wrap(
              children: translator.locals().map((i) {
                return OutlinedButton(
                  onPressed: () {
                    translator.setNewLanguage(
                      context,
                      newLanguage: i.languageCode,
                      remember: true,
                      restart: true,
                    );
                  },
                  child: Text(i.languageCode),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

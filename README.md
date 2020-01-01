# localize_and_translate
localization and translation was never easier, simple way to translate your flutter apps and make it international


## Screenshots
<img src="screenshot1.png" alt="screenshot" width="200"/><span>  </span><img src="screenshot2.png" alt="screenshot" width="200"/>



## How To Use
1. add `localize_and_translate: ^<latest>` to pubspec.yaml dependencies.  
2. run `flutter pub get` into root dir of the app
3. add `import 'package:flutter_localizations/flutter_localizations.dart';` to use `GlobalMaterialLocalizations.delegate`
4. add `import 'package:localize_and_translate/localize_and_translate.dart';` to use plugin :grin:.


## Methods
| Method        | Job           |
| ------------- |:-------------:|
| `currentLanguage` |returns current Language |
| `locale` |returns current Locale |
| `init()` |initialize things, before runApp() |
| `translate(word)` |returns word translation |
| `setNewLanguage('en')` |switch to another language |
| `locals()` |returns current Locales |


## Complete Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
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
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              translator.translate('textArea'),
              style: TextStyle(fontSize: 35),
            ),
            SizedBox(height: 150),
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


## Author
[![Mohamed Sayed](./logo.png)](https://msayed.net)
* [![Fork](https://img.shields.io/github/forks/MohamedSayed95/localize_and_translate?style=social)](https://github.com/MohamedSayed95/localize_and_translate/fork) &nbsp; [![Star](https://img.shields.io/github/stars/MohamedSayed95/localize_and_translate?style=social)](https://github.com/MohamedSayed95/localize_and_translate/stargazers) &nbsp; [![Watches](https://img.shields.io/github/watchers/MohamedSayed95/localize_and_translate?style=social)](https://github.com/MohamedSayed95/localize_and_translate/) 
* [![Plugin](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/localize_and_translate) &nbsp; [![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)

## My Plugins
* [localize_and_translate](https://pub.dev/packages/localize_and_translate)
* [user_auth](https://pub.dev/packages/user_auth)
* [print_color](https://pub.dev/packages/print_color)


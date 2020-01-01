# localize_and_translate
localization and translation was never easier, simple way to translate your flutter apps and make it international


## Screenshots
<img src="https://github.com/MohamedSayed95/localize_and_translate/blob/master/screenshot1.png?raw=true" alt="screenshot" width="200"/><span>  </span><img src="https://github.com/MohamedSayed95/localize_and_translate/blob/master/screenshot2.png?raw=true" alt="screenshot" width="200"/>


## Methods
| Method        | Job           |
| ------------- |:-------------:|
| `currentLanguage` |returns current Language |
| `locale` |returns current Locale |
| `init()` |initialize things, before runApp() |
| `translate(word)` |returns word translation |
| `setNewLanguage('en')` |switch to another language |
| `locals()` |returns current Locales |


## How To Use
1. add `localize_and_translate: ^<latest>` to pubspec.yaml dependencies
2. run `flutter pub get` into root dir of the app
3. add `import 'package:flutter_localizations/flutter_localizations.dart';` to use `GlobalMaterialLocalizations.delegate`
4. add `import 'package:localize_and_translate/localize_and_translate.dart';` to use plugin :grin:
5. wrap app entry into `LocalizedApp()`, and make sure you define it's child into different place "NOT INSIDE"
```dart
  runApp(
    LocalizedApp(
      child: MyApp(),
    ),
  );
```
6. convert your `main()` method to async, we will need next
```dart
Future<void> main() async {
  runApp(
    LocalizedApp(
      child: MyApp(),
    ),
  );
}
```
7. add `WidgetsFlutterBinding.ensureInitialized();` at very first of `main()`
8. inside `main()` define your languages
```dart
LIST_OF_LANGS = ['ar', 'en'];
```

9. add `.json` translation files as assets
* For example : `'assets/langs/ar.json'`| `'assets/langs/en.json'
* structure should look like
```json
{
  "appTitle" : "Example",
  "buttonName" : "التحول للعربية",
}
```
```json
{
  "appTitle" : "تجربة",
  "buttonName" : "English",
}
```
* define them as assets into pubspec.yaml
```yaml
flutter:
  assets:
    - assets/langs/en.json
    - assets/langs/ar.json
```
* run `flutter pub get`
* into `main()` define your root directory
```dart
LANGS_DIR = 'assets/langs/';
```

10. intialize plugin `await translator.init();`
* so now your `main()` should look like this
```dart
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
```

11. define your `LocalizedApp()` child as `MaterialApp()` like this
```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(), // re Route
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: translator.locale,
      supportedLocales: translator.locals(),
    );
  }
}
```

12. enjoy like next example
* we use  `translate(word)`
* `setNewLanguage(languageCode)` : and it's parameters
```dart
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


## Complete Example
* [Example On Pub](https://pub.dev/packages/localize_and_translate#-example-tab-)
* [Example On Github](https://github.com/MohamedSayed95/localize_and_translate/tree/master/example)



## Author
[![Mohamed Sayed](./logo.png)](https://msayed.net)
* [![Fork](https://img.shields.io/github/forks/MohamedSayed95/localize_and_translate?style=social)](https://github.com/MohamedSayed95/localize_and_translate/fork) &nbsp; [![Star](https://img.shields.io/github/stars/MohamedSayed95/localize_and_translate?style=social)](https://github.com/MohamedSayed95/localize_and_translate/stargazers) &nbsp; [![Watches](https://img.shields.io/github/watchers/MohamedSayed95/localize_and_translate?style=social)](https://github.com/MohamedSayed95/localize_and_translate/) 
* [![Plugin](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/localize_and_translate) &nbsp; [![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)

## My Plugins
* [localize_and_translate](https://pub.dev/packages/localize_and_translate)
* [user_auth](https://pub.dev/packages/user_auth)
* [print_color](https://pub.dev/packages/print_color) 


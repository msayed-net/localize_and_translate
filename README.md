# localize_and_translate
Flutter Localization In Human Way

## Screenshots

<img src="https://github.com/msayed-net/localize_and_translate/blob/master/screenshot1.png?raw=true" alt="screenshot" width="200"/><span>  </span><img src="https://github.com/msayed-net/localize_and_translate/blob/master/screenshot2.png?raw=true" alt="screenshot" width="200"/>

## Methods

| Method        | Job           |
| ------------- |:-------------:|
| `currentLanguage` |active language code |
| `locale` |active Locale |
| `init()` |initialize things, before runApp() |
| `translate('word')` |word translation |
| `googleTranslate('word', from: 'en', to: 'ar')` |google translate |
| `setNewLanguage(context,'en',restart: true, remember: true,)` |change language |
| `locals()` |locales list |
| `isDirectionRTL()` |is Direction RTL check |

## How To Use

1. add `localize_and_translate: <latest>` as dependency in `pubspec.yaml` 
2. run `flutter pub get` into app folder
3. add `.json` translation files as assets

* For example : `'assets/langs/ar.json'` | `'assets/langs/en.json'`
* structure should look like

``` json
{
  "appTitle" : "Example",
  "buttonTitle": "العربية", 
  "textArea" : "Thisi is just a test text",
}
```

``` json
{
  "appTitle" : "تجربة",
  "buttonTitle": "English", 
  "textArea" : "هذا مجرد نموذج للتأكد من اداء الاداة",
}
```

* define them as assets in pubspec.yaml

``` yaml
flutter:
  assets:
    - assets/langs/en.json
    - assets/langs/ar.json

```

* run `flutter pub get` 

04. add imports to main.dart

``` dart
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
```

5. wrap app entry into `LocalizedApp()` 
__** make sure you define it's child into different place "NOT INSIDE" **__
6. convert your `main()` method to async, we will need next
7. add `WidgetsFlutterBinding.ensureInitialized();` at very first of `main()` 
8. inside `main()` define: Languages + Root dir, then call `await translator.init();` 

* so now your `main()` should look like this

``` dart
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

``` dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(), // re Route
      localizationsDelegates: translator.delegates, // Android + iOS Delegates
      locale: translator.locale, // active locale
      supportedLocales: translator.locals(), // locals list
    );
  }
}
```

12. Enjoy
* we use `translate("appTitle")` 
* we use `googleTranslate("test", from: 'en', to: 'ar')` 
* `setNewLanguage("en")` : and it's parameters

``` dart
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

## Complete Example

* [Pub](https://pub.dev/packages/localize_and_translate#-example-tab-)
* [Github](https://github.com/msayed-net/localize_and_translate/tree/master/example)

## Known Issues

* Not working with flutter version < 1.12.13

## Author

[![Mohamed Sayed](./logo.png)](https://msayed.net)

* [![Fork](https://img.shields.io/github/forks/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/fork) &nbsp; [![Star](https://img.shields.io/github/stars/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/stargazers) &nbsp; [![Watches](https://img.shields.io/github/watchers/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/) 
* [![Plugin](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/localize_and_translate) &nbsp; [![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)

## My Plugins

* [localize_and_translate](https://pub.dev/packages/localize_and_translate)
* [print_color](https://pub.dev/packages/print_color) 
* [user_auth](https://pub.dev/packages/user_auth)
* [flutter_hex_color](https://pub.dev/packages/flutter_hex_color) 


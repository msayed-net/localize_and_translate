# localize_and_translate

Flutter localization abstract, Really simple

[![Pub](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/localize_and_translate)
[![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)


### Show some :heart: and star the repo

[![Fork](https://img.shields.io/github/forks/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/fork)
[![Star](https://img.shields.io/github/stars/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/stargazers)
[![Watch](https://img.shields.io/github/watchers/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/) 

## Screenshots

<img src="https://github.com/msayed-net/localize_and_translate/blob/master/screenshot1.png?raw=true" alt="screenshot" width="200"/><span>  </span><img src="https://github.com/msayed-net/localize_and_translate/blob/master/screenshot2.png?raw=true" alt="screenshot" width="200"/>

## Tutorial

### Video

* Arabic : [https://www.youtube.com/watch?v=nfDYussovfQ](https://www.youtube.com/watch?feature=player_embedded&v=nfDYussovfQ)

[![Alt text](https://img.youtube.com/vi/nfDYussovfQ/0.jpg)](https://www.youtube.com/watch?v=nfDYussovfQ)

### Methods

| Method        | Job           |
| ------------- |:-------------:|
| `init()` |initialize things, before runApp() |
| `translate('word')` |word translation |
| `translate('word',{"key":"value"})` |word translation with replacement arguments|
| `setNewLanguage(context,newLanguage:'en',restart: true, remember: true,)` |change language |
| `isDirectionRTL()` |is Direction RTL check |
| `currentLanguage` |Active language code |
| `locale` |Active Locale |
| `locals()` |Locales list |
| `delegates` |Localization Delegates |

### Installation

* add `.json` translation files as assets

- For example : `'assets/langs/ar.json'` | `'assets/langs/en.json'`
- structure should look like

``` json
{
  "appTitle" : "تطبيق",
  "textArea" : "This is just a test text"
}
```

- define them as assets in pubspec.yaml

``` yaml
flutter:
  assets:
    - assets/langs/en.json
    - assets/langs/ar.json
```

### Initialization

- Add imports to main.dart
- Make `main()` `async` and do the following
- Ensure flutter activated `WidgetsFlutterBinding.ensureInitialized()` 
- Define languages list `LIST_OF_LANGS`
- Define assets directory `LANGS_DIR`
- Initialize `await translator.init();`
- Inside `runApp()` wrap entry class with `LocalizedApp()`
- Note : __** make sure you define it's child into different place "NOT INSIDE" **__

``` dart
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

main() async {
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

- `LocalizedApp()` child example -> `MaterialApp()`

``` dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      localizationsDelegates: translator.delegates, // Android + iOS Delegates
      locale: translator.locale, // Active locale
      supportedLocales: translator.locals(), // Locals list
    );
  }
}
```

### Usage

* use `translate("appTitle")` 
* use `googleTranslate("test", from: 'en', to: 'ar')` 
* use `setNewLanguage(context, newLanguage: 'ar', remember: true, restart: true);`

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
      testText = await translator.googleTranslate(
        testText,
        from: 'en',
        to: translator.currentLanguage,
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

### Contributions

* `translate()` accept keys : by [mo-ah-dawood](https://github.com/mo-ah-dawood)
* Change template from plugin to package : by [mo-ah-dawood](https://github.com/mo-ah-dawood)

### Known Issues

* Lowest Flutter Version (1.12.13)

## Project Created & Maintained By

### [![Mohamed Sayed](./logo.png)](https://msayed.net)

Software Engineer | In :heart: with Flutter

# Donate

> If you found this project helpful or you learned something from the source code and want to thank me, consider buying me a cup of :coffee:
>
> - [PayPal](https://www.paypal.me/msayednet/)

## Note : All Contibutions Are Welcomed

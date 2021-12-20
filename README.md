# localize_and_translate

Flutter localization in easy steps

[![Pub](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/localize_and_translate)
[![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)

[![Fork](https://img.shields.io/github/forks/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/fork)
[![Star](https://img.shields.io/github/stars/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/stargazers)
[![Watch](https://img.shields.io/github/watchers/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/)  

## Screenshots

![screenshot 1](https://github.com/msayed-net/localize_and_translate/blob/master/screenshot1.jpeg?raw=true)
![screenshot 2](https://github.com/msayed-net/localize_and_translate/blob/master/screenshot2.jpeg?raw=true)

## Tutorial

### Video

* Arabic : [https://www.youtube.com/watch?v=nfDYussovfQ](https://www.youtube.com/watch?feature=player_embedded&v=nfDYussovfQ)
* English : Next..

### Methods

| Method        | Job           |
| ------------- |:-------------:|
| `init()` |initialize things, before runApp()|
| `'word'.tr()` |word translation - string extension|
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
* For example : `'assets/lang/ar.json'` | `'assets/lang/en.json'`
* structure should look like

``` json
{
    "appTitle": "تطبيق تجريبى", 
    "buttonTitle": "English", 
    "textArea": "هذا مجرد نموذج للتأكد من اداء الأداة"
}
```

* define them as assets in pubspec.yaml

``` yaml
flutter:
  assets:
    - assets/lang/
```

### Initialization

* Add imports to main.dart
* Make `main()` `async` and do the following
* Ensure flutter activated `WidgetsFlutterBinding.ensureInitialized()`  
* Initialize `await translator.init();` with neccassry parameters
* Inside `runApp()` wrap entry class with `LocalizedApp()`
* Note : make sure you define it's child into different place "NOT INSIDE"

``` dart
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

  runApp(
    LocalizedApp(
      child: MyApp(),
    ),
  );
}
```

* `LocalizedApp()` child example -> `MaterialApp()`

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

* use `translate('appTitle')`  
* use `setNewLanguage(context, newLanguage: 'ar', remember: true, restart: true);`

### Example

[![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)

## Contributors

![Contributors List](./CONTRIBUTORS.svg)

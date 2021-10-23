# localize_and_translate
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Flutter localization in easy steps

[![Pub](https://img.shields.io/badge/Get%20library-pub-blue)](https://pub.dev/packages/localize_and_translate)
[![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)


### Share your love to this :heart:
[![Fork](https://img.shields.io/github/forks/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/fork)
[![Star](https://img.shields.io/github/stars/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/stargazers)
[![Watch](https://img.shields.io/github/watchers/msayed-net/localize_and_translate?style=social)](https://github.com/msayed-net/localize_and_translate/) 


## Screenshots
<img src="https://github.com/msayed-net/localize_and_translate/blob/master/screenshot1.png?raw=true" alt="screenshot" width="200"/><span>  </span><img src="https://github.com/msayed-net/localize_and_translate/blob/master/screenshot2.png?raw=true" alt="screenshot" width="200"/>


## Tutorial
### Video
* Arabic : [https://www.youtube.com/watch?v=nfDYussovfQ](https://www.youtube.com/watch?feature=player_embedded&v=nfDYussovfQ)
* English : soon..


### Methods
| Method        | Job           |
| ------------- |:-------------:|
| `init()` |initialize things, before runApp()|
| `"word".tr()` |word translation - string extension|
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
- For example : `'assets/lang/ar.json'` | `'assets/lang/en.json'`
- structure should look like
``` json
{
    "appTitle": "تطبيق تجريبى", 
    "buttonTitle": "English", 
    "textArea": "هذا مجرد نموذج للتأكد من اداء الأداة"
}
```
- define them as assets in pubspec.yaml
``` yaml
flutter:
  assets:
    - assets/lang/en.json
    - assets/lang/ar.json
```

### Initialization
- Add imports to main.dart
- Make `main()` `async` and do the following
- Ensure flutter activated `WidgetsFlutterBinding.ensureInitialized()` 
- Initialize `await translator.init();` with neccassry parameters
- Inside `runApp()` wrap entry class with `LocalizedApp()`
- Note : make sure you define it's child into different place "NOT INSIDE"

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
* use `setNewLanguage(context, newLanguage: 'ar', remember: true, restart: true);`

``` dart
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('appTitle'.tr()),
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
              'textArea'.tr(),
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
              child: Text('buttonTitle'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

```

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://www.linkedin.com/in/msayed-net"><img src="https://avatars.githubusercontent.com/u/25801517?s=40&v=4?s=100" width="100px;" alt=""/><br /><sub><b>Mohamed Sayed</b></sub></a><br /><a href="https://github.com/msayed-net/localize_and_translate/commits?author=msayed-net" title="Code">💻</a></td>
    <td align="center"><a href="https://www.linkedin.com/in/mohamed-ahmed-2220b6121/"><img src="https://avatars.githubusercontent.com/u/31937782?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Mohamed Dawood</b></sub></a><br /><a href="https://github.com/msayed-net/localize_and_translate/commits?author=mo-ah-dawood" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/RYOKSEC"><img src="https://avatars.githubusercontent.com/u/31315805?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Eyad Al-Khatib</b></sub></a><br /><a href="https://github.com/msayed-net/localize_and_translate/commits?author=RYOKSEC" title="Code">💻</a></td>
    </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

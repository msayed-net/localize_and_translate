# localize_and_translate

Flutter localization in easy steps

[![License](https://img.shields.io/github/license/msayed-net/localize_and_translate?style=for-the-badge)](https://github.com/msayed-net)
[![Pub](https://img.shields.io/badge/PUB-pub-blue?style=for-the-badge)](https://pub.dev/packages/localize_and_translate)
[![Example](https://img.shields.io/badge/Example-Ex-success?style=for-the-badge)](https://pub.dev/packages/localize_and_translate/example)

[![PUB](https://img.shields.io/pub/v/localize_and_translate.svg?style=for-the-badge)](https://pub.dev/packages/localize_and_translate)
[![GitHub release](https://img.shields.io/github/v/release/msayed-net/localize_and_translate?style=for-the-badge)](https://github.com/msayed-net/localize_and_translate/releases)
[![GitHub stars](https://img.shields.io/github/stars/msayed-net/localize_and_translate?style=for-the-badge)](https://github.com/msayed-net/localize_and_translate)
[![GitHub forks](https://img.shields.io/github/forks/msayed-net/localize_and_translate?style=for-the-badge)](https://github.com/msayed-net/localize_and_translate)

<!-- [![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fmsayed-net%2FLocalize%2FAnd%2FTranslate%2Fbadge%3Fref%3Dmain&style=for-the-badge)](https://actions-badge.atrox.dev/msayed-net/localize_and_translate/goto?ref=main) -->

## Getting Started

### 🔩 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  localize_and_translate: <last_version>
```

Create folder and add translation files like this

```
assets
└── lang
    ├── {languageCode}.{ext}                  //only language code
    └── {languageCode}-{countryCode}.{ext}    //or full locale code
```

Example:

```
assets
└── lang
    ├── en.json
    └── en-US.json 
```

Declare your assets localization directory in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/lang/
```

### ⚠️ Note on **iOS**

For translation to work on **iOS** you need to add supported locales to
`ios/Runner/Info.plist` as described [here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#specifying-supportedlocales).

Example:

```xml
<key>CFBundleLocalizations</key>
<array>
  <string>en</string>
  <string>nb</string>
</array>
```

### ⚙️ Configuration 

Add EasyLocalization widget like in example

```dart
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await LocalizeAndTranslate.init(
        assetLoader: const AssetLoaderRootBundleJson('assets/lang/'), // <-- change the path of the translation files
        supportedLanguageCodes: <String>['ar', 'en'], // <-- or supportedLocales: [Locale('ar', 'DZ'), Locale('en', 'US')],
    );
  
    runApp(
        LocalizedApp(
            child: MaterialApp(
              // style 1
              builder: LocalizeAndTranslate.directionBuilder,
              // style 2
              builder: (BuildContext context, Widget? child) {
                child = LocalizeAndTranslate.directionBuilder(context, child);
        
                return child;
              },
              home: const MyHomePage(),
              locale: context.locale,
              localizationsDelegates: context.delegates,
              supportedLocales: context.supportedLocales,
            ),
        ),
    );
}
```

[**Full example**](https://github.com/msayed-net/localize_and_translate/tree/main/example)

### 📜 Localize And Translate init properties

| Properties              | Required | Default                       | Description                                                                                                                                                            |
|-------------------------|----------|-------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| supportedLanguageCodes  | or next  |                               | List of supported languages to be converted to locales.                                                                                                                |
| supportedLocales        | or prev  |                               | List of supported locales.                                                                                                                                             |
| defaultType             | false    |                               | Path to your folder with localization files.                                                                                                                           |
| assetLoader             | true     | `AssetLoaderRootBundleJson()` | Class loader for localization values. You can create your own class.                                                                                                   |

## Usage

### Init

Call `LocalizeAndTranslate.init(params)` in your main before runApp.

```dart
void main() async{
  // ...
  // Needs to be called so that we can await for LocalizeAndTranslate.init();
  WidgetsFlutterBinding.ensureInitialized();

  await LocalizeAndTranslate.init(
    assetLoader: const AssetLoaderRootBundleJson('assets/lang/'), // <-- change the path of the translation files
    supportedLocales: <Locale>[Locale('ar', 'DZ'), Locale('en', 'US')], // <-- or  supportedLanguageCodes: <String>['ar', 'en'],
    defaultType: LocalizationDefaultType.asDefined, // <-- change the default type
  );
  // ...
  runApp(
    // ...
  );
  // ...
}
```

### context extensions

LocalizeAndTranslate uses extension methods [BuildContext] for access to some values.


Example:

```dart
// set locale
context.setLocale(Locale('en', 'US'));

// set language code
context.setLanguageCode('en');

// get locale
context.locale; // en_US

// get language code
context.languageCode; // en
```


### Translate `tr()`

Main function for translate your language keys

```dart
print('title'.tr(defaultValue: 'Awesome App')); //String
```

### Translations

as json values pair

```json
{
  "title": "Awesome App",
  "hello": "Hello",
  "world": "World!",
}
```


### API Reference

| Properties         | Extension | Type     | Description                                                    |
|--------------------|-----------|----------|----------------------------------------------------------------|
| `countryCode`      | context   | Property | Gets the country code of the current locale.                   |
| `delegates`        | context   | Property | Gets the list of localization delegates used for translation.  |
| `init`             | no        | Method   | Initializes the plugin with the desired configuration values.  |
| `locale`           | context   | Property | Gets the current locale being used for localization.           |
| `resetLocale`      | context   | Method   | Resets the current locale to its default value.                |
| `setLanguageCode`  | context   | Method   | Sets the language code for localization.                       |
| `setLocale`        | context   | Method   | Sets the current locale to one of the supported locales.       |
| `supportedLocales` | context   | Property | Gets the list of supported locales for the app.                |
| `tr`               | string    | Method   | Retrieves the translated string for a given localization key.  |


Reset everything to default values passed through `init()`.

Example:

```dart
RaisedButton(
  onPressed: (){
    context.resetLocale();
  },
  child: Text(LocaleKeys.reset_locale).tr(),
)
```
## Contributors

[Contributors](https://github.com/msayed-net/localize_and_translate/graphs/contributors)
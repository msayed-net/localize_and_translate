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

### ⚙️ Configuration app

Add EasyLocalization widget like in example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizeAndTranslate.ensureInitialized();
  
  runApp(
    LocalizeAndTranslate(
      supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
      path: 'assets/lang', // <-- change the path of the translation files 
      fallbackLocale: Locale('en', 'US'),
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MyHomePage()
    );
  }
}
```

[**Full example**](https://github.com/aissat/localize_and_translate/blob/master/example/lib/main.dart)

### 📜 Localize And Translate widget properties

| Properties              | Required | Default                   | Description                                                                                                                                                            |
| ----------------------- | -------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| key                     | false    |                           | Widget key.                                                                                                                                                            |
| child                   | true     |                           | Place for your main page widget.                                                                                                                                       |
| supportedLocales        | true     |                           | List of supported locales.                                                                                                                                             |
| path                    | true     |                           | Path to your folder with localization files.                                                                                                                           |
| assetLoader             | false    | `RootBundleAssetLoader()` | Class loader for localization files. You can create your own class.                                                                                                    |
| fallbackLocale          | false    |                           | Returns the locale when the locale is not in the list `supportedLocales`.                                                                                              |
| startLocale             | false    |                           | Overrides device locale.                                                                                                                                               |
| saveLocale              | false    | `true`                    | Save locale in device storage.                                                                                                                                         |
| useFallbackTranslations | false    | `false`                   | If a localization key is not found in the locale file, try to use the fallbackLocale file.                                                                             |
| useOnlyLangCode         | false    | `false`                   | Trigger for using only language code for reading localization files.</br></br>Example:</br>`en.json //useOnlyLangCode: true`</br>`en-US.json //useOnlyLangCode: false` |
| errorWidget             | false    | `FutureErrorWidget()`     | Shows a custom error widget when an error occurs.                                                                                                                      |

## Usage

### 🔥 Initialize library

Call `LocalizeAndTranslate.ensureInitialized()` in your main before runApp.

```dart
void main() async{
  // ...
  // Needs to be called so that we can await for LocalizeAndTranslate.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await LocalizeAndTranslate.ensureInitialized();
  // ...
  runApp(....)
  // ...
}
```

### 🔥 Change or get locale

LocalizeAndTranslate uses extension methods [BuildContext] for access to locale.

It's the easiest way change locale or get parameters 😉.

ℹ️ No breaking changes, you can use old the static method `LocalizeAndTranslate.of(context)`

Example:

```dart
context.setLocale(Locale('en', 'US'));

print(context.locale.toString());
```

### 🔥 Translate `tr()`

Main function for translate your language keys

You can use extension methods of [String] or [Text] widget, you can also use `tr()` as a static function.

```dart
Text('title').tr() //Text widget

print('title'.tr()); //String

var title = tr('title') //Static function

Text(context.tr('title')) //Extension on BuildContext
```

#### Arguments

| Name      | Type                  | Description                                                                         |
| --------- | --------------------- | ----------------------------------------------------------------------------------- |
| args      | `List<String>`        | List of localized strings. Replaces `{}` left to right                              |
| namedArgs | `Map<String, String>` | Map of localized strings. Replaces the name keys `{key_name}` according to its name |
| gender    | `String`              | Gender switcher. Changes the localized string based on gender string                |

Example:

``` json
{
   "msg":"{} are written in the {} language",
   "msg_named":"LocalizeAndTranslate is written in the {lang} language",
   "msg_mixed":"{} are written in the {lang} language",
   "gender":{
      "male":"Hi man ;) {}",
      "female":"Hello girl :) {}",
      "other":"Hello {}"
   }
}
```

```dart
// args
Text('msg').tr(args: ['LocalizeAndTranslate', 'Dart']),

// namedArgs
Text('msg_named').tr(namedArgs: {'lang': 'Dart'}),

// args and namedArgs
Text('msg_mixed').tr(args: ['LocalizeAndTranslate'], namedArgs: {'lang': 'Dart'}),

// gender
Text('gender').tr(gender: _gender ? "female" : "male"),

```

### 🔥 Plurals `plural()`

You can translate with pluralization.
To insert a number in the translated string, use `{}`. Number formatting supported, for more information read [NumberFormat](https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html) class documentation.

You can use extension methods of [String] or [Text] widget, you can also use `plural()` as a static function.

#### More Arguments

| Name      | Type                  | Description                                                                                                                  |
| --------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| value     | `num`                 | Number value for pluralization                                                                                               |
| args      | `List<String>`        | List of localized strings. Replaces `{}` left to right                                                                       |
| namedArgs | `Map<String, String>` | Map of localized strings. Replaces the name keys `{key_name}` according to its name                                          |
| name      | `String`              | Name of number value. Replaces `{$name}` to value                                                                            |
| format    | `NumberFormat`        | Formats a numeric value using a [NumberFormat](https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html) class |

Example:

``` json
{
  "day": {
    "zero":"{} дней",
    "one": "{} день",
    "two": "{} дня",
    "few": "{} дня",
    "many": "{} дней",
    "other": "{} дней"
  },
  "money": {
    "zero": "You not have money",
    "one": "You have {} dollar",
    "many": "You have {} dollars",
    "other": "You have {} dollars"
  },
  "money_args": {
    "zero": "{} has no money",
    "one": "{} has {} dollar",
    "many": "{} has {} dollars",
    "other": "{} has {} dollars"
  },
  "money_named_args": {
    "zero": "{name} has no money",
    "one": "{name} has {money} dollar",
    "many": "{name} has {money} dollars",
    "other": "{name} has {money} dollars"
  }
}
```

⚠️ Key "other" required!

```dart
//Text widget with format
Text('money').plural(1000000, format: NumberFormat.compact(locale: context.locale.toString())) // output: You have 1M dollars

//String
print('day'.plural(21)); // output: 21 день

//Static function
var money = plural('money', 10.23) // output: You have 10.23 dollars

//Text widget with plural BuildContext extension
Text(context.plural('money', 10.23))

//Static function with arguments
var money = plural('money_args', 10.23, args: ['John', '10.23'])  // output: John has 10.23 dollars

//Static function with named arguments
var money = plural('money_named_args', 10.23, namedArgs: {'name': 'Jane', 'money': '10.23'})  // output: Jane has 10.23 dollars
var money = plural('money_named_args', 10.23, namedArgs: {'name': 'Jane'}, name: 'money')  // output: Jane has 10.23 dollars
```

### 🔥 Linked translations

If there's a translation key that will always have the same concrete text as another one you can just link to it. To link to another translation key, all you have to do is to prefix its contents with an `@:` sign followed by the full name of the translation key including the namespace you want to link to.

Example:

```json
{
  ...
  "example": {
    "hello": "Hello",
    "world": "World!",
    "helloWorld": "@:example.hello @:example.world"
  }
  ...
}
```

```dart
print('example.helloWorld'.tr()); //Output: Hello World!
```

You can also do nested anonymous and named arguments inside the linked messages.

Example:

```json
{
  ...
  "date": "{currentDate}.",
  "dateLogging": "INFO: the date today is @:date"
  ...
}
```

```dart
print('dateLogging'.tr(namedArguments: {'currentDate': DateTime.now().toIso8601String()})); //Output: INFO: the date today is 2020-11-27T16:40:42.657.
```

#### Formatting linked translations

Formatting linked locale messages
If the language distinguishes cases of character, you may need to control the case of the linked locale messages. Linked messages can be formatted with modifier `@.modifier:key`

The below modifiers are available currently.

- `upper`: Uppercase all characters in the linked message.
- `lower`: Lowercase all characters in the linked message.
- `capitalize`: Capitalize the first character in the linked message.

Example:

```json
{
  ...
  "example": {
    "fullName": "Full Name",
    "emptyNameError": "Please fill in your @.lower:example.fullName"
  }
  ...
}
```

Output:

```dart
print('example.emptyNameError'.tr()); //Output: Please fill in your full name
```

### 🔥 Reset locale `resetLocale()`

Reset locale to device locale

Example:

```dart
RaisedButton(
  onPressed: (){
    context.resetLocale();
  },
  child: Text(LocaleKeys.reset_locale).tr(),
)
```

### 🔥 Get device locale `deviceLocale`

Get device locale

Example:

```dart
print(${context.deviceLocale.toString()}) // OUTPUT: en_US
```

### 🔥 Delete save locale `deleteSaveLocale()`

Clears a saved locale from device storage

Example:

```dart
RaisedButton(
  onPressed: (){
    context.deleteSaveLocale();
  },
  child: Text(LocaleKeys.reset_locale).tr(),
)
```

### 🔥 Get LocalizeAndTranslate widget properties

At any time, you can take the main [properties](#-localize-and-translate-widget-properties) of the LocalizeAndTranslate widget using [BuildContext].

Are supported: supportedLocales, fallbackLocale, localizationDelegates.

Example:

```dart
print(context.supportedLocales); // output: [en_US, ar_DZ, de_DE, ru_RU]

print(context.fallbackLocale); // output: en_US
```

## 💻 Code generation

Code generation supports only json files, for more information run in terminal `flutter pub run localize_and_translate:generate -h`

### Command line arguments

| Arguments                    | Short | Default               | Description                                                                 |
| ---------------------------- | ----- | --------------------- | --------------------------------------------------------------------------- |
| --help                       | -h    |                       | Help info                                                                   |
| --source-dir                 | -S    | resources/langs       | Folder containing localization files                                        |
| --source-file                | -s    | First file            | File to use for localization                                                |
| --output-dir                 | -O    | lib/generated         | Output folder stores for the generated file                                 |
| --output-file                | -o    | codegen_loader.g.dart | Output file name                                                            |
| --format                     | -f    | json                  | Support json or keys formats                                                |
| --[no-]skip-unnecessary-keys | -u    | false                 | Ignores keys defining nested object except for pluarl(), gender() keywords. |

### 🔌 Localization asset loader class

Steps:

1. Open your terminal in the folder's path containing your project
2. Run in terminal `flutter pub run localize_and_translate:generate`
3. Change asset loader and past import.

  ```dart
  import 'generated/codegen_loader.g.dart';
  ...
  void main(){
    runApp(LocalizeAndTranslate(
      child: MyApp(),
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'DZ')],
      path: 'resources/langs',
      assetLoader: CodegenLoader()
    ));
  }
  ...
  ```

4. All done!

### 🔑 Localization keys

If you have many localization keys and are confused, key generation will help you. The code editor will automatically prompt keys

Steps:

1. Open your terminal in the folder's path containing your project
2. Run in terminal `flutter pub run localize_and_translate:generate -f keys -o locale_keys.g.dart`
3. Past import.

```dart
import 'generated/locale_keys.g.dart';
```

4. All done!

How to use generated keys:

```dart
print(LocaleKeys.title.tr()); //String
//or
Text(LocaleKeys.title).tr(); //Widget
```

## ➕ Extensions helpers

### String to locale

```dart
'en_US'.toLocale(); // Locale('en', 'US')

//with custom separator
'en|US'.toLocale(separator: '|') // Locale('en', 'US')
```

### Locale to String with separator

```dart
Locale('en', 'US').toStringWithSeparator(separator: '|') // en|US
```

<p align="center">
    <a href="https://gitpod.io/#https://github.com/msayed-net/localize_and_translate" target="_blank">
        <img src="https://gitpod.io/button/open-in-gitpod.svg" width=200 />
    </a>
</p>

### Example

[![Example](https://img.shields.io/badge/Example-Ex-success)](https://pub.dev/packages/localize_and_translate#-example-tab-)

## Donations

We need your support. Projects like this can not be successful without support from the community. If you find this project useful, and would like to support further development and ongoing maintenance, please consider donating.

<p align="center">
  <a href="https://opencollective.com/localize_and_translate/donate" target="_blank">
    <img src="https://opencollective.com/localize_and_translate/donate/button@2x.png?color=blue" width=300 />
  </a>
</p>

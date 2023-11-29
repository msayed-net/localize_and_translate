import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalizeAndTranslate.init(
    assetLoader: const AssetLoaderRootBundleJson('assets/lang'),
    supportedLanguageCodes: const <String>['ar', 'en'],
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      child: MaterialApp(
        localizationsDelegates: context.delegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (BuildContext context, Widget? child) {
          child = LocalizeAndTranslate.directionBuilder(context, child);

          return child;
        },
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('name'.tr()),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (LocalizeAndTranslate.getLanguageCode() == 'ar') {
              LocalizeAndTranslate.setLanguageCode('en');
              debugPrint('new lang: en -- context.locale: ${context.locale}');
            } else {
              LocalizeAndTranslate.setLanguageCode('ar');
              debugPrint('new lang: ar -- context.locale: ${context.locale}');
            }
          },
          child: Text('change'.tr()),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:print_color/print_color.dart';

Future<void> main() async {

  // if your flutter > 1.7.8 
  // ensure flutter activated
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
  void initState() {
    Print.green('starting'); // print_color plugin
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                // textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35),
              ),
              SizedBox(height: 150),
              OutlineButton(
                onPressed: () {

                  // FIXME: Layout not switching
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
      ),
    );
  }
}

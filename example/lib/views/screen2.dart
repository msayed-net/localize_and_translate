import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: Text('appTitle'.tr()),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 50),
            Text(
              'textArea'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 35),
            ),
            Wrap(
              children: translator.locals().map((Locale i) {
                return OutlinedButton(
                  onPressed: () {
                    translator.setNewLanguage(
                      context,
                      newLanguage: i.languageCode,
                    );
                  },
                  child: Text(i.languageCode),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

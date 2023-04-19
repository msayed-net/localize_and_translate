import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 26),
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: const Text(
                'Choose language',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            _SwitchListTileMenuItem(
              title: 'عربي',
              subtitle: 'عربي',
              locale: context.supportedLocales[1],
            ),
            const _Divider(),
            _SwitchListTileMenuItem(
              title: 'English',
              subtitle: 'English',
              locale: context.supportedLocales[0],
            ),
            const _Divider(),
            _SwitchListTileMenuItem(
              title: 'German',
              subtitle: 'German',
              locale: context.supportedLocales[2],
            ),
            const _Divider(),
            _SwitchListTileMenuItem(
              title: 'Русский',
              subtitle: 'Русский',
              locale: context.supportedLocales[3],
            ),
            const _Divider(),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: const Divider(
        color: Colors.grey,
      ),
    );
  }
}

class _SwitchListTileMenuItem extends StatelessWidget {
  const _SwitchListTileMenuItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.locale,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Locale locale;

  bool isSelected(BuildContext context) => locale == context.locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
        border: isSelected(context) ? Border.all(color: Colors.blueAccent) : null,
      ),
      child: ListTile(
          dense: true,
          // isThreeLine: true,
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
          ),
          onTap: () async {
            log(locale.toString(), name: toString());
            await context.setLocale(locale); //BuildContext extension method
            Navigator.pop(context);
          }),
    );
  }
}

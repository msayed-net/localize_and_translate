import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

/// abstract class used to building your Custom AssetLoader
/// Example:
/// ```
///class FileAssetLoader extends AssetLoader {
///  @override
///  Future<Map<String, dynamic>> load(String path, Locale locale) async {
///    final file = File(path);
///    return json.decode(await file.readAsString());
///  }
///}
/// ```
abstract class AssetLoader {
  const AssetLoader();
  Future<Map<String, dynamic>?> load(String path, Locale locale);
}

///
/// default used is RootBundleAssetLoader which uses flutter's assetloader
///
class RootBundleAssetLoader extends AssetLoader {
  const RootBundleAssetLoader();

  String getLocalePath(String basePath, Locale locale) {
    return '$basePath/${locale.toStringWithSeparator(separator: "-")}.json';
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final String localePath = getLocalePath(path, locale);
    developer.log('Load asset from $path');
    final String jsonStr = await rootBundle.loadString(localePath);
    return json.decode(jsonStr) as Map<String, dynamic>?;
  }
}

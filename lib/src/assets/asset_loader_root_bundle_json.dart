import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/src/assets/asset_loader_base.dart';
import 'package:localize_and_translate/src/constants/db_keys.dart';

/// [AssetLoaderRootBundleJson] is the asset loader for root bundle.
/// It loads the assets from the root bundle.
class AssetLoaderRootBundleJson implements AssetLoaderBase {
  /// [AssetLoaderRootBundleJson] constructor
  /// [directory] is the path of the json directory
  const AssetLoaderRootBundleJson(this.directory);

  /// [directory] is the path of the json directory
  final String directory;

  @override
  Future<Map<String, dynamic>> load() async {
    final AssetManifest assetManifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);
    final Iterable<String> paths = assetManifest.listAssets().where(
          (String element) => element.contains(directory),
        );

    final Map<String, dynamic> result = <String, dynamic>{};

    for (final String path in paths) {
      final String fileName = path.split('/').last;
      final String fileNameNoExtension = fileName.split('.').first;
      String languageCode = '';
      String? countryCode;

      if (fileNameNoExtension.contains('-')) {
        languageCode = fileNameNoExtension.split('-').first;
        countryCode = fileNameNoExtension.split('-').length > 2
            ? fileNameNoExtension.split('-').elementAt(1)
            : null;
      } else {
        languageCode = fileNameNoExtension;
      }

      final String valuesStr = await rootBundle.loadString(path);
      final dynamic values = json.decode(valuesStr);

      if (values is Map<String, dynamic>) {
        final Map<String, dynamic> newValues = <String, dynamic>{};
        for (final String key in values.keys) {
          newValues[DBKeys.buildPrefix(
            key: key,
            languageCode: languageCode,
            countryCode: countryCode,
          )] = values[key];
        }

        result.addAll(newValues);
      }
    }

    debugPrint('--LocalizeAndTranslate-- Translated Strings: ${result.length}');
    return result;
  }
}

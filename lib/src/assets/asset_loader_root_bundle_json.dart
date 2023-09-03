import 'dart:convert';

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
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = assetManifest.listAssets().where(
          (element) => element.contains(directory),
        );

    final result = <String, dynamic>{};

    for (final path in paths) {
      final fileName = path.split('/').last;
      final fileNameNoExtension = fileName.split('.').first;
      var languageCode = '';
      String? countryCode;

      if (fileNameNoExtension.contains('-')) {
        languageCode = fileNameNoExtension.split('-').first;
        countryCode = fileNameNoExtension.split('-').length > 2 ? fileNameNoExtension.split('-').elementAt(1) : null;
      } else {
        languageCode = fileNameNoExtension;
      }

      final valuesStr = await rootBundle.loadString(path);
      final values = json.decode(valuesStr);

      if (values is Map<String, dynamic>) {
        final newValues = <String, dynamic>{};

        if (countryCode != null) {
          values.forEach((key, value) {
            newValues[DBKeys.appendPrefix(key)] = value;
          });
        } else {
          values.forEach((key, value) {
            newValues[DBKeys.appendPrefix(key)] = value;
          });
        }

        result.addAll(newValues);
      }
    }

    return result;
  }
}

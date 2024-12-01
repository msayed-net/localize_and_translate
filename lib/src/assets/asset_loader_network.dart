import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/src/assets/asset_loader_base.dart';
import 'package:localize_and_translate/src/constants/db_keys.dart';
import 'package:localize_and_translate/src/mappers/nested_json_mapper.dart';

/// [AssetLoaderNetwork] loads translation assets from a network source using a user-defined URL map.
class AssetLoaderNetwork implements AssetLoaderBase {
  /// Creates an instance of [AssetLoaderNetwork].
  ///
  /// - `urlMap`: A map where the key is the language code (e.g., 'en', 'en_US') and the value is the full URL for the translation file.
  /// - `dio`: An optional Dio instance for customization (e.g., adding interceptors).
  AssetLoaderNetwork(this.urlMap, {Dio? dio}) : dio = dio ?? Dio();

  /// A map of language codes to their corresponding translation file URLs.
  final Map<String, String> urlMap;

  /// Dio instance for making HTTP requests.
  final Dio dio;

  @override
  Future<Map<String, dynamic>> load() async {
    final Map<String, dynamic> result = <String, dynamic>{};

    for (final MapEntry<String, String> entry in urlMap.entries) {
      // Normalize the language code to a consistent format (e.g., en_US)
      final String normalizedLanguageCode = _normalizeLanguageCode(entry.key);
      final String url = entry.value;

      try {
        final Response<dynamic> response = await dio.get(url);

        if (response.statusCode == 200) {
          final dynamic values = jsonDecode(response.data.toString());

          if (values is Map<String, dynamic>) {
            final Map<String, dynamic> flattenedValues = NestedJsonMapper.flattenJson(values);

            for (final String key in flattenedValues.keys) {
              final String prefix = DBKeys.buildPrefix(
                key: key,
                languageCode: normalizedLanguageCode.split('_').first,
                countryCode: normalizedLanguageCode.contains('_') ? normalizedLanguageCode.split('_').last : null,
              );

              result[prefix] = flattenedValues[key];
            }
          }
        } else {
          throw Exception('Failed to load translations for $normalizedLanguageCode: ${response.statusCode}');
        }
      } catch (e, stackTrace) {
        debugPrint(
          '--LocalizeAndTranslate-- Failed to load translations for $normalizedLanguageCode: $e\n$stackTrace',
        );
      }
    }

    return result;
  }

  /// Normalizes a language code to the format `en_US` (underscore-separated).
  String _normalizeLanguageCode(String languageCode) {
    // Replace hyphens (-) with underscores (_), e.g., en-US -> en_US
    return languageCode.replaceAll('-', '_');
  }
}

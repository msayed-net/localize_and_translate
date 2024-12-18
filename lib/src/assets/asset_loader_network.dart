import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/src/assets/asset_loader_base.dart';
import 'package:localize_and_translate/src/constants/db_keys.dart';
import 'package:localize_and_translate/src/mappers/json_mapper_base.dart';
import 'package:localize_and_translate/src/mappers/nested_json_mapper.dart';

/// [AssetLoaderNetwork] loads translation assets from a network source using a user-defined URL map.
class AssetLoaderNetwork implements AssetLoaderBase {
  /// Creates an instance of [AssetLoaderNetwork].
  ///
  /// - `urlMap`: A map where the key is the language code (e.g., 'en', 'en_US') and the value is the full URL for the translation file.
  /// - `headers`: An optional map of headers to include in the HTTP request.
  /// - `dio`: An optional Dio instance for customization (e.g., adding interceptors).
  AssetLoaderNetwork(
    this.urlMap, {
    Dio? dio,
    Map<String, dynamic>? headers,
  }) : _dio = dio ?? Dio() {
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
  }

  /// A map of language codes to their corresponding translation file URLs.
  final Map<String, String> urlMap;

  /// Dio instance for making HTTP requests.
  final Dio _dio;

  @override
  Future<Map<String, dynamic>> load([JsonMapperBase? base]) async {
    base ??= NestedJsonMapper();

    final Map<String, dynamic> result = <String, dynamic>{};

    for (final MapEntry<String, String> entry in urlMap.entries) {
      // Normalize the language code to a consistent format (e.g., en_US)
      final String normalizedLanguageCode = _normalizeLanguageCode(entry.key);
      final String url = entry.value;

      try {
        final Response<dynamic> response = await _dio.get(url);

        if (response.statusCode == 200) {
          final dynamic values = jsonDecode(jsonEncode(response.data));

          if (values is Map<String, dynamic>) {
            final Map<String, dynamic> flattenedValues = base.flattenJson(values);

            for (final String key in flattenedValues.keys) {
              final String prefix = DBKeys.buildPrefix(
                key: key,
                languageCode: normalizedLanguageCode.split('_').first,
                countryCode: normalizedLanguageCode.contains('_') ? normalizedLanguageCode.split('_').last : null,
              );

              result[prefix] = flattenedValues[key];
            }
          }

          debugPrint(
            '--LocalizeAndTranslate - (AssetLoaderNetwork) -- Translated Strings: ${result.length}',
          );
        } else {
          throw Exception(
            '--LocalizeAndTranslate-- Failed to load translations for $normalizedLanguageCode: HTTP ${response.statusCode}',
          );
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

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/src/assets/asset_loader_base.dart';
import 'package:localize_and_translate/src/constants/db_keys.dart';
import 'package:localize_and_translate/src/db/usecases.dart';
import 'package:localize_and_translate/src/models/m_localization.dart';

/// [AssetLoaderNetwork] is the asset loader for root bundle.
/// It loads the assets from the root bundle.
class AssetLoaderNetwork implements AssetLoaderBase {
  /// [AssetLoaderNetwork] constructor
  /// [endPoint] is the path of the json endPoint
  const AssetLoaderNetwork(this.endPoint);

  /// [endPoint] is the path of the json endPoint
  final String endPoint;

  @override
  Future<Map<String, dynamic>> load() async {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const <String, dynamic>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );

    final List<Locale> data = DBUseCases.localesFromDBString(DBUseCases.read(DBKeys.locales));
    final Map<String, dynamic> result = <String, dynamic>{};

    for (final Locale locale in data) {
      final Response<dynamic> response = await dio.get(
        endPoint,
        queryParameters: <String, dynamic>{
          'lang': locale.languageCode,
        },
      );

      MLocalization mLocalization = MLocalization();

      if (response.data is Map<String, dynamic>) {
        mLocalization = MLocalization.fromJson(response.data as Map<String, dynamic>);
      }

      final Map<String, dynamic> newValues = <String, dynamic>{};
      final Map<String, String> flatten = mLocalization.flattenLocalization();

      for (final String key in flatten.keys) {
        newValues[DBKeys.buildPrefix(
          key: key,
          languageCode: locale.languageCode,
          countryCode: locale.countryCode,
        )] = flatten[key];
      }

      result.addAll(newValues);
    }

    debugPrint('--LocalizeAndTranslate-- Translated Strings: ${result.length}');
    return result;
  }
}

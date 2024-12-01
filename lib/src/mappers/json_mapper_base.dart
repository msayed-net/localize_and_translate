/// Base class for JSON mappers.
abstract class JsonMapperBase {
  /// Flattens a nested JSON structure into a single-level map.
  Map<String, dynamic> flattenJson(Map<String, dynamic> json,
      {String parentKey = '', String? separator = '.'});
}

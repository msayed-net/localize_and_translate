/// Helper class to flatten nested JSON structures.
class NestedJsonMapper {
  /// Flattens a nested JSON structure into a single-level map.
  ///
  /// - `json`: The input JSON map.
  /// - `parentKey`: The parent key used for recursive calls (leave empty for the root).
  /// - `separator`: The separator to use between nested keys (default is '.').
  static Map<String, dynamic> flattenJson(Map<String, dynamic> json, {String parentKey = '', String? separator = '.'}) {
    final Map<String, dynamic> flattened = <String, dynamic>{};

    json.forEach((String key, value) {
      final String newKey = parentKey.isNotEmpty ? '$parentKey$separator$key' : key;

      if (value is Map<String, dynamic>) {
        // Recursively flatten nested JSON
        flattened.addAll(flattenJson(value, parentKey: newKey, separator: separator));
      } else {
        flattened[newKey] = value;
      }
    });

    return flattened;
  }
}

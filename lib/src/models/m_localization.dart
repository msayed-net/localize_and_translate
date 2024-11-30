/// [MLocalization] is a model class that represents the localization data.
class MLocalization {
  /// [MLocalization] constructor
  MLocalization({this.screens});

  /// [fromJson] is a factory method that creates a [MLocalization] instance from a JSON object.
  factory MLocalization.fromJson(Map<String, dynamic> json) {
    final Map<String, MLocalizationNode> screens = <String, MLocalizationNode>{};
    json.forEach((String key, dynamic value) {
      if (key != 'version') {
        screens[key] = MLocalizationNode.fromJson(value as Map<String, dynamic>);
      }
    });
    return MLocalization(
      screens: screens,
    );
  }

  /// [flattenLocalization] is a method that flattens the localization data.
  Map<String, String> flattenLocalization() {
    final Map<String, String> flatMap = <String, String>{};

    void flatten(Map<String, MLocalizationNode>? nodes, String parentKey) {
      if (nodes == null) {
        return;
      }

      nodes.forEach((String key, MLocalizationNode node) {
        final String currentKey = parentKey.isEmpty ? key : '$parentKey.$key';

        if (node.title != null) {
          // If it's a leaf, add it to the flat map
          flatMap[currentKey] = node.title!;
        } else if (node.children != null) {
          // If it has children, continue flattening
          flatten(node.children, currentKey);
        }
      });
    }

    flatten(screens, '');
    return flatMap;
  }

  /// [screens] is a map of screen names to their respective [MLocalizationNode].
  final Map<String, MLocalizationNode>? screens;
}

/// [MLocalizationNode] is a model class that represents a node in the localization data.
class MLocalizationNode {
  /// [MLocalizationNode] constructor
  MLocalizationNode({this.title, this.children});

  /// [fromJson] is a factory method that creates a [MLocalizationNode] instance from a JSON object.
  factory MLocalizationNode.fromJson(Map<String, dynamic> json) {
    // Check if the current JSON object has no nested structure
    final bool isLeafNode = json.values.every((dynamic value) => value is String || value is! Map);

    if (isLeafNode) {
      // If all values are non-map types, treat this as a leaf node
      return MLocalizationNode(title: json['title'] as String?);
    }

    // Otherwise, recursively parse children
    final Map<String, MLocalizationNode> children = <String, MLocalizationNode>{};
    json.forEach((String key, dynamic value) {
      if (value is Map<String, dynamic>) {
        children[key] = MLocalizationNode.fromJson(value);
      }
    });

    return MLocalizationNode(children: children);
  }

  /// [isLeaf] is a boolean that indicates if this node is a leaf node.
  bool get isLeaf => title != null;

  /// [title] is the localized string for this node.
  final String? title;

  /// [children] is a map of child nodes.
  final Map<String, MLocalizationNode>? children;
}

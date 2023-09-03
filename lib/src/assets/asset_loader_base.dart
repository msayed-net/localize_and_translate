/// [AssetLoaderBase] abstract class used to building your Custom AssetLoader
/// Example:
/// ```
///class FileAssetLoader extends AssetLoader {
///  @override
///  Future<Map<String, dynamic>> load(String path) async {
///    final file = File(path);
///    return json.decode(await file.readAsString());
///  }
///}
/// ```
abstract class AssetLoaderBase {
  /// [AssetLoaderBase] constructor
  const AssetLoaderBase();

  /// [load] method used to load the json file from the path
  Future<Map<String, dynamic>> load();
}

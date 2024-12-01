/// [ErrorMessages] contains all the error messages used in the app.
class ErrorMessages {
  /// [ErrorMessages] constructor
  factory ErrorMessages() => _instance;
  ErrorMessages._();
  static final ErrorMessages _instance = ErrorMessages._();

  /// [keyNotFound] is the error message when
  static String keyNotFound(String key) => '$key - 404';
}

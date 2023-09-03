/// [ErrorMessages] contains all the error messages used in the app.
class ErrorMessages {
  /// [ErrorMessages] constructor
  factory ErrorMessages() => _instance;
  ErrorMessages._();
  static final ErrorMessages _instance = ErrorMessages._();

  /// [oneOrMoreLocalesOrLanguagesCodesMustBeProvided] is the error message when
  static const String oneOrMoreLocalesOrLanguagesCodesMustBeProvided =
      'Ensure that you provide at least one of the supportedLocales or supportedLanguagesCodes';
}

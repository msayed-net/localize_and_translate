/// [NotFoundException] is thrown when the language code is not found in the
class NotFoundException implements Exception {
  /// [NotFoundException] is thrown when the language code is not found in the
  /// [message] is the message to be shown when the exception is thrown.
  NotFoundException(this.message);

  /// [message] is the message to be shown when the exception is thrown.
  final String message;
}

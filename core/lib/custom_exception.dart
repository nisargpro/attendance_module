class CustomException implements Exception {
  CustomException([this._message, this._prefix]);

  final String? _message;
  final String? _prefix;

  String toString() {
    if (_prefix != null) {
      return '$_prefix$_message';
    }

    return _message ?? '';
  }
}

class FetchDataException extends CustomException {
  FetchDataException(final String message)
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends CustomException {
  BadRequestException(final String message)
      : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(final String message)
      : super(message);
}

class InvalidInputException extends CustomException {
  InvalidInputException(final String message)
      : super(message, 'Invalid Input: ');
}

class NoInternetException extends CustomException {
  NoInternetException() : super('Internet Error', '');
}

class InternalServerException extends CustomException {
  InternalServerException(final String message)
      : super(message, 'Internal Server Error: ');
}

class ApiErrorException extends CustomException {
  ApiErrorException(final String message) : super(message);
}

class NoGpsException extends CustomException {
  NoGpsException(final String message) : super(message);
}

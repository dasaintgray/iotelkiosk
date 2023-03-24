class BaseAppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  BaseAppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends BaseAppException {
  BadRequestException([String? message, String? url]) : super(message, 'Bad Request', url);
}

class FetchDataException extends BaseAppException {
  FetchDataException([String? message, String? url]) : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends BaseAppException {
  ApiNotRespondingException([String? message, String? url]) : super(message, 'Api not responded in time', url);
}

class UnAuthorizedException extends BaseAppException {
  UnAuthorizedException([String? message, String? url]) : super(message, 'UnAuthorized request', url);
}

class AppException implements Exception {
  AppException([this.message, this.url]);

  final String? message;
  final String? url;
}

class BadRequestException extends AppException {
  BadRequestException([super.message, super.url]);
}

class FetchDataException extends AppException {
  FetchDataException([super.message, super.url]);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([super.message, super.url]);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([super.message, super.url]);
}

class ServerErrorException extends AppException {
  ServerErrorException([super.message, super.url]);
}

class RateLimitException extends AppException {
  RateLimitException([super.message, super.url]);
}

class ResourceNotFoundException extends AppException {
  ResourceNotFoundException([super.message, super.url]);
}

class CredentialInvalidException extends AppException {
  CredentialInvalidException([super.message, super.url]);
}

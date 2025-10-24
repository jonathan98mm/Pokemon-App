class RequestFailure {
  RequestFailure({this.statusCode, this.exception, this.data});

  final int? statusCode;
  final Object? exception;
  final Object? data;
}

class NetworkException {}

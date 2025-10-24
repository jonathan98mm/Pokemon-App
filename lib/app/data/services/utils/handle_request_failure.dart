import 'package:pokemon_app/app/data/http/request_failure.dart';
import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';

Either<HttpRequestFailure, R> handleHttpFailure<R>(RequestFailure failure) {
  final error = () {
    final int? statusCode = failure.statusCode;

    switch (statusCode) {
      case 404:
        return HttpRequestFailure.notFound();
    }

    if (failure.exception is NetworkException) {
      return HttpRequestFailure.network();
    }

    return HttpRequestFailure.unknown();
  }();

  return Either.left(error);
}

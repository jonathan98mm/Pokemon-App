import 'package:freezed_annotation/freezed_annotation.dart';

part "http_request_failure.freezed.dart";

@freezed
abstract class HttpRequestFailure with _$HttpRequestFailure {
  factory HttpRequestFailure.notFound() = HttpNotFound;
  factory HttpRequestFailure.network() = HttpFailureNetwork;
  factory HttpRequestFailure.unknown() = HttpFailureUnknown;
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:pokemon_app/app/data/http/request_failure.dart';
import 'package:pokemon_app/app/domain/either/either.dart';

class Http {
  Http({required String baseUrl, required Client client})
    : _client = client,
      _baseUrl = baseUrl;

  final Client _client;
  final String _baseUrl;

  Future<Either<RequestFailure, R>> request<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool useBaseUrl = true,
    String languageCode = "es",
  }) async {
    Map<String, dynamic> logs = {};
    StackTrace? stack;

    try {
      Response? response;
      Uri url = Uri.parse("${useBaseUrl ? _baseUrl : ""}$path");
      headers = {"Content-Type": "application/json", ...headers};

      if (queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters);
      }

      logs = {
        "startTime": DateTime.now().toString(),
        "url": url.toString(),
        "method": method.name,
        "body": body,
      };

      switch (method) {
        case HttpMethod.get:
          response = await _client.get(url, headers: headers);

          break;
        case HttpMethod.post:
          response = await _client.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );

          break;
        case HttpMethod.put:
          response = await _client.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );

          break;
        case HttpMethod.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: jsonEncode(body),
          );

          break;
        case HttpMethod.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: jsonEncode(body),
          );

          break;
      }

      final dynamic responseBody = _parseResponseBody(response.body);

      logs = {
        ...logs,
        "statusCode": response.statusCode,
        "responseBody": responseBody,
      };

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Either.right(onSuccess(responseBody));
      }

      return Either.left(
        RequestFailure(statusCode: response.statusCode, data: responseBody),
      );
    } catch (error, stackTrace) {
      stack = stackTrace;
      logs = {...logs, "exception": error.runtimeType.toString()};

      if (error is SocketException || error is ClientException) {
        logs = {...logs, "exception": "NetworkException"};
        return Either.left(RequestFailure(exception: NetworkException()));
      }

      return Either.left(RequestFailure(exception: error));
    } finally {
      logs = {...logs, "endTime": DateTime.now().toString()};

      //_printLogs(logs, stack);
    }
  }
}

dynamic _parseResponseBody(String responseBody) {
  try {
    return jsonDecode(responseBody);
  } catch (_) {
    return responseBody;
  }
}

void _printLogs(Map<String, dynamic> logs, StackTrace? stackTrace) {
  if (kDebugMode) {
    log('''
:(
---------------------------------
${const JsonEncoder.withIndent("  ").convert(logs)}
---------------------------------
:(
''', stackTrace: stackTrace);
  }
}

enum HttpMethod { get, post, put, delete, patch }

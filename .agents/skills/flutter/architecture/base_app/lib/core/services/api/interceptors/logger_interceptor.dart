import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  String _formatBody(dynamic data) {
    if (data == null) return 'null';
    try {
      if (data is String && data.startsWith('{')) {
        return const JsonEncoder.withIndent('|\t\t')
            .convert(json.decode(data));
      } else if (data is Map || data is List) {
        return const JsonEncoder.withIndent('|\t\t').convert(data);
      }
      return data.toString();
    } catch (e) {
      return data.toString();
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        '''
┌------------------------------------------------------------------------------
| URL: ${options.method} - ${options.path}
| Params: ${options.queryParameters}
| Body:
|\t${options.data == null ? 'None' : _formatBody(options.data)}
└------------------------------------------------------------------------------''',
        name: 'HTTP',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      log(
        '''
┌------------------------------------------------------------------------------
| RESPONSE ${response.statusCode}
| Body:
|\t${_formatBody(response.data)}
└------------------------------------------------------------------------------''',
        name: 'HTTP',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        '''
┌------------------------------------------------------------------------------
| ERROR: ${err.message}
| Status: ${err.response?.statusCode}
└------------------------------------------------------------------------------''',
        name: 'HTTP',
      );
    }
    handler.next(err);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class DioHelper {
  static Dio? _dio;

  static Dio getInstance() {
    // ignore: prefer_conditional_assignment
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ));
      _dio?.interceptors.add(_LoggerInterceptor());
    }
    return _dio!;
  }
}

class _LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '--> [${options.method}] ${options.baseUrl}${options.path}\n'
      'API Headers: ${options.headers}\n'
      'API Params: ${options.queryParameters}\n'
      // 'API Body: ${(options.data as FormData?)?.fields}\n',
      'API Body: ${options.data}\n'
      '==========================================================\n',
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log(
      'RESPONSE[${response.statusCode}] ${response.requestOptions.baseUrl}${response.requestOptions.path}\n'
      '${json.encode(response.data)}\n'
      '==========================================================\n',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.baseUrl}${err.requestOptions.path}\n'
      // 'Body: ${(err.requestOptions.data as FormData?)?.fields}\n'
      'Body: ${err.requestOptions.data}\n'
      '${err.response ?? '(No response)'}\n'
      '==========================================================\n',
    );
    return super.onError(err, handler);
  }
}

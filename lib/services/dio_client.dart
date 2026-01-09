import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio create() {
    // Web pakai localhost/127.0.0.1
    // Android emulator pakai 10.0.2.2
    final baseUrl = kIsWeb
        ? 'http://127.0.0.1:8000/api'
        : 'http://10.0.2.2:8000/api';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(LogInterceptor(responseBody: true));
    return dio;
}
}
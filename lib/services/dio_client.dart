import 'dart:io';
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  // The constructor initializes the engine with all your custom global settings
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: _getBaseUrl(),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          // Expect JSON by default; ApiService expects decoded JSON maps.
          contentType: 'application/json',
          responseType: ResponseType.json,
          headers: {'Accept': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        logPrint: (obj) => print('📡 [DIO] $obj'),
      ),
    );
  }

  static String _getBaseUrl() {
    return 'http://localhost:4000/api';
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  final Dio dio;

  // The constructor initializes the engine with all your custom global settings
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: "http://192.168.100.186:4000/api",
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
    if (kIsWeb) {
      return 'http://127.0.0.1:4000/api';
    }

    // If running on an Android Emulator/Device
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:4000/api';
    }

    // Windows / iOS Simulator / macOS
    return 'http://127.0.0.1:4000/api';
  }
}

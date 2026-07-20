import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_client.dart';
import '../model/user.dart';

class ApiService {
  final DioClient _dioClient;
  final SharedPreferences _prefs;

  ApiService(this._dioClient, this._prefs);

  Future<UserModel> registerBasicInfo({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'fullName': fullName,
        'email': email,
        'password': password,
      };

      final response = await _dioClient.dio.post(
        '/user/signup-step1',
        data: requestData,
      );

      final responseData = response.data;

      // If backend uses { error: '...' } or { message: '...' }
      if (responseData is Map) {
        if (responseData['error'] != null) {
          throw Exception(responseData['error'].toString());
        }
        if (responseData['message'] != null &&
            responseData['success'] != true) {
          throw Exception(responseData['message'].toString());
        }
      }

      final String serverUserId =
          (responseData is Map && (responseData['userId'] != null))
              ? responseData['userId'].toString()
              : '';

      final localUser = UserModel(
        id: serverUserId,
        fullName: fullName,
        email: email,
        isSignupComplete: false,
      );

      await _prefs.setString(
        "cached_user_signup",
        jsonEncode(localUser.toMap()),
      );

      return localUser;
    } on DioException catch (e) {
      // e.response?.data can be a Map or a String depending on server
      String errorMessage = 'Signup failed. Please try again.';
      final data = e.response?.data;
      if (data is Map) {
        if (data['error'] != null) {
          errorMessage = data['error'].toString();
        } else if (data['message'] != null) {
          errorMessage = data['message'].toString();
        }
      } else if (data is String) {
        errorMessage = data;
      }
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> loginAndCheckStatus({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Check local SharedPreferences cache
      final String? cachedUserJson = _prefs.getString("cached_user_signup");

      if (cachedUserJson != null) {
        final Map<String, dynamic> cachedUser = jsonDecode(cachedUserJson);

        if (cachedUser['email'] == email) {
          print("🚀 Fast Login! Loaded from local cache.");
          print(cachedUser);

          if (cachedUser['isSignupComplete'] == false) {
            return {
              "status": "PAYMENT",
              "userId": cachedUser['id'] ?? cachedUser['userId'],
            };
          } else {
            return {"status": "HOME"};
          }
        }
      }

      // 2. Cache missed. Hit the backend
      print("📡 Cache missed. Querying database...");
      final response = await _dioClient.dio.post(
        '/user/login',
        data: {'email': email, 'password': password},
      );

      final responseData = response.data;

      if (responseData is Map && responseData['success'] == true) {
        final userData = responseData['user'];
        final String token = responseData['token'] ?? '';

        await _prefs.setString("jwt_token", token);
        await _prefs.setString("cached_user_signup", jsonEncode(userData));

        if (userData['isSignupComplete'] == false) {
          return {"status": "PAYMENT", "userId": userData['id']};
        } else {
          return {"status": "HOME"};
        }
      } else {
        final msg =
            responseData['error'] ??
            responseData['message'] ??
            'Invalid credentials';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      String errorMessage = 'Connection failed. Please check your backend.';
      if (e.response?.data is Map) {
        errorMessage =
            e.response?.data['error'] ??
            e.response?.data['message'] ??
            errorMessage;
      }
      throw Exception(errorMessage);
    }
  }
}

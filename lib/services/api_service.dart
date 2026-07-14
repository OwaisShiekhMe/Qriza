import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
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
        if (responseData['message'] != null && responseData['success'] != true) {
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
}

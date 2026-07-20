import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qriza/core/providers.dart';
import 'package:qriza/model/user.dart';
import 'package:qriza/model/user_state.dart';
import 'package:qriza/services/api_service.dart';

final userViewModelProvider = NotifierProvider<UserViewModel, UserState>(() {
  return UserViewModel();
});

class UserViewModel extends Notifier<UserState> {
  @override
  UserState build() => UserState();

  ApiService get _apiService => ref.read(apiServiceProvider);

  Future<Map<String, dynamic>> login(String email, String password) async {
    state = state.copyWith(true, null, null);

    try {
      final result = await _apiService.loginAndCheckStatus(
        email: email,
        password: password,
      );

      // extract userr data from api stream
      final Map<String, dynamic> userData = result['user'] ?? result;

      // saving to riverpod for global access
      state = state.copyWith(false, null, userData);

      return {
        "success": true,
        "status": userData['isSignupComplete'] == true ? 'HOME' : 'PAYMENT',
        "userId": userData['id'] ?? userData['userId'],
      };
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      state = state.copyWith(false, msg, null);
      return {"success": false, "error": msg};
    }
  }

  Future<Map<String, dynamic>> registerStepOne(
    String fullName,
    String email,
    String password,
  ) async {
    state = state.copyWith(true, null, null);

    try {
      final UserModel userModel = await _apiService.registerBasicInfo(
        fullName: fullName,
        email: email,
        password: password,
      );

      state = state.copyWith(false, null, null);

      return {"success": true, "userId": userModel.id};
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');

      // Stop loading and publish the error so the UI can react if needed
      state = state.copyWith(false, msg, null);

      return {"success": false, "error": msg};
    }
  }
}

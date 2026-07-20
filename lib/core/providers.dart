import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/dio_client.dart';
import '../services/api_service.dart';

// Shared Preferences Wrapper
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences in main.dart first');
});

// Dio Client Wrapper
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  final prefs = ref.read(sharedPreferencesProvider);
  return ApiService(dioClient, prefs);
});

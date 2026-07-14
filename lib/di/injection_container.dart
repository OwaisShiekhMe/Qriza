import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // 1. Register SharedPreferences as a singleton
  // (We await it here once so it's ready instantly everywhere else)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // 2. Register DioClient as a Lazy Singleton
  // (It won't build until the first time the app actually needs to make a network call)
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // 3. Register ApiService as a Lazy Singleton
  // We use sl<Type>() to automatically pass the dependencies it demands in its constructor!
  sl.registerLazySingleton<ApiService>(
    () => ApiService(sl<DioClient>(), sl<SharedPreferences>()),
  );
}

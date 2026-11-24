import 'package:data/repositories/health_repository_impl.dart';
import 'package:data/services/health_service.dart';
import 'package:dio/dio.dart';
import 'package:domain/repositories/health_repository.dart';
import 'package:get_it/get_it.dart';

// Stratul Data: serviciul Web (Retrofit) și implementarea repository-ului.
// Apelat o singură dată din main(); testele pot da un Dio cu răspunsuri false.
void injectData({Dio? dio}) {
  var getIt = GetIt.instance;

  //init api services
  getIt.registerSingleton<HealthService>(HealthService(dio ?? _createDio()));

  //init repositories
  getIt.registerSingleton<HealthRepository>(HealthRepositoryImpl(healthService: getIt.get<HealthService>()));
}

Dio _createDio() => Dio(
  BaseOptions(
    // Serverul (Render, plan gratuit) poate „dormi” și pornește în ~30-50 s la prima cerere.
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ),
)..interceptors.add(LogInterceptor(requestBody: false, responseBody: false)); // afișează cererile în consolă

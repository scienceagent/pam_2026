import 'package:data/services/health_service.dart';
import 'package:data/mappers/appointment_details_extension.dart';
import 'package:data/mappers/home_extension.dart';
import 'package:dio/dio.dart';
import 'package:domain/entities/appointment_details.dart';
import 'package:domain/entities/home_data.dart';
import 'package:domain/errors/app_exception.dart';
import 'package:domain/repositories/health_repository.dart';

// Implementarea contractului din Domain: cere datele de la serviciul Web (Retrofit), le transformă în entități
// și traduce orice eroare tehnică (rețea, server, JSON greșit) într-o AppException cu mesaj pentru utilizator.
class HealthRepositoryImpl implements HealthRepository {
  HealthRepositoryImpl({required this.healthService});

  final HealthService healthService;

  @override
  Future<HomeData> getHomeFeed() => _guard(() async => (await healthService.getFeed()).toEntity);

  @override
  Future<AppointmentDetails> getAppointmentDetails() =>
      _guard(() async => (await healthService.getFeedDetails()).toEntity);

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw AppException(_messageFor(e));
    } on TypeError {
      // un câmp lipsă sau de alt tip în JSON -> cast-ul din fromJson eșuează
      throw const AppException('The server sent unexpected data.');
    } on FormatException {
      throw const AppException('The server sent unexpected data.');
    }
  }

  static String _messageFor(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => 'The server is taking too long to respond. Please try again.',
    DioExceptionType.connectionError => 'No internet connection.',
    DioExceptionType.badResponse => 'Server error (${e.response?.statusCode}).',
    _ => 'Could not load data. Please try again.',
  };
}

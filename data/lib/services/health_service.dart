import 'package:data/models/appointment_details_model.dart';
import 'package:data/models/home_feed_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'health_service.g.dart';

// Serviciul Web (stratul Data, Retrofit): cererile HTTP sunt descrise prin adnotări,
// iar implementarea _HealthService e generată de build_runner în health_service.g.dart.
@RestApi(baseUrl: 'https://test-api-jlbn.onrender.com')
abstract class HealthService {
  factory HealthService(Dio dio, {String? baseUrl}) = _HealthService;

  // GET https://test-api-jlbn.onrender.com/lab2026/v2/feed
  @GET('/lab2026/v2/feed')
  Future<HomeFeedModel> getFeed();

  // GET https://test-api-jlbn.onrender.com/lab2026/v2/feed/details
  @GET('/lab2026/v2/feed/details')
  Future<AppointmentDetailsModel> getFeedDetails();
}

import 'package:domain/entities/home_data.dart';
import 'package:domain/repositories/health_repository.dart';

// Use case: "ia datele ecranului principal". Controller-ul îl apelează ca pe o funcție: getHomeFeedUseCase().
class GetHomeFeedUseCase {
  GetHomeFeedUseCase({required this.healthRepository});

  final HealthRepository healthRepository;

  Future<HomeData> call() => healthRepository.getHomeFeed();
}
